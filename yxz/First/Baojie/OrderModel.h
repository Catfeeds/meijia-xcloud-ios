//
//  OrderModel.h
//  simi
//
//  Created by zrj on 14-12-18.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, assign) int city_id;
@property (nonatomic, assign) int order_id;
@property (nonatomic, strong) NSString *order_no;
@property (nonatomic, assign) double order_money;
@property (nonatomic, assign) double order_pay;
@property (nonatomic, assign) double price_hour;
@property (nonatomic, assign) double price_hour_discount;
@property (nonatomic, assign) int service_type;
@property (nonatomic, strong) NSJSONSerialization *send_datas;
@property (nonatomic, assign) int service_date;
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *service_hour;
@property (nonatomic, assign) int addr_id;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, assign) int add_time;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
