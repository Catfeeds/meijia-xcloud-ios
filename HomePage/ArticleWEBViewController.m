//
//  ArticleWEBViewController.m
//  yxz
//
//  Created by 白玉林 on 16/5/24.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "ArticleWEBViewController.h"
#import "NJKWebViewProgressView.h"
#import "CommentListTableViewCell.h"
#import "AFHTTPRequestOperationManager.h"
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
@interface ArticleWEBViewController ()
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
    
    UIView *plView;
    UITextView *myTextView;
    int  keypadHight;
    
    UIView *keypadView;
    UIView *maskVIew;
    UIButton *publishButton;
    UIButton *blackBut;
    UILabel *viewLabel;
    UITableView *myListTableView;
    int listIDs;
    
    UIImageView *plImageView;
    UIImageView *clickImageView;
    UIImageView *fxImageView;
    NSMutableArray *listArray;
    
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    int   page;
    
    NSString *clickStr;
    FatherViewController *fatherVc;
    UITextView *labelASS;
    
    NSDictionary *dataDict;
    NSString *webURLSSS;
    int  webDJID;
}
@end

@implementation ArticleWEBViewController
@synthesize webURL;
#pragma mark获取当前动态是否点赞接口
-(void)diazanLayout
{
    DownloadManager *_download = [[DownloadManager alloc]init];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSDictionary *_dict=@{@"fid":_listID,@"user_id":_manager.telephone};
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",ARTICLE_CLICK_BOOL] dict:_dict view:self.view delegate:self finishedSEL:@selector(ClickBoolSuccess:) isPost:NO failedSEL:@selector(ClickBoolFail:)];
}

