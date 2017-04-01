//
//  MyLogInViewController.m
//  simi
//
//  Created by zrj on 15-3-17.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "MyLogInViewController.h"
#import "ChoiceDefine.h"
#import "MBProgressHUD+Add.h"
#import "DownloadManager.h"
#import "ISLoginManager.h"
#import "BaiduMobStat.h"
#import "AppDelegate.h"
#import "WeiXinPay.h"
#import "ImgWebViewController.h"

#import "WXApi.h"
#import "WeiboSDK.h"
#import "MineViewController.h"
#import "LoginViewController.h"
#import "ChatViewController.h"
#import "RootViewController.h"
#import "WaterListViewController.h"
#import "CardPageViewController.h"
#import "LeaveListViewController.h"
#import "WasteRecoveryViewController.h"
#import "FriendsHomeViewController.h"
#import "SettingsViewController.h"
@interface MyLogInViewController ()
<
UITextFieldDelegate,
TencentSessionDelegate,
WBHttpRequestDelegate,
appDelegate
>
{
    UIView *view;
    UIButton *btn;
    UIButton * noGetbtn;
    NSInteger secondsDown;
    NSTimer *countDownTimer;
    UITextField *textField;
    
    int wxID;
    NSDictionary *cGDic;
    CLLocationManager *_locationManager;
    NSString *id3is;
    
}
@end
@implementation MyLogInViewController
@synthesize leiMing,
            tencentOAuth = _tencentOAuth;
-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"免费注册与登录", nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"免费注册与登录", nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}
- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back) name:@"WEIXINDENGLU_CG" object:nil];
    if (self.loginYesOrNo == YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN_SUCCESS" object:nil];

        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        if (delegate.pushURl==nil) {
            
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"URLOPEN" object:delegate.pushURl];
        }
    }
    
