//
//  ChatModel.m
//  simi
//
//  Created by 高鸿鹏 on 15/6/19.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "ChatModel.h"

NSString *const ORDER_NO = @"order_no";
NSString *const ORDER_ID = @"order_id";
NSString *const SERVICE_TYPE_NAME = @"service_type_name";
NSString *const ORDER_PAY_TYPE = @"order_pay_type";
NSString *const SERVICE_CONTENT = @"service_content";
NSString *const SERVICE_TIME = @"service_time";
NSString *const ORDER_MONEY = @"order_money";
NSString *const SERVICE_ADDR = @"service_addr";
NSString *const ADD_TIME = @"add_time";

@implementation ChatModel
@synthesize
order_id,
order_no,
service_type_name,
order_pay_type,
service_content,
service_time,
order_money,
service_addr;

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        self.order_id = (NSString *)[self objectOrNilForKey:ORDER_ID fromDictionary:dict];
        self.order_no = (NSString *)[self objectOrNilForKey:ORDER_NO fromDictionary:dict];
        self.service_type_name = (NSString *)[self objectOrNilForKey:SERVICE_TYPE_NAME fromDictionary:dict];
        self.order_pay_type = (NSString *)[self objectOrNilForKey:ORDER_PAY_TYPE fromDictionary:dict];
        self.service_content = (NSString *)[self objectOrNilForKey:SERVICE_CONTENT fromDictionary:dict];
        self.service_time = (NSString *)[self objectOrNilForKey:SERVICE_TIME fromDictionary:dict];
        self.order_money = (NSString *)[self objectOrNilForKey:ORDER_MONEY fromDictionary:dict];
        self.service_addr = (NSString *)[self objectOrNilForKey:SERVICE_ADDR fromDictionary:dict];
        self.add_time = (NSString *)[self objectOrNilForKey:ADD_TIME fromDictionary:dict];
        
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
