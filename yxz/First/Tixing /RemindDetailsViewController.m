//
//  RemindDetailsViewController.m
//  simi
//
//  Created by zrj on 14-12-6.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "RemindDetailsViewController.h"
#import "ChoiceDefine.h"
#import "RemindDetailsCell.h"
#import "RemindView.h"
#import "SetRemindViewController.h"
#import "RemindViewController.h"
#import "DownloadManager.h"
#import "ISLoginManager.h"
#import "BaiduMobStat.h"
#import "MyLogInViewController.h"
#import "LoginViewController.h"
#import "ChatViewController.h"
#import "AppDelegate.h"
@interface RemindDetailsViewController ()<RemindDetailsDelegate,UIAlertViewDelegate,SetRemDelegate,appDelegate,CallDelegate>

@end

@implementation RemindDetailsViewController
@synthesize index,delegate = _delegate;

-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"提醒详情", nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"提醒详情", nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
}

- (void)viewWillAppear:(BOOL)animated{
    [_mytableView reloadData];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navlabel.text = @"提醒详情";
    self.backBtn.hidden = YES;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = FRAME(18, 35, 40, 20);
    //    [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
    //[backBtn setImage:[UIImage imageNamed:@"title_left_back"] forState:UIControlStateNormal];
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(0, (40-20)/2, 10, 20)];
    img.image = [UIImage imageNamed:@"title_left_back"];
    [backBtn addSubview:img];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    RemindView *remindView = [[RemindView alloc]initWithFrame:FRAME(0, NAV_HEIGHT, SELF_VIEW_WIDTH, (196+46)/2) labletext:@"有什么大事小情都可让私秘为您提醒哦！"];
    remindView.delegate = self;
    [self.view addSubview:remindView];
    
    _mytableView = [[UITableView alloc]initWithFrame:FRAME(0, 25+296/2+74/2, SELF_VIEW_WIDTH, 108)];
    _mytableView.delegate = self;
    _mytableView.dataSource = self;
    _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_mytableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:_mytableView];
    
    
    UIButton *bttn = [UIButton buttonWithType:UIButtonTypeCustom];
    bttn.frame = FRAME(14, SELF_VIEW_HEIGHT-14-108/2, 584/2, 108/2);
    [bttn setBackgroundColor:HEX_TO_UICOLOR(ROUND_COLOR, 1.0)];
    [bttn setTitle:@"我知道了" forState:UIControlStateNormal];
    [bttn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bttn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [bttn.layer setCornerRadius:5.0];//设置矩形四个圆角半径
    [self.view addSubview:bttn];
    // Do any additional setup after loading the view.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    RemindDetailsCell *Cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    
    if (Cell == nil) {
        Cell = [[RemindDetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    
    [_mytableView setDelaysContentTouches:NO];
    Cell.delegate = self;
    Cell.backgroundView = nil;
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Cell.timeLab.text = [[[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"]objectAtIndex:index]objectForKey:@"time"];
    
    Cell.dateLab.text = [[[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"]objectAtIndex:index]objectForKey:@"zhouqi"];
    
    Cell.DetailsLab.text = [NSString stringWithFormat:@"提醒时间：%@ %@",[[[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"]objectAtIndex:index]objectForKey:@"date"],[[[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"]objectAtIndex:index]objectForKey:@"time"]];
    
    Cell.tag = indexPath.row;
    
    return Cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
#pragma mark RemindDetailsCell 代理
- (void)editOrdelete:(NSInteger)btnTag
{
    if(btnTag == 0){
        NSLog(@"编辑");
        SetRemindViewController *remind = [[SetRemindViewController alloc]init];
        remind.delegate = self;
        remind.superior = @"提醒详情";
        remind.arrIndex = index;
        remind.week = [[[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"]objectAtIndex:index]objectForKey:@"week"];
        [self.navigationController pushViewController:remind animated:YES];
        
    }else{
        NSLog(@"删除");
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定删除此条提醒吗" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alert show];
 
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 20) {
        MyLogInViewController *log = [[MyLogInViewController alloc]init];
        log.vCLID=0;
        [self.navigationController presentViewController:log animated:YES completion:nil];
        return;
        
    }
    if (buttonIndex == 0) {
        NSLog(@"1111111");
    }else{
        NSLog(@"2222222");
        

        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"]];
        
        NSString *user = [[array objectAtIndex:index] objectForKey:@"user"];
        
        if ([user isEqualToString:@"我"]) {
            
            [self quxiaonotification];
            
            [self deleteUserDefaults];
            
        }else{
            ISLoginManager *logmanager =[[ISLoginManager alloc]init];
            
            NSString *remindId = [[array objectAtIndex:index] objectForKey:@"remindId"];
            
            NSMutableDictionary *sourceDic = [[NSMutableDictionary alloc]init];
            [sourceDic setObject:logmanager.telephone  forKey:@"user_id"];
            [sourceDic setObject:[NSString stringWithFormat:@"%@",remindId]  forKey:@"remind_id"];

            NSLog(@"请求dic = %@",sourceDic);
            
            DownloadManager *_download = [[DownloadManager alloc]init];
            [_download requestWithUrl:[NSString stringWithFormat:@"%@",REMIND_DELETE] dict:sourceDic view:self.view delegate:self finishedSEL:@selector(DownlLoadFinish:) isPost:YES failedSEL:@selector(DownloadFail:)];
            
        }
        
 }
    
}
-(void)DownlLoadFinish:(id)dict
{
    NSLog(@"dict %@",dict);
    int status = [[dict objectForKey:@"status"] intValue];
    if (status == 0) {
        [self deleteUserDefaults];
    }

    
}
-(void)DownloadFail:(id)error
{
    NSLog(@"error %@",error);
}
#pragma mark 删除本地存储的数据
- (void)deleteUserDefaults
{
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"]];
    
    [array removeObjectAtIndex:index];
    
    [[NSUserDefaults standardUserDefaults]setValue:array forKey:@"TIXING"];
    
    [self.delegate RemindDetailsViewControllerDelelegate];
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 解除本地推送
- (void)quxiaonotification
{
    NSArray *narry=[[UIApplication sharedApplication] scheduledLocalNotifications];
    NSUInteger acount=[narry count];
//    UILocalNotification *notificationtag;
    if (acount>0){
        // 遍历找到对应nfkey和notificationtag的通知
        for (int i=0; i<acount; i++){
            UILocalNotification *myUILocalNotification = [narry objectAtIndex:i];
            NSDictionary *userInfo = myUILocalNotification.userInfo;
            NSString *obj = [userInfo objectForKey:@"biaoshi"];
            
            NSString *time = [NSString stringWithFormat:@"%@ %@",[[[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"]objectAtIndex:index]objectForKey:@"date"],[[[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"]objectAtIndex:index]objectForKey:@"time"]];
            
            if ([obj isEqualToString:time])
            {
                // 删除本地通知
                [[UIApplication sharedApplication] cancelLocalNotification:myUILocalNotification];
                break;
            }
        }
    }



}
- (void)next
{

    [self.delegate RemindDetailsBack];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backAction{
    [self.delegate RemindDetailsBack];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)SetRemDelegate
{
    [_mytableView reloadData];
}

#pragma mark 打电话
- (void)CallAction
{
    BOOL login = [self loginYesOrNo];
    if (login == YES) {
        //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"联系我们的客服专线" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        //        alert.tag = 30;
        //        [alert show];
        [self CallTelephone];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 20;
        [alert show];
    }
    
    
}

- (void)CallTelephone
{
    
    
    BOOL login = [self loginYesOrNo];
    if (login == YES) {
        AppDelegate *app = [[AppDelegate alloc]init];
        app.deletate = self;
        [app huanxin];
    }
    else{
        //        [self showAlertViewWithTitle:@"提示" message:@"请先登陆"];
        UIAlertView *LogalertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        LogalertView.tag = 10;
        [LogalertView show];
    }
    
    
}
- (void)LoginFailNavpush
{
//    LoginViewController *log = [[LoginViewController alloc]init];
    //    log.userName = APPLIACTION.huanxinBase.imUsername;;
    //    log.password = APPLIACTION.huanxinBase.imUserPassword;
    //    [self.navigationController pushViewController:log animated:YES];
//    [log loginWithUsername:APPLIACTION.huanxinBase.imUsername password:APPLIACTION.huanxinBase.imUserPassword];
    
}
- (void)LoginSuccessNavPush
{
    
    
    //判断是否真人聊天
    int senior = APPLIACTION.huanxinBase.is_senior;
    
    NSString *imToUserID;
    NSString *imToUsreName;
    
    if (senior == 1) {
        imToUserID = APPLIACTION.huanxinBase.im_senior_username;
        imToUsreName = APPLIACTION.huanxinBase.im_senior_nickname;
    }else{
        imToUserID = APPLIACTION.huanxinBase.im_robot_username;
        imToUsreName = APPLIACTION.huanxinBase.im_robot_nickname;
    }
    
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:imToUserID isGroup:NO];
    chatVC.title = imToUsreName;
    chatVC._baojie = APPLIACTION._baseSource.data.serviceTypes.baojie;
    chatVC._zuofan = APPLIACTION._baseSource.data.serviceTypes.zuofan;
    chatVC._xiyi = APPLIACTION._baseSource.data.serviceTypes.xiyi;
    chatVC._jiadian = APPLIACTION._baseSource.data.serviceTypes.jiadian;
    chatVC._caboli = APPLIACTION._baseSource.data.serviceTypes.caboli;
    chatVC._guandao = APPLIACTION._baseSource.data.serviceTypes.guandao;
    chatVC._xinju = APPLIACTION._baseSource.data.serviceTypes.xinju;
    chatVC.baseData = APPLIACTION.huanxinBase;
    [chatVC.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:chatVC animated:YES];
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
