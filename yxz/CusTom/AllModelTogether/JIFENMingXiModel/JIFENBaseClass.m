//
//  JIFENBaseClass.m
//
//  Created by 中杰 赵 on 14/12/11
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "JIFENBaseClass.h"
#import "JIFENData.h"


NSString *const kJIFENBaseClassStatus = @"status";
NSString *const kJIFENBaseClassMsg = @"msg";
NSString *const kJIFENBaseClassData = @"data";


@interface JIFENBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation JIFENBaseClass

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
            self.status = [[self objectOrNilForKey:kJIFENBaseClassStatus fromDictionary:dict] doubleValue];
            self.msg = [self objectOrNilForKey:kJIFENBaseClassMsg fromDictionary:dict];
    NSObject *receivedJIFENData = [dict objectForKey:kJIFENBaseClassData];
    NSMutableArray *parsedJIFENData = [NSMutableArray array];
    if ([receivedJIFENData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedJIFENData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedJIFENData addObject:[JIFENData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedJIFENData isKindOfClass:[NSDictionary class]]) {
       [parsedJIFENData addObject:[JIFENData modelObjectWithDictionary:(NSDictionary *)receivedJIFENData]];
    }

    self.data = [NSArray arrayWithArray:parsedJIFENData];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kJIFENBaseClassStatus];
    [mutableDict setValue:self.msg forKey:kJIFENBaseClassMsg];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kJIFENBaseClassData];

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

    self.status = [aDecoder decodeDoubleForKey:kJIFENBaseClassStatus];
    self.msg = [aDecoder decodeObjectForKey:kJIFENBaseClassMsg];
    self.data = [aDecoder decodeObjectForKey:kJIFENBaseClassData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_status forKey:kJIFENBaseClassStatus];
    [aCoder encodeObject:_msg forKey:kJIFENBaseClassMsg];
    [aCoder encodeObject:_data forKey:kJIFENBaseClassData];
}

- (id)copyWithZone:(NSZone *)zone
{
    JIFENBaseClass *copy = [[JIFENBaseClass alloc] init];
    
    if (copy) {

        copy.status = self.status;
        copy.msg = [self.msg copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
