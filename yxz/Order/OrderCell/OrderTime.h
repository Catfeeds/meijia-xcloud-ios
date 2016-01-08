//
//  OrderTime.h
//  simi
//
//  Created by zrj on 15-1-26.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderTime : NSObject

@property (nonatomic, assign) BOOL KtimeOut;

- (BOOL)TimeOutWith:(NSString *)TimeStr hours:(NSInteger)hours;

@end
