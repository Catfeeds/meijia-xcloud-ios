//
//  SIMPLEBaseClass.m
//
//  Created by 中杰 赵 on 14/12/3
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "SIMPLEBaseClass.h"


NSString *const kSIMPLEBaseClassMsg = @"msg";
NSString *const kSIMPLEBaseClassData = @"data";
NSString *const kSIMPLEBaseClassStatus = @"status";


@interface SIMPLEBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SIMPLEBaseClass

@synthesize msg = _msg;
@synthesize data = _data;
@synthesize status = _status;


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
            self.msg = [self objectOrNilForKey:kSIMPLEBaseClassMsg fromDictionary:dict];
            self.data = [self objectOrNilForKey:kSIMPLEBaseClassData fromDictionary:dict];
            self.status = [[self objectOrNilForKey:kSIMPLEBaseClassStatus fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.msg forKey:kSIMPLEBaseClassMsg];
    [mutableDict setValue:self.data forKey:kSIMPLEBaseClassData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kSIMPLEBaseClassStatus];

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

    self.msg = [aDecoder decodeObjectForKey:kSIMPLEBaseClassMsg];
    self.data = [aDecoder decodeObjectForKey:kSIMPLEBaseClassData];
    self.status = [aDecoder decodeDoubleForKey:kSIMPLEBaseClassStatus];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_msg forKey:kSIMPLEBaseClassMsg];
    [aCoder encodeObject:_data forKey:kSIMPLEBaseClassData];
    [aCoder encodeDouble:_status forKey:kSIMPLEBaseClassStatus];
}

- (id)copyWithZone:(NSZone *)zone
{
    SIMPLEBaseClass *copy = [[SIMPLEBaseClass alloc] init];
    
    if (copy) {

        copy.msg = [self.msg copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
        copy.status = self.status;
    }
    
    return copy;
}


@end