//    self.navlabel.text = @"快速注册与登录";
}
-(void)urlAction:(NSNotification *)sender
{
    NSLog(@"我去  我去 我去 ！");
    NSDictionary *helpDic;
    NSURL *url=sender.object;
    NSString *stringUrl=[NSString stringWithFormat:@"%@",url];
    NSLog(@"%@",url.query);
//    if([stringUrl rangeOfString:@"http://www.bolohr.com/d/open.html?"].location !=NSNotFound)
//    {
        NSString *urlStr=[NSString stringWithFormat:@"%@",url.query];
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
                pageViewVC.tyPeStr=url.query;
                pageViewVC.navlabelName=@"事务提醒";
                //                UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
                //                pageViewVC=[storys instantiateInitialViewController];
                pageViewVC.vcID=1003;
                [self.navigationController pushViewController:pageViewVC animated:YES];
                
            }else if ([[tempDic objectForKey:@"action"] isEqualToString:@"meeting"]){
                
                helpDic=@{@"action":@"meeting"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
                CardPageViewController *pageViewVC=[[CardPageViewController alloc]init];
                pageViewVC.tyPeStr=url.query;
                pageViewVC.navlabelName=@"会议安排";
                //                UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
                //                pageViewVC=[storys instantiateInitialViewController];
                pageViewVC.vcID=1001;
                [self.navigationController pushViewController:pageViewVC animated:YES];
                
                
            }else if ([[tempDic objectForKey:@"action"] isEqualToString:@"notice"]){
                
                helpDic=@{@"action":@"notice"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
                CardPageViewController *pageViewVC=[[CardPageViewController alloc]init];
                pageViewVC.tyPeStr=url.query;
                pageViewVC.navlabelName=@"通知公告";
                //                UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
                //                pageViewVC=[storys instantiateInitialViewController];
                pageViewVC.vcID=1002;
                [self.navigationController pushViewController:pageViewVC animated:YES];
                
                
            }else if ([[tempDic objectForKey:@"action"] isEqualToString:@"interview"]){
                
                helpDic=@{@"action":@"interview"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
                CardPageViewController *pageViewVC=[[CardPageViewController alloc]init];
                pageViewVC.tyPeStr=url.query;
                pageViewVC.navlabelName=@"面试邀约";
                //                UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
                //                pageViewVC=[storys instantiateInitialViewController];
                pageViewVC.vcID=1004;
                [self.navigationController pushViewController:pageViewVC animated:YES];
                
                
            }else if ([[tempDic objectForKey:@"action"] isEqualToString:@"trip"]){
                
                helpDic=@{@"action":@"trip"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
                CardPageViewController *pageViewVC=[[CardPageViewController alloc]init];
                pageViewVC.tyPeStr=url.query;
                pageViewVC.navlabelName=@"差旅规划";
                //                UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
                //                pageViewVC=[storys instantiateInitialViewController];
                pageViewVC.vcID=1005;
                [self.navigationController pushViewController:pageViewVC animated:YES];
                
                
            }else if ([[tempDic objectForKey:@"action"] isEqualToString:@"feed_add"]){
                
                helpDic=@{@"action":@"punch_sign"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
                CardPageViewController *pageViewVC=[[CardPageViewController alloc]init];
                pageViewVC.tyPeStr=url.query;
                pageViewVC.navlabelName=@"发布动态";
                //                UIStoryboard *storys  = [UIStoryboard storyboardWithName:@"PageStoryboard" bundle:nil];
                //                pageViewVC=[storys instantiateInitialViewController];
                pageViewVC.vcID=1006;
                [self.navigationController pushViewController:pageViewVC animated:YES];
                
                
            }else if ([[tempDic objectForKey:@"action"] isEqualToString:@"leave_pass"]){
                helpDic=@{@"action":@"leave_pass"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
                LeaveListViewController *leaveListVC=[[LeaveListViewController alloc]init];
                leaveListVC.tyPeStr=url.query;
                [self.navigationController pushViewController:leaveListVC animated:YES];
                
                
            }else if ([[tempDic objectForKey:@"action"] isEqualToString:@"feed_add"]){
                
                helpDic=@{@"action":@"feed_add"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HELP" object:helpDic];
                CardPageViewController *pageViewVC=[[CardPageViewController alloc]init];
                pageViewVC.tyPeStr=url.query;
                pageViewVC.vcID=1008;
                [self.navigationController pushViewController:pageViewVC animated:YES];
                
                
            }else if([[tempDic objectForKey:@"action"] isEqualToString:@"water"]){
                
                WaterListViewController *plantsVc=[[WaterListViewController alloc]init];
                plantsVc.tyPeStr=url.query;
                [self.navigationController pushViewController:plantsVc animated:YES];
                
            }else if([[tempDic objectForKey:@"action"] isEqualToString:@"recycle"]){
                WasteRecoveryViewController *plantsVc=[[WasteRecoveryViewController alloc]init];
                plantsVc.wasteID=100;
                plantsVc.tyPeStr=url.query;
                [self.navigationController pushViewController:plantsVc animated:YES];
                
            }else if([[tempDic objectForKey:@"action"] isEqualToString:@"clean"]){
                WasteRecoveryViewController *plantsVc=[[WasteRecoveryViewController alloc]init];
                plantsVc.tyPeStr=url.query;
                plantsVc.wasteID=101;
                [self.navigationController pushViewController:plantsVc animated:YES];
                
            }else if([[tempDic objectForKey:@"action"] isEqualToString:@"teamwork"]){
                
                WasteRecoveryViewController *plantsVc=[[WasteRecoveryViewController alloc]init];
                plantsVc.tyPeStr=url.query;
                plantsVc.wasteID=102;
                [self.navigationController pushViewController:plantsVc animated:YES];
                
            }else if([[tempDic objectForKey:@"action"] isEqualToString:@"express"]){
                
                WasteRecoveryViewController *plantsVc=[[WasteRecoveryViewController alloc]init];
                plantsVc.tyPeStr=url.query;
                plantsVc.wasteID=103;
                [self.navigationController pushViewController:plantsVc animated:YES];
                
            }else if ([[tempDic objectForKey:@"action"] isEqualToString:@"add_friend"]){
                FriendsHomeViewController *vc = [FriendsHomeViewController new];
                vc.friendsID=100;
                vc.view_user_id=[NSString stringWithFormat:@"%@",[tempDic objectForKey:@"params"]];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else{
            WebPageViewController *webVc=[[WebPageViewController alloc]init];
            webVc.barIDS=100;
            webVc.webURL=[NSString stringWithFormat:@"%@",url];
            [self.navigationController pushViewController:webVc animated:YES];
        }
//    }
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    wxID=0;
    self.navigationController.navigationBarHidden=YES;
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
    
   // super.backBtn.hidden=YES;
    self.navlabel.text = @"免费注册与登录";
//    self.title=@"免费注册与登录";
    if (self.loginYesOrNo == YES) {
        [self ymCommunity];
        [self pushToIM];
        if (_vCYMID==101) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SIGNSS" object:nil];
        }
//        RootViewController *vc=[[RootViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
        [self AppdeleAction];
        [self getUserInfo];//1
    }else{
        secondsDown = 60;
        
        
//        self.backBtn.hidden = YES;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back) name:@"MylogVcBack" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToIM) name:@"PUSHTOCHAT" object:nil];
        
        UIView *viewheade=[[UIView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT*0.3)];
        viewheade.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:viewheade];
        UIImageView *headeImage=[[UIImageView alloc]initWithFrame:FRAME((WIDTH-200)/2, (HEIGHT*0.3)/3, 200, (HEIGHT*0.3)/3)];
        headeImage.image=[UIImage imageNamed:@"login_logo"];
        [viewheade addSubview:headeImage];
        
        UIImageView *headImageView=[[UIImageView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT*0.3)];
        NSString *imageUrl=@"http://app.bolohr.com/simi-h5/img/login_logo_update.jpg";
//        [headImageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
        headImageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
        [viewheade addSubview:headImageView];
        
        view = [[UIView alloc]initWithFrame:FRAME(0, 64+HEIGHT*0.3, SELF_VIEW_WIDTH, 1.5+108)];
        view.backgroundColor = HEX_TO_UICOLOR(CHOICE_BACK_VIEW_COLOR, 1.0);
        [self.view addSubview:view];
        
        
        for (int i = 0; i < 2; i++) {
            UIView *vie = [[UIView alloc]initWithFrame:FRAME(0, 0.5+(108/2*i+i*0.5), SELF_VIEW_WIDTH, 108/2)];
            vie.backgroundColor = HEX_TO_UICOLOR(0xFFFFFF, 1.0);
            [view addSubview:vie];
            
            textField = [[UITextField alloc]initWithFrame:FRAME(10, 0.5+(108/2*i+i*0.5), SELF_VIEW_WIDTH, 108/2)];
            textField.backgroundColor = HEX_TO_UICOLOR(0xFFFFFF, 1.0);
            textField.delegate = self;
            textField.tag = 100+i;
            textField.keyboardType=UIKeyboardTypeNumberPad;
            [view addSubview:textField];
            
        }
        
        for (UIView *view1 in view.subviews) {
            if ([view1 isKindOfClass:[UITextField class]]) {
                if (view1.tag == 100) {
                    [(UITextField *)view1 setPlaceholder:@"请输入您的手机号"];
                }
                else if (view1.tag == 101) {
                    [(UITextField *)view1 setPlaceholder:@"请输入验证码"];
                    
                    noGetbtn = [[UIButton alloc]initWithFrame:FRAME(SELF_VIEW_WIDTH - 18 - 162/2-10, 9, 162/2+10, 108/2-18)];
                    [noGetbtn setTitle:@"没有收到？" forState:UIControlStateNormal];
                    [noGetbtn setBackgroundColor:DEFAULT_COLOR];
                    [noGetbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    [noGetbtn.layer setCornerRadius:5.0];
                    noGetbtn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [noGetbtn addTarget:self action:@selector(meishoudao:) forControlEvents:UIControlEventTouchUpInside];
                    [view1 addSubview:noGetbtn];
                    noGetbtn.hidden = YES;
                    view1.userInteractionEnabled = YES;
                }
            }
        }
        
        btn = [[UIButton alloc]initWithFrame:FRAME(SELF_VIEW_WIDTH - 18 - 162/2-10, 9, 162/2+10, 108/2-18)];
        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [btn setBackgroundColor:HEX_TO_UICOLOR(NAV_COLOR, 1.0)];
        [btn.layer setCornerRadius:5.0];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(yanzheng:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        // Do any additional setup after loading the view.
        UIButton *bttn = [UIButton buttonWithType:UIButtonTypeCustom];
        bttn.frame = FRAME(14, view.frame.origin.y+14+108+1.5, WIDTH-28, 41);//(WIDTH-576/2)/2, 5, 576/2, 41
        [bttn setBackgroundColor:HEX_TO_UICOLOR(TEXT_COLOR, 1.0)];
        [bttn setTitle:@"登录" forState:UIControlStateNormal];
        bttn.layer.cornerRadius=5;
        [bttn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bttn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
        //    [bttn.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        [self.view addSubview:bttn];
        
        UILabel *xieyiLab = [[UILabel alloc]initWithFrame:FRAME(14, bttn.bottom+8, WIDTH, 20)];
        //    xieyiLab.text = @"点击“登录”，即表示您同意《有个管家使用协议》";
        xieyiLab.textAlignment = NSTextAlignmentCenter;
        xieyiLab.font = [UIFont systemFontOfSize:12];
        
        NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:@"点击“登录”，即表示您同意《用户使用协议》"];
        [text1 setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1],NSForegroundColorAttributeName, nil] range:NSMakeRange(0, 21)];
        xieyiLab.attributedText = text1;
        [self.view addSubview:xieyiLab];
        
        xieyiLab.userInteractionEnabled = YES;
        UITapGestureRecognizer *xieyiTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(XieYiAction)];
        [xieyiLab addGestureRecognizer:xieyiTap];
        
        UITapGestureRecognizer *first = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewAction)];
        [self.view addGestureRecognizer:first];
#pragma mark 微信登录  qq登陆  新浪登陆
        
        UIView *hengXian = [[UIView alloc]initWithFrame:FRAME(20, xieyiLab.bottom+30, SELF_VIEW_WIDTH-40, 1)];
        hengXian.backgroundColor = [UIColor grayColor];
        hengXian.alpha = 0.5;
        [self.view addSubview:hengXian];
        
        UILabel *logLab = [[UILabel alloc]initWithFrame:FRAME(SELF_VIEW_WIDTH/2-40, xieyiLab.bottom+21, 80, 20)];
        logLab.text = @"一 键 登 录";
        logLab.textColor = [UIColor grayColor];
        logLab.textAlignment = NSTextAlignmentCenter;
        logLab.backgroundColor = HEX_TO_UICOLOR(BAC_VIEW_COLOR, 1.0);
        logLab.font = [UIFont systemFontOfSize:13];
        [self.view addSubview:logLab];
        
        NSArray *arr = [[NSArray alloc]initWithObjects:@"qq_login_pressed",@"wx_login_pressed",@"sina_login_pressed", nil];
        for (int i = 0 ; i < 3 ; i++)
        {
            UIButton *thirdLogin = [[UIButton alloc]initWithFrame:FRAME((WIDTH-75)/4+(50+(WIDTH-75)/4)*i, xieyiLab.bottom+70, 25, 25)];
            thirdLogin.tag = i;
            [thirdLogin setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
            thirdLogin.backgroundColor = [UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
            [thirdLogin addTarget:self action:@selector(thirdLogin:) forControlEvents:UIControlEventTouchUpInside];
            [thirdLogin setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:thirdLogin];
            
            thirdLogin.frame = FRAME((WIDTH-150)/4+(50+(WIDTH-150)/4)*i, xieyiLab.bottom+70, 50, 50);
            //                if (i == 1||i == 2) {
            //                    thirdLogin.hidden = YES;
            //                }else {
            //                    thirdLogin.frame = FRAME((SELF_VIEW_WIDTH - 30)/2, xieyiLab.bottom+70, 30, 30);
            //                }
        }

        
    }
    
    
}




-(void)AppdeleAction
{
    if (_vCLID==100) {
        
    }else if(_vCLID==0)
    {
        ISLoginManager *_manager = [ISLoginManager shareManager];
        NSLog(@"有值么%@",_manager.telephone);
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *_dict=@{@"user_id":_manager.telephone};
        [_download requestWithUrl:USER_INFO dict:_dict view:self.view delegate:self finishedSEL:@selector(QJDowLoadFinish:) isPost:NO failedSEL:@selector(QJDownFail:)];
    }

}
#pragma mark 在沙盒路径下拷贝一份数据库  否则数据库是只读属性  不能修改
- (NSString *)readyDatabase:(NSString *)dbName {
    // First, test for existence.
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:dbName];
    success = [fileManager fileExistsAtPath:writableDBPath];
    
    
    // The writable database does not exist, so copy the default to the appropriate location.
    
    if (!success) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!success) {
            //            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
        
    }
    NSLog(@"%@",writableDBPath);
    return writableDBPath;
}
#pragma mark判断数据库是否存在某张表
-(BOOL)checkName:(NSString *)name{
    
    char *err;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM simi.db where type='table' and name='%@';",name];
    
    const char *sql_stmt = [sql UTF8String];
    
    if(sqlite3_exec(simi, sql_stmt, NULL, NULL, &err) == 1){
        
        return YES;
        
    }else{
        
        return NO;
        
    }
    
}


#pragma mark用户信息详情获取成功方法
-(void)QJDowLoadFinish:(id)sender
{
    NSLog(@"数据详情%@",sender);
    NSDictionary *dic=[sender objectForKey:@"data"];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.globalDic=@{@"user_id":[dic objectForKey:@"id"],@"sec_id":[dic objectForKey:@"sec_id"],@"is_senior":[dic objectForKey:@"is_senior"],@"senior_range":[dic objectForKey:@"senior_range"],@"mobile":[dic objectForKey:@"mobile"],@"user_type":[dic objectForKey:@"user_type"],@"name":[dic objectForKey:@"name"],@"has_company":[dic objectForKey:@"has_company"],@"head_img":[dic objectForKey:@"head_img"],@"company_id":[dic objectForKey:@"company_id"],@"company_name":[dic objectForKey:@"company_name"]};
    NSLog(@"看看是什么啊%@",delegate.globalDic);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL find = [fileManager fileExistsAtPath:delegate.defaultDBPath];
    if (find) {
        if(sqlite3_open([delegate.defaultDBPath UTF8String], &simi) != SQLITE_OK) {
            sqlite3_close(simi);
            NSLog(@"open database fail");
        }
    }
    sqlite3_open([delegate.defaultDBPath UTF8String], &simi);
//    if (sqlReturns) {
//        NSLog(@"chenggong");
//    }else{
//        NSLog(@"shibai ");
//    }
    sqlite3_stmt *dbps ;
    if ([self checkName:@"User"]) {
        
    }else{
        char *sqlCreateTable = "CREATE TABLE User (id INTEGER PRIMARY KEY AUTOINCREMENT, mobile TEXT,third_type TEXT,openid TEXT,name TEXT,id_card TEXT,sex TEXT,head_img TEXT,qr_code TEXT,rest_money REAL,score INTEGER)";
        NSInteger sqlReturn = sqlite3_prepare_v2(simi, sqlCreateTable, -1, &dbps, nil);
        //如果SQL语句解析出错的话程序返回
        if(sqlReturn != SQLITE_OK) {
            NSLog(@"Error: failed to prepare statement:create test table");
        }
        
        //执行SQL语句
        int success = sqlite3_step(dbps);
        //释放sqlite3_stmt
        sqlite3_finalize(dbps);
        
        //执行SQL语句失败
        if ( success != SQLITE_DONE) {
            NSLog(@"Error: failed to dehydrate:create table test");
        }

    }
    
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO User(id,score,client_id,real_name,mobile,third_type,app_id,id_card,birth_day,update_time,openid,head_img,add_from,add_time ,open_id,rest_money,major,degree_id,user_type,province_name,name,channel_id,app_user_id,sex,is_approval,is_new_user)VALUES(%d,%d,'%@','%@','%@','%@','%@','%@','%@',%@,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[[dic objectForKey:@"id"] intValue],[[dic objectForKey:@"score"]intValue],[dic objectForKey:@"client_id"],[dic objectForKey:@"real_name"],[dic objectForKey:@"mobile"],[dic objectForKey:@"third_type"],[dic objectForKey:@"app_id"],[dic objectForKey:@"id_card"],[dic objectForKey:@"birth_day"],[dic objectForKey:@"update_time"],[dic objectForKey:@"openid"],[dic objectForKey:@"head_img"],[dic objectForKey:@"add_from"],[dic objectForKey:@"add_time"],[dic objectForKey:@"open_id"],[dic objectForKey:@"rest_money"],[dic objectForKey:@"major"],[dic objectForKey:@"degree_id"],[dic objectForKey:@"user_type"],[dic objectForKey:@"province_name"],[dic objectForKey:@"name"],[dic objectForKey:@"channel_id"],[dic objectForKey:@"app_user_id"],[dic objectForKey:@"sex"],[dic objectForKey:@"is_approval"],[dic objectForKey:@"is_new_user"]];
    //上边的update也可以这样写：
    //NSString *insert = [NSString stringWithFormat:@"INSERT OR REPLACE INTO PERSIONINFO('%@','%@','%@','%@','%@')VALUES(?,?,?,?,?)",NAME,AGE,SEX,WEIGHT,ADDRESS];
    
//    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO cell (C_ID, C_CITY_ID, C_NAME, C_ADDRESS, C_STORE_ID, C_ADDR_LNG, C_ADDR_LAT, C_OPER_TIME) VALUES (%@, %i, '%@', '%@', 17, '%@', '%@', '%@')",model.cellID,model.city_id,model.cell_name,model.cell_addr,model.addr_lng,model.addr_lat,oper_time];
//    
    const char *insertUTF8 = [insertSQL UTF8String];
    
    int result = sqlite3_prepare_v2(simi, insertUTF8, -1, &dbps, NULL);
    
    if(result == SQLITE_OK){
        NSLog(@"插入成功");
        
        if (sqlite3_step(dbps) == SQLITE_DONE) {
            sqlite3_finalize(dbps);
            NSLog(@"成功");
        }
    }else{
        NSLog(@"插入失败");
    }

    sqlite3_close(simi);
    
}
#pragma mark用户信息详情获取失败方法
-(void)QJDownFail:(id)sender
{
    
}

- (void)ThirdPartyLogSuccessWhitOpenID:(NSString *)openid type:(NSString *)type name:(NSString *)name headImgUrl:(NSString *)imgurl
{
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *param = @{@"openid":openid,@"3rd_type":type,@"name":name,@"head_img":imgurl,@"login_from":@"0",@"login_from":@"ios"};
    
    [_download requestWithUrl:Third_LOG dict:param view:self.view delegate:self finishedSEL:@selector(ThirdPardyLogSuccess:) isPost:YES failedSEL:@selector(DownFail:)];
    
}
-(void)back
{
    if (self.loginYesOrNo==YES) {
        
        [self ymCommunity];
        
//        RootViewController *vc=[[RootViewController alloc]init];
//        vc.is_new_userID=[[cGDic objectForKey:@"is_new_user"]intValue];
//        [self.navigationController pushViewController:vc animated:YES];
        if (_vCYMID==101) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"SIGNSS" object:nil];
        }
        [self.navigationController popViewControllerAnimated:YES];
        _vCLID=0;
        [self AppdeleAction];
        [self userAddress];
        [self getUserInfo];//2
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REMIND_SPOT" object:nil];
        
    }
    //[self.navigationController popViewControllerAnimated:YES];
}

