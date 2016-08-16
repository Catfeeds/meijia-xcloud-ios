//
//  AppDelegate.m
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import "FirstViewController.h"
#import "RootViewController.h"
#import "DatabaseManager.h"
//#import "APService.h"
#import "GuideViewController.h"
#import "BaiduMobStat.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DownloadManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "ISLoginManager.h"
#import "DownloadManager.h"
#import "RootViewController.h"
//环信

#import "LoginViewController.h"

#import "AppDelegate+EaseMob.h"
#import "AppDelegate+UMeng.h"
#import "AppDelegate+MagicalRecord.h"
//讯飞
#import "iflyMSC/iflySetting.h"
#import "Definition.h"
#import "iflyMSC/IFlySpeechUtility.h"
//百度map
#import "BMKMapManager.h"
#import "WeiXinPay.h"

//qq
#import <TencentOpenAPI/TencentOAuth.h>
//weibo
#import "WeiboSDK.h"

#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
//#import "MobClick.h"
#import "UMSocialSinaSSOHandler.h"
#import "DetailsViewController.h"
#import "UMCheckUpdate.h"
#import "WaterListViewController.h"

#import "Service_hallViewController.h"
#import "Op_ad_hallViewController.h"

#define IosAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
@interface AppDelegate ()<WXApiDelegate>//,WeiboSDKDelegate
{
    UIImageView *splashView;
    
    BMKMapManager * _mapManager;
    
    UINavigationController *navigationController;
    
    NSDictionary *myDic;
    int badge;
    NSDictionary *dateDic;
    
    UIView *imageView;
    NSString *titleLabelStr;
    NSString *timeLabelStr;
    NSString *dataLabelStr;
    NSString *textLabelStr;
    EjectAlertView *ejectView;
    NSString *helpUrl_Str;
    //NSDictionary *dic;
    NSDictionary *dataDic;
    int pushIDs;
    int push_IDs;
    EjectAlertView *pushEjectView;
    NSDictionary *pushDic;
    
    EjectAlertView *newinFormationView;
    NSString *urlw;
    NSString *urlSrt;
    UILocalNotification * localNotify;
    UIBackgroundTaskIdentifier bgTask;
}

@end
#define NotifyActionKey "NotifyAction"
NSString* const NotificationCategoryIdent  = @"ACTIONABLE";
NSString* const NotificationActionOneIdent = @"ACTION_ONE";
NSString* const NotificationActionTwoIdent = @"ACTION_TWO";
@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize stockDataArray = _stockDataArray;
@synthesize tianjinArray = _tianjinArray;
@synthesize callNum;
@synthesize deletate;

@synthesize appKey = _appKey;
@synthesize appSecret = _appSecret;
@synthesize appID = _appID;
@synthesize clientId = _clientId;
@synthesize payloadId = _payloadId;
@synthesize lastPayloadIndex = _lastPaylodIndex;
@synthesize sdkStatus = _sdkStatus;

-(void)registerRemoteNotification {
    
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //IOS8 新的通知机制category注册
        UIMutableUserNotificationAction *action1;
        action1 = [[UIMutableUserNotificationAction alloc] init];
        [action1 setActivationMode:UIUserNotificationActivationModeBackground];
        [action1 setTitle:@"取消"];
        [action1 setIdentifier:NotificationActionOneIdent];
        [action1 setDestructive:NO];
        [action1 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationAction *action2;
        action2 = [[UIMutableUserNotificationAction alloc] init];
        [action2 setActivationMode:UIUserNotificationActivationModeBackground];
        [action2 setTitle:@"回复"];
        [action2 setIdentifier:NotificationActionTwoIdent];
        [action2 setDestructive:NO];
        [action2 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationCategory *actionCategory;
        actionCategory = [[UIMutableUserNotificationCategory alloc] init];
        [actionCategory setIdentifier:NotificationCategoryIdent];
        [actionCategory setActions:@[action1, action2]
                        forContext:UIUserNotificationActionContextDefault];
        
        NSSet *categories = [NSSet setWithObject:actionCategory];
        UIUserNotificationType types = (UIUserNotificationTypeAlert|
                                        UIUserNotificationTypeSound|
                                        UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|
                                                                       UIRemoteNotificationTypeSound|
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|
                                                                   UIRemoteNotificationTypeSound|
                                                                   UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
    
}
-(NSString *)dataFilePath {
    //项目中的数据库文件路径
    NSString*resourcePath =[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"simi.db"];
    
    return resourcePath;
}
#pragma mark 在沙盒路径下拷贝一份数据库  否则数据库是只读属性  不能修改
- (NSString *)readyDatabase:(NSString *)dbName {
    // First, test for existence.
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:dbName];
    success = [fileManager fileExistsAtPath:writableDBPath];
    
    
    // The writable database does not exist, so copy the default to the appropriate location.
    
//    if (!success) {
//        NSString *defaultDBPaths = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
//        success = [fileManager copyItemAtPath:defaultDBPaths toPath:writableDBPath error:&error];
//        if (!success) {
//            //            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
//        }
//        
//    }
    NSLog(@"%@",writableDBPath);
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.defaultDBPath=writableDBPath;
    return writableDBPath;
}

- (void)deleteFileAtPath:(NSString *)filename {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray * myPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * myDocPath = [myPaths objectAtIndex:0];
    NSString *delelteFilePath = [myDocPath stringByAppendingPathComponent:filename];
    NSError *error;
    
    if ([fileManager removeItemAtPath:delelteFilePath error:&error] != YES)
        
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    
}
-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(simi, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(simi);
        NSLog(@"数据库操作数据失败!");
    }
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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
//    NSArray * fontNames=[UIFont familyNames];
//    
//    for(NSString * name in fontNames)
//    {
//        NSLog(@"font name:%@",name);
//    }
    
    
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL find = [fileManager fileExistsAtPath:[self readyDatabase:@"simi.db"]];
    
    if (find) {
        if(sqlite3_open([[self readyDatabase:@"simi.db"] UTF8String], &simi) != SQLITE_OK) {
            sqlite3_close(simi);
            NSLog(@"open database fail");
        }
    }
    if ([self checkName:@"op_ad"]) {
        NSLog(@"有");
    }else{
        NSLog(@"没有啊有");
    }
    
//    
    NSString *cityStr=@"";
    NSString *app_toolsStr=@"";
    NSString *expressStr=@"";
    NSString *xcompany_settingsStr=@"";
    NSString *op_adStr=@"";
    sqlite3_stmt *statement;
    NSString *citySql = @"select max(add_time)  from city";
    if (sqlite3_prepare_v2(simi, [citySql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *_id = (char *)sqlite3_column_text(statement, 0);
            cityStr= [[NSString alloc] initWithUTF8String:_id];
        }
    }
    NSString *app_toolsSql = @"select max(update_time)  from app_tools";
    if (sqlite3_prepare_v2(simi, [app_toolsSql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *_id = (char *)sqlite3_column_text(statement, 0);
            app_toolsStr= [[NSString alloc] initWithUTF8String:_id];
        }
    }
    NSString *expressSql = @"select max(update_time)  from express";
    if (sqlite3_prepare_v2(simi, [expressSql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *_id = (char *)sqlite3_column_text(statement, 0);
            expressStr= [[NSString alloc] initWithUTF8String:_id];
        }
    }
    NSString *xcompany_settingsSql = @"select max(update_time)  from xcompany_setting";
    if (sqlite3_prepare_v2(simi, [xcompany_settingsSql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *_id = (char *)sqlite3_column_text(statement, 0);
            xcompany_settingsStr= [[NSString alloc] initWithUTF8String:_id];
        }
    }
    
    NSString *op_adSql = @"select max(update_time)  from op_ad";
    if (sqlite3_prepare_v2(simi, [op_adSql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *_id = (char *)sqlite3_column_text(statement, 0);
            op_adStr= [[NSString alloc] initWithUTF8String:_id];
        }
    }
    sqlite3_close(simi);
    NSLog(@"%@,%@,%@,%@,%@",cityStr,app_toolsStr,xcompany_settingsStr,xcompany_settingsStr,op_adStr);
    
    
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict=@{@"t_city":cityStr,@"t_apptools":app_toolsStr,@"t_express":expressStr,@"t_assets":xcompany_settingsStr,@"t_opads":op_adStr};
    [_download requestWithUrl:APP_BASIC_DATA dict:_dict view:self.window delegate:self finishedSEL:@selector(Basic_dataSuccess:) isPost:NO failedSEL:@selector(Basic_dataFail:)];
    [self deleteFileAtPath:[self readyDatabase:@"simi.db"]];
    
    self.eventsByDate = [NSMutableDictionary new];
    self.monthsViews = [NSMutableArray new];
    self.riliArray=[[NSMutableArray alloc]init];
//    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = [path objectAtIndex:0];
//    NSString *fileName = [NSString stringWithFormat:@"dr.log"];// 注意不是NSData!
//    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
//    // 先删除已经存在的文件
//    NSFileManager *defaultManager = [NSFileManager defaultManager];
//    [defaultManager removeItemAtPath:logFilePath error:nil];
//    
//    // 将log输入到文件
//    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
//    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    
    NSLog(@"我就看看你走没走--1");
    NSLog(@"有什么：%@",launchOptions);
    NSLog(@"%ld",(long)application.applicationState);

    NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    if(url)
    {
        UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
        view.backgroundColor=[UIColor yellowColor];
        [self.window addSubview:view];
        UILabel *label=[[UILabel alloc]initWithFrame:FRAME(30, 100, WIDTH-60, 100)];
        label.text=[NSString stringWithFormat:@"%@",launchOptions];
        [view addSubview:label];
        NSLog(@"哦案发分不开：1");
        //badge=100;
    }
    NSString *bundleId = [launchOptions objectForKey:UIApplicationLaunchOptionsSourceApplicationKey];
    if(bundleId)
    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ALERT" object:dateDic];
        //badge=100;
        UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
        view.backgroundColor=[UIColor redColor];
        [self.window addSubview:view];
        UILabel *label=[[UILabel alloc]initWithFrame:FRAME(30, 100, WIDTH-60, 100)];
        label.text=[NSString stringWithFormat:@"%@",launchOptions];
        [view addSubview:label];
        NSLog(@"哦案发分不开：2");
    }
#pragma mark  程序杀死点击通知进入app需要走的方法
    localNotify = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if(localNotify)
    {
        NSDictionary *dict=localNotify.userInfo;
        NSDictionary *dic=[dict objectForKey:@"dic"];
        NSString *yes_or_no=[NSString stringWithFormat:@"%@",[dict objectForKey:@"yes_or_no"]];
        
        NSString *actionStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ac"]];
        
        if ([yes_or_no isEqualToString:@"yes"]) {
            NSString *trueStr=[dic objectForKey:@"is"];
            if ([trueStr isEqual:@"true"]) {
                if ([actionStr isEqualToString:@"a"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ALERT" object:dic];
                }else if ([actionStr isEqualToString:@"m"]){
                    if ([[dic objectForKey:@"ca"] isEqualToString:@"app"]) {
                        if ([[dic objectForKey:@"pa"] isEqualToString:@""]) {
                            urlSrt=[NSString stringWithFormat:@"http://www.bolohr.com/d/open.html?category=%@&action=%@",[dic objectForKey:@"ca"],[dic objectForKey:@"aj"]];
                        }else{
                            urlSrt=[NSString stringWithFormat:@"http://www.bolohr.com/d/open.html?category=%@&action=%@&params=%@",[dic objectForKey:@"ca"],[dic objectForKey:@"aj"],[dic objectForKey:@"pa"]];
                        }
                        
                    }else if([[dic objectForKey:@"ca"] isEqualToString:@"h5"]){
                        urlSrt=[NSString stringWithFormat:@"%@",[dic objectForKey:@"go"]];
                    }
                    
                    NSString *ca=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ca"]];
                    NSString *aj=[NSString stringWithFormat:@"%@",[dic objectForKey:@"aj"]];
                    NSString *pa=[NSString stringWithFormat:@"%@",[dic objectForKey:@"pa"]];
                    NSString *go=[NSString stringWithFormat:@"%@",[dic objectForKey:@"go"]];
                    if ((ca==nil||ca==NULL||[ca isEqualToString:@"(null)"])&&(aj==nil||aj==NULL||[aj isEqualToString:@"(null)"])&&(pa==nil||pa==NULL||[pa isEqualToString:@"(null)"])&&(go==nil||go==NULL||[go isEqualToString:@"(null)"])) {
                        
                    }else{
                        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(popAlertView) userInfo:nil repeats:NO];
                    }
                    
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICEPUSH" object:dic];
                }
            }
            
            
        }else{
            pushEjectView.hidden=YES;
            [pushEjectView removeFromSuperview];
            if ([actionStr isEqualToString:@"s"]) {
                //            badge=100;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ALERT" object:dic];
                
            }else if ([actionStr isEqualToString:@"m"]) {
                
                if ([[dic objectForKey:@"ca"] isEqualToString:@"app"]) {
                    if ([[dic objectForKey:@"pa"] isEqualToString:@""]) {
                        urlSrt=[NSString stringWithFormat:@"http://www.bolohr.com/d/open.html?category=%@&action=%@",[dic objectForKey:@"ca"],[dic objectForKey:@"aj"]];
                    }else{
                        urlSrt=[NSString stringWithFormat:@"http://www.bolohr.com/d/open.html?category=%@&action=%@&params=%@",[dic objectForKey:@"ca"],[dic objectForKey:@"aj"],[dic objectForKey:@"pa"]];
                    }
                    
                }else if([[dic objectForKey:@"ca"] isEqualToString:@"h5"]){
                    urlSrt=[NSString stringWithFormat:@"%@",[dic objectForKey:@"go"]];
                }
                
                NSString *ca=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ca"]];
                NSString *aj=[NSString stringWithFormat:@"%@",[dic objectForKey:@"aj"]];
                NSString *pa=[NSString stringWithFormat:@"%@",[dic objectForKey:@"pa"]];
                NSString *go=[NSString stringWithFormat:@"%@",[dic objectForKey:@"go"]];
                if ((ca==nil||ca==NULL||[ca isEqualToString:@"(null)"])&&(aj==nil||aj==NULL||[aj isEqualToString:@"(null)"])&&(pa==nil||pa==NULL||[pa isEqualToString:@"(null)"])&&(go==nil||go==NULL||[go isEqualToString:@"(null)"])) {
                    
                }else{
                    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(popAlertView) userInfo:nil repeats:NO];
                }
                
                //        return;
            }
            
        }
        
        NSLog(@"哦案发分不开：3");
    }
    NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo) 
    {
        UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
        view.backgroundColor=[UIColor brownColor];
        [self.window addSubview:view];
        UILabel *label=[[UILabel alloc]initWithFrame:FRAME(30, 100, WIDTH-60, 100)];
        label.text=[NSString stringWithFormat:@"%@",launchOptions];
        [view addSubview:label];
//        NSLog(@"哦案发分不开：4 ％@",launchOptions);
    }
    
    
    
    
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif)
    {
        UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
        view.backgroundColor=[UIColor grayColor];
        [self.window addSubview:view];
        UILabel *label=[[UILabel alloc]initWithFrame:FRAME(30, 100, WIDTH-60, 100)];
        label.text=[NSString stringWithFormat:@"%@",launchOptions];
        [view addSubview:label];
        NSLog(@"Recieved Notification %@",localNotif);
        NSDictionary* infoDic = localNotif.userInfo;
        NSLog(@"userInfo description=%@",[infoDic description]);
    }
    
    
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    
    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
    
    // [2]:注册APNS
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    // This code will work in iOS 7.0 and below:
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeNewsstandContentAvailability| UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    [self registerRemoteNotification];
    
    [UMSocialData setAppKey:YMAPPKEY];
    
    [UMFeedback setAppkey:YMAPPKEY];
    [MobClick setCrashReportEnabled:YES];
    [MobClick setLogEnabled:YES];
    	
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
//    [MobClick startWithAppkey:YMAPPKEY reportPolicy:BATCH   channelId:@"appmarket-main"];
    UMConfigInstance.appKey = YMAPPKEY;
//    UMConfigInstance.token=YMAPPKEY;
    //UMConfigInstance.secret=nil;
    UMConfigInstance.channelId = @"appmarket-main";
    UMConfigInstance.bCrashReportEnabled=YES;
    UMConfigInstance.ePolicy=SEND_INTERVAL;
//    UMConfigInstance.eSType = E_UM_GAME;
    [MobClick startWithConfigure:UMConfigInstance];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx93aa45d30bf6cba3" appSecret:@"7a4ec42a0c548c6e39ce9ed25cbc6bd7" url:Handlers];
    [UMSocialQQHandler setQQWithAppId:@"1104934408" appKey:@"bRW2glhUCR6aJYIZ" url:QQHandlerss];
    [UMSocialQQHandler setSupportWebView:YES];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"247547429" RedirectURL:SSOHandlers];
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"247547429"
//                                              secret:@"e2d6413a2c1aa9a605d46355ba15cbe4"
//                                         RedirectURL:SSOHandlers];
    
    
    //UMSocial_Sdk_Extra_Frameworks
    //打开调试日志
    [UMSocialData openLog:YES];
    [UMCheckUpdate checkUpdateWithAppkey:YMAPPKEY channel:@"App Store"];
    [UMCommunity setWithAppKey:YMAPPKEY];
    
    APPLIACTION.application = application;
    APPLIACTION.leiName = @"66";
    application.applicationIconBadgeNumber = 0;
    // Add the view controller's view to the window and display.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(baiduBangding) name:@"NO_BAIDUBANGDING" object:nil];
    
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES; // 是否允许截获并发送崩溃信息，请设置YES或者NO
    //    statTracker.channelId = @"AppStore";//设置您的app的发布渠道
    statTracker.logStrategy = BaiduMobStatLogStrategyAppLaunch;//根据开发者设定的发送策略,发送日志
    statTracker.logSendInterval = 1;  //为1时表示发送日志的时间间隔为1小时,当logStrategy设置为BaiduMobStatLogStrategyCustom时生效
    statTracker.logSendWifiOnly = YES; //是否仅在WIfi情况下发送日志数据
    statTracker.sessionResumeInterval = 10;//设置应用进入后台再回到前台为同一次session的间隔时间[0~600s],超过600s则设为600s，默认为30s
    //    statTracker.shortAppVersion  = IosAppVersion; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    statTracker.enableDebugOn = YES; //调试的时候打开，会有log打印，发布时候关闭
    /*如果有需要，可自行传入adid
     NSString *adId = @"add9c6242d";
     if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f){
     adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
     }
     statTracker.adid = adId;
     */
    [statTracker startWithAppId:@"c09edce680"];//设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey  百度统计
    [WXApi registerApp:WXAppKey withDescription:@"simi"];
    if ([WXApi registerApp:WXAppKey withDescription:@"simi"]) {
        NSLog(@"成功");
    }else{
        NSLog(@"失败");
    }
    [self getBeijingcity];
    
    
    //环信
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    
    
    // 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    // 初始化UIDemoDB部分，本db只存储uidemo上的好友申请等信息，不存储im消息。im消息存储已经由sdk处理了，您不需要单独处理。
    [self setupUIDemoDB];
    
    [[EaseMob sharedInstance].chatManager enableDeliveryNotification];
    
    //讯飞
    
    //设置log等级，此处log为默认在app沙盒目录下的msc.log文件
    [IFlySetting setLogFile:LVL_ALL];
    
    //输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    //设置msc.log的保存路径
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",APPID_VALUE,TIMEOUT_VALUE];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];

#pragma warning 百度地图初始化
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"fAiHywRUlugdgRgT2Cf8IIU3"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    // Add the navigation controller's view to the window and display.
    [self.window addSubview:navigationController.view];
    
    
    
    //新浪注册
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:XLAppKey];
    
    
    
    //    //设置默认启动页的停留时间
    [NSThread sleepForTimeInterval:0.0];
    //    //end
    //
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self ChoseRootController];
    
