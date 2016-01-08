//
//  SERVICEBaseClass.m
//
//  Created by 中杰 赵 on 14/11/28
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "SERVICEBaseClass.h"
#import "SERVICEData.h"


NSString *const kSERVICEBaseClassStatus = @"status";
NSString *const kSERVICEBaseClassMsg = @"msg";
NSString *const kSERVICEBaseClassData = @"data";


@interface SERVICEBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SERVICEBaseClass

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
            self.status = [[self objectOrNilForKey:kSERVICEBaseClassStatus fromDictionary:dict] doubleValue];
            self.msg = [self objectOrNilForKey:kSERVICEBaseClassMsg fromDictionary:dict];
            self.data = [SERVICEData modelObjectWithDictionary:[dict objectForKey:kSERVICEBaseClassData]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kSERVICEBaseClassStatus];
    [mutableDict setValue:self.msg forKey:kSERVICEBaseClassMsg];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kSERVICEBaseClassData];

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

    self.status = [aDecoder decodeDoubleForKey:kSERVICEBaseClassStatus];
    self.msg = [aDecoder decodeObjectForKey:kSERVICEBaseClassMsg];
    self.data = [aDecoder decodeObjectForKey:kSERVICEBaseClassData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_status forKey:kSERVICEBaseClassStatus];
    [aCoder encodeObject:_msg forKey:kSERVICEBaseClassMsg];
    [aCoder encodeObject:_data forKey:kSERVICEBaseClassData];
}

- (id)copyWithZone:(NSZone *)zone
{
    SERVICEBaseClass *copy = [[SERVICEBaseClass alloc] init];
    
    if (copy) {

        copy.status = self.status;
        copy.msg = [self.msg copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
