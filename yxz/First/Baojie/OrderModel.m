//
//  OrderModel.m
//  simi
//
//  Created by zrj on 14-12-18.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "OrderModel.h"

NSString *const KMOBILE = @"mobile";
NSString *const KCITYID = @"city_id";
NSString *const KORDERID = @"order_id";
NSString *const KORDERNO = @"order_no";
NSString *const KORDERMONEY = @"order_money";
NSString *const KORDERPAY = @"order_pay";
NSString *const KPRICEHOUR = @"price_hour";
NSString *const KPRICEHOURDISCOUNT = @"price_hour_discount";
NSString *const KSERVICETYPE = @"service_type";
NSString *const KSENDDATAS = @"send_datas";
NSString *const KSERVICEDATE = @"service_date";
NSString *const KSTARTTIME = @"start_time";
NSString *const KSERVICEHOUR = @"service_hour";
NSString *const KADDRID = @"addr_id";
NSString *const KREMARKS = @"remarks";
NSString *const KADDTIME = @"add_time";

@interface OrderModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OrderModel

@synthesize mobile,city_id,order_id,order_no,order_money,order_pay,price_hour,price_hour_discount,service_type,send_datas,service_date,service_hour,start_time,addr_id,remarks,add_time;


- (instancetype)initWithDictionary:(NSDictionary *)dict{
    
    self = [super init];
    
    self.mobile = [self objectOrNilForKey:KMOBILE fromDictionary:dict];
    self.city_id = [[self objectOrNilForKey:KCITYID fromDictionary:dict] intValue];
    self.order_id = [[self objectOrNilForKey:KORDERID fromDictionary:dict]intValue];
    self.order_no = [self objectOrNilForKey:KORDERNO fromDictionary:dict];
    self.order_money = [[self objectOrNilForKey:KORDERMONEY fromDictionary:dict]doubleValue];
    self.order_pay = [[self objectOrNilForKey:KORDERPAY fromDictionary:dict]doubleValue];
    self.price_hour = [[self objectOrNilForKey:KPRICEHOUR fromDictionary:dict]doubleValue];
    self.price_hour_discount = [[self objectOrNilForKey:KPRICEHOURDISCOUNT fromDictionary:dict]doubleValue];
    self.service_type = [[self objectOrNilForKey:KSERVICETYPE fromDictionary:dict]intValue];
    self.send_datas = [self objectOrNilForKey:KSENDDATAS fromDictionary:dict];
    self.service_date = [[self objectOrNilForKey:KSERVICEDATE fromDictionary:dict] intValue];
    self.service_hour = [self objectOrNilForKey:KSERVICEHOUR fromDictionary:dict];
    self.start_time = [self objectOrNilForKey:KSTARTTIME fromDictionary:dict];
    self.addr_id = [[self objectOrNilForKey:KADDRID fromDictionary:dict] intValue];
    self.remarks = [self objectOrNilForKey:KREMARKS fromDictionary:dict];
    self.add_time = [[self objectOrNilForKey:KADDTIME fromDictionary:dict] intValue];
    
    
    return self;
}


#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


@end
