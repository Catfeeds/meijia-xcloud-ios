//
//  MyLogInViewController.h
//  simi
//
//  Created by zrj on 15-3-17.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MyLogInViewController : FatherViewController<CLLocationManagerDelegate>
{
    sqlite3 *simi;
}
@property (nonatomic, copy) NSString *leiMing;

@property (nonatomic, assign)int vCLID;

@property (nonatomic, retain)TencentOAuth *tencentOAuth;
@property (nonatomic, strong)NSString*lngString;
@property (nonatomic, strong)NSString*latString;
@property (nonatomic, strong)NSString* cityStr;
@property (nonatomic, strong)NSString* addressName;
- (void)ThirdPartyLogSuccessWhitOpenID:(NSString *)openid type:(NSString *)type name:(NSString *)name headImgUrl:(NSString *)imgurl;

@end
