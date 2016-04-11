//
//  HuiYuanCenterController.m
//  simi
//
//  Created by 赵中杰 on 14/12/6.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "HuiYuanCenterController.h"
#import "HuiYuanCenterView.h"
#import "BuyViewController.h"
#import "DownloadManager.h"
#import "VIPLISTBaseClass.h"
#import "BaiduMobStat.h"
#import "ISLoginManager.h"
@interface HuiYuanCenterController ()
<
    BUYDELEGATE
>
{
    VIPLISTBaseClass *_base;
    NSDictionary *balanceDic;
    UIView *balanceView;
    UITextField *rechargeField;
    UIScrollView *_myscroll;
}

@end
@implementation HuiYuanCenterController
-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"充值", nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *dic=@{@"user_id":_manager.telephone,@"view_user_id":_manager.telephone};
    [_download requestWithUrl:USER_GRZY dict:dic view:self.view delegate:self finishedSEL:@selector(DetailsSuccessDown:) isPost:NO failedSEL:@selector(DetailsFailureDown:)];
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"充值", nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navlabel.text = @"充值";
    UITapGestureRecognizer *tapSelf=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tapSelf];
}

#pragma mark点击空白隐藏键盘方法
-(void)tapAction:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    [rechargeField resignFirstResponder];
    [UIView commitAnimations];
}


#pragma mark 获取用户详情接口成功返回数据
-(void)DetailsSuccessDown:(id)sender
{
    NSLog(@"%@",sender);
    balanceDic=[sender objectForKey:@"data"];
    DownloadManager *_download = [[DownloadManager alloc]init];
    [_download requestWithUrl:VIP_LIST dict:nil view:self.view delegate:self finishedSEL:@selector(FinishDown:) isPost:NO failedSEL:@selector(FailDown:)];
}
#pragma mark 获取用户详情接口失败返回数据
-(void)DetailsFailureDown:(id)sender
{
    
}
#pragma mark 获取成功
- (void)FinishDown:(id)responsobject
{
    NSLog(@"123321%@",responsobject);
    [_myscroll removeFromSuperview];
    [balanceView removeFromSuperview];
    [rechargeField removeFromSuperview];
    
    balanceView=[[UIView alloc]initWithFrame:FRAME(0, 10, WIDTH, 60)];
    balanceView.backgroundColor=[UIColor whiteColor];
    UILabel *balanceLabel=[[UILabel alloc]init];
    balanceLabel.text=@"余额(元):";
    [balanceLabel setNumberOfLines:1];
    [balanceLabel sizeToFit];
    balanceLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    balanceLabel.frame=FRAME(WIDTH/2-balanceLabel.frame.size.width, 22, balanceLabel.frame.size.width, 16);
    [balanceView addSubview:balanceLabel];
    
    UILabel *moneyLabel=[[UILabel alloc]init];
    moneyLabel.text=[NSString stringWithFormat:@"%@",[balanceDic objectForKey:@"rest_money"]];
    [moneyLabel setNumberOfLines:1];
    [moneyLabel sizeToFit];
    moneyLabel.font=[UIFont fontWithName:@"Heiti SC" size:18];
    moneyLabel.textAlignment=NSTextAlignmentLeft;
    moneyLabel.frame=FRAME(WIDTH/2, 20, WIDTH/2-10, 20);
    [balanceView addSubview:moneyLabel];
    
    rechargeField=[[UITextField alloc]initWithFrame:FRAME(0, 80, WIDTH-75, 40)];
    rechargeField.delegate=self;
    rechargeField.placeholder=@"请输入充值金额";
    rechargeField.font=[UIFont fontWithName:@"Heiti SC" size:15];
    rechargeField.backgroundColor=[UIColor whiteColor];
    rechargeField.keyboardType=UIKeyboardTypeNumberPad;
    
    UIButton *balanceButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-70, 80, 70, 40)];
    [balanceButton setTitle:@"充值" forState:UIControlStateNormal];
    [balanceButton addTarget:self action:@selector(balanceButAction) forControlEvents:UIControlEventTouchUpInside];
    balanceButton.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    
    _base = [[VIPLISTBaseClass alloc]initWithDictionary:responsobject];
    if (_base.status == 0) {
        
        float _height = (_HEIGHT == 480) ? 568 : _HEIGHT;
        
        HuiYuanCenterView *_myview= [[HuiYuanCenterView alloc]initWithFrame:FRAME(0, 120, _WIDTH, _height-64) listArray:_base.data];
        _myview.backgroundColor = COLOR_VAULE(242.0);
        _myview.delegate = self;
        
        _myscroll = [[UIScrollView alloc]initWithFrame:FRAME(0, 64, _WIDTH, _HEIGHT-64)];
        if (_HEIGHT == 480) {
            [_myscroll setContentSize:CGSizeMake(_WIDTH, 568-64)];
        }
        [self.view addSubview:_myscroll];
        
        [_myscroll addSubview:balanceView];
        [_myscroll addSubview:rechargeField];
        [_myscroll addSubview:balanceButton];
        [_myscroll addSubview:_myview];

        
    }else{
        
    }
}

- (void)FailDown:(id)responsobject
{
    
}

#pragma mark 充值按钮点击方法
-(void)balanceButAction
{
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    [rechargeField resignFirstResponder];
    [UIView commitAnimations];
    BuyViewController *_controller = [[BuyViewController alloc]init];
    _controller.moneystring = @"0";
    _controller.card_type=100;
    _controller.card_money=rechargeField.text;
    [self.navigationController pushViewController:_controller animated:YES];
}
- (void)buyHuiyuanWithMoney:(NSString *)money
{
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    [rechargeField resignFirstResponder];
    [UIView commitAnimations];
    BuyViewController *_controller = [[BuyViewController alloc]init];
    _controller.moneystring = @"0";
    _controller.vipdata = [_base.data objectAtIndex:[money integerValue]-1];
    [self.navigationController pushViewController:_controller animated:YES];
}

@end
