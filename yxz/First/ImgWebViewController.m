//
//  ImgWebViewController.m
//  simi
//
//  Created by zrj on 14-12-2.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "ImgWebViewController.h"
#import "RootViewController.h"
#import "AppDelegate.h"
@interface ImgWebViewController ()

@end

@implementation ImgWebViewController
@synthesize imgurl,title;
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navlabel.text = title;
    

APPLIACTION.leiName = @"";
//    [self hideTabbar];
    
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:FRAME(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imgurl]];
    webView.scalesPageToFit = YES;  //自适应
    NSLog(@"gourl  =  %@",imgurl);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
    // Do any additional setup after loading the view.
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
