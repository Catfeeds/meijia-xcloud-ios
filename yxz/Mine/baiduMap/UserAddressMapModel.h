//
//  MapModel.h
//  simi
//
//  Created by 高鸿鹏 on 15-5-12.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAddressMapModel : NSObject


@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *address;
@property(nonatomic,assign) double latitude;     //纬度
@property(nonatomic,assign) double longitude;    //经度
@property(nonatomic,assign) double center;
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *city;
@property(nonatomic,copy) NSString *phone;
@property(nonatomic,copy) NSString *postCode;
@property(nonatomic,assign) int poiType;

- (instancetype)initWithArray:(NSArray *)array index:(NSInteger)index;
@end
