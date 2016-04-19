//
//  FatherViewController.m
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
//#import "ChatViewController.h"
#import "DownloadManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "ISLoginManager.h"
#import "ImgWebViewController.h"
@interface FatherViewController ()<UIAlertViewDelegate>
{
    NSString *url;
    NSString *webTitle;
}
@end

@implementation FatherViewController
@synthesize navlabel = _navlabel;
@synthesize backBtn = _backBtn;
@synthesize hxPassword,hxUserName,imToUserID,imToUserName,ID,backlable,helpBut,img;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_TO_UICOLOR(BAC_VIEW_COLOR, 1.0);
    
    
    
    backlable = [[UIView alloc]initWithFrame:FRAME(0, 0, SELF_VIEW_WIDTH, NAV_HEIGHT)];
    backlable.backgroundColor = HEX_TO_UICOLOR(0xf9f9f9, 1.0);
    [self.view addSubview:backlable];
    
    _navlabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 20, self.view.frame.size.width-100, 44)];
    _navlabel.backgroundColor = [UIColor clearColor];
    _navlabel.textAlignment = NSTextAlignmentCenter;
    _navlabel.font = [UIFont systemFontOfSize:16];
    _navlabel.textColor = [UIColor blackColor];
    [self.view addSubview:_navlabel];
    
    helpBut=[[UIButton alloc]init];
//    helpBut.backgroundColor=[UIColor redColor];
    helpBut.hidden=YES;
    [helpBut addTarget:self action:@selector(helpButAvtion:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:helpBut];
    
    _lineLable = [[UILabel alloc]initWithFrame:FRAME(0, 63, SELF_VIEW_WIDTH, 1)];
    _lineLable.backgroundColor = [UIColor grayColor];
    _lineLable.alpha = 0.3;
    [self.view addSubview:_lineLable];

    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = FRAME(0, 20, 60, 40);
    _backBtn.tag=33;
    _backBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    
    img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 10, 20)];
    img.image = [UIImage imageNamed:@"title_left_back"];
    [_backBtn addSubview:img];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openWebView:) name:@"OPENWEBVIEW" object:nil];
    
}

-(void)helpButAvtion:(UIButton *)button
{
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    WebPageViewController *webVC=[[WebPageViewController alloc]init];
    webVC.webURL=[NSString stringWithFormat:@"http://123.57.173.36/simi-h5/show/help-%@.html",_tyPeStr];
//    [webVC setModalTransitionStyle:UIModalTransitionStylePartialCurl];
     UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:webVC];
    webVC.vcIDs=1000;
    webVC.barIDS=100;
    [[self getCurrentVC] presentViewController:nav animated:YES completion:nil];
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

-(void)todoSomething
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backAction
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething) object:nil];
    [self performSelector:@selector(todoSomething) withObject:nil afterDelay:0.2f];
    
//    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    
}   
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openWebView:(NSNotification *)obj
{

    NSLog(@"%@",obj.object);
    url = [obj.object objectForKey:@"msgid"];
    ISLoginManager *manager = [[ISLoginManager alloc]init];
    if (![url isEqualToString:@""]&& url !=nil) {
          url = [NSString stringWithFormat:
                            @"http://123.57.173.36/simi-oa/upload/html/%@.html?mobile='%@'",
                             [obj.object objectForKey:@"msgid"],
                             manager.telephone];
//        url = [NSString stringWithFormat:@"%@%@",[obj.object objectForKey:@"url"],mobile];
    }
//    webTitle = [[obj.object objectForKey:@"aps"]objectForKey:@"alert" ];
    webTitle = @"消息";

    if (![url isEqualToString:@""]&& url != nil) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"消息通知" message:[[obj.object objectForKey:@"aps"]objectForKey:@"alert" ] delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"现在查看", nil];
        
        [alert show];
    }
    
    if([url isEqualToString:@""]||url == nil){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"消息通知" message:[[obj.object objectForKey:@"aps"]objectForKey:@"alert" ] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        ImgWebViewController *web = [[ImgWebViewController alloc]init];
        web.imgurl = url;
        web.title = webTitle;
        [self.navigationController pushViewController:web animated:YES];
    }
}

#pragma mark 返回字符串高度
- (CGSize)returnMysizeWithCgsize:(CGSize)mysize text:(NSString*)mystring font:(UIFont*)myfont
{
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:myfont,NSFontAttributeName, nil];
    CGSize size = [mystring boundingRectWithSize:mysize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    return size;
}

- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize]
                         constrainedToSize:CGSizeMake(width -16.0, CGFLOAT_MAX)
                             lineBreakMode:NSLineBreakByWordWrapping];
    //此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height + 16.0;
}

#pragma mark 颜色值
-(UIColor *)getColor:(NSString *)hexColor
{
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    
    range.location =0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:1.0f];
}
//时间戳转字符串
- (NSString *)getTimeWithstring:(NSTimeInterval)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *theday = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *day = [dateFormatter stringFromDate:theday];
    
    return day;
}


#pragma mark
#pragma mark AlertView
- (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message

{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message  delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
    
    [alert show];
}

- (void)pushToIM
{
    
    BOOL login = [self loginYesOrNo];
    if (login == YES) {

    }
    else{
        return;
    }
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

//    NSString *to = [userDefaults objectForKey:@"TOHXUSERID"];
//    NSString *name = [userDefaults objectForKey:@"TOHXUSERNAME"];
}
//判断是否登录
-(BOOL)loginYesOrNo
{
    ISLoginManager *manager = [ISLoginManager shareManager];
    if (manager.isLogin) {
        return YES;
    }else{
        return NO;
    }
   
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