//    UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
//    [self.window addSubview:view];
    
//    UILabel *label=[[UILabel alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT/3)];
//    label.text=@"差旅";
//    label.font=[UIFont fontWithName:@"PingFang TC" size:100];
//    [view addSubview:label];
//    UILabel *label1=[[UILabel alloc]initWithFrame:FRAME(0, HEIGHT/3, WIDTH, HEIGHT/3)];
//    label1.text=@"差旅";
//    label1.font=[UIFont fontWithName:@"Heiti SC" size:100];
//    [view addSubview:label1];
//    
//    
//    UILabel *label2=[[UILabel alloc]initWithFrame:FRAME(0, HEIGHT/3*2, WIDTH, HEIGHT/3)];
//    label2.text=@"差旅";
//    label2.font=[UIFont fontWithName:@"Heiti SC" size:100];
//    [view addSubview:label2];
//    NSArray *familyNames = [UIFont familyNames];
//    for( NSString *familyName in familyNames ){
//        printf( "Family: %s \n", [familyName UTF8String] );
//        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
//        for( NSString *fontName in fontNames ){
//            printf( "\tFont: %s \n", [fontName UTF8String] );
//        }
//    }
    return YES;
}
-(void)openUDIDString{
    
}
#pragma mark----------------APN---------------------
- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    NSLog(@"我就看看你走没走--2");
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noticeLayout:) name:@"NOTICEPUSH" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(imageLayout:) name:@"ALERT" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewShowcase:) name:@"ASDEDSA" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewLayout:) name:@"EJECT" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(helpLayout:) name:@"HELP" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(NewinformationLayout:) name:@"Newinformation" object:nil];
    
    _appID = appID;
    _appKey = appKey;
    _appSecret =appSecret;
    NSError *err = nil;
    
    //[1-1]:通过 AppId、 appKey 、appSecret 启动SDK
    [GeTuiSdk startSdkWithAppId:appID appKey:appKey appSecret:appSecret delegate:self error:&err];
    
    //[1-2]:设置是否后台运行开关
    [GeTuiSdk runBackgroundEnable:YES];
    //[1-3]:设置电子围栏功能，开启LBS定位服务 和 是否允许SDK 弹出用户定位请求
    [GeTuiSdk lbsLocationEnable:NO andUserVerify:NO];
    
}
-(void)NewinformationLayout:(NSNotification *)dataSource
{
//    NSDictionary *dic=dataSource.object;
//    [newinFormationView removeFromSuperview];
//    newinFormationView = [EjectAlertView new];
//    newinFormationView.frame=FRAME(0, 0, WIDTH, HEIGHT);
//    newinFormationView.backgroundColor = [UIColor redColor];
//    [newinFormationView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin];
//    [self.window addSubview:newinFormationView];
//    UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH,100)];
//    view.backgroundColor=[UIColor whiteColor];
////    view.layer.cornerRadius=10;
////    view.clipsToBounds=YES;
//    [newinFormationView addSubview:view];
//    
//    UILabel *titleLabel=[[UILabel alloc]initWithFrame:FRAME(10, 20, WIDTH-40, 20)];
//    titleLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"rt"]];
//    titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:18];
//    [view addSubview:titleLabel];
//    
//    UILabel *textLabel=[[UILabel alloc]initWithFrame:FRAME(30, 50, WIDTH-40, 20)];
//    textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"rc"]];
//    textLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
//    [view addSubview:textLabel];
//    
//    [NSTimer scheduledTimerWithTimeInterval:2.0f
//                                     target:self
//                                   selector:@selector(newinTimerMethod:)
//                                   userInfo:nil
//                                    repeats:NO];
    
    
    NSDictionary *dic=dataSource.object;
    NSLog(@"%@",dic);
    [newinFormationView removeFromSuperview];
    newinFormationView = [EjectAlertView new];
    newinFormationView.frame=FRAME(0, 0, WIDTH, HEIGHT);
    newinFormationView.backgroundColor = [UIColor redColor];
    [newinFormationView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin];
    [self.window addSubview:newinFormationView];
    UIView *grayView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
    grayView.backgroundColor=[UIColor blackColor];
    grayView.alpha=0.4;
    [newinFormationView addSubview:grayView];
    
    UIView *view=[[UIView alloc]initWithFrame:FRAME((WIDTH-WIDTH*0.72)/2, (HEIGHT-356)/2, WIDTH*0.72, WIDTH*0.72*0.70+168)];
    view.backgroundColor=[UIColor whiteColor];
    view.layer.cornerRadius=10;
    view.clipsToBounds=YES;
    [newinFormationView addSubview:view];
    
    UIImageView *headeImageView=[[UIImageView alloc]initWithFrame:FRAME(0, 0, WIDTH*0.72, WIDTH*0.72*0.70)];
    headeImageView.image=[UIImage imageNamed:@"风景切图-iOS750x1334"];
    [view addSubview:headeImageView];
    
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"rt"]];
    titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    [titleLabel setNumberOfLines:1];
    [titleLabel sizeToFit];
    titleLabel.frame=FRAME((WIDTH*0.72-titleLabel.frame.size.width)/2, WIDTH*0.72*0.70+10, titleLabel.frame.size.width, 17);
    [view addSubview:titleLabel];
    
    UILabel *textLabel=[[UILabel alloc]init];
    textLabel.text=[NSString stringWithFormat:@"    %@",[dic objectForKey:@"rc"]];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:textLabel.text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, textLabel.text.length)];
    textLabel.attributedText = attributedString;
    
    UIFont *font=[UIFont fontWithName:@"Heiti SC" size:13];
    textLabel.textColor=[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1];
    textLabel.font=font;
    [textLabel setNumberOfLines:0];
    [textLabel sizeToFit];
    textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake(WIDTH*0.72-20, 90);
    CGSize expectSize = [textLabel sizeThatFits:maximumLabelSize];
    textLabel.frame=FRAME(10, WIDTH*0.72*0.70+37, expectSize.width, expectSize.height);
    [view addSubview:textLabel];
    
    UIView *hengView=[[UIView alloc]initWithFrame:FRAME(0, WIDTH*0.72*0.70+127, WIDTH*0.72, 1)];
    hengView.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [view addSubview:hengView];
    
    
    UIButton *cancelBut=[[UIButton alloc]initWithFrame:FRAME(0, WIDTH*0.72*0.70+128, WIDTH*0.72, 40)];
    cancelBut.backgroundColor=[UIColor whiteColor];
    cancelBut.tag=12;
    [cancelBut addTarget:self action:@selector(newinTimerMethod:) forControlEvents:UIControlEventTouchUpInside];
    cancelBut.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    [cancelBut setTitle:@"我知道了" forState:UIControlStateNormal];
    [cancelBut setTitleColor:[UIColor colorWithRed:17/255.0f green:150/255.0f blue:219/255.0f alpha:1] forState:UIControlStateNormal];
    [view addSubview:cancelBut];
}
-(void)newinTimerMethod:(UIButton *)theTimer
{
    newinFormationView.hidden=YES;
    [newinFormationView removeFromSuperview];
}
-(void)noticeLayout:(NSNotification *)dataSource
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KEYBOARD" object:nil];
    NSDictionary *dic=dataSource.object;
    NSLog(@"%@",dic);
    pushDic=dic;
    [pushEjectView removeFromSuperview];
    helpUrl_Str=[NSString stringWithFormat:@"%@",[dic objectForKey:@"go"]];
    pushEjectView = [EjectAlertView new];
    pushEjectView.frame=FRAME(0, 0, WIDTH, HEIGHT);
    pushEjectView.backgroundColor = [UIColor redColor];
    [pushEjectView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin];
    [self.window addSubview:pushEjectView];
    UIView *grayView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
    grayView.backgroundColor=[UIColor blackColor];
    grayView.alpha=0.4;
    [pushEjectView addSubview:grayView];
    
    UIView *view=[[UIView alloc]initWithFrame:FRAME((WIDTH-WIDTH*0.72)/2, (HEIGHT-356)/2, WIDTH*0.72, WIDTH*0.72*0.70+168)];
    view.backgroundColor=[UIColor whiteColor];
    view.layer.cornerRadius=10;
    view.clipsToBounds=YES;
    [pushEjectView addSubview:view];
    
    UIImageView *headeImageView=[[UIImageView alloc]initWithFrame:FRAME(0, 0, WIDTH*0.72, WIDTH*0.72*0.70)];
    headeImageView.image=[UIImage imageNamed:@"风景切图-iOS750x1334"];
    [view addSubview:headeImageView];
    
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"rt"]];
    titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    [titleLabel setNumberOfLines:1];
    [titleLabel sizeToFit];
    titleLabel.frame=FRAME((WIDTH*0.72-titleLabel.frame.size.width)/2, WIDTH*0.72*0.70+10, titleLabel.frame.size.width, 17);
    [view addSubview:titleLabel];
    
    UILabel *textLabel=[[UILabel alloc]init];
    textLabel.text=[NSString stringWithFormat:@"    %@",[dic objectForKey:@"rc"]];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:textLabel.text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, textLabel.text.length)];
    textLabel.attributedText = attributedString;
    
    UIFont *font=[UIFont fontWithName:@"Heiti SC" size:13];
    textLabel.textColor=[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1];
    textLabel.font=font;
    [textLabel setNumberOfLines:0];
    [textLabel sizeToFit];
    textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake(WIDTH*0.72-20, 90);
    CGSize expectSize = [textLabel sizeThatFits:maximumLabelSize];
    textLabel.frame=FRAME(10, WIDTH*0.72*0.70+37, expectSize.width, expectSize.height);
    [view addSubview:textLabel];
    
    UIView *hengView=[[UIView alloc]initWithFrame:FRAME(0, WIDTH*0.72*0.70+127, WIDTH*0.72, 1)];
    hengView.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [view addSubview:hengView];
    
    UIButton *detailsBut=[[UIButton alloc]initWithFrame:FRAME(0, WIDTH*0.72*0.70+128, (WIDTH*0.72)/2-0.5, 40)];
    detailsBut.backgroundColor=[UIColor whiteColor];
    detailsBut.tag=11;
    [detailsBut addTarget:self action:@selector(ButActiobAction:) forControlEvents:UIControlEventTouchUpInside];
    [detailsBut setTitle:@"了解更多" forState:UIControlStateNormal];
    detailsBut.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    [detailsBut setTitleColor:[UIColor colorWithRed:17/255.0f green:150/255.0f blue:219/255.0f alpha:1] forState:UIControlStateNormal];
    [view addSubview:detailsBut];
    
    UIView *werticalView=[[UIView alloc]initWithFrame:FRAME((WIDTH*0.72)/2-0.5, WIDTH*0.72*0.70+128, 1, 40)];
    werticalView.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [view addSubview:werticalView];
    
    UIButton *cancelBut=[[UIButton alloc]initWithFrame:FRAME((WIDTH*0.72)/2+0.5, WIDTH*0.72*0.70+128, WIDTH*0.72/2-0.5, 40)];
    cancelBut.backgroundColor=[UIColor whiteColor];
    cancelBut.tag=12;
    [cancelBut addTarget:self action:@selector(ButActiobAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelBut.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    [cancelBut setTitle:@"我知道了" forState:UIControlStateNormal];
    [cancelBut setTitleColor:[UIColor colorWithRed:17/255.0f green:150/255.0f blue:219/255.0f alpha:1] forState:UIControlStateNormal];
    [view addSubview:cancelBut];
}
-(void)ButActiobAction:(UIButton *)button
{
    if (button.tag==12) {
        pushEjectView.hidden=YES;
        [pushEjectView removeFromSuperview];
    }else{
        pushEjectView.hidden=YES;
        [pushEjectView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushJump" object:pushDic];
    }

}
-(void)viewLayout:(NSNotification *)dataSource
{
    dataDic=dataSource.object;
    NSLog(@"%@",dataDic);
    [ejectView removeFromSuperview];
    helpUrl_Str=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"goto_url"]];
    ejectView = [EjectAlertView new];
    ejectView.frame=FRAME(0, 0, WIDTH, HEIGHT);
    ejectView.backgroundColor = [UIColor redColor];
    [ejectView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin];
    [self.window addSubview:ejectView];
    UIView *grayView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
    grayView.backgroundColor=[UIColor blackColor];
    grayView.alpha=0.4;
    [ejectView addSubview:grayView];
    
    UIView *view=[[UIView alloc]initWithFrame:FRAME((WIDTH-WIDTH*0.72)/2, (HEIGHT-356)/2, WIDTH*0.72, WIDTH*0.72*0.70+168)];
    view.backgroundColor=[UIColor whiteColor];
    view.layer.cornerRadius=10;
    view.clipsToBounds=YES;
    [ejectView addSubview:view];
    
    UIImageView *headeImageView=[[UIImageView alloc]initWithFrame:FRAME(0, 0, WIDTH*0.72, WIDTH*0.72*0.70)];
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"img_url"]];
    [headeImageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
    [view addSubview:headeImageView];
    
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"title"]];
    titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    [titleLabel setNumberOfLines:1];
    [titleLabel sizeToFit];
    titleLabel.frame=FRAME((WIDTH*0.72-titleLabel.frame.size.width)/2, WIDTH*0.72*0.70+10, titleLabel.frame.size.width, 17);
    [view addSubview:titleLabel];
    
    UILabel *textLabel=[[UILabel alloc]init];
    textLabel.text=[NSString stringWithFormat:@"    %@",[dataDic objectForKey:@"content"]];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:textLabel.text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, textLabel.text.length)];
    textLabel.attributedText = attributedString;
    
    UIFont *font=[UIFont fontWithName:@"Heiti SC" size:13];
    textLabel.textColor=[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1];
    textLabel.font=font;
    [textLabel setNumberOfLines:0];
    [textLabel sizeToFit];
    textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake(WIDTH*0.72-20, 90);
    CGSize expectSize = [textLabel sizeThatFits:maximumLabelSize];
    textLabel.frame=FRAME(10, WIDTH*0.72*0.70+37, expectSize.width, expectSize.height);
    [view addSubview:textLabel];
    
    UIView *hengView=[[UIView alloc]initWithFrame:FRAME(0, WIDTH*0.72*0.70+127, WIDTH*0.72, 1)];
    hengView.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [view addSubview:hengView];
    
    UIButton *detailsBut=[[UIButton alloc]initWithFrame:FRAME(0, WIDTH*0.72*0.70+128, (WIDTH*0.72)/2-0.5, 40)];
    detailsBut.backgroundColor=[UIColor whiteColor];
    detailsBut.tag=11;
    [detailsBut addTarget:self action:@selector(ButActiob:) forControlEvents:UIControlEventTouchUpInside];
    [detailsBut setTitle:@"了解更多" forState:UIControlStateNormal];
    detailsBut.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    [detailsBut setTitleColor:[UIColor colorWithRed:17/255.0f green:150/255.0f blue:219/255.0f alpha:1] forState:UIControlStateNormal];
    [view addSubview:detailsBut];
    
    UIView *werticalView=[[UIView alloc]initWithFrame:FRAME((WIDTH*0.72)/2-0.5, WIDTH*0.72*0.70+128, 1, 40)];
    werticalView.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [view addSubview:werticalView];
    
    UIButton *cancelBut=[[UIButton alloc]initWithFrame:FRAME((WIDTH*0.72)/2+0.5, WIDTH*0.72*0.70+128, WIDTH*0.72/2-0.5, 40)];
    cancelBut.backgroundColor=[UIColor whiteColor];
    cancelBut.tag=12;
    [cancelBut addTarget:self action:@selector(ButActiob:) forControlEvents:UIControlEventTouchUpInside];
    cancelBut.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    [cancelBut setTitle:@"我知道了" forState:UIControlStateNormal];
    [cancelBut setTitleColor:[UIColor colorWithRed:17/255.0f green:150/255.0f blue:219/255.0f alpha:1] forState:UIControlStateNormal];
    [view addSubview:cancelBut];
}
-(void)helpLayout:(NSNotification *)dataSource
{
    NSDictionary *dic=dataSource.object;
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *action=[NSString stringWithFormat:@"%@",[dic objectForKey:@"action"]];
    NSDictionary *_dic = @{@"action":action,@"user_id":_manager.telephone};
    [_download requestWithUrl:USER_HELP dict:_dic view:self.window delegate:self finishedSEL:@selector(HelpSuccess:) isPost:NO failedSEL:@selector(HelpFailure:)];
}

