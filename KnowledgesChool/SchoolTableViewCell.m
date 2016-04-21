//
//  SchoolTableViewCell.m
//  yxz
//
//  Created by 白玉林 on 16/4/21.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "SchoolTableViewCell.h"

@implementation SchoolTableViewCell



-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initLayuot];
        
    }
    
    return self;
    
}

//初始化控件

-(void)initLayuot{
    
    _text = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, WIDTH-40 , 40)];
    
    [self addSubview:_text];
    
    _myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 80, 57)];
    
    [self addSubview:_myImageView];
    
    _nameTime = [[UILabel alloc] initWithFrame:CGRectMake(20 , 20, WIDTH-40, 40)];
    
    [self addSubview:_nameTime];
    
}



//赋值 and 自动换行,计算出cell的高度

-(void)setIntroductionText:(NSDictionary *)text{
    NSString *imageString=[NSString stringWithFormat:@"%@",[text objectForKey:@"thumbnail"]];
    if (imageString==nil||imageString==NULL||[imageString isEqualToString:@""]) {
        //获得当前cell高度
        _myImageView.hidden=YES;
        CGRect frame = [self frame];
        
        //文本赋值
        
        self.text.text =[text objectForKey:@"title"];
        self.text.font=[UIFont systemFontOfSize:15];
//        _text.backgroundColor=[UIColor redColor];
        //设置label的最大行数
        
        self.text.numberOfLines = 10;
        [self.text sizeToFit];
        CGSize size = CGSizeMake(WIDTH-130, 1000);
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil];
        //    CGSize labelSize = [self.text.text sizeWithFont:self.text.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
        CGSize labelSize = [self.text.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[text objectForKey:@"thumbnail"]];
        [_myImageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
        _myImageView.frame=FRAME(20, 20, 80, 57);
        self.text.frame = CGRectMake(110, 20, WIDTH-130, labelSize.height);
        _nameTime.font=[UIFont systemFontOfSize:12];
        _nameTime.textColor=[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
        self.nameTime.frame=FRAME(110, 30+_text.frame.size.height, WIDTH-130, 15);
//        _nameTime.backgroundColor=[UIColor blackColor];
        //计算出自适应的高度
        
        frame.size.height = labelSize.height+65;
        
        
        
        self.frame = frame;
    }else{
        //获得当前cell高度
        _myImageView.hidden=NO;
        CGRect frame = [self frame];
        
        //文本赋值
        
        self.text.text =[text objectForKey:@"title"];
        self.text.font=[UIFont systemFontOfSize:15];
//        _text.backgroundColor=[UIColor redColor];
        //设置label的最大行数
        
        self.text.numberOfLines = 10;
        [self.text sizeToFit];
        CGSize size = CGSizeMake(WIDTH-130, 1000);
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil];
        //    CGSize labelSize = [self.text.text sizeWithFont:self.text.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
        CGSize labelSize = [self.text.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[text objectForKey:@"thumbnail"]];
        [_myImageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
        _myImageView.frame=FRAME(WIDTH-100, 20, 80, 57);
        self.text.frame = CGRectMake(20, 20, WIDTH-130, labelSize.height);
        NSArray *viewsArray=[[text objectForKey:@"custom_fields"]objectForKey:@"views"];
        self.nameTime.text=[NSString stringWithFormat:@"%@人已看过",viewsArray[0]];
        _nameTime.font=[UIFont systemFontOfSize:12];
        self.nameTime.frame=FRAME(20, 30+_text.frame.size.height, WIDTH-130, 15);
        _nameTime.textColor=[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
//        _nameTime.backgroundColor=[UIColor blackColor];
        //计算出自适应的高度
        if ((labelSize.height+65)>120) {
            frame.size.height = labelSize.height+65;
        }else{
            frame.size.height = 120;
        }
        
        
        
        UIView *lineView=[[UIView alloc]initWithFrame:FRAME(20, frame.size.height-1, WIDTH-40, 0.5)];
        lineView.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
        [self addSubview:lineView];
        
        self.frame = frame;

    }
   
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated

{  
    
    [super setSelected:selected animated:animated];  
    
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
