//
//  SERVICEDatas.m
//
//  Created by 中杰 赵 on 14/11/28
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "SERVICEDatas.h"


NSString *const kSERVICEDatasId = @"id";
NSString *const kSERVICEDatasDisPrice = @"dis_price";
NSString *const kSERVICEDatasPrice = @"price";
NSString *const kSERVICEDatasSelectType = @"select_type";
NSString *const kSERVICEDatasItemUnit = @"item_unit";
NSString *const kSERVICEDatasServiceType = @"service_type";
NSString *const kSERVICEDatasDescription = @"description";
NSString *const kSERVICEDatasName = @"name";
NSString *const kSERVICEBaojieitemnuum = @"item_num";


@interface SERVICEDatas ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SERVICEDatas

@synthesize datasIdentifier = _datasIdentifier;
@synthesize disPrice = _disPrice;
@synthesize price = _price;
@synthesize selectType = _selectType;
@synthesize itemUnit = _itemUnit;
@synthesize serviceType = _serviceType;
@synthesize datasDescription = _datasDescription;
@synthesize name = _name;
@synthesize itemNum = _itemNum;


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
            self.datasIdentifier = [[self objectOrNilForKey:kSERVICEDatasId fromDictionary:dict] doubleValue];
            self.disPrice = [[self objectOrNilForKey:kSERVICEDatasDisPrice fromDictionary:dict] doubleValue];
            self.price = [[self objectOrNilForKey:kSERVICEDatasPrice fromDictionary:dict] doubleValue];
            self.selectType = [[self objectOrNilForKey:kSERVICEDatasSelectType fromDictionary:dict] doubleValue];
            self.itemUnit = [self objectOrNilForKey:kSERVICEDatasItemUnit fromDictionary:dict];
            self.serviceType = [[self objectOrNilForKey:kSERVICEDatasServiceType fromDictionary:dict] doubleValue];
            self.datasDescription = [self objectOrNilForKey:kSERVICEDatasDescription fromDictionary:dict];
            self.name = [self objectOrNilForKey:kSERVICEDatasName fromDictionary:dict];
            self.itemNum = [self objectOrNilForKey:kSERVICEBaojieitemnuum fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.datasIdentifier] forKey:kSERVICEDatasId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.disPrice] forKey:kSERVICEDatasDisPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.price] forKey:kSERVICEDatasPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.selectType] forKey:kSERVICEDatasSelectType];
    [mutableDict setValue:self.itemUnit forKey:kSERVICEDatasItemUnit];
    [mutableDict setValue:[NSNumber numberWithDouble:self.serviceType] forKey:kSERVICEDatasServiceType];
    [mutableDict setValue:self.datasDescription forKey:kSERVICEDatasDescription];
    [mutableDict setValue:self.name forKey:kSERVICEDatasName];
    [mutableDict setValue:self.itemNum forKey:kSERVICEBaojieitemnuum];

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

    self.datasIdentifier = [aDecoder decodeDoubleForKey:kSERVICEDatasId];
    self.disPrice = [aDecoder decodeDoubleForKey:kSERVICEDatasDisPrice];
    self.price = [aDecoder decodeDoubleForKey:kSERVICEDatasPrice];
    self.selectType = [aDecoder decodeDoubleForKey:kSERVICEDatasSelectType];
    self.itemUnit = [aDecoder decodeObjectForKey:kSERVICEDatasItemUnit];
    self.serviceType = [aDecoder decodeDoubleForKey:kSERVICEDatasServiceType];
    self.datasDescription = [aDecoder decodeObjectForKey:kSERVICEDatasDescription];
    self.name = [aDecoder decodeObjectForKey:kSERVICEDatasName];
    self.itemNum = [aDecoder decodeObjectForKey:kSERVICEBaojieitemnuum];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_datasIdentifier forKey:kSERVICEDatasId];
    [aCoder encodeDouble:_disPrice forKey:kSERVICEDatasDisPrice];
    [aCoder encodeDouble:_price forKey:kSERVICEDatasPrice];
    [aCoder encodeDouble:_selectType forKey:kSERVICEDatasSelectType];
    [aCoder encodeObject:_itemUnit forKey:kSERVICEDatasItemUnit];
    [aCoder encodeDouble:_serviceType forKey:kSERVICEDatasServiceType];
    [aCoder encodeObject:_datasDescription forKey:kSERVICEDatasDescription];
    [aCoder encodeObject:_name forKey:kSERVICEDatasName];
    [aCoder encodeObject:_itemNum forKey:kSERVICEBaojieitemnuum];
}

- (id)copyWithZone:(NSZone *)zone
{
    SERVICEDatas *copy = [[SERVICEDatas alloc] init];
    
    if (copy) {

        copy.datasIdentifier = self.datasIdentifier;
        copy.disPrice = self.disPrice;
        copy.price = self.price;
        copy.selectType = self.selectType;
        copy.itemUnit = [self.itemUnit copyWithZone:zone];
        copy.serviceType = self.serviceType;
        copy.datasDescription = [self.datasDescription copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.itemNum = [self.itemNum copyWithZone:zone];
    }
    
    return copy;
}


@end
