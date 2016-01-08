//
//  RepeatCell.m
//  simi
//
//  Created by zrj on 14-11-28.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "RepeatCell.h"
#import "ChoiceDefine.h"
@implementation RepeatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 自定义cell线
        self.xiaxian = [[UIView alloc]initWithFrame:FRAME(0, 40-0.5, self_Width, 0.5)];
        self.xiaxian.backgroundColor = HEX_TO_UICOLOR(CHOICE_BACK_VIEW_COLOR, 1.0);
        [self addSubview:self.xiaxian];
        
        self.titleLab = [[UILabel alloc]initWithFrame:FRAME(18, 0, 200, 40)];
        self.titleLab.backgroundColor = DEFAULT_COLOR;
        self.titleLab.textColor = HEX_TO_UICOLOR(0x666666, 1.0);
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.titleLab];
        
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
