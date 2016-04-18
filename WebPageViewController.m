//
//  WebPageViewController.m
//  yxz
//
//  Created by 白玉林 on 16/1/27.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "WebPageViewController.h"
#import "NJKWebViewProgressView.h"
@interface WebPageViewController ()
{
    UIView *layoutView;
    UIWebView *myWebView;
    UIActivityIndicatorView *webActivityView;
    UILabel *webTitleLabel;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;

}
@end

@implementation WebPageViewController
@synthesize webURL;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_barIDS==100) {
        self.navigationController.navigationBarHidden=NO;
        [myWebView removeFromSuperview];
        myWebView= [[UIWebView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
        myWebView.delegate=self;
        //self.meWebView.hidden=YES;
        myWebView.scrollView.delegate=self;
        [self.view addSubview:myWebView];
        [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
        [self.navigationController.navigationItem setHidesBackButton:YES];
        [self.navigationItem setHidesBackButton:YES];
        
        UIButton *liftButton=[[UIButton alloc]initWithFrame:FRAME(0, 0, 50, 44)];
//        liftButton.backgroundColor=[UIColor blackColor];
        [liftButton addTarget:self action:@selector(liftButAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *lifebar = [[UIBarButtonItem alloc] initWithCustomView:liftButton];
        self.navigationItem.leftBarButtonItem = lifebar;
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:FRAME(5, 11, 10, 20)];
        image.image = [UIImage imageNamed:@"title_left_back"];
        [liftButton addSubview:image];
        
        webTitleLabel=[[UILabel alloc]initWithFrame:FRAME(60, 5, WIDTH-120, 30)];
        webTitleLabel.textAlignment=NSTextAlignmentCenter;
        webTitleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        self.navigationItem.titleView =webTitleLabel;
        
        UIButton *rightButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-70, 0, 50, 40)];
//        rightButton.backgroundColor=[UIColor blackColor];
        [rightButton addTarget:self action:@selector(rightButAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *roghtbar = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = roghtbar;
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(15, 5, 30, 30)];
        img.image = [UIImage imageNamed:@"WEB_QX"];
        [rightButton addSubview:img];
        
        _progressProxy = [[NJKWebViewProgress alloc] init];
        myWebView.delegate = _progressProxy;
        _progressProxy.webViewProxyDelegate = self;
        _progressProxy.progressDelegate = self;
        
        CGFloat progressBarHeight = 2.f;
        CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        //    _progressView.backgroundColor=[UIColor redColor];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        //    [self webViewLayout];
        [self loadGoogle];
    }else{
        self.navigationController.navigationBarHidden=YES;
        [self webViewLayout];
    }
   
    // Do any additional setup after loading the view.
}
-(void)loadGoogle
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",webURL]];
    //NSLog(@"gourl  =  %@",_imgurl);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:request];
}
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [self.navigationController.navigationBar removeFromSuperview];
    [_progressView removeFromSuperview];
}

-(void)webViewLayout
{
    [myWebView removeFromSuperview];
    myWebView= [[UIWebView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    myWebView.delegate=self;
    //self.meWebView.hidden=YES;
    myWebView.scrollView.delegate=self;
    [self.view addSubview:myWebView];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",webURL]];
    //NSLog(@"gourl  =  %@",_imgurl);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:request];
    
    UIButton *liftButton=[[UIButton alloc]initWithFrame:FRAME(10, 20, 50, 44)];
    //liftButton.backgroundColor=[UIColor blackColor];
    [liftButton addTarget:self action:@selector(liftButAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:liftButton];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:FRAME(18, 11, 10, 20)];
    image.image = [UIImage imageNamed:@"title_left_back"];
    [liftButton addSubview:image];
    
    webTitleLabel=[[UILabel alloc]initWithFrame:FRAME(60, 26, WIDTH-120, 30)];
    webTitleLabel.textAlignment=NSTextAlignmentCenter;
    webTitleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    [self.view addSubview:webTitleLabel];
    
    UIButton *rightButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-60, 20, 50, 40)];
    //rightButton.backgroundColor=[UIColor blackColor];
    [rightButton addTarget:self action:@selector(rightButAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(10, 5, 30, 30)];
    img.image = [UIImage imageNamed:@"WEB_QX"];
    [rightButton addSubview:img];
}
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
//    self.title = [myWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
-(void)rightButAction
{
    [self backAction];
}
-(void)liftButAction
{
    if([myWebView canGoBack])
    {
        [myWebView goBack];
    }else{
        [self backAction];
    }
    
}
-(void)todoSomething
{
    if (_vcIDs==1000) {
       [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)backAction
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething) object:nil];
    [self performSelector:@selector(todoSomething) withObject:nil afterDelay:0.2f];
    
    //    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [webActivityView removeFromSuperview];
    webActivityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    webActivityView.center = CGPointMake(WIDTH/2, HEIGHT/2);
    webActivityView.color = [UIColor redColor];
    [webActivityView startAnimating];
    [myWebView addSubview:webActivityView];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webActivityView stopAnimating]; // 结束旋转
    [webActivityView setHidesWhenStopped:YES]; //当旋转结束时隐藏
    webTitleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
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
