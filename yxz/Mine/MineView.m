//
//  MineView.m
//  simi
//
//  Created by 赵中杰 on 14/11/29.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "MineView.h"

@implementation MineView
@synthesize delegate = _delegate;
#define X_S 0
#define Y_S 97

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        NSArray *_namaArr = @[@"账号信息",@"常用地址",@"订单",@"会员卡",@"积分",@"优惠券"];
        
        for (int i = 0; i < 6; i ++) {
            
            
            UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
            _button.backgroundColor = COLOR_VAULE(255.0);
            [_button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [_button setTitle:[_namaArr objectAtIndex:i] forState:UIControlStateNormal];
            [_button setTitleEdgeInsets:UIEdgeInsetsMake(0, X_S, 0, 0)];
            [_button setImage:IMAGE_NAMED(@"s-right-arrow") forState:UIControlStateNormal];
            [_button setTitleColor:COLOR_VAULE(83.0) forState:UIControlStateNormal]; //54  7.5 16
            [_button setImageEdgeInsets:UIEdgeInsetsMake((self.frame.size.height-20)/2, _CELL_WIDTH-20, (self.frame.size.height-20)/2, 0)];
            [_button setTag:(100+i)];
            _button.titleLabel.font = MYFONT(13);
            [_button addTarget:self action:@selector(SelectBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            if (i < 2) {
                _button.frame = FRAME(0, Y_S+54*i, _CELL_WIDTH, 54);
            }else{
                _button.frame = FRAME(0, Y_S+54*i+9, _CELL_WIDTH, 54);
            }
            [self addSubview:_button];
            
        }
        
    }
    
    
    for (int i = 0; i < 8; i ++) {
        UIImageView *_lineView = [[UIImageView alloc]init];
        
        _lineView.backgroundColor = COLOR_VAULE(209.0);
        
        if (i < 3) {
            _lineView.frame = FRAME(0, Y_S+53.5*i, _CELL_WIDTH, 0.5);
        }else{
            _lineView.frame = FRAME(0, Y_S+9+54*2+54*(i - 3), _CELL_WIDTH, 0.5);
        }
        
        [self addSubview:_lineView];
    }
    
    return self;
    
}


#pragma mark 选择按钮点击 tag 100-105 账号信息－－－优惠卷
- (void)SelectBtnPressed:(UIButton *)sender
{
    
    [self.delegate selectBrnPressedWithTag:sender.tag];
    
}


@end
