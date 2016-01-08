//
//  YOUHUIData.m
//
//  Created by 中杰 赵 on 14/12/23
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "YOUHUIData.h"


NSString *const kYOUHUIDataId = @"id";
NSString *const kYOUHUIDataServiceType = @"service_type";
NSString *const kYOUHUIDataDescription = @"description";
NSString *const kYOUHUIDataRangFrom = @"rang_from";
NSString *const kYOUHUIDataExpTime = @"exp_time";
NSString *const kYOUHUIDataMobile = @"mobile";
NSString *const kYOUHUIDataIntroduction = @"introduction";
NSString *const kYOUHUIDataRangeType = @"range_type";
NSString *const kYOUHUIDataUserId = @"user_id";
NSString *const kYOUHUIDataCouponId = @"coupon_id";
NSString *const kYOUHUIDataValue = @"value";
NSString *const kYOUHUIDataIsUsed = @"is_used";
NSString *const kYOUHUIDataCardPasswd = @"card_passwd";
NSString *const kYOUHUIDataUsedTime = @"used_time";
NSString *const kYOUHUIDataAddTime = @"add_time";
NSString *const kYOUHUIDataOrderNo = @"order_no";
NSString *const kYOUHUIDataUpdateTime = @"update_time";


@interface YOUHUIData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation YOUHUIData

