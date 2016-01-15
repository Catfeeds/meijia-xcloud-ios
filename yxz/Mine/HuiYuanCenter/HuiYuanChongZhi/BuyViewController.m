//
//  BuyViewController.m
//  simi
//
//  Created by 赵中杰 on 14/12/8.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "BuyViewController.h"
#import "BuyView.h"
#import "AliPayManager.h"
#import "DownloadManager.h"
#import "ISLoginManager.h"
//#import "MyLogInViewController.h"
#import "USERINFODataModels.h"
#import "UserInfoViewController.h"
#import "WeiXinPay.h"
@interface BuyViewController ()
<BUYDELEGATE>
{
    BuyView *_buyview;
    USERINFOBaseClass *_userbaseclass;
    PayData *_payd;
}

@end

@implementation BuyViewController
@synthesize moneystring = _moneystring;
@synthesize vipdata;
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Qianbao) name:@"QIANBAOSUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Wxchaxun) name:@"WEIXINCHAXUN" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WxPaySuccess) name:@"WXPAYSUCCESS" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    // Do any additional setup after loading the view.
    
    if (![self.moneystring isEqualToString:@"0"]) {
        self.navlabel.text = @"真人管家预定卡购买";

    }else{
        self.navlabel.text = @"充值支付";

    }
    
    
    
   _payd = [[PayData alloc]init];
    
    ISLoginManager *_manager = [ISLoginManager shareManager];

    
    _buyview = [[BuyView alloc]initWithFrame:FRAME(0, 64, _WIDTH, _HEIGHT-64) num:([self.moneystring isEqualToString:@"300"] ? 2 : 3)];
    _buyview.backgroundColor = COLOR_VAULE(242.0);
    _buyview.zhanghu = [NSString stringWithFormat:@"%@", _manager.telephone];
    if ([self.moneystring isEqualToString:@"0"]) {
        if (_card_type==100) {
            _buyview.jine = [NSString stringWithFormat:@"￥%@",_card_money];
        }else{
            _buyview.jine = [NSString stringWithFormat:@"￥%.f",self.vipdata.cardPay];
        }
        
    }else{
        _buyview.jine = self.moneystring;
    }
    _buyview.delegate = self;
    if ([self.moneystring isEqualToString:@"0"]) {
        _buyview.fanxian = [NSString stringWithFormat:@"￥ %.f",self.vipdata.cardValue - vipdata.cardPay];
    }

    [self.view addSubview:_buyview];
    
    if (![self.moneystring isEqualToString:@"0"]) {
     
        [self getMyYue];
        
    }
    
}
- (void)Wxchaxun
{
    [WeiXinPay paySuccessOrFailWithOrderNo:_payd.ordernumber orderType:@"1"];
}
- (void)WxPaySuccess
{
    [self.navigationController popViewControllerAnimated:YES];
    [self showAlertViewWithTitle:@"提示" message:@"购买成功"];
}
- (void)Qianbao{
    UserInfoViewController *user = [[UserInfoViewController alloc]init];
    [self.navigationController presentViewController:user animated:YES completion:nil];
}
#pragma mark 获得余额
- (void)getMyYue
{
    ISLoginManager *_manager = [ISLoginManager shareManager];

    DownloadManager *_download = [[DownloadManager alloc]init];
    [_download requestWithUrl:USER_INFO dict:@{@"user_id":_manager.telephone} view:self.view delegate:self finishedSEL:@selector(GetUserInfo:) isPost:NO failedSEL:@selector(FailDownload:)];
}

- (void)GetUserInfo:(id)responsobject
{
    _userbaseclass = [[USERINFOBaseClass alloc]initWithDictionary:responsobject];
    _buyview.selfmoney = [NSString stringWithFormat:@"%.2f",_userbaseclass.data.restMoney];
}