-(void)ClickBoolSuccess:(id)source
{
    clickStr=[NSString stringWithFormat:@"%@",[source objectForKey:@"data"]];
    if (clickStr==nil||clickStr==NULL||[clickStr isEqualToString:@""]) {
        clickImageView.image=[UIImage imageNamed:@"赞-点击前"];
    }else{
        clickImageView.image=[UIImage imageNamed:@"赞-点击后"];
    }
}
-(void)ClickBoolFail:(id)source
{
    NSLog(@"获取当前动态是否点赞失败:%@",source);
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    int width = keyboardRect.size.width;
    NSLog(@"键盘高度是  %d",height);
    NSLog(@"键盘宽度是  %d",width);
    keypadHight=height;
    keypadView.frame=FRAME(0, HEIGHT-(keypadHight+145), WIDTH, 145);
    blackBut.frame=FRAME(0, 0, WIDTH, HEIGHT-(keypadHight+145));
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    keypadView.frame=FRAME(0, HEIGHT, WIDTH, 145);
    blackBut.frame=FRAME(0, HEIGHT, WIDTH, HEIGHT-(keypadHight+145));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    fatherVc=[[FatherViewController alloc]init];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    listArray=[[NSMutableArray alloc]init];
    tableID=0;
    page=1;
    self.view.backgroundColor=[UIColor whiteColor];
    myTableView=[[UITableView alloc]initWithFrame:FRAME(WIDTH*0.6, 64, WIDTH*0.4, 0)];
    myTableView.dataSource=self;
    myTableView.delegate=self;
    textArray=@[@"分享",@"刷新"];
    
    plView=[[UIView alloc]initWithFrame:FRAME(0, HEIGHT-50, WIDTH, 50)];
    plView.backgroundColor=[UIColor colorWithRed:244/255.0f green:245/255.0f blue:246/255.0f alpha:1];
    [self.view addSubview:plView];
    
    UIButton *fieldView=[[UIButton alloc]initWithFrame:FRAME(31/2, 9, WIDTH-340/2, 32)];
    fieldView.backgroundColor=[UIColor whiteColor];
    fieldView.layer.borderWidth = 1;
    fieldView.layer.borderColor = [[UIColor colorWithRed:203/255.0f green:203/255.0f blue:203/255.0f alpha:1] CGColor];
    fieldView.layer.cornerRadius=32/2;
    fieldView.clipsToBounds=YES;
    [fieldView addTarget:self action:@selector(fieldBut) forControlEvents:UIControlEventTouchUpInside];
    [plView addSubview:fieldView];
    
    UILabel *plTextField=[[UILabel alloc]initWithFrame:FRAME(14, 0, fieldView.frame.size.width-28, 32)];
    //    plTextField.font=[UIFont fontWithName:@"Heiti SC" size:11];
    //    plTextField.backgroundColor=[UIColor redColor];
    plTextField.text=@"写评论...";
    plTextField.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    [fieldView addSubview:plTextField];
    NSArray *imageArray=@[@"评论 (1)",@"赞-点击前",@"分享"];
    for (int  i=0; i<3; i++) {
        UIButton *button=[[UIButton alloc]initWithFrame:FRAME(WIDTH-309/2+i*(309/2/3), 0, 309/2/3, 50)];
        [plView addSubview:button];
        button.tag=i;
        [button addTarget:self action:@selector(ButAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            plImageView=[[UIImageView alloc]initWithFrame:FRAME((button.frame.size.width-22)/2, 28/2, 22, 22)];
            plImageView.tag=10+i;
            plImageView.image=[UIImage imageNamed:imageArray[i]];
            [button addSubview:plImageView];
        }else if (i==1){
            clickImageView=[[UIImageView alloc]initWithFrame:FRAME((button.frame.size.width-22)/2, 28/2, 22, 22)];
            clickImageView.tag=10+i;
            clickImageView.image=[UIImage imageNamed:imageArray[i]];
            [button addSubview:clickImageView];
        }else{
            fxImageView=[[UIImageView alloc]initWithFrame:FRAME((button.frame.size.width-22)/2, 28/2, 22, 22)];
            fxImageView.tag=10+i;
            fxImageView.image=[UIImage imageNamed:imageArray[i]];
            [button addSubview:fxImageView];
        }
        
        
    }
    if (_barIDS==100) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        //        [myWebView removeFromSuperview];
        if (_pushID==100) {
            myWebView= [[UIWebView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-114)];
            plView.hidden=NO;
        }else{
            myWebView= [[UIWebView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
            plView.hidden=YES;
        }
        myWebView.scalesPageToFit = NO;
        myWebView.delegate=self;
        //self.meWebView.hidden=YES;
        myWebView.scrollView.delegate=self;
        [self.view addSubview:myWebView];
        [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
        [self.navigationController.navigationItem setHidesBackButton:YES];
        [self.navigationItem setHidesBackButton:YES];
        
       
        
        //        [myWebView loadHTMLString:htmlURlStr baseURL:nil];
        
        UIView  *liftView=[[UIView alloc]initWithFrame:FRAME(0, 0, 40, 44)];
        
        
        UIButton *liftButton=[[UIButton alloc]initWithFrame:FRAME(0, 0, 40, 44)];
        //        liftButton.backgroundColor=[UIColor blackColor];
        [liftButton addTarget:self action:@selector(liftButAction) forControlEvents:UIControlEventTouchUpInside];
        [liftView addSubview:liftButton];
        UIBarButtonItem *lifebar = [[UIBarButtonItem alloc] initWithCustomView:liftView];
        self.navigationItem.leftBarButtonItem = lifebar;
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:FRAME(15, 11, 10, 20)];
        image.image = [UIImage imageNamed:@"title_left_back"];
        [liftButton addSubview:image];
        
        
//        UIButton *cancelBut=[[UIButton alloc]initWithFrame:FRAME(40, 0, 40, 44)];
//        [cancelBut addTarget:self action:@selector(cancelButAction) forControlEvents:UIControlEventTouchUpInside];
//        //        UIBarButtonItem *cancelBar = [[UIBarButtonItem alloc] initWithCustomView:cancelBut];
//        [liftView addSubview:cancelBut];
//        UIImageView *cancelimage = [[UIImageView alloc]initWithFrame:FRAME(10, 12, 20, 20)];
//        cancelimage.image = [UIImage imageNamed:@"iconfont_guanbi"];
//        [cancelBut addSubview:cancelimage];
        
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
        [self loadMyWebView];
    }else{
        self.navigationController.navigationBarHidden=YES;
//        [self webViewLayout];
    }
    
    myListTableView=[[UITableView alloc]initWithFrame:FRAME(0, HEIGHT, WIDTH, HEIGHT-50)style:UITableViewStyleGrouped];
    myListTableView.delegate=self;
    myListTableView.dataSource=self;
    myListTableView.backgroundColor=[UIColor colorWithRed:247/255.0f green:248/255.0f blue:249/255.0f alpha:1];
    myListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myListTableView];
    
    _refreshHeader = [[MJRefreshHeaderView alloc] init];
    _refreshHeader.delegate = self;
    _refreshHeader.scrollView = myListTableView;
    
    _moreFooter = [[MJRefreshFooterView alloc] init];
    _moreFooter.delegate = self;
    _moreFooter.scrollView = myListTableView;
    
    keypadView=[[UIView alloc]initWithFrame:FRAME(0, HEIGHT, WIDTH, 145)];
    keypadView.backgroundColor=[UIColor colorWithRed:243/255.0f green:246/255.0f blue:246/255.0f alpha:1];
    //    [self.view addSubview:keypadView];
    //    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self.view addSubview:keypadView];
    
    myTextView=[[UITextView alloc]initWithFrame:FRAME(9, 9, WIDTH-18, 90)];
    myTextView.backgroundColor=[UIColor whiteColor];
    myTextView.layer.cornerRadius=8;
    myTextView.clipsToBounds=YES;
    myTextView.delegate=self;
    [keypadView addSubview:myTextView];
    
    viewLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, 200, 20)];
    viewLabel.enabled = NO;
    viewLabel.text = @"写下您的看法与见解...";
    viewLabel.font =  [UIFont systemFontOfSize:15];
    viewLabel.textColor = [UIColor lightGrayColor];
    [myTextView addSubview:viewLabel];
    
    publishButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-57, 108, 48, 28)];
    publishButton.backgroundColor=[UIColor colorWithRed:202/255.0f green:202/255.0f blue:202/255.0f alpha:1];
    [publishButton setTitle:@"发布" forState:UIControlStateNormal];
    publishButton.enabled=FALSE;
    [publishButton addTarget:self action:@selector(publishBut) forControlEvents:UIControlEventTouchUpInside];
    publishButton.layer.cornerRadius=5;
    publishButton.clipsToBounds=YES;
    [keypadView addSubview:publishButton];
    
    blackBut=[[UIButton alloc]initWithFrame:FRAME(0, HEIGHT, WIDTH, HEIGHT-(keypadHight+145))];
    blackBut.backgroundColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    [blackBut addTarget:self action:@selector(blackButAction) forControlEvents:UIControlEventTouchUpInside];
    blackBut.alpha=0.6;
    [self.view addSubview:blackBut];
    
        [self loadMyWebView];
       //    [self.view addSubview:labelASS];
    
    // Do any additional setup after loading the view.
}

