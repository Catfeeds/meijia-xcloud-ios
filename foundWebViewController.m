//
//  foundWebViewController.m
//  yxz
//
//  Created by 白玉林 on 16/4/8.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "foundWebViewController.h"
#import "PaymentViewController.h"
#import "ZeroViewController.h"
@interface foundWebViewController ()
{
    UIWebView *myWebView;
    UIActivityIndicatorView *meView;
}

@end

@implementation foundWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navlabel.text=_titleName;
    UIButton *rightBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH-60, 20, 60, 44)];
    [rightBut addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBut];
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(15, 12, 20, 20)];
    img.image = [UIImage imageNamed:@"WEB_QX"];
    [rightBut addSubview:img];
    [self webViewLayout];
    // Do any additional setup after loading the view.
}
-(void)webViewLayout
{
    [myWebView removeFromSuperview];
    if ([_goto_type isEqualToString:@"h5+list"]) {
        myWebView=[[UIWebView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-114)];
        UIView *buttonView=[[UIView alloc]initWithFrame:FRAME(0, HEIGHT-50, WIDTH, 52)];
        buttonView.backgroundColor=[UIColor blackColor];
        [self.view addSubview:buttonView];
        UIButton *button=[[UIButton alloc]initWithFrame:FRAME(WIDTH-100, 0, 100, 50)];
        button.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
        [button setTitle:@"确认购买" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(consultingAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:button];
        UILabel *lab=[[UILabel alloc]initWithFrame:FRAME(10, 11, WIDTH-180, 30)];
        lab.text=[NSString stringWithFormat:@"￥%@",_moneyStr];
        lab.font=[UIFont fontWithName:@"Heiti SC" size:20];
        lab.textColor=[UIColor redColor];
        [buttonView addSubview:lab];
    }else{
        myWebView=[[UIWebView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    }
    
    myWebView.scalesPageToFit=YES;
    myWebView.delegate=self;
    [self.view addSubview:myWebView];
    myWebView.scrollView.delegate=self;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_imgurl]];
    //NSLog(@"gourl  =  %@",_imgurl);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:request];
}
-(void)consultingAction:(UIButton *)sender
{
   
    PaymentViewController *_controller = [[PaymentViewController alloc]init];
    _controller.moneystring = @"0";
    NSDictionary *dic=_zeroDic;
    NSString *dayString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    _controller.buyString=dayString;
    _controller.moneyStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"dis_price"]];
    _controller.cardTypeID=_cardTypeID;
    _controller.service_type_id=_service_type_id;
    _controller.service_price_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_price_id"]];
    _controller.sec_ID=_sec_ID;
    _controller.addssID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"is_addr"]];
    if ([_controller.moneyStr isEqualToString:@"0"]) {
        ZeroViewController *zerVC=[[ZeroViewController alloc]init];
        zerVC.textString=_controller.buyString;
        zerVC.zeroDic=dic;
        zerVC.service_type_id=_service_type_id;
        zerVC.sec_ID=_sec_ID;
        [self.navigationController pushViewController:zerVC animated:YES];
    }else{
        [self.navigationController pushViewController:_controller animated:YES];
    }

}
- (void)webViewDidStartLoad:(UIWebView *)webView {
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [meView stopAnimating]; // 结束旋转
    [meView setHidesWhenStopped:YES]; //当旋转结束时隐藏
    self.navlabel.text=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
}
-(void)rightAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backAction
{
    if([myWebView canGoBack])
    {
        [myWebView goBack];
    }else{
        _backBtn.enabled = NO;
        [self.navigationController popViewControllerAnimated:YES];
        _backBtn.enabled = YES;
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
