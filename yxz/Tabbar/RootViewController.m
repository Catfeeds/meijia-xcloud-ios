//
//  RootViewController.m
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "RootViewController.h"
#import "FirstViewController.h"
#import "OrderViewController.h"
#import "MineViewController.h"
#import "MoreViewController.h"
#import "PayViewController.h"
#import "ISLoginManager.h"

#import "SMBaseViewController.h"
#import "ChatViewController.h"
#import "AppDelegate.h"
#import "PageViewController.h"
#import "FriendViewController.h"
#import "EaseMob.h"
#import "FoundViewController.h"
#import "MyselfViewController.h"
#import "PlusViewController.h"

#import "DownloadManager.h"
//#pragma mark 循环按钮跳转类


#import "OriginalViewController.h"

#import "ViewController.h"
#import "ClerkViewController.h"


#import "PageTableViewCell.h"
#import "LeaveListViewController.h"
#import "PlusCollectionViewCell.h"
@interface RootViewController ()<UIAlertViewDelegate, IChatManagerDelegate,UIAlertViewDelegate>
{
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
    NSArray *plusArray;
}
@end
#pragma mark - View lifecycle
PageViewController *pageViewVC;
ViewController * viewController;
FoundViewController * firstViewController;
ViewController *secondViewController;
FriendViewController * friendViewController;
MyselfViewController *thirdViewController;
//MyLogInViewController *myLogInViewController;
@implementation RootViewController
@synthesize tab;
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBarHidden=YES;
    if (indexesID==1) {
        [self bottomButton];
    }
}
-(void)plusLAyout
{
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dic = @{@"app_type":@"xcloud"};
    [_download requestWithUrl:USER_PLUE_LIST dict:_dic view:self.view delegate:self finishedSEL:@selector(PlusSuccess:) isPost:NO failedSEL:@selector(PlusFailure:)];
}
-(void)PlusSuccess:(id)dataSource
{
    NSLog(@"导航接口返回数据：%@",dataSource);
    plusArray=[dataSource objectForKey:@"data"];
    [_collectionView reloadData];
    
}
-(void)PlusFailure:(id)dataSource
{
    NSLog(@"导航接口返回失败数据：%@",dataSource);
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex save2File:(BOOL) save2File save2Album:(BOOL) save2Album{
    
}

-(void)helpLayout:(NSNotification *)dataSource
{
    NSDictionary *dic=dataSource.object;
    WebPageViewController *webVC=[[WebPageViewController alloc]init];
    webVC.webURL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"webUrl"]];
    [self.navigationController pushViewController:webVC animated:YES];
}
- (void)viewDidLoad {
    NSDictionary *helpDic;
    helpDic=@{@"action":@"index"};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(helpLayout:) name:@"WEBURL" object:nil];
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
    
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *yerformatter=[[NSDateFormatter alloc] init];
    [yerformatter setDateFormat:@"yyyy"];
    NSString *  yearStr=[yerformatter stringFromDate:senddate];
    
    NSDateFormatter  *monthformatter=[[NSDateFormatter alloc] init];
    [monthformatter setDateFormat:@"MM"];
    NSString *  monthStr=[monthformatter stringFromDate:senddate];
    
    DownloadManager *download = [[DownloadManager alloc]init];
    NSDictionary *dict=@{@"user_id":_manager.telephone,@"year":yearStr,@"month":monthStr};
    [download requestWithUrl:@"simi/app/card/total_by_month.json"  dict:dict view:self.view delegate:self finishedSEL:@selector(RiLiSuccess:) isPost:NO failedSEL:@selector(RiLiFailure:)];
    [self setupUntreatedApplyCount];
    [self makeTabbarView];
    [self bottomViewLayout];
    
    [self setupUnreadMessageCount];
    [self plusLAyout];
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

