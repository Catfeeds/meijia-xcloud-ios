//
//  MapModel.m
//  simi
//
//  Created by 高鸿鹏 on 15-5-12.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "UserAddressMapModel.h"
#import "BMKPoiSearch.h"
@implementation UserAddressMapModel
@synthesize name,address,latitude,longitude,center,city,uid,phone,postCode,poiType;


- (instancetype)initWithArray:(NSArray *)array index:(NSInteger)index
{
    self = [super init];
  
    self.name = ((BMKPoiInfo *) [array objectAtIndex:index]).name;
    self.address = ((BMKPoiInfo *) [array objectAtIndex:index]).address;
    self.city = ((BMKPoiInfo *) [array objectAtIndex:index]).city;
    self.uid = ((BMKPoiInfo *) [array objectAtIndex:index]).uid;
    self.phone = ((BMKPoiInfo *) [array objectAtIndex:index]).phone;
    self.postCode = ((BMKPoiInfo *) [array objectAtIndex:index]).postcode;
    self.poiType = ((BMKPoiInfo *) [array objectAtIndex:index]).epoitype;
    
    
    CLLocationCoordinate2D zuobiao = ((BMKPoiInfo *) [array objectAtIndex:index]).pt;
    
    
    self.latitude = zuobiao.latitude;
    self.longitude = zuobiao.longitude;
    
    
    return self;
}




@end
