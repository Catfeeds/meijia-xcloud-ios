//
//  BeiZhuManager.m
//  simi
//
//  Created by zrj on 15-1-5.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "BeiZhuManager.h"

@implementation BeiZhuManager
@synthesize beizhu;

- (id)init
{
    self = [super init];
    if (self) {
        self.beizhu = @"";
    }
    return self;
}

@end
