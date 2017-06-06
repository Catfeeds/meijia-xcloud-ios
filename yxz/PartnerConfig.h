//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//


#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088911704798349"
//收款支付宝账号
#define SellerID  @"meijialife@126.com"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAOqA+tDx0dtH/aZ5vfO9fM/r23HJuwYDlzHFSW7D2v0ggr68q26hPBuMtIhBH+QpZbBSCXcuITLRwpU3zbMNo3h8fFMWT8zcYwyG0Va7J69IMuu8PxNdfXY1Pw2rtRe/oVpBuPySK4dsBQdP+on1VXY+q3sPcFDvebnrpOv1Z8apAgMBAAECgYEAsE0NxD65jkleamVGqNPB3TOuBKssX0Ydyn5PSeYXYoypnyqLHB496Vxsca+8gTWaTOgwU5irvuAykSqmDEJprYAc8QOJ+dVoh5nE5dCXKr4sG7fEpB3h4kUJj3SGJNEMwS3WaU5oDibPGDBsSRUKexrKgQq81OomPdmM2r1p2d0CQQD8fouhETZ54j+f0IcEw9YYkTI2w8U9lHIsb3hreGt2aOMeKuFLuNMbwrJDe6g2uJJk5nJSAmA0cKTOCrI0ODirAkEA7cJ9XoYESIsShh7cT0PJ8fV7FwH20VMOHAE/JX3Iz0ic02hT1PiN8Y4IzGX51z41AcYYTiBtPI9DSUOPFUal+wJAd5tmf10NBj3Dz+vTGdG/KJIXTFP+qkYYs632SEqZ9VSISfEcGmeqMVtQYKFCNPHH/14ex3RyqES3/RaaBhyf0wJAHVl21GZCvRm9zaSdmYNKuH2PFkX9y9Uu1rIos14VndDe2xHz10RfcUQRPfoQn0tki7WCZpKGKYWdzrtyPDQeZQJBAPg3YIBsxiYz5LbndMqrjtynWJNKnTpIb4xb8V+GugVZ8QVBNlRF0G690AHAuQ1qYLJ131VCdRuC2oh/4GF1ss8="

//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#endif
