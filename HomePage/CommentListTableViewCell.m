//
//  CommentListTableViewCell.m
//  yxz
//
//  Created by 白玉林 on 16/5/19.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "CommentListTableViewCell.h"

@implementation CommentListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        _headImageView=[[UIImageView alloc]initWithFrame:FRAME(10, 12, 30, 30)];
        _headImageView.layer.cornerRadius=30/2;
        _headImageView.clipsToBounds=YES;
        [self addSubview:_headImageView];
        _nameLabel=[[UILabel alloc]initWithFrame:FRAME(50, 12, WIDTH-60, 15)];
        NSString *nametags=[NSString stringWithFormat:@"11%d",_cellTag];
        _nameLabel.tag=[nametags intValue];
        _nameLabel.font=[UIFont fontWithName:@"" size:14];
        [self addSubview:_nameLabel];
        
        _timeLabel=[[UILabel alloc]initWithFrame:FRAME(50, 32, WIDTH-60, 15)];
        NSString *timetags=[NSString stringWithFormat:@"22%d",_cellTag];
        _timeLabel.tag=[timetags intValue];
        _timeLabel.font=[UIFont fontWithName:@"" size:10];
        [self addSubview:_timeLabel];
        
        _texLabel=[[UILabel alloc]initWithFrame:FRAME(50, 60, WIDTH-60, 15)];
        NSString *texttags=[NSString stringWithFormat:@"33%d",_cellTag];
        _texLabel.tag=[texttags intValue];
        _texLabel.font=[UIFont fontWithName:@"" size:10];
        [self addSubview:_texLabel];
    }
    return self;
}

//-(void)setNameString:(NSString *)nameString
//{
//    _nameString = nameString;
//    NSString *tags=[NSString stringWithFormat:@"11%d",_cellTag];
//    int tag=[tags intValue];
//    UILabel *_label = (UILabel *)[self viewWithTag:tag];
//    //_label.frame=FRAME(90, 5, WIDTH-95, 30);
//    _label.text = nameString;
//}
//-(NSString *)nameString
//{
//    return _nameString;
//}
//-(void)setTimeString:(NSString *)timeString
//{
//    NSString *tags=[NSString stringWithFormat:@"22%d",_cellTag];
//    int tag=[tags intValue];
//    _timeString = timeString;
//    UILabel *_label = (UILabel *)[self viewWithTag:tag];
//    //_label.frame=FRAME(90, 5, WIDTH-95, 30);
//    _label.text = timeString;
//}
//-(NSString *)timeString
//{
//    return _timeString;
//}
//
//-(void)setTextString:(NSString *)textString
//{
//    NSString *tags=[NSString stringWithFormat:@"33%d",_cellTag];
//    int tag=[tags intValue];
//    _textString = textString;
//    UILabel *_label = (UILabel *)[self viewWithTag:tag];
//    //_label.frame=FRAME(90, 5, WIDTH-95, 30);
//    _label.text = textString;
//    UIFont *font=[UIFont fontWithName:@"Heiti SC" size:18];
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
//    CGSize size = [textString boundingRectWithSize:CGSizeMake(WIDTH-60, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
//    [_label setNumberOfLines:0];
//    [_label sizeToFit];
//    _label.frame=FRAME(50, 60, WIDTH-60, size.height);
//    _gaodu=71+size.height;
//}
//
//-(NSString *)textString
//{
//    return _textString;
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