-(void)RiLiSuccess:(id)sender
{
    NSArray *array=[sender objectForKey:@"data"];
    AppDelegate *delegates=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    for (int i=0; i<array.count; i++) {
        if([delegates.riliArray containsObject:array[i]])
        {
            
        }else{
            [delegates.riliArray addObject:array[i]];
        }
    }

    
    
    UIStoryboard *story  = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    viewController=[story instantiateViewControllerWithIdentifier:@"ViewController"];
    [self addChildViewController:viewController];
    
    firstViewController = [[FoundViewController alloc]init];
    firstViewController.backBtn.hidden=YES;
    [self addChildViewController:firstViewController];
    
    secondViewController = [[ViewController alloc]init];
    [self addChildViewController:secondViewController];
    
    friendViewController=[[FriendViewController alloc]init];
//    friendViewController.backBtn.hidden=YES;
    [self addChildViewController:friendViewController];
    
    thirdViewController = [[MyselfViewController alloc]init];
    [self addChildViewController:thirdViewController];
    
//    myLogInViewController = [[MyLogInViewController alloc]init];
//    [self addChildViewController:myLogInViewController];
    
    [mainView addSubview:viewController.view];
    currentViewController = viewController;

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
-(void)RiLiFailure:(id)sender
{
    NSLog(@"日历布局失败返回:%@",sender);
}


-(void)bottomViewLayout
{
    
    bottomView=[[UIImageView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
    bottomView.image=[UIImage imageNamed:@"95%"];
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
    secrearyLabel.font=[UIFont fontWithName:@"Arial" size:15];
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
    NSArray *barArr = @[@"首页",@"发现",@"工作",@"圈子",@"我的"];
    NSArray *imagesArray =@[@"common_icon_home@2x",@"common_icon_find@2x",@"icon_plus_add副本(1)",@"common_icon_chum@2x",@"common_icon_mine@2x"];
    float _btnwidth = self.view.frame.size.width/5;
    tab=[[UIImageView alloc]initWithFrame:CGRectMake(0, SELF_VIEW_HEIGHT-49, SELF_VIEW_WIDTH, 49)];
    tab.image=[UIImage imageNamed:@"bg_menu_bottom副本"];
    tab.userInteractionEnabled=YES;
//    tab.backgroundColor=[UIColor redColor];
    [self.view addSubview:tab];
    for (int i=0; i<barArr.count; i++) {
        if (i!=2) {
            UIButton *tabBarBut=[UIButton buttonWithType:UIButtonTypeCustom];
            tabBarBut.frame=CGRectMake(_btnwidth*i, 0, _btnwidth, 49);
            [tabBarBut addTarget:self action:@selector(SelectBarbtnWithtag:) forControlEvents:UIControlEventTouchUpInside];
            [tabBarBut setTag:(1000+i)];
            [tab addSubview:tabBarBut];
            if (i==0) {
                pageImage.frame=CGRectMake((_btnwidth-23)/2, 7, 23, 23);
                pageImage.image=[UIImage imageNamed:@"common_icon_home_c@2x"];
                [tabBarBut addSubview:pageImage];
                pageLabel.frame=CGRectMake((_btnwidth-23)/2, 36, 23, 10);
                pageLabel.text=[barArr objectAtIndex:i];
                pageLabel.textAlignment=NSTextAlignmentCenter;
                pageLabel.font=[UIFont fontWithName:@"Arial" size:10];
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
                foundLabel.font=[UIFont fontWithName:@"Arial" size:10];
                [tabBarBut addSubview:foundLabel];
            }else if (i==3){
                friendImage.frame=CGRectMake((_btnwidth-23)/2,7, 23, 23);
                friendImage.image=[UIImage imageNamed:imagesArray[i]];
                [tabBarBut addSubview:friendImage];
                friendLabel.frame=CGRectMake((_btnwidth-23)/2, 36, 23, 10);
                friendLabel.text=[barArr objectAtIndex:i];
                friendLabel.textAlignment=NSTextAlignmentCenter;
                friendLabel.font=[UIFont fontWithName:@"Arial" size:10];
                [tabBarBut addSubview:friendLabel];
                
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
                meLabel.font=[UIFont fontWithName:@"Arial" size:10];
                meLabel.textAlignment=NSTextAlignmentCenter;
                [tabBarBut addSubview:meLabel];
            }
        }else
        {
            UIButton *tabBarBut=[UIButton buttonWithType:UIButtonTypeCustom];
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
            releaseLabel.font=[UIFont fontWithName:@"Arial" size:10];
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
    if ((currentViewController==viewController&&[sender tag]==1000)||(currentViewController==firstViewController&&[sender tag]==1001)||(currentViewController==secondViewController&&[sender tag]==1002) ||(currentViewController==friendViewController&&[sender tag]==1003)||(currentViewController==thirdViewController&&[sender tag]==1004) ) {
        return;
    }
    UIViewController *oldViewController=currentViewController;
    switch (sender.tag) {
        case 1000:
        {
            helpDic=@{@"action":@"index"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
            indexesID=0;
            [self transitionFromViewController:currentViewController toViewController:viewController duration:0.5 options:0 animations:^{
            }  completion:^(BOOL finished) {
                if(finished){
                    currentViewController=viewController;
                    pageImage.image=[UIImage imageNamed:@"common_icon_home_c@2x"];
                    pageLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                    foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
                    foundLabel.textColor=[UIColor blackColor];
                    
                    friendImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
                    friendLabel.textColor=[UIColor blackColor];
                    
                    meImage.image=[UIImage imageNamed:@"common_icon_mine@2x"];
                    meLabel.textColor=[UIColor blackColor];
                }else{
                    currentViewController=viewController;
                    pageImage.image=[UIImage imageNamed:@"common_icon_home_c@2x"];
                    pageLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                    foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
                    foundLabel.textColor=[UIColor blackColor];
                    
                    friendImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
                    friendLabel.textColor=[UIColor blackColor];
                    
                    meImage.image=[UIImage imageNamed:@"common_icon_mine@2x"];
                    meLabel.textColor=[UIColor blackColor];
                }
                
            }];
        }
             break;
        case 1001:
        {
            helpDic=@{@"action":@"discover"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
            
            int b=0;
            indexesID=0;
            NSLog( @"走不走？%d",b++);
            [self transitionFromViewController:currentViewController toViewController:firstViewController duration:0.5 options:0 animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    
                    currentViewController=firstViewController;
                    firstViewController.vcID=0;
                    pageImage.image=[UIImage imageNamed:@"common_icon_home@2x"];
                    pageLabel.textColor=[UIColor blackColor];
                    
                    foundImage.image=[UIImage imageNamed:@"common_icon_find_c@2x"];
                    foundLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                    
                    friendImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
                    friendLabel.textColor=[UIColor blackColor];
                    
                    meImage.image=[UIImage imageNamed:@"common_icon_mine@2x"];
                    meLabel.textColor=[UIColor blackColor];
                }else{
                    currentViewController=oldViewController;
                    
                    pageImage.image=[UIImage imageNamed:@"common_icon_home@2x"];
                    pageLabel.textColor=[UIColor blackColor];
                    
                    foundImage.image=[UIImage imageNamed:@"common_icon_find_c@2x"];
                    foundLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                    
                    friendImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
                    friendLabel.textColor=[UIColor blackColor];
                    
                    meImage.image=[UIImage imageNamed:@"common_icon_mine@2x"];
                    meLabel.textColor=[UIColor blackColor];
                }
            }];
            
            
        }
            break;
            
            
        case 1002:
        {
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
                    [self plusLAyout];
                }else{
                    currentViewController=oldViewController;
                    
                }
            }];
        }
            break;
        case 1003:
        {
            helpDic=@{@"action":@"sns"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
            indexesID=0;
            [self transitionFromViewController:currentViewController toViewController:friendViewController duration:0.5 options:0 animations:^{
            }  completion:^(BOOL finished) {
                if(finished){
                    currentViewController=friendViewController;
                    
                    pageImage.image=[UIImage imageNamed:@"common_icon_home@2x"];
                    pageLabel.textColor=[UIColor blackColor];
                    
                    foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
                    foundLabel.textColor=[UIColor blackColor];
                    
                    friendImage.image=[UIImage imageNamed:@"common_icon_chum_c@2x"];
                    friendLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                    
                    meImage.image=[UIImage imageNamed:@"common_icon_mine@2x"];
                    meLabel.textColor=[UIColor blackColor];
                }else{
                    currentViewController=oldViewController;
                    pageImage.image=[UIImage imageNamed:@"common_icon_home@2x"];
                    pageLabel.textColor=[UIColor blackColor];
                    
                    foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
                    foundLabel.textColor=[UIColor blackColor];
                    
                    friendImage.image=[UIImage imageNamed:@"common_icon_chum_c@2x"];
                    friendLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                    
                    meImage.image=[UIImage imageNamed:@"common_icon_mine@2x"];
                    meLabel.textColor=[UIColor blackColor];

                }
                
            }];
        }
            break;
        case 1004:
        {
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
                        pageImage.image=[UIImage imageNamed:@"common_icon_home@2x"];
                        pageLabel.textColor=[UIColor blackColor];
                        
                        foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
                        foundLabel.textColor=[UIColor blackColor];
                        
                        friendImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
                        friendLabel.textColor=[UIColor blackColor];
                        
                        meImage.image=[UIImage imageNamed:@"common_icon_mine_c@2x"];
                        meLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                    }else{
                        pageImage.image=[UIImage imageNamed:@"common_icon_home@2x"];
                        pageLabel.textColor=[UIColor blackColor];
                        
                        foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
                        foundLabel.textColor=[UIColor blackColor];
                        
                        friendImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
                        friendLabel.textColor=[UIColor blackColor];
                        
                        meImage.image=[UIImage imageNamed:@"common_icon_mine_c@2x"];
                        meLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                        
                        
                    }
                }];

            }
            break;
    
        default:
            break;
    }

    
}