-(void) loadMyWebView{
    NSString *urlString = [NSString stringWithFormat:@"http://51xingzheng.cn/?json=get_post&post_id=%@&include=id,title,modified,url,thumbnail,custom_fields,content",_listID];
    AFHTTPRequestOperationManager *mymanager = [AFHTTPRequestOperationManager manager];
    
    [mymanager GET:[NSString stringWithFormat:@"%@",urlString] parameters:nil success:^(AFHTTPRequestOperation *opretion, id responseObject){
        dataDict=[responseObject objectForKey:@"post"];
        
        NSString *title=[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"title"]];
        NSString *linkStr=[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"content"]];
        //初始化和html字符串
        webURLSSS=[NSString stringWithFormat:@"<body style='background-color:#EBEBF3'><h2>%@</h2><p>%@</p>>",title,linkStr];
        webTitleLabel.text=title;
        [self loadGoogle];
        
    } failure:^(AFHTTPRequestOperation *opration, NSError *error){
        
        NSLog(@"失败数据%@",error);
        
        
    }];
    
    
    
    
}
- (void) textViewDidChange:(UITextView *)textView{
    if ([textView.text length] == 0) {
        [viewLabel setHidden:NO];
        publishButton.enabled=FALSE;
        publishButton.backgroundColor=[UIColor colorWithRed:202/255.0f green:202/255.0f blue:202/255.0f alpha:1];
    }else{
        [viewLabel setHidden:YES];
        publishButton.enabled=TRUE;
        publishButton.backgroundColor=[UIColor colorWithRed:0/255.0f green:142/255.0f blue:214/255.0f alpha:1];
    }
}
-(void)refreshURLgo
{
    //    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",refreshURL]];
    //    //NSLog(@"gourl  =  %@",_imgurl);
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    [myWebView loadRequest:request];
    [myWebView loadHTMLString:webURLSSS baseURL:nil];
    
}
-(void)loadGoogle
{
    //    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",webURL]];
    //    //NSLog(@"gourl  =  %@",_imgurl);
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    [myWebView loadRequest:request];
    
    [myWebView loadHTMLString:webURLSSS baseURL:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
    if(fatherVc.loginYesOrNo==YES)
    {
        if (_pushID==100) {
            [self listLayout];
            [self diazanLayout];
        }
        
    }
    
}
//-(void)viewDidDisappear:(BOOL)animated
//{
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [self.navigationController.navigationBar removeFromSuperview];
    [_progressView removeFromSuperview];
}

