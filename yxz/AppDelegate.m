//
//  AppDelegate.m
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "AppDelegate.h"
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
#import "MyLogInViewController.h"
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
#import "MobClick.h"
#import "UMSocialSinaSSOHandler.h"
#import "DetailsViewController.h"
#define IosAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
@interface AppDelegate ()<WXApiDelegate,WeiboSDKDelegate>
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
    //NSDictionary *dic;
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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"dr.log"];// 注意不是NSData!
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    // 先删除已经存在的文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:logFilePath error:nil];
    
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    
    NSLog(@"我就看看你走没走--1");
    NSLog(@"有什么：%@",launchOptions);
    NSLog(@"%ld",(long)application.applicationState);

    NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    if(url)
    {
        NSLog(@"哦案发分不开：1");
        //badge=100;
    }
    NSString *bundleId = [launchOptions objectForKey:UIApplicationLaunchOptionsSourceApplicationKey];
    if(bundleId)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ALERT" object:dateDic];
        //badge=100;
        NSLog(@"哦案发分不开：2");
    }
    UILocalNotification * localNotify = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if(localNotify)
    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ALERT" object:dateDic];
        NSLog(@"Recieved Notification %@",localNotify);
        NSLog(@"哈哈:%@,%@,%@",localNotify.alertTitle,localNotify.alertBody,localNotify.fireDate);
        titleLabelStr=localNotify.alertTitle;
        textLabelStr=localNotify.alertBody;
        NSArray *timeArrat=[textLabelStr componentsSeparatedByString:@" "];
        NSString *timeStr=timeArrat[1];
        NSString *str=[NSString stringWithFormat:@"%@",localNotify.fireDate];
        NSArray *array=[str componentsSeparatedByString:@" "];
        timeLabelStr=[timeStr substringToIndex:5];
        dataLabelStr=array[0];
