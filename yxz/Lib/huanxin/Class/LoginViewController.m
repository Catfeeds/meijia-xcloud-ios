/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "LoginViewController.h"
#import "EMError.h"
#import "AppDelegate.h"
#import "ChatViewController.h"
#import "SERVICEDataModel.h"
#import "SERVICEData.h"
#import "EaseMob.h"
@interface LoginViewController ()<IChatManagerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


- (IBAction)doRegister:(id)sender;
- (IBAction)doLogin:(id)sender;


@end

@implementation LoginViewController

@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize registerButton = _registerButton;
@synthesize loginButton = _loginButton;
@synthesize userName;
@synthesize password;
@synthesize popOrNo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupForDismissKeyboard];
    _usernameTextField.delegate = self;
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"AppName", @"EaseMobDemo");
   
//    [self loginWithUsername:userName password:password];
//    [self loginWithUsername:@"" password:@""]; //进来就登录
}
- (void)viewWillAppear:(BOOL)animated
{
    if (popOrNo == 1){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//注册账号
- (IBAction)doRegister:(id)sender {
    if (![self isEmpty]) {
        //隐藏键盘
        [self.view endEditing:YES];
        //判断是否是中文，但不支持中英文混编
        if ([self.usernameTextField.text isChinese]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"login.nameNotSupportZh", @"Name does not support Chinese")
                                  message:nil
                                  delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                  otherButtonTitles:nil];
            
            [alert show];
            
            return;
        }
        [self showHudInView:self.view hint:NSLocalizedString(@"register.ongoing", @"Is to register...")];
        //异步注册账号
        [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:_usernameTextField.text
                                                             password:_passwordTextField.text
                                                       withCompletion:
         ^(NSString *username, NSString *password, EMError *error) {
             
             [self hideHud];
             
             if (!error) {
                 TTAlertNoTitle(NSLocalizedString(@"register.success", @"Registered successfully, please log in"));
             }else{
                 switch (error.errorCode) {
                     case EMErrorServerNotReachable:
                         TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                         break;
                     case EMErrorServerDuplicatedAccount:
                         TTAlertNoTitle(NSLocalizedString(@"register.repeat", @"You registered user already exists!"));
                         break;
                     case EMErrorServerTimeout:
                         TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                         break;
                     default:
                         TTAlertNoTitle(NSLocalizedString(@"register.fail", @"Registration failed"));
                         break;
                 }
             }
         } onQueue:nil];
    }
}

//点击登陆后的操作
- (void)loginWithUsername:(NSString *)username password:(NSString *)passWord
{
    [self showHudInView:self.view hint:NSLocalizedString(@"login.ongoing", @"Is Login...")];
    //异步登陆账号
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:passWord
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         [self hideHud];
         if (loginInfo && !error) {
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
             //发送自动登陆状态通知
             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
//             [self LogInSuccess];

             //将旧版的coredata数据导入新的数据库
             EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
             if (!error) {
                 error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             }
         }else {
             switch (error.errorCode) {
           
                 case EMErrorServerNotReachable:
                     TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                     break;
                 case EMErrorServerAuthenticationFailure:
                 {
//                     TTAlertNoTitle(error.description);
                     [self loginWithUsername:username password:passWord];
                 }
                     break;
                 case EMErrorServerTimeout:
                     TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                     break;
                 default:
                     TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Logon failure"));
//                     NSLog(@"++++++++++error:%lu",error.errorCode);
                     break;
             }
         }
     } onQueue:nil];
}
- (void)LogInSuccess
{
    
    
    
    popOrNo = 1;
    int senior = APPLIACTION.huanxinBase.is_senior;
    NSString * toID;
    NSString *userName1;
    if (senior == 1) {
        toID = APPLIACTION.huanxinBase.im_senior_username;
        userName1 = APPLIACTION.huanxinBase.im_senior_nickname;
    }else{
        toID = APPLIACTION.huanxinBase.im_robot_username;
        userName1 = APPLIACTION.huanxinBase.im_robot_nickname;
    }
    
    ChatViewController *chat = [[ChatViewController alloc] initWithChatter:toID isGroup:NO];
    chat.title = userName1;
    chat._baojie = APPLIACTION._baseSource.data.serviceTypes.baojie;
    chat._zuofan = APPLIACTION._baseSource.data.serviceTypes.zuofan;
    chat._xiyi = APPLIACTION._baseSource.data.serviceTypes.xiyi;
    chat._jiadian = APPLIACTION._baseSource.data.serviceTypes.jiadian;
    chat._caboli = APPLIACTION._baseSource.data.serviceTypes.caboli;
    chat._guandao = APPLIACTION._baseSource.data.serviceTypes.guandao;
    chat._xinju = APPLIACTION._baseSource.data.serviceTypes.xinju;
    chat.baseData = APPLIACTION.huanxinBase;
    [self.navigationController pushViewController:chat animated:YES];
}
//弹出提示的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView cancelButtonIndex] != buttonIndex) {
        //获取文本输入框
        UITextField *nameTextField = [alertView textFieldAtIndex:0];
        if(nameTextField.text.length > 0)
        {
            //设置推送设置
            [[EaseMob sharedInstance].chatManager setApnsNickname:nameTextField.text];
        }
    }
    //登陆
    [self loginWithUsername:_usernameTextField.text password:_passwordTextField.text];
}

//登陆账号
- (IBAction)doLogin:(id)sender {
    if (![self isEmpty]) {
        [self.view endEditing:YES];
        //支持是否为中文
        if ([self.usernameTextField.text isChinese]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"login.nameNotSupportZh", @"Name does not support Chinese")
                                  message:nil
                                  delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                  otherButtonTitles:nil];
            
            [alert show];
            
            return;
        }
#if !TARGET_IPHONE_SIMULATOR
        //弹出提示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"login.inputApnsNickname", @"Please enter nickname for apns") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField *nameTextField = [alert textFieldAtIndex:0];
        nameTextField.text = self.usernameTextField.text;
        [alert show];
#elif TARGET_IPHONE_SIMULATOR
        [self loginWithUsername:_usernameTextField.text password:_passwordTextField.text];
#endif
    }
}

//判断账号和密码是否为空
- (BOOL)isEmpty{
    BOOL ret = NO;
    NSString *username = _usernameTextField.text;
    NSString *passwords = _passwordTextField.text;
    if (username.length == 0 || passwords.length == 0) {
        ret = YES;
        [WCAlertView showAlertWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                                message:NSLocalizedString(@"login.inputNameAndPswd", @"Please enter username and password")
                     customizationBlock:nil
                        completionBlock:nil
                      cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                      otherButtonTitles: nil];
    }
    
    return ret;
}


#pragma  mark - TextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _usernameTextField) {
        _passwordTextField.text = @"";
    }
    
    return YES;
}

@end
