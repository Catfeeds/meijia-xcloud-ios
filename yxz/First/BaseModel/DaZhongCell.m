//
//  DaZhongCell.m
//  simi
//
//  Created by 高鸿鹏 on 15/7/8.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "DaZhongCell.h"
#import "UIImageView+WebCache.h"
@implementation DaZhongCell


-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *title = [[UILabel alloc]initWithFrame:FRAME(100, 8, self_Width-110, 20)];
        title.tag = 1;
        title.font = [UIFont systemFontOfSize:14];
        [self addSubview:title];
        
        UILabel *dela = [[UILabel alloc]initWithFrame:FRAME(100, title.bottom+5, self_Width-110, 20)];
        dela.font = [UIFont systemFontOfSize:12];
        dela.tag = 2;
        dela.textColor = [UIColor grayColor];
        [self addSubview:dela];
        
        UILabel *price = [[UILabel alloc]initWithFrame:FRAME(100, dela.bottom+5, self_Width-110, 20)];
        price.font = [UIFont systemFontOfSize:12];
        price.textColor = YELLOW_COLOR;
        price.tag = 3;
        [self addSubview:price];
        
        UIImageView *photo = [[UIImageView alloc]initWithFrame:FRAME(10 , 10, 80, 60)];
        photo.tag = 4;
        [self addSubview:photo];

    }
    
    
    return self;
}

- (void)setBaseModel:(BaseModel *)baseModel
{
    UILabel *title = (UILabel *)[self viewWithTag:1];
    UILabel *dela = (UILabel *)[self viewWithTag:2];
    UILabel *price = (UILabel *)[self viewWithTag:3];
    UIImageView *imageView = (UIImageView *)[self viewWithTag:4];
    

    title.text = baseModel.name;
    dela.text = baseModel.describe;
    price.text = [NSString stringWithFormat:@"%@",baseModel.price];
    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",baseModel.imgUrl]]];

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