#pragma mark 确认支付按钮
- (void)buyBtnPressedisAli:(BOOL)isAli
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    
 
    if (_manager.isLogin) {
        
        if (![self.moneystring isEqualToString:@"0"]) {
            
            if (isAli) {
                NSDictionary *_dict = @{@"user_id":_manager.telephone,@"senior_type":@"1",@"pay_type":@"1"};
                DownloadManager *_download = [[DownloadManager alloc]init];
                [_download requestWithUrl:simi_GOUMAI dict:_dict view:self.view delegate:self finishedSEL:@selector(DownloadFinish:) isPost:YES failedSEL:@selector(FailDownload:)];
                
            }else{
                //余额购买管家卡
                
                if (_userbaseclass.data.restMoney < 300) {
                    [self showAlertViewWithTitle:@"提示" message:@"余额不足以此次支付，请充值!"];
                }else{
                    NSDictionary *_dict = @{@"user_id":_manager.telephone,@"senior_type":@"1",@"pay_type":@"0"};
                    DownloadManager *_download = [[DownloadManager alloc]init];
                    [_download requestWithUrl:simi_GOUMAI dict:_dict view:self.view delegate:self finishedSEL:@selector(YueDownloadFinish:) isPost:YES failedSEL:@selector(FailDownload:)];

                }
            }
            
        }else{
            
            NSString *pay_type;
            if (_buyview.ZFB == YES){
                pay_type=@"1";
            }else{
                pay_type=@"2";
            }
            NSDictionary *_parms;
            if (_card_type==100) {
                _parms = @{@"user_id":_manager.telephone,@"card_type":@"0",@"pay_type":pay_type,@"card_money":_card_money};
            }else{
                NSLog(@"%.f",self.vipdata.dataIdentifier);
                _parms = @{@"user_id":_manager.telephone,@"card_type":[NSString stringWithFormat:@"%.f",self.vipdata.dataIdentifier],@"pay_type":pay_type,@"card_money":@"0"};
            }
            
            NSLog(@"%@",[NSString stringWithFormat:@"%.f",self.vipdata.dataIdentifier]);
            
            
            DownloadManager *_download = [[DownloadManager alloc]init];
            [_download requestWithUrl:VIP_CHONGZHI dict:_parms view:self.view delegate:self finishedSEL:@selector(VIPDownloadFinish:) isPost:YES failedSEL:@selector(FailDownload:)];

        }
        

    }else{
        
//        MyLogInViewController *userinfo = [[MyLogInViewController alloc]init];
//        userinfo.vCLID=0;
//        [self presentViewController:userinfo animated:YES completion:nil];

    }
    

}


- (void)FailDownload:(id)error
{
    NSLog(@"%@",error);
}

#pragma mark 余额购买管家卡
- (void)YueDownloadFinish:(id)responsobject
{
    NSLog(@"res is %@  msg is %@",responsobject,[responsobject objectForKey:@"msg"]);
    
    NSInteger _status = [[responsobject objectForKey:@"status"] integerValue];
    
    if (_status == 0) {

//        
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"PAYSUCCESS" object:@"simika"];
        UserInfoViewController *user = [[UserInfoViewController alloc]init];
        [self.navigationController presentViewController:user animated:YES completion:nil];
        
        _buyview.selfmoney = [NSString stringWithFormat:@"%.2f",_userbaseclass.data.restMoney-300];
//        [self showAlertViewWithTitle:@"提示" message:@"购买管家卡服务成功"];
    }
}


#pragma mark 会员卡充值
- (void)VIPDownloadFinish:(id)responsobject
{
    
    NSLog(@"responsobject is %@",responsobject);

    
    NSInteger _status = [[responsobject objectForKey:@"status"] integerValue];

    if (_status == 0) {
        NSString *_cardmoney = [[responsobject objectForKey:@"data"] objectForKey:@"card_pay"];
   
        _payd.ordernumber = [[responsobject objectForKey:@"data"] objectForKey:@"card_order_no"];
        _payd.ordermoney = _cardmoney;
        

        if (_buyview.ZFB == YES) {
            NSLog(@"zfb");
            [self GotoZhifuBaoWithData:_payd noty:VIPCHONGZHI_NOTYURL];

        }else{
            NSLog(@"wx");
            [WeiXinPay WXPaywithOrderNo:_payd.ordernumber orderType:@"1"];
            
        }
    }

}


#pragma mark 管家卡购买接口w
- (void)DownloadFinish:(id)responsobject
{
    NSInteger _status = [[responsobject objectForKey:@"status"] integerValue];

    NSLog(@"responsobject is %@",responsobject);

    if (_status == 0) {
        
        NSString *_cardmoney = [[responsobject objectForKey:@"data"] objectForKey:@"senior_pay"];

        _payd.ordernumber = [[responsobject objectForKey:@"data"] objectForKey:@"senior_order_no"];
        _payd.ordermoney = _cardmoney;
        
        [self GotoZhifuBaoWithData:_payd noty:simi_NOTYURL];

    }
    
}

- (void)GotoZhifuBaoWithData:(PayData *)paydata noty:(NSString *)notyurl
{
    AliPayManager *_alimanager = [[AliPayManager alloc]init];
    [_alimanager requestWitDelegate:self data:paydata finishedSEL:@selector(PaySuccess:) notyurl:notyurl];
    
} 


- (void)PaySuccess:(id)responsobject
{
    NSLog(@"==== %@",responsobject);

    NSString *result = [responsobject objectForKey:@"resultStatus"];
    if ([result isEqualToString:@"9000"]) {

        UserInfoViewController *user = [[UserInfoViewController alloc]init];
        [self.navigationController presentViewController:user animated:YES completion:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
