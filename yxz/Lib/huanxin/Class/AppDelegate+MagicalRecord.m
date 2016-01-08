//
//  AppDelegate+MagicalRecord.m
//  ChatDemo-UI2.0
//
//  Created by dujiepeng on 1/7/15.
//  Copyright (c) 2015 dujiepeng. All rights reserved.
//

#import "AppDelegate+MagicalRecord.h"

@implementation AppDelegate (MagicalRecord)

-(void)setupUIDemoDB{
    //demo coredata, .pch中有相关头文件引用
    [MagicalRecord setupCoreDataStackWithStoreNamed:[NSString stringWithFormat:@"%@.sqlite", @"UIDemo"]];
}

@end
