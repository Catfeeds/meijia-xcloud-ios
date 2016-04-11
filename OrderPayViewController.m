//
//  OrderPayViewController.m
//  yxz
//
//  Created by 白玉林 on 15/11/14.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "OrderPayViewController.h"
#import "OrderPay.h"
#import "AliPayManager.h"
#import "DownloadManager.h"
#import "ISLoginManager.h"
//#import "MyLogInViewController.h"
#import "USERINFODataModels.h"
#import "UserInfoViewController.h"
#import "WeiXinPay.h"

#import "BuySecretaryViewController.h"
#import "Order_ListViewController.h"
#import "Order_DetailsViewController.h"

#import "UsedDressViewController.h"
#import "MineJifenViewController.h"
#import "Water_Order_DetailsViewController.h"
@interface OrderPayViewController ()<BUYDELEGATE>
{
    OrderPay *_buyview;
    USERINFOBaseClass *_userbaseclass;
    PayData *_payd;
    NSInteger status;
    int A;
    MineJifenViewController *volumeVC;
    UsedDressViewController *dress;
    NSString *addressName;
    NSString *addressID;
    NSString *moneyStr;
    NSString *couponId;
}


@end

@implementation OrderPayViewController
@synthesize moneystring = _moneystring;
@synthesize vipdata;
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Qianbao) name:@"QIANBAOSUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Wxchaxun) name:@"WEIXINCHAXUN" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WxPaySuccess) name:@"WXPAYSUCCESS" object:nil];
    if (volumeVC.moneyString) {
        _actualStr=volumeVC.moneyString;
        couponId=volumeVC.coupon_id;
    }else{
        NSString *str=[NSString stringWithFormat:@"%@",[_orderPayDic objectForKey:@"user_coupon_value"]];
        if (str==nil||str==NULL||[str isEqualToString:@"(null)"]) {
            _actualStr=@"0";
        }else{
            _actualStr=str;
            couponId=[NSString stringWithFormat:@"%@",[_orderPayDic objectForKey:@"user_coupon_id"]];
        }
        
    }
    int mone=[_moneyStr intValue];
    int actual=[_actualStr intValue];
    int actMone=mone-actual;
    moneyStr=[NSString stringWithFormat:@"%d",actMone];
    _buyview.actualString=moneyStr;
    _buyview.volumeString=[NSString stringWithFormat:@"为您节省%@元",_actualStr];
    if (dress.addCityID) {
        NSLog(@"1111");
        addressID=dress.addCityID;
        addressName=dress.ctiyString;
    }else{
        addressID=dress.addCityID;
        addressName=[NSString stringWithFormat:@"%@",[_orderPayDic objectForKey:@"addr_name"]];
    }
    _buyview.addressString=addressName;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    A=0;
    self.navlabel.text=@"购买支付";
    self.view.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    
    [self viewLayout];
    // Do any additional setup after loading the view.
}
-(void)viewLayout
{
    
    _payd = [[PayData alloc]init];
    
    ISLoginManager *_manager = [ISLoginManager shareManager];
    
    
    _buyview = [[OrderPay alloc]initWithFrame:FRAME(0, 64, _WIDTH, _HEIGHT-64) num:([self.moneystring isEqualToString:@"300"] ? 2 : 3)];
    _buyview.backgroundColor = COLOR_VAULE(242.0);
    _buyview.addressID=[_addssID intValue];
    _buyview.zhanghu = [NSString stringWithFormat:@"%@", _manager.telephone];
    _buyview.jine = [NSString stringWithFormat:@"%@",_buyString];
    _buyview.delegate = self;
    _buyview.fanxian =_moneyStr;
    
    [self.view addSubview:_buyview];
    
    if (![self.moneystring isEqualToString:@"0"]) {
        
        [self getMyYue];
        
    }
    
    
}
- (void)Wxchaxun
{
    [WeiXinPay paySuccessOrFailWithOrderNo:_payd.ordernumber orderType:@"0"];
}
- (void)WxPaySuccess
{
    
        Order_DetailsViewController *orderVC=[[Order_DetailsViewController alloc]init];
        orderVC.details_ID=5;
        orderVC.user_ID=_user_ID;
        orderVC.order_ID=_order_ID;
        [self.navigationController pushViewController:orderVC animated:YES];
    
    [self showAlertViewWithTitle:@"提示" message:@"购买成功"];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
        Order_DetailsViewController *orderVC=[[Order_DetailsViewController alloc]init];
        orderVC.details_ID=5;
        orderVC.user_ID=_user_ID;
        orderVC.order_ID=_order_ID;
        [self.navigationController pushViewController:orderVC animated:YES];
    
    [self showAlertViewWithTitle:@"提示" message:@"购买成功"];
    NSLog(@"clickButtonAtIndex:%d",1);
}
- (void)Qianbao{
    //    UserInfoViewController *user = [[UserInfoViewController alloc]init];
    //    [self.navigationController presentViewController:user animated:YES completion:nil];
    
        Order_DetailsViewController *orderVC=[[Order_DetailsViewController alloc]init];
        orderVC.details_ID=5;
        orderVC.user_ID=_user_ID;
        orderVC.order_ID=_order_ID;
        [self.navigationController pushViewController:orderVC animated:YES];
        [self showAlertViewWithTitle:@"提示" message:@"购买成功"];
    
}
#pragma mark 订单—服务下单成功返回接口
-(void)ORder_GetUserInfo:(id)sender
{
    NSLog(@"下单成功%@",sender);
    //    Order_ListViewController *orderListVC=[[Order_ListViewController alloc]init];
    //    [self.navigationController pushViewController:orderListVC animated:YES];
}
#pragma mark 订单—服务下单失败返回接口
-(void)ORder_FailDownload:(id)sender
{
    NSLog(@"下单失败%@",sender);
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
#pragma mark 优惠券按钮点击方法
-(void)buyBtnVolume:(UIButton *)sender
{
    volumeVC=[[MineJifenViewController alloc]init];
    [self.navigationController pushViewController:volumeVC animated:YES];
}
#pragma mark 地址点击方法
-(void)buyBtnAddRess:(UIButton *)sender
{
    NSLog(@"dizhi");
    dress = [[UsedDressViewController alloc]init];
    [self.navigationController pushViewController:dress animated:YES];
    
}
#pragma mark 确认支付按钮
- (void)buyBtnPressedisAli:(BOOL)isAli
{
    
//    _payd.ordernumber = _orderStr;
//    _payd.ordermoney = _moneyStr;
//    
//    
//    if (_buyview.ZFB == YES) {
//        NSLog(@"zfb");
//        [self GotoZhifuBaoWithData:_payd noty:ORDEL_NOTYURL];
//        
//    }else{
//        NSLog(@"wx");
//        [WeiXinPay WXPaywithOrderNo:_payd.ordernumber orderType:@"0"];
//        
//    }

    ISLoginManager *_manager = [ISLoginManager shareManager];
    
    
    if (_manager.isLogin) {
        
        if (![self.moneystring isEqualToString:@"0"]) {
            
            if (isAli) {
                NSString *pay_type;
                if (_buyview.ZFB==YES) {
                    pay_type=@"1";
                }else{
                    if (_buyview.MODE==YES) {
                        pay_type=@"0";
                    }else{
                        pay_type=@"2";
                    }

                }
                
                NSDictionary *_parms;
                int is_addrID=[_addssID intValue];
                NSLog(@"_a%@",_actualStr);
                if (is_addrID==0) {
                    if ([_actualStr isEqualToString:@"0"]){
                        _parms=@{@"user_id":_manager.telephone,@"order_id":_order_ID,@"order_no":_orderStr,@"pay_type":pay_type};
                        
                    }else{
                        _parms=@{@"user_id":_manager.telephone,@"order_id":_order_ID,@"order_no":_orderStr,@"pay_type":pay_type,@"user_coupon_id":couponId};
                    }
                }else{
                    
                    if ([_actualStr isEqualToString:@"0"]){
                        _parms=@{@"user_id":_manager.telephone,@"order_id":_order_ID,@"order_no":_orderStr,@"pay_type":pay_type,@"addr_id":addressID};
                        
                    }else{
                        _parms=@{@"user_id":_manager.telephone,@"order_id":_order_ID,@"order_no":_orderStr,@"pay_type":pay_type,@"user_coupon_id":couponId,@"addr_id":addressID};
                    }
                }
                
                NSLog(@"%@",_parms);
                
                DownloadManager *_download = [[DownloadManager alloc]init];
                [_download requestWithUrl:ORDER_DDZF dict:_parms view:self.view delegate:self finishedSEL:@selector(VIPDownloadFinish:) isPost:YES failedSEL:@selector(FailDownload:)];
                
            }else{
                //余额购买管家卡
                
                if (_userbaseclass.data.restMoney < 300) {
                    [self showAlertViewWithTitle:@"提示" message:@"余额不足以此次支付，请充值!"];
                }else{
                    NSString *pay_type;
                    if (_buyview.ZFB==YES) {
                        pay_type=@"1";
                    }else{
                        if (_buyview.MODE==YES) {
                            pay_type=@"0";
                        }else{
                            pay_type=@"2";
                        }

                    }
                    
                    NSDictionary *_parms;
                    int is_addrID=[_addssID intValue];
                    if (is_addrID==0) {
                        if ([_actualStr isEqualToString:@"0"]){
                            _parms=@{@"user_id":_manager.telephone,@"order_id":_order_ID,@"order_no":_orderStr,@"pay_type":pay_type};
                            
                        }else{
                            _parms=@{@"user_id":_manager.telephone,@"order_id":_order_ID,@"order_no":_orderStr,@"pay_type":pay_type,@"user_coupon_id":couponId};
                        }
                    }else{
                        
                        if ([_actualStr isEqualToString:@"0"]){
                            _parms=@{@"user_id":_manager.telephone,@"order_id":_order_ID,@"order_no":_orderStr,@"pay_type":pay_type,@"addr_id":addressID};
                            
                        }else{
                            _parms=@{@"user_id":_manager.telephone,@"order_id":_order_ID,@"order_no":_orderStr,@"pay_type":pay_type,@"user_coupon_id":couponId,@"addr_id":addressID};
                        }
                    }
                    
                    NSLog(@"%@",_parms);
                    
                    DownloadManager *_download = [[DownloadManager alloc]init];
                    [_download requestWithUrl:ORDER_DDZF dict:_parms view:self.view delegate:self finishedSEL:@selector(VIPDownloadFinish:) isPost:YES failedSEL:@selector(FailDownload:)];
                    
                }
            }
            
        }else{
            NSString *pay_type;
            if (_buyview.ZFB==YES) {
                pay_type=@"1";
            }else{
                if (_buyview.MODE==YES) {
                    pay_type=@"0";
                }else{
                    pay_type=@"2";
                }

            }
            
            NSDictionary *_parms;
            int is_addrID=[_addssID intValue];
            if (is_addrID==0) {
                if ([_actualStr isEqualToString:@"0"]){
                    _parms=@{@"user_id":_manager.telephone,@"order_id":_order_ID,@"order_no":_orderStr,@"pay_type":pay_type};
                    
                }else{
                    _parms=@{@"user_id":_manager.telephone,@"order_id":_order_ID,@"order_no":_orderStr,@"pay_type":pay_type,@"user_coupon_id":couponId};
                }
            }else{

                if ([_actualStr isEqualToString:@"0"]){
                    _parms=@{@"user_id":_manager.telephone,@"order_id":_order_ID,@"order_no":_orderStr,@"pay_type":pay_type,@"addr_id":addressID};
                    
                }else{
                   _parms=@{@"user_id":_manager.telephone,@"order_id":_order_ID,@"order_no":_orderStr,@"pay_type":pay_type,@"user_coupon_id":couponId,@"addr_id":addressID};
                }
            }
                      
            NSLog(@"%@",_parms);
            
            DownloadManager *_download = [[DownloadManager alloc]init];
            [_download requestWithUrl:ORDER_DDZF dict:_parms view:self.view delegate:self finishedSEL:@selector(VIPDownloadFinish:) isPost:YES failedSEL:@selector(FailDownload:)];
            
        }
        
        
    }else{
        
//        MyLogInViewController *userinfo = [[MyLogInViewController alloc]init];
//        userinfo.vCLID=0;
//        [self presentViewController:userinfo animated:YES completion:nil];
        
    }
    
}
#pragma mark 会员卡充值
- (void)VIPDownloadFinish:(id)responsobject
{
    
    NSLog(@"responsobject is %@",responsobject);
    
    NSDictionary *dic=[responsobject objectForKey:@"data"];
    status = [[responsobject objectForKey:@"status"] integerValue];
    
    if (status == 0) {
        NSString *_cardmoney =[[responsobject objectForKey:@"data"] objectForKey:@"order_pay"];
        
        _payd.ordernumber = [[responsobject objectForKey:@"data"] objectForKey:@"order_no"];
        _payd.ordermoney = _cardmoney;
        
        
        if (_buyview.ZFB == YES) {
            NSLog(@"zfb");
            [self GotoZhifuBaoWithData:_payd noty:ORDEL_NOTYURL];
            
        }else{
            if (_buyview.MODE==YES) {
                if (_orderVCID==1) {
                    Order_DetailsViewController *orderVC=[[Order_DetailsViewController alloc]init];
                    orderVC.details_ID=1;
                    orderVC.user_ID=_user_ID;
                    orderVC.order_ID=_order_ID;
                    [self.navigationController pushViewController:orderVC animated:YES];
                }else if(_orderVCID==100){
                    Water_Order_DetailsViewController *orderVC=[[Water_Order_DetailsViewController alloc]init];
                    orderVC.details_ID=5;
                    orderVC.user_ID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"user_id"]];
                    orderVC.order_ID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"order_id"]];
                    [self.navigationController pushViewController:orderVC animated:YES];
                }

            }else{
                NSLog(@"wx");
                [WeiXinPay WXPaywithOrderNo:_payd.ordernumber orderType:@"0"];
            }

            
            
        }
       
    }else{
        //        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"购买成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [tsView show];
        //        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (void)FailDownload:(id)error
{
    
    NSLog(@"请求失败%@",error);
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



-(void)viewDidAppear:(BOOL)animated
{
    if (A==0) {
        
    }else{
//        ISLoginManager *_manager = [ISLoginManager shareManager];
//        NSString *cardTypeString=[NSString stringWithFormat:@"%d",_cardTypeID];
//        NSDictionary *_parms = @{@"user_id":_manager.telephone,@"sec_id":_sec_ID,@"senior_type_id":cardTypeString,@"pay_type":@"1"};
//        NSLog(@"%@",_parms);
//        
//        DownloadManager *_download = [[DownloadManager alloc]init];
//        [_download requestWithUrl:SEEK_ZFB dict:_parms view:self.view delegate:self finishedSEL:@selector(VIPDownloadFinish:) isPost:YES failedSEL:@selector(FailDownload:)];
    }
    A+=1;
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
        
        [self GotoZhifuBaoWithData:_payd noty:ORDER_DDHD];
        
    }
    
}

- (void)GotoZhifuBaoWithData:(PayData *)paydata noty:(NSString *)notyurl
{
    AliPayManager *_alimanager = [[AliPayManager alloc]init];
    if (_vCID==100) {
        _alimanager.categoryID=3;
    }else{
        _alimanager.categoryID=2;
    }
    
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