-(void)HelpSuccess:(id)dataSource
{
    NSDictionary *dic=[dataSource objectForKey:@"data"];
    NSString *dataStr=[NSString stringWithFormat:@"%@",[dataSource objectForKey:@"data"]];
    if (dataStr==nil||dataStr==NULL||[dataStr length]==0||[dataStr isEqualToString:@""]) {
        
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EJECT" object:dic];
    }
    
}
-(void)HelpFailure:(id)dataSource
{
    
}

-(void)ButActiob:(UIButton *)button
{
    if (button.tag==12) {
        ejectView.hidden=YES;
        [ejectView removeFromSuperview];
    }else{
        ejectView.hidden=YES;
        [ejectView removeFromSuperview];
        NSDictionary *dic=@{@"webUrl":helpUrl_Str};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WEBURL" object:dic];
    }
    ISLoginManager *manager = [[ISLoginManager alloc]init];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *action=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"action"]];
    NSDictionary *_dict=@{@"user_id":manager.telephone,@"action":action};
    [_download requestWithUrl:USER_HELP_CLICK dict:_dict view:self.window delegate:self finishedSEL:@selector(LeaveSuccess:) isPost:YES failedSEL:@selector(LeaveFail:)];
}
-(void)LeaveSuccess:(id)source
{
    NSLog(@"%@",source);
}
-(void)LeaveFail:(id)source
{
    NSLog(@"%@",source);
}
-(void)imageLayout:(NSNotification *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KEYBOARD" object:nil];
    NSLog(@"可以传递过来么:%@",sender);
    [imageView removeFromSuperview];
    NSDictionary *dic=sender.object;
    NSString *period_name=[NSString stringWithFormat:@"%@",[dic objectForKey:@"period_name"]];
    int period_name_id;
    if (period_name==nil||period_name==NULL||[period_name isEqualToString:@"(null)"]) {
        period_name_id=10;
    }else{
        period_name_id=11;
    }
    NSString *timeStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"st"]];
    NSLog(@"remind_time%@",timeStr);
    long long time=[timeStr longLongValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    NSArray *array = [currentDateStr componentsSeparatedByString:@" "];
    NSString *timeString;
    NSString *dataString;
    if (period_name_id==10) {
        timeString=array[1];
        dataString=array[0];
    }else{
        timeString=[period_name substringFromIndex:period_name.length-5];
        dataString=[period_name substringToIndex:period_name.length-5];;
    }
   
    imageView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
    imageView.backgroundColor=[UIColor whiteColor];
    imageView.userInteractionEnabled=YES;
    [self.window addSubview:imageView];
    
    UIImageView *sceneryImage=[[UIImageView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT*0.54)];
    sceneryImage.image=[UIImage imageNamed:@"风景切图-iOS750x1334"];
    [imageView addSubview:sceneryImage];
    if (dic==nil||dic==NULL) {
        UILabel *titleLabel=[[UILabel alloc]init];
        titleLabel.text=titleLabelStr;
        titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:20];
        [titleLabel setNumberOfLines:1];
        [titleLabel sizeToFit];
        titleLabel.frame=FRAME((WIDTH-titleLabel.frame.size.width)/2, sceneryImage.frame.size.height+10, titleLabel.frame.size.width, 25);
        [imageView addSubview:titleLabel];
        
        UILabel *timeLabel=[[UILabel alloc]init];
        timeLabel.text=timeLabelStr;
        timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:50];
        [timeLabel setNumberOfLines:1];
        [timeLabel sizeToFit];
        timeLabel.frame=FRAME((WIDTH-timeLabel.frame.size.width)/2, titleLabel.frame.origin.y+titleLabel.frame.size.height+15, timeLabel.frame.size.width, 50);
        [imageView addSubview:timeLabel];
        
        UILabel *dataLabel=[[UILabel alloc]init];
        dataLabel.text=dataLabelStr;
        dataLabel.font=[UIFont fontWithName:@"Heiti SC" size:18];
        [dataLabel setNumberOfLines:1];
        [dataLabel sizeToFit];
        dataLabel.frame=FRAME((WIDTH-dataLabel.frame.size.width)/2, timeLabel.frame.origin.y+timeLabel.frame.size.height+15, dataLabel.frame.size.width, 18);
        [imageView addSubview:dataLabel];
        
        UILabel *textLabel=[[UILabel alloc]init];
        textLabel.text=textLabelStr;
        UIFont *font=[UIFont fontWithName:@"Heiti SC" size:18];
        textLabel.font=font;
        textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [textLabel setNumberOfLines:2];
        [textLabel sizeToFit];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        
        CGSize size = [textLabel.text boundingRectWithSize:CGSizeMake(WIDTH-20, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        textLabel.frame=FRAME(20, dataLabel.frame.origin.y+dataLabel.frame.size.height+15, WIDTH-40, size.height);
        [imageView addSubview:textLabel];
    }else{
        UILabel *titleLabel=[[UILabel alloc]init];
        titleLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"rt"]];
        titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:20];
        [titleLabel setNumberOfLines:1];
        [titleLabel sizeToFit];
        titleLabel.frame=FRAME((WIDTH-titleLabel.frame.size.width)/2, sceneryImage.frame.size.height+10, titleLabel.frame.size.width, 25);
        [imageView addSubview:titleLabel];
        
        UILabel *timeLabel=[[UILabel alloc]init];
        timeLabel.text=timeString;
        timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:50];
        [timeLabel setNumberOfLines:1];
        [timeLabel sizeToFit];
        timeLabel.frame=FRAME((WIDTH-timeLabel.frame.size.width)/2, titleLabel.frame.origin.y+titleLabel.frame.size.height+15, timeLabel.frame.size.width, 50);
        [imageView addSubview:timeLabel];
        
        UILabel *dataLabel=[[UILabel alloc]init];
        dataLabel.text=dataString;
        dataLabel.font=[UIFont fontWithName:@"Heiti SC" size:18];
        [dataLabel setNumberOfLines:1];
        [dataLabel sizeToFit];
        dataLabel.frame=FRAME((WIDTH-dataLabel.frame.size.width)/2, timeLabel.frame.origin.y+timeLabel.frame.size.height+15, dataLabel.frame.size.width, 18);
        [imageView addSubview:dataLabel];
        
        UILabel *textLabel=[[UILabel alloc]init];
        textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"rc"]];
        UIFont *font=[UIFont fontWithName:@"Heiti SC" size:18];
        textLabel.font=font;
        textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [textLabel setNumberOfLines:2];
        [textLabel sizeToFit];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        
        CGSize size = [textLabel.text boundingRectWithSize:CGSizeMake(WIDTH-20, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        textLabel.frame=FRAME(20, dataLabel.frame.origin.y+dataLabel.frame.size.height+15, WIDTH-40, size.height);
        [imageView addSubview:textLabel];
    }
    
    
    
    UIButton *seeBut=[[UIButton alloc]initWithFrame:FRAME((WIDTH-(WIDTH*0.36*2)-24)/2, HEIGHT-58, WIDTH*0.36, 38)];
    [seeBut setTitle:@"查看详情" forState:UIControlStateNormal];
    [seeBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [seeBut addTarget:self action:@selector(seeButAction) forControlEvents:UIControlEventTouchUpInside];
    
    [seeBut.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [seeBut.layer setCornerRadius:10];
    [seeBut.layer setBorderWidth:2];//设置边界的宽度
    //设置按钮的边界颜色
//    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
//    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){232,55,74,1});
//    [seeBut.layer setBorderColor:color];
    seeBut.layer.borderColor=[[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1]CGColor];
    
    [imageView addSubview:seeBut];
    
    UIButton *knowBut=[[UIButton alloc]initWithFrame:FRAME((WIDTH-(WIDTH*0.36*2)-24)/2+24+WIDTH*0.36, HEIGHT-58, WIDTH*0.36, 38)];
    [knowBut setTitle:@"我知道了" forState:UIControlStateNormal];
    knowBut.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [knowBut addTarget:self action:@selector(knowButAction) forControlEvents:UIControlEventTouchUpInside];
    [knowBut.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [knowBut.layer setCornerRadius:10];
    [knowBut.layer setBorderWidth:2];//设置边界的宽度
    //设置按钮的边界颜色
//    CGColorSpaceRef colorSpaceRefs = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colors = CGColorCreate(colorSpaceRefs, (CGFloat[]){232,55,74,1});
//    [knowBut.layer setBorderColor:colors];
    knowBut.layer.borderColor=[[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1]CGColor];
    [imageView addSubview:knowBut];
    dateDic=dic;
    
//    UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
//    view.backgroundColor=[UIColor blueColor];
//    [self.window addSubview:view];
//    UILabel *label=[[UILabel alloc]initWithFrame:FRAME(30, 100, WIDTH-60, 100)];
//    label.text=[NSString stringWithFormat:@"%@",[localNotify.userInfo objectForKey:@"someKey"]];
//    [view addSubview:label];
//
}
-(void)seeButAction
{
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushJumps" object:dateDic];
    imageView.hidden=YES;
    [imageView removeFromSuperview];
}
-(void)knowButAction
{
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    imageView.hidden=YES;
    [imageView removeFromSuperview];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"我就看看你走没走--3");
    NSString *token = [[deviceToken description]
                       stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    _pushDeviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"deviceToken:%@",_pushDeviceToken);
    
    //微社区
    NSLog(@"----devicetoken------%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                       stringByReplacingOccurrencesOfString: @">" withString: @""]
                                      stringByReplacingOccurrencesOfString: @" " withString: @""]);
    
    // [3]:向个推服务器注册deviceToken
    
    [GeTuiSdk registerDeviceToken:_pushDeviceToken];
}
-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [GeTuiSdk resume];  // 恢复个推SDK运行
    NSError *err = nil;
    [GeTuiSdk startSdkWithAppId:_appID appKey:_appKey appSecret:_appSecret delegate:self error:&err];
    NSLog(@"我就看看你走没走--4");
    
    completionHandler(UIBackgroundFetchResultNewData);
    
}
#pragma mark------------------------APN-------------------------
//启动页
- (void)showWord
{
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [splashView removeFromSuperview];
}
- (void)huanxin
{
    [self loginStateChange:nil];
}
#pragma mark 环信
//登陆状态改变
-(void)loginStateChange:(NSNotification *)notification
{
    //    UINavigationController *nav = nil;
    
    //    [self.deletate navPush];
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    BOOL loginSuccess = [notification.object boolValue];
    
    if (isAutoLogin || loginSuccess) {//登陆成功加载主窗口控制器
        [self.deletate LoginSuccessNavPush]; //登录成功 跳maincontroller
        //加载申请通知的数据
        [[ApplyViewController shareController] loadDataSourceFromLocalDB];
        if (_mainController == nil) {
        }else{
        }
    }else{
        [self.deletate LoginFailNavpush];
    }
    
}
/**
 *百度推送
 **/
