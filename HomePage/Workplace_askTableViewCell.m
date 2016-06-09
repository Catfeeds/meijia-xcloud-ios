//
//  Workplace_askTableViewCell.m
//  yxz
//
//  Created by 白玉林 on 16/6/3.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "Workplace_askTableViewCell.h"

@implementation Workplace_askTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        _moneyImag=[[UIImageView alloc]initWithFrame:FRAME(10, 10, 20, 20)];
        _moneyImag.layer.cornerRadius=_moneyImag.frame.size.width/2;
        _moneyImag.tag=101;
        _moneyImag.clipsToBounds=YES;
        [self addSubview:_moneyImag];
        
        _goldLabel=[[UILabel alloc]init];
        _goldLabel.textColor=[UIColor colorWithRed:234/255.0f green:149/255.0f blue:24/255.0f alpha:1];
        _goldLabel.tag=1101;
        _goldLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        [self addSubview:_goldLabel];
        
        _titleLabel=[[UILabel alloc]initWithFrame:FRAME(0, 0, WIDTH-70, 20)];
        _titleLabel.tag=1102;
        _titleLabel.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
        _titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:15];
        [self addSubview:_titleLabel];
        
        _timelabel=[[UILabel alloc]initWithFrame:FRAME(10, _titleLabel.frame.size.height+20, WIDTH-20, 15)];
        _timelabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
        _timelabel.tag=1103;
        _timelabel.textColor=[UIColor colorWithRed:157/255.0f green:157/255.0f blue:157/255.0f alpha:1];
        [self addSubview:_timelabel];
        
        UIView *lineView=[[UIView alloc]initWithFrame:FRAME(0, _timelabel.frame.origin.y+_timelabel.frame.size.height+10, WIDTH, 1)];
        lineView.tag=11111;
        lineView.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
        [self addSubview:lineView];
       
        _headeImage=[[UIImageView alloc]initWithFrame:FRAME(10, _timelabel.frame.origin.y+21, 30, 30)];
        _headeImage.tag=102;
        _headeImage.layer.cornerRadius=_headeImage.frame.size.width/2;
        _headeImage.clipsToBounds=YES;
        [self addSubview:_headeImage];
        
        _namelabel=[[UILabel alloc]initWithFrame:FRAME(_headeImage.frame.size.width+25, _headeImage.frame.origin.y+5, (WIDTH-110)/2, 20)];
        _namelabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        _namelabel.textColor=[UIColor colorWithRed:157/255.0f green:157/255.0f blue:157/255.0f alpha:1];
        _namelabel.tag=1104;
        [self addSubview:_namelabel];
        
        _textLabels=[[UILabel alloc]initWithFrame:FRAME(_namelabel.frame.size.width+_namelabel.frame.origin.x, _headeImage.frame.origin.y+5, (WIDTH-110)/2, 20)];
        _textLabels.font=[UIFont fontWithName:@"Heiti SC" size:15];
        _textLabels.tag=1105;
        _textLabels.textColor=[UIColor colorWithRed:157/255.0f green:157/255.0f blue:157/255.0f alpha:1];
        _textLabels.textAlignment=NSTextAlignmentRight;
        [self addSubview:_textLabels];
        
        UIView *verticalView=[[UIView alloc]initWithFrame:FRAME(WIDTH-70, _headeImage.frame.origin.y, 1, 30)];
        verticalView.tag=22222;
        verticalView.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
        [self addSubview:verticalView];
        
        _askButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-60, lineView.frame.origin.y+1, 60, 50)];
                
