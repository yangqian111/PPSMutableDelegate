# 多delegate的使用

一般在我们使用delegate都知道，是一对一的关系。在目前的项目中，有这样一个需求，在服务端收到了一个下发事件，需要在不同的页面，不同的VC都收到此事件，并进行相应的处理。当然这个用RAC实现很简单，但是目前的项目是一个SDK，如果将ReactiveCocoa引入进来，工程会增大很多，这样明显是不合理的，这个时候，就想到了多代理这个思路。其实也是从之前写的proxy代理类的想法而来。

### 实现思路

主要是利用OC的runtime，将一个代理类作为中间类，当收到服务器下发的通知时，通过调用代理类的方法，在代理类中实现消息转发机制，将selector转发给各个代理类。

还是看代码。

首先，我们是将各个代理存在中间类中，这样才能转发到各个代理。

```objc
@interface PPSMutableDelegate : NSObject

- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

- (void)removeDelegate:(id)delegate delegateQueue:(nullable dispatch_queue_t)delegateQueue;

- (void)removeDelegate:(id)delegate;

- (void)removeAllDelegates;

@end
```

在需要监听的delegate中 通过addDelegate将代理添加进去就行，加入queue的目的是为了，在某些收到消息的方法中，需要进行一些异步处理。如果要在主线程中处理，直接放dispatch_get_main_queue()就ok

### 实现


```objc
//代理对象和代理队列持有类
@interface PPSDelegateNode : NSObject

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) dispatch_queue_t delegateQueue;

- (id)initWithDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

@end

@implementation PPSDelegateNode

- (id)initWithDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue {
	self = [super init];
	if (self) {
		_delegate = delegate;
		_delegateQueue = delegateQueue;
	}
	return self;
}

@end

```
这就是一个model类，用来存储一下delegate

在具体的PPSMutableDelegate实现中，用了一个NSMutableArray用来储存delegate 在进行消息转发时，遍历数组 转发出去就行，实现也很简单

在实现消息转发时，主要是通过

```objc
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;
- (void)forwardInvocation:(NSInvocation *)anInvocation;
```

在实现methodSignatureForSelector:方法时，要注意在这个方法中不能返回nil 否则会崩溃的，所以如果delegate中没有找到实现，可以在当前实现一个空的方法

```objc
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	for (PPSDelegateNode *node in self.delegateNodes) {
		id nodeDelegate = node.delegate;
		NSMethodSignature *result = [nodeDelegate methodSignatureForSelector:aSelector];
		if (result != nil) {
			return result;
		}
	}
	return [[self class] instanceMethodSignatureForSelector:@selector(emptyMethod)];
}
```

实现forwardInvocation:

```objc
- (void)forwardInvocation:(NSInvocation *)anInvocation {
	
	SEL selector = [anInvocation selector];
	BOOL foundNilDelegate = NO;
	
	for (PPSDelegateNode *node in self.delegateNodes) {
		id nodeDelegate = node.delegate;
		if ([nodeDelegate respondsToSelector:selector]) {
			dispatch_async(node.delegateQueue, ^{
				[anInvocation invokeWithTarget:nodeDelegate];
			});
		} else if (nodeDelegate == nil) {
			foundNilDelegate = YES;//找到了delegate是空的node 需要移除掉
		}
	}
	
	if (foundNilDelegate) {
		NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
		NSUInteger i = 0;
		for (PPSDelegateNode *node in self.delegateNodes) {
			id nodeDelegate = node.delegate;
			if (nodeDelegate == nil) {
				[indexSet addIndex:i];
			}
			i++;
		}
		[self.delegateNodes removeObjectsAtIndexes:indexSet];
	}
}
```

*注意* 还有一个问题需要注意，要重写当前中间类的doesNotRecognizeSelector:方法，不然如果调用super的这个方法，会造成崩溃