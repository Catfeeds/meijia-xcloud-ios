//
//  SimiOrderDetailModel.m
//  simi
//
//  Created by 高鸿鹏 on 15/6/22.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "SimiOrderDetailModel.h"

@implementation SimiOrderDetailModel
@synthesize
order_no,
order_id,
service_type,
service_type_name,
order_pay_type,
service_content,
service_time,
order_money,
service_addr,
add_time,
service_date,
start_time,
order_status,
remarks;
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        self.order_id = (NSString *)[self objectOrNilForKey:@"id" fromDictionary:dict];
        self.order_no = [self objectOrNilForKey:@"order_no" fromDictionary:dict];
        self.service_type = [self objectOrNilForKey:@"service_type" fromDictionary:dict];
        self.service_type_name = [self objectOrNilForKey:@"service_type_name" fromDictionary:dict];
        self.order_pay_type = [self objectOrNilForKey:@"order_pay_type" fromDictionary:dict];
        self.service_date = [[self objectOrNilForKey:@"add_time" fromDictionary:dict] intValue];
        self.start_time = [[self objectOrNilForKey:@"start_time" fromDictionary:dict] intValue];
        self.service_content = [self objectOrNilForKey:@"service_content" fromDictionary:dict];
        self.order_money = [self objectOrNilForKey:@"order_money" fromDictionary:dict];
        self.order_status = [[self objectOrNilForKey:@"order_status" fromDictionary:dict] intValue];
        self.remarks = [self objectOrNilForKey:@"remarks" fromDictionary:dict];
        
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
