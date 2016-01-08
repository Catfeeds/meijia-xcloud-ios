//
//  MyLogInViewController.h
//  simi
//
//  Created by zrj on 15-3-17.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>



@interface MyLogInViewController : FatherViewController

@property (nonatomic, copy) NSString *leiMing;

@property (nonatomic, assign)int vCLID;

@property (nonatomic, retain)TencentOAuth *tencentOAuth;

- (void)ThirdPartyLogSuccessWhitOpenID:(NSString *)openid type:(NSString *)type name:(NSString *)name headImgUrl:(NSString *)imgurl;

@end
