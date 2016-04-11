//
//  DynamicTableViewCell.m
//  yxz
//
//  Created by 白玉林 on 15/12/26.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "DynamicTableViewCell.h"

@implementation DynamicTableViewCell
{
    int H;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _layoutView=[[UIView alloc]init];
        _layoutView.backgroundColor=[UIColor whiteColor];//[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1]
        _headeImageView=[[UIImageView alloc]initWithFrame:FRAME(18, 10, 40, 40)];
        _headeImageView.layer.cornerRadius=_headeImageView.frame.size.width/2;
        _headeImageView.layer.masksToBounds=YES;
        [_layoutView addSubview:_headeImageView];
        
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.text=@"";
        _titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        [_titleLabel setNumberOfLines:1];
        [_titleLabel sizeToFit];
        _titleLabel.textAlignment=NSTextAlignmentLeft;
        _titleLabel.frame=FRAME(_headeImageView.frame.size.width+28, 10, _titleLabel.frame.size.width, 20);
        [_layoutView addSubview:_titleLabel];
        
        _timeLabel=[[UILabel alloc]init];
        _timeLabel.text=@"";
        _timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        _timeLabel.textColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
        _timeLabel.textAlignment=NSTextAlignmentLeft;
        _timeLabel.frame=FRAME(_titleLabel.frame.origin.x, _titleLabel.frame.size.height+_titleLabel.frame.origin.y, _timeLabel.frame.size.width, 20);
        [_layoutView addSubview:_timeLabel];
        
        UIView *lineView=[[UIView alloc]initWithFrame:FRAME(0, _timeLabel.frame.origin.y+_timeLabel.frame.size.height+10, WIDTH, 1)];
        lineView.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
        [_layoutView addSubview:lineView];
        
        _textLabels=[[UILabel alloc]init];
//        textLabel.text=_textString;
        [_textLabels setNumberOfLines:0];
        _textLabels.lineBreakMode=NSLineBreakByWordWrapping;
        [_textLabels sizeToFit];
        UIFont *font=[UIFont fontWithName:@"Heiti SC" size:17];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        CGSize size = [_textLabels.text boundingRectWithSize:CGSizeMake(WIDTH-40, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        _textLabels.frame=FRAME(20, lineView.frame.size.height+lineView.frame.origin.y+10, WIDTH-40, size.height);
        [_layoutView addSubview:_textLabels];
        
        _layoutView.frame=FRAME(0, 0, WIDTH, _textLabels.frame.size.height+_textLabels.frame.origin.y+60);
        [self addSubview:_layoutView];
    }
    return self;
}

-(void)setIntroductionText:(NSString*)text{
    
    //获得当前cell高度
    
    CGRect frame = [self frame];
    
    
    //计算出自适应的高度
    
    frame.size.height = _layoutView.frame.origin.y+_layoutView.frame.size.height;
    
    
    
    self.frame = frame;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
