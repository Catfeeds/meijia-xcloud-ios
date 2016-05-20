//
//  CollectCategoryTableViewCell.m
//  yxz
//
//  Created by 白玉林 on 16/4/1.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "CollectCategoryTableViewCell.h"

@implementation CollectCategoryTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        _nameLabel=[[UILabel alloc]initWithFrame:FRAME(20, 10, WIDTH-40, 20)];
        _nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        [self addSubview:_nameLabel];
        
        _shuLabel=[[UILabel alloc]initWithFrame:FRAME(20, 50, WIDTH-140, 20)];
        _shuLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        [self addSubview:_shuLabel];
        
        _numLabel=[[UILabel alloc]initWithFrame:FRAME(WIDTH-190, 50, 50, 20)];
        _numLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        _numLabel.text=[NSString stringWithFormat:@"%d",_numbar];
        _numLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_numLabel];
        
        
        _addBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH-140, 40, 40, 40)];
//        [_addBut addTarget:self action:@selector(addBut:) forControlEvents:UIControlEventTouchUpInside];
//        _addBut.backgroundColor=[UIColor redColor];
        [self addSubview:_addBut];
        
        UIImageView *addImage=[[UIImageView alloc]initWithFrame:FRAME(5, 5, 30, 30)];
        addImage.image=[UIImage imageNamed:@"iconfont-jiahao"];
        [_addBut addSubview:addImage];
        
        _reduceBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH-220, 40, 40, 40)];
//        [_reduceBut addTarget:self action:@selector(_reduceBut:) forControlEvents:UIControlEventTouchUpInside];
//        _reduceBut.backgroundColor=[UIColor redColor];
        [self addSubview:_reduceBut];
        
        UIImageView *reduceImage=[[UIImageView alloc]initWithFrame:FRAME(5, 5, 30, 30)];
        reduceImage.image=[UIImage imageNamed:@"iconfont-jianhao"];
        [_reduceBut addSubview:reduceImage];
    }
    return self;
}

- (void)awakeFromNib {
        // Initialization code
}
//-(void)addBut:(UIButton *)button
//{
//    _numbar++;
//    _numLabel.text=[NSString stringWithFormat:@"%d",_numbar];
//}
//-(void)_reduceBut:(UIButton *)button
//{
//    if (_numbar>0) {
//        _numbar--;
//        _numLabel.text=[NSString stringWithFormat:@"%d",_numbar];
//    }
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
