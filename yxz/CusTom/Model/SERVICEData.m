//
//  SERVICEData.m
//
//  Created by 中杰 赵 on 14/11/28
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "SERVICEData.h"
#import "SERVICEBannerAd.h"
#import "SERVICEServiceTypes.h"


NSString *const kSERVICEDatasimiCall = @"simi_call";
NSString *const kSERVICEDataBannerAd = @"banner_ad";
NSString *const kSERVICEDataServiceCall = @"service_call";
NSString *const kSERVICEDataServiceTypes = @"service_types";


@interface SERVICEData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SERVICEData

@synthesize simiCall = _simiCall;
@synthesize bannerAd = _bannerAd;
@synthesize serviceCall = _serviceCall;
@synthesize serviceTypes = _serviceTypes;


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
            self.simiCall = [self objectOrNilForKey:kSERVICEDatasimiCall fromDictionary:dict];
    NSObject *receivedSERVICEBannerAd = [dict objectForKey:kSERVICEDataBannerAd];
    NSMutableArray *parsedSERVICEBannerAd = [NSMutableArray array];
    if ([receivedSERVICEBannerAd isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedSERVICEBannerAd) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedSERVICEBannerAd addObject:[SERVICEBannerAd modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedSERVICEBannerAd isKindOfClass:[NSDictionary class]]) {
       [parsedSERVICEBannerAd addObject:[SERVICEBannerAd modelObjectWithDictionary:(NSDictionary *)receivedSERVICEBannerAd]];
    }

    self.bannerAd = [NSArray arrayWithArray:parsedSERVICEBannerAd];
            self.serviceCall = [self objectOrNilForKey:kSERVICEDataServiceCall fromDictionary:dict];
            self.serviceTypes = [SERVICEServiceTypes modelObjectWithDictionary:[dict objectForKey:kSERVICEDataServiceTypes]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.simiCall forKey:kSERVICEDatasimiCall];
    NSMutableArray *tempArrayForBannerAd = [NSMutableArray array];
    for (NSObject *subArrayObject in self.bannerAd) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForBannerAd addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForBannerAd addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForBannerAd] forKey:kSERVICEDataBannerAd];
    [mutableDict setValue:self.serviceCall forKey:kSERVICEDataServiceCall];
    [mutableDict setValue:[self.serviceTypes dictionaryRepresentation] forKey:kSERVICEDataServiceTypes];

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

    self.simiCall = [aDecoder decodeObjectForKey:kSERVICEDatasimiCall];
    self.bannerAd = [aDecoder decodeObjectForKey:kSERVICEDataBannerAd];
    self.serviceCall = [aDecoder decodeObjectForKey:kSERVICEDataServiceCall];
    self.serviceTypes = [aDecoder decodeObjectForKey:kSERVICEDataServiceTypes];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_simiCall forKey:kSERVICEDatasimiCall];
    [aCoder encodeObject:_bannerAd forKey:kSERVICEDataBannerAd];
    [aCoder encodeObject:_serviceCall forKey:kSERVICEDataServiceCall];
    [aCoder encodeObject:_serviceTypes forKey:kSERVICEDataServiceTypes];
}

- (id)copyWithZone:(NSZone *)zone
{
    SERVICEData *copy = [[SERVICEData alloc] init];
    
    if (copy) {

        copy.simiCall = [self.simiCall copyWithZone:zone];
        copy.bannerAd = [self.bannerAd copyWithZone:zone];
        copy.serviceCall = [self.serviceCall copyWithZone:zone];
        copy.serviceTypes = [self.serviceTypes copyWithZone:zone];
    }
    
    return copy;
}


@end
