//
//  YOUHUIData.h
//
//  Created by 中杰 赵 on 14/12/23
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface YOUHUIData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double dataIdentifier;
@property (nonatomic, strong) NSString *serviceType;
@property (nonatomic, strong) NSString *dataDescription;
@property (nonatomic, assign) double rangFrom;
@property (nonatomic, assign) double expTime;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *introduction;
@property (nonatomic, assign) double rangeType;
@property (nonatomic, assign) double userId;
@property (nonatomic, assign) double couponId;
@property (nonatomic, assign) double value;
@property (nonatomic, assign) double isUsed;
@property (nonatomic, strong) NSString *cardPasswd;
@property (nonatomic, assign) double usedTime;
@property (nonatomic, assign) double addTime;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, assign) double updateTime;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
