//
//  ViewController2.m
//  PPSMutableDelegate
//
//  Created by ppsheep on 2018/2/27.
//  Copyright © 2018年 ppsheep. All rights reserved.
//

#import "ViewController2.h"
#import "PPSManager.h"
#import "PPSTestProtocol.h"

@interface ViewController2 ()<PPSTestProtocol>

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    [[PPSManager sharedManager].mulDelegate addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)dealloc {
    [[PPSManager sharedManager].mulDelegate removeDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)test2 {
    NSLog(@"ViewController2------test2");
}

- (void)test3WithString:(NSString *)message {
    NSLog(@"ViewController2------test3WithString----%@",message);
}
- (IBAction)sendMessage:(id)sender {
    [[PPSManager sharedManager].mulDelegate test1];
    [[PPSManager sharedManager].mulDelegate test2];
    [[PPSManager sharedManager].mulDelegate test3WithString:@"222"];
}

@end
