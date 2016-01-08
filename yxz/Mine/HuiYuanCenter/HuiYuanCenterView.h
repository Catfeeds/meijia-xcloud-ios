//
//  HuiYuanCenterView.h
//  simi
//
//  Created by 赵中杰 on 14/12/7.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherView.h"
#import "VIPLISTData.h"

@protocol BUYDELEGATE <NSObject>

- (void)buyHuiyuanWithMoney:(NSString *)money;

@end

@interface HuiYuanCenterView : FatherView
{
    __weak id <BUYDELEGATE> _delegate;
    
    
}

@property (nonatomic, weak) __weak id <BUYDELEGATE> delegate;

- (id)initWithFrame:(CGRect)frame listArray:(NSArray *)array;


@end
