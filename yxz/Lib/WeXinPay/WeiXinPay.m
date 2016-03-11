//
//  WeiXinPay.m
//  simi
//
//  Created by zrj on 15-4-30.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "WeiXinPay.h"
//#import "WXApi.h"

#import "DownloadManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "ISLoginManager.h"
@implementation WeiXinPay

#pragma mark 微信登录
+(void)sendAuthRequest
{
    //构造SendAuthReq结构体
//    SendAuthReq* req =[[SendAuthReq alloc ] init ];
//    req.scope = @"snsapi_userinfo" ;
//    req.state = @"123" ;
//    //第三方向微信终端发送一个SendAuthReq消息结构
//    [WXApi sendReq:req];
}



#pragma mark 微信支付
+(void)WXPaywithOrderNo:(NSString *)orderNo orderType:(NSString *)type
{

    ISLoginManager *manager = [[ISLoginManager alloc]init];
    NSString *phone = manager.telephone;
    NSMutableDictionary *sourceDic = [[NSMutableDictionary alloc]init];
    [sourceDic setObject:phone  forKey:@"user_id"];
    [sourceDic setObject:orderNo forKey:@"order_no"];
    [sourceDic setObject:type forKey:@"order_type"];
    NSLog(@"%@",sourceDic);
    
    AFHTTPRequestOperationManager *mymanager = [AFHTTPRequestOperationManager manager];
    NSLog(@"大会%@",mymanager);
    [mymanager POST:[NSString stringWithFormat:@"%@%@",SERVER_DRESS,WXPAY_URL]
         parameters:sourceDic success:^(AFHTTPRequestOperation *opretion, id responseObject){
      //       NSLog(@"啥你吗玩意％@",responseObject);
             NSLog(@"%@",responseObject);
             NSLog(@"msg__%@",[responseObject objectForKey:@"msg"]);
             int status = [[responseObject objectForKey:@"status"] intValue];
             
             if (status == 0) {
             
                 NSLog(@"%@",responseObject);
//                 NSString *appid = [[responseObject objectForKey:@"data"] objectForKey:@"appId"];
//                 NSString *mobile = [[responseObject objectForKey:@"data"] objectForKey:@"mobile"];
                 NSString *nonceStr = [[responseObject objectForKey:@"data"] objectForKey:@"nonceStr"];
//                 NSString *orderNo = [[responseObject objectForKey:@"data"] objectForKey:@"orderNo"];
                 NSString *package = [[responseObject objectForKey:@"data"] objectForKey:@"package"];
                 NSString *partnerId = [[responseObject objectForKey:@"data"] objectForKey:@"partnerId"];
                 NSString *prepayId = [[responseObject objectForKey:@"data"] objectForKey:@"prepayId"];
                 NSString *sign = [[responseObject objectForKey:@"data"] objectForKey:@"sign"];
//                 NSString *signType = [[responseObject objectForKey:@"data"] objectForKey:@"signType"];
                 NSString *timeStamp = [[responseObject objectForKey:@"data"] objectForKey:@"timeStamp"];
                 
                [self paywhitParttnerId:partnerId prepayId:prepayId nonceStr:nonceStr timeStamp:timeStamp sign:sign package:package];
             }
    }
     
            failure:^(AFHTTPRequestOperation *opration, NSError *error){
                
                NSLog(@"请求失败: %@",error);
                
            }];

}
+ (void)paySuccessOrFailWithOrderNo:(NSString *)orderNo orderType:(NSString *)type
{
    
    ISLoginManager *manager = [[ISLoginManager alloc]init];
    NSString *phone = manager.telephone;
    NSMutableDictionary *sourceDic = [[NSMutableDictionary alloc]init];
    [sourceDic setObject:phone  forKey:@"user_id"];
    [sourceDic setObject:orderNo forKey:@"order_no"];
    [sourceDic setObject:type forKey:@"order_type"];
    NSLog(@"%@",sourceDic);
    
    AFHTTPRequestOperationManager *mymanager = [AFHTTPRequestOperationManager manager];
    [mymanager POST:[NSString stringWithFormat:@"%@%@",SERVER_DRESS,WXPAY_SUCCESS] parameters:sourceDic success:^(AFHTTPRequestOperation *opretion, id responseObject){
             
             NSString *data = [responseObject objectForKey:@"data"];
             if ([data isEqualToString:@"SUCCESS"]) {
                 
                 [[NSNotificationCenter defaultCenter]postNotificationName:@"WXPAYSUCCESS" object:nil];
                 
             }
//             else if([data isEqualToString:@""])
//             {
//                 [[NSNotificationCenter defaultCenter]postNotificationName:@"WXPAYSUCCESS" object:nil];
//             }
         }
            failure:^(AFHTTPRequestOperation *opration, NSError *error){
                
                NSLog(@"请求失败: %@",error);
                
            }];

}
//+ (void)xiadan:(NSString *)token
//{
//    
//    NSMutableDictionary *sourceDic = [[NSMutableDictionary alloc]init];
//    [sourceDic setObject:@"crestxu"  forKey:@"traceid"];
//    [sourceDic setObject:@"wx1c0cdfad5f3bbc79" forKey:@"appid"];
//    [sourceDic setObject:@"111112222233333" forKey:@"noncestr"];
//    [sourceDic setObject:@"Sign=WXPay" forKey:@"package"];
//    [sourceDic setObject:@"1381405298" forKey:@"timestamp"];
//    [sourceDic setObject:@"53cca9d47b883bd4a5c85a9300df3da0cb48565c" forKey:@"app_signature"];
//    [sourceDic setObject:@"sha1" forKey:@"sign_method"];
//    
//    AFHTTPRequestOperationManager *mymanager = [AFHTTPRequestOperationManager manager];
//
//    [mymanager POST:[NSString stringWithFormat:@"https://api.weixin.qq.com/pay/genprepay?access_token=%@",token]  parameters:sourceDic success:^(AFHTTPRequestOperation *opretion, id responseObject){
//        
//        NSLog(@"%@",responseObject);
//        
//        //        NSString *a = responseObject[@"access_token"];
//        
//    }
//     
//           failure:^(AFHTTPRequestOperation *opration, NSError *error){
//               
//               NSLog(@"请求失败: %@",error);
//               
//           }];
//}

