//
//  ORDERDETAILData.m
//
//  Created by 中杰 赵 on 14/12/20
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "ORDERDETAILData.h"


NSString *const kORDERDETAILDataCityId = @"city_id";
NSString *const kORDERDETAILDataIsCancel = @"is_cancel";
NSString *const kORDERDETAILDataServiceHour = @"service_hour";
NSString *const kORDERDETAILDataOrderStatus = @"order_status";
NSString *const kORDERDETAILDataOrderNo = @"order_no";
NSString *const kORDERDETAILDataOrderMoney = @"order_money";
NSString *const kORDERDETAILDataPayType = @"pay_type";
NSString *const kORDERDETAILDataOrderPay = @"order_pay";
NSString *const kORDERDETAILDataSendDatas = @"send_datas";
NSString *const kORDERDETAILDataAddrId = @"addr_id";
NSString *const kORDERDETAILDataOrderId = @"order_id";
NSString *const kORDERDETAILDataServiceDate = @"service_date";
NSString *const kORDERDETAILDataPriceHourDiscount = @"price_hour_discount";
NSString *const kORDERDETAILDataOrderRateContent = @"order_rate_content";
NSString *const kORDERDETAILDataAddTime = @"add_time";
NSString *const kORDERDETAILDataMobile = @"mobile";
NSString *const kORDERDETAILDataRemarks = @"remarks";
NSString *const kORDERDETAILDataStartTime = @"start_time";
NSString *const kORDERDETAILDataServiceType = @"service_type";
NSString *const kORDERDETAILDataOrderRate = @"order_rate";


@interface ORDERDETAILData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ORDERDETAILData

