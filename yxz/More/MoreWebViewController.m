//
//  MoreWebViewController.m
//  simi
//
//  Created by 赵中杰 on 14/12/23.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "MoreWebViewController.h"
#import "Reachability.h"
#import "MBProgressHUD+Add.h"

@interface MoreWebViewController ()
<
  UIWebViewDelegate
>
{
    UIWebView *mywebView;

}

@end

@implementation MoreWebViewController
@synthesize webtag = _webtag;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSInteger mytag = [self.webtag integerValue];
    NSString *_loadurl = nil;
    
    switch (mytag) {
        case 100:
            self.navlabel.text = @"使用帮助";
            _loadurl = @"html/simi-inapp/help.htm";
            break;
            
        case 101:
            self.navlabel.text = @"用户协议";
            _loadurl = @"html/simi-inapp/agreement.htm";
            
            break;

        case 102:
            self.navlabel.text = @"关于我们";
            _loadurl = @"html/simi-inapp/about-us.htm";
            break;

            
        default:
            break;
    }
    
    
    
    if ([self connectedToNetwork]) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSURL * phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_DRESS,_loadurl]];
        mywebView = [[UIWebView alloc]initWithFrame:FRAME(0, 64, _WIDTH, _HEIGHT-64)];
        mywebView.delegate = self;
        mywebView.scalesPageToFit = YES;  //自适应
        [mywebView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];

        
    }
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [self.view addSubview:mywebView];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    
}



#pragma mark
#pragma mark 判断网络连接
- (BOOL) connectedToNetwork
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    if ([r currentReachabilityStatus] == NotReachable) {
        [self showAlertViewWithTitle:@"网络错误" message:@"网络连接失败，请稍后再试"];
        return NO;
        
    }else{
        return YES;
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
