//
//  FirstViewController.m
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FirstViewController.h"

#import "SelectCityView.h"
#import "ImagesPage.h"
#import "BaojieViewController.h"
#import "ZuoFanViewController.h"
#import "XiYiViewController.h"
#import "JiaDianViewController.h"
#import "CaBoliViewController.h"
#import "GuanDaoViewController.h"
#import "XinjuViewController.h"
#import "RemindViewController.h"
#import "ImgWebViewController.h"

#import "DownloadManager.h"
#import "SERVICEDataModel.h"
#import "SERVICEData.h"
#import "AppDelegate.h"
#import "ChoiceDefine.h"
#import "ISLoginManager.h"
#import "AdScrollView.h"
#import "HuanxinBase.h"
//#import "MyLogInViewController.h"
#import "UserDressMapViewController.h"
//环信
#import "LoginViewController.h"
#import "MainViewController.h"
#import "ChatViewController.h"
#import "DXRecordView.h"
#import "DXMessageToolBar.h"

#import "WeiXinPay.h"

@interface FirstViewController ()<SelectCityDelegate,adScrollDelegate,appDelegate,DXMessageToolBarDelegate>
{
    UIButton *citybtn;
    SelectCityView *listView;
//    ImagesPage *myImagePage;
    SERVICEBaseClass *_baseclass;
    NSString *simi_call;
    UIScrollView *_myscroll;
    float _height;
    HuanxinBase *UserData;
    UIImageView *xiajiantou;
    UIButton *rightbtn;
}
@end

@implementation FirstViewController
#define XSPACE 16
#define YSPACE 64

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    self.navlabel.text = @"私 秘";
    self.backBtn.hidden = YES;
//    self.navlabel.backgroundColor = HEX_TO_UICOLOR(ROUND_COLOR, 1.0);
    
    [self.navigationController setNavigationBarHidden:YES];
    
    //导航栏title颜色
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    //状态栏字体颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}
- (void) GetBasicData{
    DownloadManager *_download = [[DownloadManager alloc]init];
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",BASE_API] dict:nil view:self.view  delegate:self finishedSEL:@selector(DownlLoadFinish:) isPost:NO failedSEL:@selector(DownloadFail:)];
}
- (void)DownlLoadFinish:(id)dict
{
    
   // int status = [[dict objectForKey:@"status"] intValue];
    
    //NSDictionary *baseDic = [dict objectForKey:@"data"];
    
    //NSString *service_call = [baseDic objectForKey:@"service_call"];
    
    
    
    
    
    _baseclass = [[SERVICEBaseClass alloc]initWithDictionary:dict];
    
    APPLIACTION._baseSource = _baseclass;
    
    simi_call =_baseclass.data.simiCall;
    
    APPLIACTION.callNum = simi_call;
    
    NSLog(@" ============  %@   ............. %@        >>>>>>>>>>>>>> %@",_baseclass.data.bannerAd,_baseclass.data.serviceCall,_baseclass.data.serviceTypes);
    
    for (int i = 0; i < _baseclass.data.bannerAd.count; i++) {
        SERVICEBannerAd *_admodel = [_baseclass.data.bannerAd objectAtIndex:i];
        NSLog(@"id is %f \n  img_url is %@",_admodel.bannerAdIdentifier,_admodel.imgUrl);
    }
    
//    ImagesPage *myImagePage = [[ImagesPage alloc]initWithFrame:FRAME(0, YSPACE, SELF_VIEW_WIDTH,244/2) imgArray:_baseclass.data.bannerAd];
//    
//  
//    myImagePage.delegate = self;
//    
//    [self.view addSubview:myImagePage];
    
    [self createScrollView];
    
//    [self CityBtn];
    
    [self getUserInfo];
    
    
}

