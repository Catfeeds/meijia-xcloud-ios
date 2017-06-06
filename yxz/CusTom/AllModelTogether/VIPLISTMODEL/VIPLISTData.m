//
//  VIPLISTData.m
//
//  Created by 中杰 赵 on 14/12/24
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "VIPLISTData.h"


NSString *const kVIPLISTDataAddTime = @"add_time";
NSString *const kVIPLISTDataId = @"id";
NSString *const kVIPLISTDataCardPay = @"card_pay";
NSString *const kVIPLISTDataName = @"name";
NSString *const kVIPLISTDataCardValue = @"card_value";
NSString *const kVIPLISTDataDescription = @"description";


@interface VIPLISTData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation VIPLISTData

@synthesize addTime = _addTime;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize cardPay = _cardPay;
@synthesize name = _name;
@synthesize cardValue = _cardValue;
@synthesize dataDescription = _dataDescription;


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
            self.addTime = [[self objectOrNilForKey:kVIPLISTDataAddTime fromDictionary:dict] doubleValue];
            self.dataIdentifier = [[self objectOrNilForKey:kVIPLISTDataId fromDictionary:dict] doubleValue];
            self.cardPay = [[self objectOrNilForKey:kVIPLISTDataCardPay fromDictionary:dict] doubleValue];
            self.name = [self objectOrNilForKey:kVIPLISTDataName fromDictionary:dict];
            self.cardValue = [[self objectOrNilForKey:kVIPLISTDataCardValue fromDictionary:dict] doubleValue];
            self.dataDescription = [self objectOrNilForKey:kVIPLISTDataDescription fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.addTime] forKey:kVIPLISTDataAddTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kVIPLISTDataId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cardPay] forKey:kVIPLISTDataCardPay];
    [mutableDict setValue:self.name forKey:kVIPLISTDataName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cardValue] forKey:kVIPLISTDataCardValue];
    [mutableDict setValue:self.dataDescription forKey:kVIPLISTDataDescription];

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

    self.addTime = [aDecoder decodeDoubleForKey:kVIPLISTDataAddTime];
    self.dataIdentifier = [aDecoder decodeDoubleForKey:kVIPLISTDataId];
    self.cardPay = [aDecoder decodeDoubleForKey:kVIPLISTDataCardPay];
    self.name = [aDecoder decodeObjectForKey:kVIPLISTDataName];
    self.cardValue = [aDecoder decodeDoubleForKey:kVIPLISTDataCardValue];
    self.dataDescription = [aDecoder decodeObjectForKey:kVIPLISTDataDescription];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_addTime forKey:kVIPLISTDataAddTime];
    [aCoder encodeDouble:_dataIdentifier forKey:kVIPLISTDataId];
    [aCoder encodeDouble:_cardPay forKey:kVIPLISTDataCardPay];
    [aCoder encodeObject:_name forKey:kVIPLISTDataName];
    [aCoder encodeDouble:_cardValue forKey:kVIPLISTDataCardValue];
    [aCoder encodeObject:_dataDescription forKey:kVIPLISTDataDescription];
}

- (id)copyWithZone:(NSZone *)zone
{
    VIPLISTData *copy = [[VIPLISTData alloc] init];
    
    if (copy) {

        copy.addTime = self.addTime;
        copy.dataIdentifier = self.dataIdentifier;
        copy.cardPay = self.cardPay;
        copy.name = [self.name copyWithZone:zone];
        copy.cardValue = self.cardValue;
        copy.dataDescription = [self.dataDescription copyWithZone:zone];
    }
    
    return copy;
}


@end
