//
//  HomePageTableViewCell.m
//  yxz
//
//  Created by 白玉林 on 16/4/6.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "HomePageTableViewCell.h"

@implementation HomePageTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        _headeImageVIew=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-110, 15, 95, 70)];
        [self addSubview:_headeImageVIew];
        
//        //添加边框
//        CALayer *layer = [_headeImageVIew layer];
//        layer.borderColor = [[UIColor blackColor] CGColor];
//        layer.borderWidth = 0.5;
        //添加四个边阴影
        _headeImageVIew.layer.shadowColor = [UIColor blackColor].CGColor;
        _headeImageVIew.layer.shadowOffset = CGSizeMake(0, 0);
        _headeImageVIew.layer.shadowOpacity = 0.3;
//        _headeImageVIew.layer.shadowRadius = 10.0;
        
        _titleLabel=[[UILabel alloc]initWithFrame:FRAME(15, 20, WIDTH-(_headeImageVIew.frame.size.width+35), 55)];
        _titleLabel.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
        _titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
//        _titleLabel.backgroundColor=[UIColor blueColor];
        [self addSubview:_titleLabel];
        _subTitleLabel=[[UILabel alloc]initWithFrame:FRAME(15, 75, WIDTH-(_headeImageVIew.frame.size.width+35), 10)];
        _subTitleLabel.font=[UIFont fontWithName:@"Heiti SC" size:10];
        _subTitleLabel.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
        [self addSubview:_subTitleLabel];
        UIView *lineView=[[UIView alloc]initWithFrame:FRAME(15, 99.5, WIDTH-30, 0.5)];
        lineView.backgroundColor=[UIColor colorWithRed:215/255.0f green:215/255.0f blue:215/255.0f alpha:1];
        [self addSubview:lineView];
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
