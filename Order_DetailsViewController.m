//
//  Order_DetailsViewController.m
//  yxz
//
//  Created by 白玉林 on 15/11/14.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "Order_DetailsViewController.h"
#import "OrderPayViewController.h"
#import "BuySecretaryViewController.h"
#import "Order_ListViewController.h"
#import "WaterOrderViewController.h"
#import "RootViewController.h"
@interface Order_DetailsViewController ()
{
    UIView *detailsView;
    NSDictionary *orderDic;
    UITableView *myTableView;
    UIScrollView *myScrollView;
    NSArray *scroArray;
}
@end

@implementation Order_DetailsViewController
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if (_details_ID!=2) {
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *dic=@{@"user_id":_user_ID,@"order_id":_order_ID};
        [_download requestWithUrl:ORDER_DDXQ dict:dic view:self.view delegate:self finishedSEL:@selector(ORder_GetUserInfo:) isPost:NO failedSEL:@selector(ORder_FailDownload:)];
    }else{
        NSString *str=[NSString stringWithFormat:@"%@",[_dic objectForKey:@"order_id"]];
        ISLoginManager *_manager = [ISLoginManager shareManager];
        
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *dic=@{@"user_id":_manager.telephone,@"order_id":str};
        [_download requestWithUrl:ORDER_DDXQ dict:dic view:self.view delegate:self finishedSEL:@selector(ORder_GetUserInfo:) isPost:NO failedSEL:@selector(ORder_FailDownload:)];
    }
    [self postLayout];
}
-(void)postLayout
{
    if (_details_ID!=2) {
        ISLoginManager *_manager = [ISLoginManager shareManager];
        
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *dic=@{@"user_id":_manager.telephone,@"order_id":_order_ID};
        [_download requestWithUrl:ORDER_schedule dict:dic view:self.view delegate:self finishedSEL:@selector(Success:) isPost:NO failedSEL:@selector(Fail:)];
    }else{
        ISLoginManager *_manager = [ISLoginManager shareManager];
        NSString *str=[NSString stringWithFormat:@"%@",[_dic objectForKey:@"order_id"]];
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *dic=@{@"user_id":_manager.telephone,@"order_id":str};
        [_download requestWithUrl:ORDER_schedule dict:dic view:self.view delegate:self finishedSEL:@selector(Success:) isPost:NO failedSEL:@selector(Fail:)];
    }
    
}
#pragma mark 获取订单日志成功
-(void)Success:(id)dataSource
{
    NSLog(@"获取订单日志成功%@",dataSource);
    scroArray=[dataSource objectForKey:@"data"];
    [self scrollViewLayout];
}
#pragma mark 获取订单日志失败
-(void)Fail:(id)dataSource
{
    NSLog(@"获取订单日志失败%@",dataSource);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (_details_ID==4) {
        NSString *phoneNum = @"";// 电话号码
        
        phoneNum = @"400-169-1615";
        
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
        
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
//    myTableView =[[UITableView alloc]initWithFrame:FRAME(0, 295, WIDTH, HEIGHT-295)];
//    [self.view addSubview:myTableView];
//    NSDictionary *dic=@{@"name":@"2016-05-17 10:38:11",@"text":@"您的订单已送出，请耐心等待"};
//    NSDictionary *dic1=@{@"name":@"2016-05-16 10:38:11",@"text":@"您的订单已正在备货"};
//    NSDictionary *dic2=@{@"name":@"2016-05-16 18:38:11",@"text":@"您的订单已确认，准备出库"};
//    NSDictionary *dic3=@{@"name":@"2016-05-115 10:38:11",@"text":@"您已提交订单并完成支付"};
//    NSMutableArray *array=[[NSMutableArray alloc]init];
//    for (int i=0; i<4; i++) {
//        switch (i) {
//            case 0:
//                [array addObject:dic];
//                break;
//            case 1:
//                [array addObject:dic1];
//                break;
//            case 2:
//                [array addObject:dic2];
//                break;
//            case 3:
//                [array addObject:dic3];
//                break;
//                
//            default:
//                break;
//        }
//    }
//    scroArray=array;
    myScrollView=[[UIScrollView alloc]init];
    myScrollView.delegate=self;
    [self.view addSubview:myScrollView];
    
    
    // Do any additional setup after loading the view.
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
    detailsView=[[UIView alloc]initWithFrame:FRAME(0, 64, WIDTH, 261)];
    detailsView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:detailsView];

    for (int i=0; i<9; i++) {
        UIView *view=[[UIView alloc]init];
        view.backgroundColor=[UIColor whiteColor];
        [detailsView addSubview:view];
        if (i==0) {
            view.frame=FRAME(0, 0, WIDTH, 30);
            view.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
            UILabel *selfLabel=[[UILabel alloc]initWithFrame:FRAME(10, 15/2, 60, 15)];
            selfLabel.text=@"订单号";
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
                int  order_status=[[orderDic objectForKey:@"order_status"]intValue];
                if (order_status==1) {
                    stateButton.enabled=TRUE;
                    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                    
                    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 252, 110, 81, 1  });
                    [stateButton.layer setBorderColor:colorref];//边框颜色
                    stateButton.backgroundColor=[UIColor colorWithRed:252/255.0f green:110/255.0f blue:81/255.0f alpha:1];
                    stateLabel.textColor=[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
                }else{
                    stateButton.enabled=FALSE;
                    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                    
                    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 10, 0, 0, 0 });
                    [stateButton.layer setBorderColor:colorref];//边框颜色
                    
                    stateButton.backgroundColor=[UIColor clearColor];
                    stateLabel.textColor=[UIColor colorWithRed:0/255.0f green:186/255.0f blue:239/255.0f alpha:1];
                }

                stateLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
                stateLabel.textAlignment=NSTextAlignmentCenter;
                [stateButton addSubview:stateLabel];
            }else if(i==2){
                view.frame=FRAME(0, 30+51*(i-1), WIDTH, 25);
                UILabel*label=[[UILabel alloc]init];
                label.text=@"下单时间";
                label.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
                label.font=[UIFont fontWithName:@"Heiti SC" size:12];
//                [label setNumberOfLines:1];
//                [label sizeToFit];
                label.frame=FRAME(10, 5, 48, 15);
                NSLog(@"%f",label.frame.size.width);
                [view addSubview:label];
                UILabel *ordreLabel=[[UILabel alloc]init];
                ordreLabel.text=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"add_time_str"]];
                [ordreLabel setNumberOfLines:1];
                [ordreLabel sizeToFit];
                ordreLabel.frame=FRAME(label.frame.size.width+20, 5, ordreLabel.frame.size.width, 15);
                ordreLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
                ordreLabel.textColor=[UIColor colorWithRed:68/255.0f green:68/255.0f blue:68/255.0f alpha:1];
