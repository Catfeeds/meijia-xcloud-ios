//
//  AddOrderDiscussView.m
//  simi
//
//  Created by 赵中杰 on 14/12/15.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "AddOrderDiscussView.h"

@implementation AddOrderDiscussView
@synthesize delegate = _delegate;
@synthesize discussstatus = _discussstatus;
@synthesize _myfiled;
- (id)initWithFrame:(CGRect)frame serviceType:(NSString *)type startTime:(NSString *)startTime adress:(NSString *)adr
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = DEFAULT_COLOR;
        
        UILabel *_backlabel = [[UILabel alloc]initWithFrame:FRAME(0, 9, _CELL_WIDTH, 83*3)];
        _backlabel.backgroundColor = COLOR_VAULE(255.0);
        [self addSubview:_backlabel];
        
        for (int i = 0; i < 4; i ++) {
            UIImageView *_lineview = [[UIImageView alloc]initWithFrame:FRAME(0, 9+83*i, _CELL_WIDTH, 0.5)];
            _lineview.backgroundColor = COLOR_VAULE(218.0);
            [self addSubview:_lineview];
        }
        
        UIImageView *_headview = [[UIImageView alloc]initWithFrame:FRAME(18, 9+18, 48, 48)];
        [_headview setImage:IMAGE_NAMED(@"")];
        [_headview setTag:500];
        [self addSubview:_headview];

        NSString *leixing ;
        if ([type isEqualToString:@"1"]) {
            leixing = @"做饭";
            [_headview setImage:IMAGE_NAMED(@"index-zuofan")];
        }
        if ([type isEqualToString:@"2"]) {
            leixing = @"洗衣";
            [_headview setImage:IMAGE_NAMED(@"index-xiyi")];
        }
        if ([type isEqualToString:@"3"]) {
            leixing = @"家电清洗";
            [_headview setImage:IMAGE_NAMED(@"index-jiadianqingxi")];
        }
        if ([type isEqualToString:@"4"]) {
            leixing = @"保洁";
            [_headview setImage:IMAGE_NAMED(@"index-baojie")];
        }
        if ([type isEqualToString:@"5"]) {
            leixing = @"擦玻璃";
            [_headview setImage:IMAGE_NAMED(@"index-caboli")];
        }
        if ([type isEqualToString:@"6"]) {
            leixing = @"管道疏通";
            [_headview setImage:IMAGE_NAMED(@"index-guandaoshutong")];
        }
        if ([type isEqualToString:@"7"]) {
            leixing = @"新居开荒";
            [_headview setImage:IMAGE_NAMED(@"index-xinjukaihuang")];
        }
        
        
        
        
        
        
        for (int i = 0; i < 4; i ++) {
            
            UILabel *_headlabel = [[UILabel alloc]init];
            switch (i) {
                case 0:
        
                    _headlabel.text = leixing;
                    _headlabel.textColor = [self getColor:@"E8374A"];
                    _headlabel.font = MYFONT(13.5);
                    _headlabel.frame = FRAME(18+48+14, 9+18, 200, 14);
                    break;
                    
                case 1:
                    _headlabel.text = startTime;
                    _headlabel.textColor = [self getColor:@"666666"];
                    _headlabel.font = MYFONT(13.5);
                    _headlabel.frame = FRAME(18+48+14, 9+18+21, 160, 14);
                    break;

                case 2:
                    _headlabel.text = adr;
                    _headlabel.textColor = [self getColor:@"b1b1b1"];
                    _headlabel.font = MYFONT(10);
                    _headlabel.frame = FRAME(18+48+14, 9+18+21+21, 200, 11);
                    break;

                case 3:
                    _headlabel.text = @"已接单";
                    _headlabel.textColor = [self getColor:@"E8374A"];
                    _headlabel.font = MYFONT(13.5);
                    _headlabel.frame = FRAME(_CELL_WIDTH-18-60, 9, 60, 83);
                    _headlabel.textAlignment = NSTextAlignmentRight;
                    break;

                default:
                    break;
            }
            
            [self addSubview:_headlabel];
            
        }
        
        
        UILabel *_secondlabel = [[UILabel alloc]initWithFrame:FRAME(18, 9+83, 90, 83)];
        _secondlabel.textColor = [self getColor:@"666666"];
        _secondlabel.font = MYFONT(13.5);
        _secondlabel.text = @"总体评价 :";
        [self addSubview:_secondlabel];
        
        
        NSArray *_pingjiaArr = @[@"good_click-back@2X",@"common_01",@"bad_01"];
        NSArray *_pingjiaTextArr = @[@"赞",@"一般",@"心碎"];
        
        float _kongxi = (_CELL_WIDTH-90-36-126)/2+43;
        
        for (int i = 0; i < 3; i ++) {
            
            UIButton *_zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_zanBtn setTag:(510+i)];
            _zanBtn.frame = FRAME(18+90+_kongxi*i, 9+83+12.5, 43, 58);
            
            [_zanBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 15, 0)];
            _zanBtn.titleLabel.font = MYFONT(13.5);
            [_zanBtn setTitleEdgeInsets:UIEdgeInsetsMake(43, -43, 0, 0)];

            
            [_zanBtn setImage:IMAGE_NAMED([_pingjiaArr objectAtIndex:i]) forState:UIControlStateNormal];
            [_zanBtn setTitle:[_pingjiaTextArr objectAtIndex:i] forState:UIControlStateNormal];
            if (i == 0) {
                [_zanBtn setTitleColor:[self getColor:@"E8374A"] forState:UIControlStateNormal];
            }else{
                [_zanBtn setTitleColor:[self getColor:@"b1b1b1"] forState:UIControlStateNormal];
            }
            [_zanBtn addTarget:self action:@selector(SelectDiscuss:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_zanBtn];
            
            
        }
        
        _placehodel = [[UILabel alloc]initWithFrame:FRAME(21, 9+83*2+22, _CELL_WIDTH-42, 83-44)];
        _placehodel.numberOfLines = 0;
        _placehodel.font = MYFONT(13.5);
        _placehodel.textColor = [self getColor:@"b1b1b1"];
        _placehodel.text = @"亲,阿姨是否按时到达 ? 本次阿姨的服务态度怎么样 ? 是否在约定的时间内完成工作 ?";
        [self addSubview:_placehodel];
        
        _myfiled = [[UITextView alloc]initWithFrame:FRAME(18, 9+83*2+18, _CELL_WIDTH-36, 83-36)];
        _myfiled.font = MYFONT(13.5);
        _myfiled.delegate = self;
        _myfiled.backgroundColor = DEFAULT_COLOR;
        [self addSubview:_myfiled];
        
        
        
        
        UIButton *_shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.frame = FRAME(18, 23+83*3, _CELL_WIDTH-36, 54);
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


