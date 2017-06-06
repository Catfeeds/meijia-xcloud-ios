//
//  ORDERLISTData.m
//
//  Created by 中杰 赵 on 14/12/3
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "ORDERLISTData.h"


NSString *const kORDERLISTDataId = @"id";
NSString *const kORDERLISTDataServiceType = @"service_type";
NSString *const kORDERLISTDataUpdateTime = @"update_time";
NSString *const kORDERLISTDataOrderMoney = @"order_money";
NSString *const kORDERLISTDataMobile = @"mobile";
NSString *const kORDERLISTDataCellId = @"cell_id";
NSString *const kORDERLISTDataServieDate = @"servie_date";
NSString *const kORDERLISTDataUserId = @"user_id";
NSString *const kORDERLISTDataStartTime = @"start_time";
NSString *const kORDERLISTDataCityId = @"city_id";
NSString *const kORDERLISTDataOrderFrom = @"order_from";
NSString *const kORDERLISTDataAddrId = @"addr_id";
NSString *const kORDERLISTDataOrderStatus = @"order_status";
NSString *const kORDERLISTDataOrderRate = @"order_rate";
NSString *const kORDERLISTDataOrderNo = @"order_no";
NSString *const kORDERLISTDataOrderRateContent = @"order_rate_content";
NSString *const kORDERLISTDataRemarks = @"remarks";
NSString *const kORDERLISTDataServiceHours = @"service_hours";
NSString *const kORDERLISTDataAddTime = @"add_time";
NSString *const kORDERLISTDataAddstr = @"addr";
NSString *const kORDERLISTDataCellname = @"cell_name";

@interface ORDERLISTData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ORDERLISTData

@synthesize dataIdentifier = _dataIdentifier;
@synthesize serviceType = _serviceType;
@synthesize updateTime = _updateTime;
@synthesize orderMoney = _orderMoney;
@synthesize mobile = _mobile;
@synthesize cellId = _cellId;
@synthesize servieDate = _servieDate;
@synthesize userId = _userId;
@synthesize startTime = _startTime;
@synthesize cityId = _cityId;
@synthesize orderFrom = _orderFrom;
@synthesize addrId = _addrId;
@synthesize orderStatus = _orderStatus;
@synthesize orderRate = _orderRate;
@synthesize orderNo = _orderNo;
@synthesize orderRateContent = _orderRateContent;
@synthesize remarks = _remarks;
@synthesize serviceHours = _serviceHours;
@synthesize addTime = _addTime;
@synthesize addstr = _addstr;
@synthesize cellname = _cellname,name = _name;
@synthesize service_type_name;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.dataIdentifier = [self objectOrNilForKey:kORDERLISTDataId fromDictionary:dict];
            self.serviceType = [[self objectOrNilForKey:kORDERLISTDataServiceType fromDictionary:dict] doubleValue];
            self.updateTime = [[self objectOrNilForKey:kORDERLISTDataUpdateTime fromDictionary:dict] doubleValue];
            self.orderMoney = [self objectOrNilForKey:kORDERLISTDataOrderMoney fromDictionary:dict];
            self.mobile = [self objectOrNilForKey:kORDERLISTDataMobile fromDictionary:dict];
            self.cellId = [[self objectOrNilForKey:kORDERLISTDataCellId fromDictionary:dict] doubleValue];
            self.servieDate = [[self objectOrNilForKey:kORDERLISTDataServieDate fromDictionary:dict] doubleValue];
            self.userId = [[self objectOrNilForKey:kORDERLISTDataUserId fromDictionary:dict] doubleValue];
            self.startTime = [[self objectOrNilForKey:kORDERLISTDataStartTime fromDictionary:dict] doubleValue];
            self.cityId = [[self objectOrNilForKey:kORDERLISTDataCityId fromDictionary:dict] doubleValue];
            self.orderFrom = [[self objectOrNilForKey:kORDERLISTDataOrderFrom fromDictionary:dict] doubleValue];
            self.addrId = [[self objectOrNilForKey:kORDERLISTDataAddrId fromDictionary:dict] doubleValue];
            self.orderStatus = [[self objectOrNilForKey:kORDERLISTDataOrderStatus fromDictionary:dict] doubleValue];
            self.orderRate = [[self objectOrNilForKey:kORDERLISTDataOrderRate fromDictionary:dict] doubleValue];
            self.orderNo = [self objectOrNilForKey:kORDERLISTDataOrderNo fromDictionary:dict];
            self.orderRateContent = [self objectOrNilForKey:kORDERLISTDataOrderRateContent fromDictionary:dict];
            self.remarks = [self objectOrNilForKey:kORDERLISTDataRemarks fromDictionary:dict];
            self.serviceHours = [[self objectOrNilForKey:kORDERLISTDataServiceHours fromDictionary:dict] doubleValue];
            self.addTime = [[self objectOrNilForKey:kORDERLISTDataAddTime fromDictionary:dict] doubleValue];
            self.addstr = [self objectOrNilForKey:kORDERLISTDataAddstr fromDictionary:dict];
            self.cellname = [self objectOrNilForKey:kORDERLISTDataCellname fromDictionary:dict];

            self.name = [self objectOrNilForKey:@"name" fromDictionary:dict];
        self.service_type_name = [self objectOrNilForKey:@"service_type_name" fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.dataIdentifier forKey:kORDERLISTDataId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.serviceType] forKey:kORDERLISTDataServiceType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.updateTime] forKey:kORDERLISTDataUpdateTime];
    [mutableDict setValue:self.orderMoney forKey:kORDERLISTDataOrderMoney];
    [mutableDict setValue:self.mobile forKey:kORDERLISTDataMobile];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cellId] forKey:kORDERLISTDataCellId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.servieDate] forKey:kORDERLISTDataServieDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kORDERLISTDataUserId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.startTime] forKey:kORDERLISTDataStartTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cityId] forKey:kORDERLISTDataCityId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderFrom] forKey:kORDERLISTDataOrderFrom];
    [mutableDict setValue:[NSNumber numberWithDouble:self.addrId] forKey:kORDERLISTDataAddrId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderStatus] forKey:kORDERLISTDataOrderStatus];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderRate] forKey:kORDERLISTDataOrderRate];
    [mutableDict setValue:self.orderNo forKey:kORDERLISTDataOrderNo];
    [mutableDict setValue:self.orderRateContent forKey:kORDERLISTDataOrderRateContent];
    [mutableDict setValue:self.remarks forKey:kORDERLISTDataRemarks];
    [mutableDict setValue:[NSNumber numberWithDouble:self.serviceHours] forKey:kORDERLISTDataServiceHours];
    [mutableDict setValue:[NSNumber numberWithDouble:self.addTime] forKey:kORDERLISTDataAddTime];
    [mutableDict setValue:self.addstr forKey:kORDERLISTDataAddstr];
    [mutableDict setValue:self.cellname forKey:kORDERLISTDataCellname];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}



@end
