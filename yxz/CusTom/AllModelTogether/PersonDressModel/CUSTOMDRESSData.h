//
//  CUSTOMDRESSData.h
//
//  Created by 中杰 赵 on 14/12/5
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CUSTOMDRESSData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, assign) double updateTime;
@property (nonatomic, assign) double isDefault;
@property (nonatomic, assign) double dataIdentifier;
@property (nonatomic, assign) double cellId;

@property (nonatomic, assign) int poi_type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *uid;


@property (nonatomic, strong) NSString *addrLng;
@property (nonatomic, strong) NSString *addr;
@property (nonatomic, strong) NSString *cellname;
@property (nonatomic, strong) NSString *addrLat;
@property (nonatomic, assign) double userId;
@property (nonatomic, assign) double addTime;
@property (nonatomic, assign) double cityId;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
