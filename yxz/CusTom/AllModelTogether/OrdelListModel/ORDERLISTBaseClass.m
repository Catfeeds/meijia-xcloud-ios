//
//  ORDERLISTBaseClass.m
//
//  Created by 中杰 赵 on 14/12/3
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "ORDERLISTBaseClass.h"
#import "ORDERLISTData.h"


NSString *const kORDERLISTBaseClassStatus = @"status";
NSString *const kORDERLISTBaseClassMsg = @"msg";
NSString *const kORDERLISTBaseClassData = @"data";


@interface ORDERLISTBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ORDERLISTBaseClass

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
            self.status = [[self objectOrNilForKey:kORDERLISTBaseClassStatus fromDictionary:dict] doubleValue];
            self.msg = [self objectOrNilForKey:kORDERLISTBaseClassMsg fromDictionary:dict];
    NSObject *receivedORDERLISTData = [dict objectForKey:kORDERLISTBaseClassData];
    NSMutableArray *parsedORDERLISTData = [NSMutableArray array];
    if ([receivedORDERLISTData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedORDERLISTData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedORDERLISTData addObject:[ORDERLISTData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedORDERLISTData isKindOfClass:[NSDictionary class]]) {
       [parsedORDERLISTData addObject:[ORDERLISTData modelObjectWithDictionary:(NSDictionary *)receivedORDERLISTData]];
    }

    self.data = [NSArray arrayWithArray:parsedORDERLISTData];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kORDERLISTBaseClassStatus];
    [mutableDict setValue:self.msg forKey:kORDERLISTBaseClassMsg];
    NSMutableArray *tempArrayForData = [NSMutableArray array];
    for (NSObject *subArrayObject in self.data) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForData addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForData addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kORDERLISTBaseClassData];

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

    self.status = [aDecoder decodeDoubleForKey:kORDERLISTBaseClassStatus];
    self.msg = [aDecoder decodeObjectForKey:kORDERLISTBaseClassMsg];
    self.data = [aDecoder decodeObjectForKey:kORDERLISTBaseClassData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_status forKey:kORDERLISTBaseClassStatus];
    [aCoder encodeObject:_msg forKey:kORDERLISTBaseClassMsg];
    [aCoder encodeObject:_data forKey:kORDERLISTBaseClassData];
}

- (id)copyWithZone:(NSZone *)zone
{
    ORDERLISTBaseClass *copy = [[ORDERLISTBaseClass alloc] init];
    
    if (copy) {

        copy.status = self.status;
        copy.msg = [self.msg copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
