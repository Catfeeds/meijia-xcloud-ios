//
//  DetailCell.m
//  simi
//
//  Created by zrj on 14-11-12.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "DetailCell.h"
#import "ChoiceDefine.h"
@implementation DetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLab = [[UILabel alloc]initWithFrame:FRAME(18, 0, 150, self_height)];
        self.titleLab.backgroundColor = DEFAULT_COLOR;
        self.titleLab.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
        self.titleLab.font = [UIFont systemFontOfSize:14];
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.titleLab];
        
        self.numberLab = [[UILabel alloc]initWithFrame:FRAME(0, 0, self_Width, self_height)];
        self.numberLab.backgroundColor = DEFAULT_COLOR;
        self.numberLab.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
        self.numberLab.font = [UIFont systemFontOfSize:14];
        self.numberLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.numberLab];
        
        self.danjiaLab = [[UILabel alloc]initWithFrame:FRAME(self_Width-18-200, 0, 200, self_height)];
        self.danjiaLab.backgroundColor = DEFAULT_COLOR;
        self.danjiaLab.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
        self.danjiaLab.font = [UIFont systemFontOfSize:14];
        self.danjiaLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.danjiaLab];
        
        
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
