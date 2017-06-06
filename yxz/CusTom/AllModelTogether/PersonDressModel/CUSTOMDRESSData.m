//
//  CUSTOMDRESSData.m
//
//  Created by 中杰 赵 on 14/12/5
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CUSTOMDRESSData.h"


NSString *const kCUSTOMDRESSDataMobile = @"mobile";
NSString *const kCUSTOMDRESSDataUpdateTime = @"update_time";
NSString *const kCUSTOMDRESSDataIsDefault = @"is_default";
NSString *const kCUSTOMDRESSDataId = @"id";
NSString *const kCUSTOMDRESSDataCellId = @"cell_id";
NSString *const kCUSTOMDRESSDataAddrLng = @"addr_lng";
NSString *const kCUSTOMDRESSDataAddr = @"addr";
NSString *const kCUSTOMDRESSDataAddrLat = @"addr_lat";
NSString *const kCUSTOMDRESSDataUserId = @"user_id";
NSString *const kCUSTOMDRESSDataAddTime = @"add_time";
NSString *const kCUSTOMDRESSDataCELLName = @"name";
NSString *const kCUSTOMDRESSDataCITYID = @"city_id";
//cell_name

@interface CUSTOMDRESSData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CUSTOMDRESSData

@synthesize mobile = _mobile;
@synthesize updateTime = _updateTime;
@synthesize isDefault = _isDefault;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize cellId = _cellId;
@synthesize addrLng = _addrLng;
@synthesize addr = _addr;
@synthesize addrLat = _addrLat;
@synthesize userId = _userId;
@synthesize addTime = _addTime;
@synthesize cellname = _cellname;
@synthesize cityId = _cityId;
@synthesize poi_type = _poi_type,name = _name,address = _address,latitude = _latitude,longitude = _longitude,city = _city, uid = _uid;

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
            self.mobile = [self objectOrNilForKey:kCUSTOMDRESSDataMobile fromDictionary:dict];
            self.updateTime = [[self objectOrNilForKey:kCUSTOMDRESSDataUpdateTime fromDictionary:dict] doubleValue];
            self.isDefault = [[self objectOrNilForKey:kCUSTOMDRESSDataIsDefault fromDictionary:dict] doubleValue];
            self.dataIdentifier = [[self objectOrNilForKey:kCUSTOMDRESSDataId fromDictionary:dict] doubleValue];
            self.cellId = [[self objectOrNilForKey:kCUSTOMDRESSDataCellId fromDictionary:dict] doubleValue];
            self.addrLng = [self objectOrNilForKey:kCUSTOMDRESSDataAddrLng fromDictionary:dict];
            self.addr = [self objectOrNilForKey:kCUSTOMDRESSDataAddr fromDictionary:dict];
            self.addrLat = [self objectOrNilForKey:kCUSTOMDRESSDataAddrLat fromDictionary:dict];
            self.userId = [[self objectOrNilForKey:kCUSTOMDRESSDataUserId fromDictionary:dict] doubleValue];
            self.addTime = [[self objectOrNilForKey:kCUSTOMDRESSDataAddTime fromDictionary:dict] doubleValue];
            self.cellname = [self objectOrNilForKey:kCUSTOMDRESSDataCELLName fromDictionary:dict];
        
        self.poi_type = [[self objectOrNilForKey:@"poi_type" fromDictionary:dict] intValue];
        self.name = [self objectOrNilForKey:@"name" fromDictionary:dict];
        self.address = [self objectOrNilForKey:@"address" fromDictionary:dict];
        self.latitude = [self objectOrNilForKey:@"latitude" fromDictionary:dict];
        self.longitude = [self objectOrNilForKey:@"longitude" fromDictionary:dict];
        self.city = [self objectOrNilForKey:@"city" fromDictionary:dict];
        self.uid = [self objectOrNilForKey:@"uid" fromDictionary:dict];


        
        
        
        
        self.cityId = [[self objectOrNilForKey:kCUSTOMDRESSDataCITYID fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.mobile forKey:kCUSTOMDRESSDataMobile];
    [mutableDict setValue:[NSNumber numberWithDouble:self.updateTime] forKey:kCUSTOMDRESSDataUpdateTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isDefault] forKey:kCUSTOMDRESSDataIsDefault];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kCUSTOMDRESSDataId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cellId] forKey:kCUSTOMDRESSDataCellId];
    [mutableDict setValue:self.addrLng forKey:kCUSTOMDRESSDataAddrLng];
    [mutableDict setValue:self.addr forKey:kCUSTOMDRESSDataAddr];
    [mutableDict setValue:self.addrLat forKey:kCUSTOMDRESSDataAddrLat];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kCUSTOMDRESSDataUserId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.addTime] forKey:kCUSTOMDRESSDataAddTime];
    [mutableDict setValue:self.cellname forKey:kCUSTOMDRESSDataCELLName];

    [mutableDict setValue:[NSNumber numberWithDouble:self.cityId] forKey:kCUSTOMDRESSDataCITYID];
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

    self.mobile = [aDecoder decodeObjectForKey:kCUSTOMDRESSDataMobile];
    self.updateTime = [aDecoder decodeDoubleForKey:kCUSTOMDRESSDataUpdateTime];
    self.isDefault = [aDecoder decodeDoubleForKey:kCUSTOMDRESSDataIsDefault];
    self.dataIdentifier = [aDecoder decodeDoubleForKey:kCUSTOMDRESSDataId];
    self.cellId = [aDecoder decodeDoubleForKey:kCUSTOMDRESSDataCellId];
    self.addrLng = [aDecoder decodeObjectForKey:kCUSTOMDRESSDataAddrLng];
    self.addr = [aDecoder decodeObjectForKey:kCUSTOMDRESSDataAddr];
    self.addrLat = [aDecoder decodeObjectForKey:kCUSTOMDRESSDataAddrLat];
    self.userId = [aDecoder decodeDoubleForKey:kCUSTOMDRESSDataUserId];
    self.addTime = [aDecoder decodeDoubleForKey:kCUSTOMDRESSDataAddTime];
    self.cityId = [aDecoder decodeDoubleForKey:kCUSTOMDRESSDataCITYID];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_mobile forKey:kCUSTOMDRESSDataMobile];
    [aCoder encodeDouble:_updateTime forKey:kCUSTOMDRESSDataUpdateTime];
    [aCoder encodeDouble:_isDefault forKey:kCUSTOMDRESSDataIsDefault];
    [aCoder encodeDouble:_dataIdentifier forKey:kCUSTOMDRESSDataId];
    [aCoder encodeDouble:_cellId forKey:kCUSTOMDRESSDataCellId];
    [aCoder encodeObject:_addrLng forKey:kCUSTOMDRESSDataAddrLng];
    [aCoder encodeObject:_addr forKey:kCUSTOMDRESSDataAddr];
    [aCoder encodeObject:_addrLat forKey:kCUSTOMDRESSDataAddrLat];
    [aCoder encodeDouble:_userId forKey:kCUSTOMDRESSDataUserId];
    [aCoder encodeDouble:_addTime forKey:kCUSTOMDRESSDataAddTime];
    [aCoder encodeDouble:_cityId forKey:kCUSTOMDRESSDataCITYID];
}

- (id)copyWithZone:(NSZone *)zone
{
    CUSTOMDRESSData *copy = [[CUSTOMDRESSData alloc] init];
    
    if (copy) {

        copy.mobile = [self.mobile copyWithZone:zone];
        copy.updateTime = self.updateTime;
        copy.isDefault = self.isDefault;
        copy.dataIdentifier = self.dataIdentifier;
        copy.cellId = self.cellId;
        copy.addrLng = [self.addrLng copyWithZone:zone];
        copy.addr = [self.addr copyWithZone:zone];
        copy.addrLat = [self.addrLat copyWithZone:zone];
        copy.userId = self.userId;
        copy.addTime = self.addTime;
        copy.cityId = self.cityId;
    }
    
    return copy;
}


@end
