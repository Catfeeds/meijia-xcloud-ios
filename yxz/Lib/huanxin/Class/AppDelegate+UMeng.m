//
//  AppDelegate+UMeng.m
//  ChatDemo-UI2.0
//
//  Created by dujiepeng on 1/6/15.
//  Copyright (c) 2015 dujiepeng. All rights reserved.
//

#import "AppDelegate+UMeng.h"
//#import "MobClick.h"

@implementation AppDelegate (UMeng)

-(void)setupUMeng{
    //友盟
    NSString *bundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    if ([bundleID isEqualToString:@"com.easemob.enterprise.demo.ui"]) {
        UMConfigInstance.appKey = YMAPPKEY;
        UMConfigInstance.token=YMAPPKEY;
        UMConfigInstance.channelId = @"appmarket-main";
//        UMConfigInstance.eSType = E_UM_GAME;
        UMConfigInstance.ePolicy=REALTIMEs;
        [MobClick startWithConfigure:UMConfigInstance];
#if DEBUG
        [MobClick setLogEnabled:YES];
#else
        [MobClick setLogEnabled:NO];
#endif
    }
}

@end
