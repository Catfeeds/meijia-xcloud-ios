//
//  DressCell.m
//  simi
//
//  Created by zrj on 14-11-7.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "DressCell.h"
#import "ChoiceDefine.h"
@implementation DressCell
@synthesize nameLabel,btn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        nameLabel = [[UILabel alloc] initWithFrame:FRAME(16, 5, 320-82, self.frame.size.height)];
        [nameLabel setBackgroundColor:DEFAULT_COLOR];
        [nameLabel setFont:[UIFont systemFontOfSize:13]];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [nameLabel setTag:100];
        [self addSubview:nameLabel];
        
        
        UIView *xiaxian = [[UIView alloc]initWithFrame:FRAME(0, 108/2-0.5, self_Width, 0.5)];
        xiaxian.backgroundColor = HEX_TO_UICOLOR(CHOICE_BACK_VIEW_COLOR, 1.0);
        [self addSubview:xiaxian];
        
        btn = [[UIButton alloc]initWithFrame:FRAME(self_Width-60, 17, 40, 20)];
        [btn setTitle:@"默认" forState:UIControlStateNormal];
        [btn setTitleColor:HEX_TO_UICOLOR(TEXT_COLOR, 1.0) forState:UIControlStateNormal];
        [btn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.hidden = YES;
        [self addSubview:btn];
        

    }
    return self;
}


- (void)setMydata:(CUSTOMDRESSData *)mydata
{
    _mydata = mydata;
    
    UILabel *_namelabel = (UILabel *)[self viewWithTag:100];
    _namelabel.text = [NSString stringWithFormat:@"%@%@",mydata.cellname,mydata.addr];
    
}

- (CUSTOMDRESSData *)mydata
{
    return _mydata;
}



- (void) setEditing:(BOOL)editting animated:(BOOL)animated
{
    if (self.editing == editting)
    {
        return;
    }
    
    [super setEditing:editting animated:animated];
    
    if (editting)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
    }
    else
    {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.backgroundView = nil;
        
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
