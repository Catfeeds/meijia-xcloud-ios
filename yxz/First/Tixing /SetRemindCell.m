//
//  SetRemindCell.m
//  simi
//
//  Created by zrj on 14-11-26.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "SetRemindCell.h"
#import "ChoiceDefine.h"
@implementation SetRemindCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 自定义cell线
        self.xiaxian = [[UIView alloc]initWithFrame:FRAME(0, 108/2-0.5, self_Width, 0.5)];
        self.xiaxian.backgroundColor = HEX_TO_UICOLOR(CHOICE_BACK_VIEW_COLOR, 1.0);
        [self addSubview:self.xiaxian];
        
        self.title = [[UILabel alloc]initWithFrame:FRAME(18, 4, 100, 108/2/2)];
        self.title.textColor = HEX_TO_UICOLOR(0x666666, 1.0);
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.font = [UIFont systemFontOfSize:13];
//        self.title.backgroundColor = [UIColor grayColor];
        [self addSubview:self.title];
        
        self.detailTitle = [[UILabel alloc]initWithFrame:FRAME(18, 108/2/2-4, 160, 108/2/2)];
        self.detailTitle.textColor = HEX_TO_UICOLOR(0xb1b1b1, 1.0);
        self.detailTitle.textAlignment = NSTextAlignmentLeft;
        self.detailTitle.font = [UIFont systemFontOfSize:13];
//        self.detailTitle.backgroundColor = [UIColor grayColor];
        [self addSubview:self.detailTitle];
        
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
