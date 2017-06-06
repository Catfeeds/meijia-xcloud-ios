//
//  ListTablecell.m
//  simi
//
//  Created by 高鸿鹏 on 15-5-20.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "ListTablecell.h"

@implementation ListTablecell
@synthesize img,titleLab,detailLab;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        
        self.img = [[UIImageView alloc]initWithFrame:FRAME(10, 10, 30, 30)];
        [self addSubview:img];
        
        self.titleLab = [[UILabel alloc]initWithFrame:FRAME(50, 10, self_Width-50, 15)];
        titleLab.font = [UIFont systemFontOfSize:13];
        titleLab.textAlignment = NSTextAlignmentLeft;
//        titleLab.backgroundColor = [UIColor redColor];
        [self addSubview:titleLab];
        
        
        self.detailLab = [[UILabel alloc]initWithFrame:FRAME(50, 25, self_Width-50, 15)];
//        detailLab.backgroundColor= [UIColor greenColor];
        detailLab.font = [UIFont systemFontOfSize:12];
        detailLab.textColor = [UIColor grayColor];
        detailLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:detailLab];
        
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
