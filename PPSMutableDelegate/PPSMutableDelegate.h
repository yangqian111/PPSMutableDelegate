//
//  PPSMutableDelegate.h
//  APM
//
//  Created by ppsheep on 2018/2/27.
//  Copyright © 2018年 ppsheep. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface PPSMutableDelegate : NSObject

- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

- (void)removeDelegate:(id)delegate delegateQueue:(nullable dispatch_queue_t)delegateQueue;

- (void)removeDelegate:(id)delegate;

- (void)removeAllDelegates;

@end
NS_ASSUME_NONNULL_END
