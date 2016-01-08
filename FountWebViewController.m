//
//  FountWebViewController.m
//  yxz
//
//  Created by 白玉林 on 15/12/10.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "FountWebViewController.h"
#import "ClerkViewController.h"
@interface FountWebViewController ()
{
    UIWebView *myWebView;
    UIActivityIndicatorView *meView;
}

@end

@implementation FountWebViewController

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
        UIButton *button=[[UIButton alloc]initWithFrame:FRAME(WIDTH-80, 0, 80, 50)];
        button.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
        [button setTitle:@"咨询" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(consultingAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:button];
    }else{
        myWebView=[[UIWebView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    }
    
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
    ClerkViewController *clerkVC=[[ClerkViewController alloc]init];
    //clerkVC.goto_type=[NSString stringWithFormat:@"%@",[dic objectForKey:@"goto_type"]];
    clerkVC.service_type_id=_service_type_id;
    //    clerkVC.imgurl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"goto_url"]];
    [self.navigationController pushViewController:clerkVC animated:YES];
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
