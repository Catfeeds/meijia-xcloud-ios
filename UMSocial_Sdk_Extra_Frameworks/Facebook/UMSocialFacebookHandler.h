 error: linker command failed with exit code 1 (use -v to see invocation)//
//  UMSocialFacebookHandler.h
//  SocialSDK
//
//  Created by yeahugo on 13-12-23.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMSocialFacebookHandler : NSObject

/**
 设置facebook应用id，和url地址
 
 @param appID facebook应用ID
 @param urlString 分享纯文字用到的url地址
 
 */
+(void)setFacebookAppID:(NSString *)appID shareFacebookWithURL:(NSString *)urlString;
@end