//                ordreLabel.textAlignment=NSTextAlignmentRight;
                [view addSubview:ordreLabel];
            }else if(i==3){
                view.frame=FRAME(0, 30+25*(i-1)+31, WIDTH, 25);
                UILabel*label=[[UILabel alloc]init];
                label.font=[UIFont fontWithName:@"Heiti SC" size:12];
                label.text=@"所在城市";
                label.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
//                [label setNumberOfLines:1];
//                [label sizeToFit];
                label.frame=FRAME(10, 5, 48, 15);
                [view addSubview:label];
                UILabel *ordreLabel=[[UILabel alloc]init];
                ordreLabel.text=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"city_name"]];
                [ordreLabel setNumberOfLines:1];
                [ordreLabel sizeToFit];
                ordreLabel.frame=FRAME(label.frame.size.width+20, 5, ordreLabel.frame.size.width, 15);
                ordreLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
                ordreLabel.textColor=[UIColor colorWithRed:68/255.0f green:68/255.0f blue:68/255.0f alpha:1];
//                ordreLabel.textAlignment=NSTextAlignmentRight;
                [view addSubview:ordreLabel];
            }else if(i==4){
                view.frame=FRAME(0, 30+25*(i-1)+31, WIDTH, 25);
                UILabel*label=[[UILabel alloc]init];
                label.font=[UIFont fontWithName:@"Heiti SC" size:12];
                label.text=@"内容";
                label.textAlignment=NSTextAlignmentRight;
                label.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
//                [label setNumberOfLines:1];
//                [label sizeToFit];
                label.frame=FRAME(10, 5, 48, 15);
                [view addSubview:label];
                UILabel *ordreLabel=[[UILabel alloc]init];
                ordreLabel.text=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"service_content"]];
                [ordreLabel setNumberOfLines:1];
                [ordreLabel sizeToFit];
                ordreLabel.frame=FRAME(label.frame.size.width+20, 5, ordreLabel.frame.size.width, 15);
                ordreLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
                ordreLabel.textColor=[UIColor colorWithRed:68/255.0f green:68/255.0f blue:68/255.0f alpha:1];
