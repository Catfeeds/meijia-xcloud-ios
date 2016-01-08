//
//  JifenView.m
//  simi
//
//  Created by 赵中杰 on 14/12/11.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "JifenView.h"

@implementation JifenView
@synthesize delegate = _delegate;


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        for (int i = 0; i < 2; i ++) {
            UILabel *_label = [[UILabel alloc]initWithFrame:FRAME(0, 9+63*i, _CELL_WIDTH, 54)];
            _label.backgroundColor = COLOR_VAULE(255.0);
            [self addSubview:_label];
            
            UILabel *_leftlb1 = [[UILabel alloc]initWithFrame:FRAME(18+70*i, 9, 60, 54)];
            _leftlb1.font = MYFONT(13.5);
            [_leftlb1 setTag:(3000+i)];
            if (i == 0) {
                _leftlb1.text = @"当前积分:";
                _leftlb1.textColor = [self getColor:@"666666"];
            }else{
                _leftlb1.textColor = [self getColor:@"E8374A"];
                
            }
            
//            [_leftlb1 setTag:(200+i)];
            
            [self addSubview:_leftlb1];
        }

        UILabel *_rightlabel = [[UILabel alloc]initWithFrame:FRAME(_CELL_WIDTH-35-90, 9, 90, 54)];
        _rightlabel.font = MYFONT(13.5);
        _rightlabel.textColor = [self getColor:@"b1b1b1"];
        _rightlabel.textAlignment = NSTextAlignmentRight;
        _rightlabel.text = @"怎样获得积分";
        [self addSubview:_rightlabel];
        
        UIButton *_getjifenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _getjifenBtn.frame = FRAME(0, 9, _CELL_WIDTH, 54);
        [_getjifenBtn addTarget:self action:@selector(GetJifenPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_getjifenBtn];
        

    
        UIImageView *_rightview = [[UIImageView alloc]initWithFrame:FRAME(_CELL_WIDTH-18-7.5, 9+(54-16)/2, 7.5, 16)];
        [_rightview setImage:IMAGE_NAMED(@"s-right-arrow")];
        [self addSubview:_rightview];
        
        //7.5 16
        for (int i = 0; i < 4; i ++) {
            UIImageView *_lineview = [[UIImageView alloc]init];
            _lineview.backgroundColor = COLOR_VAULE(209.0);
            [self addSubview:_lineview];
            
            
            switch (i) {
                case 0:
                    _lineview.frame = FRAME(0, 9, _CELL_WIDTH, 0.5);
                    break;
                case 1:
                    _lineview.frame = FRAME(0, 9+53.5, _CELL_WIDTH, 0.5);
                    break;
                case 2:
                    _lineview.frame = FRAME(0, 9+9+53.5, _CELL_WIDTH, 0.5);
                    break;
                case 3:
                    _lineview.frame = FRAME(0, 9+9+107.5, _CELL_WIDTH, 0.5);
                    break;

                default:
                    break;
            }
        }
        
        NSArray *_btnArr = @[@"   积分兑换",@"   积分明细"];
        NSArray *_imgArr = @[@"integral-test_click",@"list-_01"];
        
        for (int i = 0; i < 2; i ++) {
            
            UIButton *_selectbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            _selectbutton.frame = FRAME((_CELL_WIDTH)/2*i, 9+63, (_CELL_WIDTH)/2, 54);
            [_selectbutton setTitle:[_btnArr objectAtIndex:i] forState:UIControlStateNormal];
            [_selectbutton setImage:IMAGE_NAMED([_imgArr objectAtIndex:i]) forState:UIControlStateNormal];
            [_selectbutton setTag:(300+i)];
            _selectbutton.titleLabel.font = MYFONT(13.5);
            if (i == 0) {
                [_selectbutton setTitleColor:[self getColor:@"E8374A"] forState:UIControlStateNormal];
            }else{
                [_selectbutton setTitleColor:[self getColor:@"666666"] forState:UIControlStateNormal];

            }
            [_selectbutton addTarget:self action:@selector(SelectBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_selectbutton];
            
        }
        
        UIImageView *_downLine = [[UIImageView alloc]initWithFrame:FRAME(0, 9+63+53, _CELL_WIDTH/2, 1)];
        _downLine.backgroundColor = [self getColor:@"E8374A"];
        [_downLine setTag:302];
        [self addSubview:_downLine];
    }
    
    return self;
}


- (void)setJifennum:(NSString *)jifennum
{
    _jifennum = jifennum;
    UILabel *_label = (UILabel *)[self viewWithTag:3001];
    _label.text = jifennum;

}

- (NSString *)jifennum
{
    return _jifennum;
    
}


#pragma mark 怎样获得积分
- (void)GetJifenPressed:(UIButton *)sender
{
    [self.delegate GetJifenBtn];
}


#pragma mark 积分明晰兑换按钮点击
- (void)SelectBtnPressed:(UIButton *)sender
{
    
    UIImageView *_imageview = (UIImageView *)[self viewWithTag:302];
    _imageview.frame = FRAME((_CELL_WIDTH/2)*(sender.tag-300), 9+63+53, _CELL_WIDTH/2, 1);
    
    if(sender.tag == 300){
        
        [self.delegate JifenMingxiOrDuihuan:@"duihuan"];
        
        UIButton *_button2 = (UIButton *)[self viewWithTag:301];

        [sender setTitleColor:[self getColor:@"E8374A"] forState:UIControlStateNormal];
        [sender setImage:IMAGE_NAMED(@"integral-test_click") forState:UIControlStateNormal];

        [_button2 setTitleColor:[self getColor:@"666666"] forState:UIControlStateNormal];
        [_button2 setImage:IMAGE_NAMED(@"list-_01") forState:UIControlStateNormal];
    }else{
        
        [self.delegate JifenMingxiOrDuihuan:@"mingxi"];

        
        UIButton *_button1 = (UIButton *)[self viewWithTag:300];

        [sender setTitleColor:[self getColor:@"E8374A"] forState:UIControlStateNormal];
        [sender setImage:IMAGE_NAMED(@"list-_click") forState:UIControlStateNormal];
        
        [_button1 setTitleColor:[self getColor:@"666666"] forState:UIControlStateNormal];
        [_button1 setImage:IMAGE_NAMED(@"integral-test_01") forState:UIControlStateNormal];

        
    }
    
    
}



@end
