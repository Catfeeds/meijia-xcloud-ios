//
//  XiYiCell.m
//  simi
//
//  Created by zrj on 14-11-5.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "XiYiCell.h"
#import "ChoiceDefine.h"

@implementation XiYiCell


@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLab = [[UILabel alloc]initWithFrame:FRAME(50, 7, 150, 20)];
        self.titleLab.backgroundColor = DEFAULT_COLOR;
        self.titleLab.textColor = HEX_TO_UICOLOR(LABLE_COLOR, 1.0);
        self.titleLab.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.titleLab];
        
        self.img = [[UIImageView alloc]initWithFrame:FRAME(20, 54/2-7, 15, 15)];
        _img.image = [UIImage imageNamed:@"order-other"];
        [self addSubview:self.img];
        
        self.shichangLab = [[UILabel alloc]initWithFrame:FRAME(50, 22, 150, 20)];
        self.shichangLab.textColor = HEX_TO_UICOLOR(XIYI_LABLE_COLOR, 1.0);
        self.shichangLab.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.shichangLab];
        
        self.youhuiLab = [[UILabel alloc]initWithFrame:FRAME(50, 33, 150, 20)];
        self.youhuiLab.textColor = HEX_TO_UICOLOR(LABLE_COLOR, 1.0);
        self.youhuiLab.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.youhuiLab];
        
        self.yellowLab = [[UIView alloc]initWithFrame:FRAME(45, 32, 95, 0.5)];
        self.yellowLab.backgroundColor = HEX_TO_UICOLOR(ROUND_COLOR, 1.0);
        [self addSubview:self.yellowLab];
        
        self.zuoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.zuoBtn.frame = FRAME(self.bounds.size.width-18-30-3-47, 14, 47/2, 47/2);
        //    Cell.zuoBtn.tag = Cell.youBtn.tag =indexPath.row;
        [self.zuoBtn setBackgroundImage:[UIImage imageNamed:@"sub"] forState:UIControlStateNormal];
        [self.zuoBtn addTarget:self action:@selector(supAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.zuoBtn];
        
        self.youBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.youBtn.frame = FRAME(self.bounds.size.width-18-47/2, 14, 47/2, 47/2);
        //    Cell.youBtn.tag = indexPath.row+1000;
        [self.youBtn setBackgroundImage:[UIImage imageNamed:@"xiyiadd"] forState:UIControlStateNormal];
        
         [self.youBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.youBtn];
        
        self.shuziLab = [[UILabel alloc]initWithFrame:FRAME(self_Width-18-47/2-26-5, 22, 30, 10)];
        self.shuziLab.textAlignment = NSTextAlignmentCenter;
        self.shuziLab.text = @"0";
        //    Cell.shuziLab.tag = 10 + indexPath.row;
        //        self.shuziLab.text = [jianshuArray objectAtIndex:indexPath.row];
        self.shuziLab.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
        self.shuziLab.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.shuziLab];
        
// 自定义cell线
        self.xiaxian = [[UIView alloc]initWithFrame:FRAME(0, 108/2-0.5, self_Width, 0.5)];
        self.xiaxian.backgroundColor = HEX_TO_UICOLOR(CHOICE_BACK_VIEW_COLOR, 1.0);
        [self addSubview:self.xiaxian];
    }
    return self;
}

- (void)supAction:(UIButton *)btn
{
    [self.delegate cellDelegate:btn];
}
- (void)addAction:(UIButton *)btn
{
    [self.delegate cellDelegateTwo:btn];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