@synthesize cityId = _cityId;
@synthesize isCancel = _isCancel;
@synthesize serviceHour = _serviceHour;
@synthesize orderStatus = _orderStatus;
@synthesize orderNo = _orderNo;
@synthesize orderMoney = _orderMoney;
@synthesize payType = _payType;
@synthesize orderPay = _orderPay;
@synthesize sendDatas = _sendDatas;
@synthesize addrId = _addrId;
@synthesize orderId = _orderId;
@synthesize serviceDate = _serviceDate;
@synthesize priceHourDiscount = _priceHourDiscount;
@synthesize orderRateContent = _orderRateContent;
@synthesize addTime = _addTime;
@synthesize mobile = _mobile;
@synthesize remarks = _remarks;
@synthesize startTime = _startTime;
@synthesize serviceType = _serviceType;
@synthesize orderRate = _orderRate;


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
            self.cityId = [[self objectOrNilForKey:kORDERDETAILDataCityId fromDictionary:dict] doubleValue];
            self.isCancel = [self objectOrNilForKey:kORDERDETAILDataIsCancel fromDictionary:dict];
            self.serviceHour = [self objectOrNilForKey:kORDERDETAILDataServiceHour fromDictionary:dict];
            self.orderStatus = [[self objectOrNilForKey:kORDERDETAILDataOrderStatus fromDictionary:dict] doubleValue];
            self.orderNo = [self objectOrNilForKey:kORDERDETAILDataOrderNo fromDictionary:dict];
            self.orderMoney = [[self objectOrNilForKey:kORDERDETAILDataOrderMoney fromDictionary:dict] doubleValue];
            self.payType = [[self objectOrNilForKey:kORDERDETAILDataPayType fromDictionary:dict] doubleValue];
            self.orderPay = [[self objectOrNilForKey:kORDERDETAILDataOrderPay fromDictionary:dict] doubleValue];
            self.sendDatas = [self objectOrNilForKey:kORDERDETAILDataSendDatas fromDictionary:dict];
            self.addrId = [[self objectOrNilForKey:kORDERDETAILDataAddrId fromDictionary:dict] doubleValue];
            self.orderId = [[self objectOrNilForKey:kORDERDETAILDataOrderId fromDictionary:dict] doubleValue];
            self.serviceDate = [[self objectOrNilForKey:kORDERDETAILDataServiceDate fromDictionary:dict] doubleValue];
            self.priceHourDiscount = [[self objectOrNilForKey:kORDERDETAILDataPriceHourDiscount fromDictionary:dict] doubleValue];
            self.orderRateContent = [self objectOrNilForKey:kORDERDETAILDataOrderRateContent fromDictionary:dict];
            self.addTime = [[self objectOrNilForKey:kORDERDETAILDataAddTime fromDictionary:dict] doubleValue];
            self.mobile = [self objectOrNilForKey:kORDERDETAILDataMobile fromDictionary:dict];
            self.remarks = [self objectOrNilForKey:kORDERDETAILDataRemarks fromDictionary:dict];
            self.startTime = [self objectOrNilForKey:kORDERDETAILDataStartTime fromDictionary:dict];
            self.serviceType = [[self objectOrNilForKey:kORDERDETAILDataServiceType fromDictionary:dict] doubleValue];
            self.orderRate = [[self objectOrNilForKey:kORDERDETAILDataOrderRate fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cityId] forKey:kORDERDETAILDataCityId];
    [mutableDict setValue:self.isCancel forKey:kORDERDETAILDataIsCancel];
    [mutableDict setValue:self.serviceHour forKey:kORDERDETAILDataServiceHour];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderStatus] forKey:kORDERDETAILDataOrderStatus];
    [mutableDict setValue:self.orderNo forKey:kORDERDETAILDataOrderNo];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderMoney] forKey:kORDERDETAILDataOrderMoney];
    [mutableDict setValue:[NSNumber numberWithDouble:self.payType] forKey:kORDERDETAILDataPayType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderPay] forKey:kORDERDETAILDataOrderPay];
    [mutableDict setValue:self.sendDatas forKey:kORDERDETAILDataSendDatas];
    [mutableDict setValue:[NSNumber numberWithDouble:self.addrId] forKey:kORDERDETAILDataAddrId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderId] forKey:kORDERDETAILDataOrderId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.serviceDate] forKey:kORDERDETAILDataServiceDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.priceHourDiscount] forKey:kORDERDETAILDataPriceHourDiscount];
    [mutableDict setValue:self.orderRateContent forKey:kORDERDETAILDataOrderRateContent];
    [mutableDict setValue:[NSNumber numberWithDouble:self.addTime] forKey:kORDERDETAILDataAddTime];
    [mutableDict setValue:self.mobile forKey:kORDERDETAILDataMobile];
    [mutableDict setValue:self.remarks forKey:kORDERDETAILDataRemarks];
    [mutableDict setValue:self.startTime forKey:kORDERDETAILDataStartTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.serviceType] forKey:kORDERDETAILDataServiceType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderRate] forKey:kORDERDETAILDataOrderRate];

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

    self.cityId = [aDecoder decodeDoubleForKey:kORDERDETAILDataCityId];
    self.isCancel = [aDecoder decodeObjectForKey:kORDERDETAILDataIsCancel];
    self.serviceHour = [aDecoder decodeObjectForKey:kORDERDETAILDataServiceHour];
    self.orderStatus = [aDecoder decodeDoubleForKey:kORDERDETAILDataOrderStatus];
    self.orderNo = [aDecoder decodeObjectForKey:kORDERDETAILDataOrderNo];
    self.orderMoney = [aDecoder decodeDoubleForKey:kORDERDETAILDataOrderMoney];
    self.payType = [aDecoder decodeDoubleForKey:kORDERDETAILDataPayType];
    self.orderPay = [aDecoder decodeDoubleForKey:kORDERDETAILDataOrderPay];
    self.sendDatas = [aDecoder decodeObjectForKey:kORDERDETAILDataSendDatas];
    self.addrId = [aDecoder decodeDoubleForKey:kORDERDETAILDataAddrId];
    self.orderId = [aDecoder decodeDoubleForKey:kORDERDETAILDataOrderId];
    self.serviceDate = [aDecoder decodeDoubleForKey:kORDERDETAILDataServiceDate];
    self.priceHourDiscount = [aDecoder decodeDoubleForKey:kORDERDETAILDataPriceHourDiscount];
    self.orderRateContent = [aDecoder decodeObjectForKey:kORDERDETAILDataOrderRateContent];
    self.addTime = [aDecoder decodeDoubleForKey:kORDERDETAILDataAddTime];
    self.mobile = [aDecoder decodeObjectForKey:kORDERDETAILDataMobile];
    self.remarks = [aDecoder decodeObjectForKey:kORDERDETAILDataRemarks];
    self.startTime = [aDecoder decodeObjectForKey:kORDERDETAILDataStartTime];
    self.serviceType = [aDecoder decodeDoubleForKey:kORDERDETAILDataServiceType];
    self.orderRate = [aDecoder decodeDoubleForKey:kORDERDETAILDataOrderRate];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_cityId forKey:kORDERDETAILDataCityId];
    [aCoder encodeObject:_isCancel forKey:kORDERDETAILDataIsCancel];
    [aCoder encodeObject:_serviceHour forKey:kORDERDETAILDataServiceHour];
    [aCoder encodeDouble:_orderStatus forKey:kORDERDETAILDataOrderStatus];
    [aCoder encodeObject:_orderNo forKey:kORDERDETAILDataOrderNo];
    [aCoder encodeDouble:_orderMoney forKey:kORDERDETAILDataOrderMoney];
    [aCoder encodeDouble:_payType forKey:kORDERDETAILDataPayType];
    [aCoder encodeDouble:_orderPay forKey:kORDERDETAILDataOrderPay];
    [aCoder encodeObject:_sendDatas forKey:kORDERDETAILDataSendDatas];
    [aCoder encodeDouble:_addrId forKey:kORDERDETAILDataAddrId];
    [aCoder encodeDouble:_orderId forKey:kORDERDETAILDataOrderId];
    [aCoder encodeDouble:_serviceDate forKey:kORDERDETAILDataServiceDate];
    [aCoder encodeDouble:_priceHourDiscount forKey:kORDERDETAILDataPriceHourDiscount];
    [aCoder encodeObject:_orderRateContent forKey:kORDERDETAILDataOrderRateContent];
    [aCoder encodeDouble:_addTime forKey:kORDERDETAILDataAddTime];
    [aCoder encodeObject:_mobile forKey:kORDERDETAILDataMobile];
    [aCoder encodeObject:_remarks forKey:kORDERDETAILDataRemarks];
    [aCoder encodeObject:_startTime forKey:kORDERDETAILDataStartTime];
    [aCoder encodeDouble:_serviceType forKey:kORDERDETAILDataServiceType];
    [aCoder encodeDouble:_orderRate forKey:kORDERDETAILDataOrderRate];
}

- (id)copyWithZone:(NSZone *)zone
{
    ORDERDETAILData *copy = [[ORDERDETAILData alloc] init];
    
    if (copy) {

        copy.cityId = self.cityId;
        copy.isCancel = [self.isCancel copyWithZone:zone];
        copy.serviceHour = [self.serviceHour copyWithZone:zone];
        copy.orderStatus = self.orderStatus;
        copy.orderNo = [self.orderNo copyWithZone:zone];
        copy.orderMoney = self.orderMoney;
        copy.payType = self.payType;
        copy.orderPay = self.orderPay;
        copy.sendDatas = [self.sendDatas copyWithZone:zone];
        copy.addrId = self.addrId;
        copy.orderId = self.orderId;
        copy.serviceDate = self.serviceDate;
        copy.priceHourDiscount = self.priceHourDiscount;
        copy.orderRateContent = [self.orderRateContent copyWithZone:zone];
        copy.addTime = self.addTime;
        copy.mobile = [self.mobile copyWithZone:zone];
        copy.remarks = [self.remarks copyWithZone:zone];
        copy.startTime = [self.startTime copyWithZone:zone];
        copy.serviceType = self.serviceType;
        copy.orderRate = self.orderRate;
    }
    
    return copy;
}


@end
