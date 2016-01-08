//
//  BuyView.m
//  simi
//
//  Created by 赵中杰 on 14/12/8.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "BuyView.h"

@implementation BuyView
@synthesize delegate = _delegate,ZFB;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (id)initWithFrame:(CGRect)frame num:(int)num
{
    self = [super initWithFrame:frame];
    if (self) {
        
        isAli = YES;
        ZFB = YES;
        
        UILabel *_titlelabel = [[UILabel alloc]initWithFrame:FRAME(18, 0, _CELL_WIDTH, 31)];
        _titlelabel.text = @"支付信息";
        _titlelabel.font = MYFONT(13.5);
        _titlelabel.textColor = [self getColor:@"b1b1b1"];
        _titlelabel.backgroundColor = DEFAULT_COLOR;
        [self addSubview:_titlelabel];
        
        
        UILabel *_backlabel = [[UILabel alloc]initWithFrame:FRAME(0, 31, _CELL_WIDTH, 54*(num-1))];
        _backlabel.backgroundColor = COLOR_VAULE(255.0);
        [self addSubview:_backlabel];
        
        
        NSArray *_labelArr = @[@"账户确认:",((num == 2) ? @"应付金额:" : @"充值金额:"),@"返现金额:"];
        
        for (int i = 1; i < num; i ++) {
            UILabel *_label = [[UILabel alloc]initWithFrame:FRAME(18, 31+54*(i-1), 72, 54)];
            _label.font = MYFONT(13.5);
            _label.textColor = [self getColor:@"666666"];
            [_label setText:[_labelArr objectAtIndex:i]];
            [self addSubview:_label];
            
            UILabel *_seconedlabel = [[UILabel alloc]initWithFrame:FRAME(90, 31+54*(i-1), _CELL_WIDTH-90-18, 54)];
            _seconedlabel.font = MYFONT(13.5);
            [_seconedlabel setTag:(100+i)];
            if (i == 0) {
                _seconedlabel.textColor = [self getColor:@"666666"];
                
            }else if (i == 1){
                _seconedlabel.textColor = [self getColor:@"b1b1b1"];
                
            }else{
                _seconedlabel.textColor = [self getColor:@"E8374A"];
                
            }
            [self addSubview:_seconedlabel];
            
            
        }
        
        for (int i = 1; i < num+1; i ++) {
            UIImageView *_lineview = [[UIImageView alloc]initWithFrame:FRAME(0, 31+54*(i-1), _CELL_WIDTH, 0.5)];
            _lineview.backgroundColor = COLOR_VAULE(209.0);
            [self addSubview:_lineview];
        }
        
        UILabel *_marklabel = [[UILabel alloc]initWithFrame:FRAME(18, 31+54*(num-1)+21, 120, 14)];
        _marklabel.text = @"支付平台:";
        _marklabel.font = MYFONT(13.5);
        _marklabel.textColor = [self getColor:@"b1b1b1"];
        [self addSubview:_marklabel];
        
        UIView *_backlabel1 = [[UIView alloc]initWithFrame:FRAME(0, 31+54*(num-1)+46, _CELL_WIDTH, 54)];
        _backlabel1.backgroundColor = COLOR_VAULE(255.0);
        _backlabel1.tag = 11;
        [self addSubview:_backlabel1];

        UIImageView *_leftimageview = [[UIImageView alloc]initWithFrame:FRAME(18, 31+54*(num-1)+46+7.5, 39, 39)];
        [_leftimageview setImage:[UIImage imageNamed:@"zhi-fu-bao-icon_"]];
        [self addSubview:_leftimageview];
        
        UILabel *_zhifulabel1 = [[UILabel alloc]initWithFrame:FRAME(18+39+14, 31+54*(num-1)+46+10, 120, 14)];
        _zhifulabel1.font = MYFONT(13.5);
        _zhifulabel1.textColor = [self getColor:@"E8374A"];
        _zhifulabel1.backgroundColor = DEFAULT_COLOR;
        _zhifulabel1.text = @"支付宝支付";
        [self addSubview:_zhifulabel1];
        
        UILabel *_zhifulabel2 = [[UILabel alloc]initWithFrame:FRAME(18+39+14, 31+54*(num-1)+46+10+21, 200, 14)];
        _zhifulabel2.font = MYFONT(10);
        _zhifulabel2.textColor = [self getColor:@"b1b1b1"];
        _zhifulabel2.backgroundColor = DEFAULT_COLOR;
        _zhifulabel2.text = @"推荐有支付宝账号的用户使用";
        [self addSubview:_zhifulabel2];
        
        
        UILabel *lab = [[UILabel alloc]initWithFrame:FRAME(0, _backlabel1.bottom, self_Width, 0.5)];
        lab.backgroundColor = COLOR_VAULE(209.0);
        [self addSubview:lab];
        
        UIView *_backlabel2 = [[UIView alloc]initWithFrame:FRAME(0, _backlabel1.bottom+0.5, _CELL_WIDTH, 54)];
        _backlabel2.backgroundColor = COLOR_VAULE(255.0);
        _backlabel2.tag = 22;
        [self addSubview:_backlabel2];
        
        UIImageView *_leftimageview1 = [[UIImageView alloc]initWithFrame:FRAME(18, _backlabel2.top+8, 39, 39)];
        [_leftimageview1 setImage:[UIImage imageNamed:@"weixin-pay"]];
        [self addSubview:_leftimageview1];
        
        UILabel *_weixin = [[UILabel alloc]initWithFrame:FRAME(18+39+14, _backlabel2.top+8, 120, 14)];
        _weixin.font = MYFONT(13.5);
        _weixin.textColor = [self getColor:@"E8374A"];
        _weixin.backgroundColor = DEFAULT_COLOR;
        _weixin.text = @"微信支付";
        [self addSubview:_weixin];
        
        UILabel *_weixinLab = [[UILabel alloc]initWithFrame:FRAME(18+39+14, _backlabel2.bottom-23, 200, 14)];
        _weixinLab.font = MYFONT(10);
        _weixinLab.textColor = [self getColor:@"b1b1b1"];
        _weixinLab.backgroundColor = DEFAULT_COLOR;
        _weixinLab.text = @"使用微信绑定的支付方式";
        [self addSubview:_weixinLab];
        
        UIImageView *image1 = [[UIImageView alloc]initWithFrame:FRAME(self_Width-40, _backlabel1.top+15, 47/2, 47/2)];
        image1.image = [UIImage imageNamed:@"selection-checked"];
        image1.tag = 33;
        [self addSubview:image1];
        
        UIImageView *image2 = [[UIImageView alloc]initWithFrame:FRAME(self_Width-40, _backlabel2.top+15, 47/2, 47/2)];
        image2.image = [UIImage imageNamed:@"selection"];
        image2.tag = 44;
        [self addSubview:image2];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ZfbPaySelect)];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(WxPaySelect)];

        [_backlabel1 addGestureRecognizer:tap];
        [_backlabel2 addGestureRecognizer:tap2];
        
        if (num == 2) {
            
            
            UILabel *_backlabel1 = [[UILabel alloc]initWithFrame:FRAME(0, 31+54*3+46, _CELL_WIDTH, 54)];
            _backlabel1.backgroundColor = COLOR_VAULE(255.0);
            [self addSubview:_backlabel1];
            
            UIImageView *_leftimageview = [[UIImageView alloc]initWithFrame:FRAME(18, 31+54*3+46+7.5, 39, 39)];
            [_leftimageview setImage:[UIImage imageNamed:@"pay_balance_icon"]];
            [self addSubview:_leftimageview];
            
            UILabel *_zhifulabel1 = [[UILabel alloc]initWithFrame:FRAME(18+39+14, 31+54*3+46+10, 120, 14)];
            _zhifulabel1.font = MYFONT(13.5);
            _zhifulabel1.textColor = [self getColor:@"E8374A"];
            _zhifulabel1.backgroundColor = DEFAULT_COLOR;
            _zhifulabel1.text = @"余额支付";
            [self addSubview:_zhifulabel1];
            
            UILabel *_zhifulabel2 = [[UILabel alloc]initWithFrame:FRAME(18+39+14, 31+54*3+46+10+21, 200, 14)];
            _zhifulabel2.font = MYFONT(10);
            _zhifulabel2.textColor = [self getColor:@"b1b1b1"];
            _zhifulabel2.backgroundColor = DEFAULT_COLOR;
            _zhifulabel2.text = @"私秘账户余额支付";
            [self addSubview:_zhifulabel2];
            
            UIImageView *_lineview = [[UIImageView alloc]initWithFrame:FRAME(0, 31+54*3+46, _CELL_WIDTH, 0.5)];
            _lineview.backgroundColor = COLOR_VAULE(209.0);
            [self addSubview:_lineview];
            
            UILabel *_yuelabel = [[UILabel alloc]initWithFrame:FRAME(_CELL_WIDTH-18-23-100, 31+54*3+46, 90, 54)];
            _yuelabel.font = MYFONT(10);
            _yuelabel.textColor = COLOR_VAULE(144.0);
            [_yuelabel setTag:190];
//            _yuelabel.text = @"100元";
            _yuelabel.textAlignment = NSTextAlignmentRight;
            [self addSubview:_yuelabel];
            
            for (int i = 0; i < 3; i ++) {
                UIButton *_selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _selectBtn.height=YES;
                _selectBtn.frame = FRAME(_CELL_WIDTH-18-23, 36+54*num+54*i, 23, 23);
                if (i == 0) {
                    [_selectBtn setImage:[UIImage imageNamed:@"selection_checked"] forState:UIControlStateNormal];

                }else{
                    [_selectBtn setImage:[UIImage imageNamed:@"noselection"] forState:UIControlStateNormal];

                }
                [_selectBtn setTag:(3000+i)];
                [_selectBtn addTarget:self action:@selector(SelectOrNo:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_selectBtn];

            }

        }

        UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = FRAME(14, 31+54*3+46+70+41, WIDTH-28, 41);
        _button.layer.cornerRadius=5;
//        [_button setBackgroundImage:[[UIImage imageNamed:@"circle_@2x"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
        [_button setBackgroundColor:HEX_TO_UICOLOR(TEXT_COLOR, 1.0)];
        _button.titleLabel.font = MYFONT(14);
        [_button setTag:222];
        [_button setTitle:@"确认支付" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(SurePayBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_button];

        
    }
    
    return self;
}
//- (void)ZfbPaySelect
//{
//    NSLog(@"支付宝支付");
//    UIImageView *view = (UIImageView *)[self viewWithTag:33];
//    UIImageView *view2 = (UIImageView *)[self viewWithTag:44];
//
//    view.image = [UIImage imageNamed:@"selection-checked"];
//    view2.image = [UIImage imageNamed:@"selection"];
//    ZFB = YES;
//    
//    
//}
//- (void)WxPaySelect
//{
//    NSLog(@"微信支付");
//    UIImageView *view = (UIImageView *)[self viewWithTag:33];
//    UIImageView *view2 = (UIImageView *)[self viewWithTag:44];
//    
//    view.image = [UIImage imageNamed:@"selection"];
//    view2.image = [UIImage imageNamed:@"selection-checked"];
//    ZFB = NO;
//}
- (void)ZfbPaySelect
{
    NSLog(@"支付宝支付");
    UIImageView *view = (UIImageView *)[self viewWithTag:33];
    UIImageView *view2 = (UIImageView *)[self viewWithTag:44];

    view.image = [UIImage imageNamed:@"selection-checked"];
    view2.image = [UIImage imageNamed:@"selection"];
    ZFB = YES;


}
- (void)WxPaySelect
{
    NSLog(@"微信支付");
    UIImageView *view = (UIImageView *)[self viewWithTag:33];
    UIImageView *view2 = (UIImageView *)[self viewWithTag:44];

    view.image = [UIImage imageNamed:@"selection"];
    view2.image = [UIImage imageNamed:@"selection-checked"];
    ZFB = NO;
}