// 6.0 以上调用这个函数
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
    if (self.loginYesOrNo==YES) {
        ISLoginManager *_manager = [ISLoginManager shareManager];
        NSLog(@"有值么%@",_manager.telephone);
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
        NSDictionary *_dict=@{@"user_id":_manager.telephone,@"lat":_latString,@"lng":_lngString,@"poi_name":_addressName,@"city":_cityStr};
        [_download requestWithUrl:ADDRESS_USER dict:_dict view:self.view delegate:self finishedSEL:@selector(AddressFinish:) isPost:YES failedSEL:@selector(QJDownFail:)];
    }
    
}
#pragma mark 获取用户当前地理位置成功返回
-(void)AddressFinish:(id)source
{
    
}
- (void)ThirdPardyLogSuccess:(id)dict
{
    int status = [[dict objectForKey:@"status"] intValue];
    NSDictionary *dataDic = [dict objectForKey:@"data"];
    NSLog(@"%@",dataDic);
    
    //登陆后的信息
    if (status == 0) {
       
        NSString *userid = [dataDic objectForKey:@"id"];
        if ([id3is isEqualToString:@""]) {
            [MobClick profileSignInWithPUID:userid];
        }else{
            [MobClick profileSignInWithPUID:GeTuiSdk.clientId provider:id3is];
        }
        //UITextField *textfield  = (UITextField *) [view viewWithTag:100];
        ISLoginManager *_logmanager = [ISLoginManager shareManager];
        _logmanager.isLogin = YES;
        NSUserDefaults *_default = [NSUserDefaults standardUserDefaults];
        [_default setObject:@"login" forKey:@"islogin"];
        NSUserDefaults *mydefaults = [NSUserDefaults standardUserDefaults];
        [mydefaults setObject:userid forKey:@"telephone"];
        [mydefaults synchronize];
        
//        [self getUserInfo];//3
//        [self dismissViewControllerAnimated:YES completion:nil];
        
//        textfield.text = [textfield.text isEqual:[NSNull null] ]? @"":textfield.text;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"THIRD_LOGIN_SUCCESS" object:[dataDic objectForKey:@"id"]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN_SUCCESS" object:[dataDic objectForKey:@"id"]];
        
//        [self.navigationController popViewControllerAnimated:YES];




        NSString *app_id = [dataDic objectForKey:@"app_id"];
        NSString *channel_id = [dataDic objectForKey:@"channel_id"];
        NSString *app_user_id = [dataDic objectForKey:@"app_user_id"];
        
        if ([app_id isEqualToString:@""] || [channel_id isEqualToString:@""] || [app_user_id isEqualToString:@""]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NO_BAIDUBANGDING" object:nil];
        }
        
    }
    [self back];
}

