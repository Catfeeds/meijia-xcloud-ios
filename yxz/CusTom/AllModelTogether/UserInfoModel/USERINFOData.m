//
//  USERINFOData.m
//
//  Created by 中杰 赵 on 14/12/23
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "USERINFOData.h"


NSString *const kUSERINFODataRestMoney = @"rest_money";
NSString *const kUSERINFODataSeniorRange = @"senior_range";
NSString *const kUSERINFODataMobile = @"mobile";
NSString *const kUSERINFODataUserId = @"user_id";
NSString *const kUSERINFODataScore = @"score";



@interface USERINFOData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation USERINFOData

@synthesize restMoney = _restMoney;
@synthesize seniorRange = _seniorRange;
@synthesize mobile = _mobile;
@synthesize userId = _userId;
@synthesize score = _score;
@synthesize userName,gender;


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
            self.restMoney = [[self objectOrNilForKey:kUSERINFODataRestMoney fromDictionary:dict] doubleValue];
            self.seniorRange = [self objectOrNilForKey:kUSERINFODataSeniorRange fromDictionary:dict];
            self.mobile = [self objectOrNilForKey:kUSERINFODataMobile fromDictionary:dict];
            self.userId = [[self objectOrNilForKey:kUSERINFODataUserId fromDictionary:dict] doubleValue];
            self.score = [[self objectOrNilForKey:kUSERINFODataScore fromDictionary:dict] doubleValue];
        
        self.userName = [self objectOrNilForKey:@"name" fromDictionary:dict];
        self.gender = [self objectOrNilForKey:@"sex" fromDictionary:dict];


    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.restMoney] forKey:kUSERINFODataRestMoney];
    [mutableDict setValue:self.seniorRange forKey:kUSERINFODataSeniorRange];
    [mutableDict setValue:self.mobile forKey:kUSERINFODataMobile];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kUSERINFODataUserId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.score] forKey:kUSERINFODataScore];

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

    self.restMoney = [aDecoder decodeDoubleForKey:kUSERINFODataRestMoney];
    self.seniorRange = [aDecoder decodeObjectForKey:kUSERINFODataSeniorRange];
    self.mobile = [aDecoder decodeObjectForKey:kUSERINFODataMobile];
    self.userId = [aDecoder decodeDoubleForKey:kUSERINFODataUserId];
    self.score = [aDecoder decodeDoubleForKey:kUSERINFODataScore];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_restMoney forKey:kUSERINFODataRestMoney];
    [aCoder encodeObject:_seniorRange forKey:kUSERINFODataSeniorRange];
    [aCoder encodeObject:_mobile forKey:kUSERINFODataMobile];
    [aCoder encodeDouble:_userId forKey:kUSERINFODataUserId];
    [aCoder encodeDouble:_score forKey:kUSERINFODataScore];
}

- (id)copyWithZone:(NSZone *)zone
{
    USERINFOData *copy = [[USERINFOData alloc] init];
    
    if (copy) {

        copy.restMoney = self.restMoney;
        copy.seniorRange = [self.seniorRange copyWithZone:zone];
        copy.mobile = [self.mobile copyWithZone:zone];
        copy.userId = self.userId;
        copy.score = self.score;
    }
    
    return copy;
}


@end
