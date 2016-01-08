//
//  JiaDianCell.m
//  simi
//
//  Created by zrj on 14-11-11.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "JiaDianCell.h"
#import "ChoiceDefine.h"
@implementation JiaDianCell
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLab = [[UILabel alloc]initWithFrame:FRAME(18+15+8, 7, 150, 20)];
        self.titleLab.backgroundColor = DEFAULT_COLOR;
        self.titleLab.textColor = HEX_TO_UICOLOR(LABLE_COLOR, 1.0);
        self.titleLab.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.titleLab];
        
        self.DetailLab = [[UILabel alloc]initWithFrame:FRAME(18+15+8, 22, self_Width-36-47/2-18-15-8, 30)];
        [self.DetailLab setBackgroundColor:[UIColor clearColor]];
        self.DetailLab.textColor = HEX_TO_UICOLOR(XIYI_LABLE_COLOR, 1.0);
        self.DetailLab.font = [UIFont systemFontOfSize:10];
        [self.DetailLab setNumberOfLines:0];
        [self addSubview:self.DetailLab];
        
        self.youBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.youBtn.frame = FRAME(self.bounds.size.width-18-47/2, 14, 47/2, 47/2);
        [self.youBtn setBackgroundImage:[UIImage imageNamed:@"selection"] forState:UIControlStateNormal];
        [self.youBtn setTitle:@"1" forState:UIControlStateNormal];
        [self.youBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.youBtn];
        
        self.youButn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.youButn.frame = FRAME(self.bounds.size.width-18-47/2, 14, 47/2, 47/2);
        [self.youButn setBackgroundImage:[UIImage imageNamed:@"selection-checked"] forState:UIControlStateNormal];
        [self.youButn addTarget:self action:@selector(btnAction1:) forControlEvents:UIControlEventTouchUpInside];
        self.youButn.hidden = YES;
        [self addSubview:self.youButn];
        
        UIView *xiaxian = [[UIView alloc]initWithFrame:FRAME(0, 108/2-0.5, self_Width, 0.5)];
        xiaxian.backgroundColor = HEX_TO_UICOLOR(CHOICE_BACK_VIEW_COLOR, 1.0);
        [self addSubview:xiaxian];
        
        
        self.img = [[UIImageView alloc]initWithFrame:FRAME(20, 54/2-7, 15, 15)];
        _img.image = [UIImage imageNamed:@"order-other"];
        [self addSubview:self.img];
        
    }
    return self;
}
- (void)btnAction:(UIButton *)Btn
{
    [self.delegate duigouBtnAction:Btn];
}
- (void)btnAction1:(UIButton *)Btn
{
    [self.delegate duigouHidden:Btn];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
