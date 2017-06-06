//
//  Water_Order_DetailsViewController.m
//  yxz
//
//  Created by 白玉林 on 16/3/4.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "Water_Order_DetailsViewController.h"
#import "OrderPayViewController.h"
#import "WaterOrderViewController.h"
@interface Water_Order_DetailsViewController ()
{
    UIView *detailsView;
    NSDictionary *orderDic;
}
@end

@implementation Water_Order_DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_details_ID==4) {
        NSString *phoneNum = @"";// 电话号码
        
        phoneNum = @"biz@bolohr.com";
        
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@",phoneNum]];
        
        UIWebView *phoneCallWebView;
        
        if ( !phoneCallWebView ) {
            
            phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
            
        }
        
        [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
        phoneCallWebView.userInteractionEnabled=YES;
        [self.view addSubview:phoneCallWebView];
    }
    self.navlabel.text=@"订单详情";
    self.view.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if (_details_ID!=2) {
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *dic=@{@"user_id":_user_ID,@"order_id":_order_ID};
        [_download requestWithUrl:WATER_ORDER_DETAILS dict:dic view:self.view delegate:self finishedSEL:@selector(ORder_GetUserInfo:) isPost:NO failedSEL:@selector(ORder_FailDownload:)];
    }else{
        NSString *str=[NSString stringWithFormat:@"%@",[_dic objectForKey:@"order_id"]];
        ISLoginManager *_manager = [ISLoginManager shareManager];
        
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *dic=@{@"user_id":_manager.telephone,@"order_id":str};
        [_download requestWithUrl:WATER_ORDER_DETAILS dict:dic view:self.view delegate:self finishedSEL:@selector(ORder_GetUserInfo:) isPost:NO failedSEL:@selector(ORder_FailDownload:)];
    }

}
-(void)ORder_GetUserInfo:(id)sender
{
    NSLog(@"sende%@",sender);
    //    NSArray *array=
    orderDic=[sender objectForKey:@"data"];
    NSLog(@"%@",orderDic);
    [self detailsViewLayout];
}
-(void)ORder_FailDownload:(id)sender
{
    
}
-(void)detailsViewLayout
{
    detailsView=[[UIView alloc]initWithFrame:FRAME(0, 64, WIDTH, 387)];
    detailsView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:detailsView];
    
    for (int i=0; i<8; i++) {
        UIView *view=[[UIView alloc]init];
        view.backgroundColor=[UIColor whiteColor];
        [detailsView addSubview:view];
        if (i==0) {
            view.frame=FRAME(0, 0, WIDTH, 30);
            view.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
            UILabel *selfLabel=[[UILabel alloc]initWithFrame:FRAME(10, 15/2, 60, 15)];
            selfLabel.text=@"订单号:";
            selfLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
            [view addSubview:selfLabel];
            
            UILabel *label=[[UILabel alloc]initWithFrame:FRAME(selfLabel.frame.size.width+selfLabel.frame.origin.x, 15/2, WIDTH-80, 14)];
            NSString *labeltext=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"order_no"]];
            label.text=labeltext;
            [view addSubview:label];
            
        }else{
            
            UIView *lineView=[[UIView alloc]initWithFrame:FRAME(0, view.frame.size.height-1, WIDTH, 1)];
            lineView.backgroundColor=[UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1];
//            [view addSubview:lineView];
            if (i==1) {
                view.frame=FRAME(0, 30+51*(i-1), WIDTH, 51);
                UIImageView *headImageView=[[UIImageView alloc]initWithFrame:FRAME(10, 10, 30, 30)];
                headImageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[orderDic objectForKey:@"partner_user_head_img"]]]];
                headImageView.layer.cornerRadius=headImageView.frame.size.width/2;
                headImageView.clipsToBounds = YES;
                [view addSubview:headImageView];
                
                UILabel *cateGroyLabel=[[UILabel alloc]initWithFrame:FRAME(headImageView.frame.size.width+headImageView.frame.origin.x+10, 15, WIDTH-120, 20)];
                NSString *service_type_name=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"service_type_name"]];
                NSString *order_money=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"order_pay"]];
                cateGroyLabel.text=[NSString stringWithFormat:@"%@:%@元",service_type_name,order_money];
                cateGroyLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
                
                [view addSubview:cateGroyLabel];
                
                UIButton *stateButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-70, 25/2, 60, 25)];
                //stateButton.backgroundColor=[UIColor redColor];
                [stateButton.layer setMasksToBounds:YES];
                [stateButton.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
                [stateButton.layer setBorderWidth:1.0];   //边框宽度
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
                [stateButton.layer setBorderColor:colorref];//边框颜色
                [stateButton addTarget:self action:@selector(stateButAction:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:stateButton];
                
                UILabel *stateLabel=[[UILabel alloc]initWithFrame:FRAME(5, 5, 50, 15)];
                stateLabel.text=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"order_status_name"]];
                NSString *order_status=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"order_status_name"]];
                if ([order_status isEqualToString:@"待支付"]) {
                    stateButton.enabled=TRUE;
                    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                    
                    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
                    [stateButton.layer setBorderColor:colorref];//边框颜色
                    stateButton.backgroundColor=[UIColor whiteColor];
                }else{
                    stateButton.enabled=FALSE;
                    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                    
                    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 180, 180, 180, 1 });
                    [stateButton.layer setBorderColor:colorref];//边框颜色
                    
                    stateButton.backgroundColor=[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
                }
                
                stateLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
                stateLabel.textAlignment=NSTextAlignmentCenter;
                [stateButton addSubview:stateLabel];
            }else if(i==2){
                view.frame=FRAME(0, 30+20*(i-1), WIDTH, 20);
                UILabel*label=[[UILabel alloc]init];
                label.text=@"下单时间:";
                label.font=[UIFont fontWithName:@"Heiti SC" size:12];
                [label setNumberOfLines:1];
                [label sizeToFit];
                label.frame=FRAME(10, 5/2, label.frame.size.width, 15);
                [view addSubview:label];
                UILabel *ordreLabel=[[UILabel alloc]init];
                ordreLabel.text=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"add_time_str"]];
                [ordreLabel setNumberOfLines:1];
                [ordreLabel sizeToFit];
                ordreLabel.frame=FRAME(WIDTH-10-ordreLabel.frame.size.width, 35/2, ordreLabel.frame.size.width, 15);
                ordreLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
                ordreLabel.textAlignment=NSTextAlignmentRight;
                [view addSubview:ordreLabel];
            }else if(i==3){
                view.frame=FRAME(0, 30+20*(i-1), WIDTH, 20);
                UILabel*label=[[UILabel alloc]init];
                label.font=[UIFont fontWithName:@"Heiti SC" size:12];
                label.text=@"所在城市:";
                [label setNumberOfLines:1];
                [label sizeToFit];
                label.frame=FRAME(10, 5/2, label.frame.size.width, 15);
                [view addSubview:label];
                UILabel *ordreLabel=[[UILabel alloc]init];
                ordreLabel.text=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"city_name"]];
                [ordreLabel setNumberOfLines:1];
                [ordreLabel sizeToFit];
                ordreLabel.frame=FRAME(WIDTH-10-ordreLabel.frame.size.width, 5/2, ordreLabel.frame.size.width, 15);
                ordreLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
                ordreLabel.textAlignment=NSTextAlignmentRight;
                [view addSubview:ordreLabel];
            }else if(i==4){
                view.frame=FRAME(0, 30+20*(i-1), WIDTH, 20);
                UILabel*label=[[UILabel alloc]init];
                label.font=[UIFont fontWithName:@"Heiti SC" size:12];
                label.text=@"内容:";
                [label setNumberOfLines:1];
                [label sizeToFit];
                label.frame=FRAME(10, 5/2, label.frame.size.width, 15);
                [view addSubview:label];
                UILabel *ordreLabel=[[UILabel alloc]init];
                ordreLabel.text=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"service_content"]];
                [ordreLabel setNumberOfLines:1];
                [ordreLabel sizeToFit];
                ordreLabel.frame=FRAME(WIDTH-10-ordreLabel.frame.size.width, 5/2, ordreLabel.frame.size.width, 15);
                ordreLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
                ordreLabel.textAlignment=NSTextAlignmentRight;
                [view addSubview:ordreLabel];
            }else if(i==5){
                view.frame=FRAME(0, 30+20*(i-1), WIDTH, 20);
                UILabel*label=[[UILabel alloc]init];
                label.font=[UIFont fontWithName:@"Heiti SC" size:12];
                label.text=@"金额:";
                [label setNumberOfLines:1];
                [label sizeToFit];
                label.frame=FRAME(10, 5/2, label.frame.size.width, 15);
                [view addSubview:label];
                UILabel *ordreLabel=[[UILabel alloc]init];
                ordreLabel.text=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"order_pay"]];
                [ordreLabel setNumberOfLines:1];
                [ordreLabel sizeToFit];
                ordreLabel.frame=FRAME(WIDTH-10-ordreLabel.frame.size.width, 5/2, ordreLabel.frame.size.width, 15);
                ordreLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
                ordreLabel.textAlignment=NSTextAlignmentRight;
                [view addSubview:ordreLabel];
            }else if(i==6){
                view.frame=FRAME(0, 30+20*(i-1), WIDTH, 20);
                UILabel*label=[[UILabel alloc]init];
                label.font=[UIFont fontWithName:@"Heiti SC" size:12];
                label.text=@"支付方式:";
                [label setNumberOfLines:1];
                [label sizeToFit];
                label.frame=FRAME(10, 5/2, label.frame.size.width, 15);
                [view addSubview:label];
                UILabel *ordreLabel=[[UILabel alloc]init];
                ordreLabel.text=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"pay_type_name"]];
                [ordreLabel setNumberOfLines:1];
                [ordreLabel sizeToFit];
                ordreLabel.frame=FRAME(WIDTH-10-ordreLabel.frame.size.width, 5/2, ordreLabel.frame.size.width, 15);
                ordreLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
                ordreLabel.textAlignment=NSTextAlignmentRight;
                [view addSubview:ordreLabel];
            }else if(i==7){
                view.frame=FRAME(0, 30+20*(i-1), WIDTH, 20);
                UILabel*label=[[UILabel alloc]init];
                label.font=[UIFont fontWithName:@"Heiti SC" size:12];
                label.text=@"进度跟踪:";
                [label setNumberOfLines:1];
                [label sizeToFit];
                label.frame=FRAME(10, 5/2, label.frame.size.width, 15);
                [view addSubview:label];
                UILabel *ordreLabel=[[UILabel alloc]init];
                ordreLabel.text=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"order_status_name"]];
                [ordreLabel setNumberOfLines:1];
                [ordreLabel sizeToFit];
                ordreLabel.frame=FRAME(WIDTH-10-ordreLabel.frame.size.width, 5/2, ordreLabel.frame.size.width, 15);
                ordreLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
                ordreLabel.textAlignment=NSTextAlignmentRight;
                [view addSubview:ordreLabel];
            }
            
            
            
            
            
        }
        
    }
}

-(void)stateButAction:(UIButton *)sender
{
    OrderPayViewController *payVC=[[OrderPayViewController alloc]init];
    payVC.buyString=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"service_type_name"]];
    payVC.orderStr=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"order_no"]];;
    int dis_price=[[orderDic objectForKey:@"dis_price"]intValue];
    int the_number=[[orderDic objectForKey:@"service_num"]intValue];
    int monetStr=dis_price*the_number;
    payVC.moneyStr=[NSString stringWithFormat:@"%d",monetStr];
    payVC.orderVCID=2;
    payVC.addssID=@"0";//[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"is_addr"]];
    payVC.user_ID=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"user_id"]];
    payVC.order_ID=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"order_id"]];
    payVC.orderPayDic=orderDic;
    [self.navigationController pushViewController:payVC animated:YES];
}
- (void)backAction
{
    if(_details_ID==5){
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[WaterOrderViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
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
