//
//  DuiHuanTableViewCell.m
//  simi
//
//  Created by 赵中杰 on 14/12/11.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "DuiHuanTableViewCell.h"

@implementation DuiHuanTableViewCell
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UILabel *_labal1 = [[UILabel alloc]initWithFrame:FRAME(18, 10, 200, 14)];
        _labal1.font = MYFONT(13.5);
        _labal1.text = @"私秘通用优惠券(20元)";
        _labal1.textColor = COLOR_VAULE(104.0);
        [self addSubview:_labal1];
        
        UILabel *_labal2 = [[UILabel alloc]initWithFrame:FRAME(18, 34, 60, 11)];
        _labal2.font = MYFONT(10);
        _labal2.text = @"所需积分:";
        _labal2.textColor = COLOR_VAULE(178.0);
        [self addSubview:_labal2];

        UILabel *_labal3 = [[UILabel alloc]initWithFrame:FRAME(18+65, 34, 80, 11)];
        _labal3.font = MYFONT(10);
        _labal3.text = @"100";
        _labal3.textColor = HEX_TO_UICOLOR(TEXT_COLOR, 1.0);
        [self addSubview:_labal3];
        
        UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = FRAME(_CELL_WIDTH-18-47, 10, 47, 32);
        [_button setBackgroundImage:[[UIImage imageNamed:@"circle_@2x"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
        _button.titleLabel.font = MYFONT(14);
        [_button setTitle:@"兑换" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(DuihuanBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_button setTitleColor:HEX_TO_UICOLOR(TEXT_COLOR, 1.0) forState:UIControlStateNormal];
        [self addSubview:_button];

        
    }
    
    return self;
}

#pragma mark 兑换按钮
- (void)DuihuanBtn:(UIButton *)sender
{
    [self.delegate duihuananniuDIanji];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
