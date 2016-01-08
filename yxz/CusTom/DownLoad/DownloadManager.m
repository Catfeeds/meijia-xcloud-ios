//
//  DownloadManager.m
//  simi
//
//  Created by 赵中杰 on 14/11/25.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "DownloadManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "DatabaseManager.h"
#import "MBProgressHUD+Add.h"

DatabaseManager *_manager;

@implementation DownloadManager


- (void)requestWithUrl:(NSString *)url dict:(NSDictionary *)parameters view:(UIView *)myview delegate:(id)downloaddelegate finishedSEL:(SEL)finished isPost:(BOOL)isPost failedSEL:(SEL)failed
{
    _manager = [DatabaseManager sharedDatabaseManager];
    
    if (_manager.connectedToNetwork) {
        
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:myview];
        HUD.labelText = @"正在加载";
        [myview addSubview:HUD];
        [HUD show:YES];
        
        if (isPost) {
            
            AFHTTPRequestOperationManager *mymanager = [AFHTTPRequestOperationManager manager];
            
            [mymanager POST:[NSString stringWithFormat:@"%@%@",SERVER_DRESS,url] parameters:parameters success:^(AFHTTPRequestOperation *opretion, id responseObject){
                
                NSInteger _status= [[responseObject objectForKey:@"status"] integerValue];
                NSString * _message= [responseObject objectForKey:@"msg"];

                if (_status == 0) {
                    
                }else{
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_message  delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
//                    
//                    [alert show];
                }
                
                [MBProgressHUD hideHUDForView:myview animated:YES];
                
                [downloaddelegate performSelector:finished withObject:responseObject afterDelay:0];

            } failure:^(AFHTTPRequestOperation *opration, NSError *error){
                
                [downloaddelegate performSelector:failed withObject:error afterDelay:0];
                
                [MBProgressHUD hideHUDForView:myview animated:YES];

            }];

        }else{
            
            
            AFHTTPRequestOperationManager *mymanager = [AFHTTPRequestOperationManager manager];
            
            [mymanager GET:[NSString stringWithFormat:@"%@%@",SERVER_DRESS,url] parameters:parameters success:^(AFHTTPRequestOperation *opretion, id responseObject){
                
                [downloaddelegate performSelector:finished withObject:responseObject afterDelay:0];
                [MBProgressHUD hideHUDForView:myview animated:YES];

                NSInteger _status= [[responseObject objectForKey:@"status"] integerValue];
                NSString * _message= [responseObject objectForKey:@"msg"];
                
                if (_status == 0) {
                    
                }else{
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_message  delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
//                    
//                    [alert show];
                }
                
                [MBProgressHUD hideHUDForView:myview animated:YES];
                
            } failure:^(AFHTTPRequestOperation *opration, NSError *error){
                
                [downloaddelegate performSelector:failed withObject:error afterDelay:0];
                [MBProgressHUD hideHUDForView:myview animated:YES];

            }];
            
        }
        
    }else{
        
        [MBProgressHUD showSuccess:@"网络繁忙，请稍候重试" toView:myview];
    
    }
    
}

@end
