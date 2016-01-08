//
//  GetJifenView.m
//  simi
//
//  Created by 赵中杰 on 14/12/12.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "GetJifenView.h"

@implementation GetJifenView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = COLOR_VAULE(245.0);
        
        NSArray *_nameArr = @[@"     积分获得行为",@"     订单消费",@"     分享给好友",@"     完成评价"];
        NSArray *_titleArr = @[@"积分",@"5元=1分",@"10分",@"10分"];
        
        for (int i = 0; i < 4; i ++) {
            
            UILabel *_label = [[UILabel alloc]initWithFrame:FRAME(0, 9+54*i, _CELL_WIDTH, 54)];
            _label.backgroundColor = COLOR_VAULE(255.0);
            _label.font = MYFONT(13.5);
            _label.textColor = COLOR_VAULE(102.0);
//            if (i > 1) {
//                _label.frame = FRAME(0, 18+54*i, _CELL_WIDTH, 54);
//            }
            _label.text = [_nameArr objectAtIndex:i];
            
            [self addSubview:_label];

            
            UILabel *_label1 = [[UILabel alloc]initWithFrame:FRAME(_CELL_WIDTH*0.5, 9+54*i, _CELL_WIDTH*0.5-18, 54)];
            _label1.backgroundColor = COLOR_VAULE(255.0);
            _label1.font = MYFONT(13.5);
            _label1.textColor = COLOR_VAULE(102.0);
//            if (i > 1) {
//                _label1.frame = FRAME(_CELL_WIDTH*0.5, 18+54*i, _CELL_WIDTH*0.5-18, 54);
//            }
            _label1.text = [_titleArr objectAtIndex:i];
            if (i == 0) {
                _label1.textColor = COLOR_VAULE(178.0);
            }else{
                _label1.textColor = HEX_TO_UICOLOR(TEXT_COLOR, 1.0);
            }
            _label1.textAlignment = NSTextAlignmentRight;
            
            [self addSubview:_label1];
            
            
        }
        
        for (int i = 0; i < 2; i ++) {
            UIImageView *_lineview = [[UIImageView alloc]initWithFrame:FRAME(0, 9+108*i, _CELL_WIDTH, 0.5)];
            _lineview.backgroundColor = COLOR_VAULE(218.0);
            [self addSubview:_lineview];
            
            UIImageView *_lineview1 = [[UIImageView alloc]initWithFrame:FRAME(0, 63+108*i, _CELL_WIDTH, 0.5)];
            _lineview1.backgroundColor = COLOR_VAULE(218.0);
            [self addSubview:_lineview1];
            
            
            UIImageView *_lineview2 = [[UIImageView alloc]initWithFrame:FRAME(0, 117+108*i, _CELL_WIDTH, 0.5)];
            _lineview2.backgroundColor = COLOR_VAULE(218.0);
//            _lineview2.backgroundColor = [UIColor redColor];
            [self addSubview:_lineview2];
            

        }
        
        UILabel *_downlabel = [[UILabel alloc]initWithFrame:FRAME(18, 18+216+9, _CELL_WIDTH-36, 11)];
        _downlabel.font = MYFONT(10);
        _downlabel.textColor = COLOR_VAULE(178.0);
        _downlabel.text = @"注 :同一行为一天只获得一次积分";
        [self addSubview:_downlabel];
        
    }
    
    
    
    return self;
}

@end
