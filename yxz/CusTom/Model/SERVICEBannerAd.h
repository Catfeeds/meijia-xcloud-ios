//
//  SERVICEBannerAd.h
//
//  Created by 中杰 赵 on 14/11/28
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SERVICEBannerAd : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double updateTime;
@property (nonatomic, assign) double bannerAdIdentifier;
@property (nonatomic, assign) double serviceType;
@property (nonatomic, strong) NSString *gotoUrl;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, assign) double noProperty;
@property (nonatomic, assign) double addTime;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