//        NSArray *array = [string componentsSeparatedByString:@"A"];
        NSDictionary* infoDic = localNotify.userInfo;
        NSLog(@"%@",infoDic);
        badge=100;
        NSLog(@"哦案发分不开：3");
    }
    NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo) 
    {
        NSLog(@"哦案发分不开：4 ％@",launchOptions);
    }
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
    
    
    
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif)
    {
        NSLog(@"Recieved Notification %@",localNotif);
        NSDictionary* infoDic = localNotif.userInfo;
        NSLog(@"userInfo description=%@",[infoDic description]);
//        NSString* codeStr = [infoDic objectForKey:@"someKey"];
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
    
    //    // [2-EXT]: 获取启动时收到的APN数据
    //
    //    NSDictionary*message=[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    //
    //    if (message) {
    //
    //        NSString*payloadMsg = [message objectForKey:@"payload"];
    //
    //        NSString*record = [NSString stringWithFormat:@"[APN]%@,%@",[NSDate date],payloadMsg];
    //    }
    
    
    
    [UMSocialData setAppKey:YMAPPKEY];
    [UMFeedback setAppkey:YMAPPKEY];
    [MobClick startWithAppkey:YMAPPKEY reportPolicy:BATCH   channelId:@"Web"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setLogEnabled:YES];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wxf2061a4e235b730c" appSecret:@"0c779ea683619930a211cfec6328af6d" url:@"http://51xingzheng.cn/h5-app-download.html"];
    [UMSocialQQHandler setQQWithAppId:@"1104934408" appKey:@"bRW2glhUCR6aJYIZ" url:@"http://51xingzheng.cn/h5-app-download.html"];
    [UMSocialQQHandler setSupportWebView:YES];
    //    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];//:@"247547429" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"247547429" RedirectURL:@"http://sns.whalecloud.com"];
    //UMSocial_Sdk_Extra_Frameworks
    //打开调试日志
    [UMSocialData openLog:YES];
    
    
    
    APPLIACTION.application = application;
    APPLIACTION.leiName = @"66";
    application.applicationIconBadgeNumber = 0;
    // Add the view controller's view to the window and display.
    
    //    myDic = [[NSDictionary alloc]initWithDictionary:launchOptions];
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
    
    
//    //极光推送
//    //极光推送
//    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                   UIRemoteNotificationTypeSound |
//                                                   UIRemoteNotificationTypeAlert)
//                                       categories:nil];
//    [APService setupWithOption:launchOptions];
    
    
    
    [WXApi registerApp:WXAppKey withDescription:@"simi"];
    
    
    //    [WXApi registerApp:@"wx1c0cdfad5f3bbc79"];
    
    
    
    //    NSURL *schemeUrl = [[NSURL alloc]initWithString:@"wx1c0cdfad5f3bbc79"];
    
    //    [WXApi handleOpenURL:schemeUrl delegate:self];
    //    NSThread *thread =[[NSThread alloc]initWithTarget:self selector:@selector(getBeijingcity) object:nil];
    //    [thread start];
    
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
#pragma warning 绑定百度推送之前 先调登录接口 看是否已经绑定过
    
    //百度推送
    
    // iOS8 下需要使用新的 API
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
    //        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    //
    //        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
    //        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    //    }else {
    //        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
    //        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    //    }
    
#pragma warning 上线 AppStore 时需要修改 pushMode
//    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
//    [BPush registerChannel:launchOptions apiKey:@"Y31eOZA3t0OH8YfTQg9rKefl" pushMode:BPushModeProduction isDebug:NO];
//    
//    //        [BPush setupChannel:launchOptions];
//    
//    // 设置 BPush 的回调
//    [BPush setDelegate:self];
//    
//    // App 是用户点击推送消息启动
//    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    if (userInfo) {
//        NSLog(@"从消息启动:%@",userInfo);
//        //[BPush handleNotification:userInfo];
//    }
    
    
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
    [NSThread sleepForTimeInterval:0.1];
    //    //end
    //
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    [self ChoseRootController];
    
    
    
    return YES;
}
#pragma mark----------------APN---------------------
- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    NSLog(@"我就看看你走没走--2");
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(imageLayout:) name:@"ALERT" object:nil];
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
-(void)imageLayout:(NSNotification *)sender
{
    NSLog(@"可以传递过来么:%@",sender);
    [imageView removeFromSuperview];
    NSDictionary *dic=sender.object;
    NSString *timeStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"remind_time"]];
    NSLog(@"remind_time%@",timeStr);
    long time=[timeStr longLongValue]/1000;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    NSArray *array = [currentDateStr componentsSeparatedByString:@" "];
    NSString *timeString=array[1];
    NSString *dataString=array[0];
    //    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"消息通知" message:@"100" delegate:self cancelButtonTitle:@"不错哦" otherButtonTitles:nil];
    //    [alert show];
    imageView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
    imageView.backgroundColor=[UIColor whiteColor];
    imageView.userInteractionEnabled=YES;
    //    imageView.userinterface =YES
    [self.window addSubview:imageView];
    
    UIImageView *sceneryImage=[[UIImageView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT*0.54)];
    sceneryImage.image=[UIImage imageNamed:@"风景切图-iOS750x1334"];
    [imageView addSubview:sceneryImage];
    if (dic==nil||dic==NULL) {
        UILabel *titleLabel=[[UILabel alloc]init];
        titleLabel.text=titleLabelStr;
        titleLabel.font=[UIFont fontWithName:@"Arial" size:20];
        [titleLabel setNumberOfLines:1];
        [titleLabel sizeToFit];
//        titleLabel.backgroundColor=[UIColor brownColor];
        titleLabel.frame=FRAME((WIDTH-titleLabel.frame.size.width)/2, sceneryImage.frame.size.height+10, titleLabel.frame.size.width, 25);
        [imageView addSubview:titleLabel];
        
        UILabel *timeLabel=[[UILabel alloc]init];
        timeLabel.text=timeLabelStr;
        timeLabel.font=[UIFont fontWithName:@"Arial" size:50];
//        timeLabel.backgroundColor=[UIColor brownColor];
        [timeLabel setNumberOfLines:1];
        [timeLabel sizeToFit];
        timeLabel.frame=FRAME((WIDTH-timeLabel.frame.size.width)/2, titleLabel.frame.origin.y+titleLabel.frame.size.height+15, timeLabel.frame.size.width, 50);
        [imageView addSubview:timeLabel];
        
        UILabel *dataLabel=[[UILabel alloc]init];
        dataLabel.text=dataLabelStr;
        dataLabel.font=[UIFont fontWithName:@"Arial" size:18];
        [dataLabel setNumberOfLines:1];
        [dataLabel sizeToFit];
//        dataLabel.backgroundColor=[UIColor brownColor];
        dataLabel.frame=FRAME((WIDTH-dataLabel.frame.size.width)/2, timeLabel.frame.origin.y+timeLabel.frame.size.height+15, dataLabel.frame.size.width, 18);
        [imageView addSubview:dataLabel];
        
        UILabel *textLabel=[[UILabel alloc]init];
        textLabel.text=textLabelStr;
        UIFont *font=[UIFont fontWithName:@"Arial" size:18];
        textLabel.font=font;
        textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [textLabel setNumberOfLines:2];
        [textLabel sizeToFit];
//        textLabel.backgroundColor=[UIColor brownColor];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        
        CGSize size = [textLabel.text boundingRectWithSize:CGSizeMake(WIDTH-20, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        textLabel.frame=FRAME(20, dataLabel.frame.origin.y+dataLabel.frame.size.height+15, WIDTH-40, size.height);
        [imageView addSubview:textLabel];
    }else{
        UILabel *titleLabel=[[UILabel alloc]init];
        titleLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"remind_title"]];
        titleLabel.font=[UIFont fontWithName:@"Arial" size:20];
        [titleLabel setNumberOfLines:1];
        [titleLabel sizeToFit];
//        titleLabel.backgroundColor=[UIColor brownColor];
        titleLabel.frame=FRAME((WIDTH-titleLabel.frame.size.width)/2, sceneryImage.frame.size.height+10, titleLabel.frame.size.width, 25);
        [imageView addSubview:titleLabel];
        
        UILabel *timeLabel=[[UILabel alloc]init];
        timeLabel.text=timeString;
        timeLabel.font=[UIFont fontWithName:@"Arial" size:50];
//        timeLabel.backgroundColor=[UIColor brownColor];
        [timeLabel setNumberOfLines:1];
        [timeLabel sizeToFit];
        timeLabel.frame=FRAME((WIDTH-timeLabel.frame.size.width)/2, titleLabel.frame.origin.y+titleLabel.frame.size.height+15, timeLabel.frame.size.width, 50);
        [imageView addSubview:timeLabel];
        
        UILabel *dataLabel=[[UILabel alloc]init];
        dataLabel.text=dataString;
        dataLabel.font=[UIFont fontWithName:@"Arial" size:18];
        [dataLabel setNumberOfLines:1];
        [dataLabel sizeToFit];
//        dataLabel.backgroundColor=[UIColor brownColor];
        dataLabel.frame=FRAME((WIDTH-dataLabel.frame.size.width)/2, timeLabel.frame.origin.y+timeLabel.frame.size.height+15, dataLabel.frame.size.width, 18);
        [imageView addSubview:dataLabel];
        
        UILabel *textLabel=[[UILabel alloc]init];
        textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"remind_content"]];
        UIFont *font=[UIFont fontWithName:@"Arial" size:18];
        textLabel.font=font;
        textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [textLabel setNumberOfLines:2];
        [textLabel sizeToFit];
