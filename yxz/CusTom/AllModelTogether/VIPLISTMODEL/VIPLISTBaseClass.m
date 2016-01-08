//
//  VIPLISTBaseClass.m
//
//  Created by 中杰 赵 on 14/12/24
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "VIPLISTBaseClass.h"
#import "VIPLISTData.h"


NSString *const kVIPLISTBaseClassStatus = @"status";
NSString *const kVIPLISTBaseClassMsg = @"msg";
NSString *const kVIPLISTBaseClassData = @"data";


@interface VIPLISTBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation VIPLISTBaseClass

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
            self.status = [[self objectOrNilForKey:kVIPLISTBaseClassStatus fromDictionary:dict] doubleValue];
            self.msg = [self objectOrNilForKey:kVIPLISTBaseClassMsg fromDictionary:dict];
    NSObject *receivedVIPLISTData = [dict objectForKey:kVIPLISTBaseClassData];
    NSMutableArray *parsedVIPLISTData = [NSMutableArray array];
    if ([receivedVIPLISTData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedVIPLISTData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedVIPLISTData addObject:[VIPLISTData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedVIPLISTData isKindOfClass:[NSDictionary class]]) {
       [parsedVIPLISTData addObject:[VIPLISTData modelObjectWithDictionary:(NSDictionary *)receivedVIPLISTData]];
    }

    self.data = [NSArray arrayWithArray:parsedVIPLISTData];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kVIPLISTBaseClassStatus];
    [mutableDict setValue:self.msg forKey:kVIPLISTBaseClassMsg];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kVIPLISTBaseClassData];

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

    self.status = [aDecoder decodeDoubleForKey:kVIPLISTBaseClassStatus];
    self.msg = [aDecoder decodeObjectForKey:kVIPLISTBaseClassMsg];
    self.data = [aDecoder decodeObjectForKey:kVIPLISTBaseClassData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_status forKey:kVIPLISTBaseClassStatus];
    [aCoder encodeObject:_msg forKey:kVIPLISTBaseClassMsg];
    [aCoder encodeObject:_data forKey:kVIPLISTBaseClassData];
}

- (id)copyWithZone:(NSZone *)zone
{
    VIPLISTBaseClass *copy = [[VIPLISTBaseClass alloc] init];
    
    if (copy) {

        copy.status = self.status;
        copy.msg = [self.msg copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
