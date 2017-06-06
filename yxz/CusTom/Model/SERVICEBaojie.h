//
//  SERVICEBaojie.h
//
//  Created by 中杰 赵 on 14/11/28
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SERVICEBaojie : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, assign) double baojieIdentifier;
@property (nonatomic, assign) double disPrice;
@property (nonatomic, assign) double price;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *descUrl;
@property (nonatomic, strong) NSString *tips;
@property (nonatomic, strong) NSString *name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
