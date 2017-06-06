//
//  ORDERDETAILData.h
//
//  Created by 中杰 赵 on 14/12/20
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ORDERDETAILData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double cityId;
@property (nonatomic, assign) id isCancel;
@property (nonatomic, strong) NSString *serviceHour;
@property (nonatomic, assign) double orderStatus;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, assign) double orderMoney;
@property (nonatomic, assign) double payType;
@property (nonatomic, assign) double orderPay;
@property (nonatomic, strong) NSString *sendDatas;
@property (nonatomic, assign) double addrId;
@property (nonatomic, assign) double orderId;
@property (nonatomic, assign) double serviceDate;
@property (nonatomic, assign) double priceHourDiscount;
@property (nonatomic, strong) NSString *orderRateContent;
@property (nonatomic, assign) double addTime;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, assign) double serviceType;
@property (nonatomic, assign) double orderRate;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
