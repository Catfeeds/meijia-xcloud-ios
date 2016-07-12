//
//  PayMentView.m
//  simi
//
//  Created by 白玉林 on 15/9/15.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "PayMentView.h"

@implementation PayMentView
{
    int Y;
}
@synthesize delegate = _delegate,ZFB,MODE;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (id)initWithFrame:(CGRect)frame num:(int)num addid:(int)ids
{
    self = [super initWithFrame:frame];
    if (self) {
        
        isAli = YES;
        ZFB = YES;
        MODE=NO;
        
        UILabel *_titlelabel = [[UILabel alloc]initWithFrame:FRAME(18, 0, _CELL_WIDTH, 31)];
        _titlelabel.text = @"支付信息";
        _titlelabel.font = MYFONT(13.5);
        _titlelabel.textColor = [self getColor:@"b1b1b1"];
        _titlelabel.backgroundColor = DEFAULT_COLOR;
        [self addSubview:_titlelabel];
        
        
        UILabel *_backlabel = [[UILabel alloc]initWithFrame:FRAME(0, 31, _CELL_WIDTH, 40*(num-1))];
        _backlabel.backgroundColor = COLOR_VAULE(255.0);
        [self addSubview:_backlabel];
        
        
        NSArray *_labelArr = @[@"账户确认:",((num == 2) ? @"应付金额:" : @"购买内容:"),@"支付金额:"];
        
        for (int i = 1; i < num; i ++) {
            UILabel *_label = [[UILabel alloc]initWithFrame:FRAME(18, 31+40*(i-1), 72, 40)];
            _label.font = MYFONT(13.5);
            _label.textColor = [self getColor:@"666666"];
            [_label setText:[_labelArr objectAtIndex:i]];
            [self addSubview:_label];
            
            UILabel *_seconedlabel = [[UILabel alloc]initWithFrame:FRAME(90, 31+40*(i-1), _CELL_WIDTH-90-18, 40)];
            _seconedlabel.font = MYFONT(13.5);
            [_seconedlabel setTag:(100+i)];
            if (i == 0) {
                _seconedlabel.textColor = [self getColor:@"666666"];
                
            }else if (i == 1){
                _seconedlabel.textColor = [self getColor:@"b1b1b1"];
                
            }else{
                _seconedlabel.textColor = [self getColor:@"E8374A"];
                
            }
            [self addSubview:_seconedlabel];
            
            
        }
        
        for (int i = 1; i < num+1; i ++) {
            UIImageView *_lineview = [[UIImageView alloc]initWithFrame:FRAME(0, 31+40*(i-1), _CELL_WIDTH, 0.5)];
            _lineview.backgroundColor = COLOR_VAULE(209.0);
            [self addSubview:_lineview];
        }
        UIButton *volumeBut=[[UIButton alloc]initWithFrame:FRAME(0, 32+40*(num-1), WIDTH, 40)];
        volumeBut.backgroundColor=[UIColor whiteColor];
        [volumeBut addTarget:self action:@selector(volumeButAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:volumeBut];
        
        UILabel *volumeLabel=[[UILabel alloc]initWithFrame:FRAME(18, 13, 72, 14)];
        volumeLabel.text=@"优 惠 劵:";
        volumeLabel.font = MYFONT(13.5);
        //[volumeLabel setTag:103];
        volumeLabel.textColor = [self getColor:@"666666"];
        [volumeBut addSubview:volumeLabel];
        
        UILabel *volLabel=[[UILabel alloc]initWithFrame:FRAME(90, 13, WIDTH-108, 14)];
        volLabel.font = MYFONT(13.5);
        volLabel.textColor = [self getColor:@"b1b1b1"];
        [volLabel setTag:(103)];
        [volumeBut addSubview:volLabel];
        
        UIView *actualView=[[UIView alloc]initWithFrame:FRAME(0, 31+40*(num-1)+41, WIDTH, 40)];
        actualView.backgroundColor=[UIColor whiteColor];
        [self addSubview:actualView];
        
        UIImageView *_lineview = [[UIImageView alloc]initWithFrame:FRAME(0, volumeBut.frame.origin.y+volumeBut.frame.size.height, _CELL_WIDTH, 0.5)];
        _lineview.backgroundColor = COLOR_VAULE(209.0);
        [self addSubview:_lineview];
        
        UILabel *actualLabel=[[UILabel alloc]initWithFrame:FRAME(18, 13, 72, 14)];
        actualLabel.text=@"实际支付:";
        actualLabel.font = MYFONT(13.5);
        //[volumeLabel setTag:103];
        actualLabel.textColor = [self getColor:@"666666"];
        [actualView addSubview:actualLabel];
        
        UILabel *actLabel=[[UILabel alloc]initWithFrame:FRAME(90, 13, WIDTH-108, 14)];
        actLabel.font = MYFONT(13.5);
        actLabel.textColor = [self getColor:@"b1b1b1"];
        [actLabel setTag:(104)];
        [actualView addSubview:actLabel];

        
        if (ids==0) {
            Y=81;
            
        }else{
            UILabel *address=[[UILabel alloc]initWithFrame:FRAME(18, 31+40*(num-1)+81+10, 120, 14)];
            address.text=@"联系地址:";
            address.font=MYFONT(13.5);
            address.textColor=[self getColor:@"b1b1b1"];
            [self addSubview:address];
            
            UIButton *addressBut=[[UIButton alloc]initWithFrame:FRAME(0, 31+40*(num-1)+81+34, WIDTH, 40)];
            addressBut.backgroundColor = COLOR_VAULE(255.0);
            [addressBut addTarget:self action:@selector(addressButAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:addressBut];
            
            UILabel *addressLabel=[[UILabel alloc]initWithFrame:FRAME(18, 13, 72, 14)];
            addressLabel.text=@"服务地址:";
            addressLabel.font = MYFONT(13.5);
            addressLabel.textColor = [self getColor:@"666666"];
            [addressBut addSubview:addressLabel];
            
            UILabel *addLabel=[[UILabel alloc]initWithFrame:FRAME(90, 13, WIDTH-108, 14)];
            addLabel.font = MYFONT(13.5);
            addLabel.textColor = [self getColor:@"666666"];
            [addLabel setTag:(105)];
            [addressBut addSubview:addLabel];
            Y=155;
        }
        
        
        UILabel *_marklabel = [[UILabel alloc]initWithFrame:FRAME(18, 31+40*(num-1)+Y+10, 120, 14)];
        _marklabel.text = @"支付方式";
        _marklabel.font = MYFONT(13.5);
        _marklabel.textColor = [self getColor:@"b1b1b1"];
        [self addSubview:_marklabel];
        
        UIView *_backlabel1 = [[UIView alloc]initWithFrame:FRAME(0, 31+40*(num-1)+Y+34, _CELL_WIDTH, 54)];
        _backlabel1.backgroundColor = COLOR_VAULE(255.0);
        _backlabel1.tag = 11;
        [self addSubview:_backlabel1];
        
        UIImageView *_leftimageview = [[UIImageView alloc]initWithFrame:FRAME(18, 31+40*(num-1)+Y+34+7.5, 39, 39)];
        [_leftimageview setImage:[UIImage imageNamed:@"zhi-fu-bao-icon_"]];
        [self addSubview:_leftimageview];
        
        UILabel *_zhifulabel1 = [[UILabel alloc]initWithFrame:FRAME(18+39+14, 31+40*(num-1)+Y+34+10, 120, 14)];
        _zhifulabel1.font = MYFONT(13.5);
        _zhifulabel1.textColor = [self getColor:@"E8374A"];
        _zhifulabel1.backgroundColor = DEFAULT_COLOR;
        _zhifulabel1.text = @"支付宝支付";
        [self addSubview:_zhifulabel1];
        
        UILabel *_zhifulabel2 = [[UILabel alloc]initWithFrame:FRAME(18+39+14, 31+40*(num-1)+Y+34+10+21, 200, 14)];
        _zhifulabel2.font = MYFONT(10);
        _zhifulabel2.textColor = [self getColor:@"b1b1b1"];
        _zhifulabel2.backgroundColor = DEFAULT_COLOR;
        _zhifulabel2.text = @"推荐有支付宝账号的用户使用";
        [self addSubview:_zhifulabel2];
        
        
        UILabel *lab = [[UILabel alloc]initWithFrame:FRAME(0, _backlabel1.bottom, self_Width, 0.5)];
        lab.backgroundColor = COLOR_VAULE(209.0);
        [self addSubview:lab];
        
        UIView *_backlabel2 = [[UIView alloc]initWithFrame:FRAME(0, _backlabel1.bottom+0.5, _CELL_WIDTH, 54)];
        _backlabel2.backgroundColor = COLOR_VAULE(255.0);
        _backlabel2.tag = 22;
        [self addSubview:_backlabel2];
        
        UIImageView *_leftimageview1 = [[UIImageView alloc]initWithFrame:FRAME(18, _backlabel2.top+8, 39, 39)];
        [_leftimageview1 setImage:[UIImage imageNamed:@"weixin-pay"]];
        [self addSubview:_leftimageview1];
        
        UILabel *_weixin = [[UILabel alloc]initWithFrame:FRAME(18+39+14, _backlabel2.top+8, 120, 14)];
        _weixin.font = MYFONT(13.5);
        _weixin.textColor = [self getColor:@"E8374A"];
        _weixin.backgroundColor = DEFAULT_COLOR;
        _weixin.text = @"微信支付";
        [self addSubview:_weixin];
        
        UILabel *_weixinLab = [[UILabel alloc]initWithFrame:FRAME(18+39+14, _backlabel2.bottom-23, 200, 14)];
        _weixinLab.font = MYFONT(10);
        _weixinLab.textColor = [self getColor:@"b1b1b1"];
        _weixinLab.backgroundColor = DEFAULT_COLOR;
        _weixinLab.text = @"使用微信绑定的支付方式";
        [self addSubview:_weixinLab];
        
        
        UILabel *lab1 = [[UILabel alloc]initWithFrame:FRAME(0, _backlabel2.bottom, self_Width, 0.5)];
        lab1.backgroundColor = COLOR_VAULE(209.0);
        [self addSubview:lab1];
        
        UIView *_backlabel3 = [[UIView alloc]initWithFrame:FRAME(0, _backlabel2.bottom+0.5, _CELL_WIDTH, 54)];
        _backlabel3.backgroundColor = COLOR_VAULE(255.0);
        _backlabel3.tag = 13;
        [self addSubview:_backlabel3];
        
        UIImageView *balanceImage = [[UIImageView alloc]initWithFrame:FRAME(18, _backlabel3.top+8, 39, 39)];
        [balanceImage setImage:[UIImage imageNamed:@"Wallet_Lcon"]];
        [self addSubview:balanceImage];
        
        UILabel *_balance = [[UILabel alloc]initWithFrame:FRAME(18+39+14, _backlabel3.top+8, 120, 14)];
        _balance.font = MYFONT(13.5);
        _balance.textColor = [self getColor:@"E8374A"];
        _balance.backgroundColor = DEFAULT_COLOR;
        _balance.text = @"余额支付";
        [self addSubview:_balance];
        
        UILabel *_balanceLab = [[UILabel alloc]initWithFrame:FRAME(18+39+14, _backlabel3.bottom-23, 200, 14)];
        _balanceLab.font = MYFONT(10);
        _balanceLab.textColor = [self getColor:@"b1b1b1"];
        _balanceLab.backgroundColor = DEFAULT_COLOR;
        _balanceLab.text = @"使用余额支付方式";
        [self addSubview:_balanceLab];
        
        
        
        UIImageView *image1 = [[UIImageView alloc]initWithFrame:FRAME(self_Width-40, _backlabel1.top+15, 47/2, 47/2)];
        image1.image = [UIImage imageNamed:@"selection-checked"];
        image1.tag = 33;
        [self addSubview:image1];
        
        UIImageView *image2 = [[UIImageView alloc]initWithFrame:FRAME(self_Width-40, _backlabel2.top+15, 47/2, 47/2)];
        image2.image = [UIImage imageNamed:@"selection"];
        image2.tag = 44;
        [self addSubview:image2];
        
        UIImageView *image3 = [[UIImageView alloc]initWithFrame:FRAME(self_Width-40, _backlabel3.top+15, 47/2, 47/2)];
        image3.image = [UIImage imageNamed:@"selection"];
        image3.tag = 55;
        [self addSubview:image3];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ZfbPaySelect)];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(WxPaySelect)];
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(balancePaySelect)];
        
        [_backlabel1 addGestureRecognizer:tap];
        [_backlabel2 addGestureRecognizer:tap2];
        [_backlabel3 addGestureRecognizer:tap3];
        
        
        UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = FRAME(14, _backlabel3.bottom+10, WIDTH-28, 41);
        _button.layer.cornerRadius=5;
        //        [_button setBackgroundImage:[[UIImage imageNamed:@"circle_@2x"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
        [_button setBackgroundColor:HEX_TO_UICOLOR(TEXT_COLOR, 1.0)];
        _button.titleLabel.font = MYFONT(14);
        [_button setTag:222];
        [_button setTitle:@"确认支付" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(SurePayBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_button];
        
        
    }
    
    return self;
}
-(void)addressButAction:(UIButton *)sender
{
    [self.delegate buyBtnAddRess:sender];
}
//- (void)ZfbPaySelect
//{
//    NSLog(@"支付宝支付");
//    UIImageView *view = (UIImageView *)[self viewWithTag:33];
//    UIImageView *view2 = (UIImageView *)[self viewWithTag:44];
//
//    view.image = [UIImage imageNamed:@"selection-checked"];
//    view2.image = [UIImage imageNamed:@"selection"];
//    ZFB = YES;
//
//
//}
//- (void)WxPaySelect
//{
//    NSLog(@"微信支付");
//    UIImageView *view = (UIImageView *)[self viewWithTag:33];
//    UIImageView *view2 = (UIImageView *)[self viewWithTag:44];
//
//    view.image = [UIImage imageNamed:@"selection"];
//    view2.image = [UIImage imageNamed:@"selection-checked"];
//    ZFB = NO;
//}
- (void)ZfbPaySelect
{
    NSLog(@"支付宝支付");
    UIImageView *view = (UIImageView *)[self viewWithTag:33];
    UIImageView *view2 = (UIImageView *)[self viewWithTag:44];
    UIImageView *view3 = (UIImageView *)[self viewWithTag:55];
    
    view.image = [UIImage imageNamed:@"selection-checked"];
    view2.image = [UIImage imageNamed:@"selection"];
    view3.image = [UIImage imageNamed:@"selection"];
    ZFB = YES;
    MODE=NO;
    isAli=YES;
    
}
- (void)WxPaySelect
{
    NSLog(@"微信支付");
    UIImageView *view = (UIImageView *)[self viewWithTag:33];
    UIImageView *view2 = (UIImageView *)[self viewWithTag:44];
    UIImageView *view3 = (UIImageView *)[self viewWithTag:55];
    
    view.image = [UIImage imageNamed:@"selection"];
    view2.image = [UIImage imageNamed:@"selection-checked"];
    view3.image = [UIImage imageNamed:@"selection"];
    ZFB = NO;
    MODE=NO;
    isAli=YES;
}

