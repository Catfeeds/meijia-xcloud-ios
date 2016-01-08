//
//  ORDERDETAILBaseClass.m
//
//  Created by 中杰 赵 on 14/12/20
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "ORDERDETAILBaseClass.h"
#import "ORDERDETAILData.h"


NSString *const kORDERDETAILBaseClassStatus = @"status";
NSString *const kORDERDETAILBaseClassMsg = @"msg";
NSString *const kORDERDETAILBaseClassData = @"data";


@interface ORDERDETAILBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ORDERDETAILBaseClass

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
            self.status = [[self objectOrNilForKey:kORDERDETAILBaseClassStatus fromDictionary:dict] doubleValue];
            self.msg = [self objectOrNilForKey:kORDERDETAILBaseClassMsg fromDictionary:dict];
            self.data = [ORDERDETAILData modelObjectWithDictionary:[dict objectForKey:kORDERDETAILBaseClassData]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kORDERDETAILBaseClassStatus];
    [mutableDict setValue:self.msg forKey:kORDERDETAILBaseClassMsg];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kORDERDETAILBaseClassData];

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

    self.status = [aDecoder decodeDoubleForKey:kORDERDETAILBaseClassStatus];
    self.msg = [aDecoder decodeObjectForKey:kORDERDETAILBaseClassMsg];
    self.data = [aDecoder decodeObjectForKey:kORDERDETAILBaseClassData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_status forKey:kORDERDETAILBaseClassStatus];
    [aCoder encodeObject:_msg forKey:kORDERDETAILBaseClassMsg];
    [aCoder encodeObject:_data forKey:kORDERDETAILBaseClassData];
}

- (id)copyWithZone:(NSZone *)zone
{
    ORDERDETAILBaseClass *copy = [[ORDERDETAILBaseClass alloc] init];
    
    if (copy) {

        copy.status = self.status;
        copy.msg = [self.msg copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
