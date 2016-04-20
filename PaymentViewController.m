//
//  PaymentViewController.m
//  simi
//
//  Created by 白玉林 on 15/9/15.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "PaymentViewController.h"
#import "PayMentView.h"
#import "AliPayManager.h"
#import "DownloadManager.h"
#import "ISLoginManager.h"
#import "USERINFODataModels.h"
#import "UserInfoViewController.h"
#import "WeiXinPay.h"
#import "BuySecretaryViewController.h"
#import "Order_ListViewController.h"
#import "Order_DetailsViewController.h"
#import "BindMobileViewController.h"
#import "ZeroViewController.h"
#import "UsedDressViewController.h"
#import "MineJifenViewController.h"
@interface PaymentViewController ()<BUYDELEGATE>
{
    PayMentView *_buyview;
    USERINFOBaseClass *_userbaseclass;
    PayData *_payd;
    NSInteger status;
    NSDictionary *detailsDIC;
    int A;
    MineJifenViewController *volumeVC;
    UsedDressViewController *dress;
    NSString *addressName;
    NSString *addressID;
    NSString *moneyStr;
    NSString *couponId;
    
    UIScrollView *myScrollview;
}
@end

@implementation PaymentViewController
@synthesize moneystring = _moneystring;
@synthesize vipdata;
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Qianbao) name:@"QIANBAOSUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Wxchaxun) name:@"WEIXINCHAXUN" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WxPaySuccess) name:@"WXPAYSUCCESS" object:nil];
    
    if (volumeVC.moneyString) {
        _actualStr=volumeVC.moneyString;
        couponId=volumeVC.coupon_id;
    }else{
        _actualStr=@"0";
    }
    int mone=[_moneyStr intValue];
    int actual=[_actualStr intValue];
    int actMone=mone-actual;
    moneyStr=[NSString stringWithFormat:@"%d",actMone];
    _buyview.actualString=moneyStr;
    _buyview.volumeString=[NSString stringWithFormat:@"为您节省%@.0元",_actualStr];
    if (dress.addCityID) {
        NSLog(@"1111");
        addressID=dress.addCityID;
        addressName=dress.ctiyString;
    }
    _buyview.addressString=addressName;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    A=0;
    myScrollview=[[UIScrollView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    myScrollview.delegate=self;
    [self.view addSubview:myScrollview];
    self.navlabel.text=@"购买支付";
    myScrollview.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    [self viewLayout];
    // Do any additional setup after loading the view.
}
-(void)viewLayout
{
    
    dress=[[UsedDressViewController alloc]init];
    _payd = [[PayData alloc]init];
    
    ISLoginManager *_manager = [ISLoginManager shareManager];
    
    if ([_addssID intValue]==0) {
        _buyview = [[PayMentView alloc]initWithFrame:FRAME(0, 0, _WIDTH, _HEIGHT-64) num:([self.moneystring isEqualToString:@"300"] ? 2 : 3) addid:[_addssID intValue]];
    }else{
        _buyview = [[PayMentView alloc]initWithFrame:FRAME(0, 0, _WIDTH, _HEIGHT-34) num:([self.moneystring isEqualToString:@"300"] ? 2 : 3) addid:[_addssID intValue]];
    }
    myScrollview.contentSize=CGSizeMake(WIDTH, _buyview.frame.size.height);
    _buyview.addressID=[_addssID intValue];
    _buyview.backgroundColor = COLOR_VAULE(242.0);
    _buyview.zhanghu = [NSString stringWithFormat:@"%@", _manager.telephone];
    _buyview.jine = [NSString stringWithFormat:@"%@",_buyString];
    _buyview.delegate = self;
    _buyview.fanxian =_moneyStr;
    
    
    [myScrollview addSubview:_buyview];
    
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
    orderVC.details_ID=3;
    orderVC.user_ID=[NSString stringWithFormat:@"%@",[detailsDIC objectForKey:@"user_id"]];
    orderVC.order_ID=[NSString stringWithFormat:@"%@",[detailsDIC objectForKey:@"order_id"]];
    [self.navigationController pushViewController:orderVC animated:YES];
    [self showAlertViewWithTitle:@"提示" message:@"购买成功"];
    
}
- (void)Qianbao{
    Order_DetailsViewController *orderVC=[[Order_DetailsViewController alloc]init];
    orderVC.details_ID=3;
    orderVC.user_ID=[NSString stringWithFormat:@"%@",[detailsDIC objectForKey:@"user_id"]];
    orderVC.order_ID=[NSString stringWithFormat:@"%@",[detailsDIC objectForKey:@"order_id"]];
    [self.navigationController pushViewController:orderVC animated:YES];
}
#pragma mark 订单—服务下单成功返回接口
-(void)ORder_GetUserInfo:(id)sender
{
    NSLog(@"下单成功%@",sender);
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
    volumeVC.viewConllorID=1;
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
                AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
                NSString *moile=[delegate.globalDic objectForKey:@"mobile"];
                // NSLog(@"手机号： %@",textfield.text);
                if (moile==nil||moile==NULL) {
                    
                    UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有绑定手机号，请绑定手机号！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alerView show];
                    BindMobileViewController *bindVC=[[BindMobileViewController alloc]init];
                    [self.navigationController pushViewController:bindVC animated:YES];
                    
                }else{
                    NSString *phonestring = moile;
                    NSString * MOBILE = @"1[0-9]{10}";
                    
                    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
                    
                    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
                    
                    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
                    
                    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
                    
                    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
                    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
                    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
                    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
                    BOOL res1 = [regextestmobile evaluateWithObject:phonestring];
                    BOOL res2 = [regextestcm evaluateWithObject:phonestring];
                    BOOL res3 = [regextestcu evaluateWithObject:phonestring];
                    BOOL res4 = [regextestct evaluateWithObject:phonestring];
                    if (res1 || res2 || res3 || res4) {
                        NSDictionary *dic;
                        ISLoginManager *_manager = [ISLoginManager shareManager];
                        DownloadManager *_download = [[DownloadManager alloc]init];
                        int addresIDS=[_addssID intValue];
                        if (addresIDS==0) {
                            if ([_actualStr isEqualToString:@"0"]) {
                                dic=@{@"partner_user_id":_sec_ID,@"service_type_id":_service_type_id,@"service_price_id":_service_price_id,@"user_id":_manager.telephone,@"mobile":moile,@"pay_type":pay_type};
                            }else{
                                dic=@{@"partner_user_id":_sec_ID,@"service_type_id":_service_type_id,@"service_price_id":_service_price_id,@"user_id":_manager.telephone,@"mobile":moile,@"pay_type":pay_type,@"user_coupon_id":couponId
                                      };
                            }
                            
                        }else{
                            if ([_actualStr isEqualToString:@"0"]) {
                                if (addressID==nil||addressID==NULL||[addressID isEqualToString:@""]) {
                                    UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"您还没有选择地址！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                    [tsView show];
                                    return;
                                }
                                dic=@{@"partner_user_id":_sec_ID,@"service_type_id":_service_type_id,@"service_price_id":_service_price_id,@"user_id":_manager.telephone,@"mobile":moile,@"pay_type":pay_type,@"addr_id":addressID};
                            }else{
                                if (addressID==nil||addressID==NULL||[addressID isEqualToString:@""]) {
                                    UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"您还没有选择地址！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                    [tsView show];
                                    return;
                                }
                                dic=@{@"partner_user_id":_sec_ID,@"service_type_id":_service_type_id,@"service_price_id":_service_price_id,@"user_id":_manager.telephone,@"mobile":moile,@"pay_type":pay_type,@"user_coupon_id":couponId,@"addr_id":addressID};
                            }
                            
                        }
                        
                        [_download requestWithUrl:ORDER_FWXD dict:dic view:self.view delegate:self finishedSEL:@selector(VIPDownloadFinish:) isPost:YES failedSEL:@selector(ORder_FailDownload:)];
                    }
                    else
                    {
                        UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您绑定的手机号不正确，请重新绑定手机号！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alerView show];
                        BindMobileViewController *bindVC=[[BindMobileViewController alloc]init];
                        [self.navigationController pushViewController:bindVC animated:YES];
                    }
                    
                }
                
            }else{
                //余额购买管家卡
                int mony=[moneyStr intValue];
                if (_userbaseclass.data.restMoney < mony) {
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
                    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
                    NSString *moile=[delegate.globalDic objectForKey:@"mobile"];
                    // NSLog(@"手机号： %@",textfield.text);
                    if (moile==nil||moile==NULL) {
                        
                        UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有绑定手机号，请绑定手机号！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alerView show];
                        BindMobileViewController *bindVC=[[BindMobileViewController alloc]init];
                        [self.navigationController pushViewController:bindVC animated:YES];
                        
                    }else{
                        NSString *phonestring = moile;
                        NSString * MOBILE = @"1[0-9]{10}";
                        
                        NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
                        
                        NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
                        
                        NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
                        
                        // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
                        
                        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
                        NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
                        NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
                        NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
                        BOOL res1 = [regextestmobile evaluateWithObject:phonestring];
                        BOOL res2 = [regextestcm evaluateWithObject:phonestring];
                        BOOL res3 = [regextestcu evaluateWithObject:phonestring];
                        BOOL res4 = [regextestct evaluateWithObject:phonestring];
                        if (res1 || res2 || res3 || res4) {
                            NSDictionary *dic;
                            ISLoginManager *_manager = [ISLoginManager shareManager];
                            DownloadManager *_download = [[DownloadManager alloc]init];
                            int addresIDS=[_addssID intValue];
                            if (addresIDS==0) {
                                if ([_actualStr isEqualToString:@"0"]) {
                                    dic=@{@"partner_user_id":_sec_ID,@"service_type_id":_service_type_id,@"service_price_id":_service_price_id,@"user_id":_manager.telephone,@"mobile":moile,@"pay_type":pay_type};
                                }else{
                                    dic=@{@"partner_user_id":_sec_ID,@"service_type_id":_service_type_id,@"service_price_id":_service_price_id,@"user_id":_manager.telephone,@"mobile":moile,@"pay_type":pay_type,@"user_coupon_id":couponId
                                          };
                                }
                                
                            }else{
                                if ([_actualStr isEqualToString:@"0"]) {
                                    
                                    if (addressID==nil||addressID==NULL||[addressID isEqualToString:@""]) {
                                        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"您还没有选择地址！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                        [tsView show];
                                        return;
                                    }dic=@{@"partner_user_id":_sec_ID,@"service_type_id":_service_type_id,@"service_price_id":_service_price_id,@"user_id":_manager.telephone,@"mobile":moile,@"pay_type":pay_type,@"addr_id":addressID};
                                }else{
                                    if (addressID==nil||addressID==NULL||[addressID isEqualToString:@""]) {
                                        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"您还没有选择地址！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                        [tsView show];
                                        return;
                                    }
                                    dic=@{@"partner_user_id":_sec_ID,@"service_type_id":_service_type_id,@"service_price_id":_service_price_id,@"user_id":_manager.telephone,@"mobile":moile,@"pay_type":pay_type,@"user_coupon_id":couponId,@"addr_id":addressID};
                                }
                                
                            }
                            
                            [_download requestWithUrl:ORDER_FWXD dict:dic view:self.view delegate:self finishedSEL:@selector(VIPDownloadFinish:) isPost:YES failedSEL:@selector(ORder_FailDownload:)];
                        }
                        else
                        {
                            UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您绑定的手机号不正确，请重新绑定手机号！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alerView show];
                            BindMobileViewController *bindVC=[[BindMobileViewController alloc]init];
                            [self.navigationController pushViewController:bindVC animated:YES];
                        }
                        
                    }
                    
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
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
            NSString *moile=[delegate.globalDic objectForKey:@"mobile"];
           // NSLog(@"手机号： %@",textfield.text);
            if (moile==nil||moile==NULL) {
                
                UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有绑定手机号，请绑定手机号！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alerView show];
                BindMobileViewController *bindVC=[[BindMobileViewController alloc]init];
                [self.navigationController pushViewController:bindVC animated:YES];
                
            }else{
                NSString *phonestring = moile;
                NSString * MOBILE = @"1[0-9]{10}";
                
                NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
                
                NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
                
                NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
                
                // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
                
                NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
                NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
                NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
                NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
                BOOL res1 = [regextestmobile evaluateWithObject:phonestring];
                BOOL res2 = [regextestcm evaluateWithObject:phonestring];
                BOOL res3 = [regextestcu evaluateWithObject:phonestring];
                BOOL res4 = [regextestct evaluateWithObject:phonestring];
                if (res1 || res2 || res3 || res4) {
                    NSDictionary *dic;
                    ISLoginManager *_manager = [ISLoginManager shareManager];
                    DownloadManager *_download = [[DownloadManager alloc]init];
                    int addresIDS=[_addssID intValue];
                    if (addresIDS==0) {
                        if ([_actualStr isEqualToString:@"0"]) {
                            dic=@{@"partner_user_id":_sec_ID,@"service_type_id":_service_type_id,@"service_price_id":_service_price_id,@"user_id":_manager.telephone,@"mobile":moile,@"pay_type":pay_type};
                        }else{
                            dic=@{@"partner_user_id":_sec_ID,@"service_type_id":_service_type_id,@"service_price_id":_service_price_id,@"user_id":_manager.telephone,@"mobile":moile,@"pay_type":pay_type,@"user_coupon_id":couponId
                                  };
                        }

                    }else{
                        if ([_actualStr isEqualToString:@"0"]) {
                            if (addressID==nil||addressID==NULL||[addressID isEqualToString:@""]) {
                                UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"您还没有选择地址！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                [tsView show];
                                return;
                            }
                            dic=@{@"partner_user_id":_sec_ID,@"service_type_id":_service_type_id,@"service_price_id":_service_price_id,@"user_id":_manager.telephone,@"mobile":moile,@"pay_type":pay_type,@"addr_id":addressID};
                        }else{
                            if (addressID==nil||addressID==NULL||[addressID isEqualToString:@""]) {
                                UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"您还没有选择地址！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                [tsView show];
                                return;
                            }
                            dic=@{@"partner_user_id":_sec_ID,@"service_type_id":_service_type_id,@"service_price_id":_service_price_id,@"user_id":_manager.telephone,@"mobile":moile,@"pay_type":pay_type,@"user_coupon_id":couponId,@"addr_id":addressID};
                        }

                    }
                    
                    [_download requestWithUrl:ORDER_FWXD dict:dic view:self.view delegate:self finishedSEL:@selector(VIPDownloadFinish:) isPost:YES failedSEL:@selector(ORder_FailDownload:)];
                }
                else
                {
                    UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您绑定的手机号不正确，请重新绑定手机号！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alerView show];
                    BindMobileViewController *bindVC=[[BindMobileViewController alloc]init];
                    [self.navigationController pushViewController:bindVC animated:YES];
                }

            }
            
            
            
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
    
    detailsDIC=[responsobject objectForKey:@"data"];
    status = [[responsobject objectForKey:@"status"] integerValue];
    
    if (status == 0) {
        NSString *_cardmoney =[[responsobject objectForKey:@"data"] objectForKey:@"order_pay"];
        
        _payd.ordernumber = [[responsobject objectForKey:@"data"] objectForKey:@"order_no"];
        NSLog(@"%@",_payd.ordernumber);
        _payd.ordermoney =_cardmoney;
        
        if (_buyview.ZFB == YES) {
        NSLog(@"zfb");
        [self GotoZhifuBaoWithData:_payd noty:ORDEL_NOTYURL];
                
        }else{
            if (_buyview.MODE==YES) {
                Order_DetailsViewController *orderVC=[[Order_DetailsViewController alloc]init];
                orderVC.details_ID=3;
                orderVC.user_ID=[NSString stringWithFormat:@"%@",[detailsDIC objectForKey:@"user_id"]];
                orderVC.order_ID=[NSString stringWithFormat:@"%@",[detailsDIC objectForKey:@"order_id"]];
                [self.navigationController pushViewController:orderVC animated:YES];
            }else{
                NSLog(@"wx");
                [WeiXinPay WXPaywithOrderNo:_payd.ordernumber orderType:@"0"];            }

        
        }
        //NSLog(@"%@,%@",_cardmoney,_payd.ordernumber);
        
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
        int mony=[moneyStr intValue];
        _buyview.selfmoney = [NSString stringWithFormat:@"%.2f",_userbaseclass.data.restMoney-mony];
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
//        NSString *pay_type;
//        if (_buyview.ZFB==YES) {
//            pay_type=@"1";
//        }else{
//            pay_type=@"2";
//        }
//        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
//        NSString *moile=[delegate.globalDic objectForKey:@"mobile"];
//        ISLoginManager *_manager = [ISLoginManager shareManager];
//        DownloadManager *_download = [[DownloadManager alloc]init];
//        NSDictionary *dic=@{@"partner_user_id":_sec_ID,@"service_type_id":_service_type_id,@"service_price_id":_service_price_id,@"user_id":_manager.telephone,@"mobile":moile,@"pay_type":pay_type};
//        [_download requestWithUrl:ORDER_FWXD dict:dic view:self.view delegate:self finishedSEL:@selector(VIPDownloadFinish:) isPost:YES failedSEL:@selector(ORder_FailDownload:)];
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
        
        [self GotoZhifuBaoWithData:_payd noty:ORDEL_NOTYURL];
        
    }
    
}

- (void)GotoZhifuBaoWithData:(PayData *)paydata noty:(NSString *)notyurl
{
    AliPayManager *_alimanager = [[AliPayManager alloc]init];
    _alimanager.categoryID=1;
    NSLog(@"支付宝数据%@",paydata);
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
