//
//  USERINFOBaseClass.m
//
//  Created by 中杰 赵 on 14/12/23
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "USERINFOBaseClass.h"
#import "USERINFOData.h"


NSString *const kUSERINFOBaseClassStatus = @"status";
NSString *const kUSERINFOBaseClassMsg = @"msg";
NSString *const kUSERINFOBaseClassData = @"data";


@interface USERINFOBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation USERINFOBaseClass

@synthesize status = _status;
@synthesize msg = _msg;
@synthesize data = _data;


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
            self.status = [[self objectOrNilForKey:kUSERINFOBaseClassStatus fromDictionary:dict] doubleValue];
            self.msg = [self objectOrNilForKey:kUSERINFOBaseClassMsg fromDictionary:dict];
            self.data = [USERINFOData modelObjectWithDictionary:[dict objectForKey:kUSERINFOBaseClassData]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kUSERINFOBaseClassStatus];
    [mutableDict setValue:self.msg forKey:kUSERINFOBaseClassMsg];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kUSERINFOBaseClassData];

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

    self.status = [aDecoder decodeDoubleForKey:kUSERINFOBaseClassStatus];
    self.msg = [aDecoder decodeObjectForKey:kUSERINFOBaseClassMsg];
    self.data = [aDecoder decodeObjectForKey:kUSERINFOBaseClassData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_status forKey:kUSERINFOBaseClassStatus];
    [aCoder encodeObject:_msg forKey:kUSERINFOBaseClassMsg];
    [aCoder encodeObject:_data forKey:kUSERINFOBaseClassData];
}

- (id)copyWithZone:(NSZone *)zone
{
    USERINFOBaseClass *copy = [[USERINFOBaseClass alloc] init];
    
    if (copy) {

        copy.status = self.status;
        copy.msg = [self.msg copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
