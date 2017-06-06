//
//  VIPLISTData.h
//
//  Created by 中杰 赵 on 14/12/24
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface VIPLISTData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double addTime;
@property (nonatomic, assign) double dataIdentifier;
@property (nonatomic, assign) double cardPay;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double cardValue;
@property (nonatomic, strong) NSString *dataDescription;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
