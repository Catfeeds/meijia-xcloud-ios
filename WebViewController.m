//
//  WebViewController.m
//  yxz
//
//  Created by 白玉林 on 15/11/13.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
{
     UIActivityIndicatorView *view;
}
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self webView];
        // Do any additional setup after loading the view.
}
-(void)webView
{
    self.meWebView= [[UIWebView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    self.meWebView.delegate=self;
    //self.meWebView.hidden=YES;
    self.meWebView.scalesPageToFit = YES;  //自适应
    self.meWebView.scrollView.delegate=self;
    if (_refreshHeaderView == nil) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0-self.meWebView.scrollView.bounds.size.height, self.meWebView.scrollView.frame.size.width, self.meWebView.scrollView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        [self.meWebView.scrollView addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];//_meWebView=webView;
    [self.view addSubview:self.meWebView];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self._weburl]];
    //NSLog(@"gourl  =  %@",_imgurl);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.meWebView loadRequest:request];

}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    view=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    view.center = CGPointMake(WIDTH/2, HEIGHT/2);
    view.color = [UIColor redColor];
    [self.view addSubview:view];
   
    _reloading = YES;
    [view startAnimating];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
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