#pragma mark  离线通知接收通知方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"我就看看你走没走--5");
    pushIDs=1000;
    push_IDs+=1;
    NSLog(@"%ld",(long)application.applicationState);

    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"userinfo:%@",userInfo);
    NSString *string=[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"a"]];
    
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    NSString *timeStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"re"]];
    dateDic=dic;
    NSLog(@"%@",dateDic);
    NSLog(@"remind_time%@",timeStr);
   
    
    
    if([UIApplication sharedApplication].applicationState ==UIApplicationStateBackground)
    {
        NSString *strings=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ac"]];
        if ([strings isEqualToString:@"s"]) {
            [self alarmClock:dic];
        }else if ([string isEqualToString:@"d"]){
            [self Delete_alarm_clock:dic];
        }
        
    }else if ([UIApplication sharedApplication].applicationState ==UIApplicationStateActive){
        NSLog(@"前台");
    }else{
        NSString *strings=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ac"]];
        NSString *trueStr=[dic objectForKey:@"is"];
        if ([trueStr isEqual:@"true"]) {
            if ([strings isEqualToString:@"a"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ALERT" object:dic];
            }else if ([strings isEqualToString:@"m"]){
                if ([[dic objectForKey:@"ca"] isEqualToString:@"app"]) {
                    if ([[dic objectForKey:@"pa"] isEqualToString:@""]) {
                        urlSrt=[NSString stringWithFormat:@"http://www.bolohr.com/d/open.html?category=%@&action=%@",[dic objectForKey:@"ca"],[dic objectForKey:@"aj"]];
                    }else{
                        urlSrt=[NSString stringWithFormat:@"http://www.bolohr.com/d/open.html?category=%@&action=%@&params=%@",[dic objectForKey:@"ca"],[dic objectForKey:@"aj"],[dic objectForKey:@"pa"]];
                    }
                    
                }else if([[dic objectForKey:@"ca"] isEqualToString:@"h5"]){
                    urlSrt=[NSString stringWithFormat:@"%@",[dic objectForKey:@"go"]];
                }
                
                NSString *ca=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ca"]];
                NSString *aj=[NSString stringWithFormat:@"%@",[dic objectForKey:@"aj"]];
                NSString *pa=[NSString stringWithFormat:@"%@",[dic objectForKey:@"pa"]];
                NSString *go=[NSString stringWithFormat:@"%@",[dic objectForKey:@"go"]];
                if ((ca==nil||ca==NULL||[ca isEqualToString:@"(null)"])&&(aj==nil||aj==NULL||[aj isEqualToString:@"(null)"])&&(pa==nil||pa==NULL||[pa isEqualToString:@"(null)"])&&(go==nil||go==NULL||[go isEqualToString:@"(null)"])) {
                    
                }else{
                    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(popAlertView) userInfo:nil repeats:NO];
                }
                
            }else if ([strings isEqualToString:@"d"]){
                [self Delete_alarm_clock:dic];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICEPUSH" object:dic];
            }
        }

    }

    
    
//    if ([[dic objectForKey:@"ac"] isEqualToString:@"a"]) {
//        badge=100;
//    }
//    int card_id=[[dic objectForKey:@"ci"]intValue];
//    int gTid=0;
//    long long time=[timeStr longLongValue];//因为时差问题要加8小时 == 28800 sec
//    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
//    NSLog(@"date:%@",[detaildate description]);
//    //实例化一个NSDateFormatter对象
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //设定时间格式,这里可以设置成自己需要的格式
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    
//    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
//    
//    NSLog(@"时间是啥%@",currentDateStr);
//    NSArray *nfArray=[[UIApplication sharedApplication]scheduledLocalNotifications];
//    NSUInteger acount=[nfArray count];
//    if (acount>0) {
//        for (int i=0; i<acount; i++) {
//            UILocalNotification *myUILocalNotification=[nfArray objectAtIndex:i];
//            NSDate *dictUser=myUILocalNotification.fireDate;
//            NSDictionary *userInfo=myUILocalNotification.userInfo;
//            NSNumber *obj=[userInfo objectForKey:@"someKey"];
//            
//            NSLog(@"都有嘛东西啊？%@",myUILocalNotification);
//            int mytag=[obj intValue];
//            if (mytag==card_id&&dictUser==detaildate) {
//                gTid=1;
//            }else{
//                gTid=10;
//            }
//        }
//    }
//    NSString *trueStr=[dic objectForKey:@"is"];
//    if ([trueStr isEqual:@"true"]) {
//    }
//    
//    if (gTid!=1) {
//    }else{
//        
//    }

    
    
}
-(void)popAlertViewssss
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"URLOPEN" object:urlw];
}
// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"我就看看你走没走--6");
    [application registerForRemoteNotifications];
    
    //    [self baiduBangding];
}
- (void)baiduBangding{
    NSLog(@"test:%@",APPLIACTION.deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
#pragma mark------------------------APN-------------------------// [3-EXT]:如果APNS注册失败，通知个推服务器
    [GeTuiSdk registerDeviceToken:@""];
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

#pragma mark-----------------APN-----------------
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId  // SDK 返回clientid

{
    
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    _clientId = clientId;
    NSLog(@"ID是什么？？%@",_clientId);
    NSLog(@"test:%@",APPLIACTION.deviceToken);
    _pushDeviceToken=[NSString stringWithFormat:@"%@",APPLIACTION.deviceToken];
    if (_pushDeviceToken) {
        
        [GeTuiSdk registerDeviceToken:_pushDeviceToken];
        
    }
}

-(void)popAlertView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"URLOPEN" object:urlSrt];
}
#pragma  mark 在线接收推送通知
-(void)GeTuiSdkDidReceivePayload:(NSString*)payloadId andTaskId:(NSString*)taskId andMessageId:(NSString *)aMsgId fromApplication:(NSString *)appId