- (void)ShareToFriend
{
    [self.delegate adddiscussWithContent:_myfiled.text status:self.discussstatus];
}



-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        [textView resignFirstResponder];//释放键盘
        return NO;
    }
    if (_myfiled.text.length==0){//textview长度为0
        if ([text isEqualToString:@""]) {//判断是否为删除键
            _placehodel.hidden=NO;//隐藏文字
        }else{
            _placehodel.hidden=YES;
        }
    }else{//textview长度不为0
        if (_myfiled.text.length==1){//textview长度为1时候
            if ([text isEqualToString:@""]) {//判断是否为删除键
                _placehodel.hidden=NO;
            }else{//不是删除
                _placehodel.hidden=YES;
            }
        }else{//长度不为1时候
            _placehodel.hidden=YES;
        }
    }
    return YES;
}



#pragma mark 选择评价级别按钮
- (void)SelectDiscuss:(UIButton *)sender
{
    UIButton *_button1 = (UIButton *)[self viewWithTag:510];
    UIButton *_button2 = (UIButton *)[self viewWithTag:511];
    UIButton *_button3 = (UIButton *)[self viewWithTag:512];

    
    self.discussstatus = sender.tag - 510;
    
    if(sender.tag == 510){
        
        [_button1 setImage:IMAGE_NAMED(@"good_click-back@2X") forState:UIControlStateNormal];
        [_button1 setTitleColor:[self getColor:@"E8374A"] forState:UIControlStateNormal];
        
        [_button2 setImage:IMAGE_NAMED(@"common_01") forState:UIControlStateNormal];
        [_button2 setTitleColor:[self getColor:@"b1b1b1"] forState:UIControlStateNormal];
        
        [_button3 setImage:IMAGE_NAMED(@"bad_01") forState:UIControlStateNormal];
        [_button3 setTitleColor:[self getColor:@"b1b1b1"] forState:UIControlStateNormal];
        
    }else if (sender.tag == 511){
    
        [_button1 setImage:IMAGE_NAMED(@"good_01@2X") forState:UIControlStateNormal];
        [_button1 setTitleColor:[self getColor:@"b1b1b1"] forState:UIControlStateNormal];
        
        [_button2 setImage:IMAGE_NAMED(@"common_click-back") forState:UIControlStateNormal];
        [_button2 setTitleColor:[self getColor:@"E8374A"] forState:UIControlStateNormal];
        
        [_button3 setImage:IMAGE_NAMED(@"bad_01") forState:UIControlStateNormal];
        [_button3 setTitleColor:[self getColor:@"b1b1b1"] forState:UIControlStateNormal];

        
    }else if (sender.tag == 512){
     
        [_button1 setImage:IMAGE_NAMED(@"good_01@2X") forState:UIControlStateNormal];
        [_button1 setTitleColor:[self getColor:@"b1b1b1"] forState:UIControlStateNormal];
        
        [_button2 setImage:IMAGE_NAMED(@"common_01") forState:UIControlStateNormal];
        [_button2 setTitleColor:[self getColor:@"b1b1b1"] forState:UIControlStateNormal];
        
        [_button3 setImage:IMAGE_NAMED(@"bad_click-back") forState:UIControlStateNormal];
        [_button3 setTitleColor:[self getColor:@"E8374A"] forState:UIControlStateNormal];

        
    }
}

@end