- (void)viewAction
{
    UITextField *textField1 = (UITextField *)[view viewWithTag:100];
    [textField1 resignFirstResponder];
    UITextField *textField2 = (UITextField *)[view viewWithTag:101];
    [textField2 resignFirstResponder];

}
- (void)XieYiAction
{
    ImgWebViewController *web = [[ImgWebViewController alloc]init];
    web.title = @"用户使用协议";
    web.imgurl = @"http://app.bolohr.com/html/simi-inapp/agreement.htm";
    [self.navigationController pushViewController:web animated:YES];
    
}
- (void)thirdLogin:(UIButton *)sender
{
    NSLog(@"%ld",(long)sender.tag);
    if (sender.tag == 0) {
        
        NSLog(@"qq登陆");
//        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:tencentAPPID andDelegate:self];
//        NSArray * _permissions =  [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
//        [_tencentOAuth authorize:_permissions inSafari:YES];

        
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
        
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],NO,^(UMSocialResponseEntity *response){
            
            //          获取微博用户名、uid、token等
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
                
                NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                NSLog(@"数组里都有啥啊？%@",snsAccount);
                [self ThirdPartyLogSuccessWhitOpenID:snsAccount.openId type:@"qq" name:snsAccount.userName headImgUrl:snsAccount.iconURL];
                id3is=@"QQ";
                
            }});
        
    }else if(sender.tag == 1)
    {
        
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
                
                NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                [self ThirdPartyLogSuccessWhitOpenID:snsAccount.openId type:@"weixin" name:snsAccount.userName headImgUrl:snsAccount.iconURL];
                id3is=@"WX";
            }
            
        });
        [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
            NSLog(@"SnsInformation is %@",response.data);
        }];
    }else
    {
        
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            //          获取微博用户名、uid、token等
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                
                NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                [self ThirdPartyLogSuccessWhitOpenID:snsAccount.usid type:@"weibo" name:snsAccount.userName headImgUrl:snsAccount.iconURL];
                id3is=@"WB";
                
            }});
        
        [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
            NSLog(@"SnsInformation is %@",response.data);
        }];
        
        [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
            NSLog(@"response is %@",response);
        }];

    }
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.viewControllerType == UMSViewControllerOauth) {
        
        NSLog(@"didFinishOauthAndGetAccount response is %@",response);
        
    }
    
}
#pragma mark 新浪微博
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = NSLocalizedString(@"收到网络回调", nil);
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",result]
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
                             otherButtonTitles:nil];
    [alert show];
}
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = NSLocalizedString(@"请求异常", nil);
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",error]
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
                             otherButtonTitles:nil];
    [alert show];
}



