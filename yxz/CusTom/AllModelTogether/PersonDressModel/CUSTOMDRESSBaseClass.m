//
//  CUSTOMDRESSBaseClass.m
//
//  Created by 中杰 赵 on 14/12/5
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CUSTOMDRESSBaseClass.h"
#import "CUSTOMDRESSData.h"


NSString *const kCUSTOMDRESSBaseClassStatus = @"status";
NSString *const kCUSTOMDRESSBaseClassMsg = @"msg";
NSString *const kCUSTOMDRESSBaseClassData = @"data";


@interface CUSTOMDRESSBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CUSTOMDRESSBaseClass

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
            self.status = [[self objectOrNilForKey:kCUSTOMDRESSBaseClassStatus fromDictionary:dict] doubleValue];
            self.msg = [self objectOrNilForKey:kCUSTOMDRESSBaseClassMsg fromDictionary:dict];
    NSObject *receivedCUSTOMDRESSData = [dict objectForKey:kCUSTOMDRESSBaseClassData];
    NSMutableArray *parsedCUSTOMDRESSData = [NSMutableArray array];
    if ([receivedCUSTOMDRESSData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedCUSTOMDRESSData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedCUSTOMDRESSData addObject:[CUSTOMDRESSData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedCUSTOMDRESSData isKindOfClass:[NSDictionary class]]) {
       [parsedCUSTOMDRESSData addObject:[CUSTOMDRESSData modelObjectWithDictionary:(NSDictionary *)receivedCUSTOMDRESSData]];
    }

    self.data = [NSArray arrayWithArray:parsedCUSTOMDRESSData];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kCUSTOMDRESSBaseClassStatus];
    [mutableDict setValue:self.msg forKey:kCUSTOMDRESSBaseClassMsg];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kCUSTOMDRESSBaseClassData];

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

    self.status = [aDecoder decodeDoubleForKey:kCUSTOMDRESSBaseClassStatus];
    self.msg = [aDecoder decodeObjectForKey:kCUSTOMDRESSBaseClassMsg];
    self.data = [aDecoder decodeObjectForKey:kCUSTOMDRESSBaseClassData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_status forKey:kCUSTOMDRESSBaseClassStatus];
    [aCoder encodeObject:_msg forKey:kCUSTOMDRESSBaseClassMsg];
    [aCoder encodeObject:_data forKey:kCUSTOMDRESSBaseClassData];
}

- (id)copyWithZone:(NSZone *)zone
{
    CUSTOMDRESSBaseClass *copy = [[CUSTOMDRESSBaseClass alloc] init];
    
    if (copy) {

        copy.status = self.status;
        copy.msg = [self.msg copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
