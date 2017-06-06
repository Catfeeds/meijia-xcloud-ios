//
//  RemindCell.m
//  simi
//
//  Created by zrj on 14-12-4.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "RemindCell.h"
#import "ChoiceDefine.h"
@implementation RemindCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = HEX_TO_UICOLOR(ROUND_COLOR, 1.0); //cell选中时的背景颜色

        _lingdangImg = [[UIImageView alloc]initWithFrame:FRAME(18, (70-61/2)/2, 62/2, 61/2)];
        [_lingdangImg setImage:[UIImage imageNamed:@"bell_01@2x"]];
        _lingdangImg.highlightedImage = [UIImage imageNamed:@"bell_click@2x"];
        [self addSubview:_lingdangImg];
        
        _titleLab = [[UILabel alloc]initWithFrame:FRAME(36+62/2, 41/2, 150, 20)];
        _titleLab.textColor = HEX_TO_UICOLOR(0x666666, 1.0);
        _titleLab.highlightedTextColor = [UIColor whiteColor];  //cell选中时的lab颜色
        _titleLab.font = [UIFont systemFontOfSize:13];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLab];
        
        _detailLab = [[UILabel alloc]initWithFrame:FRAME(36+62/2, 41/2+15, 150, 20)];
        _detailLab.textColor = HEX_TO_UICOLOR(0xb1b1b1, 1.0);
        _detailLab.font = [UIFont systemFontOfSize:10];
        _detailLab.textAlignment = NSTextAlignmentLeft;
        _detailLab.highlightedTextColor = [UIColor whiteColor];
        [self addSubview:_detailLab];
        
        _sImg = [[UIImageView alloc]initWithFrame:FRAME(self_Width-18-4-61, (70-61/2)/2, 61/2, 61/2)];
        [_sImg setImage:[UIImage imageNamed:@"cyclic_01@2x"]];
        _sImg.highlightedImage = [UIImage imageNamed:@"cyclic_02@2x"];

        [self addSubview:_sImg];
        
        _renImg = [[UIImageView alloc]initWithFrame:FRAME(self_Width-18-61/2, (70-61/2)/2, 61/2, 61/2)];
        [_renImg setImage:[UIImage imageNamed:@"other_01@2x"]];
        _renImg.highlightedImage = [UIImage imageNamed:@"ther_02@2x"];
        [self addSubview:_renImg];
        
        // 自定义cell线
        UIView *xiaxian = [[UIView alloc]initWithFrame:FRAME(0, 70-0.5, self_Width, 0.5)];
        xiaxian.backgroundColor = HEX_TO_UICOLOR(CHOICE_BACK_VIEW_COLOR, 1.0);
        [self addSubview:xiaxian];
        
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
