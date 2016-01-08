//
//  CellModel.m
//  simi
//
//  Created by zrj on 15-2-2.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "CellModel.h"


@interface CellModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CellModel

@synthesize cellID,city_id,cell_name,cell_addr,addr_lng,addr_lat,add_time,available;

- (instancetype)initWithArray:(NSArray *)array index:(NSInteger)index{
    
    self = [super init];
    
    self.cellID = [[array objectAtIndex:index] objectForKey:@"id"];
    self.city_id = [[[array objectAtIndex:index] objectForKey:@"city_id"] intValue];
    self.cell_name = [[array objectAtIndex:index] objectForKey:@"name"];
    self.cell_addr = [[array objectAtIndex:index] objectForKey:@"addr"];
    self.addr_lng = [[array objectAtIndex:index] objectForKey:@"addr_lng"];
    self.addr_lat = [[array objectAtIndex:index] objectForKey:@"addr_lat"];
    self.add_time = [[[array objectAtIndex:index] objectForKey:@"add_time"] intValue];
    self.available = [[[array objectAtIndex:index] objectForKey:@"available"] intValue];
    return self;
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end
