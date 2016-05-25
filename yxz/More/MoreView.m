//
//  MoreView.m
//  simi
//
//  Created by 赵中杰 on 14/11/28.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "MoreView.h"

@implementation MoreView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        NSArray *_titleArr = @[@"用户协议",@"分享好友",@"意见反馈",@"关于我们",@"当前版本",@"联系客服",@"清理缓存"];
        
        
        for (int i = 0; i < _titleArr.count; i ++) {
            

            
            
            UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
            [_button setBackgroundColor:COLOR_VAULE(255.0)];
            [_button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [_button setTitle:[_titleArr objectAtIndex:i] forState:UIControlStateNormal];
            [_button setTitleColor:[self getColor:@"666666"] forState:UIControlStateNormal];
            _button.titleLabel.font = MYFONT(13.5);
            [_button setImage:IMAGE_NAMED(@"s-right-arrow") forState:UIControlStateNormal];
            [_button setTitleEdgeInsets:UIEdgeInsetsMake(0, 9, 0, 0)];
            [_button setImageEdgeInsets:UIEdgeInsetsMake(17, _CELL_WIDTH-18-20, 17, 18)];
            [_button setTag:400+i];
            [_button addTarget:self action:@selector(SelectBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            switch (i) {
                case 0:
                    _button.frame = FRAME(0, 9, _CELL_WIDTH, 54);
                    break;
                case 1:
                    _button.frame = FRAME(0, 9+54, _CELL_WIDTH, 54);
                    break;
                case 2:
                    _button.frame = FRAME(0, 18+54*2, _CELL_WIDTH, 54);
                    break;
                case 3:
                    _button.frame = FRAME(0, 18+54*3, _CELL_WIDTH, 54);
                    break;
                case 4:
                    _button.frame = FRAME(0, 27+54*4, _CELL_WIDTH, 54);
                    break;
                case 5:
                    _button.frame = FRAME(0, 27+54*5, _CELL_WIDTH, 54);
                    break;
                case 6:
                    _button.frame = FRAME(0, 36+54*6, _CELL_WIDTH, 54);
                    break;
                    
                default:
                    break;
            }
            
            [self addSubview:_button];
            
            if (i == 4) {
                NSString *editionStr=[NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
                UIButton *_phonebutton = [UIButton buttonWithType:UIButtonTypeCustom];
                _phonebutton.frame = FRAME(_CELL_WIDTH-100-12, 27+54*4, 100, 54);
                _phonebutton.titleLabel.font = MYFONT(13.5);
                [_phonebutton setTitleColor:HEX_TO_UICOLOR(TEXT_COLOR, 1.0) forState:UIControlStateNormal];
                [_phonebutton setTitle:editionStr forState:UIControlStateNormal];
                [self addSubview:_phonebutton];
                [_button setImage:IMAGE_NAMED(@"") forState:UIControlStateNormal];
                [_button setTitleEdgeInsets:UIEdgeInsetsMake(0, 31, 0, 0)];
            }
            if (i == 5) {
                UILabel *_phonebutton = [[UILabel alloc]init];;
                _phonebutton.frame = FRAME(_CELL_WIDTH-36-100, 27+54*5, 100, 54);
                _phonebutton.font = MYFONT(13.5);
//                [_phonebutton setTitleColor:HEX_TO_UICOLOR(TEXT_COLOR, 1.0) forState:UIControlStateNormal];
//                [_phonebutton setTitle:@"400-169-1615" forState:UIControlStateNormal];
                _phonebutton.textColor=HEX_TO_UICOLOR(TEXT_COLOR, 1.0);
                _phonebutton.text=@"400-169-1615";
                [_button addTarget:self action:@selector(PhoneBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_phonebutton];
            }
            
            
        }
        
        for (int i = 0; i < 3; i ++) {
            UIImageView *_lineview1 = [[UIImageView alloc]initWithFrame:FRAME(0, 9+117*i, _CELL_WIDTH, 0.5)];
            _lineview1.backgroundColor = COLOR_VAULE(209.0);
            [self addSubview:_lineview1];
            
            UIImageView *_lineview2 = [[UIImageView alloc]initWithFrame:FRAME(0, 9+54+117*i, _CELL_WIDTH, 0.5)];
            _lineview2.backgroundColor = COLOR_VAULE(209.0);
            [self addSubview:_lineview2];
            
            if (i < 3) {
                UIImageView *_lineview3 = [[UIImageView alloc]initWithFrame:FRAME(0, 9+108+117*i, _CELL_WIDTH, 0.5)];
                _lineview3.backgroundColor = COLOR_VAULE(209.0);
                [self addSubview:_lineview3];
            }
        }
        
    }
    
    return self;
}

- (void)checkBtnPressed:(UIButton *)sender
{
    [self.delegate selectWhichControllerToPushWithTag:404];
    
}

#pragma mark 选择按钮
- (void)SelectBtnPressed:(UIButton *)sender
{
    
    [self.delegate selectWhichControllerToPushWithTag:sender.tag];
}

- (void)PhoneBtnPressed:(UIButton *)sender
{
    [self.delegate telephoneBtn];
}


@end
