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
#import "MyLogInViewController.h"
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
#import "BookingViewController.h"
#import "MeetingViewController.h"
#import "OriginalViewController.h"

#import "ViewController.h"
#import "SeekViewController.h"
#import "UpLoadViewController.h"
@interface RootViewController ()
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
    
    UIImageView *bottomView;
    BookingViewController *vc;
    MeetingViewController *vcs;
    
    int indexesID;
}
@end
#pragma mark - View lifecycle
ViewController * pageViewController;
FoundViewController * firstViewController;
ViewController *secondViewController;
FriendViewController * friendViewController;
MyselfViewController *thirdViewController;
MyLogInViewController *myLogInViewController;


//SMBaseViewController *baseVC;
//MyLogInViewController *logVC;
//MineViewController *mineVC;

//MoreViewController *fourViewController;
//LoginViewController *loginViewController;
@implementation RootViewController
@synthesize tab;
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBarHidden=YES;
    if (indexesID==1) {
        [self bottomButton];
    }
//    if (vc.cardsID==1||vcs.cardsID==1) {
//        [self bottomButton];
//    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    indexesID=0;
    
    // 状态栏(statusbar)
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    NSLog(@"status width - %f", rectStatus.size.width); // 宽度
    NSLog(@"status height - %f", rectStatus.size.height);   // 高度
    
    // 导航栏（navigationbar）
    CGRect rectNav = self.navigationController.navigationBar.frame;
    NSLog(@"nav width - %f", rectNav.size.width); // 宽度
    NSLog(@"nav height - %f", rectNav.size.height);   // 高度
    self.navigationController.navigationBarHidden=YES;
   // NSLog(@"asmbdsab[EaseMob sharedInsatnce].sdkVersion%@",[EaseMob sharedInsatnce].sdkVersion);
    
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
//    APPLIACTION.leiName = @"66";
    
    _manager = [ISLoginManager shareManager];
    
    
    //    manager = [ISLoginManager shareManager];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LoginReturn:) name:@"LOGIN_SUCCESS" object:nil];
    
    mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SELF_VIEW_WIDTH, SELF_VIEW_HEIGHT-78/2)];
    //mainView.backgroundColor=[UIColor blackColor];
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
    
    [self makeTabbarView];
    [self bottomViewLayout];
}

-(void)RiLiSuccess:(id)sender
{
    NSArray *array=[sender objectForKey:@"data"];
    AppDelegate *delegates=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegates.riliArray=array;
    
    UIStoryboard *story  = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    pageViewController=[story instantiateViewControllerWithIdentifier:@"ViewController"];
    [self addChildViewController:pageViewController];
    
    firstViewController = [[FoundViewController alloc]init];
    firstViewController.backBtn.hidden=YES;
    [self addChildViewController:firstViewController];
    
    secondViewController = [[ViewController alloc]init];
    //secondViewController.backBtn.hidden=YES;
    [self addChildViewController:secondViewController];
    
    friendViewController=[[FriendViewController alloc]init];
    friendViewController.backBtn.hidden=YES;
    [self addChildViewController:friendViewController];
    
    thirdViewController = [[MyselfViewController alloc]init];
    [self addChildViewController:thirdViewController];
    
    myLogInViewController = [[MyLogInViewController alloc]init];
    // myLogInViewController..vCLID=0;
    [self addChildViewController:myLogInViewController];
    
    [mainView addSubview:pageViewController.view];
    currentViewController = pageViewController;

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
    //bottomView.backgroundColor=[UIColor whiteColor];
    //bottomView.alpha=0.70;
    [self.view addSubview:bottomView];
    
    UIButton *button=[[UIButton alloc]initWithFrame:FRAME((WIDTH-94/2)/2, HEIGHT-54, 49, 49)];
    [button setImage:[UIImage imageNamed:@"QX"] forState:UIControlStateNormal];
    button.layer.cornerRadius=button.frame.size.width/2;
    [button addTarget:self action:@selector(bottomButton) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:button];
    
    UIButton *secretaryButton=[[UIButton alloc]initWithFrame:FRAME((WIDTH-184/2)/2, 180/2, 184/2, 184/2)];
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
//    NSArray *array=@[@"CL",@"HY",@"SW",@"YYTZ",@"JZ",@"GD"];
//    NSArray *labelArray=@[@"差旅规划",@"会议安排",@"事务提醒",@"邀约通知",@"秘书叫早",@"更多服务"];
    NSArray *array=@[@"SW",@"HY",@"JZ",@"YYTZ",@"CL",@"GD"];
    NSArray *labelArray=@[@"事务提醒",@"会议安排",@"通知公告",@"面试邀约",@"差旅规划",@"发布动态"];
    int Y=secretaryButton.frame.origin.y+secretaryButton.frame.size.height+57;
    int a=0;
    for (int i=0; i<6; i++) {
        if (i%3==0&&i!=0) {
            Y=Y+145;
            a=0;
            UIButton *button=[[UIButton alloc]initWithFrame:FRAME((WIDTH-72*3)/4+((WIDTH-72*3)/4+72)*a, Y, 72, 72)];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=1000+i;
            [button setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
            [bottomView addSubview:button];
            UILabel *label=[[UILabel alloc]initWithFrame:FRAME((WIDTH-72*3)/4+((WIDTH-72*3)/4+72)*a, Y+72+24/2, 72, 15)];
            label.text=labelArray[i];
            label.font=[UIFont fontWithName:@"Arial" size:15];
            label.textAlignment=1;
            [bottomView addSubview:label];
            
        }else
        {
            UIButton *button=[[UIButton alloc]initWithFrame:FRAME((WIDTH-72*3)/4+((WIDTH-72*3)/4+72)*a, Y, 72, 72)];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=1000+i;
            [button setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
            [bottomView addSubview:button];
            UILabel *label=[[UILabel alloc]initWithFrame:FRAME((WIDTH-72*3)/4+((WIDTH-72*3)/4+72)*a, Y+72+24/2, 72, 15)];
            label.text=labelArray[i];
            label.font=[UIFont fontWithName:@"Arial" size:15];
            label.textAlignment=1;
            [bottomView addSubview:label];
        }
        a++;
    }
    
}
- (void)makeTabbarView
{
    
    
    
//    UILabel *lable = [[UILabel alloc]initWithFrame:FRAME(0, SELF_VIEW_HEIGHT-50, SELF_VIEW_WIDTH, 1)];
//    lable.backgroundColor = [UIColor grayColor];
//    lable.tag = 777;
//    lable.alpha = 0.3;
//
//    [self.view addSubview:lable];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, HEIGHT-57, WIDTH, 7)];
    imageView.image=[UIImage imageNamed:@"common_bt_divider@2x"];
    [self.view addSubview:imageView];
    [self tabBarAction];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddFication:) name:@"RETURN" object:nil];
    
    
}