#pragma mark - 构建广告滚动视图
- (void)createScrollView
{
    NSMutableArray *imgUrlarray = [[NSMutableArray alloc]init ];
    NSMutableArray *imgGoUrlarray = [[NSMutableArray alloc]init ];
    for (int i = 0; i < _baseclass.data.bannerAd.count; i++) {
        SERVICEBannerAd *_admodel = [_baseclass.data.bannerAd objectAtIndex:i];
        [imgUrlarray addObject:_admodel.imgUrl];
        [imgGoUrlarray addObject:_admodel.gotoUrl];
    }

    AdScrollView * scrollView = [[AdScrollView alloc]initWithFrame:CGRectMake(0, YSPACE-_height, SELF_VIEW_WIDTH, 244/2)];
    scrollView.delegateGHP = self;
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    scrollView.userInteractionEnabled = YES;
    scrollView.imageNameArray = imgUrlarray;
    scrollView.imgGoUrlArray = imgGoUrlarray;
    scrollView.PageControlShowStyle = UIPageControlShowStyleRight;
    scrollView.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    
//    NSArray *array = [[NSArray alloc]initWithObjects:@"123",@"456",@"789", nil];
//   [scrollView setAdTitleArray:array withShowStyle:AdTitleShowStyleLeft];
    scrollView.pageControl.frame = FRAME(SELF_VIEW_WIDTH-50, 170-_height, 40, 20);
    scrollView.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    
    [_myscroll addSubview:scrollView];
    
    UIImageView *img = (UIImageView *)[_myscroll viewWithTag:666];
    img.hidden = YES;
}
-(void)goUrlIs:(NSString *)url{
    ImgWebViewController *web = [[ImgWebViewController alloc]init];
    web.imgurl = url;
    if (url.length != 0) {
        [self.navigationController pushViewController:web animated:YES];
    }
    
}
-(void)CityBtn
{
    citybtn = [UIButton buttonWithType:UIButtonTypeCustom];
    citybtn.frame = CGRectMake(12, 20, 54, 44);
    [citybtn setTitle:@"北京" forState:UIControlStateNormal];
    citybtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [citybtn setTitleColor:HEX_TO_UICOLOR(TEXT_COLOR, 1.0) forState:UIControlStateNormal];
    [citybtn addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    citybtn.userInteractionEnabled = YES;
    [self.view addSubview:citybtn];
    
    xiajiantou = [[UIImageView alloc]initWithFrame:CGRectMake(56, 34, 18, 18)];
    [xiajiantou setImage:[UIImage imageNamed:@"xianxiajiantou"]];
    xiajiantou.tag = 200;
    [self.view addSubview:xiajiantou];
    
    NSArray *dressArr = @[@"北京",@"天津"];
    
    listView = [[SelectCityView alloc]initWithFrame:FRAME(16, 25, 70, 0) titleArray:dressArr];
    listView.hidden = YES;
    listView.delegate = self;
    [_myscroll addSubview:listView];
}

- (void)DownloadFail:(id)errorstr
{
    NSLog(@"errsor   :   %@",errorstr);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginSuccess:) name:@"LOGIN_SUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReviceNotifation:) name:@"REVICENOTIFICATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    _myscroll.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _height = (_HEIGHT == 480) ? 64 : 0;
    NSLog(@"%.f",_height);
    _myscroll = [[UIScrollView alloc]initWithFrame:FRAME(0, 0, _WIDTH, _HEIGHT-49)];
    if (_HEIGHT == 480) {
        _myscroll.frame = FRAME(0, 64, _WIDTH, _HEIGHT-49-64);
        [_myscroll setContentSize:CGSizeMake(_WIDTH, 568-64)];
    }
    [self.view addSubview:_myscroll];
    
    rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbtn.frame = FRAME(SELF_VIEW_WIDTH-18-20-10, (40-60/2)/2+20+2, 60/2, 60/2);
    [rightbtn setTitle:@"" forState:UIControlStateNormal];
    [rightbtn setImage:[UIImage imageNamed:@"index-cellphone"] forState:UIControlStateNormal];
    [rightbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [rightbtn addTarget:self action:@selector(CallAction:) forControlEvents:UIControlEventTouchUpInside];
    rightbtn.tag =100;
    [self.view addSubview:rightbtn];
    
    UIButton *dian = [[UIButton alloc]initWithFrame:FRAME(25, 3, 6, 6)];
    dian.tag = 321;
    dian.hidden = YES;
    [dian setBackgroundImage:[UIImage imageNamed:@"dot_@2x"] forState:UIControlStateNormal];
    [rightbtn addSubview:dian];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *unRead = [user objectForKey:@"UNREADMESSAGES"];
    if ([unRead isEqualToString:@"66"]) {
        dian.hidden = NO;
    }else{
        dian.hidden = YES;
    }
    [user synchronize];
    
    NSArray *ImageArray = [[NSArray alloc]initWithObjects:@"index-tixing",@"index-zuofan",@"index-xiyi",@"index-jiadianqingxi", nil];
    for (int i = 0; i < 4; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = FRAME(27+(27+46.25)*i, YSPACE+244/2+38/2-_height, 46.25, 46.25);
        [btn setBackgroundColor:[UIColor clearColor]];
        btn.tag = i+1;
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",ImageArray[i]]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(FirstAction:) forControlEvents:UIControlEventTouchUpInside];
        [_myscroll addSubview:btn];
    }
    NSArray *btnTitles = [[NSArray alloc]initWithObjects:@"提醒",@"做饭",@"洗衣",@"家电清洗", nil];
    for (int i = 0; i < 4; i++) {
        UILabel *btntitles = [[UILabel alloc]initWithFrame:FRAME(23+(74*i), YSPACE+244/2+38/2+46.25+2-_height, 50, 20)];
        btntitles.font = [UIFont systemFontOfSize:12];
        btntitles.text = [NSString stringWithFormat:@"%@",btnTitles[i]];
        btntitles.textColor = HEX_TO_UICOLOR(0x7A7A7A, 1.0);
        btntitles.textAlignment = 1;
        [_myscroll addSubview:btntitles];
    }
    
    NSArray *ImageArray2 = [[NSArray alloc]initWithObjects:@"index-baojie",@"index-caboli",@"index-guandaoshutong",@"index-xinjukaihuang", nil];
    for (int i = 0; i < 4; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = FRAME(27+(27+46.25)*i, YSPACE+244/2+38/2+46.25+33-_height, 46.25, 46.25);
        [btn setBackgroundColor:[UIColor clearColor]];
        btn.tag = i+20;
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",ImageArray2[i]]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(secondAction:) forControlEvents:UIControlEventTouchUpInside];
        [_myscroll addSubview:btn];
    }
    
    NSArray *btnTitles2 = [[NSArray alloc]initWithObjects:@"保洁",@"擦玻璃",@"管道疏通",@"新居开荒", nil];
    for (int i = 0; i < 4; i++) {
        UILabel *btntitles = [[UILabel alloc]initWithFrame:FRAME(23+(74*i), YSPACE+244/2+38/2+46.25+46.25+33+2-_height, 50, 20)];
        btntitles.font = [UIFont systemFontOfSize:12];
        btntitles.text = [NSString stringWithFormat:@"%@",btnTitles2[i]];
        btntitles.textColor = HEX_TO_UICOLOR(0x7A7A7A, 1.0);
        btntitles.textAlignment = 1;
        [_myscroll addSubview:btntitles];
    }
    
//    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftbtn.frame = FRAME(31, 726/2+176/4+10, 78/2, 78/2);
//    [leftbtn setBackgroundImage:[UIImage imageNamed:@"index-left-arrow"] forState:UIControlStateNormal];
//    [leftbtn setBackgroundImage:[UIImage imageNamed:@"index-left-pressdown"] forState:UIControlStateHighlighted];
//    [_myscroll addSubview:leftbtn];
    
    UIButton *centbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    centbtn.frame = FRAME(31+78/2+22, 726/2+10-_height, 273/2, 273/2);
    [centbtn setBackgroundImage:[UIImage imageNamed:@"calling-btn"] forState:UIControlStateNormal];
    [centbtn setBackgroundImage:[UIImage imageNamed:@"calling-btn-pressdown"] forState:UIControlStateHighlighted];
    [centbtn addTarget:self action:@selector(CallAction:) forControlEvents:UIControlEventTouchUpInside];
    [centbtn setTag:200];
    [_myscroll addSubview:centbtn];
    
//    UIButton *rigbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rigbtn.frame = FRAME(31+78/2+22+273/2+22, 726/2+176/4+10, 78/2, 78/2);
//    [rigbtn setBackgroundImage:[UIImage imageNamed:@"index-right-arrow"] forState:UIControlStateNormal];
//    [rigbtn setBackgroundImage:[UIImage imageNamed:@"index-right-pressdown"] forState:UIControlStateHighlighted];
//    [_myscroll addSubview:rigbtn];
    
    
    //banner默认图片
    
    UIImageView *bannerImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, YSPACE-_height, SELF_VIEW_WIDTH, 244/2)];
    bannerImg.image = [UIImage imageNamed:@"bannerMoren"];
    bannerImg.tag = 666;
    [_myscroll addSubview:bannerImg];
    
