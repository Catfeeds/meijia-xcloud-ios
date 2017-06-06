//
//  SERVICEBannerAd.m
//
//  Created by 中杰 赵 on 14/11/28
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "SERVICEBannerAd.h"


NSString *const kSERVICEBannerAdUpdateTime = @"update_time";
NSString *const kSERVICEBannerAdId = @"id";
NSString *const kSERVICEBannerAdServiceType = @"service_type";
NSString *const kSERVICEBannerAdGotoUrl = @"goto_url";
NSString *const kSERVICEBannerAdImgUrl = @"img_url";
NSString *const kSERVICEBannerAdNo = @"no";
NSString *const kSERVICEBannerAdAddTime = @"add_time";


@interface SERVICEBannerAd ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SERVICEBannerAd

@synthesize updateTime = _updateTime;
@synthesize bannerAdIdentifier = _bannerAdIdentifier;
@synthesize serviceType = _serviceType;
@synthesize gotoUrl = _gotoUrl;
@synthesize imgUrl = _imgUrl;
@synthesize noProperty = _noProperty;
@synthesize addTime = _addTime;


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
            self.updateTime = [[self objectOrNilForKey:kSERVICEBannerAdUpdateTime fromDictionary:dict] doubleValue];
            self.bannerAdIdentifier = [[self objectOrNilForKey:kSERVICEBannerAdId fromDictionary:dict] doubleValue];
            self.serviceType = [[self objectOrNilForKey:kSERVICEBannerAdServiceType fromDictionary:dict] doubleValue];
            self.gotoUrl = [self objectOrNilForKey:kSERVICEBannerAdGotoUrl fromDictionary:dict];
            self.imgUrl = [self objectOrNilForKey:kSERVICEBannerAdImgUrl fromDictionary:dict];
            self.noProperty = [[self objectOrNilForKey:kSERVICEBannerAdNo fromDictionary:dict] doubleValue];
            self.addTime = [[self objectOrNilForKey:kSERVICEBannerAdAddTime fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.updateTime] forKey:kSERVICEBannerAdUpdateTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.bannerAdIdentifier] forKey:kSERVICEBannerAdId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.serviceType] forKey:kSERVICEBannerAdServiceType];
    [mutableDict setValue:self.gotoUrl forKey:kSERVICEBannerAdGotoUrl];
    [mutableDict setValue:self.imgUrl forKey:kSERVICEBannerAdImgUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.noProperty] forKey:kSERVICEBannerAdNo];
    [mutableDict setValue:[NSNumber numberWithDouble:self.addTime] forKey:kSERVICEBannerAdAddTime];

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

    self.updateTime = [aDecoder decodeDoubleForKey:kSERVICEBannerAdUpdateTime];
    self.bannerAdIdentifier = [aDecoder decodeDoubleForKey:kSERVICEBannerAdId];
    self.serviceType = [aDecoder decodeDoubleForKey:kSERVICEBannerAdServiceType];
    self.gotoUrl = [aDecoder decodeObjectForKey:kSERVICEBannerAdGotoUrl];
    self.imgUrl = [aDecoder decodeObjectForKey:kSERVICEBannerAdImgUrl];
    self.noProperty = [aDecoder decodeDoubleForKey:kSERVICEBannerAdNo];
    self.addTime = [aDecoder decodeDoubleForKey:kSERVICEBannerAdAddTime];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_updateTime forKey:kSERVICEBannerAdUpdateTime];
    [aCoder encodeDouble:_bannerAdIdentifier forKey:kSERVICEBannerAdId];
    [aCoder encodeDouble:_serviceType forKey:kSERVICEBannerAdServiceType];
    [aCoder encodeObject:_gotoUrl forKey:kSERVICEBannerAdGotoUrl];
    [aCoder encodeObject:_imgUrl forKey:kSERVICEBannerAdImgUrl];
    [aCoder encodeDouble:_noProperty forKey:kSERVICEBannerAdNo];
    [aCoder encodeDouble:_addTime forKey:kSERVICEBannerAdAddTime];
}

- (id)copyWithZone:(NSZone *)zone
{
    SERVICEBannerAd *copy = [[SERVICEBannerAd alloc] init];
    
    if (copy) {

        copy.updateTime = self.updateTime;
        copy.bannerAdIdentifier = self.bannerAdIdentifier;
        copy.serviceType = self.serviceType;
        copy.gotoUrl = [self.gotoUrl copyWithZone:zone];
        copy.imgUrl = [self.imgUrl copyWithZone:zone];
        copy.noProperty = self.noProperty;
        copy.addTime = self.addTime;
    }
    
    return copy;
}


@end