-(void)tabBarAction
{
    [tab removeFromSuperview];
    NSArray *barArr = @[@"首页",@"发现",@"",@"圈子",@"我的"];
    NSArray *imagesArray =@[@"common_icon_home@2x",@"common_icon_find@2x",@"common_icon_more@2x",@"common_icon_chum@2x",@"common_icon_mine@2x"];
    float _btnwidth = self.view.frame.size.width/5;
    tab=[[UIView alloc]initWithFrame:CGRectMake(0, SELF_VIEW_HEIGHT-49, SELF_VIEW_WIDTH, 49)];
    tab.backgroundColor=[UIColor whiteColor];
    //tab.alpha=1;
    [self.view addSubview:tab];
    for (int i=0; i<barArr.count; i++) {
        if (i!=2) {
            UIButton *tabBarBut=[UIButton buttonWithType:UIButtonTypeCustom];
            tabBarBut.frame=CGRectMake(_btnwidth*i, 0, _btnwidth, 49);
            //tabBarBut.backgroundColor=[UIColor redColor];
            [tabBarBut addTarget:self action:@selector(SelectBarbtnWithtag:) forControlEvents:UIControlEventTouchUpInside];
            [tabBarBut setTag:(1000+i)];
            [tab addSubview:tabBarBut];
            if (i==0) {
                pageImage.frame=CGRectMake((_btnwidth-23)/2, 4.5, 23, 23);
                pageImage.image=[UIImage imageNamed:@"common_icon_home_c@2x"];
                [tabBarBut addSubview:pageImage];
                //tab.hidden=YES;
                pageLabel.frame=CGRectMake((_btnwidth-23)/2, 7.5+24, 23, 10);
                pageLabel.text=[barArr objectAtIndex:i];
                pageLabel.textAlignment=NSTextAlignmentCenter;
                pageLabel.font=[UIFont fontWithName:@"Arial" size:10];
                pageLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                [tabBarBut addSubview:pageLabel];
                
            }else if(i==1)
            {
                foundImage.frame=CGRectMake((_btnwidth-23)/2,4.5, 23, 23);
                foundImage.image=[UIImage imageNamed:imagesArray[i]/*@"tab-home-pressdown"*/];
                [tabBarBut addSubview:foundImage];
                
                foundLabel.frame=CGRectMake((_btnwidth-23)/2, 7.5+24, 23, 10);
                foundLabel.text=[barArr objectAtIndex:i];
                foundLabel.textAlignment=NSTextAlignmentCenter;
                foundLabel.font=[UIFont fontWithName:@"Arial" size:10];
                //foundLabel.textColor=[UIColor redColor];
                [tabBarBut addSubview:foundLabel];
            }else if (i==3){
                friendImage.frame=CGRectMake((_btnwidth-23)/2,4.5, 23, 23);
                friendImage.image=[UIImage imageNamed:imagesArray[i]];
                [tabBarBut addSubview:friendImage];
                
                friendLabel.frame=CGRectMake((_btnwidth-23)/2, 7.5+24, 23, 10);
                friendLabel.text=[barArr objectAtIndex:i];
                friendLabel.textAlignment=NSTextAlignmentCenter;
                friendLabel.font=[UIFont fontWithName:@"Arial" size:10];
                //friendLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                [tabBarBut addSubview:friendLabel];
            }else if (i==4){
                meImage.frame=CGRectMake((_btnwidth-23)/2,4.5, 23, 23);
                meImage.image=[UIImage imageNamed:imagesArray[i]];
                [tabBarBut addSubview:meImage];
                meLabel.frame=CGRectMake((_btnwidth-23)/2, 7.5+24, 23, 10);
                meLabel.text=[barArr objectAtIndex:i];
                meLabel.font=[UIFont fontWithName:@"Arial" size:10];
                meLabel.textAlignment=NSTextAlignmentCenter;
                [tabBarBut addSubview:meLabel];
                
            }
        }else
        {
            UIButton *tabBarBut=[UIButton buttonWithType:UIButtonTypeCustom];
            tabBarBut.frame=CGRectMake(_btnwidth*i+_btnwidth/2-49/2, -5, 49, 49);
            tabBarBut.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
            tabBarBut.layer.cornerRadius=49/2;
            [tabBarBut setImage:[UIImage imageNamed:imagesArray[i]] forState:UIControlStateNormal];
            [tabBarBut addTarget:self action:@selector(SelectBarbtnWithtag:) forControlEvents:UIControlEventTouchUpInside];
            [tabBarBut setTag:(1000+i)];
            [tab addSubview:tabBarBut];
        }
        
    }

}
- (void)AddFication:(NSNotification *)obj
{
    [self makeTabbarView];
    
}
- (void)SelectBarbtnWithtag:(UIButton *)sender
{
    NSLog(@"按钮的tag值%ld",(long)sender.tag);
    if ((currentViewController==pageViewController&&[sender tag]==1000)||(currentViewController==firstViewController&&[sender tag]==1001)||(currentViewController==secondViewController&&[sender tag]==1002) ||(currentViewController==friendViewController&&[sender tag]==1003)||(currentViewController==thirdViewController&&[sender tag]==1004) ) {
        return;
    }
    UIViewController *oldViewController=currentViewController;
    
    //[@"common_icon_home@2x",@"common_icon_find@2x",@"common_icon_more@2x",@"common_icon_chum@2x",@"common_icon_mine@2x"
    switch (sender.tag) {
        case 1000:
        {
            indexesID=0;
            [self transitionFromViewController:currentViewController toViewController:pageViewController duration:0.5 options:0 animations:^{
            }  completion:^(BOOL finished) {
                if(finished){
                    currentViewController=pageViewController;
                    pageImage.image=[UIImage imageNamed:@"common_icon_home_c@2x"];
                    pageLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
                    foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
                    foundLabel.textColor=[UIColor blackColor];
                    
                    friendImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
                    friendLabel.textColor=[UIColor blackColor];
                    
                    meImage.image=[UIImage imageNamed:@"common_icon_mine@2x"];
                    meLabel.textColor=[UIColor blackColor];
                }else{
                    currentViewController=pageViewController;
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
//            if (self.loginYesOrNo == YES) {
//
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"PUSHTOCHAT" object:nil];
//
//                
//            }
            indexesID=1;
            self.backBtn.hidden=YES;
            [self transitionFromViewController:currentViewController toViewController:secondViewController duration:0.5 options:0 animations:^{
                
            }  completion:^(BOOL finished) {
                if (finished) {
                    currentViewController=secondViewController;
                    [UIView beginAnimations:@"Animation" context:nil];
                    [UIView setAnimationDuration:1];
                    tab.hidden=YES;
                    [UIView commitAnimations];
                    bottomView.hidden=NO;
                }else{
                    currentViewController=oldViewController;
                    
                }
            }];
        }
            break;
        case 1003:
        {
            indexesID=0;
//            if (self.loginYesOrNo==YES) {
//               // [[NSNotificationCenter defaultCenter] postNotificationName:@"PUSHTOCHAT" object:nil];
//                friendViewController=[[FriendViewController alloc]init];
//                [self.navigationController pushViewController:friendViewController animated:YES];
//            }else{
//                [self transitionFromViewController:currentViewController toViewController:secondViewController duration:0.5 options:0 animations:^{
//                    
//                }  completion:^(BOOL finished) {
//                    if (finished) {
//                        currentViewController=secondViewController;
//                    }else{
//                        currentViewController=oldViewController;
//                        
//                    }
//                }];
//            }
            
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
//            if (self.loginYesOrNo == YES) {
            indexesID=0;
            //thirdViewController.rootId=1;
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

                
//            }else{
//                [self transitionFromViewController:currentViewController toViewController:myLogInViewController duration:0.5 options:0 animations:^{
//                    
//                                    }  completion:^(BOOL finished) {
//                                        if (finished) {
//                                            currentViewController=myLogInViewController;
//                                            pageImage.image=[UIImage imageNamed:@"common_icon_home@2x"];
//                                            pageLabel.textColor=[UIColor blackColor];
//                                            
//                                            foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
//                                            foundLabel.textColor=[UIColor blackColor];
//                                            
//                                            friendImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
//                                            friendLabel.textColor=[UIColor blackColor];
//                                            
//                                            meImage.image=[UIImage imageNamed:@"common_icon_mine_c@2x"];
//                                            meLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
//                                        }else{
//                                            pageImage.image=[UIImage imageNamed:@"common_icon_home@2x"];
//                                            pageLabel.textColor=[UIColor blackColor];
//                                            
//                                            foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
//                                            foundLabel.textColor=[UIColor blackColor];
//                                            
//                                            friendImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
//                                            friendLabel.textColor=[UIColor blackColor];
//                                            
//                                            meImage.image=[UIImage imageNamed:@"common_icon_mine_c@2x"];
//                                            meLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
//                                            
//                                            
//                                        }
//                                    }];
//
//                
//            }
                    }
            break;
    
        default:
            break;
    }

    
}

- (void)LoginReturn:(NSNotification *)noti
{
    currentViewController=pageViewController;
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
    currentViewController=pageViewController;
    pageImage.image=[UIImage imageNamed:@"common_icon_home_c@2x"];
    pageLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    
    foundImage.image=[UIImage imageNamed:@"common_icon_find@2x"];
    foundLabel.textColor=[UIColor blackColor];
    
    friendImage.image=[UIImage imageNamed:@"common_icon_chum@2x"];
    friendLabel.textColor=[UIColor blackColor];
    
    meImage.image=[UIImage imageNamed:@"common_icon_mine@2x"];
    meLabel.textColor=[UIColor blackColor];
    [mainView addSubview:pageViewController.view];
    [self tabBarAction];
}

#pragma mark 循环按钮的点击方法
-(void)buttonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 1000:
        {
            vcs=[[MeetingViewController alloc]init];
            vcs.vcID=1002;
            [self.navigationController pushViewController:vcs animated:YES];
        }
            break;
        case 1001:
        {
            vcs=[[MeetingViewController alloc]init];
            vcs.vcID=sender.tag;
            [self.navigationController pushViewController:vcs animated:YES];
        }
            break;
        case 1002:
        {
            vcs=[[MeetingViewController alloc]init];
            vcs.vcID=1004;
            [self.navigationController pushViewController:vcs animated:YES];
            

        }
            break;
        case 1003:
        {
            vcs=[[MeetingViewController alloc]init];
            vcs.vcID=sender.tag;
            [self.navigationController pushViewController:vcs animated:YES];

        }
            break;
        case 1004:
        {
            vc=[[BookingViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            

        }
            break;
        case 1005:
        {
            UpLoadViewController *vcd=[[UpLoadViewController alloc]init];
//            vcd.vcID=sender.tag;
            [self.navigationController pushViewController:vcd animated:YES];
        }
            break;
//        case 1006:
//        {
//           
//            
//        }
//            break;
            
        default:
            break;
    }
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
        SeekViewController *seekVC=[[SeekViewController alloc]init];
        [self.navigationController pushViewController:seekVC animated:YES];
    }else
    {
        NSDictionary *dic=[sender objectForKey:@"data"];
        ChatViewController *vcr=[[ChatViewController alloc]initWithChatter:[dic objectForKey:@"im_sec_username"] isGroup:NO];
        vcr.title=[NSString stringWithFormat:@"%@",[dic objectForKey:@"im_sec_nickname"]];
        [vcr.navigationController setNavigationBarHidden:NO];
        //NSLog(@"%@,,,%@",[dict objectForKey:@"im_sec_nickname"],[dict objectForKey:@"im_sec_username"]);
        [self.navigationController pushViewController:vcr animated:YES];
    }
    
}
-(void)FailDownload:(id)sender
{
    
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
