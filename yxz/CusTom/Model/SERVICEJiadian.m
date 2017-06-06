//
//  SERVICEJiadian.m
//
//  Created by 中杰 赵 on 14/11/28
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "SERVICEJiadian.h"
#import "SERVICEDatas.h"


NSString *const kSERVICEJiadianDatas = @"datas";
NSString *const kSERVICEJiadianId = @"id";
NSString *const kSERVICEJiadianDisPrice = @"dis_price";
NSString *const kSERVICEJiadianPrice = @"price";
NSString *const kSERVICEJiadianKeyword = @"keyword";
NSString *const kSERVICEJiadianDescUrl = @"desc_url";
NSString *const kSERVICEJiadianTips = @"tips";
NSString *const kSERVICEJiadianName = @"name";


@interface SERVICEJiadian ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SERVICEJiadian

@synthesize datas = _datas;
@synthesize jiadianIdentifier = _jiadianIdentifier;
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
    NSObject *receivedSERVICEDatas = [dict objectForKey:kSERVICEJiadianDatas];
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
            self.jiadianIdentifier = [[self objectOrNilForKey:kSERVICEJiadianId fromDictionary:dict] doubleValue];
            self.disPrice = [[self objectOrNilForKey:kSERVICEJiadianDisPrice fromDictionary:dict] doubleValue];
            self.price = [[self objectOrNilForKey:kSERVICEJiadianPrice fromDictionary:dict] doubleValue];
            self.keyword = [self objectOrNilForKey:kSERVICEJiadianKeyword fromDictionary:dict];
            self.descUrl = [self objectOrNilForKey:kSERVICEJiadianDescUrl fromDictionary:dict];
            self.tips = [self objectOrNilForKey:kSERVICEJiadianTips fromDictionary:dict];
            self.name = [self objectOrNilForKey:kSERVICEJiadianName fromDictionary:dict];

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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForDatas] forKey:kSERVICEJiadianDatas];
    [mutableDict setValue:[NSNumber numberWithDouble:self.jiadianIdentifier] forKey:kSERVICEJiadianId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.disPrice] forKey:kSERVICEJiadianDisPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.price] forKey:kSERVICEJiadianPrice];
    [mutableDict setValue:self.keyword forKey:kSERVICEJiadianKeyword];
    [mutableDict setValue:self.descUrl forKey:kSERVICEJiadianDescUrl];
    [mutableDict setValue:self.tips forKey:kSERVICEJiadianTips];
    [mutableDict setValue:self.name forKey:kSERVICEJiadianName];

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

    self.datas = [aDecoder decodeObjectForKey:kSERVICEJiadianDatas];
    self.jiadianIdentifier = [aDecoder decodeDoubleForKey:kSERVICEJiadianId];
    self.disPrice = [aDecoder decodeDoubleForKey:kSERVICEJiadianDisPrice];
    self.price = [aDecoder decodeDoubleForKey:kSERVICEJiadianPrice];
    self.keyword = [aDecoder decodeObjectForKey:kSERVICEJiadianKeyword];
    self.descUrl = [aDecoder decodeObjectForKey:kSERVICEJiadianDescUrl];
    self.tips = [aDecoder decodeObjectForKey:kSERVICEJiadianTips];
    self.name = [aDecoder decodeObjectForKey:kSERVICEJiadianName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_datas forKey:kSERVICEJiadianDatas];
    [aCoder encodeDouble:_jiadianIdentifier forKey:kSERVICEJiadianId];
    [aCoder encodeDouble:_disPrice forKey:kSERVICEJiadianDisPrice];
    [aCoder encodeDouble:_price forKey:kSERVICEJiadianPrice];
    [aCoder encodeObject:_keyword forKey:kSERVICEJiadianKeyword];
    [aCoder encodeObject:_descUrl forKey:kSERVICEJiadianDescUrl];
    [aCoder encodeObject:_tips forKey:kSERVICEJiadianTips];
    [aCoder encodeObject:_name forKey:kSERVICEJiadianName];
}

- (id)copyWithZone:(NSZone *)zone
{
    SERVICEJiadian *copy = [[SERVICEJiadian alloc] init];
    
    if (copy) {

        copy.datas = [self.datas copyWithZone:zone];
        copy.jiadianIdentifier = self.jiadianIdentifier;
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
