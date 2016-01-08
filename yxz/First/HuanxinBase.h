//
//  HuanxinBase.h
//  simi
//
//  Created by zrj on 15-3-30.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HuanxinBase : NSObject


@property (nonatomic, strong) NSString *imUsername;  ///环信账号
@property (nonatomic, strong) NSString *imUserPassword;
@property (nonatomic, assign) int is_senior; //是否用机器人   0表示用机器人
@property (nonatomic, strong) NSString *im_senior_username;//真人管家账号
@property (nonatomic, strong) NSString *im_senior_nickname;
@property (nonatomic, strong) NSString *im_robot_username;//机器人管家IM账号
@property (nonatomic, strong) NSString *im_robot_nickname;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