//-(void)webViewLayout
//{
//    //    [myWebView removeFromSuperview];
//    myWebView= [[UIWebView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
//    myWebView.delegate=self;
//    //self.meWebView.hidden=YES;
//    myWebView.scrollView.delegate=self;
//    [self.view addSubview:myWebView];
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",webURL]];
//    //NSLog(@"gourl  =  %@",_imgurl);
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [myWebView loadRequest:request];
//    
//    UIButton *liftButton=[[UIButton alloc]initWithFrame:FRAME(10, 20, 50, 44)];
//    //liftButton.backgroundColor=[UIColor blackColor];
//    [liftButton addTarget:self action:@selector(liftButAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:liftButton];
//    
//    UIImageView *image = [[UIImageView alloc]initWithFrame:FRAME(18, 11, 10, 20)];
//    image.image = [UIImage imageNamed:@"title_left_back"];
//    [liftButton addSubview:image];
//    
//    webTitleLabel=[[UILabel alloc]initWithFrame:FRAME(60, 26, WIDTH-120, 30)];
//    webTitleLabel.textAlignment=NSTextAlignmentCenter;
//    webTitleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
//    [self.view addSubview:webTitleLabel];
//    
//    UIButton *rightButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-60, 20, 50, 40)];
//    //rightButton.backgroundColor=[UIColor blackColor];
//    [rightButton addTarget:self action:@selector(rightButAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:rightButton];
//    
//    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(115, 10, 20, 20)];
//    img.image = [UIImage imageNamed:@"iconfont_gengduo"];
//    [rightButton addSubview:img];
//    
//    _progressProxy = [[NJKWebViewProgress alloc] init];
//    myWebView.delegate = _progressProxy;
//    _progressProxy.webViewProxyDelegate = self;
//    _progressProxy.progressDelegate = self;
//    
//    CGFloat progressBarHeight = 2.f;
//    CGRect navigationBarBounds = FRAME(0, 64, WIDTH, 2);
//    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
//    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
//    //    _progressView.backgroundColor=[UIColor redColor];
//    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//    //    [self webViewLayout];
//    [self loadGoogle];
//}
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    //    self.title = [myWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
-(void)cancelButAction
{
    [myTextView resignFirstResponder];
    [self backAction];
}
-(void)rightButAction
{
    [myTextView resignFirstResponder];
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
    [myTextView resignFirstResponder];
    if([myWebView canGoBack])
    {
        
        [myWebView goBack];
    }else{
//        if (webDJID>0) {
//            webDJID--;
//            [self loadMyWebView];
//        }else{
            [self backAction];
//        }
    }
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    switch (navigationType)
    {
            //点击连接
        case UIWebViewNavigationTypeLinkClicked:
        {
            NSLog(@"clicked");
            if (webDJID==0) {
                webDJID++;
            }
            
        }
            break;
            //提交表单
        case UIWebViewNavigationTypeFormSubmitted:
        {
            NSLog(@"submitted");
            if (webDJID==0) {
                webDJID++;
            }
        }
        default:
            break;
    }
    return YES;
}
-(void)todoSomething
{
    if(listIDs==1)
    {
        [UIView beginAnimations: @"Animation" context:nil];
        [UIView setAnimationDuration:0.3];
        myListTableView.frame=FRAME(0, HEIGHT, WIDTH, HEIGHT-114);
        [UIView commitAnimations];
        listIDs--;
    }else{
        if (_vcIDs==1000) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        if (_qdIDl==1000) {
            [self dismissViewControllerAnimated:YES completion:nil];
            //        if([origin isMemberOfClass:[MyLogInViewController class]]){
            //            origin = self.presentingViewController.presentingViewController.presentingViewController;
            //        }
            //        [origin dismissViewControllerAnimated:NO completion:nil];
        }

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
//    webTitleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    refreshURL=webView.request.URL.absoluteString;
    NSLog(@"%@",webView.request.URL.absoluteString);
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int  count;
    if (tableView==myTableView) {
        count=(int)textArray.count;
    }else{
        count=(int)listArray.count;
    }
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==myTableView) {
        NSString *identifier = [NSString stringWithFormat:@"Cell%ld,%ld",(long)indexPath.row,(long)indexPath.section];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.textLabel.text=[NSString stringWithFormat:@"%@",textArray[indexPath.row]];
        cell.textLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        return cell;
    }else{
        NSDictionary *dic=listArray[indexPath.row];
        NSString *identifier = [NSString stringWithFormat:@"Cell%ld,%ld",(long)indexPath.row,(long)indexPath.section];
        CommentListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[CommentListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"head_img"]];
        [cell.headImageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
        cell.nameLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        cell.nameLabel.textColor=[UIColor colorWithRed:146/255.0f green:146/255.0f blue:146/255.0f alpha:1];
        cell.timeLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"add_time_str"]];
        cell.timeLabel.textColor=[UIColor colorWithRed:209/255.0f green:209/255.0f blue:209/255.0f alpha:1];
        cell.texLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"comment"]];
        UIFont *font=[UIFont fontWithName:@"Heiti SC" size:15];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        CGSize size = [cell.texLabel.text boundingRectWithSize:CGSizeMake(WIDTH-60, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        [cell.texLabel setNumberOfLines:0];
        [cell.texLabel sizeToFit];
        cell.texLabel.frame=FRAME(50, 60, WIDTH-60, size.height);
        UIView  *lineView=[[UIView alloc]initWithFrame:FRAME(10, 70+size.height, WIDTH-20, 1)];
        lineView.backgroundColor=[UIColor colorWithRed:226/255.0f green:227/255.0f blue:228/255.0f alpha:1];
        [cell addSubview:lineView];
        cell.backgroundColor=[UIColor colorWithRed:247/255.0f green:248/255.0f blue:249/255.0f alpha:1];
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==myTableView) {
        return 50;
    }else{
        CommentListTableViewCell *cell=[[CommentListTableViewCell alloc]init];
        NSDictionary *dic=listArray[indexPath.row];
        cell.texLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"comment"]];
        UIFont *font=[UIFont fontWithName:@"Heiti SC" size:15];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        CGSize size = [cell.texLabel.text boundingRectWithSize:CGSizeMake(WIDTH-60, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        return size.height+71;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == myTableView) {
        return 0;
    }else{
        return 43;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == myTableView){
        return nil;
    }else{
        UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 43)];
        UILabel *nameLabel=[[UILabel alloc]init];
        nameLabel.text=@"评论";
        nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        nameLabel.textColor=[UIColor colorWithRed:50/255.0f green:51/255.0f blue:52/255.0f alpha:1];
        [nameLabel setNumberOfLines:1];
        [nameLabel sizeToFit];
        nameLabel.frame=FRAME(10, 20, nameLabel.frame.size.width, 15);
        [view addSubview:nameLabel];
        
        UIView *labelView=[[UIView alloc]initWithFrame:FRAME(10, 42, nameLabel.frame.size.width, 1)];
        labelView.backgroundColor=[UIColor colorWithRed:255/255.0f green:123/255.0f blue:129/255.0f alpha:1];
        [view addSubview:labelView];
        
        UIView *lineView=[[UIView alloc]initWithFrame:FRAME(10+nameLabel.frame.size.width, 42, WIDTH-20-nameLabel.frame.size.width, 1)];
        lineView.backgroundColor=[UIColor colorWithRed:226/255.0f green:227/255.0f blue:228/255.0f alpha:1];
        [view addSubview:lineView];
        return view;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (myTableView) {
        switch (indexPath.row) {
            case 0:
            {
                [UMSocialWechatHandler setWXAppId:@"wx93aa45d30bf6cba3" appSecret:@"7a4ec42a0c548c6e39ce9ed25cbc6bd7" url:webURL];
                [UMSocialQQHandler setQQWithAppId:@"1104934408" appKey:@"bRW2glhUCR6aJYIZ" url:webURL];
                [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"247547429" RedirectURL:webURL];
                [UMSocialSnsService presentSnsIconSheetView:self appKey:YMAPPKEY shareText:webTitleLabel.text shareImage:[UIImage imageNamed:@"yunxingzheng-Logo-512.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina,nil] delegate:self];
                [self rightButAction];
            }
                break;
            case 1:
            {
                [self loadMyWebView];
                [self rightButAction];
            }
                break;
            default:
                break;
        }
        
    }else{
        
    }
    
}
#pragma mark 评论按钮点击方法
-(void)fieldBut
{
    if(fatherVc.loginYesOrNo!=YES)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            MyLogInViewController *loginViewController = [[MyLogInViewController alloc] init];
            loginViewController.vCYMID=100;
            UMComNavigationController *navigationController = [[UMComNavigationController alloc] initWithRootViewController:loginViewController];
            [self presentViewController:navigationController animated:YES completion:^{
            }];
        });
    }else{
        [myTextView becomeFirstResponder];//弹出键盘
    }
    
    
}
#pragma mark 发布按钮点击方法
-(void)publishBut
{
    [myTextView resignFirstResponder];
    DownloadManager *_download = [[DownloadManager alloc]init];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSDictionary *_dict=@{@"fid":_listID,@"user_id":_manager.telephone,@"comment":myTextView.text};
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",DYNAMIC_COMMENT] dict:_dict view:self.view delegate:self finishedSEL:@selector(publishSuccess:) isPost:YES failedSEL:@selector(publishFail:)];
}
-(void)publishSuccess:(id)source
{
    [self listLayout];
}
-(void)publishFail:(id)source
{
    NSLog(@"评论失败反悔:%@",source);
}
#pragma mark 黑色透明区点击方法
-(void)blackButAction
{
    [myTextView resignFirstResponder];
}
#pragma mark 右侧三个按钮点击方法
-(void)ButAction:(UIButton *)button
{
    if(fatherVc.loginYesOrNo!=YES)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            MyLogInViewController *loginViewController = [[MyLogInViewController alloc] init];
            loginViewController.vCYMID=100;
            UMComNavigationController *navigationController = [[UMComNavigationController alloc] initWithRootViewController:loginViewController];
            [self presentViewController:navigationController animated:YES completion:^{
            }];
        });
    }else{
        switch (button.tag) {
            case 0:
            {
                if (listIDs%2==0) {
                    [UIView beginAnimations: @"Animation" context:nil];
                    [UIView setAnimationDuration:0.3];
                    myListTableView.frame=FRAME(0, 64, WIDTH, HEIGHT-114);
                    [UIView commitAnimations];
                    
                    listIDs++;
                }else{
                    [UIView beginAnimations: @"Animation" context:nil];
                    [UIView setAnimationDuration:0.3];
                    myListTableView.frame=FRAME(0, HEIGHT, WIDTH, HEIGHT-114);
                    [UIView commitAnimations];
                    listIDs--;
                }
                
            }
                break;
            case 1:
            {
                DownloadManager *_download = [[DownloadManager alloc]init];
                ISLoginManager *_manager = [ISLoginManager shareManager];
                NSString *actionStr;
                if (clickStr==nil||clickStr==NULL||[clickStr isEqualToString:@""]) {
                    actionStr=@"add";
                }else{
                    actionStr=@"del";
                }
                NSDictionary *_dict=@{@"fid":_listID,@"user_id":_manager.telephone,@"action":actionStr};
                [_download requestWithUrl:[NSString stringWithFormat:@"%@",DYNAMIC_SHARE] dict:_dict view:self.view delegate:self finishedSEL:@selector(ClickSuccess:) isPost:YES failedSEL:@selector(ClickFail:)];
            }
                break;
            case 2:
            {
                [UMSocialWechatHandler setWXAppId:@"wx93aa45d30bf6cba3" appSecret:@"7a4ec42a0c548c6e39ce9ed25cbc6bd7" url:webURL];
                [UMSocialQQHandler setQQWithAppId:@"1104934408" appKey:@"bRW2glhUCR6aJYIZ" url:webURL];
                [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"247547429" RedirectURL:webURL];
                [UMSocialSnsService presentSnsIconSheetView:self appKey:YMAPPKEY shareText:webTitleLabel.text shareImage:[UIImage imageNamed:@"yunxingzheng-Logo-512.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina,nil] delegate:self];
            }
                break;
            default:
                break;
        }

    }
}
#pragma mark 点赞成功
-(void)ClickSuccess:(id)source
{
    NSLog(@"点赞成功数据 :%@",source);
    [self diazanLayout];
}
#pragma mark 点赞失败
-(void)ClickFail:(id)source
{
    NSLog(@"点赞失败数据 :%@",source);
}
-(void)listLayout
{
    DownloadManager *_download = [[DownloadManager alloc]init];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSDictionary *_dict=@{@"fid":_listID,@"user_id":_manager.telephone};
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",DYNAMIC_COM_CARD] dict:_dict view:self.view delegate:self finishedSEL:@selector(ListSuccess:) isPost:NO failedSEL:@selector(ListFail:)];
}
-(void)ListSuccess:(id)source
{
    NSLog(@"评论列表数据成功:%@",source);
    NSString *string=[NSString stringWithFormat:@"%@",[source objectForKey:@"data"]];
    if (string==nil||string==NULL||[string isEqualToString:@""]) {
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }else{
        
        if(page==1){
            [listArray removeAllObjects];
        }
        //        NSLog(@"数据%@",responseObject);
        NSArray *array=[source objectForKey:@"data"];
        if (array.count<10) {
            _hasMore=YES;
        }else{
            _hasMore=NO;
        }
        
        for (int i=0; i<array.count; i++) {
            NSDictionary *dict=array[i];
            if ([listArray containsObject:dict]) {
                
            }else{
                [listArray addObject:dict];
            }
        }
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        
        //        if (array.count<5) {
        //            selectedID=YES;
        //        }
        [myListTableView reloadData];
        
    }
}
-(void)ListFail:(id)source
{
    NSLog(@"评论列表数据失败:%@",source);
}

#pragma mark 表格刷新相关
#pragma mark 刷新
-(void)refresh
{
    [_refreshHeader beginRefreshing];
}


#pragma mark - MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        //头 -》 刷新
        if (_moreFooter.isRefreshing) {
            //正在加载更多，取消本次请求
            [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            return;
        }
        page = 1;
        //刷新
        [self loadData];
        
    }else if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
        //尾 -》 更多
        if (_refreshHeader.isRefreshing) {
            //正在刷新，取消本次请求
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            
            return;
        }
        
        if (_hasMore==YES) {
            //没有更多了
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            //            [_tableView reloadData];
            return;
        }
        page++;
        
        //加载更多
        
        [self loadData];
    }
}

-(void)loadData
{
    //    if (_service == nil) {
    //        _service = [[zzProjectListService alloc] init];
    //        _service.delegate = self;
    //    }
    
    //通过控制page控制更多 网路数据
    //    [_service reqwithPageSize:INVESTPAGESIZE page:page];
    //    [self loadImg];
    
    //本底数据
    //    [_arrData addObjectsFromArray:[UIFont familyNames]];
    
    [self listLayout];
    
    
    
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
