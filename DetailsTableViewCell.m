//
//  DetailsTableViewCell.m
//  simi
//
//  Created by 白玉林 on 15/9/10.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "DetailsTableViewCell.h"

@implementation DetailsTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellView=[[UIView alloc]init];
        _cellView.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:_cellView];
        _nameLabel=[[UILabel alloc]init];
        [_nameLabel setNumberOfLines:1];
        [_nameLabel sizeToFit];
        _nameLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        _nameLabel.frame=FRAME(20, 10, _nameLabel.frame.size.width, 14);
        _nameLabel.textColor=[UIColor colorWithRed:189/255.0f green:189/255.0f blue:189/255.0f alpha:1];
        [_cellView addSubview:_nameLabel];
        
        _timeLabel=[[UILabel alloc]init];
        [_timeLabel setNumberOfLines:1];
        [_timeLabel sizeToFit];
        _timeLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        _timeLabel.frame=FRAME(self.frame.size.width-20-_timeLabel.frame.size.width, 10, _timeLabel.frame.size.width, 14);
        _timeLabel.textColor=[UIColor colorWithRed:189/255.0f green:189/255.0f blue:189/255.0f alpha:1];
        [_cellView addSubview:_timeLabel];
        
        _contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, _nameLabel.frame.size.height+_nameLabel.frame.origin.y+25/2, WIDTH-40, 14)];
         _contentLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        [_contentLabel setNumberOfLines:10];
        [_contentLabel sizeToFit];
        CGSize size = CGSizeMake(WIDTH-40, 1000);
        CGSize labelSize = [self.contentLabel.text sizeWithFont:self.contentLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
        _contentLabel.frame=CGRectMake(20, _nameLabel.frame.size.height+_nameLabel.frame.origin.y+25/2, WIDTH-40, labelSize.height);
        _contentLabel.font=[UIFont fontWithName:@"Arial" size:13];
        [_cellView addSubview:_contentLabel];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(10, _contentLabel.frame.size.height+_contentLabel.frame.origin.y+5, WIDTH-20, 1)];
        lineView.backgroundColor=[UIColor colorWithRed:189/255.0f green:189/255.0f blue:189/255.0f alpha:1];
        [_cellView addSubview:lineView];
        
        _cellView.frame=FRAME(0, 0, WIDTH, lineView.frame.origin.y+1);
        
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
