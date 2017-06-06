//
//  BuyView.h
//  simi
//
//  Created by 赵中杰 on 14/12/8.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherView.h"

@protocol BUYDELEGATE <NSObject>

- (void)buyBtnPressedisAli:(BOOL)isAli;

@end

@interface BuyView : FatherView
{
    NSString *_zhanghu;
    NSString *_jine;
    NSString *_fanxian;
    
    NSString *_selfmoney;
    
    BOOL isAli;
}

@property (nonatomic, strong)NSString *zhanghu;
@property (nonatomic, strong)NSString *jine;
@property (nonatomic, strong)NSString *fanxian;
@property (nonatomic, strong)NSString *selfmoney;
@property (nonatomic, assign)BOOL ZFB;

@property (nonatomic, weak) __weak id <BUYDELEGATE> delegate;


- (id)initWithFrame:(CGRect)frame num:(int)num;

@end
