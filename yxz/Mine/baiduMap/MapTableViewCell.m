//
//  MapTableViewCell.m
//  simi
//
//  Created by 高鸿鹏 on 15-5-12.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "MapTableViewCell.h"

@implementation MapTableViewCell


@synthesize titleLab,addressLab;
-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        titleLab = [[UILabel alloc]initWithFrame:FRAME(10, 10, self_Width-20, 15)];
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.tag = 10;
        titleLab.font = [UIFont systemFontOfSize:13];
        [self addSubview:titleLab];
        
        addressLab = [[UILabel alloc]initWithFrame:FRAME(10, titleLab.bottom+5, self_Width-20, 15)];
        addressLab.textAlignment = NSTextAlignmentLeft;
        addressLab.tag = 100;
        addressLab.font = [UIFont systemFontOfSize:12];
        addressLab.textColor = [UIColor grayColor];
        [self addSubview:addressLab];
        
        
    }
    return self;
}
- (void)setMymodel:(UserAddressMapModel *)mymodel
{
    _mymodel = mymodel;
    
    
    UILabel *title = (UILabel *) [self viewWithTag:10];
    title.text = mymodel.name;
    UILabel *address = (UILabel *) [self viewWithTag:100];
    address.text = mymodel.address;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