+(void)paywhitParttnerId:(NSString *)partnerId prepayId:(NSString *)prepayId nonceStr:(NSString *)nonceStr timeStamp:(NSString *)timeStamp sign:(NSString *)sign package:(NSString *)package
{

//    PayReq *request = [[PayReq alloc] init];
//
////    request.openID = @"wx1c0cdfad5f3bbc79";
//    
//    request.partnerId = partnerId;                           /** 商家向财付通申请的商家id */
//    
//    request.prepayId= prepayId;                              /** 预支付订单 */
//    
//    request.package = package;                               /** 商家根据财付通文档填写的数据和签名 */
//    
//    request.nonceStr= nonceStr;                              /** 随机串，防重发 */
//    
//    request.timeStamp= [timeStamp intValue];                 /** 时间戳，防重发 */
//    
//    request.sign= sign;                                      /** 商家根据微信开放平台文档对数据做的签名 */
//    
//    [WXApi sendReq:request];
    
/**
    //从服务器获取支付参数，服务端自定义处理逻辑和格式
    //订单标题
    NSString *ORDER_NAME    = @"Ios服务器端签名支付 测试";
    //订单金额，单位（元）
    NSString *ORDER_PRICE   = @"0.01";
    
    //根据服务器端编码确定是否转码
    NSStringEncoding enc;
    //if UTF8编码
    //enc = NSUTF8StringEncoding;
    //if GBK编码
    enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *urlString = [NSString stringWithFormat:@"%@?plat=ios&order_no=%@&product_name=%@&order_price=%@",
                           SP_URL,
                           [[NSString stringWithFormat:@"%ld",time(0)] stringByAddingPercentEscapesUsingEncoding:enc],
                           [ORDER_NAME stringByAddingPercentEscapesUsingEncoding:enc],
                           ORDER_PRICE];
    
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
 
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.openID              = [dict objectForKey:@"appid"];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi safeSendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
            }else{
//                [self alert:@"提示信息" msg:[dict objectForKey:@"retmsg"]];
                NSLog(@"1");
            }
        }else{
//            [self alert:@"提示信息" msg:@"服务器返回错误，未获取到json对象"];
            NSLog(@"2");
        }
    }else{
//        [self alert:@"提示信息" msg:@"服务器返回错误"];
        NSLog(@"3");
    }
*/
    
}



@end
