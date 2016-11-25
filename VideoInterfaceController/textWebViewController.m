//
//  textWebViewController.m
//  海狸司机
//
//  Created by 鲜世杰 on 16/10/12.
//  Copyright © 2016年 public. All rights reserved.
//

#import "textWebViewController.h"

@interface textWebViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *mainWebView;
@end

@implementation textWebViewController

-(UIWebView *)mainWebView{
    
    if (_mainWebView == nil) {
        _mainWebView = [[UIWebView alloc]init];
        _mainWebView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        _mainWebView.backgroundColor = [UIColor clearColor];
        _mainWebView.delegate = self;
        [_mainWebView setUserInteractionEnabled:YES];//是否支持交互
        [_mainWebView setOpaque:NO];//opaque是不透明的意思
//        [_mainWebView setScalesPageToFit:YES];//自动缩放以适应屏幕
        [self.view addSubview:_mainWebView];
        for (UIView *_aView in [_mainWebView subviews])
        {
            if ([_aView isKindOfClass:[UIScrollView class]])
            {
                [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO]; //右侧的滚动条
                
                for (UIView *_inScrollview in _aView.subviews)
                {
                    
                    if ([_inScrollview isKindOfClass:[UIImageView class]])
                    {
                        _inScrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                    } 
                } 
            } 
        }
    }
    return _mainWebView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}
- (void)title:(NSString *)title webUrl:(NSString *)webUrl{

    self.title = @"";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:webUrl]];
    [self.mainWebView loadRequest:request];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(15,11, 10, 20)];
//    [leftButton setImage:[UIImage imageNamed:@"title_left_back"]forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(popHomeView) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItem = leftItem;
//
    UIView  *liftView=[[UIView alloc]initWithFrame:FRAME(0, 0, 80, 44)];
    UIButton *liftButton=[[UIButton alloc]initWithFrame:FRAME(0, 0, 40, 44)];
    [liftButton addTarget:self action:@selector(popHomeView) forControlEvents:UIControlEventTouchUpInside];
    [liftView addSubview:liftButton];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:FRAME(15, 11, 10, 20)];
    image.image = [UIImage imageNamed:@"title_left_back"];
    [liftButton addSubview:image];
    
    UIBarButtonItem *lifebar = [[UIBarButtonItem alloc] initWithCustomView:liftView];
    self.navigationItem.leftBarButtonItem = lifebar;
    self.view.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
    
}
//H5加载结束后
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTapHighlightColor='rgba(0,0,0,0)';"];

    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)popHomeView{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
