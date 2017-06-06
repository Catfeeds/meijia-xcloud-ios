//
//  CancelOrderCell.m
//  simi
//
//  Created by 赵中杰 on 14/12/20.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "CancelOrderView.h"
#import "OrderTime.h"
@implementation CancelOrderView
#define CELL_HEIGHT 82        //  cell高度
#define IMAGE_XY 46             //头像宽度
#define X_S 18                //  头像距离屏幕左边距
#define Y_S 18                //  头像距离屏幕上边距
#define TEXT_X 14             //  文字距离头像右边距
#define TEXT_Y 20             //  文字距离屏幕上边距
#define DTEXT_U 9             //  第二行文字距离第一行文字边距


@synthesize delegate = _delegate;


- (id)initWithFrame:(CGRect)frame ordelListData:(ORDERLISTData *)listdata
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = DEFAULT_COLOR;
        OrderTime *timeData = [[OrderTime alloc]init];
        
        UILabel *_backlabel = [[UILabel alloc]initWithFrame:FRAME(0, 0, _CELL_WIDTH, 82)];
        _backlabel.backgroundColor = COLOR_VAULE(255.0);
        [self addSubview:_backlabel];
        
        //   头像
        
        NSArray *imageArray = [[NSArray alloc]initWithObjects:@"index-zuofan",@"index-xiyi",@"index-jiadianqingxi",@"index-baojie",@"index-caboli",@"index-guandaoshutong",@"index-xinjukaihuang", nil];
        
        int servetype = (int)listdata.serviceType;
        
        UIImageView *_headimageView = [[UIImageView alloc]initWithFrame:FRAME(X_S, Y_S, CELL_HEIGHT-Y_S*2, CELL_HEIGHT-Y_S*2)];
        [_headimageView setTag:100];
        [_headimageView setImage:IMAGE_NAMED([imageArray objectAtIndex:servetype - 1])];
        [self addSubview:_headimageView];
        
        
        //   三个label
        for (int i = 0; i < 3; i ++) {
            
            UILabel *_label = [[UILabel alloc]init];
            _label.backgroundColor = DEFAULT_COLOR;
            [_label setTag:101+i];
            
            switch (i) {
                case 0:
                    _label.textColor = [self getColor:@"E8374A"];
                    _label.font = MYFONT(13.5);
                    _label.adjustsFontSizeToFitWidth = YES;
                    int _status = (int)listdata.orderStatus;
                    switch (_status) {
                        case 0:
                            _label.text = @"已取消";
                            break;
                        case 1:
                            _label.text = @"待支付";
                            break;
                        case 2:
                            _label.text = @"已支付";
                            
                            //判断当前时间和服务结束时间
                            BOOL time1 = [timeData TimeOutWith:[self getTimeWithstring:listdata.startTime] hours:[[NSString stringWithFormat:@"%f",listdata.serviceHours] integerValue]];
                            NSLog(@"%@",[self getTimeWithstring:listdata.startTime]);
                            
                            //判断当前时间和服务开始时间
                            BOOL time2 = [timeData TimeOutWith:[self getTimeWithstring:listdata.startTime] hours:0];
                            
                            if (time1 == NO && time2 == YES) {
                                
                                _label.text = @"即将服务";
                            }
                            if (time1 == YES) {
                                
                                _label.text = @"待评价";
                            }
                            if (time2 == NO){
                                
                                _label.text = @"待服务";
                            }
                            
                            break;
                        case 3:
                            _label.text = @"待服务";
                            break;
                        case 4:
                            _label.text = @"即将服务";
                            break;
                        case 5:
                            _label.text = @"待评价";
                            break;
                        case 6:
                            _label.text = @"已完成";
                            break;
                        case 7:
                            _label.text = @"已关闭";
                            break;
                            
                            
                        default:
                            break;
                    }
                    
                    _label.frame = FRAME(X_S+IMAGE_XY+TEXT_X, TEXT_Y, 120, 14);
                    break;
                    
                case 1:
                    _label.textColor = [self getColor:@"b1b1b1"];
                    _label.font = MYFONT(13.5);
                    _label.adjustsFontSizeToFitWidth = YES;
                    _label.text = [self getTimeWithstring:listdata.addTime];
                    _label.frame = FRAME(X_S+IMAGE_XY+TEXT_X, TEXT_Y+21, 160, 12);
                    if (listdata.orderStatus == 4) {
                        _label.frame = FRAME(X_S+IMAGE_XY+TEXT_X, TEXT_Y+20, 160, 12);
                    }
                    if (listdata.orderStatus == 2 || listdata.orderStatus == 3) {
                        
                        BOOL time1 = [timeData TimeOutWith:[self getTimeWithstring:listdata.startTime] hours:[[NSString stringWithFormat:@"%f",listdata.serviceHours] integerValue]];
                        if (time1 == YES) {
                            _label.frame = FRAME(X_S+IMAGE_XY+TEXT_X, TEXT_Y+60, 160, 12);
                        }
                    }
                    break;
                    
                case 2:
                    _label.textColor = [self getColor:@"b1b1b1"];
                    _label.font = MYFONT(10);
                    _label.frame = FRAME(X_S+IMAGE_XY+TEXT_X, TEXT_Y+14+26, _CELL_WIDTH-X_S+IMAGE_XY+TEXT_X-65, 10);
                    
                    if (listdata.orderStatus == 2 || listdata.orderStatus == 3) {
                        
                        BOOL time1 = [timeData TimeOutWith:[self getTimeWithstring:listdata.startTime] hours:[[NSString stringWithFormat:@"%f",listdata.serviceHours] integerValue]];
                        if (time1 == YES) {
                            _label.frame = FRAME(X_S+IMAGE_XY+TEXT_X, TEXT_Y+80, _CELL_WIDTH-X_S+IMAGE_XY+TEXT_X-65, 10);
                        }
                    }
                    if (listdata.orderStatus == 4) {
                        _label.frame = FRAME(X_S+IMAGE_XY+TEXT_X, TEXT_Y+40, _CELL_WIDTH-X_S+IMAGE_XY+TEXT_X-65, 10);
                    }

                    _label.text = [NSString stringWithFormat:@"%@%@",listdata.name,listdata.addstr];
                    break;
                    
                    
                default:
                    break;
            }
            
            [self addSubview:_label];
        }
        
        
        
        //     订单取消按钮
        UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = FRAME(_CELL_WIDTH-68, TEXT_Y+10, 50, 25);
        [_button setBackgroundImage:IMAGE_NAMED(@"circle_@2x") forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:13.5];
        [_button setTitle:@"取消" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(ButtonPressedWithButtonTitle:) forControlEvents:UIControlEventTouchUpInside];
        [_button setTitleColor:[self getColor:@"E8374A"] forState:UIControlStateNormal];
        [_button setTag:104];
        
        int _status = (int)listdata.orderStatus;
        if (_status == 1 || _status == 4) {
            _button.hidden = NO;
            if (_status == 4) {
                [_button setTitle:@"评价" forState:UIControlStateNormal];
            }
            if (_status == 1){
                [_button setTitle:@"支付" forState:UIControlStateNormal];
            }
        }else if (_status == 2||_status == 3){
            //判断当前时间和服务结束时间
            BOOL time1 = [timeData TimeOutWith:[self getTimeWithstring:listdata.startTime] hours:[[NSString stringWithFormat:@"%f",listdata.serviceHours] integerValue]];

            if (time1 == YES) {
                [_button setTitle:@"评价" forState:UIControlStateNormal];
            }
        }
        else{
            _button.hidden = YES;
        }
        
        
        [self addSubview:_button];
        
        
        UIImageView *_lineView = [[UIImageView alloc]initWithFrame:FRAME(0, 81.5, _CELL_WIDTH, 0.5)];
        _lineView.backgroundColor = COLOR_VAULE(209.0);
        [self addSubview:_lineView];
        
        UILabel *lable = (UILabel *)[self viewWithTag:101];
        if ([lable.text isEqualToString:@"即将服务"]) {
            
//            UILabel *_tishilabel = [[UILabel alloc]initWithFrame:FRAME(X_S+IMAGE_XY+TEXT_X, Y_S+20, _CELL_WIDTH-X_S-IMAGE_XY-TEXT_X-86, 25)];
//            _tishilabel.text = @"请您及时为本次服务作出评价,还有10积分拿哦!";
//            _tishilabel.font = MYFONT(10);
//            _tishilabel.numberOfLines = 0;
//            _tishilabel.lineBreakMode = NSLineBreakByWordWrapping;
//            _tishilabel.textColor = COLOR_VAULE(77.0);
//            [self addSubview:_tishilabel];
            
//            UILabel *_linelabel = [[UILabel alloc]initWithFrame:FRAME(X_S+(CELL_HEIGHT-Y_S*2)*0.5-0.5, Y_S+(CELL_HEIGHT-Y_S*2), 0.5, 32)];
//            _linelabel.backgroundColor = COLOR_VAULE(144.0);
//            [self addSubview:_linelabel];
            
            

            UILabel *_linelabel = [[UILabel alloc]initWithFrame:FRAME(X_S+(CELL_HEIGHT-Y_S*2)*0.5-0.5, Y_S+(CELL_HEIGHT-Y_S*2), 0.5, 32)];
            _linelabel.backgroundColor = COLOR_VAULE(144.0);
            [self addSubview:_linelabel];
            
            UILabel *_dianlabel = [[UILabel alloc]initWithFrame:FRAME(X_S+(CELL_HEIGHT-Y_S*2)*0.5-2.5, Y_S+(CELL_HEIGHT-Y_S*2)+32, 4, 4)];
            _dianlabel.backgroundColor = COLOR_VAULE(144.0);
            _dianlabel.layer.cornerRadius = 2;
            _dianlabel.layer.masksToBounds = YES;
            [self addSubview:_dianlabel];
            
            UILabel *_statuslabel = [[UILabel alloc]init];
            _statuslabel.backgroundColor = DEFAULT_COLOR;
            _statuslabel.textColor = [self getColor:@"E8374A"];
            _statuslabel.font = MYFONT(13.5);
            _statuslabel.adjustsFontSizeToFitWidth = YES;
            _statuslabel.text = @"已付款";
            _statuslabel.frame = FRAME(X_S+IMAGE_XY+TEXT_X, Y_S+(CELL_HEIGHT-Y_S*2)+25, 100, 14);
            [self addSubview:_statuslabel];
            
            _backlabel.frame = FRAME(0, 0, _CELL_WIDTH, 115);
            _lineView.frame = FRAME(0, 115, _CELL_WIDTH, 0.5);
            

        }
        
        
        if (listdata.orderStatus == 2 || listdata.orderStatus == 3) {
            
            BOOL time1 = [timeData TimeOutWith:[self getTimeWithstring:listdata.startTime] hours:[[NSString stringWithFormat:@"%f",listdata.serviceHours] integerValue]];
            if (time1 == YES) {
                
                UILabel *_tishilabel = [[UILabel alloc]initWithFrame:FRAME(X_S+IMAGE_XY+TEXT_X, Y_S+20, _CELL_WIDTH-X_S-IMAGE_XY-TEXT_X-86, 25)];
                _tishilabel.text = @"请您及时为本次服务作出评价,还有10积分拿哦!";
                _tishilabel.font = MYFONT(10);
                _tishilabel.numberOfLines = 0;
                _tishilabel.lineBreakMode = NSLineBreakByWordWrapping;
                _tishilabel.textColor = COLOR_VAULE(77.0);
                [self addSubview:_tishilabel];
                
                UILabel *_linelabel = [[UILabel alloc]initWithFrame:FRAME(X_S+(CELL_HEIGHT-Y_S*2)*0.5-0.5, Y_S+(CELL_HEIGHT-Y_S*2), 0.5, 108)];
                _linelabel.backgroundColor = COLOR_VAULE(144.0);
                [self addSubview:_linelabel];
                
                for (int i = 0; i < 2; i ++) {
                    
                    UILabel *_dianlabel = [[UILabel alloc]initWithFrame:FRAME(X_S+(CELL_HEIGHT-Y_S*2)*0.5-2.5, Y_S+(CELL_HEIGHT-Y_S*2)+67+41*i, 4, 4)];
                    _dianlabel.backgroundColor = COLOR_VAULE(144.0);
                    _dianlabel.layer.cornerRadius = 2;
                    _dianlabel.layer.masksToBounds = YES;
                    [self addSubview:_dianlabel];
                    
                    
                    UILabel *_statuslabel = [[UILabel alloc]init];
                    _statuslabel.backgroundColor = DEFAULT_COLOR;
                    _statuslabel.textColor = [self getColor:@"E8374A"];
                    _statuslabel.font = MYFONT(13.5);
                    _statuslabel.adjustsFontSizeToFitWidth = YES;
                    if (i == 0) {
                        _statuslabel.text = @"已服务";
                    }else{
                        _statuslabel.text = @"已付款";
                    }
                    _statuslabel.frame = FRAME(X_S+IMAGE_XY+TEXT_X, Y_S+(CELL_HEIGHT-Y_S*2)+62+45*i, 100, 14);
                    [self addSubview:_statuslabel];

                }
                
            
                _backlabel.frame = FRAME(0, 0, _CELL_WIDTH, 195);
                _lineView.frame = FRAME(0, 194.5, _CELL_WIDTH, 0.5);
                return self;
            }
            
        }
        
        
        if (listdata.orderStatus == 3) {
            UILabel *_linelabel = [[UILabel alloc]initWithFrame:FRAME(X_S+(CELL_HEIGHT-Y_S*2)*0.5-0.5, Y_S+(CELL_HEIGHT-Y_S*2), 0.5, 32)];
            _linelabel.backgroundColor = COLOR_VAULE(144.0);
            [self addSubview:_linelabel];
            
            UILabel *_dianlabel = [[UILabel alloc]initWithFrame:FRAME(X_S+(CELL_HEIGHT-Y_S*2)*0.5-2.5, Y_S+(CELL_HEIGHT-Y_S*2)+32, 4, 4)];
            _dianlabel.backgroundColor = COLOR_VAULE(144.0);
            _dianlabel.layer.cornerRadius = 2;
            _dianlabel.layer.masksToBounds = YES;
            [self addSubview:_dianlabel];
            
            UILabel *_statuslabel = [[UILabel alloc]init];
            _statuslabel.backgroundColor = DEFAULT_COLOR;
            _statuslabel.textColor = [self getColor:@"E8374A"];
            _statuslabel.font = MYFONT(13.5);
            _statuslabel.adjustsFontSizeToFitWidth = YES;
            _statuslabel.text = @"已付款";
            _statuslabel.frame = FRAME(X_S+IMAGE_XY+TEXT_X, Y_S+(CELL_HEIGHT-Y_S*2)+25, 100, 14);
            [self addSubview:_statuslabel];
            
            _backlabel.frame = FRAME(0, 0, _CELL_WIDTH, 115);
            _lineView.frame = FRAME(0, 115, _CELL_WIDTH, 0.5);
            
        }
       //gao
       
        if ([lable.text isEqualToString:@"待服务"]) {
            UILabel *_linelabel = [[UILabel alloc]initWithFrame:FRAME(X_S+(CELL_HEIGHT-Y_S*2)*0.5-0.5, Y_S+(CELL_HEIGHT-Y_S*2), 0.5, 32)];
            _linelabel.backgroundColor = COLOR_VAULE(144.0);
            [self addSubview:_linelabel];
            
            UILabel *_dianlabel = [[UILabel alloc]initWithFrame:FRAME(X_S+(CELL_HEIGHT-Y_S*2)*0.5-2.5, Y_S+(CELL_HEIGHT-Y_S*2)+32, 4, 4)];
            _dianlabel.backgroundColor = COLOR_VAULE(144.0);
            _dianlabel.layer.cornerRadius = 2;
            _dianlabel.layer.masksToBounds = YES;
            [self addSubview:_dianlabel];
            
            UILabel *_statuslabel = [[UILabel alloc]init];
            _statuslabel.backgroundColor = DEFAULT_COLOR;
            _statuslabel.textColor = [self getColor:@"E8374A"];
            _statuslabel.font = MYFONT(13.5);
            _statuslabel.adjustsFontSizeToFitWidth = YES;
            _statuslabel.text = @"已付款";
            _statuslabel.frame = FRAME(X_S+IMAGE_XY+TEXT_X, Y_S+(CELL_HEIGHT-Y_S*2)+25, 100, 14);
            [self addSubview:_statuslabel];
            
            _backlabel.frame = FRAME(0, 0, _CELL_WIDTH, 115);
            _lineView.frame = FRAME(0, 115, _CELL_WIDTH, 0.5);
        }
         else if ([lable.text isEqualToString:@"即将服务"]) {
        
             
           UIButton *btn = (UIButton *)[self viewWithTag:104];
            [btn setHidden:YES];
             
             
             UILabel *_linelabel = [[UILabel alloc]initWithFrame:FRAME(X_S+(CELL_HEIGHT-Y_S*2)*0.5-0.5, Y_S+(CELL_HEIGHT-Y_S*2), 0.5, 32)];
             _linelabel.backgroundColor = COLOR_VAULE(144.0);
             [self addSubview:_linelabel];
             _linelabel.hidden = YES;
             
             UILabel *_dianlabel = [[UILabel alloc]initWithFrame:FRAME(X_S+(CELL_HEIGHT-Y_S*2)*0.5-2.5, Y_S+(CELL_HEIGHT-Y_S*2)+32, 4, 4)];
             _dianlabel.backgroundColor = COLOR_VAULE(144.0);
             _dianlabel.layer.cornerRadius = 2;
             _dianlabel.layer.masksToBounds = YES;
             [self addSubview:_dianlabel];
             _dianlabel.hidden = YES;
             
             UILabel *_statuslabel = [[UILabel alloc]init];
             _statuslabel.backgroundColor = DEFAULT_COLOR;
             _statuslabel.textColor = [self getColor:@"E8374A"];
             _statuslabel.font = MYFONT(13.5);
             _statuslabel.adjustsFontSizeToFitWidth = YES;
             _statuslabel.text = @"已付款";
             _statuslabel.frame = FRAME(X_S+IMAGE_XY+TEXT_X, Y_S+(CELL_HEIGHT-Y_S*2)+25, 100, 14);
             [self addSubview:_statuslabel];
//
             _statuslabel.hidden = YES;
             
//             _backlabel.frame = FRAME(0, 0, _CELL_WIDTH, 115);
//             _lineView.frame = FRAME(0, 115, _CELL_WIDTH, 0.5);
        }
    }
    
    return self;
}

