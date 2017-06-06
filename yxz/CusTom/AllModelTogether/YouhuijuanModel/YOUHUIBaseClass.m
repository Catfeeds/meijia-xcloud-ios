//
//  YOUHUIBaseClass.m
//
//  Created by 中杰 赵 on 14/12/23
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "YOUHUIBaseClass.h"
#import "YOUHUIData.h"


NSString *const kYOUHUIBaseClassStatus = @"status";
NSString *const kYOUHUIBaseClassMsg = @"msg";
NSString *const kYOUHUIBaseClassData = @"data";


@interface YOUHUIBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation YOUHUIBaseClass

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
            self.status = [[self objectOrNilForKey:kYOUHUIBaseClassStatus fromDictionary:dict] doubleValue];
            self.msg = [self objectOrNilForKey:kYOUHUIBaseClassMsg fromDictionary:dict];
    NSObject *receivedYOUHUIData = [dict objectForKey:kYOUHUIBaseClassData];
    NSMutableArray *parsedYOUHUIData = [NSMutableArray array];
    if ([receivedYOUHUIData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedYOUHUIData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedYOUHUIData addObject:[YOUHUIData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedYOUHUIData isKindOfClass:[NSDictionary class]]) {
       [parsedYOUHUIData addObject:[YOUHUIData modelObjectWithDictionary:(NSDictionary *)receivedYOUHUIData]];
    }

    self.data = [NSArray arrayWithArray:parsedYOUHUIData];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kYOUHUIBaseClassStatus];
    [mutableDict setValue:self.msg forKey:kYOUHUIBaseClassMsg];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kYOUHUIBaseClassData];

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

    self.status = [aDecoder decodeDoubleForKey:kYOUHUIBaseClassStatus];
    self.msg = [aDecoder decodeObjectForKey:kYOUHUIBaseClassMsg];
    self.data = [aDecoder decodeObjectForKey:kYOUHUIBaseClassData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_status forKey:kYOUHUIBaseClassStatus];
    [aCoder encodeObject:_msg forKey:kYOUHUIBaseClassMsg];
    [aCoder encodeObject:_data forKey:kYOUHUIBaseClassData];
}

- (id)copyWithZone:(NSZone *)zone
{
    YOUHUIBaseClass *copy = [[YOUHUIBaseClass alloc] init];
    
    if (copy) {

        copy.status = self.status;
        copy.msg = [self.msg copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
