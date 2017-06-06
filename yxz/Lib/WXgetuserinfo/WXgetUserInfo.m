//
//  WXgetUserInfo.m
//  simi
//
//  Created by 高鸿鹏 on 15/6/16.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "WXgetUserInfo.h"
#import "AFHTTPRequestOperationManager.h"
#import "MyLogInViewController.h"
@implementation WXgetUserInfo

//通过code获取access_token

+ (void)GetTokenWithCode:(NSString *)code
{

//    NSMutableDictionary *sourceDic = [[NSMutableDictionary alloc]init];
//    [sourceDic setObject:WXAppKey  forKey:@"appid"];
//    [sourceDic setObject:WXsecret forKey:@"secret"];
//    [sourceDic setObject:code forKey:@"code"];
//    [sourceDic setObject:@"authorization_code" forKey:@"grant_type"];

    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WXAppKey,WXsecret,code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

                
                NSString *token = [dic objectForKey:@"access_token"];
                NSString *openid = [dic objectForKey:@"openid"];
//                NSString *refresh_token = [dic objectForKey:@"refresh_token"];

                [self getUserInfoWithToken:token andOpenId:openid];
                }
        });
    });
}
- (void)RefreshToken
{
    
}
//获取用户信息
+ (void)getUserInfoWithToken:(NSString *)token andOpenId:(NSString *)openid
{
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 city = Haidian;
                 country = CN;
                 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
                 language = "zh_CN";
                 nickname = "xxx";
                 openid = oyAaTjsDx7pl4xxxxxxx;
                 privilege =     (
                 );
                 province = Beijing;
                 sex = 1;
                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
                 }
                 */
                
                NSString *name = [dic objectForKey:@"nickname"];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"headimgurl"]]]];
            
                [self SaveImgage:image];
                
                MyLogInViewController *log = [[MyLogInViewController alloc]init];
                log.vCLID=0;
                [log ThirdPartyLogSuccessWhitOpenID:openid type:@"weixin" name:name headImgUrl:[dic objectForKey:@"headimgurl"]];

            }
        });
        
    });
}
//将图片保存到本地
+ (void)SaveImgage:(UIImage *)image
{
    NSData *data;
    data = UIImagePNGRepresentation(image);
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
    
    NSLog(@"filePath:%@",filePath);

}
@end