//        [askButton addTarget:self action:@selector(askAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_askButton];
    }
    return self;
}
-(void)setMoneyImagStr:(NSString *)moneyImagStr
{
    _moneyImagStr=moneyImagStr;
    UIImageView *imageView=(UIImageView *)[self viewWithTag:101];
    imageView.image=[UIImage imageNamed:moneyImagStr];
}
-(NSString *)moneyImagStr
{
    return _moneyImagStr;
}
-(void)setGoldLabelStr:(NSString *)goldLabelStr
{
    _goldLabelStr=goldLabelStr;
    int goldId=[_goldLabelStr intValue];
    UILabel *label=(UILabel *)[self viewWithTag:1101];
//    label.backgroundColor=[UIColor redColor];
    label.text=goldLabelStr;
    [label setNumberOfLines:1];
    [label sizeToFit];
    if (goldId==0) {
        label.hidden=YES;
    }else{
        label.hidden=NO;
    }
    label.frame=FRAME(35, 10, label.frame.size.width, 20);
}
-(NSString *)goldLabelStr
{
    return _goldLabelStr;
}
-(void)setTitleLabelStr:(NSString *)titleLabelStr
{
    int goldId=[_goldLabelStr intValue];
    _titleLabelStr=titleLabelStr;
    UILabel *label=(UILabel *)[self viewWithTag:1102];
    label.text=titleLabelStr;
    
    if (goldId==0) {
        UIFont *font=[UIFont fontWithName:@"Heiti SC" size:15];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        CGSize size = [label.text boundingRectWithSize:CGSizeMake(WIDTH-20, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        [label setNumberOfLines:0];
        [label sizeToFit];
        label.frame=FRAME(10, 10, WIDTH-20, size.height);
    }else{
        UIFont *font=[UIFont fontWithName:@"Heiti SC" size:15];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        CGSize size = [label.text boundingRectWithSize:CGSizeMake(WIDTH-70, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        [label setNumberOfLines:0];
        [label sizeToFit];
        label.frame=FRAME(60, 10, WIDTH-70, size.height);
    }
    
}
-(NSString *)titleLabelStr
{
    return _titleLabelStr;
}
-(void)setTimelabelStr:(NSString *)timelabelStr
{
    _timelabelStr=timelabelStr;
    UILabel *label=(UILabel *)[self viewWithTag:1103];
    label.text=timelabelStr;
    label.frame=FRAME(10, _titleLabel.frame.size.height+20, WIDTH-20, 15);
    
    UIView *view=(UIView *)[self viewWithTag:11111];
    view.frame=FRAME(0, _timelabel.frame.origin.y+_timelabel.frame.size.height+10, WIDTH, 0.5);
}
-(NSString *)timelabelStr
{
    return _timelabelStr;
}
-(void)setHeadeImageStr:(NSString *)headeImageStr
{
    _headeImageStr=headeImageStr;
    NSString *imageUrl=[NSString stringWithFormat:@"%@",headeImageStr];
    [_headeImage setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
//    UIImageView *imageView=(UIImageView *)[self viewWithTag:102];
//    imageView.image=[UIImage imageNamed:headeImageStr];
    _headeImage.frame=FRAME(10, _timelabel.frame.origin.y+36, 30, 30);
}
-(void)setNamelabelStr:(NSString *)namelabelStr
{
    _namelabelStr=namelabelStr;
    UILabel *label=(UILabel *)[self viewWithTag:1104];
    label.text=namelabelStr;
    label.frame=FRAME(_headeImage.frame.size.width+25, _timelabel.frame.origin.y+41, (WIDTH-135)/2, 20);
}
-(NSString *)namelabelStr
{
    return _namelabelStr;
}
-(void)setTextLabelsStr:(NSString *)textLabelsStr
{
    _textLabelsStr=textLabelsStr;
    UILabel *label=(UILabel *)[self viewWithTag:1105];
    UIView *view=(UIView *)[self viewWithTag:22222];
    label.text=textLabelsStr;
    label.frame=FRAME(_namelabel.frame.size.width+_namelabel.frame.origin.x, _namelabel.frame.origin.y, (WIDTH-135)/2, 20);
    _askButton.frame=FRAME(WIDTH-70, _timelabel.frame.origin.y+26, 70, 50);
//    _askButton.backgroundColor=[UIColor redColor];
    view.frame=FRAME(WIDTH-70, _timelabel.frame.origin.y+36, 1, 30);
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:FRAME(0, _askButton.frame.origin.y+50, WIDTH, 10)];
    lineLabel.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    [self addSubview:lineLabel];
}
-(NSString *)textLabelsStr
{
    return _textLabelsStr;
}

@end