//        textLabel.backgroundColor=[UIColor brownColor];
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
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){1,0,0,1});
    [seeBut.layer setBorderColor:color];
    
    [imageView addSubview:seeBut];
    
    UIButton *knowBut=[[UIButton alloc]initWithFrame:FRAME((WIDTH-(WIDTH*0.36*2)-24)/2+24+WIDTH*0.36, HEIGHT-58, WIDTH*0.36, 38)];
    [knowBut setTitle:@"我知道了" forState:UIControlStateNormal];
    knowBut.backgroundColor=[UIColor redColor];
    //[knowBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [knowBut addTarget:self action:@selector(knowButAction) forControlEvents:UIControlEventTouchUpInside];
    [knowBut.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [knowBut.layer setCornerRadius:10];
    [knowBut.layer setBorderWidth:2];//设置边界的宽度
    //设置按钮的边界颜色
    CGColorSpaceRef colorSpaceRefs = CGColorSpaceCreateDeviceRGB();
    CGColorRef colors = CGColorCreate(colorSpaceRefs, (CGFloat[]){1,0,0,1});
    [knowBut.layer setBorderColor:colors];
    [imageView addSubview:knowBut];
}
-(void)seeButAction
{
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    imageView.hidden=YES;
    [imageView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ALERTPUSH" object:dateDic];
    
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
    
    // [3]:向个推服务器注册deviceToken
    
    [GeTuiSdk registerDeviceToken:_pushDeviceToken];
}
-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [GeTuiSdk resume];  // 恢复个推SDK运行
    NSLog(@"我就看看你走没走--4");
    
    completionHandler(UIBackgroundFetchResultNewData);
    
}
#pragma mark------------------------APN-------------------------
//启动页
- (void)showWord
{
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
            //            _mainController = [[MainViewController alloc] init];
            //            [_mainController networkChanged:_connectionState];
            //            nav = [[UINavigationController alloc] initWithRootViewController:_mainController];
        }else{
            //            nav  = _mainController.navigationController;
        }
    }else{//登陆失败加载登陆页面控制器
        //        _mainController = nil;
        //        LoginViewController *loginController = [[LoginViewController alloc] init];
        //        nav = [[UINavigationController alloc] initWithRootViewController:loginController];
        //        loginController.title = NSLocalizedString(@"私秘", @"EaseMobDemo");
        //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"IM登录失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [alert show];
        [self.deletate LoginFailNavpush];
        //        self.window.rootViewController = nav;
    }
    
    //设置7.0以下的导航栏
    //    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0){
    //        nav.navigationBar.barStyle = UIBarStyleDefault;
    //        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"titleBar"]
    //                                forBarMetrics:UIBarMetricsDefault];
    //
    //        [nav.navigationBar.layer setMasksToBounds:YES];
    //    }
    //
    //    [nav setNavigationBarHidden:NO];
    //    [nav setNavigationBarHidden:NO];
}
/**
 *百度推送
 **/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"我就看看你走没走--5");
    // 打印到日志 textView 中
