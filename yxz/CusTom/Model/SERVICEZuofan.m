//
//  SERVICEZuofan.m
//
//  Created by 中杰 赵 on 14/11/28
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "SERVICEZuofan.h"
#import "SERVICEDatas.h"


NSString *const kSERVICEZuofanDatas = @"datas";
NSString *const kSERVICEZuofanId = @"id";
NSString *const kSERVICEZuofanDisPrice = @"dis_price";
NSString *const kSERVICEZuofanPrice = @"price";
NSString *const kSERVICEZuofanKeyword = @"keyword";
NSString *const kSERVICEZuofanDescUrl = @"desc_url";
NSString *const kSERVICEZuofanTips = @"tips";
NSString *const kSERVICEZuofanName = @"name";


@interface SERVICEZuofan ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SERVICEZuofan

@synthesize datas = _datas;
@synthesize zuofanIdentifier = _zuofanIdentifier;
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
    NSObject *receivedSERVICEDatas = [dict objectForKey:kSERVICEZuofanDatas];
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
            self.zuofanIdentifier = [[self objectOrNilForKey:kSERVICEZuofanId fromDictionary:dict] doubleValue];
            self.disPrice = [[self objectOrNilForKey:kSERVICEZuofanDisPrice fromDictionary:dict] doubleValue];
            self.price = [[self objectOrNilForKey:kSERVICEZuofanPrice fromDictionary:dict] doubleValue];
            self.keyword = [self objectOrNilForKey:kSERVICEZuofanKeyword fromDictionary:dict];
            self.descUrl = [self objectOrNilForKey:kSERVICEZuofanDescUrl fromDictionary:dict];
            self.tips = [self objectOrNilForKey:kSERVICEZuofanTips fromDictionary:dict];
            self.name = [self objectOrNilForKey:kSERVICEZuofanName fromDictionary:dict];

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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForDatas] forKey:kSERVICEZuofanDatas];
    [mutableDict setValue:[NSNumber numberWithDouble:self.zuofanIdentifier] forKey:kSERVICEZuofanId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.disPrice] forKey:kSERVICEZuofanDisPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.price] forKey:kSERVICEZuofanPrice];
    [mutableDict setValue:self.keyword forKey:kSERVICEZuofanKeyword];
    [mutableDict setValue:self.descUrl forKey:kSERVICEZuofanDescUrl];
    [mutableDict setValue:self.tips forKey:kSERVICEZuofanTips];
    [mutableDict setValue:self.name forKey:kSERVICEZuofanName];

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

    self.datas = [aDecoder decodeObjectForKey:kSERVICEZuofanDatas];
    self.zuofanIdentifier = [aDecoder decodeDoubleForKey:kSERVICEZuofanId];
    self.disPrice = [aDecoder decodeDoubleForKey:kSERVICEZuofanDisPrice];
    self.price = [aDecoder decodeDoubleForKey:kSERVICEZuofanPrice];
    self.keyword = [aDecoder decodeObjectForKey:kSERVICEZuofanKeyword];
    self.descUrl = [aDecoder decodeObjectForKey:kSERVICEZuofanDescUrl];
    self.tips = [aDecoder decodeObjectForKey:kSERVICEZuofanTips];
    self.name = [aDecoder decodeObjectForKey:kSERVICEZuofanName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_datas forKey:kSERVICEZuofanDatas];
    [aCoder encodeDouble:_zuofanIdentifier forKey:kSERVICEZuofanId];
    [aCoder encodeDouble:_disPrice forKey:kSERVICEZuofanDisPrice];
    [aCoder encodeDouble:_price forKey:kSERVICEZuofanPrice];
    [aCoder encodeObject:_keyword forKey:kSERVICEZuofanKeyword];
    [aCoder encodeObject:_descUrl forKey:kSERVICEZuofanDescUrl];
    [aCoder encodeObject:_tips forKey:kSERVICEZuofanTips];
    [aCoder encodeObject:_name forKey:kSERVICEZuofanName];
}

- (id)copyWithZone:(NSZone *)zone
{
    SERVICEZuofan *copy = [[SERVICEZuofan alloc] init];
    
    if (copy) {

        copy.datas = [self.datas copyWithZone:zone];
        copy.zuofanIdentifier = self.zuofanIdentifier;
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
