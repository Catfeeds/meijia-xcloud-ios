//
//  RootViewController.m
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "RootViewController.h"
//#import "FirstViewController.h"
//#import "OrderViewController.h"
//#import "MineViewController.h"
//#import "MoreViewController.h"
//#import "PayViewController.h"
//#import "ISLoginManager.h"

//#import "SMBaseViewController.h"
#import "ChatViewController.h"
//#import "AppDelegate.h"
#import "CardPageViewController.h"
//#import "FriendViewController.h"
//#import "EaseMob.h"
#import "FoundViewController.h"
#import "MyselfViewController.h"
//#import "PlusViewController.h"

//#import "DownloadManager.h"
//#pragma mark 循环按钮跳转类


//#import "OriginalViewController.h"

#import "ViewController.h"
#import "ClerkViewController.h"


//#import "PageTableViewCell.h"
#import "LeaveListViewController.h"
#import "PlusCollectionViewCell.h"
#import "AppCenterViewController.h"

#import "BookingViewController.h"
#import "MeetingViewController.h"
//#import "UpLoadViewController.h"
#import "AttendanceViewController.h"
#import "ApplyForLeaveViewController.h"
#import "WaterListViewController.h"
#import "WasteRecoveryViewController.h"
#import "DetailsListViewController.h"
#import "AssetsAdministrationViewController.h"

#import "HomePageTableViewController.h"
#import "FatherViewController.h"
#import "MyLogInViewController.h"
#import "BlankViewController.h"

#import "ExprViewController.h"


#import "FriendsHomeViewController.h"
#import "Order_ListViewController.h"
#import "ApplyFriendsListViewController.h"
#import "Order_DetailsViewController.h"

#import "EnterpriseViewController.h"
#import "LeaveDetailsViewController.h"

//#import "DisplayStarView.h"
//#import "RatingBar.h"
@interface RootViewController ()<UIAlertViewDelegate, IChatManagerDelegate,UIAlertViewDelegate/*,RatingBarDelegate*/>
{
    
    CLLocationManager *_locationManager;
    
    UIView *mainView;
    UIViewController *currentViewController;
    UIImageView *barView;
    //    UIButton *button;
    ISLoginManager *_manager;
    UIImageView *foundImage;
    UIImageView *meImage;
    UIImageView *pageImage;
    UIImageView *friendImage;
    
    UILabel *pageLabel;
    UILabel *foundLabel;
    UILabel *friendLabel;
    UILabel *meLabel;
    UILabel *releaseLabel;
    
    UIImageView *bottomView;
//    BookingViewController *vc;
//    MeetingViewController *vcs;
    
    int indexesID;
    
    UIView *spotView;
    UIActivityIndicatorView *meView;
    UICollectionViewFlowLayout *flowView;
    NSMutableArray *plusArray;
    UILabel *alertLabel;
    NSDictionary *coreDic;
    
    FatherViewController *fatherVc;
    NSString *createPath;
    NSString *msNameString;
    NSURL *url;
    NSString *stringUrl;
    UIView *remind_spotView;
}
@end
#pragma mark - View lifecycle
HomePageTableViewController *homePageVIewController;
CardPageViewController *pageViewVC;
ViewController * viewController;
FoundViewController * firstViewController;
BlankViewController *secondViewController;
//FriendViewController * friendViewController;
MyselfViewController *thirdViewController;
//MyLogInViewController *myLogInViewController;
@implementation RootViewController
@synthesize tab;

