//
//  Express_RegisterViewController.m
//  yxz
//
//  Created by 白玉林 on 16/3/10.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "Express_RegisterViewController.h"
#import "TeamWorkCityViewController.h"
#import "ConTentViewController.h"
#import "WasteRecoveryListViewController.h"
#import "OrderPayViewController.h"
#import "DCRoundSwitch.h"
@interface Express_RegisterViewController ()
{
    UILabel *remarksLabel;
    UIView *layoutView;
    UIScrollView *myScrollView;
    NSString *remarksString;
    TeamWorkCityViewController *userdressVC;
    ConTentViewController *viewController;
    WasteRecoveryListViewController *waterListVC;
    DCRoundSwitch *switchButton;
    int express_typeID;
    int express_typeIDs;
    int pay_typeID;
    int pay_typeIDs;
    NSString *ex_typeStr;
    NSString *pay_typeStr;
    
    
    NSString *express_noStr;
    NSString *express_idStr;
    NSString *from_addrStr;
    NSString *from_nameStr;
    NSString *from_telStr;
    NSString *to_addrStr;
    NSString *to_nameStr;
    NSString *to_telStr;
}
@end

@implementation Express_RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navlabel.text=@"登记";
    self.backlable.backgroundColor=HEX_TO_UICOLOR(0x00bb9c, 1.0);
    _navlabel.textColor = [UIColor whiteColor];
    self.img.hidden=YES;
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 20, 20)];
    img.image = [UIImage imageNamed:@"iconfont-p-back"];
    [_backBtn addSubview:img];
    express_noStr=@"";
    express_idStr=@"";
    from_addrStr=@"";
    from_nameStr=@"";
    from_telStr=@"";
    to_addrStr=@"";
    to_nameStr=@"";
    to_telStr=@"";
    remarksString=@"";
    ex_typeStr=@"";
    pay_typeStr=@"";
    UIButton *submitBut=[[UIButton alloc]initWithFrame:FRAME(14, HEIGHT-46, WIDTH-28, 41)];
    submitBut.backgroundColor=self.backlable.backgroundColor;
    [submitBut setTitle:@"提交" forState:UIControlStateNormal];
    [submitBut addTarget:self action:@selector(submitBut:) forControlEvents:UIControlEventTouchUpInside];
    submitBut.layer.cornerRadius=5;
    submitBut.clipsToBounds=YES;
    [self.view addSubview:submitBut];
    
    myScrollView=[[UIScrollView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-111)];
    myScrollView.delegate=self;
    [self.view addSubview:myScrollView];
    [self viewLayout];
    // Do any additional setup after loading the view.
}
-(void)submitBut:(UIButton *)button
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSDictionary *_dict=@{@"user_id":_manager.telephone,@"express_no":express_noStr,@"express_id":express_idStr,@"express_type":ex_typeStr,@"pay_type":pay_typeStr,@"from_addr":from_addrStr,@"from_name":from_nameStr,@"from_tel":from_telStr,@"to_addr":to_addrStr,@"to_name":to_nameStr,@"to_tel":to_telStr,@"remarks":remarksString};
    DownloadManager *_download = [[DownloadManager alloc]init];
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",EXPRESS_REGISTER] dict:_dict view:self.view delegate:self finishedSEL:@selector(waterOrderSuccess:) isPost:YES failedSEL:@selector(waterOrderFail:)];
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
    [myScrollView addSubview:layoutView];
    NSArray*array=@[@"快递单号",@"快递公司",@"收发件",@"付费方式",@"寄件人地址",@"寄件人姓名",@"寄件人联系方式",@"收件人地址",@"收件人姓名",@"收件人联系方式",@"备注",@"图片"];
    for (int i=0; i<array.count; i++) {
        UIView *lienView=[[UIView alloc]initWithFrame:FRAME(0, 50+51*i, WIDTH, 1)];
        lienView.backgroundColor=[UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1];
        [layoutView addSubview:lienView];
        UIButton *button=[[UIButton alloc]initWithFrame:FRAME(0, 51*i, WIDTH, 50)];
        button.tag=i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [layoutView addSubview:button];
        UILabel *label=[[UILabel alloc]init];
        label.font=[UIFont fontWithName:@"Arial" size:15];
        label.text=[NSString stringWithFormat:@"%@",array[i]];
        [label setNumberOfLines:1];
        [label sizeToFit];
        label.frame=FRAME(20, 15, label.frame.size.width, 20);
        [button addSubview:label];
        if(i==2){
//            button.enabled=FALSE;
            UILabel *express_typeLabel=[[UILabel alloc]init];
            express_typeLabel.text=@"寄件";
            express_typeLabel.font=[UIFont fontWithName:@"Arila" size:15];
            [express_typeLabel setNumberOfLines:1];
            [express_typeLabel sizeToFit];
            express_typeLabel.frame=FRAME(WIDTH-express_typeLabel.frame.size.width-20, 15, express_typeLabel.frame.size.width, 20);
            [button addSubview:express_typeLabel];
            
            UIButton *express_typeBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH-express_typeLabel.frame.size.width-50, 15, 20, 20)];
            express_typeBut.tag=100;
            [express_typeBut addTarget:self action:@selector(express_typeBut:) forControlEvents:UIControlEventTouchUpInside];
            [express_typeBut setImage:[UIImage imageNamed:@"noselection@2x"] forState:UIControlStateNormal];
            [button addSubview:express_typeBut];
            
            UILabel *express_typeLabel1=[[UILabel alloc]init];
            express_typeLabel1.text=@"收件";
            express_typeLabel1.font=[UIFont fontWithName:@"Arila" size:15];
            [express_typeLabel1 setNumberOfLines:1];
            [express_typeLabel1 sizeToFit];
            express_typeLabel1.frame=FRAME(WIDTH-express_typeLabel1.frame.size.width-express_typeLabel.frame.size.width-90, 15, express_typeLabel1.frame.size.width, 20);
            [button addSubview:express_typeLabel1];
            
            UIButton *express_typeBut1=[[UIButton alloc]initWithFrame:FRAME(express_typeLabel1.frame.origin.x-30, 15, 20, 20)];
            express_typeBut1.tag=101;
            [express_typeBut1 addTarget:self action:@selector(express_typeBut:) forControlEvents:UIControlEventTouchUpInside];
            [express_typeBut1 setImage:[UIImage imageNamed:@"noselection@2x"] forState:UIControlStateNormal];
            [button addSubview:express_typeBut1];
            
        }else if (i==3){
//            button.enabled=FALSE;
            UILabel *pay_typeLabel=[[UILabel alloc]init];
            pay_typeLabel.text=@"寄件";
            pay_typeLabel.font=[UIFont fontWithName:@"Arila" size:15];
            [pay_typeLabel setNumberOfLines:1];
            [pay_typeLabel sizeToFit];
            pay_typeLabel.frame=FRAME(WIDTH-pay_typeLabel.frame.size.width-20, 15, pay_typeLabel.frame.size.width, 20);
            [button addSubview:pay_typeLabel];
            
            UIButton *pay_typeBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH-pay_typeLabel.frame.size.width-50, 15, 20, 20)];
            pay_typeBut.tag=1000;
            [pay_typeBut addTarget:self action:@selector(pay_typeBut:) forControlEvents:UIControlEventTouchUpInside];
            [pay_typeBut setImage:[UIImage imageNamed:@"noselection@2x"] forState:UIControlStateNormal];
            [button addSubview:pay_typeBut];
            
            UILabel *pay_typeLabel1=[[UILabel alloc]init];
            pay_typeLabel1.text=@"收件";
            pay_typeLabel1.font=[UIFont fontWithName:@"Arila" size:15];
            [pay_typeLabel1 setNumberOfLines:1];
            [pay_typeLabel1 sizeToFit];
            pay_typeLabel1.frame=FRAME(WIDTH-pay_typeLabel1.frame.size.width-pay_typeLabel.frame.size.width-90, 15, pay_typeLabel1.frame.size.width, 20);
            [button addSubview:pay_typeLabel1];
            
            UIButton *pay_typeBut1=[[UIButton alloc]initWithFrame:FRAME(pay_typeLabel1.frame.origin.x-30, 15, 20, 20)];
            pay_typeBut1.tag=1001;
            [pay_typeBut1 addTarget:self action:@selector(pay_typeBut:) forControlEvents:UIControlEventTouchUpInside];
            [pay_typeBut1 setImage:[UIImage imageNamed:@"noselection@2x"] forState:UIControlStateNormal];
            [button addSubview:pay_typeBut1];

        }else if (i>9){
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-35, 15, 15, 20)];
            imageView.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
            [button addSubview:imageView];
        }else{
            UITextField *textField=[[UITextField alloc]initWithFrame:FRAME(label.frame.size.width+20, 15, WIDTH-label.frame.size.width-40, 20)];
            textField.delegate=self;
            textField.textAlignment=NSTextAlignmentRight;
            textField.placeholder = @"请输入信息！";
            textField.tag=i;
            textField.font=[UIFont fontWithName:@"Arial" size:13];
            [button addSubview:textField];
        }
    }
    layoutView.frame=FRAME(0, 0, WIDTH, 51*12);
    
    UIView *smartView=[[UIView alloc]initWithFrame:FRAME(0, layoutView.frame.size.height+10, WIDTH, 52)];
    smartView.backgroundColor=[UIColor whiteColor];
    [myScrollView addSubview:smartView];
    
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
    smartLabel.font=[UIFont fontWithName:@"Arial" size:15];
    smartLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [smartView addSubview:smartLabel];
    
    switchButton=[[DCRoundSwitch alloc]initWithFrame:CGRectMake(smartView.frame.size.width-70, 27/2, 50, 25)];
    switchButton.ID=1;
    [switchButton addTarget:self action:@selector(switchButAction:) forControlEvents:UIControlEventValueChanged];
    switchButton.onText = @"YES"; //NSLocalizedString(@"YES", @"");
    switchButton.offText = @"NO";//NSLocalizedString(@"NO", @"");
    [smartView addSubview:switchButton];
    
     myScrollView.contentSize=CGSizeMake(WIDTH, layoutView.frame.size.height+62);
}
-(void)express_typeBut:(UIButton *)button
{
    UIButton *but=(UIButton *)[self.view viewWithTag:100];
    UIButton *buts=(UIButton *)[self.view viewWithTag:101];
    if (button.tag==100) {
        if (express_typeID%2==0) {
            ex_typeStr=@"1";
            if (express_typeIDs!=0) {
                express_typeIDs--;
            }
            express_typeID++;
            [but setImage:[UIImage imageNamed:@"selection-checked"] forState:UIControlStateNormal];
            [buts setImage:[UIImage imageNamed:@"noselection@2x"] forState:UIControlStateNormal];
        }else{
            express_typeID--;
            [but setImage:[UIImage imageNamed:@"noselection@2x"] forState:UIControlStateNormal];
            [buts setImage:[UIImage imageNamed:@"noselection@2x"] forState:UIControlStateNormal];
        }
    }else{
        if (express_typeIDs%2==0) {
            ex_typeStr=@"0";
            if(express_typeID!=0){
                express_typeID--;
            }
            express_typeIDs++;
            [but setImage:[UIImage imageNamed:@"noselection@2x"] forState:UIControlStateNormal];
            [buts setImage:[UIImage imageNamed:@"selection-checked"] forState:UIControlStateNormal];
        }else{
            express_typeIDs--;
            [but setImage:[UIImage imageNamed:@"noselection@2x"] forState:UIControlStateNormal];
            [buts setImage:[UIImage imageNamed:@"noselection@2x"] forState:UIControlStateNormal];
        }
    }
}
-(void)pay_typeBut:(UIButton *)button
{
    UIButton *but=(UIButton *)[self.view viewWithTag:1000];
    UIButton *buts=(UIButton *)[self.view viewWithTag:1001];
    if (button.tag==1000) {
        if (pay_typeID%2==0) {
            pay_typeStr=@"1";
            if (pay_typeIDs!=0) {
                pay_typeIDs--;
            }
            pay_typeID++;
            [but setImage:[UIImage imageNamed:@"selection-checked"] forState:UIControlStateNormal];
            [buts setImage:[UIImage imageNamed:@"noselection@2x"] forState:UIControlStateNormal];
        }else{
            pay_typeID--;
            [but setImage:[UIImage imageNamed:@"noselection@2x"] forState:UIControlStateNormal];
            [buts setImage:[UIImage imageNamed:@"noselection@2x"] forState:UIControlStateNormal];
        }
    }else{
        if (pay_typeIDs%2==0) {
            if (pay_typeID!=0) {
                pay_typeID--;
            }
            pay_typeStr=@"0";
            pay_typeIDs++;
            [but setImage:[UIImage imageNamed:@"noselection@2x"] forState:UIControlStateNormal];
            [buts setImage:[UIImage imageNamed:@"selection-checked"] forState:UIControlStateNormal];
        }else{
            pay_typeIDs--;
            [but setImage:[UIImage imageNamed:@"noselection@2x"] forState:UIControlStateNormal];
            [buts setImage:[UIImage imageNamed:@"noselection@2x"] forState:UIControlStateNormal];
        }
    }
    
    
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
    if (viewController.textString==nil||viewController.textString==NULL) {
        remarksString=@"";
    }else{
        remarksString=viewController.textString;
        [self remarksLayout];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            layoutView.frame=FRAME(0, 0, WIDTH, 51*12);
            [UIView commitAnimations];
            
            break;
        case 1:
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            layoutView.frame=FRAME(0, 0, WIDTH, 51*12);
            [UIView commitAnimations];
            
            break;
        case 4:
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            layoutView.frame=FRAME(0, -51, WIDTH, 51*12);
            [UIView commitAnimations];
            
            break;
        case 5:
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            layoutView.frame=FRAME(0, -51*2, WIDTH, 51*12);
            [UIView commitAnimations];
            
            break;
        case 6:
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView commitAnimations];
            layoutView.frame=FRAME(0, -51*3, WIDTH, 51*12);
            break;
        case 7:
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            layoutView.frame=FRAME(0, -51*4, WIDTH, 51*12);
            [UIView commitAnimations];
            
            break;
        case 8:
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            layoutView.frame=FRAME(0, -51*5, WIDTH, 51*12);
            [UIView commitAnimations];
            
            break;
        case 9:
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            layoutView.frame=FRAME(0, -51*6, WIDTH, 51*12);
            [UIView commitAnimations];
            
            break;
        default:
            break;
    }

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            if (textField.text==nil) {
                express_noStr=@"";
            }else{
                express_noStr=textField.text;
            }
            
            break;
        case 1:
            if (textField.text==nil) {
                express_idStr=@"";
            }else{
                express_idStr=textField.text;
            }
          
            
            break;
        case 4:
            if (textField.text==nil) {
                from_addrStr=@"";
            }else{
                from_addrStr=textField.text;
            }
            
            break;
        case 5:
            if (textField.text==nil) {
                from_nameStr=@"";
            }else{
                from_nameStr=textField.text;
            }
            
            
            break;
        case 6:
            if (textField.text==nil) {
                from_telStr=@"";
            }else{
                from_telStr=textField.text;
            }
            
            break;
        case 7:
            if (textField.text==nil) {
                to_addrStr=@"";
            }else{
                to_addrStr=textField.text;
            }
            break;
        case 8:
            if (textField.text==nil) {
                to_nameStr=@"";
            }else{
                to_nameStr=textField.text;
            }
            
            
            break;
        case 9:
            if (textField.text==nil) {
                to_telStr=@"";
            }else{
                to_telStr=textField.text;
            }
            
            
            break;
        default:
            break;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {  // 这个方法是UITextFieldDelegate协议里面的
    NSLog(@"textFieldShouldReturn the keyboard *** %@ ",theTextField.text);
    [theTextField resignFirstResponder]; //这句代码可以隐藏 键盘
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    layoutView.frame=FRAME(0, 0, WIDTH, 51*12);
    [UIView commitAnimations];
    
    return YES;
}

-(void)buttonAction:(UIButton *)button
{
    switch (button.tag) {
        case 10:
        {
            viewController=[[ConTentViewController alloc]init];
            viewController.textString=remarksString;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 11:
        {
            
        }
            break;
        default:
            break;
    }
}
-(void)remarksLayout
{
    remarksLabel.text=remarksString;
    remarksLabel.textAlignment=NSTextAlignmentRight;
    remarksLabel.font=[UIFont fontWithName:@"Arial" size:15];
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
