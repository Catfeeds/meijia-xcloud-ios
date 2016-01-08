//
//  SERVICEData.h
//
//  Created by 中杰 赵 on 14/11/28
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SERVICEServiceTypes;

@interface SERVICEData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *simiCall;
@property (nonatomic, strong) NSArray *bannerAd;
@property (nonatomic, strong) NSString *serviceCall;
@property (nonatomic, strong) SERVICEServiceTypes *serviceTypes;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
