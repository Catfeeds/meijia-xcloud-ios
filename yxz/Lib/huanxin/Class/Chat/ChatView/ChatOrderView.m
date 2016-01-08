//
//  ChatOrderView.m
//  simi
//
//  Created by 高鸿鹏 on 15/6/19.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "ChatOrderView.h"

@implementation ChatOrderView
{
    NSMutableArray *array;
    UIView *_backView ;
    UILabel *_lable;
}
@synthesize delegate =_delegate;

- (id)initWithFrame:(CGRect)frame withModel:(ChatModel *)chatmodel
{
    
    array = [[NSMutableArray alloc]initWithObjects:@"订单详情 ",
             [NSString stringWithFormat:@"下单时间: %@",chatmodel.add_time],
             [NSString stringWithFormat:@"服务类型: %@",chatmodel.service_type_name],
             [NSString stringWithFormat:@"内容: %@",chatmodel.service_content], nil];
    
    if (![chatmodel.service_time isEqualToString:@""]) {
        [array addObject:[NSString stringWithFormat:@"服务时间: %@",chatmodel.service_time]];
    }
    if (![chatmodel.service_addr isEqualToString:@""]) {
        [array addObject:[NSString stringWithFormat:@"服务地址: %@",chatmodel.service_addr]];
    }
    [array addObject:[NSString stringWithFormat:@"支付金额: %@",chatmodel.order_money]];
    NSLog(@"array:%@",array);
    

    self = [super initWithFrame:frame];
    if (self) {
        
        for (int i = 0 ; i < array.count+1; i++) {
            
            CGFloat y;
            CGFloat hight;
            CGFloat height ;
            
            y = i == 0? y = 30 : 30+50+(i-1)*40;
            hight = i == 0? 50 : 40;
            if (i < array.count) {
                height  =  [self heightForString:array[i] fontSize:12 andWidth:self_Width-20];
            }
            if (height > 40) {
                hight = height;
            }
            
            _backView = [[UIView alloc]init];
            _backView.backgroundColor = i == 0 ? HEX_TO_UICOLOR(0x4c5660, 1.0) : [UIColor whiteColor];
            if (i == array.count) {
                _backView.backgroundColor = HEX_TO_UICOLOR(BAC_VIEW_COLOR, 1.0);
            }
            _backView.frame = FRAME(0, 30, self_Width, hight);
            _backView.tag = i+1000;
            [self addSubview:_backView];
            if (i > 0) {
                UIView *bkView = (UIView *)[self viewWithTag:i+1000-1];
                _backView.frame = FRAME(0, bkView.bottom, self_Width, hight);
            }
            
            if (i > 0 && i < array.count-1) {
                UIView *xian = [[UIView alloc]init];
                xian.tag = i+100;
                xian.frame = FRAME(10, _backView.bottom-0.5, self_Width-20, 0.5);
                xian.backgroundColor = HEX_TO_UICOLOR(BAC_VIEW_COLOR, 1.0);
                if (xian.tag-100 == _backView.tag-1000) {
                [self addSubview:xian];

                }

            }
            
            if (i < array.count) {

                NSRange range = i == 3? NSMakeRange(0, 3) : NSMakeRange(0, 5);
                UIColor *color = i == 0? [UIColor whiteColor] : [UIColor grayColor];
                NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:array[i]];
                [text setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName, nil] range:range];
            
                _lable = [[UILabel alloc]init];
                _lable.tag = i;
                _lable.frame = FRAME(10, 0, self_Width-20, _backView.height);
                _lable.numberOfLines = 0;
//                _lable.text = array[i];
                _lable.attributedText = text;
                _lable.font = i == 0 ? [UIFont systemFontOfSize:14] :[UIFont systemFontOfSize:12];
                if (_backView.tag-1000 == _lable.tag) {
                    [_backView addSubview:_lable];
                }
            }else {
                for (int index = 0; index < 2; index++) {
                    UIButton *buton = [[UIButton alloc]init];
                    buton.tag = index;
                    buton.frame = FRAME(10+(index*(self_Width-20)/2), 0, (self_Width-20)/2, 40);
                    NSString *title = [chatmodel.order_money intValue] == 0? @"确认" : @"确认-支付";
                    if (buton.tag == 0) {
                        [buton setTitle:title forState:UIControlStateNormal];
                    }else{
                        [buton setTitle:@"取消" forState:UIControlStateNormal];
                    }
                    [buton setTitleColor:HEX_TO_UICOLOR(0x25a6fb, 1.0) forState:UIControlStateNormal];
                    buton.titleLabel.font = [UIFont systemFontOfSize:15];
                    [buton addTarget:self action:@selector(ButnAction:) forControlEvents:UIControlEventTouchUpInside];
                    [_backView addSubview:buton];
                }
                
            }
            
            
        }
            
    }
    return self;
}

- (void)ButnAction:(UIButton *)btn
{
    [self.delegate PressBtnwithBtnTitle:btn.currentTitle];
}
#pragma mark 返回字符串高度
- (CGSize)returnMysizeWithCgsize:(CGSize)mysize text:(NSString*)mystring font:(UIFont*)myfont
{
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:myfont,NSFontAttributeName, nil];
    CGSize size = [mystring boundingRectWithSize:mysize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    return size;
}
- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize]
                         constrainedToSize:CGSizeMake(width -16.0, CGFLOAT_MAX)
                             lineBreakMode:NSLineBreakByWordWrapping];
    //此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height + 16.0;
}

@end
