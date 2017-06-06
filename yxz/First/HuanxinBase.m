//
//  HuanxinBase.m
//  simi
//
//  Created by zrj on 15-3-30.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "HuanxinBase.h"


NSString *const KIMUSERNAME = @"im_username";
NSString *const KIMPASSWORD = @"im_password";
NSString *const KISSENIOR = @"is_senior";
NSString *const KIMSENIORUSERNAME = @"im_senior_username";
NSString *const KIMSENIORNICKNAME = @"im_senior_nickname";
NSString *const KIMROBOTUSERNAME = @"im_robot_username";
NSString *const KIMROBOTNICKNAME = @"im_robot_nickname";

@interface HuanxinBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end



@implementation HuanxinBase

@synthesize imUsername = _imUsername;
@synthesize imUserPassword = _imUserPassword;
@synthesize is_senior = _is_senior;
@synthesize im_senior_nickname = _im_senior_nickname;
@synthesize im_senior_username = _im_senior_username;
@synthesize im_robot_username = _im_robot_username;
@synthesize im_robot_nickname = _im_robot_nickname;



- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {

        
        self.imUsername = [self objectOrNilForKey:KIMUSERNAME fromDictionary:dict];
        self.imUserPassword = [self objectOrNilForKey:KIMPASSWORD fromDictionary:dict];
        self.is_senior = [[self objectOrNilForKey:KISSENIOR fromDictionary:dict] intValue];
        self.im_senior_username = [self objectOrNilForKey:KIMSENIORUSERNAME fromDictionary:dict];
        self.im_senior_nickname = [self objectOrNilForKey:KIMSENIORNICKNAME fromDictionary:dict];
        self.im_robot_username = [self objectOrNilForKey:KIMROBOTUSERNAME fromDictionary:dict];
        self.im_robot_nickname = [self objectOrNilForKey:KIMROBOTNICKNAME fromDictionary:dict];
    }
    

    
    
    return self;
}


#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end