-(void)viewWillAppear:(BOOL)animated
{
//    NSArray *narry=[[UIApplication sharedApplication] scheduledLocalNotifications];
//    NSUInteger acount=[narry count];
//    if (acount>0)
//    {// 遍历找到对应nfkey和notificationtag的通知
//            for (int i=0; i<acount; i++)
//            {
//                    UILocalNotification *myUILocalNotification = [narry objectAtIndex:i];
//                    NSDictionary *userInfo = myUILocalNotification.userInfo;
//                    NSNumber *obj = [userInfo objectForKey:@"nfkey"];
//                    int mytag=[obj intValue];
////                    if (mytag==notificationtag)
////                    {
//                        // 删除本地通知
//                    [[UIApplication sharedApplication] cancelLocalNotification:myUILocalNotification];
////                            break;
////                        }
//                }
//        }

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBarHidden=YES;
    if (indexesID==1) {
        [self bottomButton];
    }
    @try{
        
    }
    @catch(NSException *exception) {
        NSLog(@"异常错误是:%@", exception);
    }
    @finally {
        
    }
    if (fatherVc.loginYesOrNo) {
        [self getUserInfo];
    }
    [self msLayout];
}
-(void)msLayout
{
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict=@{@"user_id":@"366"};
    [_download requestWithUrl:USER_INFO dict:_dict view:self.view delegate:self finishedSEL:@selector(MsFinish:) isPost:NO failedSEL:@selector(MsFail:)];
}
#pragma mark 获取秘书信息接口成功返回
-(void)MsFinish:(id)source
{
    NSLog(@"获取秘书信息接口成功返回%@",source);
    NSDictionary *nameDic=[source objectForKey:@"data"];
    msNameString=[NSString stringWithFormat:@"%@",[nameDic objectForKey:@"name"]];
}
#pragma mark 获取秘书信息接口失败返回
-(void)MsFail:(id)source
{
    NSLog(@"获取秘书信息接口失败返回%@",source);
}
-(void)plusLAyout
{
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dic = @{@"app_type":@"xcloud",@"user_id":_manager.telephone};
    [_download requestWithUrl:USER_PLUE_LIST dict:_dic view:self.view delegate:self finishedSEL:@selector(PlusSuccess:) isPost:NO failedSEL:@selector(PlusFailure:)];
}
-(void)PlusSuccess:(id)dataSource
{
    NSLog(@"导航接口返回数据：%@",dataSource);
    [plusArray removeAllObjects];
    NSArray  *array=[dataSource objectForKey:@"data"];
    [plusArray addObjectsFromArray:array];
    [plusArray addObject:coreDic];
    [_collectionView reloadData];
    
}
-(void)PlusFailure:(id)dataSource
{
    NSLog(@"导航接口返回失败数据：%@",dataSource);
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex save2File:(BOOL) save2File save2Album:(BOOL) save2Album{
    
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
-(void)helpLayout:(NSNotification *)dataSource
{
    NSDictionary *dic=dataSource.object;
    WebPageViewController *webVC=[[WebPageViewController alloc]init];
    webVC.barIDS=100;
    webVC.webURL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"webUrl"]];
    webVC.vcIDs=1000;
    [[self getCurrentVC] presentViewController:webVC animated:YES completion:nil];
}
-(void)pushJumpLayout:(NSNotification *)dataSource
{
    NSDictionary *dic=dataSource.object;
    DetailsListViewController *vc=[[DetailsListViewController alloc]init];
    vc.card_ID=[[dic objectForKey:@"ci"]intValue];
    vc.vcIDS=1000;
    [[self getCurrentVC] presentViewController:vc animated:YES completion:nil];
}
-(void)pushJumpsLayout:(NSNotification *)dataSource
{
    NSDictionary *dic=dataSource.object;
    DetailsListViewController *vc=[[DetailsListViewController alloc]init];
    vc.card_ID=[[dic objectForKey:@"ci"]intValue];
    vc.vcIDS=1000;
    [[self getCurrentVC] presentViewController:vc animated:YES completion:nil];
}
-(void)imgTap:(NSNotification *)dataSource
{
    WebPageViewController *webPageVC=[[WebPageViewController alloc]init];
    webPageVC.barIDS=100;
    webPageVC.webURL=[NSString stringWithFormat:@"https://www.baidu.com"];
    [self.navigationController pushViewController:webPageVC animated:YES];
}
-(void)todoSomething
{
    NSDictionary *helpDic;
    if([stringUrl rangeOfString:@"http://www.51xingzheng.cn/d/open.html?"].location ==NSNotFound)
    {
        WebPageViewController *webVc=[[WebPageViewController alloc]init];
        webVc.barIDS=100;
        webVc.webURL=[NSString stringWithFormat:@"%@",url];
        [self.navigationController pushViewController:webVc animated:YES];
        return;
    }
    NSArray *array=[stringUrl componentsSeparatedByString:@"?"];
    NSString *urlStr=[NSString stringWithFormat:@"%@",array[1]];
    NSLog(@"%@",urlStr);
    NSArray *urlArray = [urlStr componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:4];
    for (int i=0; i<urlArray.count; i++) {
        NSArray *dicArray = [urlArray[i] componentsSeparatedByString:@"="];
        [tempDic setObject:dicArray[1] forKey:dicArray[0]];
    }
    
    if ([[tempDic objectForKey:@"category"] isEqualToString:@"app"]) {
        if ([[tempDic objectForKey:@"action"] isEqualToString:@"alarm"]) {
            
            helpDic=@{@"action":@"alarm"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
            CardPageViewController *pageViewVC=[[CardPageViewController alloc]init];
            pageViewVC.tyPeStr=urlStr;
            pageViewVC.navlabelName=@"事务提醒";
            //                UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
            //                pageViewVC=[storys instantiateInitialViewController];
            pageViewVC.vcID=1003;
            [self.navigationController pushViewController:pageViewVC animated:YES];
            
        }else if ([[tempDic objectForKey:@"action"] isEqualToString:@"meeting"]){
            
            helpDic=@{@"action":@"meeting"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
            CardPageViewController *pageViewVC=[[CardPageViewController alloc]init];
            pageViewVC.tyPeStr=urlStr;
            pageViewVC.navlabelName=@"会议安排";
            //                UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
            //                pageViewVC=[storys instantiateInitialViewController];
            pageViewVC.vcID=1001;
            [self.navigationController pushViewController:pageViewVC animated:YES];
            
            
        }else if ([[tempDic objectForKey:@"action"] isEqualToString:@"notice"]){
            
            helpDic=@{@"action":@"notice"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
            CardPageViewController *pageViewVC=[[CardPageViewController alloc]init];
            pageViewVC.tyPeStr=urlStr;
            pageViewVC.navlabelName=@"通知公告";
            //                UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
            //                pageViewVC=[storys instantiateInitialViewController];
            pageViewVC.vcID=1002;
            [self.navigationController pushViewController:pageViewVC animated:YES];
            
            
        }else if ([[tempDic objectForKey:@"action"] isEqualToString:@"interview"]){
            
            helpDic=@{@"action":@"interview"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
            CardPageViewController *pageViewVC=[[CardPageViewController alloc]init];
            pageViewVC.tyPeStr=urlStr;
            pageViewVC.navlabelName=@"面试邀约";
            //                UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
            //                pageViewVC=[storys instantiateInitialViewController];
            pageViewVC.vcID=1004;
            [self.navigationController pushViewController:pageViewVC animated:YES];
            
            
        }else if ([[tempDic objectForKey:@"action"] isEqualToString:@"trip"]){
            
            helpDic=@{@"action":@"trip"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
            CardPageViewController *pageViewVC=[[CardPageViewController alloc]init];
            pageViewVC.tyPeStr=urlStr;
            pageViewVC.navlabelName=@"差旅规划";
            //                UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
            //                pageViewVC=[storys instantiateInitialViewController];
            pageViewVC.vcID=1005;
            [self.navigationController pushViewController:pageViewVC animated:YES];
            
            
        }else if ([[tempDic objectForKey:@"action"] isEqualToString:@"feed_add"]){
            
            helpDic=@{@"action":@"punch_sign"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
            CardPageViewController *pageViewVC=[[CardPageViewController alloc]init];
            pageViewVC.tyPeStr=urlStr;
            pageViewVC.navlabelName=@"发布动态";
            //                UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
            //                pageViewVC=[storys instantiateInitialViewController];
            pageViewVC.vcID=1006;
            [self.navigationController pushViewController:pageViewVC animated:YES];
            
            
        }else if ([[tempDic objectForKey:@"action"] isEqualToString:@"leave_pass"]){
            helpDic=@{@"action":@"leave_pass"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
//            LeaveListViewController *leaveListVC=[[LeaveListViewController alloc]init];
//            leaveListVC.tyPeStr=urlStr;
//            [self.navigationController pushViewController:leaveListVC animated:YES];
            LeaveDetailsViewController *leaveDetailsVC=[[LeaveDetailsViewController alloc]init];
            leaveDetailsVC.leave_id=[NSString stringWithFormat:@"%@",[tempDic objectForKey:@"params"]];
            leaveDetailsVC.leaveVC_id=101;
            [self.navigationController pushViewController:leaveDetailsVC animated:YES];
            
            
        }else if ([[tempDic objectForKey:@"action"] isEqualToString:@"feed_add"]){
            
            helpDic=@{@"action":@"feed_add"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
            CardPageViewController *pageViewVC=[[CardPageViewController alloc]init];
            pageViewVC.tyPeStr=urlStr;
            pageViewVC.vcID=1008;
            [self.navigationController pushViewController:pageViewVC animated:YES];
            
            
        }else if([[tempDic objectForKey:@"action"] isEqualToString:@"water"]){
            
            WaterListViewController *plantsVc=[[WaterListViewController alloc]init];
            plantsVc.tyPeStr=urlStr;
            [self.navigationController pushViewController:plantsVc animated:YES];
            
        }else if([[tempDic objectForKey:@"action"] isEqualToString:@"recycle"]){
            WasteRecoveryViewController *plantsVc=[[WasteRecoveryViewController alloc]init];
            plantsVc.wasteID=100;
            plantsVc.tyPeStr=urlStr;
            [self.navigationController pushViewController:plantsVc animated:YES];
            
        }else if([[tempDic objectForKey:@"action"] isEqualToString:@"clean"]){
            WasteRecoveryViewController *plantsVc=[[WasteRecoveryViewController alloc]init];
            plantsVc.tyPeStr=urlStr;
            plantsVc.wasteID=101;
            [self.navigationController pushViewController:plantsVc animated:YES];
            
        }else if([[tempDic objectForKey:@"action"] isEqualToString:@"teamwork"]){
            
            WasteRecoveryViewController *plantsVc=[[WasteRecoveryViewController alloc]init];
            plantsVc.tyPeStr=urlStr;
            plantsVc.wasteID=102;
            [self.navigationController pushViewController:plantsVc animated:YES];
            
        }else if([[tempDic objectForKey:@"action"] isEqualToString:@"express"]){
            
            WasteRecoveryViewController *plantsVc=[[WasteRecoveryViewController alloc]init];
            plantsVc.tyPeStr=urlStr;
            plantsVc.wasteID=103;
            [self.navigationController pushViewController:plantsVc animated:YES];
            
        }else if ([[tempDic objectForKey:@"action"] isEqualToString:@"add_friend"]){
            FriendsHomeViewController *vc = [FriendsHomeViewController new];
            vc.friendsID=100;
            vc.view_user_id=[NSString stringWithFormat:@"%@",[tempDic objectForKey:@"params"]];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([[tempDic objectForKey:@"action"] isEqualToString:@"friend_req"]){
            ApplyFriendsListViewController *applyVC=[[ApplyFriendsListViewController alloc]init];
            applyVC.vcID=100;
            applyVC.listID=1001;
            [self.navigationController pushViewController:applyVC animated:YES];
            
        }else if ([[tempDic objectForKey:@"action"] isEqualToString:@"company_pass"]){
            ApplyFriendsListViewController *applyVC=[[ApplyFriendsListViewController alloc]init];
            applyVC.vcID=100;
            applyVC.listID=1002;
            [self.navigationController pushViewController:applyVC animated:YES];
            
        }else if ([[tempDic objectForKey:@"action"] isEqualToString:@"p_user_list"]){
            ClerkViewController *clerkVC=[[ClerkViewController alloc]init];
            clerkVC.pushIDS=100;
            clerkVC.service_type_id=[NSString stringWithFormat:@"%@",[tempDic objectForKey:@"params"]];
            [self.navigationController pushViewController:clerkVC animated:YES];
            
        }else if ([[tempDic objectForKey:@"action"] isEqualToString:@"order_detail"]){
            Order_DetailsViewController *vc=[[Order_DetailsViewController alloc]init];
            vc.order_ID=[NSString stringWithFormat:@"%@",[tempDic objectForKey:@"params"]];
            vc.details_ID=1;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([[tempDic objectForKey:@"action"] isEqualToString:@"order"]){
            Order_ListViewController *orderVc=[[Order_ListViewController alloc]init];
            [self.navigationController pushViewController:orderVc animated:YES];
        }
        
        
    }else{
        WebPageViewController *webVc=[[WebPageViewController alloc]init];
        webVc.barIDS=100;
        webVc.webURL=[NSString stringWithFormat:@"%@",url];
        [self.navigationController pushViewController:webVc animated:YES];
    }

}

-(void)urlAction:(NSNotification *)sender
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething) object:nil];
    [self performSelector:@selector(todoSomething) withObject:nil afterDelay:1.0f];

    NSLog(@"我去  我去 我去 ！");
   
    url=sender.object;
    stringUrl=[NSString stringWithFormat:@"%@",url];
        //    }
    
}
- (void)viewDidLoad {
    
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    [_locationManager startUpdatingLocation];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remind_spot) name:@"REMIND_SPOT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(urlAction:) name:@"URLOPEN" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(imgTap:) name:@"IMGTAPP" object:nil];
    fatherVc=[[FatherViewController alloc]init];
    NSDictionary *helpDic;
    if (fatherVc.loginYesOrNo) {
        [self remind_spot];
    }
    plusArray=[[NSMutableArray alloc]init];
    self.view.backgroundColor=[UIColor whiteColor];
    coreDic=@{@"name":@"应用中心",@"logo":@"http://img.51xingzheng.cn/437396cc0b49b04dc89a0552f7e90cae?p=0",@"action":@"asdsad",@"open_type":@"app"};
    helpDic=@{@"action":@"index"};
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(helpLayout:) name:@"WEBURL" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushJumpLayout:) name:@"PushJump" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushJumpsLayout:) name:@"PushJumps" object:nil];
    [super viewDidLoad];
    meView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    meView.center = CGPointMake(WIDTH/2, HEIGHT/2);
    meView.color = [UIColor redColor];
    [self.view addSubview:meView];
    [meView startAnimating];
    
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
    [self didUnreadMessagesCountChanged];
#pragma warning 把self注册为SDK的delegate
    [self registerNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
    indexesID=0;
//    self.backBtn.hidden=YES;
    
    
    
    self.navigationController.navigationBarHidden=YES;
    // 状态栏(statusbar)
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    NSLog(@"status width - %f", rectStatus.size.width); // 宽度
    NSLog(@"status height - %f", rectStatus.size.height);   // 高度
    
    // 导航栏（navigationbar）
    CGRect rectNav = self.navigationController.navigationBar.frame;
    NSLog(@"nav width - %f", rectNav.size.width); // 宽度
    NSLog(@"nav height - %f", rectNav.size.height);   // 高度
    self.navigationController.navigationBarHidden=YES;
    
    //第一个按钮的图片和标签
    pageImage=[[UIImageView alloc]init];
    pageLabel=[[UILabel alloc]init];
    //第二个按钮的图片和标签
    foundImage=[[UIImageView alloc]init];
    foundLabel=[[UILabel alloc]init];
    //第四个按钮的图片和标签
    friendImage=[[UIImageView alloc]init];
    friendLabel=[[UILabel alloc]init];
    //第五个按钮的图片和标签
    meImage=[[UIImageView alloc]init];
    meLabel=[[UILabel alloc]init];
    
    _manager = [ISLoginManager shareManager];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LoginReturn:) name:@"LOGIN_SUCCESS" object:nil];
    
    mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SELF_VIEW_WIDTH, HEIGHT-49)];
    [self.view addSubview:mainView];
    /**
    对于那些当前暂时不需要显示的subview，
    只通过addChildViewController把subViewController加进去；
    需要显示时再调用transitionFromViewController方法。
    将其添加进入底层的ViewController中。
    **/
    
    
    
    
    [self setupUntreatedApplyCount];
    [self makeTabbarView];
    [self bottomViewLayout];
    
    [self setupUnreadMessageCount];
    
    UIStoryboard *story  = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    viewController=[story instantiateViewControllerWithIdentifier:@"ViewController"];
    [self addChildViewController:viewController];
    
    firstViewController = [[FoundViewController alloc]init];
    firstViewController.backBtn.hidden=YES;
    [self addChildViewController:firstViewController];
    
    secondViewController = [[BlankViewController alloc]init];
    [self addChildViewController:secondViewController];
    
    //    friendViewController=[[FriendViewController alloc]init];
    ////    friendViewController.backBtn.hidden=YES;
    //    [self addChildViewController:friendViewController];
    
    thirdViewController = [[MyselfViewController alloc]init];
    [self addChildViewController:thirdViewController];
    
    homePageVIewController=[[HomePageTableViewController alloc]init];
    [self addChildViewController:homePageVIewController];
    
    //    myLogInViewController = [[MyLogInViewController alloc]init];
    //    [self addChildViewController:myLogInViewController];
    
//    if (_is_new_userID==1) {
//        [mainView addSubview:secondViewController.view];
//        currentViewController = secondViewController;
//        [UIView beginAnimations:@"Animation" context:nil];
//        [UIView setAnimationDuration:1];
//        tab.hidden=YES;
//        [UIView commitAnimations];
//        bottomView.hidden=NO;
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//        [self plusLAyout];
//    }else{
        [mainView addSubview:homePageVIewController.view];
        currentViewController = homePageVIewController;
//    }
    if (fatherVc.loginYesOrNo==YES) {
        _manager = [ISLoginManager shareManager];
        NSLog(@"有值么%@",_manager.telephone);
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *_dict=@{@"user_id":_manager.telephone};
        [_download requestWithUrl:USER_INFO dict:_dict view:self.view delegate:self finishedSEL:@selector(QJDowLoadFinish:) isPost:NO failedSEL:@selector(QJDownFail:)];

    }

//    DisplayStarView *sv = [[DisplayStarView alloc]initWithFrame:CGRectMake(90, 200, 200, 40)];
//    [self.view addSubview:sv];
//    sv.showStar = 4.2*20;
//    
//    RatingBar *ratingBar = [[RatingBar alloc] init];
//    ratingBar.frame = CGRectMake(60, 240, 200, 50);
//    
//    [self.view addSubview:ratingBar];
//    ratingBar.isIndicator = NO;//指示器，就不能滑动了，只显示评分结果
//    [ratingBar setImageDeselected:@"星星 (1)" halfSelected:nil fullSelected:@"星星" andDelegate:self];
//    [self plusLAyout];
    
    
    
    
}
-(void)remind_spot
{
    if (fatherVc.loginYesOrNo==YES) {
        NSDate *  senddate=[NSDate date];
        
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        _manager = [ISLoginManager shareManager];
        NSLog(@"有值么%@",_manager.telephone);
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *_dict=@{@"user_id":_manager.telephone,@"page":@"1",@"service_date":locationString};
        [_download requestWithUrl:REMIND_SPOT dict:_dict view:self.view delegate:self finishedSEL:@selector(RemindFinish:) isPost:NO failedSEL:@selector(RemindFail:)];
        
    }
}
#pragma mark日程红点成功返回
-(void)RemindFinish:(id)sourData
{
    NSLog(@"日程红点成功返回+++%@",sourData);
    NSArray *sourDataArray=[sourData objectForKey:@"data"];
    if (sourDataArray.count>1) {
        remind_spotView.hidden=NO;
    }else{
        remind_spotView.hidden=YES;
    }
}
#pragma mark日程红点失败返回
-(void)RemindFail:(id)sourData
{
    NSLog(@"日程红点失败返回+++%@",sourData);
}
#pragma mark用户信息详情获取成功方法
-(void)QJDowLoadFinish:(id)sender
{
    NSLog(@"数据详情%@",sender);
    NSDictionary *dic=[sender objectForKey:@"data"];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.globalDic=@{@"user_id":[dic objectForKey:@"id"],@"sec_id":[dic objectForKey:@"sec_id"],@"is_senior":[dic objectForKey:@"is_senior"],@"senior_range":[dic objectForKey:@"senior_range"],@"mobile":[dic objectForKey:@"mobile"],@"user_type":[dic objectForKey:@"user_type"],@"name":[dic objectForKey:@"name"],@"has_company":[dic objectForKey:@"has_company"],@"head_img":[dic objectForKey:@"head_img"],@"company_id":[dic objectForKey:@"company_id"],@"company_name":[dic objectForKey:@"company_name"]};
    NSLog(@"看看是什么啊%@",delegate.globalDic);
    
   
    
}
#pragma mark用户信息详情获取失败方法
-(void)QJDownFail:(id)sender
{
    
}
#pragma mark - private
// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
}
// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (unreadCount > 0) {
        spotView.hidden=NO;
    }else{
        spotView.hidden=YES;
    }
   
    NSLog(@"没有读过的消息数%ld",(long)unreadCount);
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    //    [[EMSDKFull sharedInstance].callManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    //    [[EMSDKFull sharedInstance].callManager removeDelegate:self];
}

