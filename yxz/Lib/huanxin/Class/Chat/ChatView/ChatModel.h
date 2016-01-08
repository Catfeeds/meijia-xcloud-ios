//
//  ChatModel.h
//  simi
//
//  Created by 高鸿鹏 on 15/6/19.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModel : NSObject


@property (nonatomic, strong) NSString *order_no;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *service_type_name;
@property (nonatomic, strong) NSString *order_pay_type;
@property (nonatomic, strong) NSString *service_content;
@property (nonatomic, strong) NSString *service_time;
@property (nonatomic, strong) NSString *order_money;
@property (nonatomic, strong) NSString *service_addr;
@property (nonatomic, strong) NSString *add_time;


- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
