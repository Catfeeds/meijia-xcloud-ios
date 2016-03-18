//
//  FriendViewController.m
//  simi
//
//  Created by 白玉林 on 15/7/29.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "FriendViewController.h"
#import "NewsViewController.h"
#import "SecretFriendsViewController.h"
#import "DynamicViewController.h"
#import "ChatListViewController.h"
#import "ApplyFriendsListViewController.h"
@interface FriendViewController ()
{
    UIView *tabBarView;
    UIView *mainView;
    UIView *lineView;
    UIViewController *currentViewController;
    UIButton *newsButton;
    UIButton *secetFriendsButton;
    UIView *spotView;
    UIButton *addBut;
    
}

@end
ChatListViewController *newsViewController;
SecretFriendsViewController *secAccessController;
DynamicViewController *dynamicViewController;
ApplyFriendsListViewController *friendsListViewController;
@implementation FriendViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"好友"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"好友"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.backBtn.hidden=YES;
//    self.navlabel.text=@"好友";
    [self didUnreadMessagesCountChanged];
    
    
#pragma warning 把self注册为SDK的delegate
    [self registerNotifications];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
    [self setupUntreatedApplyCount];
    mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SELF_VIEW_WIDTH, HEIGHT)];
    mainView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:mainView];
    
    dynamicViewController=[[DynamicViewController alloc]init];
    [self addChildViewController:dynamicViewController];
    
    newsViewController=[[ChatListViewController alloc]init];
    [self addChildViewController:newsViewController];
    
    secAccessController=[[SecretFriendsViewController alloc]init];
    [self addChildViewController:secAccessController];
    
    friendsListViewController=[[ApplyFriendsListViewController alloc]init];
    [self addChildViewController:friendsListViewController];
    
    [mainView addSubview:dynamicViewController.view];
    currentViewController = dynamicViewController;
    
    
    tabBarView=[[UIView alloc]initWithFrame:CGRectMake((WIDTH-240)/2, 20, 240, 44)];
   // tabBarView.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    [self.view addSubview:tabBarView];
    
    addBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH-40, 20, 40, 44)];
//    [addBut setTitle:@"添加" forState:UIControlStateNormal];
    [addBut addTarget:self action:@selector(addBUtAction:) forControlEvents:UIControlEventTouchUpInside];
//    addBut.backgroundColor=[UIColor redColor];
    [self.view addSubview:addBut];
    UIImageView *addImageView=[[UIImageView alloc]initWithFrame:FRAME(10, 10, 20, 20)];
    addImageView.image=[UIImage imageNamed:@"iconfont-xinjian"];
    [addBut addSubview:addImageView];
    
    lineView=[[UIView alloc]initWithFrame:FRAME(0, 42, 60, 2)];
    lineView.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [tabBarView addSubview:lineView];
    
    
    UIView *_lineLable = [[UILabel alloc]initWithFrame:FRAME(0, 38, SELF_VIEW_WIDTH, 1)];
    _lineLable.backgroundColor = [UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    //_lineLable.alpha = 0.3;
//    [tabBarView addSubview:_lineLable];
    
    NSArray *nameArray=@[@"动态",@"好友",@"消息",@"申请"];
    for (int i=0; i<nameArray.count; i++) {
        UIButton *tabbarBut=[[UIButton alloc]initWithFrame:FRAME(60*i, 0, 60, 43)];
        [tabbarBut setTitle:nameArray[i] forState:UIControlStateNormal];
        if(i==0){
            [tabbarBut setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
        }else{
            [tabbarBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        if (i==2) {
            spotView=[[UIView alloc]initWithFrame:FRAME(43, 8, 10, 10)];
            spotView.layer.masksToBounds=YES;
            spotView.layer.cornerRadius=spotView.frame.size.width/2;
            spotView.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
            spotView.hidden=YES;
            [tabbarBut addSubview:spotView];
        }
        tabbarBut.titleLabel.font=[UIFont fontWithName:@"Arial" size:15];
        [tabbarBut addTarget:self action:@selector(tabBarButton:) forControlEvents:UIControlEventTouchUpInside];
        [tabbarBut setTag:(1000+i)];
        [tabBarView addSubview:tabbarBut];
        
    }
    
    [self setupUnreadMessageCount];
    // Do any additional setup after loading the view.
}
-(void)addBUtAction:(UIButton *)button
{
    UpLoadViewController *vcd=[[UpLoadViewController alloc]init];
    [self.navigationController pushViewController:vcd animated:YES];
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

-(void)tabBarButton:(UIButton *)sender
{
    if ((currentViewController==dynamicViewController&&[sender tag]==1000)||(currentViewController==secAccessController&&[sender tag]==1001)||(currentViewController==newsViewController&&[sender tag]==1002)||(currentViewController==friendsListViewController&&[sender tag]==1003)) {
        return;
    }
    UIViewController *oldViewController=currentViewController;
    static int currentSelectButtonIndex = 0;
    static int previousSelectButtonIndex=1000;
    currentSelectButtonIndex=(int)sender.tag;
    UIButton *previousBtn=(UIButton *)[self.view viewWithTag:previousSelectButtonIndex];
    [previousBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    previousBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:15];
    UIButton *currentBtn = (UIButton *)[self.view viewWithTag:currentSelectButtonIndex];;
    [currentBtn setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
    currentBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:18];
    previousSelectButtonIndex=currentSelectButtonIndex;
    switch (sender.tag) {
        case 1000:
        {
            addBut.hidden=NO;
            [self transitionFromViewController:currentViewController toViewController:dynamicViewController duration:0.5 options:0 animations:^{
            }  completion:^(BOOL finished) {
                if(finished){
                    
                    currentViewController=dynamicViewController;
                    
                }else{
                    currentViewController=oldViewController;
                   
                }
                
            }];
        }
            break;
        case 1001:
        {
            addBut.hidden=YES;
            [self transitionFromViewController:currentViewController toViewController:secAccessController duration:0.5 options:0 animations:^{
            }  completion:^(BOOL finished) {
                if(finished){
                    currentViewController=secAccessController;
                    
                }else{
                    currentViewController=oldViewController;
                    
                }
                
            }];
        }
            break;
        case 1002:
        {
            addBut.hidden=YES;
            [self transitionFromViewController:currentViewController toViewController:newsViewController duration:0.5 options:0 animations:^{
            }  completion:^(BOOL finished) {
                if(finished){
                    currentViewController=newsViewController;
                    
                }else{
                    currentViewController=oldViewController;
                    
                }
                
            }];
        }
            break;
        case 1003:
        {
            addBut.hidden=YES;
            [self transitionFromViewController:currentViewController toViewController:friendsListViewController duration:0.5 options:0 animations:^{
            }  completion:^(BOOL finished) {
                if(finished){
                    currentViewController=friendsListViewController;
                    
                }else{
                    currentViewController=oldViewController;
                    
                }
                
            }];

        }
            break;
        default:
            break;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame=FRAME(60*(sender.tag-1000), 42, 60, 2);
    [UIView commitAnimations];
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
