//
//  SimiOrderDetaileVC.m
//  simi
//
//  Created by 高鸿鹏 on 15/6/22.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "SimiOrderDetaileVC.h"
#import "SimiOrderDetail.h"
#import "DownloadManager.h"
#import "ISLoginManager.h"
#import "SimiOrderDetailModel.h"
#import "PayViewController.h"
#import "OrderViewController.h"
@interface SimiOrderDetaileVC ()<simiOrderDetailDelete>
{
    SimiOrderDetailModel *model;
}
@end

@implementation SimiOrderDetaileVC
@synthesize orderNo;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.navlabel.text = @"订单详情";
    
    ISLoginManager *logManager = [[ISLoginManager alloc]init];
    NSDictionary *mobelDic = [[NSDictionary alloc]initWithObjectsAndKeys:logManager.telephone,@"user_id",orderNo,@"order_no", nil];
    DownloadManager *_download = [[DownloadManager alloc]init];
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",ORDER_DETAIL]  dict:mobelDic view:self.view delegate:self finishedSEL:@selector(DownLoadSuccess:) isPost:NO failedSEL:@selector(DownLoadfoFail:)];

}
- (void)DownLoadSuccess:(id)dict
{
    NSLog(@"dict : %@",dict);
    int status = [[dict objectForKey:@"status"] intValue];
    if (status == 0) {
        NSDictionary *dataDic = [dict objectForKey:@"data"];
        model = [[SimiOrderDetailModel alloc]initWithDictionary:dataDic];
        
        SimiOrderDetail *simiOrderView = [[SimiOrderDetail alloc]initWithFrame:FRAME(0, 60, SELF_VIEW_WIDTH, SELF_VIEW_HEIGHT-60)withModel:model];
        simiOrderView.delegate = self;
        simiOrderView.myModel = model;
        [self.view addSubview:simiOrderView];
        
        
        NSString *title ;
        BOOL btnHiden = YES;

        switch (model.order_status) {
            case 1:
                title = @"确认";
                btnHiden = NO;
                break;
            case 3:
                title = @"确认-支付";
                btnHiden = NO;
                break;
                
            default:
                break;
        }
        
        UIButton *bttn = [UIButton buttonWithType:UIButtonTypeCustom];
        bttn.frame = FRAME(14, SELF_VIEW_HEIGHT-100, 584/2, 108/2);
        [bttn setBackgroundColor:HEX_TO_UICOLOR(0xFFB30F, 1.0)];
        [bttn setTitle:title forState:UIControlStateNormal];
        [bttn setHidden:btnHiden];
        [bttn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bttn addTarget:self action:@selector(BtnPress:) forControlEvents:UIControlEventTouchUpInside];
        [bttn.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        [self.view addSubview:bttn];
    }
}
-(void)BtnPress:(UIButton *)btn
{
    NSLog(@"%@",btn.currentTitle);
    if ([btn.currentTitle isEqualToString:@"确认-支付"]) {
        PayViewController *pay = [[PayViewController alloc]init];
        pay.price = model.order_money;
        pay.time = [self getTimeWithstring:model.service_date];
        pay.orderID = model.order_id;
        pay.orderNum = model.order_no;
        [self.navigationController pushViewController:pay animated:YES];
        
    }else if ([btn.currentTitle isEqualToString:@"确认"]){
        ISLoginManager *logManager = [[ISLoginManager alloc]init];
        NSDictionary *mobelDic = [[NSDictionary alloc]initWithObjectsAndKeys:
                                  logManager.telephone,@"user_id",
                                  orderNo,@"order_no",
                                  nil];
        
        DownloadManager *_download = [[DownloadManager alloc]init];
        [_download requestWithUrl:[NSString stringWithFormat:@"%@",ORDER_SURE]  dict:mobelDic view:self.view delegate:self finishedSEL:@selector(SureSuccess:) isPost:YES failedSEL:@selector(DownLoadfoFail:)];
    }
}
- (void)PressDownWithTitle:(NSString *)title
{
    NSLog(@"title: %@",title);
}
- (void)SureSuccess:(id)dict
{
    int status = [[dict objectForKey:@"status"] intValue];
    if (status == 0) {
        OrderViewController *order = [[OrderViewController alloc]init];
        [self.navigationController pushViewController:order animated:YES];
    }
}
- (void)DownLoadfoFail:(id)error
{
    NSLog(@"error: %@",error);
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