//    badge=100;
    NSLog(@"%ld",(long)application.applicationState);

//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//角标
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"userinfo:%@",userInfo);
    
//    
//    NSString *jsonString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"card_extra"]];
//    
//    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err;
//    dict = [NSJSONSerialization JSONObjectWithData:jsonData
//                                           options:NSJSONReadingMutableContainers
//                                             error:&err];
    
    NSString *string=[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"a"]];
    
    
    
    //NSDictionary *dic=payloadMsg;
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    NSString *timeStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"remind_time"]];
    dateDic=dic;
    NSLog(@"%@",dateDic);
    NSLog(@"remind_time%@",timeStr);
    NSString *card_idStr=[dic objectForKey:@"card_id"];
    if ([card_idStr isEqualToString:@"0"]) {
        return;
    }
    NSString *actionStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"action"]];
    if ([actionStr isEqualToString:@"setclock"]) {
        badge=101;
    }else{
        badge=100;
    }
//    int pdg=[[[userInfo objectForKey:@"aps"]objectForKey:@"badge"]intValue];
//    if (pdg!=0) {
//        badge=100;
//    }else{
//        badge=100;
//    }

    int card_id=[[dic objectForKey:@"card_id"]intValue];
    int gTid=0;
    long time=[timeStr longLongValue]/1000;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    NSLog(@"时间是啥%@",currentDateStr);
    NSArray *nfArray=[[UIApplication sharedApplication]scheduledLocalNotifications];
    NSUInteger acount=[nfArray count];
    if (acount>0) {
        for (int i=0; i<acount; i++) {
            UILocalNotification *myUILocalNotification=[nfArray objectAtIndex:i];
            NSDate *dictUser=myUILocalNotification.fireDate;
            NSDictionary *userInfo=myUILocalNotification.userInfo;
            NSNumber *obj=[userInfo objectForKey:@"someKey"];
            
            NSLog(@"都有嘛东西啊？%@",myUILocalNotification);
            int mytag=[obj intValue];
            if (mytag==card_id&&dictUser==detaildate) {
                gTid=1;
            }else{
                gTid=10;
            }
        }
    }
    NSString *trueStr=[dic objectForKey:@"is_show"];
    if ([trueStr isEqual:@"true"]) {
    }
    
    if (gTid!=1) {
        UILocalNotification *notification=[[UILocalNotification alloc] init];
        if (notification!=nil) {
            
            //NSDate *now=[NSDate new];
            
            notification.fireDate=[detaildate dateByAddingTimeInterval:-0];//10秒后通知
            
            notification.repeatInterval=0;//循环次数，kCFCalendarUnitWeekday一周一次
            
            notification.timeZone=[NSTimeZone defaultTimeZone];
            
            notification.applicationIconBadgeNumber=1; //应用的红色数字
            
            
            notification.soundName=@"simivoice.caf";//声音，可以换成alarm.soundName = @"myMusic.caf"
            
            //去掉下面2行就不会弹出提示框
            notification.alertTitle=[dic objectForKey:@"remind_title"];
            notification.alertBody=[dic objectForKey:@"remind_content"];//提示信息 弹出提示框
            
            notification.alertAction = @"打开";  //提示框按钮
            
            //notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
            
            
            
            NSDictionary *infoDict = [NSDictionary dictionaryWithObject:card_idStr forKey:@"someKey"];
            
            notification.userInfo = infoDict; //添加额外的信息
            
            
            
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
        
    }else{
        
    }

    
    
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
    
    //[_clientId release];
    
    _clientId = clientId;
    NSLog(@"ID是什么？？%@",_clientId);
    NSLog(@"test:%@",APPLIACTION.deviceToken);
    _pushDeviceToken=[NSString stringWithFormat:@"%@",APPLIACTION.deviceToken];
    if (_pushDeviceToken) {
        
        [GeTuiSdk registerDeviceToken:_pushDeviceToken];
        
    }
}
-(void)GeTuiSdkDidReceivePayload:(NSString*)payloadId andTaskId:(NSString*)taskId andMessageId:(NSString *)aMsgId fromApplication:(NSString *)appId