- (void)setMydata:(ORDERDETAILData *)mydata
{
    _mydata = mydata;
    
    UILabel *timelabel = (UILabel *)[self viewWithTag:102];
    timelabel.text = [self getTimeWithstring:mydata.addTime];
    
    if (mydata.orderStatus == 6) {
        
        UILabel *_backlabel = [[UILabel alloc]initWithFrame:FRAME(0, 82, _CELL_WIDTH, 108)];
        _backlabel.backgroundColor = COLOR_VAULE(255.0);
        [self addSubview:_backlabel];
        
        UILabel *_discusslabel = [[UILabel alloc]initWithFrame:FRAME(18, 82+16, 43, 14)];
        _discusslabel.text = @"评价";
        _discusslabel.textColor = COLOR_VAULE(77.0);
        _discusslabel.font = MYFONT(13.5);
        _discusslabel.textAlignment = NSTextAlignmentCenter;
        _discusslabel.backgroundColor = DEFAULT_COLOR;
        [self addSubview:_discusslabel];
        
        NSArray *_pingjiaTextArr = @[@"赞",@"一般",@"心碎"];
        NSArray *_pingjiaArr = @[@"good_click-back@2X",@"common_click-back",@"bad_click-back"];
        
        UIButton *_zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _zanBtn.frame = FRAME(18, 83+38, 43, 58);
        [_zanBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 15, 0)];
        _zanBtn.titleLabel.font = MYFONT(13.5);
        [_zanBtn setTitleEdgeInsets:UIEdgeInsetsMake(43, -43, 0, 0)];
        
        
        [_zanBtn setImage:IMAGE_NAMED([_pingjiaArr objectAtIndex:mydata.orderRate]) forState:UIControlStateNormal];
        [_zanBtn setTitle:[_pingjiaTextArr objectAtIndex:mydata.orderRate] forState:UIControlStateNormal];
        [_zanBtn setTitleColor:[self getColor:@"E8374A"] forState:UIControlStateNormal];
        [self addSubview:_zanBtn];
        
    
        UILabel *_contentLabel = [[UILabel alloc]init];
        _contentLabel.frame = FRAME(36+43, 83+38, _CELL_WIDTH-36-43, 58);
        _contentLabel.textColor = COLOR_VAULE(169.0);
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = MYFONT(13.5);
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _contentLabel.text = mydata.orderRateContent;
        [_contentLabel setContentMode:UIViewContentModeCenter];
        [self addSubview:_contentLabel];
        
    }
    
}

- (ORDERDETAILData *)mydata
{
    return _mydata;
}

#pragma mark 取消或者评价按钮点击
- (void)ButtonPressedWithButtonTitle:(UIButton *)sender
{
    [self.delegate OrderBtnPressed:sender.currentTitle];
    
}

@end