#pragma mark未读消息书
- (void)setupUntreatedApplyCount
{
    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
    if (unreadCount > 0) {
        spotView.hidden=NO;
    }else{
        spotView.hidden=YES;
    }

}

-(void)viewLayout:(NSTimer *)theTimer
{
    alertLabel.hidden=YES;
}

-(void)bottomViewLayout
{
    
    bottomView=[[UIImageView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
//    bottomView.image=[UIImage imageNamed:@"95%"];
    bottomView.backgroundColor=[UIColor whiteColor];
    bottomView.userInteractionEnabled=YES;
    bottomView.hidden=YES;
    [self.view addSubview:bottomView];
    
    UIButton *button=[[UIButton alloc]initWithFrame:FRAME((WIDTH-55)/2, HEIGHT-66.5, 55, 55)];
    [button setImage:[UIImage imageNamed:@"QX"] forState:UIControlStateNormal];
    button.layer.cornerRadius=button.frame.size.width/2;
    [button addTarget:self action:@selector(bottomButton) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:button];
    
    UIButton *secretaryButton=[[UIButton alloc]initWithFrame:FRAME((WIDTH-144/2)/2, 40, 144/2, 144/2)];
    [secretaryButton setImage:[UIImage imageNamed:@"MS"] forState:UIControlStateNormal];
    secretaryButton.tag=1007;
    [secretaryButton addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
    secretaryButton.layer.cornerRadius=secretaryButton.frame.size.width/2;
    [bottomView addSubview:secretaryButton];
    
    UILabel *secrearyLabel=[[UILabel alloc]init];
    secrearyLabel.text=@"直接找秘书";
    secrearyLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    secrearyLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [secrearyLabel setNumberOfLines:0];
    [secrearyLabel sizeToFit];
    secrearyLabel.frame=FRAME((WIDTH-secrearyLabel.frame.size.width)/2, secretaryButton.frame.origin.y+secretaryButton.frame.size.height+24/2, secrearyLabel.frame.size.width, 15);
    [bottomView addSubview:secrearyLabel];
    
    flowView=[[UICollectionViewFlowLayout alloc]init];
    [flowView setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowView.headerReferenceSize=CGSizeMake(WIDTH, 80);
    
    //    [_collectionView removeFromSuperview];
    _collectionView=[[UICollectionView alloc]initWithFrame:FRAME(0, secrearyLabel.frame.origin.y+45, WIDTH, HEIGHT-secrearyLabel.frame.origin.y-112)collectionViewLayout:flowView];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    
    _collectionView.backgroundColor=[UIColor whiteColor];
    [bottomView addSubview:_collectionView];
    [_collectionView registerClass:[PlusCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
}
- (void)makeTabbarView
{
    [self tabBarAction];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddFication:) name:@"RETURN" object:nil];
}

-(void)tabBarAction
{
    [tab removeFromSuperview];
    NSArray *barArr = @[@"首页",@"发现",@"工作",@"日程",@"我的"];
    NSArray *imagesArray =@[@"common_icon_chum@2x",@"common_icon_find@2x",@"icon_plus_add",@"common_icon_home@2x",@"common_icon_mine@2x"];
    float _btnwidth = self.view.frame.size.width/5;
    tab=[[UIImageView alloc]initWithFrame:CGRectMake(0, SELF_VIEW_HEIGHT-49, SELF_VIEW_WIDTH, 49)];
    tab.image=[UIImage imageNamed:@"bg_menu_bottom副本"];
    tab.userInteractionEnabled=YES;
//    tab.backgroundColor=[UIColor redColor];
    [self.view addSubview:tab];
    for (int i=0; i<barArr.count; i++) {
        if (i!=2) {
            UIButton *tabBarBut=[UIButton buttonWithType:UIButtonTypeCustom];
            [tabBarBut setAdjustsImageWhenHighlighted:NO];
            tabBarBut.frame=CGRectMake(_btnwidth*i, 0, _btnwidth, 49);
            [tabBarBut addTarget:self action:@selector(SelectBarbtnWithtag:) forControlEvents:UIControlEventTouchUpInside];
            [tabBarBut setTag:(1000+i)];
            [tab addSubview:tabBarBut];
            if (i==0) {
                pageImage.frame=CGRectMake((_btnwidth-23)/2, 7, 23, 23);
                pageImage.image=[UIImage imageNamed:@"common_icon_chum_c@2x"];
                [tabBarBut addSubview:pageImage];
                pageLabel.frame=CGRectMake((_btnwidth-23)/2, 36, 23, 10);
                pageLabel.text=[barArr objectAtIndex:i];
                pageLabel.textAlignment=NSTextAlignmentCenter;
                pageLabel.font=[UIFont fontWithName:@"Heiti SC" size:10];
                pageLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                [tabBarBut addSubview:pageLabel];
                
            }else if(i==1)
            {
                foundImage.frame=CGRectMake((_btnwidth-23)/2,7, 23, 23);
                foundImage.image=[UIImage imageNamed:imagesArray[i]/*@"tab-home-pressdown"*/];
                [tabBarBut addSubview:foundImage];
                
                foundLabel.frame=CGRectMake((_btnwidth-23)/2, 36, 23, 10);
                foundLabel.text=[barArr objectAtIndex:i];
                foundLabel.textAlignment=NSTextAlignmentCenter;
                foundLabel.font=[UIFont fontWithName:@"Heiti SC" size:10];
                [tabBarBut addSubview:foundLabel];
            }else if (i==3){
                [tabBarBut setAdjustsImageWhenHighlighted:NO];
                friendImage.frame=CGRectMake((_btnwidth-23)/2,7, 23, 23);
                friendImage.image=[UIImage imageNamed:imagesArray[i]];
                [tabBarBut addSubview:friendImage];
                friendLabel.frame=CGRectMake((_btnwidth-23)/2, 36, 23, 10);
                friendLabel.text=[barArr objectAtIndex:i];
                friendLabel.textAlignment=NSTextAlignmentCenter;
                friendLabel.font=[UIFont fontWithName:@"Heiti SC" size:10];
                [tabBarBut addSubview:friendLabel];
                
                remind_spotView=[[UIView alloc]initWithFrame:FRAME((_btnwidth-23)/2+19, 2, 10, 10)];
                remind_spotView.layer.masksToBounds=YES;
                remind_spotView.layer.cornerRadius=remind_spotView.frame.size.width/2;
                remind_spotView.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                remind_spotView.hidden=YES;
                [tabBarBut addSubview:remind_spotView];
                
                spotView=[[UIView alloc]initWithFrame:FRAME((_btnwidth-23)/2+19, 2, 10, 10)];
                spotView.layer.masksToBounds=YES;
                spotView.layer.cornerRadius=spotView.frame.size.width/2;
                spotView.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                spotView.hidden=YES;
                [tabBarBut addSubview:spotView];
            }else if (i==4){
                meImage.frame=CGRectMake((_btnwidth-23)/2,7, 23, 23);
                meImage.image=[UIImage imageNamed:imagesArray[i]];
                [tabBarBut addSubview:meImage];
                meLabel.frame=CGRectMake((_btnwidth-23)/2, 36, 23, 10);
                meLabel.text=[barArr objectAtIndex:i];
                meLabel.font=[UIFont fontWithName:@"Heiti SC" size:10];
                meLabel.textAlignment=NSTextAlignmentCenter;
                [tabBarBut addSubview:meLabel];
            }
        }else
        {
            UIButton *tabBarBut=[UIButton buttonWithType:UIButtonTypeCustom];
            [tabBarBut setAdjustsImageWhenHighlighted:NO];
            tabBarBut.frame=CGRectMake(_btnwidth*i+_btnwidth/2-55/2, -17.5, 55, 55);
//            tabBarBut.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
            
            [tabBarBut setImage:[UIImage imageNamed:imagesArray[i]] forState:UIControlStateNormal];
            [tabBarBut addTarget:self action:@selector(SelectBarbtnWithtag:) forControlEvents:UIControlEventTouchUpInside];
            [tabBarBut setTag:(1000+i)];
            [tab addSubview:tabBarBut];
//            UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME(0, 0, 50, 50)];
//            imageView.image=[UIImage imageNamed:@"icon_plus_add副本"];
//            [tabBarBut addSubview:imageView];
            releaseLabel=[[UILabel alloc]init];
            releaseLabel.text=[barArr objectAtIndex:i];
            releaseLabel.font=[UIFont fontWithName:@"Heiti SC" size:10];
            releaseLabel.textAlignment=NSTextAlignmentCenter;
            [releaseLabel setNumberOfLines:1];
            [releaseLabel sizeToFit];
            releaseLabel.frame=FRAME((WIDTH-releaseLabel.frame.size.width)/2, 36, releaseLabel.frame.size.width, 10);
            [tab addSubview:releaseLabel];
        }
        
    }

}
- (void)AddFication:(NSNotification *)obj
{
    [self makeTabbarView];
    
}
- (void)SelectBarbtnWithtag:(UIButton *)sender
{
    NSDictionary *helpDic;
    
    NSLog(@"按钮的tag值%ld",(long)sender.tag);
    if ((currentViewController==homePageVIewController&&[sender tag]==1000)||(currentViewController==firstViewController&&[sender tag]==1001)||(currentViewController==secondViewController&&[sender tag]==1002) ||(currentViewController==viewController&&[sender tag]==1003)||(currentViewController==thirdViewController&&[sender tag]==1004) ) {
        return;
    }
    UIViewController *oldViewController=currentViewController;
    switch (sender.tag) {
        case 1000:
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            _tabBarID=0;
            helpDic=@{@"action":@"index"};
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
            indexesID=0;
            [self transitionFromViewController:currentViewController toViewController:homePageVIewController duration:0.5 options:0 animations:^{
            }  completion:^(BOOL finished) {
                if(finished){
                    currentViewController=homePageVIewController;
                    pageImage.image=[UIImage imageNamed:@"common_icon_chum_c@2x"];
                    pageLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                    foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
                    foundLabel.textColor=[UIColor blackColor];
                    
                    friendImage.image=[UIImage imageNamed:@"common_icon_home@2x"];
                    friendLabel.textColor=[UIColor blackColor];
                    
                    meImage.image=[UIImage imageNamed:@"common_icon_mine@2x"];
                    meLabel.textColor=[UIColor blackColor];
                }else{
                    currentViewController=homePageVIewController;
                    pageImage.image=[UIImage imageNamed:@"common_icon_chum_c@2x"];
                    pageLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                    foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
                    foundLabel.textColor=[UIColor blackColor];
                    
                    friendImage.image=[UIImage imageNamed:@"common_icon_home@2x"];
                    friendLabel.textColor=[UIColor blackColor];
                    
                    meImage.image=[UIImage imageNamed:@"common_icon_mine@2x"];
                    meLabel.textColor=[UIColor blackColor];
                }
                
            }];
        }
             break;
        case 1001:
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            _tabBarID=1;
            helpDic=@{@"action":@"discover"};
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
            
            int b=0;
            indexesID=0;
            NSLog( @"走不走？%d",b++);
            [self transitionFromViewController:currentViewController toViewController:firstViewController duration:0.5 options:0 animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    
                    currentViewController=firstViewController;
                    firstViewController.vcID=0;
                    pageImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
                    pageLabel.textColor=[UIColor blackColor];
                    
                    foundImage.image=[UIImage imageNamed:@"common_icon_find_c@2x"];
                    foundLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                    
                    friendImage.image=[UIImage imageNamed:@"common_icon_home@2x"];
                    friendLabel.textColor=[UIColor blackColor];
                    
                    meImage.image=[UIImage imageNamed:@"common_icon_mine@2x"];
                    meLabel.textColor=[UIColor blackColor];
                }else{
                    currentViewController=oldViewController;
                    
                    pageImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
                    pageLabel.textColor=[UIColor blackColor];
                    
                    foundImage.image=[UIImage imageNamed:@"common_icon_find_c@2x"];
                    foundLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                    
                    friendImage.image=[UIImage imageNamed:@"common_icon_home@2x"];
                    friendLabel.textColor=[UIColor blackColor];
                    
                    meImage.image=[UIImage imageNamed:@"common_icon_mine@2x"];
                    meLabel.textColor=[UIColor blackColor];
                }
            }];
            
            
        }
            break;
            
            
        case 1002:
        {
            if(fatherVc.loginYesOrNo==YES){
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                helpDic=@{@"action":@"work"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
                indexesID=1;
                //            self.backBtn.hidden=YES;
                [self transitionFromViewController:currentViewController toViewController:secondViewController duration:0.5 options:0 animations:^{
                    
                }  completion:^(BOOL finished) {
                    if (finished) {
                        currentViewController=secondViewController;
                        [UIView beginAnimations:@"Animation" context:nil];
                        [UIView setAnimationDuration:1];
                        tab.hidden=YES;
                        [UIView commitAnimations];
                        bottomView.hidden=NO;
                        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                        [self plusLAyout];
                    }else{
                        currentViewController=oldViewController;
                        
                    }
                }];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MyLogInViewController *loginViewController = [[MyLogInViewController alloc] init];
                    loginViewController.vCYMID=100;
                    UMComNavigationController *navigationController = [[UMComNavigationController alloc] initWithRootViewController:loginViewController];
                    [self presentViewController:navigationController animated:YES completion:^{
                    }];
                });
            }
            
        }
            break;
        case 1003:
        {
            
            if(fatherVc.loginYesOrNo==YES){
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
                _tabBarID=3;
                helpDic=@{@"action":@"sns"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
                indexesID=0;
                [self transitionFromViewController:currentViewController toViewController:viewController duration:0.5 options:0 animations:^{
                }  completion:^(BOOL finished) {
                    if(finished){
                        currentViewController=viewController;
                        
                        pageImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
                        pageLabel.textColor=[UIColor blackColor];
                        
                        foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
                        foundLabel.textColor=[UIColor blackColor];
                        
                        friendImage.image=[UIImage imageNamed:@"common_icon_home_c@2x"];
                        friendLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                        
                        meImage.image=[UIImage imageNamed:@"common_icon_mine@2x"];
                        meLabel.textColor=[UIColor blackColor];
                    }else{
                        currentViewController=oldViewController;
                        pageImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
                        pageLabel.textColor=[UIColor blackColor];
                        
                        foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
                        foundLabel.textColor=[UIColor blackColor];
                        
                        friendImage.image=[UIImage imageNamed:@"common_icon_home_c@2x"];
                        friendLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                        
                        meImage.image=[UIImage imageNamed:@"common_icon_mine@2x"];
                        meLabel.textColor=[UIColor blackColor];
                        
                    }
                    
                }];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MyLogInViewController *loginViewController = [[MyLogInViewController alloc] init];
                    loginViewController.vCYMID=100;
                    UMComNavigationController *navigationController = [[UMComNavigationController alloc] initWithRootViewController:loginViewController];
                    [self presentViewController:navigationController animated:YES completion:^{
                    }];
                });
            }
            
        }
            break;
        case 1004:
        {
            if(fatherVc.loginYesOrNo==YES){
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                _tabBarID=4;
                helpDic=@{@"action":@"mine"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
                indexesID=0;
                [self transitionFromViewController:currentViewController toViewController:thirdViewController duration:0.5 options:0 animations:^{
                    
                }  completion:^(BOOL finished) {
                    if (finished) {
                        _manager = [ISLoginManager shareManager];
                        NSString *userID=[NSString stringWithFormat:@"%@",_manager.telephone];
                        currentViewController=thirdViewController;
                        thirdViewController.rootId=0;
                        thirdViewController.userID=userID;
                        thirdViewController.view_userID=userID;
                        pageImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
                        pageLabel.textColor=[UIColor blackColor];
                        
                        foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
                        foundLabel.textColor=[UIColor blackColor];
                        
                        friendImage.image=[UIImage imageNamed:@"common_icon_home@2x"];
                        friendLabel.textColor=[UIColor blackColor];
                        
                        meImage.image=[UIImage imageNamed:@"common_icon_mine_c@2x"];
                        meLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                    }else{
                        pageImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
                        pageLabel.textColor=[UIColor blackColor];
                        
                        foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
                        foundLabel.textColor=[UIColor blackColor];
                        
                        friendImage.image=[UIImage imageNamed:@"common_icon_home@2x"];
                        friendLabel.textColor=[UIColor blackColor];
                        
                        meImage.image=[UIImage imageNamed:@"common_icon_mine_c@2x"];
                        meLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                        
                        
                    }
                }];

            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MyLogInViewController *loginViewController = [[MyLogInViewController alloc] init];
                    loginViewController.vCYMID=100;
                    UMComNavigationController *navigationController = [[UMComNavigationController alloc] initWithRootViewController:loginViewController];
                    [self presentViewController:navigationController animated:YES completion:^{
                    }];
                });
            }
            
        }
            break;
    
        default:
            break;
    }

    
}