{
    NSLog(@"我就看看你走没走--7");
    
    // [4]: 收到个推消息
//    if (badge!=100) {
        _payloadId =payloadId;
        
        NSData *payload = [GeTuiSdk retrivePayloadById:payloadId]; //根据payloadId取回Payload
        
        NSString *payloadMsg = nil;
        
        if (payload) {
            
            payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                          
                                                  length:payload.length
                          
                                                encoding:NSUTF8StringEncoding];
            
        }
        //NSDictionary *dic=payloadMsg;
        NSData *jsonData = [payloadMsg dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        NSLog(@"个推消息内容%@",dic);
    
        if (dic==nil||dic==NULL) {
            return;
        }
    NSString *actionStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"action"]];
    if ([actionStr isEqualToString:@"msg"]) {
        return;
    }
        //    NSString *record = [NSString stringWithFormat:@"%d, %@, %@",++_lastPaylodIndex, [self formateTime:[NSDate date]], payloadMsg];
        //NSString *todoString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"todo"]];
        
        NSString *timeStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"remind_time"]];
        NSLog(@"remind_time%@",timeStr);
        NSString *card_idStr=[dic objectForKey:@"card_id"];
        int card_id=[[dic objectForKey:@"card_id"]intValue];
        int gTid;
        long time=[timeStr longLongValue]/1000;//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        NSLog(@"date:%@",[detaildate description]);
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
        
        NSLog(@"时间是啥%@",currentDateStr);
        NSArray *nfArray=[[UIApplication sharedApplication]scheduledLocalNotifications];
        NSUInteger acount=[nfArray count];
        if (acount>0) {
            for (int i=0; i<acount; i++) {
                UILocalNotification *myUILocalNotification=[nfArray objectAtIndex:i];
                NSDate *dictUser=myUILocalNotification.fireDate;
                NSDictionary *userInfo=myUILocalNotification.userInfo;
                NSNumber *obj=[userInfo objectForKey:@"someKey"];
                
                NSLog(@"都有嘛东西啊？%@",myUILocalNotification);
                int mytag=[obj intValue];
                if (mytag==card_id&&dictUser==detaildate) {
                    gTid=1;
                }else{
                    gTid=10;
                }
            }
        }
        NSString *trueStr=[dic objectForKey:@"is_show"];
        if ([trueStr isEqual:@"true"]) {
            NSDate *  senddate=[NSDate date];
            
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            
            [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            UILocalNotification *notification=[[UILocalNotification alloc] init];
            if (notification!=nil) {
                
                //NSDate *now=[NSDate new];
                
                notification.fireDate=[senddate dateByAddingTimeInterval:-0];//10秒后通知
                
                notification.repeatInterval=0;//循环次数，kCFCalendarUnitWeekday一周一次
                
                notification.timeZone=[NSTimeZone defaultTimeZone];
                
                notification.applicationIconBadgeNumber=1; //应用的红色数字
                
                
                notification.soundName=@"simivoice.caf";//声音，可以换成alarm.soundName = @"myMusic.caf"
                
                //去掉下面2行就不会弹出提示框
                notification.alertTitle=[dic objectForKey:@"remind_title"];
                notification.alertBody=[dic objectForKey:@"remind_content"];//提示信息 弹出提示框
                
                //notification.alertAction = @"打开";  //提示框按钮
                
                //notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
                
                
                
                NSDictionary *infoDict = [NSDictionary dictionaryWithObject:card_idStr forKey:@"someKey"];
                
                notification.userInfo = infoDict; //添加额外的信息
                
                
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                
            }
        }
        
        if (gTid!=1) {
            UILocalNotification *notification=[[UILocalNotification alloc] init];
            if (notification!=nil) {
                
                //NSDate *now=[NSDate new];
                
                notification.fireDate=[detaildate dateByAddingTimeInterval:-0];//10秒后通知
                
                notification.repeatInterval=0;//循环次数，kCFCalendarUnitWeekday一周一次
                
                notification.timeZone=[NSTimeZone defaultTimeZone];
                
                notification.applicationIconBadgeNumber=1; //应用的红色数字
                
                
                notification.soundName=@"simivoice.caf";//声音，可以换成alarm.soundName = @"myMusic.caf"
                
                //去掉下面2行就不会弹出提示框
                notification.alertTitle=[dic objectForKey:@"remind_title"];
                notification.alertBody=[dic objectForKey:@"remind_content"];//提示信息 弹出提示框
                
                notification.alertAction = @"打开";  //提示框按钮
                
                //notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
                
                
                
                NSDictionary *infoDict = [NSDictionary dictionaryWithObject:card_idStr forKey:@"someKey"];
                
                notification.userInfo = infoDict; //添加额外的信息
                
                
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            }
            
        }else{
            
        }

//    }

    
    //    if ([todoString isEqualToString:@"get_reminds"]) {
    //        NSString *userID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"user_id"]];
    //        DownloadManager *_download = [[DownloadManager alloc]init];
    //        NSDictionary *_dicts = @{@"user_id":userID};
    //        [_download requestWithUrl:[NSString stringWithFormat:@"%@",LOGIN_TSNZ] dict:_dicts view:self.window delegate:self finishedSEL:@selector(NZDownloadFinish1:) isPost:NO failedSEL:@selector(NZDownload:)];
    //    }
    //    NSLog(@"task id : %@, messageId:%@", taskId, aMsgId);
    
    //[payloadMsg release];
    
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
    
    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
    
    // [_viewController logMsg:record];
    
    
}
- (void)GeTuiSdkDidOccurError:(NSError *)error

