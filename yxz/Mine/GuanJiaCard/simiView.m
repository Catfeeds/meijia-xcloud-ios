//
//  simiView.m
//  simi
//
//  Created by 赵中杰 on 14/12/9.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "simiView.h"

@implementation simiView

@synthesize delegate = _delegate;


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    UILabel *_backlabel = [[UILabel alloc]initWithFrame:FRAME(18, 15, _CELL_WIDTH-36, 113.5+80)];
    _backlabel.backgroundColor = COLOR_VAULE(255.0);
    _backlabel.layer.cornerRadius = 4;
    _backlabel.alpha = 0.75;
    _backlabel.layer.borderWidth = 0.5;
    _backlabel.layer.borderColor = COLOR_VAULE(211.0).CGColor;
    [self addSubview:_backlabel];

//    7.5 line_
    UIImageView *_backimageview = [[UIImageView alloc]initWithFrame:FRAME(18, 15, _CELL_WIDTH-36, 113.5)];
    [_backimageview setBackgroundColor:[self getColor:@"E8374A"]];
    _backimageview.layer.cornerRadius = 4.0;
    [self addSubview:_backimageview];
    
    UIImageView *_lineimageview = [[UIImageView alloc]initWithFrame:FRAME(18, 109+15, _CELL_WIDTH-36, 13.5)];
    [_lineimageview setImage:[UIImage imageNamed:@"background_01"]];
    [self addSubview:_lineimageview];

    
    UIImageView *_avatarView = [[UIImageView alloc]initWithFrame:FRAME(18+17, 15+17, 55, 55)];
    [_avatarView setImage:[UIImage imageNamed:@"steward-icon_"]];
    [self addSubview:_avatarView];
    
    UILabel *_label1 = [[UILabel alloc]initWithFrame:FRAME(18+17+55+12.5, 15+33, 180, 18.5)];
    _label1.text = @"真人私秘预订卡";
    _label1.textColor = [self getColor:@"ffffff"];
    _label1.font = MYBOLD(18.5);
    [self addSubview:_label1];
    
    UILabel *_label2 = [[UILabel alloc]initWithFrame:FRAME(_CELL_WIDTH-18-75, 15+33+40, 23, 23)];
    _label2.text = @"￥";
    _label2.textColor = [self getColor:@"ffffff"];
    _label2.font = MYBOLD(22.5);
    [self addSubview:_label2];

    UILabel *_label3 = [[UILabel alloc]initWithFrame:FRAME(_CELL_WIDTH-18-55, 15+33+40, 55, 20)];
    _label3.text = @"300";
    _label3.textColor = [self getColor:@"ffffff"];
    _label3.font = MYBOLD(20);
    [self addSubview:_label3];
    
    UIButton *_shenqingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shenqingBtn.frame = FRAME(10+18, 15+113.5+22.5, _CELL_WIDTH-20-36, 30);
    _shenqingBtn.layer.cornerRadius = 5;
    _shenqingBtn.layer.borderWidth = 1;
    _shenqingBtn.layer.borderColor = [self getColor:@"E8374A"].CGColor;
    [_shenqingBtn setTitle:@"马 上 申 请" forState:UIControlStateNormal];
    _shenqingBtn.titleLabel.font = MYFONT(15);
    [_shenqingBtn setTitleColor:[self getColor:@"E8374A"] forState:UIControlStateNormal];
    [_shenqingBtn addTarget:self action:@selector(ShenQingBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shenqingBtn];
    
    
    
    NSArray *_imgNameArr = @[@"shen-xin_",@"ti-yan_",@"dui-hua_"];
    NSArray *_titleArr = @[@"一键呼叫私秘,快捷省心",@"真人对话,沟通不再冷冰冰",@"大事小事私秘搞定,尊享体验"];
    
    for (int i = 0; i < 3; i ++) {
        UIImageView *_leftview = [[UIImageView alloc]initWithFrame:FRAME(18, 15+113.5+80+32.5+65*i, 39, 39)];
        [_leftview setImage:[UIImage imageNamed:[_imgNameArr objectAtIndex:i]]];
        [self addSubview:_leftview];
        
        UIButton *_touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_touchBtn setBackgroundImage:[[UIImage imageNamed:@"backcloth_"] stretchableImageWithLeftCapWidth:25 topCapHeight:28] forState:UIControlStateNormal];
        _touchBtn.frame = FRAME(18+42, 15+113.5+80+32.5+65*i+5, _CELL_WIDTH-18-42-35, 30);
        [_touchBtn setTitle:[_titleArr objectAtIndex:i] forState:UIControlStateNormal];
        _touchBtn.titleLabel.font = MYFONT(13.5);
        [_touchBtn setTitleColor:[self getColor:@"b1b1b1"] forState:UIControlStateNormal];
        [self addSubview:_touchBtn];
    }
    
    UIImageView *_downline = [[UIImageView alloc]initWithFrame:FRAME(18, self.frame.size.height-60, _CELL_WIDTH-36, 0.5)];
    _downline.backgroundColor = COLOR_VAULE(209.0);
    [self addSubview:_downline];
    
    UILabel *_downlabel = [[UILabel alloc]initWithFrame:FRAME(0, self.frame.size.height-60, _CELL_WIDTH-18, 60)];
    _downlabel.font = MYFONT(10);
    _downlabel.textColor = [self getColor:@"b1b1b1"];
    _downlabel.text = @"现在购买会员卡赠送私秘服务,快去看看";
    _downlabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_downlabel];
    
    UIButton *_touchBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_touchBtn1 addTarget:self action:@selector(GotoHuiyuanka:) forControlEvents:UIControlEventTouchUpInside];
    _touchBtn1.frame = FRAME(_CELL_WIDTH-60-20-180, self.frame.size.height-40, 196, 16);
    [_touchBtn1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_touchBtn1 setImage:[UIImage imageNamed:@"see_"] forState:UIControlStateNormal];
    [self addSubview:_touchBtn1];

    
//    see_@2x 16 16
    

    
}

- (void)GotoHuiyuanka:(UIButton *)sender
{
    [self.delegate simiBtnPressedWithName:@"huiyuanka"];
    
}

- (void)ShenQingBtnPressed:(UIButton *)sender
{
    [self.delegate simiBtnPressedWithName:@"simika"];
}



@end
