//
//  PayViewController.m
//  simi
//
//  Created by zrj on 14-12-3.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "PayViewController.h"
#import "ChoiceDefine.h"
#import "DownloadManager.h"
#import "MBProgressHUD+Add.h"
#import "Header.h"
#import "OrderModel.h"
#import "AliPayManager.h"
#import "PayData.h"
#import "MineJifenViewController.h"
#import "ISLoginManager.h"
#import "OrderViewController.h"
#import "BaiduMobStat.h"
#import "WeiXinPay.h"
@interface PayViewController ()<JiFenDelegate>
{
    BOOL xuanzhoang;
    BOOL zhifubao;
    BOOL bank;
    int payment;     //  1-余额支付 2-支付宝支付 3-银行卡支付
    NSString *restMoney;//余额
    NSString *cardPasswd;
    int resmoney;
    ISLoginManager *logManager;
    NSString *jiage;
}
@end

@implementation PayViewController
@synthesize price,time,orderID,orderNum,juanLX;
#define oneHeiget 64

-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"支付", nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"支付", nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}

- (void)DownLoadSource
{

    NSDictionary *mobelDic = [[NSDictionary alloc]initWithObjectsAndKeys:logManager.telephone,@"user_id", nil];
    DownloadManager *_download = [[DownloadManager alloc]init];
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",USERINFO_API] dict:mobelDic view:self.view delegate:self finishedSEL:@selector(DownlLoadFinish:) isPost:NO failedSEL:@selector(DownloadFail:)];
}
- (void)DownlLoadFinish:(id)dict
{
    NSLog(@"dic  = %@",dict);

    [MBProgressHUD showMessag:@"请稍等..." toView:self.view];
    restMoney = [dict[@"data"] objectForKey:@"rest_money"];
    NSString *msg = dict[@"msg"];
    int status = [dict[@"status"] intValue];
    NSLog(@"余额：%@  msg：%@  status：%i",restMoney,msg,status);
    if ([msg isEqualToString:@"ok"]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    if (status == 100 || status == 101 || status == 102 || status == 999 ) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"服务器错误" toView:self.view];
    }
    
    UILabel *lable = (UILabel *)[self.view viewWithTag:300];
    lable.text = [NSString stringWithFormat:@"%@元",restMoney];
    
    UILabel *lable1 = (UILabel *)[self.view viewWithTag:301];
    lable1.text = [NSString stringWithFormat:@"%@元",price];
    
    if([[NSString stringWithFormat:@"%@",price] isEqualToString:@"0.0"]){
        
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                
                UIButton *btn = (UIButton *)view;
                if ([btn.titleLabel.text isEqualToString:@"支付宝支付"] || [btn.titleLabel.text isEqualToString:@"余额支付"]) {
                    btn.hidden = YES;
                }
                
            }
        }
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                
                UILabel *lable = (UILabel *)view;
                if ([lable.text isEqualToString:@"推荐有支付宝账号的用户使用"] || [lable.text isEqualToString:@"请选择支付方式："]) {
                    lable.hidden = YES;
                }
                if (lable.tag == 300) {
                    lable.hidden = YES;
                }
                
            }
        }
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[UIView class]]) {
                if (view.tag == 33) {
                    view.hidden = YES;
                }
            }
        }
        
        UIImageView *img = (UIImageView *)[self.view viewWithTag:20];
        img.hidden = YES;
        
//        UIView *vie = (UIView *)[self.view viewWithTag:33];
//        vie.hidden = YES;
        
    }
    
    //判断默认选择哪个支付方式
    [self zhifubaoOrBank];
}

