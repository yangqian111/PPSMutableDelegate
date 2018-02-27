//
//  PPSManager.h
//  PPSMutableDelegate
//
//  Created by ppsheep on 2018/2/27.
//  Copyright © 2018年 ppsheep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPSMutableDelegate.h"
#import "PPSTestProtocol.h"

@interface PPSManager : NSObject

@property (nonatomic, strong) PPSMutableDelegate<PPSTestProtocol> *mulDelegate;

+ (instancetype)sharedManager;

@end
