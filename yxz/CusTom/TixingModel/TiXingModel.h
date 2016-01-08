//
//  TiXingModel.h
//  simi
//
//  Created by 赵中杰 on 14/11/29.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TiXingModel : NSObject

@property (nonatomic, strong) NSString *duixiang;
@property (nonatomic, strong) NSString *biaoti;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *zhouqi;
@property (nonatomic, strong) NSString *beizhu;
@property (nonatomic, assign) NSInteger number;     //记录重复周期选的第几行
@property (nonatomic, strong) NSString *listTitle;  //记录   我 他
@property (nonatomic, strong) NSString *week;       //记录星期几
@property (nonatomic, strong) NSString *userTextFieldText;

@end