#pragma mark 腾讯登陆协议
- (void)tencentDidLogin
{
    NSLog(@"登陆成功");
    [_tencentOAuth getUserInfo];

    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        
        //  记录登录用户的OpenID、Token以及过期时间
        
        NSLog(@"%@腾讯登陆后的数据  token：%@ id:%@",_tencentOAuth.accessToken,_tencentOAuth.openId);
    }
    else
    {
       NSLog(@"登录不成功 没有获取accesstoken");
    }
}
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        NSLog(@"腾讯用户登录取消");
    }
    else
    {
        NSLog(@"腾讯登录失败");
    }
}
-(void)tencentDidNotNetWork
{
   NSLog(@"无网络连接，请设置网络");
}
//获取用户信息
- (void)getUserInfoResponse:(APIResponse *)response
{
    NSString *name = [response.jsonResponse objectForKey:@"nickname"];
    //NSString *xingbie = [response.jsonResponse objectForKey:@"gender"];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[response.jsonResponse objectForKey:@"figureurl_qq_1"]]]];
    [WXgetUserInfo SaveImgage:image];//图片保存到本地
    [self ThirdPartyLogSuccessWhitOpenID:_tencentOAuth.openId type:@"0" name:name headImgUrl:[response.jsonResponse objectForKey:@"figureurl_qq_1"]];

}

