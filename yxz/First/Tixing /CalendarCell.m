//
//  CalendarCell.m
//  simi
//
//  Created by zrj on 14-12-15.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "CalendarCell.h"
#import "ChoiceDefine.h"
@implementation CalendarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = HEX_TO_UICOLOR(BAC_VIEW_COLOR, 1.0); //cell选中时的背景颜色
        
        // 自定义cell线
        UIView *xiaxian = [[UIView alloc]initWithFrame:FRAME(0, 54+0.5, self_Width, 0.5)];
        xiaxian.backgroundColor = HEX_TO_UICOLOR(CHOICE_BACK_VIEW_COLOR, 1.0);
        [self addSubview:xiaxian];
        
        UIView *shangxian = [[UIView alloc]initWithFrame:FRAME(0, 0.5, self_Width, 0.5)];
        shangxian.backgroundColor = HEX_TO_UICOLOR(CHOICE_BACK_VIEW_COLOR, 1.0);
        [self addSubview:shangxian];
        
        _title = [[UILabel alloc]initWithFrame:FRAME(18, 10, self_Width - 36, 20)];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.font = [UIFont systemFontOfSize:13];
        _title.highlightedTextColor = HEX_TO_UICOLOR(NAV_COLOR, 1.0);
        [self addSubview:_title];
        
        _detailLab = [[UILabel alloc]initWithFrame:FRAME(18, 30, self_Width - 36, 20)];
        _detailLab.textAlignment = NSTextAlignmentLeft;
        _detailLab.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
        _detailLab.font = [UIFont systemFontOfSize:10];
        [self addSubview:_detailLab];
        
        
        }
    
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
