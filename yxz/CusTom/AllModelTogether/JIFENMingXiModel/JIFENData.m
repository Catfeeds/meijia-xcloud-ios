//
//  JIFENData.m
//
//  Created by 中杰 赵 on 14/12/11
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "JIFENData.h"


NSString *const kJIFENDataMobile = @"mobile";
NSString *const kJIFENDataScore = @"score";
NSString *const kJIFENDataId = @"id";
NSString *const kJIFENDataIsConsume = @"is_consume";
NSString *const kJIFENDataUserId = @"user_id";
NSString *const kJIFENDataActionId = @"action_id";
NSString *const kJIFENDataAddTime = @"add_time";


@interface JIFENData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation JIFENData

@synthesize mobile = _mobile;
@synthesize score = _score;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize isConsume = _isConsume;
@synthesize userId = _userId;
@synthesize actionId = _actionId;
@synthesize addTime = _addTime;


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
            self.mobile = [self objectOrNilForKey:kJIFENDataMobile fromDictionary:dict];
            self.score = [[self objectOrNilForKey:kJIFENDataScore fromDictionary:dict] doubleValue];
            self.dataIdentifier = [[self objectOrNilForKey:kJIFENDataId fromDictionary:dict] doubleValue];
            self.isConsume = [[self objectOrNilForKey:kJIFENDataIsConsume fromDictionary:dict] doubleValue];
            self.userId = [[self objectOrNilForKey:kJIFENDataUserId fromDictionary:dict] doubleValue];
            self.actionId = [[self objectOrNilForKey:kJIFENDataActionId fromDictionary:dict] doubleValue];
            self.addTime = [[self objectOrNilForKey:kJIFENDataAddTime fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.mobile forKey:kJIFENDataMobile];
    [mutableDict setValue:[NSNumber numberWithDouble:self.score] forKey:kJIFENDataScore];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kJIFENDataId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isConsume] forKey:kJIFENDataIsConsume];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kJIFENDataUserId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.actionId] forKey:kJIFENDataActionId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.addTime] forKey:kJIFENDataAddTime];

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

    self.mobile = [aDecoder decodeObjectForKey:kJIFENDataMobile];
    self.score = [aDecoder decodeDoubleForKey:kJIFENDataScore];
    self.dataIdentifier = [aDecoder decodeDoubleForKey:kJIFENDataId];
    self.isConsume = [aDecoder decodeDoubleForKey:kJIFENDataIsConsume];
    self.userId = [aDecoder decodeDoubleForKey:kJIFENDataUserId];
    self.actionId = [aDecoder decodeDoubleForKey:kJIFENDataActionId];
    self.addTime = [aDecoder decodeDoubleForKey:kJIFENDataAddTime];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_mobile forKey:kJIFENDataMobile];
    [aCoder encodeDouble:_score forKey:kJIFENDataScore];
    [aCoder encodeDouble:_dataIdentifier forKey:kJIFENDataId];
    [aCoder encodeDouble:_isConsume forKey:kJIFENDataIsConsume];
    [aCoder encodeDouble:_userId forKey:kJIFENDataUserId];
    [aCoder encodeDouble:_actionId forKey:kJIFENDataActionId];
    [aCoder encodeDouble:_addTime forKey:kJIFENDataAddTime];
}

- (id)copyWithZone:(NSZone *)zone
{
    JIFENData *copy = [[JIFENData alloc] init];
    
    if (copy) {

        copy.mobile = [self.mobile copyWithZone:zone];
        copy.score = self.score;
        copy.dataIdentifier = self.dataIdentifier;
        copy.isConsume = self.isConsume;
        copy.userId = self.userId;
        copy.actionId = self.actionId;
        copy.addTime = self.addTime;
    }
    
    return copy;
}


@end
