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
{
    UIView *view;
    UILabel*alertLabel;
    int timeID;
    UIAlertView *alert;
}

- (void)requestWithUrl:(NSString *)url dict:(NSDictionary *)parameters view:(UIView *)myview delegate:(id)downloaddelegate finishedSEL:(SEL)finished isPost:(BOOL)isPost failedSEL:(SEL)failed
{
    _manager = [DatabaseManager sharedDatabaseManager];
    
    if (_manager.connectedToNetwork) {
        
       
//        [NSTimer scheduledTimerWithTimeInterval:2.0f
//                                         target:self
//                                       selector:@selector(timerFireMethod:)
//                                       userInfo:nil
//                                        repeats:NO];
        view=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
        [myview addSubview:view];
        NSTimer *timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(function:) userInfo:nil repeats:YES];
        [timer setFireDate:[NSDate distantPast]];
        if (isPost) {
            
            
            AFHTTPRequestOperationManager *mymanager = [AFHTTPRequestOperationManager manager];
            
            [mymanager POST:[NSString stringWithFormat:@"%@%@",SERVER_DRESS,url] parameters:parameters success:^(AFHTTPRequestOperation *opretion, id responseObject){
                
                view.frame=FRAME(0, 0, 0, 0);
                view.hidden=YES;
                NSInteger _status= [[responseObject objectForKey:@"status"] integerValue];
                NSString * _message= [responseObject objectForKey:@"msg"];
                if (_status == 0) {
                    
                }else  {
                    alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_message  delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(alertView:) userInfo:nil repeats:NO];
                    [alert show];
                }
                
                [MBProgressHUD hideHUDForView:myview animated:YES];
                
                [downloaddelegate performSelector:finished withObject:responseObject afterDelay:0];

            } failure:^(AFHTTPRequestOperation *opration, NSError *error){
                
                [timer invalidate];
                view.frame=FRAME(0, 0, 0, 0);
                view.hidden=YES;
                [downloaddelegate performSelector:failed withObject:error afterDelay:0];
                
                [MBProgressHUD hideHUDForView:myview animated:YES];

            }];

        }else{
            
            
            AFHTTPRequestOperationManager *mymanager = [AFHTTPRequestOperationManager manager];
            
            [mymanager GET:[NSString stringWithFormat:@"%@%@",SERVER_DRESS,url] parameters:parameters success:^(AFHTTPRequestOperation *opretion, id responseObject){
                view.frame=FRAME(0, 0, 0, 0);
                view.hidden=YES;
                [downloaddelegate performSelector:finished withObject:responseObject afterDelay:0];
                [MBProgressHUD hideHUDForView:myview animated:YES];

                NSInteger _status= [[responseObject objectForKey:@"status"] integerValue];
                NSString * _message= [responseObject objectForKey:@"msg"];
                
                if (_status == 0) {
                    
                }else{
                    alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_message  delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(alertView:) userInfo:nil repeats:NO];
                    [alert show];
                }
                
                [MBProgressHUD hideHUDForView:myview animated:YES];
                
            } failure:^(AFHTTPRequestOperation *opration, NSError *error){
                [timer invalidate];
                view.frame=FRAME(0, 0, 0, 0);
                view.hidden=YES;
                [downloaddelegate performSelector:failed withObject:error afterDelay:0];
                [MBProgressHUD hideHUDForView:myview animated:YES];

            }];
            
        }
        
    }else{
        [MBProgressHUD hideHUDForView:myview animated:YES];
        [MBProgressHUD showSuccess:@"网络繁忙，请稍候重试" toView:myview];
    
        
    }
    
}
-(void) alertView:(NSTimer *)timer
{
    [alert dismissWithClickedButtonIndex:0 animated:NO];
}
-(void)function:(NSTimer *)theTimer
{
    timeID++;
    if (timeID==2) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
        HUD.labelText = @"正在加载";
        [view addSubview:HUD];
        [HUD show:YES];
        
        
    }
}
- (void)timerFireMethod:(NSTimer*)theTimer
{
    view.frame=FRAME(0, 0, WIDTH, HEIGHT);
    
    alertLabel=[[UILabel alloc]initWithFrame:FRAME((WIDTH-260)/2, (HEIGHT-40)/2, 260, 40)];
    alertLabel.backgroundColor=[UIColor blackColor];
    alertLabel.alpha=0.4;
    alertLabel.text=@"还没有输入评论内容哦～";
    alertLabel.textColor=[UIColor whiteColor];
    alertLabel.textAlignment=NSTextAlignmentCenter;
    [view addSubview:alertLabel];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f
                                     target:self
                                   selector:@selector(viewLayout:)
                                   userInfo:alertLabel
                                    repeats:NO];
}
-(void)viewLayout:(NSTimer *)theTimer
{
    view.frame=FRAME(0, 0, 0, 0);
    alertLabel.hidden=YES;
}
@end
