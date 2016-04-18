//
//  Modify_InformationViewController.m
//  yxz
//
//  Created by 白玉林 on 16/4/15.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "Modify_InformationViewController.h"
#import "SettingsViewController.h"
#import "UMComShowToast.h"
#import "UMComSession.h"
@interface Modify_InformationViewController ()
{
    UITextField *nameField;
}
@end

@implementation Modify_InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.userAccount) {
        self.userAccount = [[UMComUserAccount alloc]initWithSnsType:UMComSnsTypeSelfAccount];
    }
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = FRAME(0, 0, 60, 40);
    _backBtn.tag=33;
    _backBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_backBtn addTarget:self action:@selector(gotoBack) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:_backBtn];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 10, 20)];
    img.image = [UIImage imageNamed:@"title_left_back"];
    [_backBtn addSubview:img];
    
    self.title=@"修改昵称";
    UILabel *textLabel=[[UILabel alloc]init];
    textLabel.lineBreakMode=NSLineBreakByWordWrapping;
    textLabel.text=@"    您的用户名（昵称）已被占用，请修改昵称登录 ，否则将无法登录成功！";
    [textLabel setNumberOfLines:0];
    [textLabel sizeToFit];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
    
    CGSize size = [textLabel.text boundingRectWithSize:CGSizeMake(WIDTH-20, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    textLabel.font=[UIFont fontWithName:@"Heiti SC" size:18];
    textLabel.frame=FRAME(20, 80, WIDTH-40, size.height);
    [self.view addSubview:textLabel];
    
    
    
    UIView *lineView=[[UIView alloc]initWithFrame:FRAME(0, size.height+100, WIDTH, 1)];
    lineView.backgroundColor=[UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1];
    [self.view addSubview:lineView];
    UILabel *nameLabel=[[UILabel alloc]init];
    nameLabel.text=@"昵称:";
    nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:18];
    [nameLabel setNumberOfLines:1];
    [nameLabel sizeToFit];
    nameLabel.frame=FRAME(20, lineView.frame.origin.y+10, nameLabel.frame.size.width, 30);
    [self.view addSubview:nameLabel];
    nameField=[[UITextField alloc]initWithFrame:FRAME(nameLabel.frame.origin.x+nameLabel.frame.size.width+10, lineView.frame.origin.y+10, WIDTH-(40+nameLabel.frame.size.width+10), 30)];
    nameField.placeholder=@"请输入昵称";
    nameField.delegate=self;
    nameField.textAlignment=NSTextAlignmentRight;
    nameField.font=[UIFont fontWithName:@"Heiti SC" size:15];
    [self.view addSubview:nameField];
    
    UIView *lineDownView=[[UIView alloc]initWithFrame:FRAME(0, lineView.frame.origin.y+50, WIDTH, 1)];
    lineDownView.backgroundColor=[UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1];
    [self.view addSubview:lineDownView];
    
    
    UIButton *modifyBut=[[UIButton alloc]initWithFrame:FRAME(14, lineDownView.frame.origin.y+20, WIDTH-28, 40)];
    [modifyBut setTitle:@"保存" forState:UIControlStateNormal];
    modifyBut.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [modifyBut addTarget:self action:@selector(modifyBut:) forControlEvents:UIControlEventTouchUpInside];
    modifyBut.layer.cornerRadius=8;
    modifyBut.clipsToBounds=YES;
    [self.view addSubview:modifyBut];
    // Do any additional setup after loading the view.
}
-(void)modifyBut:(UIButton *)button
{
    [nameField resignFirstResponder];
    if (nameField.text.length < 2) {
        [[[UIAlertView alloc]initWithTitle:UMComLocalizedString(@"sorry", @"抱歉") message:UMComLocalizedString(@"The user nickname is too short", @"用户昵称太短了") delegate:nil cancelButtonTitle:UMComLocalizedString(@"OK", @"好的") otherButtonTitles:nil, nil] show];
        return;
    }
    if (nameField.text.length > 20) {
        [[[UIAlertView alloc]initWithTitle:UMComLocalizedString(@"sorry", @"抱歉") message:UMComLocalizedString(@"The user nickname is too long", @"用户昵称过长") delegate:nil cancelButtonTitle:UMComLocalizedString(@"OK", @"好的") otherButtonTitles:nil, nil] show];
        return;
    }
    if ([self isIncludeSpecialCharact:nameField.text]) {
        [[[UIAlertView alloc]initWithTitle:UMComLocalizedString(@"sorry", @"抱歉") message:UMComLocalizedString(@"The input character does not conform to the requirements", @"昵称只能包含中文、中英文字母、数字和下划线") delegate:nil cancelButtonTitle:UMComLocalizedString(@"OK", @"好的") otherButtonTitles:nil, nil] show];
        return;
    }
    
    self.userAccount.name = nameField.text;
    self.userAccount.gender = 0;
    NSLog(@"%@",nameField.text);
    __weak typeof(self) weakSelf = self;
    //如果从登录页面因为用户名错误，直接跳转到设置页面，先进行登录注册
    if (self.settingCompletion) {
        self.settingCompletion(self, self.userAccount);
    }else{
        [UMComPushRequest updateWithUser:self.userAccount completion:^(NSError *error) {
            
            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:UpdateUserProfileSuccess object:weakSelf];
                
                if (weakSelf.navigationController.viewControllers.count > 1) {
                    if (self.updateCompletion) {
                        self.updateCompletion(nil, nil);
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } else {
                    [weakSelf dismissViewControllerAnimated:YES completion:^{
                        if (self.updateCompletion) {
                            self.updateCompletion(nil, nil);
                        }
                    }];
                }
            } else {
                [UMComShowToast showFetchResultTipWithError:error];
            }
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
            NSString *urlstr=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"head_img"]];
            weakSelf.userAccount.icon_url = urlstr;
            [weakSelf setUserProfile];
        }];
    }

}

- (void)setUserProfile
{
   // UMComUser *loginUser = [UMComSession sharedInstance].loginUser;
    self.userAccount.name = nameField.text;
    self.userAccount.gender = 0;
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *urlstr=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"head_img"]];
    self.userAccount.icon_url = urlstr;
    
    [nameField setText:self.userAccount.name];
    NSString *imageName = @"female";
    if ([self.userAccount.gender integerValue] == 1) {
        imageName = @"male";
    }
//    [self.userPortrait  setImageURL:self.userAccount.icon_url placeHolderImage:UMComImageWithImageName(imageName)];
//    [self setGender:self.userAccount.gender.integerValue];
}

-(BOOL)isIncludeSpecialCharact:(NSString *)str {
    
    NSString *regex = @"(^[a-zA-Z0-9_\u4e00-\u9fa5]+$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isRight = ![pred evaluateWithObject:str];
    return isRight;
}
-(void)gotoBack
{
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
             }
         } onQueue:nil];
    }];

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
