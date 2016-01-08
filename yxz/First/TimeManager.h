//
//  TimeManager.h
//  simi
//
//  Created by zrj on 15-1-14.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeManager : NSObject

- (void)TimeOutWith:(NSString *)TimeStr;

@property (nonatomic, assign) BOOL KtimeOut;

@end