//    [self GetBasicData];


    
    
//    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(0, 0, SELF_VIEW_WIDTH, SELF_VIEW_HEIGHT)];
//    img.image = [UIImage imageNamed:@"Default@2x"];
//    img.userInteractionEnabled = NO;
//    [self.view addSubview:img];
    
//    ISLoginManager *logManager = [[ISLoginManager alloc]init];
//    
//    if (logManager.isLogin == NO) {
//        MyLogInViewController *log = [[MyLogInViewController alloc]init];
//        log.leiMing = @"首页";
//        [self.navigationController pushViewController:log animated:YES];
////        [self.navigationController presentViewController:log animated:YES completion:nil];
//        
//    }else{
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//
//        NSString *tohxuserID = [userDefaults objectForKey:@"TOHXUSERID"];
//        NSString *tohxuserName = [userDefaults objectForKey:@"TOHXUSERNAME"];
//        
//        //自动登录
//        BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
//
//        if (tohxuserID && isAutoLogin) {
//            
//            ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:tohxuserID isGroup:NO];
//            chatVC.title = tohxuserName;
//            [chatVC.navigationController setNavigationBarHidden:NO];
//            [self.navigationController pushViewController:chatVC animated:YES];
//            
//        }else{
//            [self getUserInfo];
//
//        }
//        
//
//    }

}
- (void)loginStateChange:(NSNotification *)obj
{
    [self CallTelephone];
}
- (void)ReviceNotifation:(NSNotification *)obj
{
    UIButton *btn = (UIButton *)[rightbtn viewWithTag:321];
    btn.hidden = NO;
}
-(void)LoginSuccess:(NSNotification *)obj
{
    [self getUserInfo];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LOGIN_SUCCESS" object:nil];

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
    NSLog(@"这里可能是秘书的信息%@",dic);
    NSDictionary *dict = [dic objectForKey:@"data"];
    int status = [dict[@"status"] intValue];
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

        
#pragma  warning 1.8版本 首页主要改动
        ISLoginManager *logManager = [[ISLoginManager alloc]init];

        if (logManager.isLogin == YES) {
            [self CallTelephone];
        }
        
    }
    if(status){
        NSLog(@"1");
        
    }
}


