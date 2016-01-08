//
//  RemindViewController.m
//  simi
//
//  Created by zrj on 14-11-26.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "RemindViewController.h"
#import "RemindView.h"
#import "ChoiceDefine.h"
#import "SetRemindViewController.h"
#import "RemindCell.h"
#import "RemindDetailsViewController.h"
#import "CalendarViewController.h"
#import "DownloadManager.h"
#import "AppDelegate.h"
#import "BaiduMobStat.h"
#import "MyLogInViewController.h"
#import "LoginViewController.h"
#import "ChatViewController.h"
@interface RemindViewController ()<UITableViewDataSource,UITableViewDelegate,SetRemDelegate,RemindDetailsViewControllerDelelegate,CallDelegate,appDelegate>
{
    UITableView *_mytableView;
    NSMutableArray *tixingArray;
    NSIndexPath *hang; //记录选中那一行
}
@end

@implementation RemindViewController

-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"提醒", nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
    [_mytableView reloadData];//此处是为了返回到此页时 消除单元格的选中状态
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"提醒", nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navlabel.text = @"提醒";
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];  //取消所有本地通知
    
//    NSMutableDictionary *sourceDic = [[NSMutableDictionary alloc]init];
//    [sourceDic setObject:@"13520256623"  forKey:@"mobile"];
//     NSLog(@"请求dic = %@",sourceDic);
//    DownloadManager *_download = [[DownloadManager alloc]init];
//    [_download requestWithUrl:[NSString stringWithFormat:@"%@",REMIND_LIST] dict:sourceDic view:self.view delegate:self finishedSEL:@selector(DownlLoadFinish:) isPost:NO failedSEL:@selector(DownloadFail:)];
    
    
    RemindView *remindView = [[RemindView alloc]initWithFrame:FRAME(0, NAV_HEIGHT, SELF_VIEW_WIDTH, (196+46)/2) labletext:@"有什么大事小情都可让私秘为您提醒哦！"];
    remindView.delegate =self;
    [self.view addSubview:remindView];
    
    _mytableView = [[UITableView alloc]initWithFrame:FRAME(0, 25+296/2+74/2, SELF_VIEW_WIDTH, SELF_VIEW_HEIGHT-(20+296/2+74/2)-28-59)];
    _mytableView.delegate = self;
    _mytableView.dataSource = self;
    _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_mytableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:_mytableView];
    
    tixingArray = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"TIXING"]];
    
    NSLog(@"tingxingArray = %@",tixingArray);
    
    UIButton *riliBtn = [[UIButton alloc]initWithFrame:FRAME(SELF_VIEW_WIDTH-19-14, 20+12, 19, 19)];
    [riliBtn setImage:[UIImage imageNamed:@"calendar_@2x"] forState:UIControlStateNormal];
    [riliBtn addTarget:self action:@selector(calendarAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:riliBtn];
    
    
    UIButton *bttn = [UIButton buttonWithType:UIButtonTypeCustom];
    bttn.frame = FRAME(14, SELF_VIEW_HEIGHT-14-108/2, 584/2, 108/2);
    [bttn setBackgroundColor:HEX_TO_UICOLOR(ROUND_COLOR, 1.0)];
    [bttn setTitle:@"添加提醒" forState:UIControlStateNormal];
    [bttn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bttn addTarget:self action:@selector(addRemind) forControlEvents:UIControlEventTouchUpInside];
    [bttn.layer setCornerRadius:5.0];//设置矩形四个圆角半径
    [self.view addSubview:bttn];
    
    // Do any additional setup after loading the view.
}
//- (void)DownlLoadFinish:(id)dict
//{
//    NSLog(@"dict %@",dict);
//}
//- (void)DownloadFail:(id)dict
//{
//    NSLog(@"%@",dict);
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tixingArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    RemindCell *Cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (Cell == nil) {
        Cell = [[RemindCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    
    [_mytableView setDelaysContentTouches:NO];
    Cell.backgroundView = nil;
    Cell.selectionStyle = UITableViewCellSelectionStyleGray;

    NSString *user = [[tixingArray objectAtIndex:indexPath.row]objectForKey:@"user"];
    NSString *zhouqi = [[tixingArray objectAtIndex:indexPath.row]objectForKey:@"zhouqi"];
    if(![user isEqualToString:@"他人"]){
        Cell.renImg.hidden = YES;
    }
    if ([zhouqi isEqualToString:@"一次性活动"]) {
        Cell.sImg.hidden = YES;
    }

    Cell.titleLab.text = [NSString stringWithFormat:@"%@ %@",[[tixingArray objectAtIndex:indexPath.row]objectForKey:@"time"],[[tixingArray objectAtIndex:indexPath.row]objectForKey:@"biaoti"]];

    Cell.detailLab.text = [NSString stringWithFormat:@"%@ 星期%@",[[tixingArray objectAtIndex:indexPath.row]objectForKey:@"date"],[[tixingArray objectAtIndex:indexPath.row]objectForKey:@"week"]];
    

    Cell.tag = indexPath.row;
    
    return Cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    RemindDetailsViewController *details = [[RemindDetailsViewController alloc]init];
    
    details.delegate = self;
    
    details.index = indexPath.row;

    [self.navigationController pushViewController:details animated:YES];

    hang = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    
}

- (void)addRemind
{
    SetRemindViewController *setremind = [[SetRemindViewController alloc]init];
    setremind.delegate = self;
    [self.navigationController pushViewController:setremind animated:YES];
}
- (void)SetRemDelegate
{
    tixingArray = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"TIXING"]];
    [_mytableView reloadData];
}
- (void)RemindDetailsViewControllerDelelegate
{
    tixingArray = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"TIXING"]];
    [_mytableView reloadData];
}
- (void)RemindDetailsBack
{
    tixingArray = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"TIXING"]];
    [_mytableView reloadData];
    [_mytableView selectRowAtIndexPath:hang animated:YES scrollPosition:UITableViewScrollPositionTop];
}
- (void)calendarAction
{
    CalendarViewController *calendar = [[CalendarViewController alloc]init];
    [self.navigationController pushViewController:calendar animated:YES];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 20) {
        MyLogInViewController *log = [[MyLogInViewController alloc]init];
        log.vCLID=0;
        [self.navigationController presentViewController:log animated:YES completion:nil];
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