//                ordreLabel.textAlignment=NSTextAlignmentRight;
                [view addSubview:ordreLabel];
            }else if(i==5){
                view.frame=FRAME(0, 30+25*(i-1)+31, WIDTH, 25);
                UILabel*label=[[UILabel alloc]init];
                label.font=[UIFont fontWithName:@"Heiti SC" size:12];
                label.text=@"金额";
                label.textAlignment=NSTextAlignmentRight;
                label.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
//                [label setNumberOfLines:1];
//                [label sizeToFit];
                label.frame=FRAME(10, 5, 48, 15);
                [view addSubview:label];
                UILabel *ordreLabel=[[UILabel alloc]init];
                ordreLabel.text=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"order_pay"]];
                [ordreLabel setNumberOfLines:1];
                [ordreLabel sizeToFit];
                ordreLabel.frame=FRAME(label.frame.size.width+20, 5, ordreLabel.frame.size.width, 15);
                ordreLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
                ordreLabel.textColor=[UIColor colorWithRed:68/255.0f green:68/255.0f blue:68/255.0f alpha:1];
//                ordreLabel.textAlignment=NSTextAlignmentRight;
                [view addSubview:ordreLabel];
            }else if(i==6){
                view.frame=FRAME(0, 30+25*(i-1)+31, WIDTH, 25);
                UILabel*label=[[UILabel alloc]init];
                label.font=[UIFont fontWithName:@"Heiti SC" size:12];
                label.text=@"支付方式";
                label.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
//                [label setNumberOfLines:1];
//                [label sizeToFit];
                label.frame=FRAME(10, 5, 48, 15);
                [view addSubview:label];
                UILabel *ordreLabel=[[UILabel alloc]init];
                ordreLabel.text=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"pay_type_name"]];
                [ordreLabel setNumberOfLines:1];
                [ordreLabel sizeToFit];
                ordreLabel.frame=FRAME(label.frame.size.width+20, 5, ordreLabel.frame.size.width, 15);
                ordreLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
                ordreLabel.textColor=[UIColor colorWithRed:68/255.0f green:68/255.0f blue:68/255.0f alpha:1];
