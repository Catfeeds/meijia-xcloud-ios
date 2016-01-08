//
//  HairTableViewCell.m
//  yxz
//
//  Created by 白玉林 on 15/12/9.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "HairTableViewCell.h"

@implementation HairTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
        UIView *shangline=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 1)];
        shangline.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
        [self addSubview:shangline];
        UIView *xiaLine=[[UIView alloc]initWithFrame:FRAME(0, 9, WIDTH, 1)];
        xiaLine.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
        [self addSubview:xiaLine];

        _pictureImageView=[[UIImageView alloc]initWithFrame:FRAME(0, 10, WIDTH, 160)];
        [self addSubview:_pictureImageView];
        _labelView=[[UIView alloc]initWithFrame:FRAME(0, 170, WIDTH, 40)];
        _labelView.backgroundColor=[UIColor whiteColor];
        [self addSubview:_labelView];
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
