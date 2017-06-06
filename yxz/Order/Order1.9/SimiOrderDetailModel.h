//
//  SimiOrderDetailModel.h
//  simi
//
//  Created by 高鸿鹏 on 15/6/22.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimiOrderDetailModel : NSObject


@property (nonatomic, strong) NSString *order_no;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *service_type;
@property (nonatomic, strong) NSString *service_type_name;
@property (nonatomic, strong) NSString *order_pay_type;
@property (nonatomic, strong) NSString *service_content;
@property (nonatomic, strong) NSString *service_time;
@property (nonatomic, strong) NSString *order_money;
@property (nonatomic, strong) NSString *service_addr;
@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, assign) int service_date;
@property (nonatomic, assign) int start_time;
@property (nonatomic, assign) int order_status;
@property (nonatomic, strong) NSString *remarks;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
