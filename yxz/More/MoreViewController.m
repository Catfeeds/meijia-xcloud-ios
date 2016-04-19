//
//  MoreViewController.m
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreView.h"
#import "MoreWebViewController.h"

@interface MoreViewController ()
<MOREDELEGATE>
{
    UIScrollView *_myscroll;
}

@end

@implementation MoreViewController
#define APP_URL @"http://itunes.apple.com/lookup?id=942877871"


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navlabel.text = @"更多";
//    self.backBtn.hidden = YES;
    
    
    _myscroll = [[UIScrollView alloc]initWithFrame:FRAME(0, 64, _WIDTH, _HEIGHT-64)];
    if (_HEIGHT == 480) {
        
        [_myscroll setContentSize:CGSizeMake(_WIDTH, 568-64)];
    }
    [self.view addSubview:_myscroll];
    
    MoreView *_moreview = [[MoreView alloc]initWithFrame:FRAME(0, 0, _WIDTH, _HEIGHT-64)];
    _moreview.delegate = self;
    [_myscroll addSubview:_moreview];
    
}

- (void)selectWhichControllerToPushWithTag:(NSInteger)tag
{
    
    if (tag == 400) {
        
//        MoreWebViewController *_controller = [[MoreWebViewController alloc]init];
//        _controller.webtag = @"100";
//        [self.navigationController pushViewController:_controller animated:YES];
        MoreWebViewController *_controller = [[MoreWebViewController alloc]init];
        _controller.webtag = @"101";
        [self.navigationController pushViewController:_controller animated:YES];
        
    }else if (tag == 401){
        
//        MoreWebViewController *_controller = [[MoreWebViewController alloc]init];
//        _controller.webtag = @"101";
//        [self.navigationController pushViewController:_controller animated:YES];

        [UMSocialWechatHandler setWXAppId:@"wx93aa45d30bf6cba3" appSecret:@"7a4ec42a0c548c6e39ce9ed25cbc6bd7" url:Handlers];
        [UMSocialQQHandler setQQWithAppId:@"1104934408" appKey:@"bRW2glhUCR6aJYIZ" url:QQHandlerss];
        [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"247547429" RedirectURL:SSOHandlers];
        [UMSocialSnsService presentSnsIconSheetView:self appKey:YMAPPKEY shareText:@"云行政，企业行政服务第一平台！极大降低企业行政管理成本，有效提升行政综合服务能力，快来试试吧！体验就送礼哦：http://51xingzheng.cn/h5-app-download.html" shareImage:[UIImage imageNamed:@"001.gif"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina,nil] delegate:self];
        
    }else if (tag ==402){
//        [UMSocialSnsService presentSnsIconSheetView:self appKey:YMAPPKEY shareText:@"云行政，企业行政服务第一平台！极大降低企业行政管理成本，有效提升行政综合服务能力，快来试试吧！体验就送礼哦：http://51xingzheng.cn/h5-app-download.html" shareImage:[UIImage imageNamed:@"001.gif"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina,nil] delegate:self];
        
        [self presentModalViewController:[UMFeedback feedbackModalViewController]
                                animated:YES];
        
        //[UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
//        ShareFriendViewController *_controller = [[ShareFriendViewController alloc]init];
//        [self.navigationController pushViewController:_controller animated:YES];
    }else if (tag == 403){
//        YijianFankuiViewController *_controller = [[YijianFankuiViewController alloc]init];
//        [self.navigationController pushViewController:_controller animated:YES];
//        [self.navigationController pushViewController:[UMFeedback feedbackViewController]
//                                             animated:YES];
//        [self presentModalViewController:[UMFeedback feedbackModalViewController]
//                                animated:YES];
        MoreWebViewController *_controller = [[MoreWebViewController alloc]init];
        _controller.webtag = @"102";
        [self.navigationController pushViewController:_controller animated:YES];
        
    }else if (tag == 404){
        

//        [self onCheckVersion:@"1.0"];
        
    }else if (tag == 405){
        [self telephoneBtn];
    }
}



/*-(void)onCheckVersion:(NSString *)currentVersion
{
    
    NSString *URL = APP_URL;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (recervedData) {
        NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:recervedData options:NSJSONReadingMutableLeaves error:nil];
        NSArray *infoArray = [dic objectForKey:@"results"];
        
        NSLog(@"dict is %@",dic);
        
        if ([infoArray count]) {
            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
            NSString *lastVersion = [releaseInfo objectForKey:@"version"];
            
            if (![lastVersion isEqualToString:currentVersion]) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"下次" otherButtonTitles:@"更新", nil];
//                [alert setTag:2121];
//                [alert show];
                
                [self showAlertViewWithTitle:@"提示" message:@"已是最新版本"];
                
            }else{
                [self showAlertViewWithTitle:@"提示" message:@"已是最新版本"];
            }
        }
        
    }
    
}*/


- (void)telephoneBtn
{
        NSString *phoneNum = @"";// 电话号码
    
        phoneNum = @"400-169-1615";
    
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    
        UIWebView *phoneCallWebView;
    
        if ( !phoneCallWebView ) {
    
            phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    
        }
    
        [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
         phoneCallWebView.userInteractionEnabled=YES;
        [self.view addSubview:phoneCallWebView];
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
