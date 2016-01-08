//
//  SERVICEBaojie.m
//
//  Created by 中杰 赵 on 14/11/28
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "SERVICEBaojie.h"
#import "SERVICEDatas.h"


NSString *const kSERVICEBaojieDatas = @"datas";
NSString *const kSERVICEBaojieId = @"id";
NSString *const kSERVICEBaojieDisPrice = @"dis_price";
NSString *const kSERVICEBaojiePrice = @"price";
NSString *const kSERVICEBaojieKeyword = @"keyword";
NSString *const kSERVICEBaojieDescUrl = @"desc_url";
NSString *const kSERVICEBaojieTips = @"tips";
NSString *const kSERVICEBaojieName = @"name";


@interface SERVICEBaojie ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SERVICEBaojie

@synthesize datas = _datas;
@synthesize baojieIdentifier = _baojieIdentifier;
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
    NSObject *receivedSERVICEDatas = [dict objectForKey:kSERVICEBaojieDatas];
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
            self.baojieIdentifier = [[self objectOrNilForKey:kSERVICEBaojieId fromDictionary:dict] doubleValue];
            self.disPrice = [[self objectOrNilForKey:kSERVICEBaojieDisPrice fromDictionary:dict] doubleValue];
            self.price = [[self objectOrNilForKey:kSERVICEBaojiePrice fromDictionary:dict] doubleValue];
            self.keyword = [self objectOrNilForKey:kSERVICEBaojieKeyword fromDictionary:dict];
            self.descUrl = [self objectOrNilForKey:kSERVICEBaojieDescUrl fromDictionary:dict];
            self.tips = [self objectOrNilForKey:kSERVICEBaojieTips fromDictionary:dict];
            self.name = [self objectOrNilForKey:kSERVICEBaojieName fromDictionary:dict];

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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForDatas] forKey:kSERVICEBaojieDatas];
    [mutableDict setValue:[NSNumber numberWithDouble:self.baojieIdentifier] forKey:kSERVICEBaojieId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.disPrice] forKey:kSERVICEBaojieDisPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.price] forKey:kSERVICEBaojiePrice];
    [mutableDict setValue:self.keyword forKey:kSERVICEBaojieKeyword];
    [mutableDict setValue:self.descUrl forKey:kSERVICEBaojieDescUrl];
    [mutableDict setValue:self.tips forKey:kSERVICEBaojieTips];
    [mutableDict setValue:self.name forKey:kSERVICEBaojieName];

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

    self.datas = [aDecoder decodeObjectForKey:kSERVICEBaojieDatas];
    self.baojieIdentifier = [aDecoder decodeDoubleForKey:kSERVICEBaojieId];
    self.disPrice = [aDecoder decodeDoubleForKey:kSERVICEBaojieDisPrice];
    self.price = [aDecoder decodeDoubleForKey:kSERVICEBaojiePrice];
    self.keyword = [aDecoder decodeObjectForKey:kSERVICEBaojieKeyword];
    self.descUrl = [aDecoder decodeObjectForKey:kSERVICEBaojieDescUrl];
    self.tips = [aDecoder decodeObjectForKey:kSERVICEBaojieTips];
    self.name = [aDecoder decodeObjectForKey:kSERVICEBaojieName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_datas forKey:kSERVICEBaojieDatas];
    [aCoder encodeDouble:_baojieIdentifier forKey:kSERVICEBaojieId];
    [aCoder encodeDouble:_disPrice forKey:kSERVICEBaojieDisPrice];
    [aCoder encodeDouble:_price forKey:kSERVICEBaojiePrice];
    [aCoder encodeObject:_keyword forKey:kSERVICEBaojieKeyword];
    [aCoder encodeObject:_descUrl forKey:kSERVICEBaojieDescUrl];
    [aCoder encodeObject:_tips forKey:kSERVICEBaojieTips];
    [aCoder encodeObject:_name forKey:kSERVICEBaojieName];
}

- (id)copyWithZone:(NSZone *)zone
{
    SERVICEBaojie *copy = [[SERVICEBaojie alloc] init];
    
    if (copy) {

        copy.datas = [self.datas copyWithZone:zone];
        copy.baojieIdentifier = self.baojieIdentifier;
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
