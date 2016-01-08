//
//  ORDERLISTData.h
//
//  Created by 中杰 赵 on 14/12/3
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ORDERLISTData : NSObject /*<NSCoding, NSCopying>*/

@property (nonatomic, assign) id dataIdentifier;
@property (nonatomic, assign) double serviceType;
@property (nonatomic, assign) double updateTime;
@property (nonatomic, assign) id orderMoney;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, assign) double cellId;
@property (nonatomic, assign) double servieDate;
@property (nonatomic, assign) double userId;
@property (nonatomic, assign) double startTime;
@property (nonatomic, assign) double cityId;
@property (nonatomic, assign) double orderFrom;
@property (nonatomic, assign) double addrId;
@property (nonatomic, assign) double orderStatus;
@property (nonatomic, assign) double orderRate;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *orderRateContent;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, assign) double serviceHours;
@property (nonatomic, assign) double addTime;
@property (nonatomic, strong) NSString *addstr;
@property (nonatomic, strong) NSString *cellname;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *service_type_name;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
