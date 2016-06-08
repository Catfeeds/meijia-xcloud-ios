//
//  ask_listDetailsTableViewCell.m
//  yxz
//
//  Created by 白玉林 on 16/6/4.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "ask_listDetailsTableViewCell.h"

@implementation ask_listDetailsTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        _headeImageView=[[UIImageView alloc]initWithFrame:FRAME(10, 10, 40, 40)];
        _headeImageView.layer.cornerRadius=_headeImageView.frame.size.width/2;
        _headeImageView.clipsToBounds=YES;
        _headeImageView.tag=101;
        [self addSubview:_headeImageView];
        
        _nameLabel=[[UILabel alloc]init];
        _nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        _nameLabel.textColor=[UIColor colorWithRed:157/255.0f green:157/255.0f blue:157/255.0f alpha:1];
        _nameLabel.tag=102;
        [self addSubview:_nameLabel];
        
        _timeLabel=[[UILabel alloc]init];
        _timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
        _timeLabel.textColor=[UIColor colorWithRed:157/255.0f green:157/255.0f blue:157/255.0f alpha:1];
        _timeLabel.tag=103;
        [self addSubview:_timeLabel];
        
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        _titleLabel.tag=104;
        [self addSubview:_titleLabel];
        
        _zanBut=[[UIButton alloc]init];
        [self addSubview:_zanBut];
        
        _zanImageView=[[UIImageView alloc]init];
        _zanImageView.tag=105;
        [_zanBut addSubview:_zanImageView];
        
        _zanLabel =[[UILabel alloc]init];
        _zanLabel.font=[UIFont fontWithName:@"Heiti SC" size:10];
        _zanLabel.tag=106;
        [_zanBut addSubview:_zanLabel];
        
        _adoptBut=[[UIButton alloc]init];
        [_adoptBut.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
        [_adoptBut.layer setCornerRadius:5];
        [_adoptBut.layer setBorderWidth:1];//设置边界的宽度
        [self addSubview:_adoptBut];
        
        _adoptLabel=[[UILabel alloc]init];
        _adoptLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        _adoptLabel.textColor=[UIColor colorWithRed:70/255.0f green:144/255.0f blue:255/255.0f alpha:1];
        [_adoptLabel.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
        [_adoptLabel.layer setCornerRadius:5];
        [_adoptLabel.layer setBorderWidth:1];//设置边界的宽度
        [self addSubview:_adoptLabel];
        
    }
    return self;
}
-(void)setHeadeImageStr:(NSString *)headeImageStr
{
    _headeImageStr=headeImageStr;
    NSString *imageUrl=[NSString stringWithFormat:@"%@",headeImageStr];
    [_headeImageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];

}
-(NSString *)headeImageStr
{
    return _headeImageStr;
}

-(void)setNameStr:(NSString *)nameStr
{
    _nameStr=nameStr;
    UILabel *label=(UILabel *)[self viewWithTag:102];
    label.text=nameStr;
    [label setNumberOfLines:1];
    [label sizeToFit];
    if (label.frame.size.width<WIDTH-150) {
        label.frame=FRAME(_headeImageView.frame.size.width+20, 15, label.frame.size.width, 20);
    }else{
        label.frame=FRAME(_headeImageView.frame.size.width+20, 15, (WIDTH-70)/2, 20);
    }
    
    
}
-(NSString *)nameStr
{
    return _nameStr;
}

-(void)setTimeStr:(NSString *)timeStr
{
    _timeStr=timeStr;
    UILabel *label=(UILabel *)[self viewWithTag:103];
    label.text=timeStr;
    [label setNumberOfLines:1];
    [label sizeToFit];
    label.frame=FRAME(_nameLabel.frame.size.width+70, 20, (WIDTH-70)/2, 15);
}
-(NSString *)timeStr
{
    return _timeStr;
}
-(void)setTitleStr:(NSString *)titleStr
{
    _titleStr=titleStr;
    UILabel *label=(UILabel *)[self viewWithTag:104];
    label.text=titleStr;
    UIFont *font=[UIFont fontWithName:@"Heiti SC" size:15];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize size = [label.text boundingRectWithSize:CGSizeMake(WIDTH-70, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    [label setNumberOfLines:0];
    [label sizeToFit];
    label.frame=FRAME(60, 60, WIDTH-70, size.height);
    _zanBut.frame=FRAME(60, 70+size.height, 70, 30);
}
-(NSString *)titleStr
{
    return _titleStr;
}

-(void)setZanImageStr:(NSString *)zanImageStr
{
    _zanImageStr=zanImageStr;
//    NSString *imageUrl=[NSString stringWithFormat:@"%@",zanImageStr];
//    [_zanImageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];

    _zanImageView.image=[UIImage imageNamed:zanImageStr];
    _zanImageView.frame=FRAME(5, 5, 20, 20);
    
}
-(NSString *)zanImageStr
{
    return _zanImageStr;
}

-(void)setZanStr:(NSString *)zanStr
{
    _zanStr=zanStr;
    UILabel *label=(UILabel *)[self viewWithTag:106];
    label.text=zanStr;
    label.frame=FRAME(35, 10, 40, 10);
    _adoptBut.frame=FRAME(WIDTH-70, _zanBut.frame.origin.y, 60, 30);
    _adoptLabel.frame=FRAME(WIDTH-70, _zanBut.frame.origin.y, 60, 30);
    UILabel *linelabel=[[UILabel alloc]initWithFrame:FRAME(0, _adoptBut.frame.origin.y+40, WIDTH, 0.5)];
    linelabel.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    [self addSubview:linelabel];
    
}
-(NSString *)zanStr
{
    return _zanStr;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
