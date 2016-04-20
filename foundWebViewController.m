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
@interface foundWebViewController ()
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
    NSString *refreshURL;
}

@end

@implementation foundWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tableID=0;
    NSLog(@"%f,%f,%f,%f",self.view.frame.origin.x,self.view.frame.origin.y,WIDTH,HEIGHT);
    self.view.backgroundColor=[UIColor whiteColor];
    myTableView=[[UITableView alloc]initWithFrame:FRAME(WIDTH*0.6, 64, WIDTH*0.4, 0)];
   
    myTableView.dataSource=self;
    myTableView.delegate=self;
    textArray=@[@"分享",@"刷新"];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //        [myWebView removeFromSuperview];
    
    myWebView= [[UIWebView alloc]init];
    myWebView.delegate=self;
    //self.meWebView.hidden=YES;
    myWebView.scrollView.delegate=self;
    
    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
    [self.navigationController.navigationItem setHidesBackButton:YES];
    [self.navigationItem setHidesBackButton:YES];
    if ([_goto_type isEqualToString:@"h5+list"]) {
        myWebView.frame=FRAME(0, 64, WIDTH, HEIGHT-114);
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
        myWebView.frame=FRAME(0, 64, WIDTH, HEIGHT-64);
    }
    
    
    
    
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
     myWebView.scalesPageToFit=YES;
    [self.view addSubview:myWebView];
}
//-(void)webViewLayout
//{
//    [myWebView removeFromSuperview];
//    if ([_goto_type isEqualToString:@"h5+list"]) {
//        myWebView=[[UIWebView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-114)];
//        UIView *buttonView=[[UIView alloc]initWithFrame:FRAME(0, HEIGHT-50, WIDTH, 52)];
//        buttonView.backgroundColor=[UIColor blackColor];
//        [self.view addSubview:buttonView];
//        UIButton *button=[[UIButton alloc]initWithFrame:FRAME(WIDTH-100, 0, 100, 50)];
//        button.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
//        [button setTitle:@"确认购买" forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(consultingAction:) forControlEvents:UIControlEventTouchUpInside];
//        [buttonView addSubview:button];
//        UILabel *lab=[[UILabel alloc]initWithFrame:FRAME(10, 11, WIDTH-180, 30)];
//        lab.text=[NSString stringWithFormat:@"￥%@",_moneyStr];
//        lab.font=[UIFont fontWithName:@"Heiti SC" size:20];
//        lab.textColor=[UIColor redColor];
//        [buttonView addSubview:lab];
//    }else{
//        myWebView=[[UIWebView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
//    }
//    
//    myWebView.scalesPageToFit=YES;
//    myWebView.delegate=self;
//    [self.view addSubview:myWebView];
//    myWebView.scrollView.delegate=self;
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_imgurl]];
//    //NSLog(@"gourl  =  %@",_imgurl);
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [myWebView loadRequest:request];
//}
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
-(void)loadGoogle
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_imgurl]];
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
    //    if (_vcIDs==1000) {
    //        [self dismissViewControllerAnimated:YES completion:nil];
    //    }else{
    [self.navigationController popViewControllerAnimated:YES];
    //    }
    
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
    refreshURL=webView.request.URL.absoluteString;
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
    cell.textLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
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
            [UMSocialWechatHandler setWXAppId:@"wx93aa45d30bf6cba3" appSecret:@"7a4ec42a0c548c6e39ce9ed25cbc6bd7" url:_imgurl];
            [UMSocialQQHandler setQQWithAppId:@"1104934408" appKey:@"bRW2glhUCR6aJYIZ" url:_imgurl];
            [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"247547429" RedirectURL:_imgurl];
            [UMSocialSnsService presentSnsIconSheetView:self appKey:YMAPPKEY shareText:webTitleLabel.text shareImage:[UIImage imageNamed:@"yunxingzheng-Logo-512.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina,nil] delegate:self];
            [self rightButAction];
        }
            break;
        case 1:
        {
            [self refreshURLgo];
            [self rightButAction];
        }
            break;
        default:
            break;
    }
    
}
-(void)refreshURLgo
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",refreshURL]];
    //NSLog(@"gourl  =  %@",_imgurl);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:request];
    
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
