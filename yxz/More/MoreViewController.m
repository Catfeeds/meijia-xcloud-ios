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
#import "SDImageCache.h"
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
//        [self presentModalViewController:[UMFeedback feedbackModalViewController]
//                                animated:YES];
        [self presentViewController:[UMFeedback feedbackModalViewController] animated:YES completion:nil];
        
    }else if (tag == 401){
        
//        MoreWebViewController *_controller = [[MoreWebViewController alloc]init];
//        _controller.webtag = @"101";
//        [self.navigationController pushViewController:_controller animated:YES];

        [UMSocialWechatHandler setWXAppId:@"wx93aa45d30bf6cba3" appSecret:@"7a4ec42a0c548c6e39ce9ed25cbc6bd7" url:Handlers];
        [UMSocialQQHandler setQQWithAppId:@"1104934408" appKey:@"bRW2glhUCR6aJYIZ" url:QQHandlerss];
        [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"247547429" RedirectURL:SSOHandlers];
        [UMSocialSnsService presentSnsIconSheetView:self appKey:YMAPPKEY shareText:@"菠萝HR，人事行政必备神器！我们专注“人事行政”的成长与服务！快来体验吧：http://bolohr.com/web" shareImage:[UIImage imageNamed:@"001.gif"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina,nil] delegate:self];
        
    }else if (tag ==402){

        MoreWebViewController *_controller = [[MoreWebViewController alloc]init];
        _controller.webtag = @"101";
        [self.navigationController pushViewController:_controller animated:YES];
        
//        [UMSocialSnsService presentSnsIconSheetView:self appKey:YMAPPKEY shareText:@"菠萝HR，人事行政必备神器！我们专注“人事行政”的成长与服务！快来体验吧：http://bolohr.com/web" shareImage:[UIImage imageNamed:@"001.gif"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina,nil] delegate:self];
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
    }else if (tag == 406){
        NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *createPath = [NSString stringWithFormat:@"%@/PreLoadingImage", pathDocuments];
        [self folderSizeAtPath:createPath];
        NSString *string=[NSString stringWithFormat:@"缓存大小为%.2fM.确定要清理缓存么？",[self folderSizeAtPath:createPath]];
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [tsView show];
    }
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
    }
    
    return 0;
    
}
#pragma mark 计算目录大小
-(float)folderSizeAtPath:(NSString *)path{
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:path]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:path] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    
    return folderSize/(1024.0*1024.0);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *createPath = [NSString stringWithFormat:@"%@/PreLoadingImage", pathDocuments];
        [self clearCache:createPath];
    }
    
}
-(void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
    
    NSArray *file = [[[NSFileManager alloc] init] subpathsAtPath:path];
    //NSLog(@"%d",[file count]);
    NSLog(@"%@",file);

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
    
        phoneNum = @"biz@bolohr.com";
    
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@",phoneNum]];
    
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