- (void)DownloadFail:(id)errorstr
{
    NSLog(@"errsor   :   %@",errorstr);
}
- (void)viewWillAppear:(BOOL)animated{
    [self DownLoadSource];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Qianbao) name:@"QIANBAOSUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WxPaySuccess) name:@"WXPAYSUCCESS" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chauxnWeiXin) name:@"WEIXINCHAXUN" object:nil];
    
    
}
- (void)chauxnWeiXin
{
//        [WeiXinPay WXPaywithOrderNo:orderNum orderType:@"0"];
    [WeiXinPay paySuccessOrFailWithOrderNo:orderNum orderType:@"0"];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navlabel.text = @"支付";
    
    xuanzhoang = NO;
    zhifubao = NO;
    bank = NO;

    logManager = [[ISLoginManager alloc]init];
    jiage = price;
    NSArray *titleArray = @[@"",@"优惠券",@"余额支付",@"还需支付",@"支付宝支付",@"微信支付"];
    
    for (int i = 0 ; i < 6 ; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = i;
        [btn addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft]; //内容水平向左
        [btn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:HEX_TO_UICOLOR(0x666666, 1.0) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        
//        [btn setBackgroundImage:[imgArray objectAtIndex:i] forState:UIControlStateNormal];
        if (i == 5) {
//            btn.hidden = YES;
        }
        
        if(i > 0 && i < 6){
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 18, 0, 0)];
        }
        
        if (i == 0) {
            
            btn.frame = FRAME(0, NAV_HEIGHT+9, SELF_VIEW_WIDTH, oneHeiget);
//            [btn setImageEdgeInsets:UIEdgeInsetsMake(19, SELF_VIEW_WIDTH-18-7.5, 19, 18)];
        }
        
        if (i > 0 && i < 4) {
            btn.frame = FRAME(0, NAV_HEIGHT+9+oneHeiget+9+(54*i)-54,SELF_VIEW_WIDTH, 54);
            
        }
        
        if (i >3 && i < 6) {
            btn.frame = FRAME(0, NAV_HEIGHT+9+oneHeiget+9+(54*i)+34-54, SELF_VIEW_WIDTH, 54);
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(5, 25, 20, 0)];
            [btn setTitleColor:HEX_TO_UICOLOR(0xE8374A, 1.0) forState:UIControlStateNormal];
        }
        
        if (i == 2 || i == 4) {
            [btn setTitleColor:HEX_TO_UICOLOR(0x666666, 1.0) forState:UIControlStateNormal];
        }
        if(i == 1){
            [btn setImage:[UIImage imageNamed:@"s-right-arrow"] forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(19, SELF_VIEW_WIDTH-18-7.5, 19, 18)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -5 , 0, 0)];

        }
        if(i == 2){
            [btn setFrame:FRAME(0, NAV_HEIGHT+9+oneHeiget+9+(54*i)+34, SELF_VIEW_WIDTH, 54)];
            [btn setImage:[UIImage imageNamed:@"selection"] forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake((54-47/2)/2, SELF_VIEW_WIDTH-47/2-18, (54-47/2)/2, 18)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(5, 25, 20, 0)];
            [btn setTitleColor:HEX_TO_UICOLOR(0x666666, 1.0) forState:UIControlStateNormal];
            //钱包图片
            UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (54-76/2)/2, 76/2, 76/2)];
            img.image = [UIImage imageNamed:@"pay_balance_icon@2x"];
            [btn addSubview:img];
        }
        if (i == 3) {
            btn.frame = FRAME(0, NAV_HEIGHT+9+oneHeiget+9+(54*2)-54,SELF_VIEW_WIDTH, 54);
        }
        if ( i == 4 || i == 5) {
            [btn setImage:[UIImage imageNamed:@"selection"] forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake((54-47/2)/2, SELF_VIEW_WIDTH-47/2-18, (54-47/2)/2, 18)];
        }
        
//        if (i == 4) {
//            [btn setImage:[UIImage imageNamed:@"zhifubao"] forState:UIControlStateNormal];
//            [btn setImageEdgeInsets:UIEdgeInsetsMake((54-76/2)/2, 18, (54-76/2)/2, SELF_VIEW_WIDTH-18-76/2)];
//            [btn setTitleEdgeInsets:UIEdgeInsetsMake(5, -5, 20, 0)];
//        }
        if (i == 5) {
            
            //微信图片
            [btn setTitleColor:HEX_TO_UICOLOR(0x666666, 1.0) forState:UIControlStateNormal];

            UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (54-76/2)/2, 76/2, 76/2)];
            img.image = [UIImage imageNamed:@"weixin-pay"];
            [btn addSubview:img];
            
