//
//  BindMobileViewController.m
//  yxz
//
//  Created by 白玉林 on 15/11/17.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "BindMobileViewController.h"

#import "MBProgressHUD+Add.h"

@interface BindMobileViewController ()
{
    NSTimer *countDownTimer;
    NSInteger secondsDown;
}

@end

@implementation BindMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    secondsDown=60;
    self.title=@"绑定手机号";
    UIButton *liftButton=[[UIButton alloc]initWithFrame:FRAME(0, 20, 70, 44)];
    [liftButton addTarget:self action:@selector(liftAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:liftButton];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (44-20)/2, 10, 20)];
    img.image = [UIImage imageNamed:@"title_left_back"];
    [liftButton addSubview:img];
    
    UIView *bindMobileView=[[UIView alloc]initWithFrame:FRAME(0, 84, WIDTH, 121)];
    bindMobileView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bindMobileView];
    
    _mobileField=[[UITextField alloc]initWithFrame:FRAME(0, 0, WIDTH-100, 60)];
    _mobileField.placeholder=@"请输入手机号";
    _mobileField.delegate=self;
    [bindMobileView addSubview:_mobileField];
    _veriFicationButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-100, 10, 80, 40)];
    _veriFicationButton.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [_veriFicationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    _veriFicationButton.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    _veriFicationButton.layer.cornerRadius=10;
    _veriFicationButton.clipsToBounds=YES;
    [_veriFicationButton addTarget:self action:@selector(veriButAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [bindMobileView addSubview:_veriFicationButton];
    
    UIView *lineView=[[UIView alloc]initWithFrame:FRAME(0, 60, WIDTH, 1)];
    lineView.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    [bindMobileView addSubview:lineView];
    
    _veriFicationField=[[UITextField alloc]initWithFrame:FRAME(0, 61, WIDTH, 60)];
    _veriFicationField.placeholder=@"请输入验证码";
    _veriFicationField.delegate=self;
    [bindMobileView addSubview:_veriFicationField];
    
    UIButton *suBmit=[[UIButton alloc]initWithFrame:FRAME(20, bindMobileView.frame.size.height+bindMobileView.frame.origin.y+10, WIDTH-40, 60)];
    suBmit.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    suBmit.layer.cornerRadius=10;
    suBmit.clipsToBounds=YES;
    [suBmit addTarget:self action:@selector(suBmitAction:) forControlEvents:UIControlEventTouchUpInside];
    [suBmit setTitle:@"绑定" forState:UIControlStateNormal];
    [self.view addSubview:suBmit];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:FRAME(20, suBmit.frame.size.height+suBmit.frame.origin.y+30, WIDTH-40, 17)];
    titleLabel.text=@"绑定手机号后，我们的服务和礼品将能更快捷的送达!";
    [self.view addSubview:titleLabel];
    
    // Do any additional setup after loading the view.
}
-(void)liftAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark  获取验证码按钮点击方法
-(void)veriButAction:(UIButton*)sender
{
    NSLog(@"获取验证码");
    NSString *phonestring = _mobileField.text;
    NSString * MOBILE = @"1[0-9]{10}";
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
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

#pragma mark 验证码请求
- (void)getYanzhengma
{
    
    //请求成功之后 开始倒计时
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *param = @{@"mobile":_mobileField.text,@"sms_type":@"0"};
    
    [_download requestWithUrl:GET_YANZHENGMA dict:param view:self.view delegate:self finishedSEL:@selector(GetyanzhengmaFinish:) isPost:NO failedSEL:@selector(DownFail:)];
    
    [self numberDown];
}

#pragma mark 获取验证码失败返回方法
-(void)DownFail:(id)sender
{
    NSLog(@"验证码获取失败%@",sender);
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
    _veriFicationButton.backgroundColor = [UIColor grayColor];
    _veriFicationButton.userInteractionEnabled = NO;
}
-(void)timeFireMethod{
    secondsDown--;
    
    [_veriFicationButton setTitle:[NSString stringWithFormat:@"%lds",(long)secondsDown] forState:UIControlStateNormal];
    if(secondsDown==0){
        [countDownTimer invalidate];
        [_veriFicationButton setBackgroundColor:HEX_TO_UICOLOR(0xE8374A, 1.0)];
        [_veriFicationButton setTitle:@"重发验证码" forState:UIControlStateNormal];
        _veriFicationButton.userInteractionEnabled = YES;
        secondsDown = 60;
        
    }
}

#pragma mark 绑定手机号按钮点击方法
-(void)suBmitAction:(UIButton *)sender
{
    NSLog(@"绑定手机号");
    if(_mobileField.text.length == 0){
        [MBProgressHUD showError:@"请输入手机号" toView:self.view];
        return;
    }
    if(_veriFicationField.text.length == 0){
        [MBProgressHUD showError:@"请输入验证码" toView:self.view];
        return;
    }
    ISLoginManager *user=[ISLoginManager shareManager];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *name=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"name"]];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *param = @{@"user_id":user.telephone,@"mobile":_mobileField.text,@"name":name,@"sms_token":_veriFicationField.text};
    
    [_download requestWithUrl:USER_SJBD dict:param view:self.view delegate:self finishedSEL:@selector(SjbdFinish:) isPost:YES failedSEL:@selector(SjbdDownFail:)];
}
#pragma mark 用户绑定手机号成功返回
-(void)SjbdFinish:(id)sender
{
    NSLog(@"用户绑定手机号成功%@",sender);
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSLog(@"有值么%@",_manager.telephone);
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict=@{@"user_id":_manager.telephone};
    [_download requestWithUrl:USER_INFO dict:_dict view:self.view delegate:self finishedSEL:@selector(QJDowLoadFinish:) isPost:NO failedSEL:@selector(QJDownFail:)];
}
#pragma mark 用户绑定手机号失败返回
-(void)SjbdDownFail:(id)sender
{
    NSLog(@"用户绑定手机号失败%@",sender);
}

#pragma mark用户信息详情获取成功方法
-(void)QJDowLoadFinish:(id)sender
{
    NSLog(@"数据详情%@",sender);
    NSDictionary *dic=[sender objectForKey:@"data"];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.globalDic=@{@"user_id":[dic objectForKey:@"id"],@"sec_id":[dic objectForKey:@"sec_id"],@"is_senior":[dic objectForKey:@"is_senior"],@"senior_range":[dic objectForKey:@"senior_range"],@"mobile":[dic objectForKey:@"mobile"],@"user_type":[dic objectForKey:@"user_type"],@"name":[dic objectForKey:@"name"],@"has_company":[dic objectForKey:@"has_company"],@"head_img":[dic objectForKey:@"head_img"],@"company_id":[dic objectForKey:@"company_id"],@"company_name":[dic objectForKey:@"company_name"]};
    NSLog(@"看看是什么啊%@",delegate.globalDic);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark用户信息详情获取失败方法
-(void)QJDownFail:(id)sender
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