{
    NSLog(@"我就看看你走没走--7");
    
    // [4]: 收到个推消息
        _payloadId =payloadId;
        
        NSData *payload = [GeTuiSdk retrivePayloadById:payloadId]; //根据payloadId取回Payload
        
        NSString *payloadMsg = nil;
        
        if (payload) {
            
            payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                          
                                                  length:payload.length
                          
                                                encoding:NSUTF8StringEncoding];
            
        }
        NSData *jsonData = [payloadMsg dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
    NSLog(@"个推消息内容%@",dic);
    
    NSString *string=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ac"]];
    if ([string isEqualToString:@"s"]) {
        if (pushIDs!=1000) {
             [self alarmClock:dic];
        }
       
    }else if ([string isEqualToString:@"d"]){
        [self Delete_alarm_clock:dic];
    }
    if ([string isEqualToString:@"car-msg"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ASDEDSA" object:dic];
        return;
    }
        if (dic==nil||dic==NULL) {
            return;
        }
    NSString *trueStr=[dic objectForKey:@"is"];
    if ([trueStr isEqual:@"true"]) {
        if (pushIDs!=1000) {
            if ([string isEqualToString:@"a"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ALERT" object:dic];
            }else if ([string isEqualToString:@"m"]){
                if ([[dic objectForKey:@"ca"] isEqualToString:@"app"]) {
                    if ([[dic objectForKey:@"pa"] isEqualToString:@""]) {
                        urlSrt=[NSString stringWithFormat:@"http://www.bolohr.com/d/open.html?category=%@&action=%@",[dic objectForKey:@"ca"],[dic objectForKey:@"aj"]];
                    }else{
                        urlSrt=[NSString stringWithFormat:@"http://www.bolohr.com/d/open.html?category=%@&action=%@&params=%@",[dic objectForKey:@"ca"],[dic objectForKey:@"aj"],[dic objectForKey:@"pa"]];
                    }
                    
                }else if([[dic objectForKey:@"ca"] isEqualToString:@"h5"]){
                    urlSrt=[NSString stringWithFormat:@"%@",[dic objectForKey:@"go"]];
                }
                
                NSString *ca=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ca"]];
                NSString *aj=[NSString stringWithFormat:@"%@",[dic objectForKey:@"aj"]];
                NSString *pa=[NSString stringWithFormat:@"%@",[dic objectForKey:@"pa"]];
                NSString *go=[NSString stringWithFormat:@"%@",[dic objectForKey:@"go"]];
                if ((ca==nil||ca==NULL||[ca isEqualToString:@"(null)"])&&(aj==nil||aj==NULL||[aj isEqualToString:@"(null)"])&&(pa==nil||pa==NULL||[pa isEqualToString:@"(null)"])&&(go==nil||go==NULL||[go isEqualToString:@"(null)"])) {
                    
                }else{
                    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(popAlertView) userInfo:nil repeats:NO];
                }
            }else if ([string isEqualToString:@"d"]){
                [self Delete_alarm_clock:dic];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICEPUSH" object:dic];
            }
        }
    }
    pushIDs=0;
//    NSString *actionStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ac"]];
//    if ([actionStr isEqualToString:@"m"]) {
//        
//       
//        if ([[dic objectForKey:@"ca"] isEqualToString:@"app"]) {
//            if ([[dic objectForKey:@"pa"] isEqualToString:@""]) {
//                urlSrt=[NSString stringWithFormat:@"http://www.bolohr.com/d/open.html?category=%@&action=%@",[dic objectForKey:@"ca"],[dic objectForKey:@"aj"]];
//            }else{
//                urlSrt=[NSString stringWithFormat:@"http://www.bolohr.com/d/open.html?category=%@&action=%@&params=%@",[dic objectForKey:@"ca"],[dic objectForKey:@"aj"],[dic objectForKey:@"pa"]];
//            }
//            
//        }else if([[dic objectForKey:@"ca"] isEqualToString:@"h5"]){
//            urlSrt=[NSString stringWithFormat:@"%@",[dic objectForKey:@"go"]];
//        }
//
//        NSString *ca=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ca"]];
//        NSString *aj=[NSString stringWithFormat:@"%@",[dic objectForKey:@"aj"]];
//        NSString *pa=[NSString stringWithFormat:@"%@",[dic objectForKey:@"pa"]];
//        NSString *go=[NSString stringWithFormat:@"%@",[dic objectForKey:@"go"]];
//        if ((ca==nil||ca==NULL||[ca isEqualToString:@"(null)"])&&(aj==nil||aj==NULL||[aj isEqualToString:@"(null)"])&&(pa==nil||pa==NULL||[pa isEqualToString:@"(null)"])&&(go==nil||go==NULL||[go isEqualToString:@"(null)"])) {
//            
//        }else{
//            if(pushIDs!=1000){
//                [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(popAlertView) userInfo:nil repeats:NO];
//                
//            }
//        }
//        
////        return;
//    }
//    if ([[dic objectForKey:@"ac"] isEqualToString:@"a"]) {
//        badge=100;
//        
//    }else{
//       
//    }
//        
//        NSString *timeStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"re"]];
//        NSLog(@"remind_time%@",timeStr);
////        NSString *card_idStr=[dic objectForKey:@"card_id"];
//        int card_id=[[dic objectForKey:@"ci"]intValue];
//        int gTid;
//        long long time=[timeStr longLongValue];//因为时差问题要加8小时 == 28800 sec
//        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
//        NSLog(@"date:%@",[detaildate description]);
//        //实例化一个NSDateFormatter对象
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        //设定时间格式,这里可以设置成自己需要的格式
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        
//        NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
//        
//        NSLog(@"时间是啥%@",currentDateStr);
//        NSArray *nfArray=[[UIApplication sharedApplication]scheduledLocalNotifications];
//        NSUInteger acount=[nfArray count];
//        if (acount>0) {
//            for (int i=0; i<acount; i++) {
//                UILocalNotification *myUILocalNotification=[nfArray objectAtIndex:i];
//                NSDate *dictUser=myUILocalNotification.fireDate;
//                NSDictionary *userInfo=myUILocalNotification.userInfo;
//                NSNumber *obj=[userInfo objectForKey:@"someKey"];
//                
//                NSLog(@"都有嘛东西啊？%@",myUILocalNotification);
//                int mytag=[obj intValue];
//                if (mytag==card_id&&dictUser==detaildate) {
//                    gTid=1;
//                }else{
//                    gTid=10;
//                }
//            }
//        }
//        NSString *trueStr=[dic objectForKey:@"is"];
//        if ([trueStr isEqual:@"true"]) {
//            NSString *actionStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ac"]];
//            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//            
//            [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            if ([actionStr isEqualToString:@"a"]) {
//                badge=100;
//                if (pushIDs!=1000) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ALERT" object:dic];
//                }
//                
//            }else if([actionStr isEqualToString:@"m"]){
//                if (pushIDs!=1000) {
//                    if ([[dic objectForKey:@"ca"] isEqualToString:@""]&&[[dic objectForKey:@"pa"] isEqualToString:@""]&&[[dic objectForKey:@"aj"] isEqualToString:@""]&&[[dic objectForKey:@"go"] isEqualToString:@""]) {
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"Newinformation" object:dic];
//                    }
//                    
//                }
//            }else{
//                if (pushIDs!=1000) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICEPUSH" object:dic];
//                }
//            }
//
//        }
//        
//        if (gTid!=1) {
//        }else{
//            
//        }
//    pushIDs=0;
    
}
-(NSString*) formateTime:(NSDate*) date {
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString* dateTime = [formatter stringFromDate:date];
    return dateTime;
}
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    NSLog(@"我就看看你走没走--8");
    // [4-EXT]:发送上行消息结果反馈
    
//    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
    
    
    
}
- (void)GeTuiSdkDidOccurError:(NSError *)error

{
    
    
}
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // [EXT]:通知SDK运行状态
    _sdkStatus = aStatus;
}

#pragma mark--------------------APN-----------------
#pragma mark Push Delegate
- (void)onMethod:(NSString*)method response:(NSDictionary*)data
{
    NSLog(@"%@",[NSString stringWithFormat:@"Method: %@\n%@",method,data]);
    NSString *app_id = [data objectForKey:@"app_id"];
    NSString *channel_id = [data objectForKey:@"channel_id"];
    NSString *user_id = [data objectForKey:@"user_id"];
    
    
    if (app_id && channel_id && user_id) {
        
        ISLoginManager *_manager = [ISLoginManager shareManager];
        NSMutableDictionary *sourceDic = [[NSMutableDictionary alloc]init];
        [sourceDic setObject:_manager.telephone  forKey:@"user_id"];
        [sourceDic setObject:app_id forKey:@"app_id"];
        [sourceDic setObject:channel_id forKey:@"channel_id"];
        [sourceDic setObject:user_id forKey:@"app_user_id"];
        [sourceDic setObject:@"ios" forKey:@"device_type"];
        
        NSLog(@"%@",sourceDic);
        
        AFHTTPRequestOperationManager *mymanager = [AFHTTPRequestOperationManager manager];
        [mymanager POST:[NSString stringWithFormat:@"%@%@",SERVER_DRESS,baidu_bangding]  parameters:sourceDic success:^(AFHTTPRequestOperation *opretion, id responseObject){
            
            NSLog(@"绑定成功");
            
        }
         
                failure:^(AFHTTPRequestOperation *opration, NSError *error){
                    
                    NSLog(@"请求失败: %@",error);
                    
                }];
        
    }
    
}
/*
 end
 */
- (void) sendTextContent
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = @"【私秘】今天终于体验了“私人秘书”的服务，大家快来试试吧！下载有礼1gj.cc/d/";
    req.bText = YES;
    req.scene = 1;
    
    [WXApi sendReq:req];
}
//微信的回调
-(void) onResp:(BaseResp*)resp{
    NSLog(@"%@",resp);
    NSLog(@"errStr %@",[resp errStr]);
    NSLog(@"errCode %d",[resp errCode]);
    NSLog(@"type %d",[resp type]);
    
    //微信分享
    if([resp errCode] == 0 && [resp type] == 0){
        
        if([resp isKindOfClass:[SendMessageToWXResp class]])
        {
            ISLoginManager *logmanager = [[ISLoginManager alloc]init];
            
            NSDictionary *_dict = @{@"user_id":logmanager.telephone,
                                    @"share_type":@"weixin",
                                    @"share_account":@""};
            
            AFHTTPRequestOperationManager *mymanager = [AFHTTPRequestOperationManager manager];
            
            [mymanager POST:[NSString stringWithFormat:@"%@%@",SERVER_DRESS,@"/simi/app/user/share.json"] parameters:_dict success:^(AFHTTPRequestOperation *opretion, id responseObject){
                
                NSInteger _status= [[responseObject objectForKey:@"status"] integerValue];
                NSString * _message= [responseObject objectForKey:@"msg"];
                NSLog(@"%@",_message);
                if (_status == 0) {
                    
                }else{
                }
                
            } failure:^(AFHTTPRequestOperation *opration, NSError *error){
                
            }];
            
        }
    }
    
    //微信支付
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WEIXINCHAXUN" object:nil];
                break;
            default:
                NSLog(@"支付失败， retcode=%d",resp.errCode);
                break;
        }
    }
//    //微信登录
//    SendAuthResp *aresp = (SendAuthResp *)resp;
//    if([resp isKindOfClass:[SendAuthResp class]])
//    {
//        if (aresp.errCode== 0) {
//            NSLog(@"微信登录成功");
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"WEIXINDENGLU_CG" object:nil];
////            [WXgetUserInfo GetTokenWithCode:aresp.code];
//            
//            
//        }
//    }
    
}