- (void)LoginReturn:(NSNotification *)noti
{
    currentViewController=viewController;
    pageImage.image=[UIImage imageNamed:@"common_icon_home_c@2x"];
    pageLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    
    foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
    foundLabel.textColor=[UIColor blackColor];
    
    friendImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
    friendLabel.textColor=[UIColor blackColor];
    
    meImage.image=[UIImage imageNamed:@"common_icon_mine@2x"];
    meLabel.textColor=[UIColor blackColor];
    [mainView addSubview:currentViewController.view];
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
    currentViewController=viewController;
    pageImage.image=[UIImage imageNamed:@"common_icon_home_c@2x"];
    pageLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    
    foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
    foundLabel.textColor=[UIColor blackColor];
    
    friendImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
    friendLabel.textColor=[UIColor blackColor];
    
    meImage.image=[UIImage imageNamed:@"common_icon_mine@2x"];
    meLabel.textColor=[UIColor blackColor];
    [mainView addSubview:viewController.view];
    [self tabBarAction];
}

-(void)butAction:(UIButton *)sender
{
    _manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict = @{@"user_id":_manager.telephone};
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",USER_INFO] dict:_dict view:self.view delegate:self finishedSEL:@selector(DownloadFinish1:) isPost:NO failedSEL:@selector(FailDownload:)];
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
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify=@"cell";//[NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    NSDictionary *dataDic=plusArray[indexPath.row];
    PlusCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义cell就不可能进来了");
    }
    NSString *nameStr=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"title"]];
    
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"icon_url"]];
    [cell.lconImageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
   
    cell.lconImageView.frame=FRAME((WIDTH/4-50)/2, 10, 50, 50);
    cell.nameLabel.text=nameStr;
    cell.nameLabel.font=[UIFont fontWithName:@"Arial" size:13];
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
    NSDictionary *helpDic;
    NSString *category=[NSString stringWithFormat:@"%@",[dic objectForKey:@"category"]];
    NSString *action=[NSString stringWithFormat:@"%@",[dic objectForKey:@"action"]];
    if ([category isEqualToString:@"app"]) {
        if ([action isEqualToString:@"alarm"]) {
            helpDic=@{@"action":@"alarm"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
            PageViewController *pageViewVC=[[PageViewController alloc]init];
            UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
            pageViewVC=[storys instantiateInitialViewController];
            pageViewVC.vcID=1003;
            [self.navigationController pushViewController:pageViewVC animated:YES];
        }else if ([action isEqualToString:@"meeting"]){
            helpDic=@{@"action":@"meeting"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
            PageViewController *pageViewVC=[[PageViewController alloc]init];
            UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
            pageViewVC=[storys instantiateInitialViewController];
            pageViewVC.vcID=1001;
            [self.navigationController pushViewController:pageViewVC animated:YES];
        }else if ([action isEqualToString:@"notice"]){
            helpDic=@{@"action":@"notice"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
            PageViewController *pageViewVC=[[PageViewController alloc]init];
            UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
            pageViewVC=[storys instantiateInitialViewController];
            pageViewVC.vcID=1002;
            [self.navigationController pushViewController:pageViewVC animated:YES];
        }else if ([action isEqualToString:@"interview"]){
            helpDic=@{@"action":@"interview"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
            PageViewController *pageViewVC=[[PageViewController alloc]init];
            UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
            pageViewVC=[storys instantiateInitialViewController];
            pageViewVC.vcID=1004;
            [self.navigationController pushViewController:pageViewVC animated:YES];
        }else if ([action isEqualToString:@"trip"]){
            helpDic=@{@"action":@"trip"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
            PageViewController *pageViewVC=[[PageViewController alloc]init];
            UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
            pageViewVC=[storys instantiateInitialViewController];
            pageViewVC.vcID=1005;
            [self.navigationController pushViewController:pageViewVC animated:YES];
        }else if ([action isEqualToString:@"punch_sign"]){
            helpDic=@{@"action":@"punch_sign"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
            PageViewController *pageViewVC=[[PageViewController alloc]init];
            UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
            pageViewVC=[storys instantiateInitialViewController];
            pageViewVC.vcID=1006;
            [self.navigationController pushViewController:pageViewVC animated:YES];
        }else if ([action isEqualToString:@"leave_pass"]){
            helpDic=@{@"action":@"leave_pass"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
            LeaveListViewController *leaveListVC=[[LeaveListViewController alloc]init];
            [self.navigationController pushViewController:leaveListVC animated:YES];
        }else if ([action isEqualToString:@"punch_dynamic"]){
            helpDic=@{@"action":@"punch_dynamic"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
            PageViewController *pageViewVC=[[PageViewController alloc]init];
            UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
            pageViewVC=[storys instantiateInitialViewController];
            pageViewVC.vcID=1008;
            [self.navigationController pushViewController:pageViewVC animated:YES];
        }
    }
    
}
@end