- (void)LoginReturn:(NSNotification *)noti
{
    switch (_tabBarID) {
        case 0:
        {
            currentViewController=homePageVIewController;
            pageImage.image=[UIImage imageNamed:@"common_icon_chum_c@2x"];
            pageLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
            
            foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
            foundLabel.textColor=[UIColor blackColor];
            
            friendImage.image=[UIImage imageNamed:@"common_icon_home@2x"];
            friendLabel.textColor=[UIColor blackColor];
            
            meImage.image=[UIImage imageNamed:@"common_icon_mine@2x"];
            meLabel.textColor=[UIColor blackColor];
            [mainView addSubview:homePageVIewController.view];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }
            break;
        case 1:
        {
            currentViewController=firstViewController;
            firstViewController.vcID=0;
            pageImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
            pageLabel.textColor=[UIColor blackColor];
            
            foundImage.image=[UIImage imageNamed:@"common_icon_find_c@2x"];
            foundLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
            
            friendImage.image=[UIImage imageNamed:@"common_icon_home@2x"];
            friendLabel.textColor=[UIColor blackColor];
            
            meImage.image=[UIImage imageNamed:@"common_icon_mine@2x"];
            meLabel.textColor=[UIColor blackColor];
            [mainView addSubview:firstViewController.view];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }
            break;
        case 3:
        {
            currentViewController=viewController;
            
            pageImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
            pageLabel.textColor=[UIColor blackColor];
            
            foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
            foundLabel.textColor=[UIColor blackColor];
            
            friendImage.image=[UIImage imageNamed:@"common_icon_home_c@2x"];
            friendLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
            
            meImage.image=[UIImage imageNamed:@"common_icon_mine@2x"];
            meLabel.textColor=[UIColor blackColor];
            [mainView addSubview:viewController.view];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
            break;
        case 4:
        {
            currentViewController=thirdViewController;
            //                thirdViewController.rootId=0;
            
            pageImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
            pageLabel.textColor=[UIColor blackColor];
            
            foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
            foundLabel.textColor=[UIColor blackColor];
            
            friendImage.image=[UIImage imageNamed:@"common_icon_home@2x"];
            friendLabel.textColor=[UIColor blackColor];
            
            meImage.image=[UIImage imageNamed:@"common_icon_mine_c@2x"];
            meLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
            [mainView addSubview:thirdViewController.view];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
            break;
            
        default:
            break;
    }

}
- (void)ZFBPaySuccess:(NSNotification *)notification
{
    
    if (notification.object == nil) {
        UIViewController *oldViewController=currentViewController;
        [self transitionFromViewController:firstViewController toViewController:secondViewController duration:1 options:0 animations:^{
            
        }  completion:^(BOOL finished) {
            if (finished) {
                currentViewController=secondViewController;
                
            }else{
                currentViewController=oldViewController;
                
            }
        }];
    }
    
}
-(void)bottomButton
{
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationDuration:1];
    tab.hidden=NO;
    [UIView commitAnimations];
    bottomView.hidden=YES;
//    if (_is_new_userID==1) {
//        currentViewController=homePageVIewController;
//        pageImage.image=[UIImage imageNamed:@"common_icon_chum_c@2x"];
//        pageLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
//        
//        foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
//        foundLabel.textColor=[UIColor blackColor];
//        
//        friendImage.image=[UIImage imageNamed:@"common_icon_home@2x"];
//        friendLabel.textColor=[UIColor blackColor];
//        
//        meImage.image=[UIImage imageNamed:@"common_icon_mine@2x"];
//        meLabel.textColor=[UIColor blackColor];
//        [mainView addSubview:homePageVIewController.view];
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    }else{
        switch (_tabBarID) {
            case 0:
            {
                currentViewController=homePageVIewController;
                pageImage.image=[UIImage imageNamed:@"common_icon_chum_c@2x"];
                pageLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                
                foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
                foundLabel.textColor=[UIColor blackColor];
                
                friendImage.image=[UIImage imageNamed:@"common_icon_home@2x"];
                friendLabel.textColor=[UIColor blackColor];
                
                meImage.image=[UIImage imageNamed:@"common_icon_mine@2x"];
                meLabel.textColor=[UIColor blackColor];
                [mainView addSubview:homePageVIewController.view];
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            }
                break;
            case 1:
            {
                currentViewController=firstViewController;
                firstViewController.vcID=0;
                pageImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
                pageLabel.textColor=[UIColor blackColor];
                
                foundImage.image=[UIImage imageNamed:@"common_icon_find_c@2x"];
                foundLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                
                friendImage.image=[UIImage imageNamed:@"common_icon_home@2x"];
                friendLabel.textColor=[UIColor blackColor];
                
                meImage.image=[UIImage imageNamed:@"common_icon_mine@2x"];
                meLabel.textColor=[UIColor blackColor];
                [mainView addSubview:firstViewController.view];
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            }
                break;
            case 3:
            {
                currentViewController=viewController;
                
                pageImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
                pageLabel.textColor=[UIColor blackColor];
                
                foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
                foundLabel.textColor=[UIColor blackColor];
                
                friendImage.image=[UIImage imageNamed:@"common_icon_home_c@2x"];
                friendLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                
                meImage.image=[UIImage imageNamed:@"common_icon_mine@2x"];
                meLabel.textColor=[UIColor blackColor];
                [mainView addSubview:viewController.view];
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            }
                break;
            case 4:
            {
                currentViewController=thirdViewController;
//                thirdViewController.rootId=0;
                
                pageImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
                pageLabel.textColor=[UIColor blackColor];
                
                foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
                foundLabel.textColor=[UIColor blackColor];
                
                friendImage.image=[UIImage imageNamed:@"common_icon_home@2x"];
                friendLabel.textColor=[UIColor blackColor];
                
                meImage.image=[UIImage imageNamed:@"common_icon_mine_c@2x"];
                meLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                [mainView addSubview:thirdViewController.view];
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            }
                break;
                
            default:
                break;
        }
//    }
    
    
//    [self tabBarAction];
}

-(void)butAction:(UIButton *)sender
{
//    _manager = [ISLoginManager shareManager];
//    DownloadManager *_download = [[DownloadManager alloc]init];
//    NSDictionary *_dict = @{@"user_id":_manager.telephone};
//    [_download requestWithUrl:[NSString stringWithFormat:@"%@",USER_INFO] dict:_dict view:self.view delegate:self finishedSEL:@selector(DownloadFinish1:) isPost:NO failedSEL:@selector(FailDownload:)];
//    NSDictionary *dic=[sender objectForKey:@"data"];
    ChatViewController *vcr=[[ChatViewController alloc]initWithChatter:@"simi-user-366" isGroup:NO];
    vcr.title=[NSString stringWithFormat:@"%@",msNameString];
    [vcr.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:vcr animated:YES];
}
-(void)DownloadFinish1:(id)sender
{
    NSLog(@"%@",sender);
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    int is_senior=[[delegate.globalDic objectForKey:@"is_senior"]intValue];
    if (is_senior==0) {
        ClerkViewController *seekVC=[[ClerkViewController alloc]init];
        seekVC.service_type_id=@"75";
        [self.navigationController pushViewController:seekVC animated:YES];
    }else
    {
        NSDictionary *dic=[sender objectForKey:@"data"];
        ChatViewController *vcr=[[ChatViewController alloc]initWithChatter:[dic objectForKey:@"im_sec_username"] isGroup:NO];
        vcr.title=[NSString stringWithFormat:@"%@",[dic objectForKey:@"im_sec_nickname"]];
        [vcr.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:vcr animated:YES];
    }
    
}
-(void)FailDownload:(id)sender
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
{
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return plusArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
#pragma mark - 获取图像路径
- (NSString *)imageFilePath:(NSString *)imageUrl
{
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    createPath = [NSString stringWithFormat:@"%@/Servicr_HallImage", pathDocuments];
    //    NSArray *file = [[[NSFileManager alloc] init] subpathsAtPath:createPath];
    //    //NSLog(@"%d",[file count]);
    //    NSLog(@"%@",file);

    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:createPath]) {
        
        
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
#pragma mark 拼接图像文件在沙盒中的路径,因为图像URL有"/",要在存入前替换掉,随意用"_"代替
    //    NSString * imageName = [imageUrl stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString * imageFilePath = [createPath stringByAppendingPathComponent:imageUrl];
    
    
    return imageFilePath;
}
#pragma mark - 加载本地图像
- (UIImage *)loadLocalImage:(NSString *)imageUrl
{
    
    // 获取图像路径
    NSString * filePath = [self imageFilePath:imageUrl];
    
    
    UIImage * image = [UIImage imageWithContentsOfFile:filePath];
    
    
    if (image != nil) {
        return image;
    }
    
    return nil;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify=@"cell";//[NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    NSDictionary *dataDic=plusArray[indexPath.row];
    PlusCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义cell就不可能进来了");
    }
    NSString *nameStr=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"name"]];
    if (indexPath.row==plusArray.count-1) {
         NSString *imageUrl=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"logo"]];
        [cell.lconImageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
    }else{
        NSString *imageUrl=[NSString stringWithFormat:@"apptools_%@_%@",[dataDic objectForKey:@"t_id"],[dataDic objectForKey:@"update_time"]];
        UIImage * image =[self loadLocalImage:imageUrl];
        if (image==nil) {
            cell.lconImageView.image=[UIImage imageNamed:imageUrl];
        }else{
            cell.lconImageView.image=image;
        }
    }
    
    
    
    cell.lconImageView.frame=FRAME((WIDTH/4-50)/2, 10, 50, 50);
    cell.lconImageView.layer.cornerRadius=cell.lconImageView.frame.size.width/2;
    cell.lconImageView.clipsToBounds=YES;
    cell.nameLabel.text=nameStr;
    cell.nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
    cell.nameLabel.textColor=[UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1];
    cell.nameLabel.textAlignment=NSTextAlignmentCenter;
    cell.backgroundColor=[UIColor whiteColor];
    cell.layer.borderColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1].CGColor;
    cell.layer.borderWidth=0;
    
    if([indexPath row] == ((NSIndexPath*)[[collectionView indexPathsForVisibleItems] lastObject]).row){
        dispatch_async(dispatch_get_main_queue(),^{
            [meView stopAnimating]; // 结束旋转
            [meView setHidesWhenStopped:YES]; //当旋转结束时隐藏
        });
    }
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(WIDTH/4, 95);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(WIDTH, 0);
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=plusArray[indexPath.row];
    NSString *nameStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    NSLog(@"%ld",(long)indexPath.row);
    NSDictionary *helpDic;
    NSString *category=[NSString stringWithFormat:@"%@",[dic objectForKey:@"open_type"]];
    NSString *action=[NSString stringWithFormat:@"%@",[dic objectForKey:@"action"]];
    NSString *params=[NSString stringWithFormat:@"%@",[dic objectForKey:@"params"]];
    if ([category isEqualToString:@"app"]) {
        if ([action isEqualToString:@"alarm"]) {
            if ([params isEqualToString:@"add"]) {
                MeetingViewController *meetVC=[[MeetingViewController alloc]init];
                meetVC.titleName=nameStr;
                meetVC.vcID=1003;
                [self.navigationController pushViewController:meetVC animated:YES];
            }else if ([params isEqualToString:@"list"]){
                helpDic=@{@"action":@"alarm"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
                CardPageViewController *pageViewVC=[[CardPageViewController alloc]init];
                pageViewVC.tyPeStr=action;
                pageViewVC.navlabelName=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
//                UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
//                pageViewVC=[storys instantiateInitialViewController];
                pageViewVC.vcID=1003;
                [self.navigationController pushViewController:pageViewVC animated:YES];
            }
            
        }else if ([action isEqualToString:@"meeting"]){
            if ([params isEqualToString:@"add"]) {
                MeetingViewController *meetVC=[[MeetingViewController alloc]init];
                meetVC.titleName=nameStr;
                meetVC.vcID=1001;
                [self.navigationController pushViewController:meetVC animated:YES];
            }else if ([params isEqualToString:@"list"]){
                helpDic=@{@"action":@"meeting"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
                CardPageViewController *pageViewVC=[[CardPageViewController alloc]init];
                pageViewVC.tyPeStr=action;
                pageViewVC.navlabelName=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
//                UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
//                pageViewVC=[storys instantiateInitialViewController];
                pageViewVC.vcID=1001;
                [self.navigationController pushViewController:pageViewVC animated:YES];
            }
           
        }else if ([action isEqualToString:@"notice"]){
            if ([params isEqualToString:@"add"]) {
                MeetingViewController *meetVC=[[MeetingViewController alloc]init];
                meetVC.titleName=nameStr;
                meetVC.vcID=1002;
                [self.navigationController pushViewController:meetVC animated:YES];
            }else if ([params isEqualToString:@"list"]){
                helpDic=@{@"action":@"notice"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
                CardPageViewController *pageViewVC=[[CardPageViewController alloc]init];
                pageViewVC.tyPeStr=action;
                pageViewVC.navlabelName=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
//                UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
//                pageViewVC=[storys instantiateInitialViewController];
                pageViewVC.vcID=1002;
                [self.navigationController pushViewController:pageViewVC animated:YES];
            }
            
        }else if ([action isEqualToString:@"interview"]){
            if ([params isEqualToString:@"add"]) {
                MeetingViewController *meetVC=[[MeetingViewController alloc]init];
                meetVC.titleName=nameStr;
                meetVC.vcID=1004;
                [self.navigationController pushViewController:meetVC animated:YES];
            }else if ([params isEqualToString:@"list"]){
                helpDic=@{@"action":@"interview"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
                CardPageViewController *pageViewVC=[[CardPageViewController alloc]init];
                pageViewVC.tyPeStr=action;
                pageViewVC.navlabelName=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
//                UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
//                pageViewVC=[storys instantiateInitialViewController];
                pageViewVC.vcID=1004;
                [self.navigationController pushViewController:pageViewVC animated:YES];
            }
            
        }else if ([action isEqualToString:@"trip"]){
            if ([params isEqualToString:@"add"]) {
                BookingViewController *bookVC=[[BookingViewController alloc]init];
                bookVC.titleName=nameStr;
                [self.navigationController pushViewController:bookVC animated:YES];
            }else if ([params isEqualToString:@"list"]){
                helpDic=@{@"action":@"trip"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
                CardPageViewController *pageViewVC=[[CardPageViewController alloc]init];
                pageViewVC.tyPeStr=action;
                pageViewVC.navlabelName=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
//                UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
//                pageViewVC=[storys instantiateInitialViewController];
                pageViewVC.vcID=1005;
                [self.navigationController pushViewController:pageViewVC animated:YES];
            }
            
        }else if ([action isEqualToString:@"checkin"]){
            if ([params isEqualToString:@"add"]) {
               
                AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
                NSString *has_company=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"has_company"]];
                int has=[has_company intValue];
                if (has==0) {
                    Create_Enterprise_Address_BookViewController *boolVC=[[Create_Enterprise_Address_BookViewController alloc]init];
                    [self.navigationController pushViewController:boolVC animated:YES];
                }else{
                    
                    AttendanceViewController *userVC=[[AttendanceViewController alloc]init];
                    userVC.titleName=nameStr;
                    userVC.webID=1;
                    userVC.tyPeStr=action;
                    [self.navigationController pushViewController:userVC animated:YES];
                }
                
                
            }else if ([params isEqualToString:@"list"]){
                helpDic=@{@"action":@"punch_sign"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
                CardPageViewController *pageViewVC=[[CardPageViewController alloc]init];
                pageViewVC.tyPeStr=action;
                pageViewVC.navlabelName=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
//                UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
//                pageViewVC=[storys instantiateInitialViewController];
                pageViewVC.vcID=1006;
                [self.navigationController pushViewController:pageViewVC animated:YES];
            }
            
        }else if ([action isEqualToString:@"leave"]){
            if ([params isEqualToString:@"add"]) {
                ApplyForLeaveViewController *applyVC=[[ApplyForLeaveViewController alloc]init];
                applyVC.titleName=nameStr;
                applyVC.tyPeStr=action;
                applyVC.colorid=100;
                [self.navigationController pushViewController:applyVC animated:YES];
            }else if ([params isEqualToString:@"list"]){
                helpDic=@{@"action":@"leave_pass"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
                LeaveListViewController *leaveListVC=[[LeaveListViewController alloc]init];
                leaveListVC.titleName=nameStr;
                leaveListVC.tyPeStr=action;
                [self.navigationController pushViewController:leaveListVC animated:YES];
            }
            
        }else if ([action isEqualToString:@"feed_add"]){
            if ([params isEqualToString:@"add"]) {
                UpLoadViewController *vcd=[[UpLoadViewController alloc]init];
                
                [self.navigationController pushViewController:vcd animated:YES];
            }else if ([params isEqualToString:@"list"]){
                helpDic=@{@"action":@"feed_add"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
                CardPageViewController *pageViewVC=[[CardPageViewController alloc]init];
                pageViewVC.tyPeStr=action;
                pageViewVC.vcID=1008;
                [self.navigationController pushViewController:pageViewVC animated:YES];
            }
            
        }else if([action isEqualToString:@"water"]){
            if ([params isEqualToString:@"add"]) {
                
            }else if ([params isEqualToString:@"list"]){
                WaterListViewController *plantsVc=[[WaterListViewController alloc]init];
                plantsVc.titleName=nameStr;
                plantsVc.tyPeStr=action;
                [self.navigationController pushViewController:plantsVc animated:YES];
            }
        }else if([action isEqualToString:@"recycle"]){
            if ([params isEqualToString:@"add"]) {
                
            }else if ([params isEqualToString:@"list"]){
                WasteRecoveryViewController *plantsVc=[[WasteRecoveryViewController alloc]init];
                plantsVc.titleName=nameStr;
                plantsVc.wasteID=100;
                plantsVc.tyPeStr=action;
                [self.navigationController pushViewController:plantsVc animated:YES];
            }
        }else if([action isEqualToString:@"clean"]){
            if ([params isEqualToString:@"add"]) {
                
            }else if ([params isEqualToString:@"list"]){
                WasteRecoveryViewController *plantsVc=[[WasteRecoveryViewController alloc]init];
                plantsVc.titleName=nameStr;
                plantsVc.tyPeStr=action;
                plantsVc.wasteID=101;
                [self.navigationController pushViewController:plantsVc animated:YES];
            }
        }else if([action isEqualToString:@"teamwork"]){
            if ([params isEqualToString:@"add"]) {
                
            }else if ([params isEqualToString:@"list"]){
                WasteRecoveryViewController *plantsVc=[[WasteRecoveryViewController alloc]init];
                plantsVc.tyPeStr=action;
                plantsVc.titleName=nameStr;
                plantsVc.wasteID=102;
                [self.navigationController pushViewController:plantsVc animated:YES];
            }
        }else if([action isEqualToString:@"express"]){
            if ([params isEqualToString:@"add"]) {
                
            }else if ([params isEqualToString:@"list"]){
                WasteRecoveryViewController *plantsVc=[[WasteRecoveryViewController alloc]init];
                plantsVc.titleName=nameStr;
                plantsVc.tyPeStr=action;
                plantsVc.wasteID=103;
                [self.navigationController pushViewController:plantsVc animated:YES];
            }
        }else if([action isEqualToString:@"asset"]){
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
            NSString *has_company=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"has_company"]];
            int has=[has_company intValue];
            if (has==0) {
                Create_Enterprise_Address_BookViewController *boolVC=[[Create_Enterprise_Address_BookViewController alloc]init];
                [self.navigationController pushViewController:boolVC animated:YES];
            }else{
                AssetsAdministrationViewController *plantsVc=[[AssetsAdministrationViewController alloc]init];
                plantsVc.titleName=nameStr;
                plantsVc.tyPeStr=action;
                [self.navigationController pushViewController:plantsVc animated:YES];
            }
           
            
        }else if([action isEqualToString:@"expy"]){
            ExprViewController *plantsVc=[[ExprViewController alloc]init];
            plantsVc.titleName=nameStr;
            plantsVc.tyPeStr=action;
            [self.navigationController pushViewController:plantsVc animated:YES];
            
        }else if([action isEqualToString:@"company"]){
           
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
            NSString *has_company=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"has_company"]];
            int has=[has_company intValue];
            if (has==0) {
                Create_Enterprise_Address_BookViewController *boolVC=[[Create_Enterprise_Address_BookViewController alloc]init];
                [self.navigationController pushViewController:boolVC animated:YES];
            }else{
                EnterpriseViewController *enterVc=[[EnterpriseViewController alloc]init];
                enterVc.vcIDs=100;
                enterVc.webId=1;
                [self.navigationController pushViewController:enterVc animated:YES];
            }
            
        }else{
            AppCenterViewController *appCenterVC=[[AppCenterViewController alloc]init];
            appCenterVC.titleName=nameStr;
            [self.navigationController pushViewController:appCenterVC animated:YES];
        }
    }else if ([category isEqualToString:@"h5"]){
        WebPageViewController *webPageVC=[[WebPageViewController alloc]init];
        webPageVC.barIDS=100;
        webPageVC.webURL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]];
        [self.navigationController pushViewController:webPageVC animated:YES];
    }
    
}

