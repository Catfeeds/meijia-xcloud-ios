//
//  FoundViewController.m
//  simi
//
//  Created by 白玉林 on 15/7/31.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//
#import "FoundViewController.h"
#import "ImgWebViewController.h"
#import "ClerkViewController.h"
#import "SearchVoiceViewController.h"
#import "HairViewController.h"
@interface FoundViewController ()
{
    UIScrollView *rootView;
    UIView *mainView;
    UIButton *tabBar;
    UIButton *tabBar1;
    UIButton *tabBar2;
    UIButton *tabBar3;
    UIView *jdView;
    UIActivityIndicatorView *view;
    UIViewController *currentViewController;
    
    int scrollID;
    int buttID;
    NSArray *array;
    
}
@end
HairViewController *oneViewController;
HairViewController *towViewController;
HairViewController *threeViewController;
HairViewController *fourViewController;
@implementation FoundViewController
@synthesize meWebView,lineImageView,vcID;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"发现"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"发现"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (vcID==1005) {
        self.backBtn.hidden=NO;
    }else
    {
        self.backBtn.hidden=YES;
    }
    //self.navlabel.text=@"发现";
    UIView *reView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 64)];
    reView.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [self.view addSubview:reView];
    UIButton *searchButton=[[UIButton alloc]initWithFrame:FRAME(20, 30, WIDTH-40, 25)];
    searchButton.backgroundColor=[UIColor whiteColor];//colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [searchButton addTarget:self action:@selector(searchButAction) forControlEvents:UIControlEventTouchUpInside];
    [reView addSubview:searchButton];
    UIImageView *searchImage=[[UIImageView alloc]initWithFrame:FRAME(5, 5, 15, 15)];
    searchImage.image=[UIImage imageNamed:@"search_@2x"];
    [searchButton addSubview:searchImage];
    UIImageView *voiceImage=[[UIImageView alloc]initWithFrame:FRAME(searchButton.frame.size.width-20, 5, 15, 15)];
    voiceImage.image=[UIImage imageNamed:@"iconfont-yuyin-copy"];
    [searchButton addSubview:voiceImage];
    UILabel *searchLabel=[[UILabel alloc]initWithFrame:FRAME(45, 5, searchButton.frame.size.width-90, 15)];
    searchLabel.text=@"点击搜索相关信息";
    searchLabel.font=[UIFont fontWithName:@"Arial" size:13];
    searchLabel.textAlignment=NSTextAlignmentCenter;
    searchLabel.textColor=[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
    [searchButton addSubview:searchLabel];
    
    
    mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 101,WIDTH, SELF_VIEW_HEIGHT-151)];
    mainView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:mainView];
    
    [oneViewController removeFromParentViewController];
    oneViewController=[[HairViewController alloc]init];
    [self addChildViewController:oneViewController];
    DownloadManager *_download = [[DownloadManager alloc]init];
    [_download requestWithUrl:FOUND_CHANNEL dict:nil view:self.view delegate:self finishedSEL:@selector(ChannelSuccess:) isPost:NO failedSEL:@selector(ChannelFailure:)];
}
#pragma mark 获取频道列表成功返回方法
-(void)ChannelSuccess:(id)sender
{
    NSLog(@"获取频道列表成功数据%@",sender);
    array=[sender objectForKey:@"data"];
    oneViewController.channel_id=[NSString stringWithFormat:@"%@",[array[0] objectForKey:@"channel_id"]];
    [mainView addSubview:oneViewController.view];
    currentViewController = oneViewController;
    
    [self rootViewLayout];
    
}
#pragma mark 获取频道列表失败返回方法
-(void)ChannelFailure:(id)sender
{
    NSLog(@"获取频道列表失败数据%@",sender);
}
-(void)rootViewLayout
{
    [rootView removeFromSuperview];
    rootView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 37)];
    rootView.backgroundColor=[UIColor whiteColor];
    rootView.contentSize=CGSizeMake(WIDTH/4*array.count, 37);
    //rootView.pagingEnabled=YES;
    rootView.bounces=NO;
    rootView.delegate=self;
    [self.view addSubview:rootView];
    lineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 36, WIDTH/4, 1)];
    lineImageView.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [rootView addSubview:lineImageView];
    
    
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic=array[i];
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH/4*i, 0, WIDTH/4, 37)];
        [button setTitle:[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tabbarButton:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            [button setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1]forState:UIControlStateNormal];
        }
        
        [button setTag:1000+i];
        button.titleLabel.font=[UIFont fontWithName:@"Arial" size:15];
