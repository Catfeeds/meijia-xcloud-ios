//
//  Order_CleanViewController.m
//  yxz
//
//  Created by 白玉林 on 16/3/7.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "Order_CleanViewController.h"
#import "UsedDressViewController.h"
#import "ConTentViewController.h"
#import "WasteRecoveryListViewController.h"
#import "OrderPayViewController.h"
#import "DCRoundSwitch.h"
@interface Order_CleanViewController ()
{
    UILabel *waterName;
    UILabel *moneyLabel;
    UILabel *addressLabel;
    UITextField *nameField;
    UITextField *mobileField;
    UILabel *remarksLabel;
    UIView *layoutView;
    
    NSString *waterString;
    NSString *moneyString;
    NSString *addressString;
    NSString *nameString;
    NSString *mobileString;
    NSString *remarksString;
    NSString *service_price_id;
    NSString *addressID;
    UsedDressViewController *userdressVC;
    ConTentViewController *viewController;
    WasteRecoveryListViewController *waterListVC;
    DCRoundSwitch *switchButton;
}
@end

@implementation Order_CleanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navlabel.text=@"下单";
    self.backlable.backgroundColor=HEX_TO_UICOLOR(0x56abe4, 1.0);
    _navlabel.textColor = [UIColor whiteColor];
    self.img.hidden=YES;
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 20, 20)];
    img.image = [UIImage imageNamed:@"iconfont-p-back"];
    [_backBtn addSubview:img];
    [self viewLayout];
    UIButton *submitBut=[[UIButton alloc]initWithFrame:FRAME(14, HEIGHT-46, WIDTH-28, 41)];
    submitBut.backgroundColor=self.backlable.backgroundColor;
    [submitBut setTitle:@"提交" forState:UIControlStateNormal];
    [submitBut addTarget:self action:@selector(submitBut:) forControlEvents:UIControlEventTouchUpInside];
    submitBut.layer.cornerRadius=5;
    submitBut.clipsToBounds=YES;
    [self.view addSubview:submitBut];
    // Do any additional setup after loading the view.
}
#pragma mark 联系方式判断
- (BOOL)validateMobile:(NSString *)mobileNum