-(void)balancePaySelect
{
    NSLog(@"余额支付");
    UIImageView *view = (UIImageView *)[self viewWithTag:33];
    UIImageView *view2 = (UIImageView *)[self viewWithTag:44];
    UIImageView *view3 = (UIImageView *)[self viewWithTag:55];
    
    view.image = [UIImage imageNamed:@"selection"];
    view2.image = [UIImage imageNamed:@"selection"];
    view3.image = [UIImage imageNamed:@"selection-checked"];
    ZFB = NO;
    MODE=YES;
    isAli=NO;
}
-(void)volumeButAction:(UIButton *)sender
{
    [self.delegate buyBtnVolume:sender];
}
- (void)setSelfmoney:(NSString *)selfmoney
{
    UILabel *_label = (UILabel *)[self viewWithTag:190];
    _label.text = selfmoney;
}

- (void)SurePayBtnPressed:(UIButton *)sender
{
    [self.delegate buyBtnPressedisAli:isAli];
}

- (void)SelectOrNo:(UIButton *)sender
{
    
    NSLog(@"谁会走这里呢？");
    [sender setImage:[UIImage imageNamed:@"selection_checked"] forState:UIControlStateNormal];
    UIButton *_button = (UIButton *)[self viewWithTag:3000];
    UIButton *_button1 = (UIButton *)[self viewWithTag:3001];
    UIButton *_button2 = (UIButton *)[self viewWithTag:3002];
    
    if (sender.tag == 3000) {
        ZFB=YES;
        isAli=NO;
        [_button1 setImage:[UIImage imageNamed:@"noselection"] forState:UIControlStateNormal];
        [_button2 setImage:[UIImage imageNamed:@"noselection"] forState:UIControlStateNormal];
    }else if(sender.tag==3001){
        ZFB=NO;
        isAli=NO;
        [_button setImage:[UIImage imageNamed:@"noselection"] forState:UIControlStateNormal];
        [_button2 setImage:[UIImage imageNamed:@"noselection"] forState:UIControlStateNormal];
        
    }else
    {
        ZFB=NO;
        isAli=YES;
        [_button setImage:[UIImage imageNamed:@"noselection"] forState:UIControlStateNormal];
        [_button1 setImage:[UIImage imageNamed:@"noselection"] forState:UIControlStateNormal];
    }
    
}
-(void)setAddressString:(NSString *)addString
{
    _addressString = addString;
    UILabel *_label = (UILabel *)[self viewWithTag:105];
    //_label.frame=FRAME(90, 5, WIDTH-95, 30);
    _label.text = addString;
    [_label setNumberOfLines:2];
    [_label sizeToFit];
}
-(NSString *)addString
{
    return _addressString;
}
- (void)setZhanghu:(NSString *)zhanghu
{
    _zhanghu = zhanghu;
    UILabel *_label = (UILabel *)[self viewWithTag:100];
    _label.text = zhanghu;
}

- (NSString *)zhanghu
{
    return _zhanghu;
}

- (void)setJine:(NSString *)jine
{
    _jine = jine;
    UILabel *_label = (UILabel *)[self viewWithTag:101];
    _label.text = jine;
    
}
- (NSString *)jine
{
    return _jine;
}

- (void)setFanxian:(NSString *)fanxian
{
    _fanxian = fanxian;
    UILabel *_label = (UILabel *)[self viewWithTag:102];
    _label.text = [NSString stringWithFormat:@"%@元",fanxian];;
    
}

- (NSString *)fanxian
{
    return _fanxian;
}
-(void)setVolumeString:(NSString *)volumeString
{
    _volumeString = volumeString;
    UILabel *_label = (UILabel *)[self viewWithTag:103];
    _label.text = volumeString;
    
}
- (NSString *)volumeString
{
    return _volumeString;
}

-(void)setActualString:(NSString *)actualString
{
    _actualString = actualString;
    UILabel *_label = (UILabel *)[self viewWithTag:104];
    _label.text = [NSString stringWithFormat:@"%@元",actualString];
    
}
- (NSString *)actualString
{
    return _actualString;
}

@end

