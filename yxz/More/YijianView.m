//
//  YijianView.m
//  simi
//
//  Created by 赵中杰 on 14/12/19.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "YijianView.h"

@interface YijianView ()
<UITextViewDelegate>
{
    UITextView *_mytextview;
    UILabel *_placehodel;
}

@end

@implementation YijianView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [self getColor:@"f5f5f5"];
        
        UILabel *_backlabel = [[UILabel alloc]initWithFrame:FRAME(0, 9, _CELL_WIDTH, 120)];
        _backlabel.backgroundColor = COLOR_VAULE(255.0);
        [self addSubview:_backlabel];
        
        _placehodel = [[UILabel alloc]initWithFrame:FRAME(21, 9+22, _CELL_WIDTH-42, 22)];
        _placehodel.numberOfLines = 0;
        _placehodel.font = MYFONT(13.5);
        _placehodel.textColor = [self getColor:@"b1b1b1"];
        _placehodel.text = @"请描述您的详情,我们会尽快帮您解决...";
        [self addSubview:_placehodel];
        
        _mytextview = [[UITextView alloc]initWithFrame:FRAME(18, 9+18, _CELL_WIDTH-36, 120-36)];
        _mytextview.font = MYFONT(13.5);
        _mytextview.delegate = self;
        _mytextview.backgroundColor = DEFAULT_COLOR;
        [self addSubview:_mytextview];
        
        
        
        UIButton *_shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.frame = FRAME(14, 23+120, WIDTH-28, 41);
        [_shareBtn setBackgroundColor:HEX_TO_UICOLOR(NAV_COLOR, 1.0)];
        [_shareBtn setTitle:@"提 交" forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = MYBOLD(15);
        _shareBtn.layer.cornerRadius = 5.0;
        _shareBtn.layer.masksToBounds = YES;
        [_shareBtn addTarget:self action:@selector(ShareToFriend) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_shareBtn];
        


    }
    
    return self;
}


#pragma mark 提交
- (void)ShareToFriend
{
    [self.delegate TijiaoYijianBtnPressed:_mytextview.text];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        [textView resignFirstResponder];//释放键盘
        return NO;
    }
    if (_mytextview.text.length==0){//textview长度为0
        if ([text isEqualToString:@""]) {//判断是否为删除键
            _placehodel.hidden=NO;//隐藏文字
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YIJIANTEXT" object:@""];

        }else{
            _placehodel.hidden=YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YIJIANTEXT" object:[NSString stringWithFormat:@"%@%@",_mytextview.text,text]];

        }
    }else{//textview长度不为0
        if (_mytextview.text.length==1){//textview长度为1时候
            if ([text isEqualToString:@""]) {//判断是否为删除键
                _placehodel.hidden=NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"YIJIANTEXT" object:@""];

            }else{//不是删除
                _placehodel.hidden=YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"YIJIANTEXT" object:[NSString stringWithFormat:@"%@%@",_mytextview.text,text]];

            }
        }else{//长度不为1时候
            _placehodel.hidden=YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YIJIANTEXT" object:[NSString stringWithFormat:@"%@%@",_mytextview.text,text]];

        }
    }
    

    
    return YES;
}


@end