- (void)getUserInfo
{
    ISLoginManager *logManager = [[ISLoginManager alloc]init];
    NSDictionary *mobelDic = [[NSDictionary alloc]initWithObjectsAndKeys:logManager.telephone,@"user_id", nil];
    DownloadManager *_download = [[DownloadManager alloc]init];
    //    [_download requestWithUrl:[NSString stringWithFormat:@"%@",USERINFO_API] dict:mobelDic view:self.view delegate:self finishedSEL:@selector(DownlLoadFinish:)];
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",USERINFO_API]  dict:mobelDic view:self.view delegate:self finishedSEL:@selector(getUserInfoSuccess:) isPost:NO failedSEL:@selector(getUserInfoFail:)];
    [self hideHud];
    
}
- (void)getUserInfoSuccess:(id)dic
{
    NSDictionary *dict = [dic objectForKey:@"data"];
    //    if (wxID==1) {
    //        [[NSNotificationCenter defaultCenter]postNotificationName:@"MylogVcBack" object:nil];
    //    }
    NSString *clientId=GeTuiSdk.clientId;
    if (clientId==nil||clientId==NULL) {
        return;
    }
    if ([dict objectForKey:@"client_id"]==nil||[dict objectForKey:@"client_id"]==NULL) {
        ISLoginManager *_managers = [ISLoginManager shareManager];
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *_dict = @{@"user_id":_managers.telephone,@"device_type":@"ios",@"client_id":clientId};
        NSLog(@"用户名%@",_dict);
        [_download requestWithUrl:LOGIN_GTJK dict:_dict view:self.view delegate:self finishedSEL:@selector(GTDownLoadFinish:) isPost:YES failedSEL:@selector(GTDownFail:)];
    }else{
        if ([dict objectForKey:@"client_id"]==clientId) {
            
        }else{
            ISLoginManager *_managers = [ISLoginManager shareManager];
            DownloadManager *_download = [[DownloadManager alloc]init];
            NSLog(@"为什么是空的呢？？？？？%@,%@",_managers.telephone,clientId);
            NSDictionary *_dict = @{@"user_id":_managers.telephone,@"device_type":@"ios",@"client_id":clientId};
            NSLog(@"用户名12131314%@",_dict);
            [_download requestWithUrl:LOGIN_GTJK dict:_dict view:self.view delegate:self finishedSEL:@selector(GTDownLoadFinish:) isPost:YES failedSEL:@selector(GTDownFail:)];
        }
    }
    
}
- (void)getUserInfoFail:(id)error
{
    NSLog(@"%@",error);
}
-(void)GTDownLoadFinish:(id)sender
{
    NSLog(@"成功");
}
-(void)GTDownFail:(id)sender
{
    NSLog(@"失败");
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"%lu", (unsigned long)[locations count]);
    
    CLLocation *newLocation = locations[0];
    CLLocationCoordinate2D oldCoordinate= newLocation.coordinate;
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    _lngString=[NSString stringWithFormat:@"%f",oldCoordinate.longitude];
    _latString=[NSString stringWithFormat:@"%f",oldCoordinate.latitude];
    [manager stopUpdatingLocation];
    
    CLLocation *currentLocation = [locations lastObject];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     
     {
         
         if (array.count > 0)
             
         {
             
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             
             
             //将获得的所有信息显示到label上
             
             NSLog(@"%@",placemark.name);
             
             //获取城市
             
             NSString *city = placemark.locality;
             if (!city) {
                 
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 
                 city = placemark.administrativeArea;
                 
             }
             
             _cityStr =[NSString stringWithFormat:@"%@",city];
             _addressName=[NSString stringWithFormat:@"%@",placemark.name];
             [self userAddress];
         }
         
         else if (error == nil && [array count] == 0)
             
         {
             
             NSLog(@"No results were returned.");
             
         }
         
         else if (error != nil)
             
         {
             
             NSLog(@"An error occurred = %@", error);
             
         }
         
     }];
    
    [manager stopUpdatingLocation];
}