//                ordreLabel.textAlignment=NSTextAlignmentRight;
                [view addSubview:ordreLabel];
            }else if(i==7){
                view.frame=FRAME(0, 30+25*(i-1)+31, WIDTH, 25);
                UILabel*label=[[UILabel alloc]init];
                label.font=[UIFont fontWithName:@"Heiti SC" size:12];
                label.text=@"订单备注";
                label.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
//                [label setNumberOfLines:1];
//                [label sizeToFit];
                label.frame=FRAME(10, 5, 48, 15);
                [view addSubview:label];
                UILabel *ordreLabel=[[UILabel alloc]init];
                ordreLabel.text=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"remarks"]];
                [ordreLabel setNumberOfLines:1];
                [ordreLabel sizeToFit];
                ordreLabel.frame=FRAME(label.frame.size.width+20, 5, WIDTH-(label.frame.size.height+30), 15);
                ordreLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
                ordreLabel.textColor=[UIColor colorWithRed:68/255.0f green:68/255.0f blue:68/255.0f alpha:1];
                ordreLabel.textAlignment=NSTextAlignmentLeft;
                [view addSubview:ordreLabel];
            }else if(i==8){
                view.frame=FRAME(0, 30+25*(i-1)+31, WIDTH, 30);
                view.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
                UILabel*label=[[UILabel alloc]init];
                label.font=[UIFont fontWithName:@"Heiti SC" size:14];
                label.text=@"进度跟踪";
                [label setNumberOfLines:1];
                [label sizeToFit];
                label.frame=FRAME(10, 15/2, label.frame.size.width, 15);
                [view addSubview:label];
//                UILabel *ordreLabel=[[UILabel alloc]init];
//                ordreLabel.text=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"order_status_name"]];
//                [ordreLabel setNumberOfLines:1];
//                [ordreLabel sizeToFit];
//                ordreLabel.frame=FRAME(WIDTH-10-ordreLabel.frame.size.width, 5/2, ordreLabel.frame.size.width, 15);
//                ordreLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
//                ordreLabel.textAlignment=NSTextAlignmentRight;
//                [view addSubview:ordreLabel];
            }





        }
        
    }
}

