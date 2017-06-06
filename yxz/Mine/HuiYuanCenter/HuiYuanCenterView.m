//
//  HuiYuanCenterView.m
//  simi
//
//  Created by 赵中杰 on 14/12/7.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "HuiYuanCenterView.h"
#import "BuyViewController.h"

@implementation HuiYuanCenterView
@synthesize delegate = _delegate;


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (id)initWithFrame:(CGRect)frame listArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
        UILabel *_titlelabel = [[UILabel alloc]initWithFrame:FRAME(18, 0, _CELL_WIDTH, 31)];
        _titlelabel.text = @"充值优惠";
        _titlelabel.font = MYFONT(13.5);
        _titlelabel.textColor = [self getColor:@"b1b1b1"];
        _titlelabel.backgroundColor = DEFAULT_COLOR;
        [self addSubview:_titlelabel];
        
        UILabel *_backlabel = [[UILabel alloc]initWithFrame:FRAME(0, 31, _CELL_WIDTH, 54*3)];
        _backlabel.backgroundColor = COLOR_VAULE(255.0);
        [self addSubview:_backlabel];
        
        
        for (int i = 0; i < 3; i ++) {
            
            VIPLISTData *_vipdata = [array objectAtIndex:i];
            
            UILabel *_label = [[UILabel alloc]initWithFrame:FRAME(18, 31+54*i, 72, 54)];
            _label.font = MYFONT(13.5);
            _label.textColor = [self getColor:@"666666"];
            [_label setText:_vipdata.name];
            NSLog(@"%@",_vipdata.name);
            [self addSubview:_label];
            
            UILabel *_moneylabel = [[UILabel alloc]initWithFrame:FRAME(90, 31+54*i, 55, 54)];
            _moneylabel.textColor = [self getColor:@"b1b1b1"];
            _moneylabel.font = MYFONT(13.5);
            _moneylabel.text = [NSString stringWithFormat:@"￥%.f",_vipdata.cardPay];
            [self addSubview:_moneylabel];
            
            UILabel *_moneylabel1 = [[UILabel alloc]initWithFrame:FRAME(145, 31+54*i, 60, 54)];
            _moneylabel1.textColor = [self getColor:@"E8374A"];
            _moneylabel1.font = MYFONT(13.5);
            _moneylabel1.text = [NSString stringWithFormat:@"返%.f",(_vipdata.cardValue - _vipdata.cardPay)];
            [self addSubview:_moneylabel1];
            
            //47  32 18
            UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
            _button.frame = FRAME(_CELL_WIDTH-18-47, 31+54*i+10, 60, 32);
            [_button setBackgroundImage:[[UIImage imageNamed:@"circle_@2x"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
            _button.titleLabel.font = MYFONT(14);
            [_button setTitle:@"购买" forState:UIControlStateNormal];
            [_button setTag:(1000*(i+1))];
            [_button addTarget:self action:@selector(BuyHuiyuan:) forControlEvents:UIControlEventTouchUpInside];
            [_button setTitleColor:[self getColor:@"E8374A"] forState:UIControlStateNormal];
            [self addSubview:_button];
        }
        
        UILabel *tequan = [[UILabel alloc]initWithFrame:FRAME(18, 31+54*3, 60, 54)];
        tequan.textColor = [self getColor:@"b1b1b1"];
        tequan.font = MYFONT(13.5);
        tequan.text = [NSString stringWithFormat:@"充值特权"];
        tequan.lineBreakMode=NSLineBreakByTruncatingTail;
        [tequan setNumberOfLines:1];
        [tequan sizeToFit];
        tequan.frame=FRAME(18, 31+54*3, tequan.frame.size.width, 43);
        [self addSubview:tequan];
        
        for (int i = 0; i < 4; i ++) {
            UIImageView *_lineview = [[UIImageView alloc]initWithFrame:FRAME(0, 31+54*i, _CELL_WIDTH, 0.5)];
            _lineview.backgroundColor = COLOR_VAULE(209.0);
            [self addSubview:_lineview];
        }
        
        UIImageView *_centerview = [[UIImageView alloc]initWithFrame:FRAME(0, 31+54*3+45, WIDTH,150)];
        [_centerview setImage:[UIImage imageNamed:@"member-benefite_"]];
        [self addSubview:_centerview];

    }
    
    return self;
}


#pragma mark 购买会员
- (void)BuyHuiyuan:(UIButton *)sender
{
    switch (sender.tag) {
        case 1000:
            [self.delegate buyHuiyuanWithMoney:@"1"];
            break;
        case 2000:
            [self.delegate buyHuiyuanWithMoney:@"2"];
            break;
        case 3000:
            [self.delegate buyHuiyuanWithMoney:@"3"];
            break;
            
        default:
            break;
    }
}


@end
