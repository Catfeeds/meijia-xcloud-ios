//
//  BaseModel.m
//  simi
//
//  Created by 高鸿鹏 on 15/6/17.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
@synthesize
name,
price,
describe,
imgUrl,
online_reservation_url
;


- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        name = [self objectOrNilForKey:@"name" fromDictionary:dict];
        price = [self objectOrNilForKey:@"avg_price" fromDictionary:dict];

        imgUrl = [self objectOrNilForKey:@"photo_url" fromDictionary:dict];
        describe = [self objectOrNilForKey:@"branch_name" fromDictionary:dict];

        online_reservation_url = [self objectOrNilForKey:@"online_reservation_url" fromDictionary:dict];
    }
    return  self;
}



#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


@end