-(void)stateButAction:(UIButton *)sender
{
    OrderPayViewController *payVC=[[OrderPayViewController alloc]init];
    payVC.buyString=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"service_content"]];
    payVC.orderStr=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"order_no"]];
    payVC.moneyStr=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"order_money"]];
    payVC.orderVCID=2;
    payVC.addssID=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"is_addr"]];
    payVC.user_ID=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"user_id"]];
    payVC.order_ID=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"order_id"]];
    payVC.orderPayDic=orderDic;
    [self.navigationController pushViewController:payVC animated:YES];
}
- (void)backAction
{
    if (_details_ID==3||_details_ID==4) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[RootViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            } 
        }
    }else if(_details_ID==5){
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[RootViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }

    }else{
        [self.navigationController popViewControllerAnimated:YES];
       
    }
    
}
-(void)scrollViewLayout
{
    int  h=0;
    for (int i=0; i<scroArray.count; i++) {
        NSDictionary *dict=scroArray[i];
        NSString *string=[NSString stringWithFormat:@"%@",[dict objectForKey:@"image"]];
        UIView *scroView=[[UIView alloc]init];
        if (string==nil||string==NULL||[string isEqualToString:@"(null)"]) {
            scroView.frame=FRAME(0, h, WIDTH, 60);
        }else{
            scroView.frame=FRAME(0, h, WIDTH, 104);
        }
        scroView.backgroundColor=[UIColor whiteColor];
        [myScrollView addSubview:scroView];
        h+=scroView.frame.size.height;
        
        UIView *shangLineView=[[UIView alloc]init];
        [scroView addSubview:shangLineView];
        UIView *xiaLineView=[[UIView alloc]init];
        [scroView addSubview:xiaLineView];
        UIImageView *imageView=[[UIImageView alloc]init];
        [scroView addSubview:imageView];
        UILabel *timeLabel=[[UILabel alloc]init];
        [scroView addSubview:timeLabel];
        UILabel *textLabel=[[UILabel alloc]init];
        [scroView addSubview:textLabel];
        UIImageView *chartImageView=[[UIImageView alloc]init];
        [scroView addSubview:chartImageView];
       
        if (i==0) {
            shangLineView.hidden=YES;
            imageView.frame=FRAME(14, 15, 20, 20);
            imageView.layer.cornerRadius=20/2;
            imageView.clipsToBounds=YES;
            imageView.image=[UIImage imageNamed:@"checked"];
            xiaLineView.frame=FRAME(24, 25, 1, scroView.frame.size.height-25);
            xiaLineView.backgroundColor=[UIColor colorWithRed:100/255.0f green:178/255.0f blue:41/255.0f alpha:1];
            
            timeLabel.frame=FRAME(68, 15, WIDTH-88, 15);
            timeLabel.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"add_time_str"]];
            timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
            timeLabel.textColor=[UIColor colorWithRed:100/255.0f green:178/255.0f blue:41/255.0f alpha:1];
            
            textLabel.frame=FRAME(68, 35, WIDTH-88, 15);
            textLabel.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"remarks"]];
            textLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
            textLabel.textColor=[UIColor colorWithRed:100/255.0f green:178/255.0f blue:41/255.0f alpha:1];
            if (string==nil||string==NULL||[string isEqualToString:@"(null)"]) {
                chartImageView.hidden=YES;
            }else{
                chartImageView.hidden=NO;
            }
            
        }else if (i==1){
            shangLineView.hidden=NO;
            shangLineView.frame=FRAME(24, 0, 1, 6);
            shangLineView.backgroundColor=[UIColor colorWithRed:100/255.0f green:178/255.0f blue:41/255.0f alpha:1];
            imageView.frame=FRAME(19, 6, 10, 10);
            imageView.layer.cornerRadius=10/2;
            imageView.clipsToBounds=YES;
            imageView.backgroundColor=[UIColor colorWithRed:203/255.0f green:203/255.0f blue:203/255.0f alpha:1];
            xiaLineView.frame=FRAME(24, 16, 1, scroView.frame.size.height-16);
            xiaLineView.backgroundColor=[UIColor colorWithRed:203/255.0f green:203/255.0f blue:203/255.0f alpha:1];
            
            timeLabel.frame=FRAME(68, 6, WIDTH-88, 15);
            timeLabel.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"add_time_str"]];
            timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
            timeLabel.textColor=[UIColor colorWithRed:100/255.0f green:178/255.0f blue:41/255.0f alpha:1];
            
            textLabel.frame=FRAME(68, 26, WIDTH-88, 15);
            textLabel.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"remarks"]];
            textLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
            textLabel.textColor=[UIColor colorWithRed:100/255.0f green:178/255.0f blue:41/255.0f alpha:1];
            
            if (string==nil||string==NULL||[string isEqualToString:@"(null)"]) {
                chartImageView.hidden=YES;
            }else{
                chartImageView.hidden=NO;
            }
        }else{
            shangLineView.hidden=NO;
            shangLineView.frame=FRAME(24, 0, 1, 6);
            shangLineView.backgroundColor=[UIColor colorWithRed:203/255.0f green:203/255.0f blue:203/255.0f alpha:1];
            imageView.frame=FRAME(19, 6, 10, 10);
            imageView.layer.cornerRadius=10/2;
            imageView.clipsToBounds=YES;
            imageView.backgroundColor=[UIColor colorWithRed:203/255.0f green:203/255.0f blue:203/255.0f alpha:1];
            xiaLineView.frame=FRAME(24, 16, 1, scroView.frame.size.height-16);
            xiaLineView.backgroundColor=[UIColor colorWithRed:203/255.0f green:203/255.0f blue:203/255.0f alpha:1];
            
            timeLabel.frame=FRAME(68, 6, WIDTH-88, 15);
            timeLabel.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"add_time_str"]];
            timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
            timeLabel.textColor=[UIColor colorWithRed:100/255.0f green:178/255.0f blue:41/255.0f alpha:1];
            
            textLabel.frame=FRAME(68, 26, WIDTH-88, 15);
            textLabel.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"remarks"]];
            textLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
            textLabel.textColor=[UIColor colorWithRed:100/255.0f green:178/255.0f blue:41/255.0f alpha:1];
            
            if (string==nil||string==NULL||[string isEqualToString:@"(null)"]) {
                chartImageView.hidden=YES;
            }else{
                chartImageView.hidden=NO;
            }
        }
        if (i==scroArray.count-1) {
            xiaLineView.hidden=YES;
        }
    }
    if (h>HEIGHT-295) {
        myScrollView.frame=FRAME(0, 325, WIDTH, HEIGHT-325);
        myScrollView.contentSize=CGSizeMake(WIDTH, h);
    }else{
        myScrollView.frame=FRAME(0, 325, WIDTH, h);
        myScrollView.contentSize=CGSizeMake(WIDTH, h);
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
