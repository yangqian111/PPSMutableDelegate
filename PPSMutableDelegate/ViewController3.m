//
//  ViewController3.m
//  PPSMutableDelegate
//
//  Created by ppsheep on 2018/2/27.
//  Copyright © 2018年 ppsheep. All rights reserved.
//

#import "ViewController3.h"
#import "PPSManager.h"
#import "PPSTestProtocol.h"

@interface ViewController3 ()<PPSTestProtocol>

@end

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    [[PPSManager sharedManager].mulDelegate addDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
}

- (void)dealloc {
    [[PPSManager sharedManager].mulDelegate removeDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
}

- (void)test1 {
    NSLog(@"ViewController3------test1");
}

- (void)test2 {
    NSLog(@"ViewController3------test2");
}

- (IBAction)sendMessager:(id)sender {
    [[PPSManager sharedManager].mulDelegate test1];
    [[PPSManager sharedManager].mulDelegate test2];
    [[PPSManager sharedManager].mulDelegate test3WithString:@"222"];
}

@end
