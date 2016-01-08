//
//  ISLoginManager.m
//  simi
//
//  Created by zrj on 14-11-24.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "ISLoginManager.h"

static ISLoginManager *manager = nil;

@implementation ISLoginManager

+(ISLoginManager *)shareManager
{
    @synchronized(self){
        if (manager == nil) {
            manager = [[super allocWithZone:NULL]init];
        }
    }
    
    return manager;
}
+(id)allocWithZone:(struct _NSZone *)zone
{
    return [[self shareManager]copy];
}
-(id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark 登录状态
- (void)setIsLogin:(BOOL)isLogin
{
    
    if (isLogin != _isLogin) {   //加不加都可以
        _isLogin = isLogin;
    }
    
    
//    _isLogin = isLogin;
}

- (BOOL)isLogin
{
    NSString *_status = [[NSUserDefaults standardUserDefaults]objectForKey:@"islogin"];
    
    NSLog(@"_status is %@",_status);
    
    if ([_status isEqualToString:@"login"]) {
        _isLogin = YES;
    }else{
        _isLogin = NO;
    }
    return  _isLogin;
}

#pragma mark 手机号
- (void)setTelephone:(NSString *)telephone
{
    _telephone = telephone;
    NSLog( @"手机号%@",_telephone);
}

-(NSString *)telephone
{
    NSUserDefaults *mydefaults = [NSUserDefaults standardUserDefaults];
    _telephone = [mydefaults objectForKey:@"telephone"];
    NSLog(@"有没有东西%@",_telephone);
    return _telephone;
}

- (NSString *)listTitle
{
    NSUserDefaults *mydefaults = [NSUserDefaults standardUserDefaults];
    _listTitle = [mydefaults objectForKey:@"listtitle"];
    
    return _listTitle;
}
@end
