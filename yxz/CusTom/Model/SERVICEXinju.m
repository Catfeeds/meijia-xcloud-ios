//
//  SERVICEXinju.m
//
//  Created by 中杰 赵 on 14/11/28
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "SERVICEXinju.h"
#import "SERVICEDatas.h"


NSString *const kSERVICEXinjuDatas = @"datas";
NSString *const kSERVICEXinjuId = @"id";
NSString *const kSERVICEXinjuDisPrice = @"dis_price";
NSString *const kSERVICEXinjuPrice = @"price";
NSString *const kSERVICEXinjuKeyword = @"keyword";
NSString *const kSERVICEXinjuDescUrl = @"desc_url";
NSString *const kSERVICEXinjuTips = @"tips";
NSString *const kSERVICEXinjuName = @"name";


@interface SERVICEXinju ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SERVICEXinju

@synthesize datas = _datas;
@synthesize xinjuIdentifier = _xinjuIdentifier;
@synthesize disPrice = _disPrice;
@synthesize price = _price;
@synthesize keyword = _keyword;
@synthesize descUrl = _descUrl;
@synthesize tips = _tips;
@synthesize name = _name;


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
    NSObject *receivedSERVICEDatas = [dict objectForKey:kSERVICEXinjuDatas];
    NSMutableArray *parsedSERVICEDatas = [NSMutableArray array];
    if ([receivedSERVICEDatas isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedSERVICEDatas) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedSERVICEDatas addObject:[SERVICEDatas modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedSERVICEDatas isKindOfClass:[NSDictionary class]]) {
       [parsedSERVICEDatas addObject:[SERVICEDatas modelObjectWithDictionary:(NSDictionary *)receivedSERVICEDatas]];
    }

    self.datas = [NSArray arrayWithArray:parsedSERVICEDatas];
            self.xinjuIdentifier = [[self objectOrNilForKey:kSERVICEXinjuId fromDictionary:dict] doubleValue];
            self.disPrice = [[self objectOrNilForKey:kSERVICEXinjuDisPrice fromDictionary:dict] doubleValue];
            self.price = [[self objectOrNilForKey:kSERVICEXinjuPrice fromDictionary:dict] doubleValue];
            self.keyword = [self objectOrNilForKey:kSERVICEXinjuKeyword fromDictionary:dict];
            self.descUrl = [self objectOrNilForKey:kSERVICEXinjuDescUrl fromDictionary:dict];
            self.tips = [self objectOrNilForKey:kSERVICEXinjuTips fromDictionary:dict];
            self.name = [self objectOrNilForKey:kSERVICEXinjuName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForDatas = [NSMutableArray array];
    for (NSObject *subArrayObject in self.datas) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForDatas addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForDatas addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForDatas] forKey:kSERVICEXinjuDatas];
    [mutableDict setValue:[NSNumber numberWithDouble:self.xinjuIdentifier] forKey:kSERVICEXinjuId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.disPrice] forKey:kSERVICEXinjuDisPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.price] forKey:kSERVICEXinjuPrice];
    [mutableDict setValue:self.keyword forKey:kSERVICEXinjuKeyword];
    [mutableDict setValue:self.descUrl forKey:kSERVICEXinjuDescUrl];
    [mutableDict setValue:self.tips forKey:kSERVICEXinjuTips];
    [mutableDict setValue:self.name forKey:kSERVICEXinjuName];

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

    self.datas = [aDecoder decodeObjectForKey:kSERVICEXinjuDatas];
    self.xinjuIdentifier = [aDecoder decodeDoubleForKey:kSERVICEXinjuId];
    self.disPrice = [aDecoder decodeDoubleForKey:kSERVICEXinjuDisPrice];
    self.price = [aDecoder decodeDoubleForKey:kSERVICEXinjuPrice];
    self.keyword = [aDecoder decodeObjectForKey:kSERVICEXinjuKeyword];
    self.descUrl = [aDecoder decodeObjectForKey:kSERVICEXinjuDescUrl];
    self.tips = [aDecoder decodeObjectForKey:kSERVICEXinjuTips];
    self.name = [aDecoder decodeObjectForKey:kSERVICEXinjuName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_datas forKey:kSERVICEXinjuDatas];
    [aCoder encodeDouble:_xinjuIdentifier forKey:kSERVICEXinjuId];
    [aCoder encodeDouble:_disPrice forKey:kSERVICEXinjuDisPrice];
    [aCoder encodeDouble:_price forKey:kSERVICEXinjuPrice];
    [aCoder encodeObject:_keyword forKey:kSERVICEXinjuKeyword];
    [aCoder encodeObject:_descUrl forKey:kSERVICEXinjuDescUrl];
    [aCoder encodeObject:_tips forKey:kSERVICEXinjuTips];
    [aCoder encodeObject:_name forKey:kSERVICEXinjuName];
}

- (id)copyWithZone:(NSZone *)zone
{
    SERVICEXinju *copy = [[SERVICEXinju alloc] init];
    
    if (copy) {

        copy.datas = [self.datas copyWithZone:zone];
        copy.xinjuIdentifier = self.xinjuIdentifier;
        copy.disPrice = self.disPrice;
        copy.price = self.price;
        copy.keyword = [self.keyword copyWithZone:zone];
        copy.descUrl = [self.descUrl copyWithZone:zone];
        copy.tips = [self.tips copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