+(NSString *)wangluo
{
    UIApplication *application = [UIApplication sharedApplication];
    NSArray *subviews = [[[application valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    
    NSNumber *dataNetWorkItemView = nil;
    
    for (id subView in subviews) {
        if ([subView isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetWorkItemView = subView;
            break;
        }
    }
    NSString *string;
    NetWorkTypes networkType = NetWorkType_Nones;
    switch ([[dataNetWorkItemView valueForKey:@"dataNetworkType"] integerValue]) {
        case 0:
            NSLog(@"No wifi or cellular");
            networkType = NetWorkType_Nones;
            string=@"0";
            break;
        case 1:
            NSLog(@"2G");
            networkType = NetWorkType_2Gs;
            string=@"1";
            break;
        case 2:
            NSLog(@"3G");
            networkType = NetWorkType_3Gs;
            string=@"2";
            break;
        case 3:
            NSLog(@"4G");
            networkType = NetWorkType_4Gs;
            string=@"3";
            break;
        default:
            NSLog(@"Wifi");
            networkType = NetWorkType_WIFIs;
            string=@"4";
            break;
    }
    
    return string;
}

#pragma mark
- (void)ChoseRootController
{
    
    NSUserDefaults *_userdefaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"阿空军基地法咖啡%@",_userdefaults);
    NSString *_guidstring = [_userdefaults objectForKey:@"GUIDE"];
    NSLog(@"(guidstring:%@",_guidstring);
    if (_guidstring) {
        
        RootViewController *controller = [[RootViewController alloc]init];
//        controller.vCLID=0;
        UINavigationController *navcontroller = [[UINavigationController alloc]initWithRootViewController:controller];
        self.window.rootViewController = navcontroller;
        navcontroller.navigationBarHidden = YES;
        if (_pushID!=1) {
            //设置启动页
            NSString *strs=[self.class wangluo];
            int wifiID=[strs intValue];
            
            splashView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height)];
            
            [splashView setImage:[UIImage imageNamed:@"1242X2208"]];
            
            [self.window addSubview:splashView];
            
            [self.window bringSubviewToFront:splashView];
            _adView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-150)];
            NSString *imageUrl=@"http://app.bolohr.com/simi-h5/img/load-ad-update.jpg";
            if (wifiID==0) {
                [_adView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
            }else if (wifiID==1){
                [_adView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
            }else{
                 _adView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
            }
//            _adView.backgroundColor=[UIColor redColor];
            [splashView addSubview:_adView];
            splashView.userInteractionEnabled=YES;
            _adView.userInteractionEnabled=YES;
//            UITapGestureRecognizer *imageTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTap)];
//            [_adView addGestureRecognizer:imageTap];
            
            [self performSelector:@selector(showWord) withObject:nil afterDelay:3.0f];
            
            UIActivityIndicatorView *acview = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            
            acview.center = CGPointMake((self.window.bounds.size.width/2), self.window.bounds.size.height/2+50);
            
            [splashView addSubview:acview];
            
            [acview startAnimating];
        }
        
        
        
        //end
        
    }else{
        [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        GuideViewController *_controller = [[GuideViewController alloc]init];
        UINavigationController *root = [[UINavigationController alloc]initWithRootViewController:_controller];
        self.window.rootViewController = root;
        
    }
    
    
}
#pragma mark 启动页点击事件
-(void)imgTap
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"IMGTAPP" object:nil];
    WebPageViewController *webPageVC=[[WebPageViewController alloc]init];
    webPageVC.barIDS=100;
    webPageVC.qdIDl=1000;
    webPageVC.webURL=[NSString stringWithFormat:@"https://www.baidu.com"];
    UINavigationController *navcontroller = [[UINavigationController alloc]initWithRootViewController:webPageVC];
    [self.window.rootViewController presentViewController:navcontroller animated:YES completion:nil];
}
- (void)getBeijingcity
{
    _repartArray = [[NSMutableArray alloc]init];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options
{
    // 跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSDictionary *payDic = resultDic;
            NSLog(@"%@",payDic);
            NSString * status = [payDic objectForKey:@"resultStatus"];
            
            if ([status isEqualToString:@"9000"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"QIANBAOSUCCESS" object:nil];
            }
        }];
    }

    if ([url.scheme isEqualToString:@"tencent1104934408"]) {
        return [UMSocialSnsService handleOpenURL:url];
    }
    if ([url.scheme isEqualToString:@"wx93aa45d30bf6cba3"]) {
        [WXApi handleOpenURL:url delegate:self];
        return [UMSocialSnsService handleOpenURL:url];
    }
    /*
     新浪微博登陆
     */
    if ([url.scheme isEqualToString:@"wb247547429"]) {
        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }

    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    /*
     qq登陆
     */
    
    if ([url.scheme isEqualToString:@"tencent1104934408"]) {
        return [UMSocialSnsService handleOpenURL:url];
    }
    if ([url.scheme isEqualToString:@"wx93aa45d30bf6cba3"]) {
        [WXApi handleOpenURL:url delegate:self];
        return [UMSocialSnsService handleOpenURL:url];
    }
    /*
     新浪微博登陆
     */
    if ([url.scheme isEqualToString:@"wb247547429"]) {
        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }
    
    
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    
    
    // 跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSDictionary *payDic = resultDic;
            NSLog(@"%@",payDic);
            NSString * status = [payDic objectForKey:@"resultStatus"];
            
            if ([status isEqualToString:@"9000"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"QIANBAOSUCCESS" object:nil];
            }
        }];
    }
    
    
    /*
     微信分享
     */
    //如果涉及其他应用交互,请做如下判断,例如:还可能和新浪微博进行交互
    if ([url.scheme isEqualToString:@"wx93aa45d30bf6cba3"]) {
        [WXApi handleOpenURL:url delegate:self]||[TencentOAuth HandleOpenURL:url];
        [WXApi handleOpenURL:url delegate:self];
        return [UMSocialSnsService handleOpenURL:url];
    }
    
    /*
     
     qq登陆
     */
    
    if ([url.scheme isEqualToString:@"QQ41DBF608"]) {
        return [UMSocialSnsService handleOpenURL:url];
    }
    if ([url.scheme isEqualToString:@"tencent1104934408"]) {
        
        return [UMSocialSnsService handleOpenURL:url];//TencentOAuth
    }
    
    /*
     新浪微博登陆
     */
    if ([url.scheme isEqualToString:@"wb247547429"]) {
        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }
    
    
    /*
     自定义URL启动App  样本xcloud://51xingzheng.com?category=app&action=water
     */
    if ([url.scheme isEqualToString:@"xcloud"]) {
        NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
        NSLog(@"URL scheme:%@", [url scheme]);
        NSLog(@"URL query: %@", [url query]);
//        NSURL *url=sender.object;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"URLOPEN" object:url];
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        delegate.pushURl=url;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"URLOPEN" object:delegate.pushURl];
      // 
    }
    
    
    
    return YES;
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    AudioServicesPlayAlertSound(1000); //系统的通知声音
    NSLog(@"我就看看你走没走--9");
    if (_mainController) {
        [_mainController jumpToChatList];
    }
    NSLog(@"userinfo:%@",userInfo);
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"%@",notification.userInfo);
    NSLog(@"我就看看你走没走--10");
    if(application.applicationState == UIApplicationStateActive)
    {
        NSLog(@"前台");
    }
    if (application.applicationState == UIApplicationStateBackground) {
        NSLog(@"后台");
        
    }
    
#pragma mark程序在后台点击通知
    if (application.applicationState == UIApplicationStateInactive) {
        NSDictionary *dict=notification.userInfo;
        NSDictionary *dic=[dict objectForKey:@"dic"];
        NSString *yes_or_no=[NSString stringWithFormat:@"%@",[dict objectForKey:@"yes_or_no"]];
        
        NSString *actionStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ac"]];
        
        if ([yes_or_no isEqualToString:@"yes"]) {
            NSString *trueStr=[dic objectForKey:@"is"];
            if ([trueStr isEqual:@"true"]) {
                if ([actionStr isEqualToString:@"a"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ALERT" object:dic];
                }else if ([actionStr isEqualToString:@"m"]){
                    if ([[dic objectForKey:@"ca"] isEqualToString:@"app"]) {
                        if ([[dic objectForKey:@"pa"] isEqualToString:@""]) {
                            urlSrt=[NSString stringWithFormat:@"http://www.bolohr.com/d/open.html?category=%@&action=%@",[dic objectForKey:@"ca"],[dic objectForKey:@"aj"]];
                        }else{
                            urlSrt=[NSString stringWithFormat:@"http://www.bolohr.com/d/open.html?category=%@&action=%@&params=%@",[dic objectForKey:@"ca"],[dic objectForKey:@"aj"],[dic objectForKey:@"pa"]];
                        }
                        
                    }else if([[dic objectForKey:@"ca"] isEqualToString:@"h5"]){
                        urlSrt=[NSString stringWithFormat:@"%@",[dic objectForKey:@"go"]];
                    }
                    
                    NSString *ca=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ca"]];
                    NSString *aj=[NSString stringWithFormat:@"%@",[dic objectForKey:@"aj"]];
                    NSString *pa=[NSString stringWithFormat:@"%@",[dic objectForKey:@"pa"]];
                    NSString *go=[NSString stringWithFormat:@"%@",[dic objectForKey:@"go"]];
                    if ((ca==nil||ca==NULL||[ca isEqualToString:@"(null)"])&&(aj==nil||aj==NULL||[aj isEqualToString:@"(null)"])&&(pa==nil||pa==NULL||[pa isEqualToString:@"(null)"])&&(go==nil||go==NULL||[go isEqualToString:@"(null)"])) {
                        
                    }else{
                        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(popAlertView) userInfo:nil repeats:NO];
                    }
                    
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICEPUSH" object:dic];
                }
            }
            
            
        }else{
            pushEjectView.hidden=YES;
            [pushEjectView removeFromSuperview];
            if ([actionStr isEqualToString:@"s"]) {
                //            badge=100;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ALERT" object:dic];
                
            }else if ([actionStr isEqualToString:@"m"]) {
                
                if ([[dic objectForKey:@"ca"] isEqualToString:@"app"]) {
                    if ([[dic objectForKey:@"pa"] isEqualToString:@""]) {
                        urlSrt=[NSString stringWithFormat:@"http://www.bolohr.com/d/open.html?category=%@&action=%@",[dic objectForKey:@"ca"],[dic objectForKey:@"aj"]];
                    }else{
                        urlSrt=[NSString stringWithFormat:@"http://www.bolohr.com/d/open.html?category=%@&action=%@&params=%@",[dic objectForKey:@"ca"],[dic objectForKey:@"aj"],[dic objectForKey:@"pa"]];
                    }
                    
                }else if([[dic objectForKey:@"ca"] isEqualToString:@"h5"]){
                    urlSrt=[NSString stringWithFormat:@"%@",[dic objectForKey:@"go"]];
                }
                
                NSString *ca=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ca"]];
                NSString *aj=[NSString stringWithFormat:@"%@",[dic objectForKey:@"aj"]];
                NSString *pa=[NSString stringWithFormat:@"%@",[dic objectForKey:@"pa"]];
                NSString *go=[NSString stringWithFormat:@"%@",[dic objectForKey:@"go"]];
                if ((ca==nil||ca==NULL||[ca isEqualToString:@"(null)"])&&(aj==nil||aj==NULL||[aj isEqualToString:@"(null)"])&&(pa==nil||pa==NULL||[pa isEqualToString:@"(null)"])&&(go==nil||go==NULL||[go isEqualToString:@"(null)"])) {
                    
                }else{
                    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(popAlertView) userInfo:nil repeats:NO];
                }
                
                //        return;
            }

        }
        
        
      
        
    }
    if (notification)
    {
        NSDictionary *dict=notification.userInfo;
        NSDictionary *dic=[dict objectForKey:@"dic"];
        NSLog(@"%@",dic);
        NSString *yes_or_no=[NSString stringWithFormat:@"%@",[dict objectForKey:@"yes_or_no"]];
        
        NSString *actionStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ac"]];
        
        if ([yes_or_no isEqualToString:@"yes"]) {
            NSString *trueStr=[dic objectForKey:@"is"];
            if ([trueStr isEqual:@"true"]) {
                if ([actionStr isEqualToString:@"a"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ALERT" object:dic];
                }else if ([actionStr isEqualToString:@"m"]){
                    if ([[dic objectForKey:@"ca"] isEqualToString:@"app"]) {
                        if ([[dic objectForKey:@"pa"] isEqualToString:@""]) {
                            urlSrt=[NSString stringWithFormat:@"http://www.bolohr.com/d/open.html?category=%@&action=%@",[dic objectForKey:@"ca"],[dic objectForKey:@"aj"]];
                        }else{
                            urlSrt=[NSString stringWithFormat:@"http://www.bolohr.com/d/open.html?category=%@&action=%@&params=%@",[dic objectForKey:@"ca"],[dic objectForKey:@"aj"],[dic objectForKey:@"pa"]];
                        }
                        
                    }else if([[dic objectForKey:@"ca"] isEqualToString:@"h5"]){
                        urlSrt=[NSString stringWithFormat:@"%@",[dic objectForKey:@"go"]];
                    }
                    
                    NSString *ca=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ca"]];
                    NSString *aj=[NSString stringWithFormat:@"%@",[dic objectForKey:@"aj"]];
                    NSString *pa=[NSString stringWithFormat:@"%@",[dic objectForKey:@"pa"]];
                    NSString *go=[NSString stringWithFormat:@"%@",[dic objectForKey:@"go"]];
                    if ((ca==nil||ca==NULL||[ca isEqualToString:@"(null)"])&&(aj==nil||aj==NULL||[aj isEqualToString:@"(null)"])&&(pa==nil||pa==NULL||[pa isEqualToString:@"(null)"])&&(go==nil||go==NULL||[go isEqualToString:@"(null)"])) {
                        
                    }else{
                        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(popAlertView) userInfo:nil repeats:NO];
                    }
                    
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICEPUSH" object:dic];
                }
            }
            
            
        }else{
            pushEjectView.hidden=YES;
            [pushEjectView removeFromSuperview];
            if ([actionStr isEqualToString:@"s"]) {
                //            badge=100;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ALERT" object:dic];
                
            }else if ([actionStr isEqualToString:@"m"]) {
                
                if ([[dic objectForKey:@"ca"] isEqualToString:@"app"]) {
                    if ([[dic objectForKey:@"pa"] isEqualToString:@""]) {
                        urlSrt=[NSString stringWithFormat:@"http://www.bolohr.com/d/open.html?category=%@&action=%@",[dic objectForKey:@"ca"],[dic objectForKey:@"aj"]];
                    }else{
                        urlSrt=[NSString stringWithFormat:@"http://www.bolohr.com/d/open.html?category=%@&action=%@&params=%@",[dic objectForKey:@"ca"],[dic objectForKey:@"aj"],[dic objectForKey:@"pa"]];
                    }
                    
                }else if([[dic objectForKey:@"ca"] isEqualToString:@"h5"]){
                    urlSrt=[NSString stringWithFormat:@"%@",[dic objectForKey:@"go"]];
                }
                
                NSString *ca=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ca"]];
                NSString *aj=[NSString stringWithFormat:@"%@",[dic objectForKey:@"aj"]];
                NSString *pa=[NSString stringWithFormat:@"%@",[dic objectForKey:@"pa"]];
                NSString *go=[NSString stringWithFormat:@"%@",[dic objectForKey:@"go"]];
                if ((ca==nil||ca==NULL||[ca isEqualToString:@"(null)"])&&(aj==nil||aj==NULL||[aj isEqualToString:@"(null)"])&&(pa==nil||pa==NULL||[pa isEqualToString:@"(null)"])&&(go==nil||go==NULL||[go isEqualToString:@"(null)"])) {
                    
                }else{
                    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(popAlertView) userInfo:nil repeats:NO];
                }
                
                //        return;
            }
            
        }
        

    }
    
    application.applicationIconBadgeNumber = 0;
    
    if (_mainController) {
        [_mainController jumpToChatList];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"我就看看你走没走--11");
    badge=0;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
    dateDic=nil;
    pushIDs=0;
