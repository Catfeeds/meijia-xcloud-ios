//
//  MineJifenViewController.h
//  simi
//
//  Created by 赵中杰 on 14/12/23.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@protocol JiFenDelegate <NSObject>

- (void) CardPasswdIs:(NSString *)passwd money:(double)money;

@end
@interface MineJifenViewController : FatherViewController<MJRefreshBaseViewDelegate>
{
    __weak id<JiFenDelegate>_delegate;
}

@property (nonatomic, weak) id<JiFenDelegate>delegate;

@property (nonatomic, strong) NSString *controlName;

@property (nonatomic, strong) NSString *juanLX;

@property (nonatomic, strong) NSString *moneyString;
@property (nonatomic, strong) NSString *coupon_id;

@property (nonatomic, assign)NSInteger viewConllorID;

@end
