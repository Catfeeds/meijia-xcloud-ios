//
//  SERVICECaboli.m
//
//  Created by 中杰 赵 on 14/11/28
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "SERVICECaboli.h"
#import "SERVICEDatas.h"


NSString *const kSERVICECaboliDatas = @"datas";
NSString *const kSERVICECaboliId = @"id";
NSString *const kSERVICECaboliDisPrice = @"dis_price";
NSString *const kSERVICECaboliPrice = @"price";
NSString *const kSERVICECaboliKeyword = @"keyword";
NSString *const kSERVICECaboliDescUrl = @"desc_url";
NSString *const kSERVICECaboliTips = @"tips";
NSString *const kSERVICECaboliName = @"name";


@interface SERVICECaboli ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SERVICECaboli

@synthesize datas = _datas;
@synthesize caboliIdentifier = _caboliIdentifier;
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
    NSObject *receivedSERVICEDatas = [dict objectForKey:kSERVICECaboliDatas];
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
            self.caboliIdentifier = [[self objectOrNilForKey:kSERVICECaboliId fromDictionary:dict] doubleValue];
            self.disPrice = [[self objectOrNilForKey:kSERVICECaboliDisPrice fromDictionary:dict] doubleValue];
            self.price = [[self objectOrNilForKey:kSERVICECaboliPrice fromDictionary:dict] doubleValue];
            self.keyword = [self objectOrNilForKey:kSERVICECaboliKeyword fromDictionary:dict];
            self.descUrl = [self objectOrNilForKey:kSERVICECaboliDescUrl fromDictionary:dict];
            self.tips = [self objectOrNilForKey:kSERVICECaboliTips fromDictionary:dict];
            self.name = [self objectOrNilForKey:kSERVICECaboliName fromDictionary:dict];

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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForDatas] forKey:kSERVICECaboliDatas];
    [mutableDict setValue:[NSNumber numberWithDouble:self.caboliIdentifier] forKey:kSERVICECaboliId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.disPrice] forKey:kSERVICECaboliDisPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.price] forKey:kSERVICECaboliPrice];
    [mutableDict setValue:self.keyword forKey:kSERVICECaboliKeyword];
    [mutableDict setValue:self.descUrl forKey:kSERVICECaboliDescUrl];
    [mutableDict setValue:self.tips forKey:kSERVICECaboliTips];
    [mutableDict setValue:self.name forKey:kSERVICECaboliName];

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

    self.datas = [aDecoder decodeObjectForKey:kSERVICECaboliDatas];
    self.caboliIdentifier = [aDecoder decodeDoubleForKey:kSERVICECaboliId];
    self.disPrice = [aDecoder decodeDoubleForKey:kSERVICECaboliDisPrice];
    self.price = [aDecoder decodeDoubleForKey:kSERVICECaboliPrice];
    self.keyword = [aDecoder decodeObjectForKey:kSERVICECaboliKeyword];
    self.descUrl = [aDecoder decodeObjectForKey:kSERVICECaboliDescUrl];
    self.tips = [aDecoder decodeObjectForKey:kSERVICECaboliTips];
    self.name = [aDecoder decodeObjectForKey:kSERVICECaboliName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_datas forKey:kSERVICECaboliDatas];
    [aCoder encodeDouble:_caboliIdentifier forKey:kSERVICECaboliId];
    [aCoder encodeDouble:_disPrice forKey:kSERVICECaboliDisPrice];
    [aCoder encodeDouble:_price forKey:kSERVICECaboliPrice];
    [aCoder encodeObject:_keyword forKey:kSERVICECaboliKeyword];
    [aCoder encodeObject:_descUrl forKey:kSERVICECaboliDescUrl];
    [aCoder encodeObject:_tips forKey:kSERVICECaboliTips];
    [aCoder encodeObject:_name forKey:kSERVICECaboliName];
}

- (id)copyWithZone:(NSZone *)zone
{
    SERVICECaboli *copy = [[SERVICECaboli alloc] init];
    
    if (copy) {

        copy.datas = [self.datas copyWithZone:zone];
        copy.caboliIdentifier = self.caboliIdentifier;
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