#pragma mark--------APN  // [EXT] APP进入后台时，通知个推SDK进入后台
    [GeTuiSdk enterBackground];
    bgTask=[application beginBackgroundTaskWithExpirationHandler:^{
        // 10分钟后执行这里，应该进行一些清理工作，如断开和服务器的连接等
        // ...
        // stopped or ending the task outright.
        [application endBackgroundTask:bgTask];
        bgTask=UIBackgroundTaskInvalid;
        }];
    if (bgTask == UIBackgroundTaskInvalid){
        NSLog(@"failed to start background task!");
        }
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Do the work associated with the task, preferably in chunks.
        NSTimeInterval timeRemain = 0;
        do{
            [NSThread sleepForTimeInterval:5];
            if(bgTask!=UIBackgroundTaskInvalid){
                timeRemain = [application backgroundTimeRemaining];
                NSLog(@"Time remaining: %f",timeRemain);
                }
            }while(bgTask!=UIBackgroundTaskInvalid&&timeRemain>10*60);// 如果改为timeRemain > 5*60,表示后台运行5分钟
        // done!
        // 如果没到10分钟，也可以主动关闭后台任务，但这需要在主线程中执行，否则会出错
        dispatch_async(dispatch_get_main_queue(),^{
            if(bgTask!=UIBackgroundTaskInvalid)
            {
                    // 和上面10分钟后执行的代码一样
                    // ...
                    // if you don't call endBackgroundTask, the OS will exit your app.
                    [application endBackgroundTask:bgTask];
                    bgTask=UIBackgroundTaskInvalid;
                }
        });
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"我就看看你走没走--12");
    // 如果没到10分钟又打开了app,结束后台任务
    if (bgTask!=UIBackgroundTaskInvalid) {
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    badge=0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"badge%d",badge);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HOMERefresh" object:dateDic];
    [GeTuiSdk resume];
     NSError *err = nil;
    [GeTuiSdk startSdkWithAppId:_appID appKey:_appKey appSecret:_appSecret delegate:self error:&err];
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    if (badge==100) {
        NSLog(@"就时不走是吧");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ALERT" object:dateDic];
        
    }
    NSLog(@"%ld",(long)application.applicationState);
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"我就看看你走没走--13");
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"simi" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"simi.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}
-(void)viewShowcase:(NSNotification *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KEYBOARD" object:nil];
    NSDictionary *dic=sender.object;
    UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
    view.backgroundColor=[UIColor whiteColor];
    [self.window addSubview:view];
    NSArray *array=@[@"识别车牌:",@"车颜色:",@"绑定用户:",@"识别时间:",@"本次缴费:",@"账户余额:",@"账户类型:"];
    for (int i=0; i<array.count; i++) {
        UILabel *nameLabel=[[UILabel alloc]init];
        nameLabel.text=[NSString stringWithFormat:@"%@",array[i]];
        nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:18];
        [nameLabel setNumberOfLines:1];
        [nameLabel sizeToFit];
        nameLabel.frame=FRAME(20, 64+30*i, nameLabel.frame.size.width, 30);
        [view addSubview:nameLabel];
        
        UILabel *textLabel=[[UILabel alloc]init];
        textLabel.font=[UIFont fontWithName:@"Heiti SC" size:18];
        switch (i) {
            case 0:
            {
                textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"cn"]];
            }
                break;
            case 1:
            {
                textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"cc"]];
            }
                break;
            case 2:
            {
                textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"mo"]];
            }
                break;
            case 3:
            {
                textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ot"]];
            }
                break;
            case 4:
            {
                textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"om"]];
            }
                break;
            case 5:
            {
                textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"rm"]];
            }
                break;
            case 6:
            {
                textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ot"]];
            }
                break;
                
            default:
                break;
        }
        textLabel.frame=FRAME(nameLabel.frame.size.width+30, 64+30*i, (WIDTH-nameLabel.frame.size.width-50), 30);
        textLabel.textAlignment=NSTextAlignmentLeft;
        [view addSubview:textLabel];
    }
    UIImageView *image=[[UIImageView alloc]initWithFrame:FRAME(20, 64+30*7, WIDTH-40, 200)];
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ci"]];
    [image setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
    [view addSubview:image];
    
    UIButton *confirmBut=[[UIButton alloc]initWithFrame:FRAME(14, HEIGHT-46, WIDTH-28, 41)];
    confirmBut.backgroundColor=HEX_TO_UICOLOR(0xe8374a, 1.0);
    [confirmBut setTitle:@"确认缴费" forState:UIControlStateNormal];
    confirmBut.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    confirmBut.layer.cornerRadius=8;
    confirmBut.clipsToBounds=YES;
    [confirmBut addTarget:self action:@selector(confirmBut:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:confirmBut];
}
-(void)confirmBut:(UIButton *)button
{
    
}

//- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
//{
//    NSLog(@"continueUserActiity enter");
//    NSLog(@"\tAction Type : %@", userActivity.activityType);
//    NSLog(@"\tURL         : %@", userActivity.webpageURL);
//    NSLog(@"\tuserinfo :%@",userActivity.userInfo);
//    
//    NSLog(@"continueUserActiity exit");
//    restorationHandler(nil);
//    
//    NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    NSArray *cookies = [sharedHTTPCookieStorage cookiesForURL:userActivity.webpageURL];
//    
//    NSLog(@"COOKIE{name: %@", cookies);
//    return true;
//}
#pragma mark 基础数据更新接口成功返回
-(void)Basic_dataSuccess:(id)SourceData
{
    NSLog(@"基础数据更新接口成功返回:::%@",SourceData);
    NSDictionary *dataDict=[SourceData objectForKey:@"data"];
    NSArray *cityArray=[dataDict objectForKey:@"city"];
    //应用中心列表数组
    NSArray *apptoolsArray=[dataDict objectForKey:@"apptools"];
    NSArray *expressArray=[dataDict objectForKey:@"express"];
    NSArray *assetsArray=[dataDict objectForKey:@"asset_types"];
    NSArray *op_adArray=[dataDict objectForKey:@"opads"];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    
    
    BOOL find = [fileManager fileExistsAtPath:[self readyDatabase:@"simi.db"]];
    
    if (find) {
        if(sqlite3_open([[self readyDatabase:@"simi.db"] UTF8String], &simi) != SQLITE_OK) {
            sqlite3_close(simi);
            NSLog(@"open database fail");
        }
    }
    //城市列表数据更新
    for (int i=0; i<cityArray.count; i++) {
        NSDictionary *dict=cityArray[i];
        NSArray *ar=dict.allKeys;
        NSLog(@"+++++++++%@",ar);
        
        
        
        sqlite3_stmt *dbps;
        
        NSString *searchSQL = [NSString stringWithFormat:@"SELECT * from city where city_id = %@",[dict objectForKey:@"city_id"]];
        
        const char *searchtUTF8 = [searchSQL UTF8String];
        
        if (sqlite3_prepare_v2(simi, searchtUTF8, -1, &dbps, nil) != SQLITE_OK) {
            NSLog(@"数据查询失败");
            
        }else{
            NSLog(@"查询成功");
            
            if (sqlite3_step(dbps) == SQLITE_ROW) { //查询有这个小区
                char *abc = (char *)sqlite3_column_text(dbps, 5);
                NSString *str = [[NSString alloc]initWithCString:abc encoding:NSUTF8StringEncoding];
                NSLog(@"str : %@",str);
               NSString *updateSQL = [NSString stringWithFormat:@"update city set city_id=%i,name='%@',add_time=%i,province_id=%i,is_enable=%i,zip_code=%i where city_id =%i",[[dict objectForKey:@"city_id"]intValue],[dict objectForKey:@"name"],[[dict objectForKey:@"add_time"]intValue],[[dict objectForKey:@"province_id"]intValue],[[dict objectForKey:@"is_enable"]intValue],[[dict objectForKey:@"zip_code"]intValue],[[dict objectForKey:@"city_id"]intValue]];
                NSLog(@"SQL语句:%@",updateSQL);
                [self updatetableName:updateSQL];
                continue;
            }else{
                NSString *insertSQL=[NSString stringWithFormat:@"INSERT INTO city (city_id,name,add_time,province_id,is_enable,zip_code) VALUES (%i, '%@', %i, %i,%i, %i)",[[dict objectForKey:@"city_id"]intValue],[dict objectForKey:@"name"],[[dict objectForKey:@"add_time"]intValue],[[dict objectForKey:@"province_id"]intValue],[[dict objectForKey:@"is_enable"]intValue],[[dict objectForKey:@"zip_code"]intValue]];
                
                [self insertIntoTableName:insertSQL];  ////查询没有这个小区
            }
            
            //        [self deleteTableName:@"cell" cellId:1];
            
            
        }

        
    }
    Service_hallViewController*preLoadingVC=[[Service_hallViewController alloc]init];
    [preLoadingVC preLoadingImage:apptoolsArray];
    //应用中心数据更新
    for (int i=0; i<apptoolsArray.count; i++) {
        
        
        NSDictionary *dict=apptoolsArray[i];
        
        sqlite3_stmt *dbps;
        
        NSString *searchSQL = [NSString stringWithFormat:@"SELECT * from app_tools where t_id = %@",[dict objectForKey:@"t_id"]];
        
        const char *searchtUTF8 = [searchSQL UTF8String];
        
        if (sqlite3_prepare_v2(simi, searchtUTF8, -1, &dbps, nil) != SQLITE_OK) {
            NSLog(@"数据查询失败");
            
        }else{
            NSLog(@"查询成功");
            
            if (sqlite3_step(dbps) == SQLITE_ROW) { //查询有这个小区
                char *abc = (char *)sqlite3_column_text(dbps, 19);
                NSString *str = [[NSString alloc]initWithCString:abc encoding:NSUTF8StringEncoding];
                NSLog(@"str : %@",str);
                NSString *updateSQL =[NSString stringWithFormat:@"update app_tools set t_id=%i,no=%i,name='%@',logo='%@',app_type='%@',menu_type='%@',open_type='%@',url='%@',action='%@',params='%@',is_default=%i,is_del=%i,is_partner=%i,is_online=%i,app_provider='%@',app_describe='%@',auth_url='%@',qr_code='%@',add_time='%@',update_time='%@' where t_id=%i",[[dict objectForKey:@"t_id"]intValue],[[dict objectForKey:@"no"]intValue],[dict objectForKey:@"name"],[dict objectForKey:@"logo"],[dict objectForKey:@"app_type"],[dict objectForKey:@"menu_type"],[dict objectForKey:@"open_type"],[dict objectForKey:@"url"],[dict objectForKey:@"action"],[dict objectForKey:@"params"],[[dict objectForKey:@"is_default"]intValue],[[dict objectForKey:@"is_del"]intValue],[[dict objectForKey:@"is_partner"]intValue],[[dict objectForKey:@"is_online"]intValue],[dict objectForKey:@"app_provider"],[dict objectForKey:@"app_describe"],[dict objectForKey:@"auth_url"],[dict objectForKey:@"qr_code"],[dict objectForKey:@"add_time"],[dict objectForKey:@"update_time"],[[dict objectForKey:@"t_id"]intValue]];
                NSLog(@"SQL语句:%@",updateSQL);
                [self updatetableName:updateSQL];
                continue;
            }else{
                NSString *insertSQL=[NSString stringWithFormat:@"INSERT INTO app_tools (t_id,no,name,logo,app_type,menu_type,open_type,url,action,params,is_default,is_del,is_partner,is_online,app_provider,app_describe,auth_url,qr_code,add_time, update_time) VALUES (%i, %i, '%@', '%@','%@', '%@', '%@', '%@','%@','%@',%i,%i,%i,%i,'%@','%@','%@','%@',%i,%i)",[[dict objectForKey:@"t_id"]intValue],[[dict objectForKey:@"no"]intValue],[dict objectForKey:@"name"],[dict objectForKey:@"logo"],[dict objectForKey:@"app_type"],[dict objectForKey:@"menu_type"],[dict objectForKey:@"open_type"],[dict objectForKey:@"url"],[dict objectForKey:@"action"],[dict objectForKey:@"params"],[[dict objectForKey:@"is_default"]intValue],[[dict objectForKey:@"is_del"]intValue],[[dict objectForKey:@"is_partner"]intValue],[[dict objectForKey:@"is_online"]intValue],[dict objectForKey:@"app_provider"],[dict objectForKey:@"app_describe"],[dict objectForKey:@"auth_url"],[dict objectForKey:@"qr_code"],[[dict objectForKey:@"add_time"]intValue],[[dict objectForKey:@"update_time"]intValue]];
                
                [self insertIntoTableName:insertSQL];  ////查询没有这个小区
            }
            
            //        [self deleteTableName:@"cell" cellId:1];
           
            
        }
    }
    
    //快递列表数据更新
    for (int i=0; i<expressArray.count; i++) {
        NSDictionary *dict=expressArray[i];
        sqlite3_stmt *dbps;
        
        NSString *searchSQL = [NSString stringWithFormat:@"SELECT * from express where express_id = %@",[dict objectForKey:@"express_id"]];
        
        const char *searchtUTF8 = [searchSQL UTF8String];
        
        if (sqlite3_prepare_v2(simi, searchtUTF8, -1, &dbps, nil) != SQLITE_OK) {
            NSLog(@"数据查询失败");
            
        }else{
            NSLog(@"查询成功");
            
            if (sqlite3_step(dbps) == SQLITE_ROW) { //查询有这个小区
                char *abc = (char *)sqlite3_column_text(dbps, 8);
                NSString *str = [[NSString alloc]initWithCString:abc encoding:NSUTF8StringEncoding];
                NSLog(@"str : %@",str);
               NSString *updateSQL = [NSString stringWithFormat:@"update express set express_id=%i,ecode='%@',name='%@',is_hot=%i,website'=%@',api_order_url='%@',api_search_url='%@',add_time=%i,update_time=%i where express_id =%i",[[dict objectForKey:@"express_id"]intValue],[dict objectForKey:@"ecode"],[dict objectForKey:@"name"],[[dict objectForKey:@"is_hot"]intValue],[dict objectForKey:@"website"],[dict objectForKey:@"api_order_url"],[dict objectForKey:@"api_search_url"],[[dict objectForKey:@"add_time"]intValue],[[dict objectForKey:@"update_time"]intValue],[[dict objectForKey:@"express_id"]intValue]];
                NSLog(@"SQL语句:%@",updateSQL);
                [self updatetableName:updateSQL];
                continue;
            }else{
               NSString *insertSQL=[NSString stringWithFormat:@"INSERT INTO express (express_id,ecode,name,is_hot,website,api_order_url,api_search_url,add_time,update_time) VALUES (%i, '%@', '%@', %i,'%@', '%@','%@', %i, %i)",[[dict objectForKey:@"express_id"]intValue],[dict objectForKey:@"ecode"],[dict objectForKey:@"name"],[[dict objectForKey:@"is_hot"]intValue],[dict objectForKey:@"website"],[dict objectForKey:@"api_order_url"],[dict objectForKey:@"api_search_url"],[[dict objectForKey:@"add_time"]intValue],[[dict objectForKey:@"update_time"]intValue]];
                
                [self insertIntoTableName:insertSQL];  ////查询没有这个小区
            }
            
            //        [self deleteTableName:@"cell" cellId:1];
            
            
        }
    }
    
    //资产列表数据更新
    for (int i=0; i<assetsArray.count; i++) {
        NSDictionary *dict=assetsArray[i];
        sqlite3_stmt *dbps;
        
        NSString *searchSQL = [NSString stringWithFormat:@"SELECT * from xcompany_setting where id = %@",[dict objectForKey:@"id"]];
        
        const char *searchtUTF8 = [searchSQL UTF8String];
        
        if (sqlite3_prepare_v2(simi, searchtUTF8, -1, &dbps, nil) != SQLITE_OK) {
            NSLog(@"数据查询失败");
            
        }else{
            NSLog(@"查询成功");
            
            if (sqlite3_step(dbps) == SQLITE_ROW) { //查询有这个小区
                char *abc = (char *)sqlite3_column_text(dbps, 7);
                NSString *str = [[NSString alloc]initWithCString:abc encoding:NSUTF8StringEncoding];
                NSLog(@"str : %@",str);
                NSString *updateSQL = [NSString stringWithFormat:@"update xcompany_setting set id=%i,company_id=%i,name='%@',setting_type='%@',setting_json='%@',is_enable=%i,add_time=%i,update_time=%i where id =%i",[[dict objectForKey:@"id"]intValue],[[dict objectForKey:@"company_id"]intValue],[dict objectForKey:@"name"],[dict objectForKey:@"setting_type"],[dict objectForKey:@"setting_json"],[[dict objectForKey:@"is_enable"]intValue],[[dict objectForKey:@"add_time"]intValue],[[dict objectForKey:@"update_time"]intValue],[[dict objectForKey:@"id"]intValue]];
                NSLog(@"SQL语句:%@",updateSQL);
                [self updatetableName:updateSQL];
                continue;
            }else{
                NSString *insertSQL=[NSString stringWithFormat:@"INSERT INTO xcompany_setting (id,company_id,name,setting_type,setting_json,is_enable,add_time,update_time) VALUES (%i, %i, '%@','%@','%@',%i,%i,%i)",[[dict objectForKey:@"id"]intValue],[[dict objectForKey:@"company_id"]intValue],[dict objectForKey:@"name"],[dict objectForKey:@"setting_type"],[dict objectForKey:@"setting_json"],[[dict objectForKey:@"is_enable"]intValue],[[dict objectForKey:@"add_time"]intValue],[[dict objectForKey:@"update_time"]intValue]];
                
                [self insertIntoTableName:insertSQL];  ////查询没有这个小区
            }
            
            //        [self deleteTableName:@"cell" cellId:1];
            
            
        }

    }
    Op_ad_hallViewController *op_adLoadingVC=[[Op_ad_hallViewController alloc]init];
    [op_adLoadingVC preLoadingImage:op_adArray];
    //服务大厅数据更新
    for (int i=0; i<op_adArray.count; i++) {
        NSDictionary *dict=op_adArray[i];
        sqlite3_stmt *dbps;
        
        NSString *searchSQL = [NSString stringWithFormat:@"SELECT * from op_ad where id = %@",[dict objectForKey:@"id"]];
        
        const char *searchtUTF8 = [searchSQL UTF8String];
        
        if (sqlite3_prepare_v2(simi, searchtUTF8, -1, &dbps, nil) != SQLITE_OK) {
            NSLog(@"数据查询失败");
            
        }else{
            NSLog(@"查询成功");
            
            if (sqlite3_step(dbps) == SQLITE_ROW) { //查询有这个小区
                char *abc = (char *)sqlite3_column_text(dbps, 10);
                NSString *str = [[NSString alloc]initWithCString:abc encoding:NSUTF8StringEncoding];
                NSLog(@"str : %@",str);
                NSString *updateSQL = [NSString stringWithFormat:@"update op_ad set id=%i ,no=%i ,title='%@', ad_type=%i, service_type_ids=%i, img_url='%@', goto_type='%@', goto_url='%@', add_time=%i, update_time=%i, enable=%i where id = %i",[[dict objectForKey:@"id"]intValue],[[dict objectForKey:@"no"]intValue],[dict objectForKey:@"title"],[[dict objectForKey:@"ad_type"]intValue],[[dict objectForKey:@"service_type_ids"]intValue],[dict objectForKey:@"img_url"],[dict objectForKey:@"goto_type"],[dict objectForKey:@"goto_url"],[[dict objectForKey:@"add_time"]intValue] ,[[dict objectForKey:@"update_time"]intValue],[[dict objectForKey:@"enable"]intValue],[[dict objectForKey:@"id"]intValue]];
                NSLog(@"SQL语句:%@",updateSQL);
                [self updatetableName:updateSQL];
                continue;
            }else{
                NSString *insertSQL=[NSString stringWithFormat:@"INSERT INTO op_ad (id ,no ,title, ad_type, service_type_ids, img_url, goto_type, goto_url, add_time, update_time, enable) VALUES (%i, %i, '%@',%i,%i,'%@','%@','%@',%i,%i,%i)",[[dict objectForKey:@"id"]intValue],[[dict objectForKey:@"no"]intValue],[dict objectForKey:@"title"],[[dict objectForKey:@"ad_type"]intValue],[[dict objectForKey:@"service_type_ids"]intValue],[dict objectForKey:@"img_url"],[dict objectForKey:@"goto_type"],[dict objectForKey:@"goto_url"],[[dict objectForKey:@"add_time"]intValue],[[dict objectForKey:@"update_time"]intValue],[[dict objectForKey:@"enable"]intValue]];
                
                [self insertIntoTableName:insertSQL];  ////查询没有这个小区
            }
            
            //        [self deleteTableName:@"cell" cellId:1];
            
            
        }
        
    }

    sqlite3_close(simi);
}

- (void)updatetableName:(NSString *)tablename
{
    sqlite3_stmt *dbps = nil;
    
    const char *searchtUTF8 = [tablename UTF8String];
    
    int result = sqlite3_prepare_v2(simi, searchtUTF8, -1, &dbps, NULL);
    
    if (result == SQLITE_OK) {
        NSLog(@"%d",sqlite3_step(dbps));
        if (sqlite3_step(dbps)==SQLITE_DONE) {
         NSLog(@"更新成功");
        }
    }
    
    sqlite3_finalize(dbps);
}
#pragma mark 如果没有这个数据就插入这条数据
- (void)insertIntoTableName:(NSString *)tablename
{
    
    
    sqlite3_stmt *dbps ;
    
    const char *insertUTF8 = [tablename UTF8String];
    
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
}

#pragma mark 基础数据更新接口失败返回
-(void)Basic_dataFail:(id)SourceData
{
    NSLog(@"基础数据更新接口失败返回:::%@",SourceData);
}
#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
-(void)alarmClock:(NSDictionary *)dict;
{
    
    //删除原来的闹钟
    NSArray *narry=[[UIApplication sharedApplication] scheduledLocalNotifications];
    NSUInteger acount=[narry count];
    if (acount>0)
    {// 遍历找到对应nfkey和notificationtag的通知
        for (int i=0; i<acount; i++)
        {
            UILocalNotification *myUILocalNotification = [narry objectAtIndex:i];
            NSDictionary *userInfo = [myUILocalNotification.userInfo objectForKey:@"dic"];
            NSNumber *obj = [userInfo objectForKey:@"ci"];
            int mytag=[obj intValue];
            NSString *card_id=[NSString stringWithFormat:@"%@",[dict objectForKey:@"ci"]];
            int notificationtag=[card_id intValue];
            if (mytag==notificationtag)
            {
                //删除本地通知
                [[UIApplication sharedApplication] cancelLocalNotification:myUILocalNotification];
                break;
            }
        }
    }//删除原来的闹钟
    
    NSString *timaString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"re"]];
