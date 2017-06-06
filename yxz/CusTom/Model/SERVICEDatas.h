//
//  SERVICEDatas.h
//
//  Created by 中杰 赵 on 14/11/28
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SERVICEDatas : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double datasIdentifier;
@property (nonatomic, assign) double disPrice;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) double selectType;
@property (nonatomic, strong) NSString *itemUnit;
@property (nonatomic, assign) double serviceType;
@property (nonatomic, strong) NSString *datasDescription;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *itemNum;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
