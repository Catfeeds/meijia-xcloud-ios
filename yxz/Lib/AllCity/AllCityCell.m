//
//  AllCityCell.m
//  simi
//
//  Created by 赵中杰 on 14/12/6.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "AllCityCell.h"

@implementation AllCityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:FRAME(16, 5, 320-82, self.frame.size.height)];
        [nameLabel setBackgroundColor:DEFAULT_COLOR];
        [nameLabel setFont:[UIFont systemFontOfSize:13]];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [nameLabel setTag:100];
        [self addSubview:nameLabel];
        
        
        UIView *xiaxian = [[UIView alloc]initWithFrame:FRAME(0, 108/2-0.5, self.frame.size.width, 0.5)];
        xiaxian.backgroundColor = HEX_TO_UICOLOR(CHOICE_BACK_VIEW_COLOR, 1.0);
        [self addSubview:xiaxian];
        
        
    }
    return self;
}


- (void)setBase:(ALLCITYBaseClass *)base
{
    _base = base;

    UILabel *_namelabel = (UILabel *)[self viewWithTag:100];
    _namelabel.text = base.cITYName;
}

- (ALLCITYBaseClass *)base
{
    return _base;
}


@end
