//
//  WebPageViewController.m
//  yxz
//
//  Created by 白玉林 on 16/1/27.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "WebPageViewController.h"
#import "NJKWebViewProgressView.h"
@interface UINavigationItem (margin)

@end

@implementation UINavigationItem (margin)

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
- (void)setLeftBarButtonItem:(UIBarButtonItem *)_leftBarButtonItem
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -12;
        
        if (_leftBarButtonItem)
        {
            [self setLeftBarButtonItems:@[negativeSeperator, _leftBarButtonItem]];
        }
        else
        {
            [self setLeftBarButtonItems:@[negativeSeperator]];
        }
    }
    else
    {
        [self setLeftBarButtonItem:_leftBarButtonItem animated:NO];
    }
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)_rightBarButtonItem
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -12;
        
        if (_rightBarButtonItem)
        {
            [self setRightBarButtonItems:@[negativeSeperator, _rightBarButtonItem]];
        }
        else
        {
            [self setRightBarButtonItems:@[negativeSeperator]];
        }
    }
    else
    {
        [self setRightBarButtonItem:_rightBarButtonItem animated:NO];
    }
}

#endif
@end
@interface WebPageViewController ()
{
    UIView *layoutView;
    UIWebView *myWebView;
    UIActivityIndicatorView *webActivityView;
    UILabel *webTitleLabel;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    UITableView *myTableView;
    NSArray *textArray;
    int tableID;

}
@end

@implementation WebPageViewController
@synthesize webURL;
- (void)viewDidLoad {
    [super viewDidLoad];
    tableID=0;
    self.view.backgroundColor=[UIColor whiteColor];
    myTableView=[[UITableView alloc]initWithFrame:FRAME(WIDTH*0.6, 64, WIDTH*0.4, 0)];
    myTableView.dataSource=self;
    myTableView.delegate=self;
    textArray=@[@"分享",@"刷新"];
    if (_barIDS==100) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
//        [myWebView removeFromSuperview];
        
        myWebView= [[UIWebView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
        myWebView.delegate=self;
        //self.meWebView.hidden=YES;
        myWebView.scrollView.delegate=self;
        [self.view addSubview:myWebView];
        [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
        [self.navigationController.navigationItem setHidesBackButton:YES];
        [self.navigationItem setHidesBackButton:YES];
        
        
        
        UIView  *liftView=[[UIView alloc]initWithFrame:FRAME(0, 0, 80, 44)];
        
        
        UIButton *liftButton=[[UIButton alloc]initWithFrame:FRAME(0, 0, 40, 44)];
//        liftButton.backgroundColor=[UIColor blackColor];
        [liftButton addTarget:self action:@selector(liftButAction) forControlEvents:UIControlEventTouchUpInside];
        [liftView addSubview:liftButton];
        UIBarButtonItem *lifebar = [[UIBarButtonItem alloc] initWithCustomView:liftView];
        self.navigationItem.leftBarButtonItem = lifebar;
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:FRAME(15, 11, 10, 20)];
        image.image = [UIImage imageNamed:@"title_left_back"];
        [liftButton addSubview:image];
        
        
        UIButton *cancelBut=[[UIButton alloc]initWithFrame:FRAME(40, 0, 40, 44)];
        [cancelBut addTarget:self action:@selector(cancelButAction) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *cancelBar = [[UIBarButtonItem alloc] initWithCustomView:cancelBut];
        [liftView addSubview:cancelBut];
        UIImageView *cancelimage = [[UIImageView alloc]initWithFrame:FRAME(10, 12, 20, 20)];
        cancelimage.image = [UIImage imageNamed:@"iconfont_guanbi"];
        [cancelBut addSubview:cancelimage];
        
//        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects: cancelBar,nil]];
        
        
        webTitleLabel=[[UILabel alloc]initWithFrame:FRAME(60, 5, WIDTH-120, 30)];
        webTitleLabel.textAlignment=NSTextAlignmentCenter;
        webTitleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        self.navigationItem.titleView =webTitleLabel;
        
        UIButton *rightButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-70, 0, 50, 40)];
//        rightButton.backgroundColor=[UIColor blackColor];
        [rightButton addTarget:self action:@selector(rightButAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *roghtbar = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = roghtbar;
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(15, 10, 20, 20)];
        img.image = [UIImage imageNamed:@"iconfont_gengduo"];
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
//    [myWebView removeFromSuperview];
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
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(115, 10, 20, 20)];
    img.image = [UIImage imageNamed:@"iconfont_gengduo"];
    [rightButton addSubview:img];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    myWebView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = FRAME(0, 64, WIDTH, 2);
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    //    _progressView.backgroundColor=[UIColor redColor];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    //    [self webViewLayout];
    [self loadGoogle];
}
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
//    self.title = [myWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
-(void)cancelButAction
{
    [self backAction];
}
-(void)rightButAction
{
    if (tableID%2==0) {
        [UIView beginAnimations:nil context:nil];
        //设置动画时长
        [UIView setAnimationDuration:0.5];
        myTableView.frame=FRAME(WIDTH*0.6, 64, WIDTH*0.4, 150);
        [self.view addSubview:myTableView];
        [UIView commitAnimations];
        tableID++;
    }else{
        [UIView beginAnimations:nil context:nil];
        //设置动画时长
        [UIView setAnimationDuration:0.5];
        myTableView.frame=FRAME(WIDTH*0.6, 64, WIDTH*0.4, 0);
        [self.view addSubview:myTableView];
        [UIView commitAnimations];
        tableID--;
    }
    
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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return textArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld,%ld",(long)indexPath.row,(long)indexPath.section];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"%@",textArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            [UMSocialWechatHandler setWXAppId:@"wx93aa45d30bf6cba3" appSecret:@"7a4ec42a0c548c6e39ce9ed25cbc6bd7" url:webURL];
            [UMSocialQQHandler setQQWithAppId:@"1104934408" appKey:@"bRW2glhUCR6aJYIZ" url:webURL];
            [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"247547429" RedirectURL:webURL];
            [UMSocialSnsService presentSnsIconSheetView:self appKey:YMAPPKEY shareText:webURL shareImage:[UIImage imageNamed:@"yunxingzheng-Logo-512.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina,nil] delegate:self];
            [self rightButAction];
        }
            break;
        case 1:
        {
            [self loadGoogle];
            [self rightButAction];
        }
            break;
        default:
            break;
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