{
    
    NSString * MOBILE = @"1[0-9]{10}";
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    NSString * PHS = @"^\\d{3}-\\d{8}|\\d{4}-\\d{7,8}";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    BOOL regextestmobileBool=[regextestmobile evaluateWithObject:mobileNum];
    BOOL regextestcmBool=[regextestcm evaluateWithObject:mobileNum];
    BOOL regextestcuBool=[regextestct evaluateWithObject:mobileNum];
    BOOL regextestctBool=[regextestcu evaluateWithObject:mobileNum];
    BOOL regextestphsBool=[regextestphs evaluateWithObject:mobileNum];
    if(regextestmobileBool==YES||regextestcmBool==YES||regextestcuBool==YES||regextestctBool==YES||regextestphsBool==YES){
        return YES;
    }else{
        
        return NO;
        
    }
    
}
-(void)submitBut:(UIButton *)button
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *company_name=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"company_name"]];
    if (waterString==nil||waterString==NULL||[waterString isEqualToString:@""]) {
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"服务类型不能为空，请选择！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [tsView show];
    }else if (addressString==nil||addressString==NULL||[addressString isEqualToString:@""]){
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"服务地址不能为空，请选择！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [tsView show];
    }else{
        ISLoginManager *_manager = [ISLoginManager shareManager];
        NSDictionary *_dict;
        if (nameString==nil&&mobileString!=nil&&remarksString!=nil)
        {
            if (company_name==nil||company_name==NULL||[company_name isEqualToString:@""]) {
                _dict = @{@"user_id":_manager.telephone,@"addr_id":addressID,@"clean_type":service_price_id,@"link_tel":mobileString,@"remarks":remarksString};
            }else{
                _dict = @{@"user_id":_manager.telephone,@"addr_id":addressID,@"clean_type":service_price_id,@"link_tel":mobileString,@"remarks":remarksString,@"company_name":company_name};
            }
            
        }else if (mobileString==nil&&nameString!=nil&&remarksString!=nil)
        {
            if (company_name==nil||company_name==NULL||[company_name isEqualToString:@""]) {
                _dict = @{@"user_id":_manager.telephone,@"addr_id":addressID,@"clean_type":service_price_id,@"link_man":nameString,@"remarks":remarksString};
            }else{
                _dict = @{@"user_id":_manager.telephone,@"addr_id":addressID,@"clean_type":service_price_id,@"link_man":nameString,@"remarks":remarksString,@"company_name":company_name};
            }
            
        }else if (remarksString==nil&&mobileString!=nil&&nameString!=nil)
        {
            if (company_name==nil||company_name==NULL||[company_name isEqualToString:@""]) {
                _dict = @{@"user_id":_manager.telephone,@"addr_id":addressID,@"clean_type":service_price_id,@"link_man":nameString,@"link_tel":mobileString};
            }else{
                _dict = @{@"user_id":_manager.telephone,@"addr_id":addressID,@"clean_type":service_price_id,@"link_man":nameString,@"link_tel":mobileString,@"company_name":company_name};
            }
            
        }else if (nameString==nil&&mobileString==nil&&remarksString!=nil)
        {
            if (company_name==nil||company_name==NULL||[company_name isEqualToString:@""]) {
                _dict = @{@"user_id":_manager.telephone,@"addr_id":addressID,@"clean_type":service_price_id,@"remarks":remarksString};
            }else{
                _dict = @{@"user_id":_manager.telephone,@"addr_id":addressID,@"clean_type":service_price_id,@"remarks":remarksString,@"company_name":company_name};
            }
            
        }else if (nameString==nil&&remarksString==nil&&mobileString!=nil)
        {
            if (company_name==nil||company_name==NULL||[company_name isEqualToString:@""]) {
                _dict = @{@"user_id":_manager.telephone,@"addr_id":addressID,@"clean_type":service_price_id,@"link_tel":mobileString};
            }else{
                _dict = @{@"user_id":_manager.telephone,@"addr_id":addressID,@"clean_type":service_price_id,@"link_tel":mobileString,@"company_name":company_name};
            }
            
        }else if (remarksString==nil&&mobileString==nil&&nameString!=nil)
        {
            if (company_name==nil||company_name==NULL||[company_name isEqualToString:@""]) {
                _dict = @{@"user_id":_manager.telephone,@"addr_id":addressID,@"clean_type":service_price_id,@"link_man":nameString};
            }else{
                _dict = @{@"user_id":_manager.telephone,@"addr_id":addressID,@"clean_type":service_price_id,@"link_man":nameString,@"company_name":company_name};
            }
            
        }else if (nameString==nil&&mobileString==nil&&remarksString==nil)
        {
            if (company_name==nil||company_name==NULL||[company_name isEqualToString:@""]) {
                _dict = @{@"user_id":_manager.telephone,@"addr_id":addressID,@"clean_type":service_price_id};
            }else{
                _dict = @{@"user_id":_manager.telephone,@"addr_id":addressID,@"clean_type":service_price_id,@"company_name":company_name};
            }
            
        }else
        {
            if (company_name==nil||company_name==NULL||[company_name isEqualToString:@""]) {
                _dict = @{@"user_id":_manager.telephone,@"addr_id":addressID,@"clean_type":service_price_id,@"link_man":nameString,@"link_tel":mobileString,@"remarks":remarksString};
            }else{
                _dict = @{@"user_id":_manager.telephone,@"addr_id":addressID,@"clean_type":service_price_id,@"link_man":nameString,@"link_tel":mobileString,@"remarks":remarksString,@"company_name":company_name};
            }
            
        }
        if(mobileString!=nil){
            BOOL mobelBool=[self validateMobile:mobileString];
            if (mobelBool) {
                DownloadManager *_download = [[DownloadManager alloc]init];
                [_download requestWithUrl:[NSString stringWithFormat:@"%@",CLEAN_ORDER_PLACE] dict:_dict view:self.view delegate:self finishedSEL:@selector(waterOrderSuccess:) isPost:YES failedSEL:@selector(waterOrderFail:)];
            }else{
                UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请输入正确的联系方式！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [tsView show];
            }
        }else{
            DownloadManager *_download = [[DownloadManager alloc]init];
            [_download requestWithUrl:[NSString stringWithFormat:@"%@",CLEAN_ORDER_PLACE] dict:_dict view:self.view delegate:self finishedSEL:@selector(waterOrderSuccess:) isPost:YES failedSEL:@selector(waterOrderFail:)];
        }
        //
        //
       

    }
}
#pragma mark送水订单提交成功返回接口
-(void)waterOrderSuccess:(id)sourceData
{
    NSLog(@"送水订单提交返回数据:%@",sourceData);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark送水订单提交失败返回接口
-(void)waterOrderFail:(id)sourceData
{
    NSLog(@"送水订单提交返回数据:%@",sourceData);
}
-(void)viewLayout
{
    layoutView=[[UIView alloc]init];
    layoutView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:layoutView];
    NSArray*array=@[@"服务类型",@"服务地址",@"联系人",@"联系电话",@"备注"];
    for (int i=0; i<array.count; i++) {
        
        UIView *lineView=[[UIView alloc]init];
        lineView.backgroundColor=[UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1];
        [layoutView addSubview:lineView];
        if (i==0) {
            UIButton *button=[[UIButton alloc]init];
            button.tag=i;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [layoutView addSubview:button];
            button.frame=FRAME(0, 0, WIDTH, 80);
            lineView.frame=FRAME(10, 80, WIDTH-20, 1);
            UILabel *label=[[UILabel alloc]init];
            label.text=[NSString stringWithFormat:@"%@",array[i]];
            label.font=[UIFont fontWithName:@"Heiti SC" size:15];
            [label setNumberOfLines:1];
            [label sizeToFit];
            label.frame=FRAME(20, 20, label.frame.size.width, 20);
            [button addSubview:label];
            waterName=[[UILabel alloc]init];
            [button addSubview:waterName];
            moneyLabel=[[UILabel alloc]init];
            [button addSubview:moneyLabel];
            [self waterLayout];
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-35, 20, 15, 20)];
            imageView.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
            [button addSubview:imageView];
        }else{
            lineView.frame=FRAME(10, 80+50*(i)+1*i, WIDTH-20, 1);
            
            switch (i) {
                case 1:
                {
                    UIButton *button=[[UIButton alloc]init];
                    button.frame=FRAME(0, 80+50*(i-1)+1*i, WIDTH, 50);
                    button.tag=i;
                    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [layoutView addSubview:button];
                    UILabel *label=[[UILabel alloc]init];
                    label.text=[NSString stringWithFormat:@"%@",array[i]];
                    label.font=[UIFont fontWithName:@"Heiti SC" size:15];
                    [label setNumberOfLines:1];
                    [label sizeToFit];
                    label.frame=FRAME(20, 15, label.frame.size.width, 20);
                    [button addSubview:label];
                    addressLabel=[[UILabel alloc]init];
                    [button addSubview:addressLabel];
                    [self addressLayout];
                    UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-35, 15, 15, 20)];
                    imageView.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
                    [button addSubview:imageView];
                }
                    break;
                case 2:
                {
                    UIView *button=[[UIView alloc]init];
                    button.frame=FRAME(0, 80+50*(i-1)+1*i, WIDTH, 50);
                    [layoutView addSubview:button];
                    UILabel *label=[[UILabel alloc]init];
                    label.text=[NSString stringWithFormat:@"%@",array[i]];
                    label.font=[UIFont fontWithName:@"Heiti SC" size:15];
                    [label setNumberOfLines:1];
                    [label sizeToFit];
                    label.frame=FRAME(20, 15, label.frame.size.width, 20);
                    [button addSubview:label];
                    nameField=[[UITextField alloc]initWithFrame:FRAME(label.frame.size.width+30, 15, WIDTH-label.frame.size.width-50, 20)];
                    nameField.delegate=self;
                    nameField.tag=100;
                    nameField.textAlignment=NSTextAlignmentRight;
                    nameField.placeholder = @"请输入姓名！";
                    nameField.text=nameString;
                    nameField.font=[UIFont fontWithName:@"Heiti SC" size:13];
                    [button addSubview:nameField];
                    
                }
                    break;
                case 3:
                {
                    UIView *button=[[UIView alloc]init];
                    button.frame=FRAME(0, 80+50*(i-1)+1*i, WIDTH, 50);
                    [layoutView addSubview:button];
                    UILabel *label=[[UILabel alloc]init];
                    label.text=[NSString stringWithFormat:@"%@",array[i]];
                    label.font=[UIFont fontWithName:@"Heiti SC" size:15];
                    [label setNumberOfLines:1];
                    [label sizeToFit];
                    label.frame=FRAME(20, 15, label.frame.size.width, 20);
                    [button addSubview:label];
                    mobileField=[[UITextField alloc]initWithFrame:FRAME(label.frame.size.width+30, 15, WIDTH-label.frame.size.width-50, 20)];
                    mobileField.delegate=self;
                    mobileField.textAlignment=NSTextAlignmentRight;
                    mobileField.placeholder = @"请输入联系方式！";
                    mobileField.tag=101;
                    mobileField.text=mobileString;
                    mobileField.font=[UIFont fontWithName:@"Heiti SC" size:13];
                    [button addSubview:mobileField];
                    
                }
                    break;
                case 4:
                {
                    UIButton *button=[[UIButton alloc]init];
                    button.frame=FRAME(0, 80+50*(i-1)+1*i, WIDTH, 50);
                    button.tag=i;
                    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [layoutView addSubview:button];
                    UILabel *label=[[UILabel alloc]init];
                    label.text=[NSString stringWithFormat:@"%@",array[i]];
                    label.font=[UIFont fontWithName:@"Heiti SC" size:15];
                    [label setNumberOfLines:1];
                    [label sizeToFit];
                    label.frame=FRAME(20, 15, label.frame.size.width, 20);
                    [button addSubview:label];
                    UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-35, 15, 15, 20)];
                    imageView.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
                    [button addSubview:imageView];
                    remarksLabel=[[UILabel alloc]init];
                    [button addSubview:remarksLabel];
                }
                    break;
                    
                default:
                    break;
            }
        }
        
    }
    layoutView.frame=FRAME(0, 64, WIDTH, 80+50*4+1*5);
    
    UIView *smartView=[[UIView alloc]initWithFrame:FRAME(0, layoutView.frame.size.height+74, WIDTH, 52)];
    smartView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:smartView];
    
    UIView *lineView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 1)];
    lineView.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [smartView addSubview:lineView];
    UIView *lineViews=[[UIView alloc]initWithFrame:FRAME(0, 51, WIDTH, 1)];
    lineViews.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [smartView addSubview:lineViews];
    
    UIImageView *smartImage=[[UIImageView alloc]initWithFrame:FRAME(20, 37/2, 15, 15)];
    smartImage.image=[UIImage imageNamed:@"chuli"];
    [smartView addSubview:smartImage];
    
    UILabel *smartLabel=[[UILabel alloc]initWithFrame:FRAME(45, 32/2, WIDTH-125, 20)];
    smartLabel.text=@"智能贴心服务";
    smartLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    smartLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [smartView addSubview:smartLabel];
    
    switchButton=[[DCRoundSwitch alloc]initWithFrame:CGRectMake(smartView.frame.size.width-70, 27/2, 50, 25)];
    switchButton.ID=1;
    [switchButton addTarget:self action:@selector(switchButAction:) forControlEvents:UIControlEventValueChanged];
    switchButton.onText = @"YES"; //NSLocalizedString(@"YES", @"");
    switchButton.offText = @"NO";//NSLocalizedString(@"NO", @"");
    [smartView addSubview:switchButton];
}
#pragma mark 开关按钮switchButton的相应事件方法
-(void)switchButAction:(id)sender
{
    
    //UISwitch *switchBuT=(UISwitch *)sender;
    if (switchButton.isOn) {
        
        
    }else
    {
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    if (userdressVC.ctiyString==nil||userdressVC.ctiyString==NULL) {
        
    }else{
        addressString=userdressVC.ctiyString;
        addressID=userdressVC.addCityID;
        [self addressLayout];
    }
    if (viewController.textString==nil||viewController.textString==NULL) {
        
    }else{
        remarksString=viewController.textString;
        [self remarksLayout];
    }
    if (waterListVC.waterString==nil||waterListVC.waterString==NULL) {
        
    }else{
        waterString=waterListVC.waterString;
        service_price_id=waterListVC.waterID;
        [self waterLayout];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==100) {
        nameString=nameField.text;
    }else if(textField.tag==101){
        mobileString=mobileField.text;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {  // 这个方法是UITextFieldDelegate协议里面的
    NSLog(@"textFieldShouldReturn the keyboard *** %@ ",theTextField.text);
    if (theTextField == nameField) {
        [nameField resignFirstResponder]; //这句代码可以隐藏 键盘
    }else if (theTextField == mobileField){
        [mobileField resignFirstResponder];
    }
    return YES;
}

-(void)buttonAction:(UIButton *)button
{
    switch (button.tag) {
        case 0:
        {
            waterListVC=[[WasteRecoveryListViewController alloc]init];
            waterListVC.listID=101;
            [self.navigationController pushViewController:waterListVC animated:YES];
        }
            break;
        case 1:
        {
            userdressVC=[[UsedDressViewController alloc]init];
            [self.navigationController pushViewController:userdressVC animated:YES];
        }
            break;
        case 4:
        {
            viewController=[[ConTentViewController alloc]init];
            viewController.textString=remarksString;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
            
        default:
            break;
    }
}
-(void)waterLayout
{
    waterName.text=waterString;
    waterName.font=[UIFont fontWithName:@"Heiti SC" size:15];
    waterName.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [waterName setNumberOfLines:1];
    [waterName sizeToFit];
    waterName.frame=FRAME(WIDTH-waterName.frame.size.width-35, 20, waterName.frame.size.width, 20);
    
    moneyLabel.text=moneyString;
    moneyLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    moneyLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [moneyLabel setNumberOfLines:1];
    [moneyLabel sizeToFit];
    moneyLabel.frame=FRAME(WIDTH-moneyLabel.frame.size.width-35, 50, moneyLabel.frame.size.width, 20);
    
}
-(void)addressLayout
{
    addressLabel.text=addressString;
    addressLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    addressLabel.textColor=[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1];
    [addressLabel setNumberOfLines:1];
    [addressLabel sizeToFit];
    addressLabel.frame=FRAME(WIDTH-addressLabel.frame.size.width-35, 15, addressLabel.frame.size.width, 20);
}
-(void)remarksLayout
{
    remarksLabel.text=remarksString;
    remarksLabel.textAlignment=NSTextAlignmentRight;
    remarksLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    remarksLabel.textColor=[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1];
    remarksLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [remarksLabel setNumberOfLines:1];
    [remarksLabel sizeToFit];
    remarksLabel.frame=FRAME(80, 15, WIDTH-115, 20);
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