//        button.titleLabel.textColor=;
        [rootView addSubview:button];
    }

}
#pragma mark 搜索按钮点击方法
-(void)searchButAction
{
    SearchVoiceViewController *searchVC=[[SearchVoiceViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
-(void)webView
{
    self.meWebView= [[UIWebView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT-64-37-49)];
    self.meWebView.delegate=self;
    //self.meWebView.hidden=YES;
    self.meWebView.scrollView.delegate=self;
    if (_refreshHeaderView == nil) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0-self.meWebView.scrollView.bounds.size.height, self.meWebView.scrollView.frame.size.width, self.meWebView.scrollView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        [self.meWebView.scrollView addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];//_meWebView=webView;
    [mainView addSubview:self.meWebView];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_imgurl]];
    //NSLog(@"gourl  =  %@",_imgurl);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.meWebView loadRequest:request];
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [jdView removeFromSuperview];
    jdView=[[UIView alloc]initWithFrame:FRAME((WIDTH-70)/2, 200, 70, 70)];
    jdView.backgroundColor=[UIColor blackColor];
    jdView.alpha=0.6;
    view=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    view.center = CGPointMake(35.0f, 35.0f);
    view.color = [UIColor redColor];
    [jdView addSubview:view];
    jdView.hidden=NO;
    jdView.hidden=YES;
    [self.view addSubview:jdView];
    _reloading = YES;
    [view startAnimating];
    jdView.hidden=NO;
}
-(void)timerFireMethod:(NSTimer *)sender
{
    jdView.hidden=YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    jdView.hidden=YES;
    [view stopAnimating]; // 结束旋转
    [view setHidesWhenStopped:YES]; //当旋转结束时隐藏

    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.meWebView.scrollView];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"load page error:%@", [error description]);
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.meWebView.scrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self webView];
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
}
-(void)tabbarButton:(UIButton *)sender
{
    
    int _offSet=(int)(sender.tag-1000);
    NSDictionary *dic=array[_offSet];
    if (_offSet>2&&_offSet!=array.count-1) {
        buttID=1;
        [UIView beginAnimations: @"Animation" context:nil];
        [UIView setAnimationDuration:1];
        rootView.contentOffset=CGPointMake(WIDTH/4*1, 0);
        [UIView commitAnimations];
        
    }else if (buttID==1&&_offSet<scrollID){
        [UIView beginAnimations: @"Animation" context:nil];
        [UIView setAnimationDuration:1];
        rootView.contentOffset=CGPointMake(rootView.contentOffset.x-(WIDTH/4), 0);
        [UIView commitAnimations];
        
        if (_offSet<3) {
            buttID=0;
        }
    }
    static int currentSelectButtonIndex = 0;
    static int previousSelectButtonIndex=1000;
    currentSelectButtonIndex=(int)sender.tag;
    UIButton *previousBtn=(UIButton *)[self.view viewWithTag:previousSelectButtonIndex];
    [previousBtn setTitleColor:[UIColor colorWithRed:120/255.0f green:120/255.0f blue:120/255.0f alpha:1] forState:UIControlStateNormal];
    UIButton *currentBtn = (UIButton *)[self.view viewWithTag:currentSelectButtonIndex];;
    [currentBtn setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
    previousSelectButtonIndex=currentSelectButtonIndex;
    
    
    [self.meWebView removeFromSuperview];
    jdView.hidden=YES;
    [view stopAnimating]; // 结束旋转
    [view setHidesWhenStopped:YES]; //当旋转结束时隐藏
    [oneViewController removeFromParentViewController];
    [mainView removeFromSuperview];
    mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 101,WIDTH, SELF_VIEW_HEIGHT-151)];
    mainView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:mainView];

    oneViewController=[[HairViewController alloc]init];
    [self addChildViewController:oneViewController];
    oneViewController.channel_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"channel_id"]];
    [mainView addSubview:oneViewController.view];
    currentViewController = oneViewController;
    
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:1];
    lineImageView.frame=CGRectMake(WIDTH/4*(sender.tag-1000), 36, WIDTH/4, 1);
    [UIView commitAnimations];
   // currentViewController=oneViewController;
        scrollID=(int)(sender.tag-1000);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
