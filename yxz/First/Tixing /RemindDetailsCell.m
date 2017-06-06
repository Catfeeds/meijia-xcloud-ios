//
//  RemindDetailsCell.m
//  simi
//
//  Created by zrj on 14-12-6.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "RemindDetailsCell.h"
#import "ChoiceDefine.h"
@implementation RemindDetailsCell
@synthesize delegate = _delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 自定义cell线
        for (int i = 0; i < 3; i++) {
            self.xiaxian = [[UIView alloc]initWithFrame:FRAME(0, 0+((108/2-0.5)*i), self_Width, 0.5)];
            self.xiaxian.backgroundColor = HEX_TO_UICOLOR(CHOICE_BACK_VIEW_COLOR, 1.0);
            [self addSubview:self.xiaxian];
        }
        _oneImg =[[UIImageView alloc]initWithFrame:FRAME(18, (54-31/2)/2, 29/2, 31/2)];
        _oneImg.image = [UIImage imageNamed:@"time_01@2x"];
        [self addSubview:_oneImg];
        
        _twoImg =[[UIImageView alloc]initWithFrame:FRAME(18, 108-(54-31/2)/2-31/2, 29/2, 31/2)];
        _twoImg.image = [UIImage imageNamed:@"time_02@2x"];
        [self addSubview:_twoImg];
        
        _timeLab = [[UILabel alloc]initWithFrame:FRAME(36+29/2, 0, 150, 108/2)];
        _timeLab.font = [UIFont systemFontOfSize:18];
        _timeLab.textColor = HEX_TO_UICOLOR(ROUND_COLOR, 1.0);
        _timeLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_timeLab];
        
        _dateLab = [[UILabel alloc]initWithFrame:FRAME(36+29/2, 54+10, 150, 20)];
        _dateLab.font = [UIFont systemFontOfSize:13];
        _dateLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_dateLab];
        
        _DetailsLab = [[UILabel alloc]initWithFrame:FRAME(36+29/2, 108-10-15, 200, 15)];
        _DetailsLab.backgroundColor = [UIColor clearColor];
        _DetailsLab.font = [UIFont systemFontOfSize:10];
        _DetailsLab.textColor = HEX_TO_UICOLOR(0xb1b1b1, 1.0);
        [self addSubview:_DetailsLab];
        
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.frame = FRAME(self_Width-18-29/2-13-15, 54, 15+29/2, 15+40);
        [_editBtn setImage:[UIImage imageNamed:@"compile_02@2x"] forState:UIControlStateNormal];
        [_editBtn setImageEdgeInsets:UIEdgeInsetsMake(20, 0, 20, 29/2)];
        [_editBtn addTarget:self action:@selector(editaction:) forControlEvents:UIControlEventTouchUpInside];
        _editBtn.tag = 0;
        [self addSubview:_editBtn];
        
        _deleteBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = FRAME(self_Width-18-13, 54, 13+13, 15+40);
        [_deleteBtn addTarget:self action:@selector(editaction:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.tag = 1;
        [_deleteBtn setImage:[UIImage imageNamed:@"ashcan_02@2x"] forState:UIControlStateNormal];
        [_deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(20, 0, 20, 13)];
        [self addSubview:_deleteBtn];
    }
    return self;
}
- (void)editaction:(UIButton *)btn
{
    [self.delegate editOrdelete:btn.tag];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