- (void)setSelfmoney:(NSString *)selfmoney
{
    UILabel *_label = (UILabel *)[self viewWithTag:190];
    _label.text = selfmoney;
}

- (void)SurePayBtnPressed:(UIButton *)sender
{
    [self.delegate buyBtnPressedisAli:isAli];
}

- (void)SelectOrNo:(UIButton *)sender
{
    
    NSLog(@"谁会走这里呢？");
    [sender setImage:[UIImage imageNamed:@"selection_checked"] forState:UIControlStateNormal];
    UIButton *_button = (UIButton *)[self viewWithTag:3000];
    UIButton *_button1 = (UIButton *)[self viewWithTag:3001];
    UIButton *_button2 = (UIButton *)[self viewWithTag:3002];
    
    if (sender.tag == 3000) {
        ZFB=YES;
        isAli=NO;
        [_button1 setImage:[UIImage imageNamed:@"noselection"] forState:UIControlStateNormal];
        [_button2 setImage:[UIImage imageNamed:@"noselection"] forState:UIControlStateNormal];
    }else if(sender.tag==3001){
        ZFB=NO;
        isAli=NO;
        [_button setImage:[UIImage imageNamed:@"noselection"] forState:UIControlStateNormal];
        [_button2 setImage:[UIImage imageNamed:@"noselection"] forState:UIControlStateNormal];

    }else
    {
        ZFB=NO;
        isAli=YES;
        [_button setImage:[UIImage imageNamed:@"noselection"] forState:UIControlStateNormal];
        [_button1 setImage:[UIImage imageNamed:@"noselection"] forState:UIControlStateNormal];
    }

}

- (void)setZhanghu:(NSString *)zhanghu
{
    _zhanghu = zhanghu;
    UILabel *_label = (UILabel *)[self viewWithTag:100];
    _label.text = zhanghu;
}

- (NSString *)zhanghu
{
    return _zhanghu;
}

- (void)setJine:(NSString *)jine
{
    _jine = jine;
    UILabel *_label = (UILabel *)[self viewWithTag:101];
    _label.text = jine;

}
- (NSString *)jine
{
    return _jine;
}

- (void)setFanxian:(NSString *)fanxian
{
    _fanxian = fanxian;
    UILabel *_label = (UILabel *)[self viewWithTag:102];
    _label.text = fanxian;

}

- (NSString *)fanxian
{
    return _fanxian;
}
@end
