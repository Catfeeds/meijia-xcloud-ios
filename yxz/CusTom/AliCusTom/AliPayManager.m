//
//  AliPayManager.m
//  simi
//
//  Created by 赵中杰 on 14/12/20.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "AliPayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "NSString+StrSize.h"
#import "DataSigner.h"

@implementation AliPayManager
@synthesize mydata = _mydata;
@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)requestWitDelegate:(id)downloaddelegate data:(PayData *)paydata finishedSEL:(SEL)finished notyurl:(NSString *)notyurl
{
         NSLog(@"%@",paydata);
        self.mydata = paydata;
        
        NSString *appScheme = @"wx93aa45d30bf6cba3";
        NSString* orderInfo = [self getOrderInfo:nil noty:notyurl];
        NSString* signedStr = [self doRsa:orderInfo];
        

        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                 orderInfo, signedStr, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
            [downloaddelegate performSelector:finished withObject:resultDic afterDelay:0];
            
        }];
        
}

-(NSString*)getOrderInfo:(NSString *)dingdanid noty:(NSString *)notyurl
{
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    
    Order *order = [[Order alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;//提及订单接口first
    NSLog(@"传递参数%@,%@",order.partner,order.seller);
    NSLog(@"%@",self.mydata.ordernumber);
    NSLog(@"%@",self.mydata.ordermoney);
    order.tradeNO = self.mydata.ordernumber; //订单ID（由商家自行制定）
    if (_categoryID==1) {
        order.productName = @"服务费"; //商品标题
        order.productDescription = @"服务费"; //商品描述
    }else if(_categoryID==3){
        order.productName = @"饮用水支付"; //商品标题
        order.productDescription = @"饮用水支付"; //商品描述
    }else{
        order.productName = @"充值"; //商品标题
        order.productDescription = @"充值"; //商品描述

    }
    order.amount = self.mydata.ordermoney; //商品价格
//    order.amount = @"0.01";
    NSLog(@"url___%@",notyurl);
    order.notifyURL =  [[NSString stringWithFormat:@"%@%@",SERVER_DRESS,notyurl] urlEncodeString]; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    NSLog(@"都有什么%@,%@,%@,%@,%@",order.service,order.paymentType,order.inputCharset,order.itBPay,order.showUrl);

    return [order description];
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

-(void)paymentResultDelegate:(NSString *)result
{
    NSLog(@"%@",result);
}


- (void)payOrder:(NSString *)orderStr
      fromScheme:(NSString *)schemeStr
        callback:(CompletionBlock)completionBlock{
    
}


@end
