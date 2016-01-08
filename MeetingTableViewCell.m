//
//  MeetingTableViewCell.m
//  simi
//
//  Created by 白玉林 on 15/8/13.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "MeetingTableViewCell.h"

@implementation MeetingTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        _view =[[UIView alloc]init];
        _view.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:_view];
        _hookImage=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-36, 21, 25, 25)];
        _hookImage.alpha=_hookImage.frame.size.width/2;
        [_view addSubview:_hookImage];
        _heideImage=[[UIImageView alloc]initWithFrame:FRAME(25, 14, 40, 40)];
        _heideImage.alpha=_heideImage.frame.size.width/2;
        [_view addSubview:_heideImage];
        _nameLabel=[[UILabel alloc]init];
        _nameLabel.frame=FRAME(_heideImage.frame.origin.x+_heideImage.frame.size.width+10, 12, _nameLabel.frame.size.width, 21);
        _nameLabel.font=[UIFont fontWithName:@"Arial" size:20];
        [_view addSubview:_nameLabel];
        _telephoneLabel=[[UILabel alloc]initWithFrame:FRAME(_heideImage.frame.origin.x+_heideImage.frame.size.width+10, 35, 132, 21)];
        _telephoneLabel.font=[UIFont fontWithName:@"Arial" size:20];
        [_view addSubview:_telephoneLabel];
        _view.frame=FRAME(0, 0, WIDTH, _heideImage.frame.size.height+24);
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
