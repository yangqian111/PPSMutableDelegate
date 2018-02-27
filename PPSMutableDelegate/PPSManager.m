//
//  PPSManager.m
//  PPSMutableDelegate
//
//  Created by ppsheep on 2018/2/27.
//  Copyright © 2018年 ppsheep. All rights reserved.
//

#import "PPSManager.h"

@implementation PPSManager

static PPSManager * __instance;
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[PPSManager alloc] init];
    });
    return __instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _mulDelegate = (PPSMutableDelegate<PPSTestProtocol> *)[[PPSMutableDelegate alloc] init];
    }
    return self;
}

@end
