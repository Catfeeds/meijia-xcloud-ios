//
//  SERVICEGuandao.m
//
//  Created by 中杰 赵 on 14/11/28
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "SERVICEGuandao.h"
#import "SERVICEDatas.h"


NSString *const kSERVICEGuandaoDatas = @"datas";
NSString *const kSERVICEGuandaoId = @"id";
NSString *const kSERVICEGuandaoDisPrice = @"dis_price";
NSString *const kSERVICEGuandaoPrice = @"price";
NSString *const kSERVICEGuandaoKeyword = @"keyword";
NSString *const kSERVICEGuandaoDescUrl = @"desc_url";
NSString *const kSERVICEGuandaoTips = @"tips";
NSString *const kSERVICEGuandaoName = @"name";


@interface SERVICEGuandao ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SERVICEGuandao

@synthesize datas = _datas;
@synthesize guandaoIdentifier = _guandaoIdentifier;
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
    NSObject *receivedSERVICEDatas = [dict objectForKey:kSERVICEGuandaoDatas];
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
            self.guandaoIdentifier = [[self objectOrNilForKey:kSERVICEGuandaoId fromDictionary:dict] doubleValue];
            self.disPrice = [[self objectOrNilForKey:kSERVICEGuandaoDisPrice fromDictionary:dict] doubleValue];
            self.price = [[self objectOrNilForKey:kSERVICEGuandaoPrice fromDictionary:dict] doubleValue];
            self.keyword = [self objectOrNilForKey:kSERVICEGuandaoKeyword fromDictionary:dict];
            self.descUrl = [self objectOrNilForKey:kSERVICEGuandaoDescUrl fromDictionary:dict];
            self.tips = [self objectOrNilForKey:kSERVICEGuandaoTips fromDictionary:dict];
            self.name = [self objectOrNilForKey:kSERVICEGuandaoName fromDictionary:dict];

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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForDatas] forKey:kSERVICEGuandaoDatas];
    [mutableDict setValue:[NSNumber numberWithDouble:self.guandaoIdentifier] forKey:kSERVICEGuandaoId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.disPrice] forKey:kSERVICEGuandaoDisPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.price] forKey:kSERVICEGuandaoPrice];
    [mutableDict setValue:self.keyword forKey:kSERVICEGuandaoKeyword];
    [mutableDict setValue:self.descUrl forKey:kSERVICEGuandaoDescUrl];
    [mutableDict setValue:self.tips forKey:kSERVICEGuandaoTips];
    [mutableDict setValue:self.name forKey:kSERVICEGuandaoName];

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

    self.datas = [aDecoder decodeObjectForKey:kSERVICEGuandaoDatas];
    self.guandaoIdentifier = [aDecoder decodeDoubleForKey:kSERVICEGuandaoId];
    self.disPrice = [aDecoder decodeDoubleForKey:kSERVICEGuandaoDisPrice];
    self.price = [aDecoder decodeDoubleForKey:kSERVICEGuandaoPrice];
    self.keyword = [aDecoder decodeObjectForKey:kSERVICEGuandaoKeyword];
    self.descUrl = [aDecoder decodeObjectForKey:kSERVICEGuandaoDescUrl];
    self.tips = [aDecoder decodeObjectForKey:kSERVICEGuandaoTips];
    self.name = [aDecoder decodeObjectForKey:kSERVICEGuandaoName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_datas forKey:kSERVICEGuandaoDatas];
    [aCoder encodeDouble:_guandaoIdentifier forKey:kSERVICEGuandaoId];
    [aCoder encodeDouble:_disPrice forKey:kSERVICEGuandaoDisPrice];
    [aCoder encodeDouble:_price forKey:kSERVICEGuandaoPrice];
    [aCoder encodeObject:_keyword forKey:kSERVICEGuandaoKeyword];
    [aCoder encodeObject:_descUrl forKey:kSERVICEGuandaoDescUrl];
    [aCoder encodeObject:_tips forKey:kSERVICEGuandaoTips];
    [aCoder encodeObject:_name forKey:kSERVICEGuandaoName];
}

- (id)copyWithZone:(NSZone *)zone
{
    SERVICEGuandao *copy = [[SERVICEGuandao alloc] init];
    
    if (copy) {

        copy.datas = [self.datas copyWithZone:zone];
        copy.guandaoIdentifier = self.guandaoIdentifier;
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
