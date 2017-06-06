//
//  PayViewController.h
//  simi
//
//  Created by zrj on 14-12-3.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface PayViewController : FatherViewController
{
    NSString *price;
    NSString *time;
    
    NSString *orderID;
    NSString *orderNum;
    
}
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSString *orderNum;
@property (nonatomic, strong) NSString *juanLX;

- (void)zhifubaoOrBank;

@end
