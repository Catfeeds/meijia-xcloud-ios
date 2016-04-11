//
//  ZeroViewController.m
//  yxz
//
//  Created by 白玉林 on 15/11/17.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "ZeroViewController.h"
#import "BindMobileViewController.h"
#import "Order_DetailsViewController.h"
@interface ZeroViewController ()

@end

@implementation ZeroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navlabel.text=@"咨询服务";
    
    UIView *zeroView=[[UIView alloc]initWithFrame:FRAME(0, 84, WIDTH, 101)];
    zeroView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:zeroView];
    
    NSLog(@"_zeroDic--%@",_zeroDic);
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.text=@"服务内容:";
    [titleLabel setNumberOfLines:1];
    [titleLabel sizeToFit];
    titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    titleLabel.frame=FRAME(20, 15, titleLabel.frame.size.width, 20);
    [zeroView addSubview:titleLabel];
    
    UILabel *textLabel=[[UILabel alloc]initWithFrame:FRAME(titleLabel.frame.size.width+20, 15, WIDTH-titleLabel.frame.size.width-40, 20)];
    textLabel.text=_textString;
    textLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    textLabel.textAlignment=NSTextAlignmentLeft;
    textLabel.textColor=[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:1];
    [zeroView addSubview:textLabel];
    
    UIView *lineView=[[UIView alloc]initWithFrame:FRAME(0, 50, WIDTH, 1)];
    lineView.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [zeroView addSubview:lineView];
    
    UILabel *payLabel=[[UILabel alloc]init];
    payLabel.text=@"支付金额:";
    [payLabel setNumberOfLines:1];
    [payLabel sizeToFit];
    payLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    payLabel.frame=FRAME(20, 66, titleLabel.frame.size.width, 20);
    [zeroView addSubview:payLabel];
    
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:FRAME(payLabel.frame.size.width+20, 66, WIDTH-payLabel.frame.size.width-40, 20)];
    moneyLabel.text=[NSString stringWithFormat:@"%@.00元",[_zeroDic objectForKey:@"dis_price"]];
    moneyLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    moneyLabel.textAlignment=NSTextAlignmentLeft;
    moneyLabel.textColor=[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:1];
    [zeroView addSubview:moneyLabel];
    
    UIButton *conFirm=[[UIButton alloc]initWithFrame:FRAME(20, zeroView.frame.size.height+zeroView.frame.origin.y+30, WIDTH-40, 50)];
    [conFirm setTitle:@"免费咨询" forState:UIControlStateNormal];
    conFirm.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    conFirm.layer.cornerRadius=6;
    conFirm.clipsToBounds=YES;
    [conFirm addTarget:self action:@selector(conFirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:conFirm];
    
    // Do any additional setup after loading the view.
}
#pragma mark  确认咨询按钮点击方法
-(void)conFirmAction:(UIButton *)sender
{
    NSLog(@"确认咨询啦！");
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
            NSString *_price_id=[NSString stringWithFormat:@"%@",[_zeroDic objectForKey:@"service_price_id"]];
            dic=@{@"user_id":_manager.telephone,@"mobile":moile,@"partner_user_id":_sec_ID,@"service_type_id":_service_type_id,@"service_price_id":_price_id,@"pay_type":@"0"};
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
-(void)VIPDownloadFinish:(id)sender
{
    NSLog(@"%@",sender);
    NSDictionary *oderDic=[sender objectForKey:@"data"];
    Order_DetailsViewController *orderVC=[[Order_DetailsViewController alloc]init];
    orderVC.details_ID=4;
    orderVC.user_ID=[NSString stringWithFormat:@"%@",[oderDic objectForKey:@"user_id"]];
    orderVC.order_ID=[NSString stringWithFormat:@"%@",[oderDic objectForKey:@"order_id"]];
    [self.navigationController pushViewController:orderVC animated:YES];
}
-(void)ORder_FailDownload:(id)sender
{
    NSLog(@"访问失败了！！！%@",sender);
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