- (void)yanzheng:(UIButton *)sender
{
    UITextField *textfield  = (UITextField *) [view viewWithTag:100];
    NSLog(@"手机号： %@",textfield.text);
    NSString *phonestring = textfield.text;
    NSString * MOBILE = @"1[0-9]{10}";
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:phonestring];
    BOOL res2 = [regextestcm evaluateWithObject:phonestring];
    BOOL res3 = [regextestcu evaluateWithObject:phonestring];
    BOOL res4 = [regextestct evaluateWithObject:phonestring];
    if (res1 || res2 || res3 || res4) {
        [self getYanzhengma];
    }
    else
    {
        [MBProgressHUD showError:@"请输入正确的手机号码" toView:self.view];
    }
}
- (void)sureAction:(UIButton *)sender
{
    
    UITextField *textfield  = (UITextField *) [view viewWithTag:100];
    [textfield resignFirstResponder];
    UITextField *textfield1 = (UITextField *) [view viewWithTag:101];
    [textfield1 resignFirstResponder];
    if(textfield.text.length == 0){
        [MBProgressHUD showError:@"请输入手机号" toView:self.view];
        return;
    }
    if(textfield1.text.length == 0){
        [MBProgressHUD showError:@"请输入验证码" toView:self.view];
        return;
    }
    NSLog(@"%@  ==== %@",textfield.text,textfield1.text);
    
    
    

    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict = @{@"mobile":textfield.text,@"sms_token":textfield1.text,@"login_from":@"1"};
    NSLog(@"用户名%@",_dict);
    [_download requestWithUrl:LOGIN_API dict:_dict view:self.view delegate:self finishedSEL:@selector(logDownLoadFinish:) isPost:YES failedSEL:@selector(DownFail:)];
//    RootViewController *vc=[[RootViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 登陆成功
- (void)logDownLoadFinish:(id)string
{
    NSLog(@"登录后信息：%@",string);
    
    cGDic=[string objectForKey:@"data"];
        SIMPLEBaseClass *_base = [[SIMPLEBaseClass alloc]initWithDictionary:string];
    
    
    if (_base.status  == 0) {
        
        UITextField *textfield  = (UITextField *) [view viewWithTag:100];
        
        ISLoginManager *_logmanager = [ISLoginManager shareManager];
        _logmanager.isLogin = YES;
        NSUserDefaults *_default = [NSUserDefaults standardUserDefaults];
        [_default setObject:@"login" forKey:@"islogin"];
        NSUserDefaults *mydefaults = [NSUserDefaults standardUserDefaults];
        [mydefaults setObject:[[string objectForKey:@"data"] objectForKey:@"id"] forKey:@"telephone"];
        [mydefaults synchronize];
        
//        [self getUserInfo];//4
        //[self.navigationController popViewControllerAnimated:YES];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN_SUCCESS" object:textfield.text];
        
//        [self dismissViewControllerAnimated:YES completion:nil];
        
        
        NSString *app_id = [[string objectForKey:@"data"] objectForKey:@"app_id"];
        NSString *channel_id = [[string objectForKey:@"data"] objectForKey:@"channel_id"];
        NSString *app_user_id = [[string objectForKey:@"data"] objectForKey:@"app_user_id"];
        
        if ([app_id isEqualToString:@""] || [channel_id isEqualToString:@""] || [app_user_id isEqualToString:@""]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NO_BAIDUBANGDING" object:nil];
        }
        
//        if ([leiMing isEqualToString:@"首页"]) {
//            [self pushToIM];
//        }

    }
    [self back];
    
}
-(void)GTDownLoadFinish:(id)sender
{
    NSLog(@"成功");
}
-(void)GTDownFail:(id)sender
{
    NSLog(@"失败");
}
- (void)DownFail:(id)string
{
    NSLog(@"erroe is %@",string);
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
    if ([cGDic objectForKey:@"client_id"]==nil||[cGDic objectForKey:@"client_id"]==NULL) {
        ISLoginManager *_manager = [ISLoginManager shareManager];
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *_dict = @{@"user_id":_manager.telephone,@"device_type":@"ios",@"client_id":clientId};
        NSLog(@"用户名%@",_dict);
        [_download requestWithUrl:LOGIN_GTJK dict:_dict view:self.view delegate:self finishedSEL:@selector(GTDownLoadFinish:) isPost:YES failedSEL:@selector(GTDownFail:)];
    }else{
        if ([cGDic objectForKey:@"client_id"]==clientId) {
            
        }else{
            ISLoginManager *_manager = [ISLoginManager shareManager];
            DownloadManager *_download = [[DownloadManager alloc]init];
            NSLog(@"为什么是空的呢？？？？？%@,%@",_manager.telephone,clientId);
            NSDictionary *_dict = @{@"user_id":_manager.telephone,@"device_type":@"ios",@"client_id":clientId};
            NSLog(@"用户名12131314%@",_dict);
            [_download requestWithUrl:LOGIN_GTJK dict:_dict view:self.view delegate:self finishedSEL:@selector(GTDownLoadFinish:) isPost:YES failedSEL:@selector(GTDownFail:)];
        }
    }

    NSLog(@"这回会出来不？？%@",dict);
    int status = [dict[@"status"] intValue];
    
    NSLog(@"hahahhahahah__+++++_____+++++___%@",dict);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TONG_ZHI" object:dict];
    if (status == 0) {
        
        //        UserData  = [[HuanxinBase alloc]initWithDictionary:dict];
        //        APPLIACTION.huanxinBase = UserData;
        //        NSLog(@"环信账号：%@环信密码：%@",UserData.imUsername,UserData.imUserPassword);
        self.hxUserName = [dict objectForKey:@"im_username"];
        self.hxPassword = [dict objectForKey:@"im_password"];
        NSLog(@"环信账号：%@环信密码：%@",self.hxUserName,self.hxPassword);
        
        self.imToUserID = [dict objectForKey:@"im_sec_username"];
        self.imToUserName = [dict objectForKey:@"im_sec_nickname"];
        self.ID =[dict objectForKey:@"id"];
        NSLog(@"%@",self.imToUserName);
        NSLog(@"%@",[dic objectForKey:@"im_sec_nickname"]);
        
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.imToUserID forKey:@"TOHXUSERID"];
        [userDefaults setObject:self.imToUserName forKey:@"TOHXUSERNAME"];
        [userDefaults synchronize];
        
        
#pragma warning 1.8版本 首页主要改动
        ISLoginManager *logManager = [[ISLoginManager alloc]init];
        
        if (logManager.isLogin == YES) {
            

            AppDelegate *app = [[AppDelegate alloc]init];
            app.deletate = self;
            [app huanxin];
            

//            [self pushToIM];
        }
        
    }
    if(status){
        NSLog(@"1");
    }
    if (wxID==1) {
        [self ymCommunity];
//        RootViewController *vc=[[RootViewController alloc]init];
//        [self presentViewController:vc animated:YES completion:nil];
        if (_vCYMID==101) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SIGNSS" object:nil];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)LoginFailNavpush
{
    LoginViewController *log = [[LoginViewController alloc]init];
    //    log.userName = UserData.imUsername;
    //    log.password = UserData.imUserPassword;
    //    [self.navigationController pushViewController:log animated:YES];
    NSLog(@"%@",APPLIACTION.deviceToken);
    [log loginWithUsername:self.hxUserName password:self.hxPassword];
    
}
- (void)LoginSuccessNavPush
{
    //判断是否真人聊天
    //    NSString *imToUserID;
    //    imToUserID = self.imToUserID;
    
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:self.imToUserID isGroup:NO];
    chatVC.title = self.imToUserName;
    [chatVC.navigationController setNavigationBarHidden:NO];
    //[self.navigationController pushViewController:chatVC animated:YES];
    
}

- (void)getUserInfoFail:(id)error
{
    NSLog(@"%@",error);
}

#pragma mark 验证码请求
- (void)getYanzhengma
{
    
    //请求成功之后 开始倒计时
    UITextField *textfield  = (UITextField *) [view viewWithTag:100];
    
    NSUserDefaults *_default = [NSUserDefaults standardUserDefaults];
    [_default setObject:textfield.text forKey:@"telephone"];
    
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *param = @{@"mobile":textfield.text,@"sms_type":@"0"};
    
    [_download requestWithUrl:GET_YANZHENGMA dict:param view:self.view delegate:self finishedSEL:@selector(GetyanzhengmaFinish:) isPost:NO failedSEL:@selector(DownFail:)];
    
    [self numberDown];
}



#pragma mark 获得验证码成功
- (void)GetyanzhengmaFinish:(id)responobject
{
    NSLog(@"object is %@",responobject);
}


#pragma mark 开始倒计时
- (void)numberDown
{
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    btn.backgroundColor = [UIColor grayColor];
    btn.userInteractionEnabled = NO;
}
-(void)timeFireMethod{
    secondsDown--;
    
    [btn setTitle:[NSString stringWithFormat:@"重发验证码%lds",(long)secondsDown] forState:UIControlStateNormal];
    [noGetbtn setHidden:NO];
    if(secondsDown==0){
        [countDownTimer invalidate];
        [btn setBackgroundColor:HEX_TO_UICOLOR(0xE8374A, 1.0)];
        [btn setTitle:@"重发验证码" forState:UIControlStateNormal];
        btn.userInteractionEnabled = YES;
        secondsDown = 60;
        
        noGetbtn.userInteractionEnabled = YES;
    }
}
- (void)meishoudao:(UIButton *)sender{
    
    for (UIView *view1 in view.subviews) {
        if ([view1 isKindOfClass:[UITextField class]]) {
            if (view1.tag == 100) {
                [view1 resignFirstResponder];
                
            }
            else if (view1.tag == 101) {
                
                [view1 resignFirstResponder];
            }
        }
    }
    
    UIButton *tbtn =[[UIButton alloc]init];
    tbtn.frame = FRAME(14, SELF_VIEW_HEIGHT-180, 584/2, 100);
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"私秘提示 \n请检查手机号是否正确，如无误超过60秒仍未收到短信，可能是短信被拦截或网络异常，请稍后重试。"];
    [str setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor],NSForegroundColorAttributeName, nil] range:NSMakeRange(53 , 12)];
    
    [tbtn setAttributedTitle:str forState:UIControlStateNormal];
    tbtn.titleLabel.font = [UIFont systemFontOfSize:13];
    tbtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    tbtn.titleLabel.numberOfLines = 0;
    [tbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [tbtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tbtn];
    
    UILabel *xiahuaxian = [[UILabel alloc]initWithFrame:FRAME(92, tbtn.bottom-20, 83, 0.5)];
    xiahuaxian.backgroundColor = [UIColor blueColor];
    [self.view addSubview:xiahuaxian];
    
}
- (void)call{
    
    for (UIView *view1 in view.subviews) {
        if ([view1 isKindOfClass:[UITextField class]]) {
            if (view1.tag == 100) {
                [view1 resignFirstResponder];
                
            }
            else if (view1.tag == 101) {
                
                [view1 resignFirstResponder];
            }
        }
    }
    
    
    NSString *phoneNum = @"";// 电话号码
    
    phoneNum = APPLIACTION.callNum;
    
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    
    UIWebView *phoneCallWebView;
    
    if ( !phoneCallWebView ) {
        
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        
    }
    
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    
    [self.view addSubview:phoneCallWebView];
}
-(void)ymCommunity
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSLog(@"有值么%@",_manager.telephone);
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict=@{@"user_id":_manager.telephone};
    [_download requestWithUrl:USER_INFO dict:_dict view:self.view delegate:self finishedSEL:@selector(CommunityFinish:) isPost:NO failedSEL:@selector(CommunityFail:)];
    

    

}
-(void)CommunityFinish:(id)source
{
    UMComUserAccount *account = [[UMComUserAccount alloc] initWithSnsType:UMComSnsTypeSelfAccount];
    account.usid =[NSString stringWithFormat:@"%@",[[source objectForKey:@"data"]objectForKey:@"id"]];//用户自己所在系统的uid
    account.name = [NSString stringWithFormat:@"%@",[[source objectForKey:@"data"]objectForKey:@"name"]];
    account.icon_url=[NSString stringWithFormat:@"%@",[[source objectForKey:@"data"]objectForKey:@"head_img"]];
    [UMComLoginManager loginWithLoginViewController:self userAccount:account loginCompletion:nil];
}
-(void)CommunityFail:(id)source
{
    
}
-(void)todoSomething
{
    if (_vCYMID==100) {
        [self dismissViewControllerAnimated:YES completion:nil];
        if (_vcIDsss==1000) {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGOUT" object:nil];
        [[UMComSession sharedInstance] userLogout];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogoutSucceedNotification object:nil];
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error)
         {
             if (error && error.errorCode != EMErrorServerNotLogin)
             {
                 
             }else{
                 SettingsViewController *set = [[SettingsViewController alloc]init];
                 [set logoutAction];
                 NSUserDefaults *_default = [NSUserDefaults standardUserDefaults];
                 [_default removeObjectForKey:@"telephone"];
                 [_default removeObjectForKey:@"islogin"];
                 [_default synchronize];
                 RootViewController *vc=[[RootViewController alloc]init];
                 //            vc.vCLID=100;
                 UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
                 [self presentViewController:nav animated:YES completion:nil];
                 
             }
         } onQueue:nil];

    }else if (_vCYMID==1000){
       
        [self dismissViewControllerAnimated:YES completion:^{
            [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error)
             {
                 if (error && error.errorCode != EMErrorServerNotLogin)
                 {
                     
                 }else{
                     SettingsViewController *set = [[SettingsViewController alloc]init];
                     [set logoutAction];
                     NSUserDefaults *_default = [NSUserDefaults standardUserDefaults];
                     [_default removeObjectForKey:@"telephone"];
                     [_default removeObjectForKey:@"islogin"];
                     [_default synchronize];
                     UIViewController *origin = self.presentingViewController.presentingViewController;
                     if([origin isMemberOfClass:[RootViewController class]]){
                         origin = self.presentingViewController.presentingViewController.presentingViewController;
                     }
                     [origin dismissViewControllerAnimated:NO completion:nil];
                 }
             } onQueue:nil];
        }];

        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RETURN_POP" object:nil];
        
    }
}
- (void)backAction
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething) object:nil];
    [self performSelector:@selector(todoSomething) withObject:nil afterDelay:0.2f];
    
    //    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    
}
//- (void)backAction
//{
//    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"RETURN" object:nil userInfo:nil];
//    
////    [self dismissViewControllerAnimated:YES completion:nil];
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