@synthesize dataIdentifier = _dataIdentifier;
@synthesize serviceType = _serviceType;
@synthesize dataDescription = _dataDescription;
@synthesize rangFrom = _rangFrom;
@synthesize expTime = _expTime;
@synthesize mobile = _mobile;
@synthesize introduction = _introduction;
@synthesize rangeType = _rangeType;
@synthesize userId = _userId;
@synthesize couponId = _couponId;
@synthesize value = _value;
@synthesize isUsed = _isUsed;
@synthesize cardPasswd = _cardPasswd;
@synthesize usedTime = _usedTime;
@synthesize addTime = _addTime;
@synthesize orderNo = _orderNo;
@synthesize updateTime = _updateTime;


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
            self.dataIdentifier = [[self objectOrNilForKey:kYOUHUIDataId fromDictionary:dict] doubleValue];
            self.serviceType = [self objectOrNilForKey:kYOUHUIDataServiceType fromDictionary:dict];
            self.dataDescription = [self objectOrNilForKey:kYOUHUIDataDescription fromDictionary:dict];
            self.rangFrom = [[self objectOrNilForKey:kYOUHUIDataRangFrom fromDictionary:dict] doubleValue];
            self.expTime = [[self objectOrNilForKey:kYOUHUIDataExpTime fromDictionary:dict] doubleValue];
            self.mobile = [self objectOrNilForKey:kYOUHUIDataMobile fromDictionary:dict];
            self.introduction = [self objectOrNilForKey:kYOUHUIDataIntroduction fromDictionary:dict];
            self.rangeType = [[self objectOrNilForKey:kYOUHUIDataRangeType fromDictionary:dict] doubleValue];
            self.userId = [[self objectOrNilForKey:kYOUHUIDataUserId fromDictionary:dict] doubleValue];
            self.couponId = [[self objectOrNilForKey:kYOUHUIDataCouponId fromDictionary:dict] doubleValue];
            self.value = [[self objectOrNilForKey:kYOUHUIDataValue fromDictionary:dict] doubleValue];
            self.isUsed = [[self objectOrNilForKey:kYOUHUIDataIsUsed fromDictionary:dict] doubleValue];
            self.cardPasswd = [self objectOrNilForKey:kYOUHUIDataCardPasswd fromDictionary:dict];
            self.usedTime = [[self objectOrNilForKey:kYOUHUIDataUsedTime fromDictionary:dict] doubleValue];
            self.addTime = [[self objectOrNilForKey:kYOUHUIDataAddTime fromDictionary:dict] doubleValue];
            self.orderNo = [self objectOrNilForKey:kYOUHUIDataOrderNo fromDictionary:dict];
            self.updateTime = [[self objectOrNilForKey:kYOUHUIDataUpdateTime fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kYOUHUIDataId];
    [mutableDict setValue:self.serviceType forKey:kYOUHUIDataServiceType];
    [mutableDict setValue:self.dataDescription forKey:kYOUHUIDataDescription];
    [mutableDict setValue:[NSNumber numberWithDouble:self.rangFrom] forKey:kYOUHUIDataRangFrom];
    [mutableDict setValue:[NSNumber numberWithDouble:self.expTime] forKey:kYOUHUIDataExpTime];
    [mutableDict setValue:self.mobile forKey:kYOUHUIDataMobile];
    [mutableDict setValue:self.introduction forKey:kYOUHUIDataIntroduction];
    [mutableDict setValue:[NSNumber numberWithDouble:self.rangeType] forKey:kYOUHUIDataRangeType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kYOUHUIDataUserId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.couponId] forKey:kYOUHUIDataCouponId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.value] forKey:kYOUHUIDataValue];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isUsed] forKey:kYOUHUIDataIsUsed];
    [mutableDict setValue:self.cardPasswd forKey:kYOUHUIDataCardPasswd];
    [mutableDict setValue:[NSNumber numberWithDouble:self.usedTime] forKey:kYOUHUIDataUsedTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.addTime] forKey:kYOUHUIDataAddTime];
    [mutableDict setValue:self.orderNo forKey:kYOUHUIDataOrderNo];
    [mutableDict setValue:[NSNumber numberWithDouble:self.updateTime] forKey:kYOUHUIDataUpdateTime];

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


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.dataIdentifier = [aDecoder decodeDoubleForKey:kYOUHUIDataId];
    self.serviceType = [aDecoder decodeObjectForKey:kYOUHUIDataServiceType];
    self.dataDescription = [aDecoder decodeObjectForKey:kYOUHUIDataDescription];
    self.rangFrom = [aDecoder decodeDoubleForKey:kYOUHUIDataRangFrom];
    self.expTime = [aDecoder decodeDoubleForKey:kYOUHUIDataExpTime];
    self.mobile = [aDecoder decodeObjectForKey:kYOUHUIDataMobile];
    self.introduction = [aDecoder decodeObjectForKey:kYOUHUIDataIntroduction];
    self.rangeType = [aDecoder decodeDoubleForKey:kYOUHUIDataRangeType];
    self.userId = [aDecoder decodeDoubleForKey:kYOUHUIDataUserId];
    self.couponId = [aDecoder decodeDoubleForKey:kYOUHUIDataCouponId];
    self.value = [aDecoder decodeDoubleForKey:kYOUHUIDataValue];
    self.isUsed = [aDecoder decodeDoubleForKey:kYOUHUIDataIsUsed];
    self.cardPasswd = [aDecoder decodeObjectForKey:kYOUHUIDataCardPasswd];
    self.usedTime = [aDecoder decodeDoubleForKey:kYOUHUIDataUsedTime];
    self.addTime = [aDecoder decodeDoubleForKey:kYOUHUIDataAddTime];
    self.orderNo = [aDecoder decodeObjectForKey:kYOUHUIDataOrderNo];
    self.updateTime = [aDecoder decodeDoubleForKey:kYOUHUIDataUpdateTime];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_dataIdentifier forKey:kYOUHUIDataId];
    [aCoder encodeObject:_serviceType forKey:kYOUHUIDataServiceType];
    [aCoder encodeObject:_dataDescription forKey:kYOUHUIDataDescription];
    [aCoder encodeDouble:_rangFrom forKey:kYOUHUIDataRangFrom];
    [aCoder encodeDouble:_expTime forKey:kYOUHUIDataExpTime];
    [aCoder encodeObject:_mobile forKey:kYOUHUIDataMobile];
    [aCoder encodeObject:_introduction forKey:kYOUHUIDataIntroduction];
    [aCoder encodeDouble:_rangeType forKey:kYOUHUIDataRangeType];
    [aCoder encodeDouble:_userId forKey:kYOUHUIDataUserId];
    [aCoder encodeDouble:_couponId forKey:kYOUHUIDataCouponId];
    [aCoder encodeDouble:_value forKey:kYOUHUIDataValue];
    [aCoder encodeDouble:_isUsed forKey:kYOUHUIDataIsUsed];
    [aCoder encodeObject:_cardPasswd forKey:kYOUHUIDataCardPasswd];
    [aCoder encodeDouble:_usedTime forKey:kYOUHUIDataUsedTime];
    [aCoder encodeDouble:_addTime forKey:kYOUHUIDataAddTime];
    [aCoder encodeObject:_orderNo forKey:kYOUHUIDataOrderNo];
    [aCoder encodeDouble:_updateTime forKey:kYOUHUIDataUpdateTime];
}

- (id)copyWithZone:(NSZone *)zone
{
    YOUHUIData *copy = [[YOUHUIData alloc] init];
    
    if (copy) {

        copy.dataIdentifier = self.dataIdentifier;
        copy.serviceType = [self.serviceType copyWithZone:zone];
        copy.dataDescription = [self.dataDescription copyWithZone:zone];
        copy.rangFrom = self.rangFrom;
        copy.expTime = self.expTime;
        copy.mobile = [self.mobile copyWithZone:zone];
        copy.introduction = [self.introduction copyWithZone:zone];
        copy.rangeType = self.rangeType;
        copy.userId = self.userId;
        copy.couponId = self.couponId;
        copy.value = self.value;
        copy.isUsed = self.isUsed;
        copy.cardPasswd = [self.cardPasswd copyWithZone:zone];
        copy.usedTime = self.usedTime;
        copy.addTime = self.addTime;
        copy.orderNo = [self.orderNo copyWithZone:zone];
        copy.updateTime = self.updateTime;
    }
    
    return copy;
}


@end