- (void)getUserInfoFail:(id)error
{
    NSLog(@"%@",error);
}
#pragma mark 打电话
- (void)CallAction:(UIButton *)sender
{
    if(sender.tag == 100){

#pragma  warning 测试用
        UIButton *btn = (UIButton *)[rightbtn viewWithTag:321];
        btn.hidden = YES;
//        
        ImgWebViewController *img = [[ImgWebViewController alloc]init];
        img.imgurl = @"http://123.57.173.36/simi-wwz/wwz/news_list.html";
        img.title = @"消息列表";
        [self.navigationController pushViewController:img animated:YES];
//        
//        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:@"55" forKey:@"UNREADMESSAGES"];
        [user synchronize];
        
        
//        UserDressMapViewController *map = [[UserDressMapViewController alloc]init];
//        [self.navigationController pushViewController:map animated:YES];
        
        
//        [WeiXinPay pay:nil];
//        payRequsestHandler *pay = [[payRequsestHandler alloc]init];
//        [pay sendPay_demo];
        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"联系我们的客服专线" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        
//        [alert show];
    }else{
//        DXMessageToolBar *mess = [[DXMessageToolBar alloc]init];
////        [mess.delegate didStartRecordingVoiceAction:mess.recordView];
//        [mess recordButtonTouchDown];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"与客服在线交流" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        
//        [alert show];
        
        [self CallTelephone];
        
    }


}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{


    if (alertView.tag == 10) {
        if (buttonIndex == 0) {
        }else{
//            MyLogInViewController *login = [[MyLogInViewController alloc]init];
//            login.vCLID=0;;
//            [self.navigationController presentViewController:login animated:YES completion:nil];
        }
    }

}
- (void)CallTelephone
{
//    NSString *phoneNum = @"";// 电话号码
//
//    phoneNum = simi_call;
// 
//    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
//    
//    UIWebView *phoneCallWebView;
//    
//    if ( !phoneCallWebView ) {
//        
//        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
//        
//    }
//    
//    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
//    
//    [_myscroll addSubview:phoneCallWebView];
    
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
- (void)LoginSuccessNavPush
{
    //判断是否真人聊天
//    NSString *imToUserID;
//    imToUserID = self.imToUserID;
    
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:self.imToUserID isGroup:NO];
    chatVC.title = self.imToUserName;
    [chatVC.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:chatVC animated:YES];
    
}
#pragma mark 点击城市按钮
- (void)selectCity:(UIButton *)sender
{
    xiajiantou.hidden = YES;
    [citybtn setTitle:@"" forState:UIControlStateNormal];
    citybtn.userInteractionEnabled = NO;
    if (listView.frame.size.height < 10) {
        listView.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^void{
            listView.frame = FRAME(XSPACE, 25, 70, 72);
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^void{
            listView.hidden = YES;
            listView.frame = FRAME(XSPACE, 25, 70, 0);
        }]; 
    }

}
- (void)SelectCtiyDelegate:(NSString *)btntitle
{
    [UIView animateWithDuration:0.25 animations:^void{
        listView.hidden = YES;
        listView.frame = FRAME(XSPACE, 25, 70, 0);
    }];
    [citybtn setUserInteractionEnabled:YES];
    [citybtn setTitle:btntitle forState:UIControlStateNormal];
    
    xiajiantou.hidden = NO;
}
#pragma mark 第一排按钮点击事件
- (void)FirstAction:(UIButton *)sender
{
    if (sender.tag == 1) {
        RemindViewController *reming = [[RemindViewController alloc]init];
        [self.navigationController pushViewController:reming animated:YES];
    }
    if(sender.tag == 2)
    {
        ZuoFanViewController *zuofan = [[ZuoFanViewController alloc]init];
        zuofan.model = _baseclass.data.serviceTypes.zuofan;
        [self.navigationController pushViewController:zuofan animated:YES];
    }
    if(sender.tag == 3)
    {
        XiYiViewController *xiyi = [[XiYiViewController alloc]init];
        xiyi.model = _baseclass.data.serviceTypes.xiyi;
        [self.navigationController pushViewController:xiyi animated:YES];
    }
    if(sender.tag == 4)
    {
        JiaDianViewController *jiadain = [[JiaDianViewController alloc]init];
        jiadain.model = _baseclass.data.serviceTypes.jiadian;
        [self.navigationController pushViewController:jiadain animated:YES];
    }
}
#pragma mark 第二排按钮点击事件
- (void)secondAction:(UIButton *)sender
{
    if (sender.tag == 20) {
        BaojieViewController *baojie = [[BaojieViewController alloc]init];
        baojie.baojieModel = _baseclass.data.serviceTypes.baojie;
        [self.navigationController pushViewController:baojie animated:YES];
    }
    if (sender.tag == 21) {
        CaBoliViewController *caboli = [[CaBoliViewController alloc]init];
        caboli.bolimodel = _baseclass.data.serviceTypes.caboli;
        [self.navigationController pushViewController:caboli animated:YES];
    }
    if (sender.tag == 22) {
        GuanDaoViewController *guandao = [[GuanDaoViewController alloc]init];
        guandao.model = _baseclass.data.serviceTypes.guandao;
        [self.navigationController pushViewController:guandao animated:YES];
    }
    if (sender.tag == 23) {
        XinjuViewController *xinju = [[XinjuViewController alloc]init];
        xinju.model = _baseclass.data.serviceTypes.xinju;
        [self.navigationController pushViewController:xinju animated:YES];
    }
}
#pragma mark 图片点击代理
//- (void)imgdelegate:(UIButton *)btn imgUrl:(NSString *)url
//{
//    ImgWebViewController *web = [[ImgWebViewController alloc]init];
//    web.imgurl = url;
//    [self.navigationController pushViewController:web animated:YES];
//}
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