// 6.0 调用此函数
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"%@", @"ok");
}
-(void)userAddress
{
    if (fatherVc.loginYesOrNo==YES) {
        ISLoginManager *_managers = [ISLoginManager shareManager];
        NSLog(@"有值么%@",_managers.telephone);
        DownloadManager *_download = [[DownloadManager alloc]init];
        if (_latString==nil||_latString==NULL||[_latString isEqualToString:@""]) {
            _latString=@"";
        }
        if (_lngString==nil||_lngString==NULL||[_lngString isEqualToString:@""]){
            _lngString=@"";
        }
        if (_addressName==nil||_addressName==NULL||[_addressName isEqualToString:@""]){
            _addressName=@"";
        }
        if (_cityStr==nil||_cityStr==NULL||[_cityStr isEqualToString:@""]){
            _cityStr=@"";
        }
        NSDictionary *_dict=@{@"user_id":_managers.telephone,@"lat":_latString,@"lng":_lngString,@"poi_name":_addressName,@"city":_cityStr};
        [_download requestWithUrl:ADDRESS_USER dict:_dict view:self.view delegate:self finishedSEL:@selector(AddressFinish:) isPost:YES failedSEL:@selector(QJDownFail:)];
    }
    
}
//#pragma mark用户信息详情获取失败方法
//-(void)QJDownFail:(id)sender
//{
//    
//}
#pragma mark 获取用户当前地理位置成功返回
-(void)AddressFinish:(id)source
{
    
}

@end