{
    
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    
    //    [_viewController logMsg:[NSString
    //                             stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]];
    
}
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    
    // [EXT]:通知SDK运行状态
    
    _sdkStatus = aStatus;
    
    //[_viewController updateStatusView:self];
    
}

#pragma mark--------------------APN-----------------
#pragma mark Push Delegate
- (void)onMethod:(NSString*)method response:(NSDictionary*)data
{
    //    [self.viewController addLogString:[NSString stringWithFormat:@"Method: %@\n%@",method,data]];
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
                    
                    //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_message  delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
                    //
                    //                [alert show];
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
    //微信登录
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if([resp isKindOfClass:[SendAuthResp class]])
    {
        if (aresp.errCode== 0) {
            //        NSString *code = aresp.code;
            //        NSDictionary *dic = @{@"code":code};
            NSLog(@"微信登录成功");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WEIXINDENGLU_CG" object:nil];
            [WXgetUserInfo GetTokenWithCode:aresp.code];
            
            
        }
    }
    
}



#pragma mark
- (void)ChoseRootController
{
    
    NSUserDefaults *_userdefaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"阿空军基地法咖啡%@",_userdefaults);
    NSString *_guidstring = [_userdefaults objectForKey:@"GUIDE"];
    NSLog(@"(guidstring:%@",_guidstring);
    if (_guidstring) {
        
        MyLogInViewController *controller = [[MyLogInViewController alloc]init];
        controller.vCLID=0;
        UINavigationController *navcontroller = [[UINavigationController alloc]initWithRootViewController:controller];
        self.window.rootViewController = navcontroller;
        navcontroller.navigationBarHidden = YES;
        if (_pushID!=1) {
            //设置启动页
            splashView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height)];
            
            [splashView setImage:[UIImage imageNamed:@"Default@2x"]];
            
            [self.window addSubview:splashView];
            
            [self.window bringSubviewToFront:splashView];
            
            [self performSelector:@selector(showWord) withObject:nil afterDelay:2.0f];
            
            UIActivityIndicatorView *acview = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            
            acview.center = CGPointMake((self.window.bounds.size.width/2), self.window.bounds.size.height/2+50);
            
            [splashView addSubview:acview];
            
            [acview startAnimating];
        }
        
        
        
        //end
        
    }else{
        
        GuideViewController *_controller = [[GuideViewController alloc]init];
        UINavigationController *root = [[UINavigationController alloc]initWithRootViewController:_controller];
        self.window.rootViewController = root;
        
    }
    
    
}
- (void)getBeijingcity
{
    
    //    [[DatabaseManager sharedDatabaseManager] chaxunTableName:@"cell" timeZiduan:@"C_OPER_TIME"];
    
    //    _stockDataArray = [[NSArray alloc] initWithArray:[[DatabaseManager sharedDatabaseManager] getDataRecordsByTableName:@"cell" cityid:2]];
    //    _tianjinArray = [[NSArray alloc] initWithArray:[[DatabaseManager sharedDatabaseManager] getDataRecordsByTableName:@"cell" cityid:3]];
    //    [[DatabaseManager sharedDatabaseManager] chaxuntableName:@"cell" cellId:@"3642"];
    _repartArray = [[NSMutableArray alloc]init];
    
    //    NSLog(@"stockDataArray = %@",_stockDataArray);
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    // return  [UMSocialSnsService handleOpenURL:url];
    /*
     qq登陆
     */
    
    if ([url.scheme isEqualToString:@"tencent1104934408"]) {
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
        //        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
        return [WXApi handleOpenURL:url delegate:self];
    }
    //    if ([url.scheme isEqualToString:@"1104763123"]){
    //        return  [UMSocialSnsService handleOpenURL:url];
    //    }
    
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
    
    
    //return [WXApi handleOpenURL:url delegate:self]||[TencentOAuth HandleOpenURL:url];
    
    return YES;
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"我就看看你走没走--9");
    if (_mainController) {
        [_mainController jumpToChatList];
    }
