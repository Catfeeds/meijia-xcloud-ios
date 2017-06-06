//
//  ALLCITYBaseClass.m
//
//  Created by 中杰 赵 on 14/12/6
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "ALLCITYBaseClass.h"


NSString *const kALLCITYBaseClassCITYId = @"CITY_id";
NSString *const kALLCITYBaseClassCITYOpentime = @"CITY_opentime";
NSString *const kALLCITYBaseClassCITYName = @"CITY_name";
NSString *const kALLCITYBaseClassCITYStoreid = @"CITY_storeid";
NSString *const kALLCITYBaseClassCId = @"C_id";
NSString *const kALLCITYBaseClassCITYDress = @"CITY_dress";


@interface ALLCITYBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ALLCITYBaseClass

@synthesize cITYId = _cITYId;
@synthesize cITYOpentime = _cITYOpentime;
@synthesize cITYName = _cITYName;
@synthesize cITYStoreid = _cITYStoreid;
@synthesize cId = _cId;
@synthesize cITYDress = _cITYDress;


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
            self.cITYId = [[self objectOrNilForKey:kALLCITYBaseClassCITYId fromDictionary:dict] doubleValue];
            self.cITYOpentime = [self objectOrNilForKey:kALLCITYBaseClassCITYOpentime fromDictionary:dict];
            self.cITYName = [self objectOrNilForKey:kALLCITYBaseClassCITYName fromDictionary:dict];
            self.cITYStoreid = [[self objectOrNilForKey:kALLCITYBaseClassCITYStoreid fromDictionary:dict] doubleValue];
            self.cId = [[self objectOrNilForKey:kALLCITYBaseClassCId fromDictionary:dict] doubleValue];
            self.cITYDress = [self objectOrNilForKey:kALLCITYBaseClassCITYDress fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cITYId] forKey:kALLCITYBaseClassCITYId];
    [mutableDict setValue:self.cITYOpentime forKey:kALLCITYBaseClassCITYOpentime];
    [mutableDict setValue:self.cITYName forKey:kALLCITYBaseClassCITYName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cITYStoreid] forKey:kALLCITYBaseClassCITYStoreid];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cId] forKey:kALLCITYBaseClassCId];
    [mutableDict setValue:self.cITYDress forKey:kALLCITYBaseClassCITYDress];

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

    self.cITYId = [aDecoder decodeDoubleForKey:kALLCITYBaseClassCITYId];
    self.cITYOpentime = [aDecoder decodeObjectForKey:kALLCITYBaseClassCITYOpentime];
    self.cITYName = [aDecoder decodeObjectForKey:kALLCITYBaseClassCITYName];
    self.cITYStoreid = [aDecoder decodeDoubleForKey:kALLCITYBaseClassCITYStoreid];
    self.cId = [aDecoder decodeDoubleForKey:kALLCITYBaseClassCId];
    self.cITYDress = [aDecoder decodeObjectForKey:kALLCITYBaseClassCITYDress];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_cITYId forKey:kALLCITYBaseClassCITYId];
    [aCoder encodeObject:_cITYOpentime forKey:kALLCITYBaseClassCITYOpentime];
    [aCoder encodeObject:_cITYName forKey:kALLCITYBaseClassCITYName];
    [aCoder encodeDouble:_cITYStoreid forKey:kALLCITYBaseClassCITYStoreid];
    [aCoder encodeDouble:_cId forKey:kALLCITYBaseClassCId];
    [aCoder encodeObject:_cITYDress forKey:kALLCITYBaseClassCITYDress];
}

- (id)copyWithZone:(NSZone *)zone
{
    ALLCITYBaseClass *copy = [[ALLCITYBaseClass alloc] init];
    
    if (copy) {

        copy.cITYId = self.cITYId;
        copy.cITYOpentime = [self.cITYOpentime copyWithZone:zone];
        copy.cITYName = [self.cITYName copyWithZone:zone];
        copy.cITYStoreid = self.cITYStoreid;
        copy.cId = self.cId;
        copy.cITYDress = [self.cITYDress copyWithZone:zone];
    }
    
    return copy;
}


@end
