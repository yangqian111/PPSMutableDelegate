//
//  ViewController.m
//  PPSMutableDelegate
//
//  Created by ppsheep on 2018/2/27.
//  Copyright © 2018年 ppsheep. All rights reserved.
//

#import "ViewController.h"
#import "PPSTestProtocol.h"
#import "PPSManager.h"

@interface ViewController ()<PPSTestProtocol>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[PPSManager sharedManager].mulDelegate addDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
}

- (void)dealloc {
    [[PPSManager sharedManager].mulDelegate removeDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test1 {
    NSThread *thread = [NSThread currentThread];
    NSLog(@"%@",thread);
    NSLog(@"ViewController------test1");
}

- (void)test3WithString:(NSString *)message {
    NSThread *thread = [NSThread currentThread];
    NSLog(@"%@",thread);
    NSLog(@"ViewController------test3WithString----%@",message);
}

- (IBAction)sendMessage:(id)sender {
   
    [[PPSManager sharedManager].mulDelegate test1];
    [[PPSManager sharedManager].mulDelegate test2];
    [[PPSManager sharedManager].mulDelegate test3WithString:@"222"];
}

@end