//        [BPush handleNotification:userInfo]; // 可选
    
    //    application.applicationIconBadgeNumber += 1;
    NSLog(@"userinfo:%@",userInfo);
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"消息通知" message:[[userInfo objectForKey:@"aps"]objectForKey:@"alert" ] delegate:self cancelButtonTitle:@"不错哦" otherButtonTitles:nil];
//    [alert show];
//    
//    NSString *alert2 = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
//    NSLog(@"推送的内容：%@",alert2);
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"我就看看你走没走--10");
    if(application.applicationState == UIApplicationStateActive)
    {
        NSLog(@"前台");
    }
    if (application.applicationState == UIApplicationStateBackground) {
        NSLog(@"后台");
        
    }
    if (application.applicationState == UIApplicationStateInactive) {
        NSLog(@"houtai％@,",notification);
        timeLabelStr=notification.alertTitle;
        textLabelStr=notification.alertBody;
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        dataLabelStr=[dateformatter stringFromDate:senddate];
        NSDateFormatter *timeformatter=[[NSDateFormatter alloc]init];
        [timeformatter setDateFormat:@"HH:mm"];
        timeLabelStr=[timeformatter stringFromDate:senddate];
//        NSString *  locationString=[dateformatter stringFromDate:senddate];
        
        badge=100;
    }
    //UILocalNotification *localNotif = [notification objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification)
    {
//        NSLog(@"Recieved Notification %@",notification);
//        NSDictionary* infoDic = notification.userInfo;
//        NSLog(@"userInfo description=%@",[infoDic description]);
//        NSString* codeStr = [infoDic objectForKey:@"someKey"];
    }
    
    application.applicationIconBadgeNumber = 0;
//    [APService showLocalNotificationAtFront:notification identifierKey:nil];
    
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
#pragma mark--------APN  // [EXT] APP进入后台时，通知个推SDK进入后台
    [GeTuiSdk enterBackground];
   // badge=0;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"我就看看你走没走--12");
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    badge=0;
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"badge%d",badge);
    [GeTuiSdk resume];
    //application.applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    if (badge==100) {
        NSLog(@"就时不走是吧");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ALERT" object:dateDic];
        
    }
    NSLog(@"%ld",(long)application.applicationState);
    [UMSocialSnsService  applicationDidBecomeActive];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"我就看看你走没走--13");
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
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
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