//            [btn setImage:[UIImage imageNamed:@"bank"] forState:UIControlStateNormal];
//            [btn setImageEdgeInsets:UIEdgeInsetsMake((54-76/2)/2, 18, (54-76/2)/2, SELF_VIEW_WIDTH-18-76/2)];
//            [btn setTitleEdgeInsets:UIEdgeInsetsMake(5, -5, 20, 0)];
        }
        [self.view addSubview:btn];
    }
    
    for (int i = 0 ; i < 8; i++) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = COLOR_VAULE(209.0);
        if (i < 2) {
            view.frame = FRAME(0, NAV_HEIGHT+9+(oneHeiget*i), SELF_VIEW_WIDTH, 0.5);
        }
        
        if (i > 1 && i < 5) {
            view.frame = FRAME(0, NAV_HEIGHT+18+oneHeiget+(54*i)-54*2, SELF_VIEW_WIDTH, 0.5);
//            view.backgroundColor = [UIColor redColor];
        }
        
        if (i > 4 && i < 8) {
            view.frame = FRAME(0, NAV_HEIGHT+oneHeiget+18+54*3+34+(54*i)-6*54, SELF_VIEW_WIDTH, 0.5);
            view.tag = 33;
        }
        
        [self.view addSubview:view];
    }
    
    for (int i = 0; i < 8; i++) {
        UILabel *detailLab = [[UILabel alloc]init];
        detailLab.textColor = HEX_TO_UICOLOR(0xb1b1b1, 1.0);
        detailLab.font = [UIFont systemFontOfSize:10];
        detailLab.textAlignment = NSTextAlignmentLeft;
        detailLab.tag = i+50;
        if (i <3) {
            detailLab.frame = FRAME(18, NAV_HEIGHT+9+13+(i*20), SELF_VIEW_WIDTH-18, 20) ;
        }
        
        if (i == 0) {
            detailLab.textColor = HEX_TO_UICOLOR(0xE8374A, 1.0);
            detailLab.font = [UIFont systemFontOfSize:13];
            
            NSMutableAttributedString *ding1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计：%@元",price]];
            [ding1 setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:HEX_TO_UICOLOR(0x666666, 1.0),NSForegroundColorAttributeName, nil] range:NSMakeRange(0, 3)];
            detailLab.attributedText = ding1;
            
        }
        if (i == 1) {
            NSString *fuwuTime = [time stringByReplacingOccurrencesOfString:@"." withString:@"-"];
            if ([fuwuTime isEqualToString:@"1970-01-01 08:00"]) {
                fuwuTime = @"";
            }
            detailLab.text = [NSString stringWithFormat:@"服务时间：%@",fuwuTime];
            detailLab.textColor = HEX_TO_UICOLOR(0x666666, 1.0);
            detailLab.font = [UIFont systemFontOfSize:13];
        }
        if (i == 2) {
//            detailLab.text = @"线下服务人员会按实际工作收取剩余费用";
            detailLab.textColor = HEX_TO_UICOLOR(0xb1b1b1, 1.0);
        }
        
        if (i >2 && i <6) {
            detailLab.frame = FRAME(100, NAV_HEIGHT+18+oneHeiget+18+((i-3)*54), SELF_VIEW_WIDTH-100-40, 20);
            detailLab.textAlignment = NSTextAlignmentRight;
            detailLab.font = [UIFont systemFontOfSize:13];
        }
        if (i == 3) {
            detailLab.text = @"使用优惠券";
        }
        if (i == 4) {
            detailLab.frame = FRAME(70, NAV_HEIGHT+9+oneHeiget+9+(54*i)-54+10, SELF_VIEW_WIDTH-90, 20);
            detailLab.textAlignment = NSTextAlignmentLeft;
            detailLab.text = [NSString stringWithFormat:@"%@",restMoney];
            detailLab.font = [UIFont systemFontOfSize:12];
            detailLab.tag = 300;
    
        }
        if (i == 5) {
//            detailLab.text = @"12元";
            detailLab.frame = FRAME(100, NAV_HEIGHT+18+oneHeiget+18+((5-3)*54)-54, SELF_VIEW_WIDTH-100-18, 20);
            detailLab.textColor = HEX_TO_UICOLOR(0xE8374A, 1.0);
            detailLab.tag = 301;
        }
        if (i > 5) {
            detailLab.frame = FRAME(70, NAV_HEIGHT+18+oneHeiget+54*3+34+30+(i -6)*53, SELF_VIEW_WIDTH-80, 20);
            
        }
        if (i == 6) {
            detailLab.text = @"推荐有支付宝账号的用户使用";
        }
        if (i == 7)
        {
            detailLab.text = @"使用微信绑定的支付方式";
//            detailLab.hidden = YES;
        }
        [self.view addSubview:detailLab];

    }
    
    for (int i = 0; i < 2; i++) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, NAV_HEIGHT+18+oneHeiget+54*3+34+(54-76/2)/2+i*(76/2+(54-76/2)), 76/2, 76/2)];
        if (i == 0) {
            img.image = [UIImage imageNamed:@"zhifubao"];
            img.tag = 20;
        }
        if (i == 1) {
            img.image = [UIImage imageNamed:@"weixin-pay"];
            img.hidden = YES;
        }
        [self.view addSubview:img];
    }
    
    UILabel *paylab = [[UILabel alloc]init];
    paylab.text = @"请选择支付方式：";
    paylab.tag = 22;
    paylab.textColor = HEX_TO_UICOLOR(0xb1b1b1, 1.0);
    paylab.font = [UIFont systemFontOfSize:13];
    paylab.frame = FRAME(18, 261, 150, 20);
    [self.view addSubview:paylab];
    
    UIButton *bttn = [UIButton buttonWithType:UIButtonTypeCustom];
    bttn.frame = FRAME(14, SELF_VIEW_HEIGHT-14-41, WIDTH-28, 41);
    bttn.layer.cornerRadius=5;
    [bttn setBackgroundColor:HEX_TO_UICOLOR(ROUND_COLOR, 1.0)];
    [bttn setTitle:@"确认支付" forState:UIControlStateNormal];
    [bttn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bttn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    [bttn.layer setCornerRadius:5.0];//设置矩形四个圆角半径
    [self.view addSubview:bttn];
 
    // Do any additional setup after loading the view.
}
- (void)WxPaySuccess
{
    OrderViewController *order = [[OrderViewController alloc]init];
    [self.navigationController pushViewController:order animated:YES];
}
- (void)zhifubaoOrBank
{
    UIButton *zhifuBtn = (UIButton *)[self.view viewWithTag:2];   //余额
    UIButton *zhifuBtn2 = (UIButton *)[self.view viewWithTag:4];  //支付宝
    if([restMoney intValue] >= [price intValue]){
        [zhifuBtn setImage:[UIImage imageNamed:@"selection-checked"] forState:UIControlStateNormal];
        [zhifuBtn2 setImage:[UIImage imageNamed:@"selection"] forState:UIControlStateNormal];
        
        payment = 1;
        zhifubao = NO;
    }else{ 
        [zhifuBtn setImage:[UIImage imageNamed:@"selection"] forState:UIControlStateNormal];
        [zhifuBtn2 setImage:[UIImage imageNamed:@"selection-checked"] forState:UIControlStateNormal];
        payment = 2;
        zhifubao = YES;
    }
}
- (void)touchAction:(UIButton *)btn
{
    if(btn.tag == 1){
        MineJifenViewController *mine = [[MineJifenViewController alloc]init];
        mine.delegate = self;
        mine.controlName = @"支付";
        mine.juanLX = self.juanLX;
        [self.navigationController pushViewController:mine animated:YES];
    }
    if (btn.tag == 2) {
        if (xuanzhoang == NO) {
            [btn setImage:[UIImage imageNamed:@"selection-checked"] forState:UIControlStateNormal];
            payment = 1;
            xuanzhoang = YES;
            
            UIButton *zhifuBtn = (UIButton *)[self.view viewWithTag:4];
            UIButton *zhifuBtn2 = (UIButton *)[self.view viewWithTag:5];
            [zhifuBtn setImage:[UIImage imageNamed:@"selection"] forState:UIControlStateNormal];
            [zhifuBtn2 setImage:[UIImage imageNamed:@"selection"] forState:UIControlStateNormal];
            zhifubao = NO;
            bank = NO;
        }
        else{
//            [btn setImage:[UIImage imageNamed:@"selection"] forState:UIControlStateNormal];
//            payment = 0;
//            xuanzhoang =NO;
        }
    }
    
    if (btn.tag == 4) {
        if (zhifubao == NO) {
            [btn setImage:[UIImage imageNamed:@"selection-checked"] forState:UIControlStateNormal];
            payment = 2;
            zhifubao = YES;
            
            UIButton *yue = (UIButton *)[self.view viewWithTag:2];
            UIButton *zhifuBtn = (UIButton *)[self.view viewWithTag:5];
            [yue setImage:[UIImage imageNamed:@"selection"] forState:UIControlStateNormal];
            [zhifuBtn setImage:[UIImage imageNamed:@"selection"] forState:UIControlStateNormal];
            xuanzhoang = NO;
            bank = NO;
        }
        else
        {
//            [btn setImage:[UIImage imageNamed:@"selection"] forState:UIControlStateNormal];
//            payment = 0;
//            zhifubao = NO;
        }
    }
    
    if (btn.tag == 5) {
        if (bank == NO) {
            [btn setImage:[UIImage imageNamed:@"selection-checked"] forState:UIControlStateNormal];
            payment = 3;
            bank = YES;
            
            UIButton *yue = (UIButton *)[self.view viewWithTag:2];
            UIButton *zhifuBtn = (UIButton *)[self.view viewWithTag:4];
            [yue setImage:[UIImage imageNamed:@"selection"] forState:UIControlStateNormal];
            [zhifuBtn setImage:[UIImage imageNamed:@"selection"] forState:UIControlStateNormal];
            xuanzhoang = NO;
            zhifubao = NO;
        }
        else
        {
//            [btn setImage:[UIImage imageNamed:@"selection"] forState:UIControlStateNormal];
//            payment = 0;
//            bank = NO;
        }
    }
}
- (void)CardPasswdIs:(NSString *)passwd money:(double)money
{
    price = jiage;
    [self DownLoadSource];
    NSLog(@"passwd = %@  money = %0.2f",passwd,money);
    cardPasswd = passwd;
    NSString *haixu = [NSString stringWithFormat:@"%0.1f",[price doubleValue]-money];
    if ([price doubleValue]-money < 0) {
        haixu = @"0";
    }
    price = haixu;
    UILabel *lable1 = (UILabel *)[self.view viewWithTag:301];
    lable1.text = [NSString stringWithFormat:@"%@元",haixu];
    
    UILabel *lable2 = (UILabel *)[self.view viewWithTag:53];
    lable2.text = [NSString stringWithFormat:@"为您节省了%0.2f元",money];
//    [self DownLoadSource];
}
- (void)payAction{

//    if(payment == 0){
//        [MBProgressHUD showError:@"请选择支付方式" toView:self.view];
//        return;
//    }
    if (cardPasswd == nil) {
        cardPasswd = @"0";
    }
    if (payment == 1) {
        NSMutableDictionary *sourceDic = [[NSMutableDictionary alloc]init];
        [sourceDic setObject:logManager.telephone  forKey:@"user_id"];
        [sourceDic setObject:[NSString stringWithFormat:@"%@",orderID]  forKey:@"order_id"];
        [sourceDic setObject:orderNum  forKey:@"order_no"];
        [sourceDic setObject:@"0"  forKey:@"pay_type"];
//        [sourceDic setObject:cardPasswd  forKey:@"card_passwd"];
//        [sourceDic setObject:@"0"  forKey:@"score"];
        
        NSLog(@"请求dic = %@",sourceDic);
        DownloadManager *_download = [[DownloadManager alloc]init];
        [_download requestWithUrl:[NSString stringWithFormat:@"%@",ORDER_PAY] dict:sourceDic view:self.view delegate:self finishedSEL:@selector(DownlLoadtoFinish:) isPost:YES failedSEL:@selector(DownloadTo:)];
    }
    if (payment == 2) {
        NSLog(@"支付宝支付");
        
        NSMutableDictionary *sourceDic = [[NSMutableDictionary alloc]init];
        [sourceDic setObject:logManager.telephone  forKey:@"user_id"];
        [sourceDic setObject:[NSString stringWithFormat:@"%@",orderID]  forKey:@"order_id"];
        [sourceDic setObject:orderNum  forKey:@"order_no"];
        [sourceDic setObject:@"1"  forKey:@"pay_type"];
//        [sourceDic setObject:cardPasswd  forKey:@"card_passwd"];
//        [sourceDic setObject:@"0"  forKey:@"score"];
        
        NSLog(@"请求dic = %@",sourceDic);
        DownloadManager *_download = [[DownloadManager alloc]init];
        [_download requestWithUrl:[NSString stringWithFormat:@"%@",ORDER_PAY] dict:sourceDic view:self.view delegate:self finishedSEL:@selector(ZFBDownlLoadtoFinish:) isPost:YES failedSEL:@selector(ZFBDownloadTo:)];
    }
    if (payment == 3) {

        NSMutableDictionary *sourceDic = [[NSMutableDictionary alloc]init];
        [sourceDic setObject:logManager.telephone  forKey:@"user_id"];
        [sourceDic setObject:[NSString stringWithFormat:@"%@",orderID]  forKey:@"order_id"];
        [sourceDic setObject:orderNum  forKey:@"order_no"];
        [sourceDic setObject:@"2"  forKey:@"pay_type"];
//        [sourceDic setObject:cardPasswd  forKey:@"card_passwd"];
//        [sourceDic setObject:@"0"  forKey:@"score"];
        
        NSLog(@"请求dic = %@",sourceDic);
        DownloadManager *_download = [[DownloadManager alloc]init];
        [_download requestWithUrl:[NSString stringWithFormat:@"%@",ORDER_PAY] dict:sourceDic view:self.view delegate:self finishedSEL:@selector(WXDownlLoadtoFinish:) isPost:YES failedSEL:@selector(ZFBDownloadTo:)];
    }

}
- (void)WXDownlLoadtoFinish:(id)dict
{
    NSLog(@"dict = %@",dict);
    int status = [dict[@"status"] intValue];
    if (status == 0) {
        
//        PayData *orderData = [[PayData alloc]init];
//        orderData.ordermoney = price;
//        orderData.ordernumber = orderNum;
//        AliPayManager *_mydata = [[AliPayManager alloc]init];
        
        [WeiXinPay WXPaywithOrderNo:orderNum orderType:@"0"];

    }
    
}
- (void)DownlLoadtoFinish:(id)dict{
    NSLog(@"dict = %@",dict);
    int status = [dict[@"status"] intValue];
    if (status == 0) {
        [MBProgressHUD showError:@"支付成功" toView:self.view];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"PAYSUCCESS" object:nil];
        OrderViewController *order = [[OrderViewController alloc]init];
        [self.navigationController pushViewController:order animated:YES];
       
//        [self transitionFromViewController:self toViewController:order duration:1 options:0 animations:^{
//        }  completion:^(BOOL finished) {
//            if (finished) {
//                
//            }else{
//                
//            }
//        }];
    }
    else{
//        [MBProgressHUD showError:@"支付错误" toView:self.view];
    }
}
- (void)PaySuccess:(id)responsobject
{
    NSLog(@"支付成功 ： %@",responsobject);
    NSString *result = [responsobject objectForKey:@"resultStatus"];
    if ([result isEqualToString:@"9000"]) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"PAYSUCCESS" object:nil];
        OrderViewController *order = [[OrderViewController alloc]init];
        [self.navigationController pushViewController:order animated:YES];

    }
}

- (void)ZFBDownlLoadtoFinish:(id)dict{
    NSLog(@"dict = %@",dict);
    int status = [dict[@"status"] intValue];
    if (status == 0) {

        PayData *orderData = [[PayData alloc]init];
        orderData.ordermoney = price;
        orderData.ordernumber = orderNum;
        AliPayManager *_mydata = [[AliPayManager alloc]init];
        //        [_mydata requestWitDelegate:self data:orderData finishedSEL:@selector(PaySuccess:)];
        [_mydata requestWitDelegate:self data:orderData finishedSEL:@selector(PaySuccess:) notyurl:ORDEL_NOTYURL];
    }
}
- (void)ZFBDownloadTo:(id)error
{
    NSLog(@"dict = %@",error);
}
- (void)DownloadTo:(id)error
{
    NSLog(@"dict = %@",error);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)Qianbao
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PAYSUCCESS" object:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 
*/

@end
