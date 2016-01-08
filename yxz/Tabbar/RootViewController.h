//
//  RootViewController.h
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import "AppDelegate.h"
@interface RootViewController : FatherViewController<appDelegate>
- (void)tabbarhiddenNO;
- (void)tabbarhidden;
@property (nonatomic, strong)UIView *tab;
@end
