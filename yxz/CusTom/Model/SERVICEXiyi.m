//
//  SERVICEXiyi.m
//
//  Created by 中杰 赵 on 14/11/28
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "SERVICEXiyi.h"
#import "SERVICEDatas.h"


NSString *const kSERVICEXiyiDatas = @"datas";
NSString *const kSERVICEXiyiId = @"id";
NSString *const kSERVICEXiyiDisPrice = @"dis_price";
NSString *const kSERVICEXiyiPrice = @"price";
NSString *const kSERVICEXiyiKeyword = @"keyword";
NSString *const kSERVICEXiyiDescUrl = @"desc_url";
NSString *const kSERVICEXiyiTips = @"tips";
NSString *const kSERVICEXiyiName = @"name";


@interface SERVICEXiyi ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SERVICEXiyi

@synthesize datas = _datas;
@synthesize xiyiIdentifier = _xiyiIdentifier;
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
    NSObject *receivedSERVICEDatas = [dict objectForKey:kSERVICEXiyiDatas];
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
            self.xiyiIdentifier = [[self objectOrNilForKey:kSERVICEXiyiId fromDictionary:dict] doubleValue];
            self.disPrice = [[self objectOrNilForKey:kSERVICEXiyiDisPrice fromDictionary:dict] doubleValue];
            self.price = [[self objectOrNilForKey:kSERVICEXiyiPrice fromDictionary:dict] doubleValue];
            self.keyword = [self objectOrNilForKey:kSERVICEXiyiKeyword fromDictionary:dict];
            self.descUrl = [self objectOrNilForKey:kSERVICEXiyiDescUrl fromDictionary:dict];
            self.tips = [self objectOrNilForKey:kSERVICEXiyiTips fromDictionary:dict];
            self.name = [self objectOrNilForKey:kSERVICEXiyiName fromDictionary:dict];

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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForDatas] forKey:kSERVICEXiyiDatas];
    [mutableDict setValue:[NSNumber numberWithDouble:self.xiyiIdentifier] forKey:kSERVICEXiyiId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.disPrice] forKey:kSERVICEXiyiDisPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.price] forKey:kSERVICEXiyiPrice];
    [mutableDict setValue:self.keyword forKey:kSERVICEXiyiKeyword];
    [mutableDict setValue:self.descUrl forKey:kSERVICEXiyiDescUrl];
    [mutableDict setValue:self.tips forKey:kSERVICEXiyiTips];
    [mutableDict setValue:self.name forKey:kSERVICEXiyiName];

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

    self.datas = [aDecoder decodeObjectForKey:kSERVICEXiyiDatas];
    self.xiyiIdentifier = [aDecoder decodeDoubleForKey:kSERVICEXiyiId];
    self.disPrice = [aDecoder decodeDoubleForKey:kSERVICEXiyiDisPrice];
    self.price = [aDecoder decodeDoubleForKey:kSERVICEXiyiPrice];
    self.keyword = [aDecoder decodeObjectForKey:kSERVICEXiyiKeyword];
    self.descUrl = [aDecoder decodeObjectForKey:kSERVICEXiyiDescUrl];
    self.tips = [aDecoder decodeObjectForKey:kSERVICEXiyiTips];
    self.name = [aDecoder decodeObjectForKey:kSERVICEXiyiName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_datas forKey:kSERVICEXiyiDatas];
    [aCoder encodeDouble:_xiyiIdentifier forKey:kSERVICEXiyiId];
    [aCoder encodeDouble:_disPrice forKey:kSERVICEXiyiDisPrice];
    [aCoder encodeDouble:_price forKey:kSERVICEXiyiPrice];
    [aCoder encodeObject:_keyword forKey:kSERVICEXiyiKeyword];
    [aCoder encodeObject:_descUrl forKey:kSERVICEXiyiDescUrl];
    [aCoder encodeObject:_tips forKey:kSERVICEXiyiTips];
    [aCoder encodeObject:_name forKey:kSERVICEXiyiName];
}

- (id)copyWithZone:(NSZone *)zone
{
    SERVICEXiyi *copy = [[SERVICEXiyi alloc] init];
    
    if (copy) {

        copy.datas = [self.datas copyWithZone:zone];
        copy.xiyiIdentifier = self.xiyiIdentifier;
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