//    NSDateFormatter *theTwoformatte1 = [[NSDateFormatter alloc] init];
//    [theTwoformatte1 setDateStyle:NSDateFormatterMediumStyle];
//    [theTwoformatte1 setTimeStyle:NSDateFormatterShortStyle];
//    [theTwoformatte1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate* theTwotdate1 = [theTwoformatte1 dateFromString:timaString];
    int theTwo1 = [timaString intValue];
    
    //获取当前时间
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    NSLog(@"locationString:%@",locationString);
    NSDateFormatter *formatte = [[NSDateFormatter alloc] init];
    [formatte setDateStyle:NSDateFormatterMediumStyle];
    [formatte setTimeStyle:NSDateFormatterShortStyle];
    [formatte setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate* date = [formatte dateFromString:locationString];
    int  _secondDate = [date timeIntervalSince1970];
    NSLog(@"%d",theTwo1-_secondDate);
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        
        //        NSDate *now=[NSDate new];
        
        notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:(theTwo1-_secondDate)];//10秒后通知
        
        notification.repeatInterval=0;//循环次数，kCFCalendarUnitWeekday一周一次
        
        notification.timeZone=[NSTimeZone defaultTimeZone];
        
        notification.applicationIconBadgeNumber=1; //应用的红色数字
        
        
        notification.soundName=@"simivoice.caf";//声音，可以换成alarm.soundName = @"myMusic.caf"
        
        //去掉下面2行就不会弹出提示框
        notification.alertTitle=[NSString stringWithFormat:@"%@",[dict objectForKey:@"rt"]];
        notification.alertBody=[NSString stringWithFormat:@"%@",[dict objectForKey:@"rc"]];//提示信息 弹出提示框
        
        notification.alertAction = @"打开";  //提示框按钮
        
        //notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
        
        
        
//        NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
        NSDictionary *infoDict = @{@"dic":dict,@"yes_or_no":@"no"};
        notification.userInfo = infoDict; //添加额外的信息
        
        
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        ISLoginManager *_manager = [ISLoginManager shareManager];
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *dics=@{@"user_id":_manager.telephone,@"card_id":[dict objectForKey:@"ci"]};
        [_download requestWithUrl:PUSH_NOTICE dict:dics view:self.window delegate:self finishedSEL:@selector(Success:) isPost:YES failedSEL:@selector(Fail:)];
    }

}
-(void)Success:(id)source
{
    
}
-(void)Fail:(id)source
{
    NSLog(@"%@",source);
}
-(void)rightOff:(NSDictionary *)dic
{
    
    
    
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        
        //        NSDate *now=[NSDate new];
        
        notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:0];//10秒后通知
        
        notification.repeatInterval=0;//循环次数，kCFCalendarUnitWeekday一周一次
        
        notification.timeZone=[NSTimeZone defaultTimeZone];
        
        notification.applicationIconBadgeNumber=1; //应用的红色数字
        
        
        notification.soundName=@"new-mail.caf";//声音，可以换成alarm.soundName = @"myMusic.caf"
        
        //去掉下面2行就不会弹出提示框
        notification.alertTitle=[NSString stringWithFormat:@"%@",[dic objectForKey:@"rt"]];
        notification.alertBody=[NSString stringWithFormat:@"%@",[dic objectForKey:@"rc"]];//提示信息 弹出提示框
        
        notification.alertAction = @"打开";  //提示框按钮
        
        //notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
        
        
        
        NSDictionary *infoDict = @{@"dic":dic,@"yes_or_no":@"yes"};//[NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
        
        notification.userInfo = infoDict; //添加额外的信息
        
        
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
    }

}
-(void)Delete_alarm_clock:(NSDictionary *)dataDict
{
    //删除原来的闹钟
    NSArray *narry=[[UIApplication sharedApplication] scheduledLocalNotifications];
    NSUInteger acount=[narry count];
    if (acount>0)
    {// 遍历找到对应nfkey和notificationtag的通知
        for (int i=0; i<acount; i++)
        {
            UILocalNotification *myUILocalNotification = [narry objectAtIndex:i];
            NSDictionary *userInfo = [myUILocalNotification.userInfo objectForKey:@"dic"];
            NSNumber *obj = [userInfo objectForKey:@"ci"];
            int mytag=[obj intValue];
            NSString *card_id=[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"ci"]];
            int notificationtag=[card_id intValue];
            if (mytag==notificationtag)
            {
                //删除本地通知
                [[UIApplication sharedApplication] cancelLocalNotification:myUILocalNotification];
                break;
            }
        }
    }//删除原来的闹钟

}
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
//    NSLog(@"URL scheme:%@", [url scheme]);
//    NSLog(@"URL query: %@", [url query]);
//    
//    return YES;
//}
@end
