//
//  PPSTestProtocol.h
//  PPSMutableDelegate
//
//  Created by ppsheep on 2018/2/27.
//  Copyright © 2018年 ppsheep. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PPSTestProtocol <NSObject>

@optional

- (void)test1;

- (void)test2;

- (void)test3WithString:(NSString *)message;

@end
