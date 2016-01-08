//
//  SERVICEServiceTypes.m
//
//  Created by 中杰 赵 on 14/11/28
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "SERVICEServiceTypes.h"
#import "SERVICEBaojie.h"
#import "SERVICEXiyi.h"
#import "SERVICEZuofan.h"
#import "SERVICECaboli.h"
#import "SERVICEGuandao.h"
#import "SERVICEXinju.h"
#import "SERVICEJiadian.h"


NSString *const kSERVICEServiceTypesBaojie = @"baojie";
NSString *const kSERVICEServiceTypesXiyi = @"xiyi";
NSString *const kSERVICEServiceTypesZuofan = @"zuofan";
NSString *const kSERVICEServiceTypesCaboli = @"caboli";
NSString *const kSERVICEServiceTypesGuandao = @"guandao";
NSString *const kSERVICEServiceTypesXinju = @"xinju";
NSString *const kSERVICEServiceTypesJiadian = @"jiadian";


@interface SERVICEServiceTypes ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SERVICEServiceTypes

@synthesize baojie = _baojie;
@synthesize xiyi = _xiyi;
@synthesize zuofan = _zuofan;
@synthesize caboli = _caboli;
@synthesize guandao = _guandao;
@synthesize xinju = _xinju;
@synthesize jiadian = _jiadian;


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
            self.baojie = [SERVICEBaojie modelObjectWithDictionary:[dict objectForKey:kSERVICEServiceTypesBaojie]];
            self.xiyi = [SERVICEXiyi modelObjectWithDictionary:[dict objectForKey:kSERVICEServiceTypesXiyi]];
            self.zuofan = [SERVICEZuofan modelObjectWithDictionary:[dict objectForKey:kSERVICEServiceTypesZuofan]];
            self.caboli = [SERVICECaboli modelObjectWithDictionary:[dict objectForKey:kSERVICEServiceTypesCaboli]];
            self.guandao = [SERVICEGuandao modelObjectWithDictionary:[dict objectForKey:kSERVICEServiceTypesGuandao]];
            self.xinju = [SERVICEXinju modelObjectWithDictionary:[dict objectForKey:kSERVICEServiceTypesXinju]];
            self.jiadian = [SERVICEJiadian modelObjectWithDictionary:[dict objectForKey:kSERVICEServiceTypesJiadian]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.baojie dictionaryRepresentation] forKey:kSERVICEServiceTypesBaojie];
    [mutableDict setValue:[self.xiyi dictionaryRepresentation] forKey:kSERVICEServiceTypesXiyi];
    [mutableDict setValue:[self.zuofan dictionaryRepresentation] forKey:kSERVICEServiceTypesZuofan];
    [mutableDict setValue:[self.caboli dictionaryRepresentation] forKey:kSERVICEServiceTypesCaboli];
    [mutableDict setValue:[self.guandao dictionaryRepresentation] forKey:kSERVICEServiceTypesGuandao];
    [mutableDict setValue:[self.xinju dictionaryRepresentation] forKey:kSERVICEServiceTypesXinju];
    [mutableDict setValue:[self.jiadian dictionaryRepresentation] forKey:kSERVICEServiceTypesJiadian];

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

    self.baojie = [aDecoder decodeObjectForKey:kSERVICEServiceTypesBaojie];
    self.xiyi = [aDecoder decodeObjectForKey:kSERVICEServiceTypesXiyi];
    self.zuofan = [aDecoder decodeObjectForKey:kSERVICEServiceTypesZuofan];
    self.caboli = [aDecoder decodeObjectForKey:kSERVICEServiceTypesCaboli];
    self.guandao = [aDecoder decodeObjectForKey:kSERVICEServiceTypesGuandao];
    self.xinju = [aDecoder decodeObjectForKey:kSERVICEServiceTypesXinju];
    self.jiadian = [aDecoder decodeObjectForKey:kSERVICEServiceTypesJiadian];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_baojie forKey:kSERVICEServiceTypesBaojie];
    [aCoder encodeObject:_xiyi forKey:kSERVICEServiceTypesXiyi];
    [aCoder encodeObject:_zuofan forKey:kSERVICEServiceTypesZuofan];
    [aCoder encodeObject:_caboli forKey:kSERVICEServiceTypesCaboli];
    [aCoder encodeObject:_guandao forKey:kSERVICEServiceTypesGuandao];
    [aCoder encodeObject:_xinju forKey:kSERVICEServiceTypesXinju];
    [aCoder encodeObject:_jiadian forKey:kSERVICEServiceTypesJiadian];
}

- (id)copyWithZone:(NSZone *)zone
{
    SERVICEServiceTypes *copy = [[SERVICEServiceTypes alloc] init];
    
    if (copy) {

        copy.baojie = [self.baojie copyWithZone:zone];
        copy.xiyi = [self.xiyi copyWithZone:zone];
        copy.zuofan = [self.zuofan copyWithZone:zone];
        copy.caboli = [self.caboli copyWithZone:zone];
        copy.guandao = [self.guandao copyWithZone:zone];
        copy.xinju = [self.xinju copyWithZone:zone];
        copy.jiadian = [self.jiadian copyWithZone:zone];
    }
    
    return copy;
}


@end
