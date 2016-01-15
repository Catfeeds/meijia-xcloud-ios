//
//  MineViewController.m
//  simi
//
//  Created by zrj on 14-11-12.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "MineViewController.h"
#import "ChoiceDefine.h"
#import "UserInfoViewController.h"
#import "UsedDressViewController.h"
//#import "MyLogInViewController.h"
#import "ISLoginManager.h"

#import "HuiYuanCenterController.h"
#import "simiViewController.h"
#import "JifenViewController.h"

#import "AliPayManager.h"

#import "MineJifenViewController.h"
#import "DownloadManager.h"
#import "USERINFODataModels.h"
#import "Order_ListViewController.h"
#import "MoreViewController.h"
#import "ChatViewController.h"
#import "LoginViewController.h"
#import "EaseMob.h"
@interface MineViewController ()
{
    UILabel *userlabel;
    USERINFOBaseClass *_base;
    UIScrollView *_myscroll;
    float _height;
    UIImageView *image;
    
}

@end

@implementation MineViewController
- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
     NSLog(@"有没有啊   啊 啊啊 啊 啊%@",[[EaseMob sharedInstance] sdkVersion]);
    ISLoginManager *_manager = [ISLoginManager shareManager];
    if (_manager.isLogin) {
        UIImage *headimg = [GetPhoto getPhotoFromName:@"image.png"];
        UIImageView *image1 = (UIImageView *)[image viewWithTag:66];
        if (headimg) {
            image1.image = headimg;
            image1.frame = FRAME((SELF_VIEW_WIDTH-50)/2, 15, 50, 50);
            image1.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
        }else{
            image1.image = [UIImage imageNamed:@"家-我_默认头像"];
            image1.frame = FRAME((SELF_VIEW_WIDTH-50)/2, 15, 50, 50);;
        }

    }else{
        UIImage *headimg =nil; //[GetPhoto getPhotoFromName:@"image.png"];
        UIImageView *image1 = (UIImageView *)[image viewWithTag:66];
        if (headimg) {
            image1.image = headimg;
            image1.frame = FRAME((SELF_VIEW_WIDTH-50)/2, 15, 50, 50);
        }else{
            image1.image = [UIImage imageNamed:@"家-我_默认头像"];
            image1.frame = FRAME((SELF_VIEW_WIDTH-50)/2, 15, 50, 50);;
        }
    }
    
}

- (void)LoginSuccess1:(NSNotification *)noti
{
    
    userlabel.text = [NSString stringWithFormat:@"%@",noti.object];
    
    NSLog(@"userlabel.text!!!!!!!!%@",userlabel.text);
       [self getjifen:[NSString stringWithFormat:@"%@",noti.object]];
        userlabel.font = [UIFont fontWithName:@"Georgia-Bold" size:20];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"THIRD_LOGIN_SUCCESS" object:nil];

}
-(void)tongzhiNA:(NSNotification *)dic
{
    NSString *st=[NSString stringWithFormat:@"%@",[dic.object objectForKey:@"name"]];
    userlabel.text=st;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"TONG_ZHI" object:nil];
    NSLog(@"获取到的饿数据%@",st);
}
- (void)Logout
{
    UIImage *headimg = nil;//[GetPhoto getPhotoFromName:@"image.png"];
    
    UIImageView *image1 = (UIImageView *)[image viewWithTag:66];
    if (headimg) {
        image1.image = headimg;
        image1.frame = FRAME((SELF_VIEW_WIDTH-50)/2, 15, 50, 50);
    }else{
        image1.image = [UIImage imageNamed:@"家-我_默认头像"];
        image1.frame = FRAME((SELF_VIEW_WIDTH-50)/2, 15, 50, 50);;
    }
    //[image removeFromSuperview];
    userlabel.text = @"立即登录";
    UILabel *_label = (UILabel *)[_myscroll viewWithTag:909];
    _label.text = @"0.0";

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LOGOUT" object:nil];
    
}
- (void)getjifen:(NSString *)cellphone
{
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict = @{@"user_id":cellphone};
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",USERINFO_API] dict:_dict view:_myscroll delegate:self finishedSEL:@selector(DownloadFinish1:) isPost:NO failedSEL:@selector(FailDownload:)];
}

- (void)JifenDuihuanSuccess:(NSNotification *)noti
{
    UILabel *_label = (UILabel *)[_myscroll viewWithTag:909];
    _label.text = [NSString stringWithFormat:@"%.f",_base.data.score-[noti.object integerValue]];
}

#pragma mark 下载成功
- (void)DownloadFinish1:(id)responsobject
{
    _base = [[USERINFOBaseClass alloc]initWithDictionary:responsobject];
    NSDictionary *dict = [responsobject objectForKey:@"data"];

    NSLog(@"下载成功的数据%@",dict);
    if (_base.status == 0) {
        UILabel *_label = (UILabel *)[_myscroll viewWithTag:909];
        _label.text = [NSString stringWithFormat:@"%.f",_base.data.score];
        UILabel *_label1 = (UILabel *)[_myscroll viewWithTag:99];
        NSString *str = [[responsobject objectForKey:@"data"] objectForKey:@"name"];
        _label1.text = str;
        
        UIImageView *im = (UIImageView *)[image viewWithTag:66];
        UIImage *img =[GetPhoto getPhotoFromName:@"image.png"];
        if (img) {
            im.image = img;
        }
        
        self.ID = [dict objectForKey:@"id"];
        self.hxUserName = [dict objectForKey:@"im_username"];
        self.hxPassword = [dict objectForKey:@"im_password"];
        NSLog(@"？？？？？？环信账号：%@环信密码：%@",self.hxUserName,self.hxPassword);
        
        self.imToUserID = [dict objectForKey:@"im_sec_username"];
        self.imToUserName = [dict objectForKey:@"im_sec_nickname"];


    }
}

#pragma mark 下载失败
- (void)FailDownload:(id)error
{
    NSLog(@"error: %@",error);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navlabel.text = @"我的";
    //self.backBtn.hidden = YES;
    self.navigationController.navigationBarHidden = YES;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tongzhiNA:) name:@"TONG_ZHI" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Logout) name:@"LOGOUT" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginSuccess1:) name:@"THIRD_LOGIN_SUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JifenDuihuanSuccess:) name:@"JIFEN_DUIHUAN100" object:nil];
    
    _height = (_HEIGHT == 480) ? 64 : 64;
    _myscroll = [[UIScrollView alloc]initWithFrame:FRAME(0, 64, _WIDTH, _HEIGHT-64)];
    [_myscroll setContentSize:CGSizeMake(_WIDTH, 620)];

    if (_HEIGHT == 480) {
        _myscroll.frame = FRAME(0, 64, _WIDTH, _HEIGHT);
        [_myscroll setContentSize:CGSizeMake(_WIDTH, 568+20)];
    }
    [self.view addSubview:_myscroll];
    
    image = [[UIImageView alloc]initWithFrame:FRAME(0, NAV_HEIGHT-_height, SELF_VIEW_WIDTH, 176/2+20)];
//    image.image = [UIImage imageNamed:@"mine-background"];
    image.backgroundColor = [UIColor whiteColor];
    [_myscroll addSubview:image];
    
    
    
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:FRAME((SELF_VIEW_WIDTH-100/2)/2, 15, 100/2, 100/2)];
    image1.tag = 66;
    [image1.layer setCornerRadius:25];
    image1.layer.masksToBounds = YES;
    UIImage *headimg = [GetPhoto getPhotoFromName:@"image.png"];
    if (headimg) {
        image1.image = headimg;
        image1.frame = FRAME((SELF_VIEW_WIDTH-50)/2, 15, 50, 50);
    }else{
        image1.image = [UIImage imageNamed:@"家-我_默认头像"];
        image1.frame = FRAME((SELF_VIEW_WIDTH-50)/2, 15, 50, 50);
    }
    
    image1.backgroundColor = DEFAULT_COLOR;
//    image1.backgroundColor = [UIColor redColor];

    [image addSubview:image1];
   
    ISLoginManager *_manager = [ISLoginManager shareManager];
//    ISLoginManager *_manager = [ISLoginManager shareManager];
    
    if (_manager.isLogin) {
        NSLog(@"%@",_manager.telephone);
        [self getjifen:_manager.telephone];
    }
    userlabel = [[UILabel alloc]initWithFrame:FRAME(126/2+47/2, image.height-47/2-10, 150, 47/2)];
    userlabel.textAlignment = NSTextAlignmentCenter;
    userlabel.textColor = HEX_TO_UICOLOR(0x666666, 1.0);
    if (_manager.isLogin) {
        userlabel.text =[NSString stringWithFormat:@"%@",_manager.telephone];
        userlabel.font = [UIFont fontWithName:@"Georgia-Bold" size:20];
    }else
    {
        userlabel.text = @"立即登录";
    }
    userlabel.tag = 99;
    [image addSubview:userlabel];
    
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:FRAME(SELF_VIEW_WIDTH-18-15/2, 176/4-8, 15/2, 16)];
    image2.image = [UIImage imageNamed:@"mine-r-arrow"];
    image2.backgroundColor = DEFAULT_COLOR;
    [image addSubview:image2];
    
//    UILabel *lable = [[UILabel alloc]initWithFrame:FRAME(0, 176/2-46/2-15, SELF_VIEW_WIDTH, 25)];
//    lable.text = @"私秘，轻松生活！";
//    lable.textAlignment = NSTextAlignmentCenter;
//    lable.font = [UIFont fontWithName:@"AmericanTypewriter" size:13];
//    lable.textColor = HEX_TO_UICOLOR(0x666666, 1.0);
//    [image addSubview:lable];
    
    UIButton *_headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _headBtn.frame = FRAME(0, 64-_height, _WIDTH, 176/2+20);
    [_headBtn setTag:1];
    //[_headBtn addTarget:self action:@selector(oneAction:) forControlEvents:UIControlEventTouchUpInside];
    [_myscroll addSubview:_headBtn];
    
    
    UIView *view = [[UIView alloc]initWithFrame:FRAME(0, NAV_HEIGHT+176/2+9-_height+20, SELF_VIEW_WIDTH, 54+1)];
    view.backgroundColor = HEX_TO_UICOLOR(CHOICE_BACK_VIEW_COLOR, 1.0);
    [_myscroll addSubview:view];
    NSArray *titlearr = @[@"常用地址"];
    for (int i = 0; i < 1; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:FRAME(0, 0.5+(108.5/2*i), SELF_VIEW_WIDTH, 108/2)];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setImage:[UIImage imageNamed:@"家-我_常用地址"] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(12, 10, 12, SELF_VIEW_WIDTH-10-25)];
        btn.tag = i+2;
        [btn addTarget:self action:@selector(oneAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UILabel *lab = [[UILabel alloc]init];
        lab.frame = FRAME(40, 0.5+(108.5/2*i), 100, 108/2);
        lab.font = [UIFont systemFontOfSize:13];
        lab.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
        lab.text = titlearr[i];
        [view addSubview:lab];
        
        UIButton *butn = [UIButton buttonWithType:UIButtonTypeCustom];
        butn.frame = FRAME(SELF_VIEW_WIDTH-18-15/2-10, (108-8)/4-5+(i*108/2)-3, 20, 20);
        [butn setBackgroundImage:[UIImage imageNamed:@"s-right-arrow"] forState:UIControlStateNormal];
        [view addSubview:butn];
    }
    
    UIView *viewTwo = [[UIView alloc]initWithFrame:FRAME(0, NAV_HEIGHT+176/2+9+54+2+9-_height+20, SELF_VIEW_WIDTH, 2.5+108/2*4+108/2+0.5+108/2+0.5)];
    viewTwo.backgroundColor = HEX_TO_UICOLOR(CHOICE_BACK_VIEW_COLOR, 1.0);
    [_myscroll addSubview:viewTwo];
    
//    NSArray *titleArr = @[@"订单",@"充值",@"积分",@"优惠券",@"私秘卡",@"更多"];
    NSArray *titleArr = @[@"订单",@"充值",@"积分",@"优惠券",@"更多"];
    //NSArray *imgArr = @[@"家-我_订单",@"家-我_充值（会员卡）",@"家-我_积分",@"家-我_优惠券",@"家-我_私密卡",@"家-我_更多"];
    NSArray *imgArr = @[@"家-我_订单",@"家-我_充值（会员卡）",@"家-我_积分",@"家-我_优惠券",@"家-我_更多"];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:FRAME(0, 0.5+((108/2+0.5)*i), SELF_VIEW_WIDTH, 108/2)];
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(oneAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(15, 10, 15, SELF_VIEW_WIDTH-10-24)];
        [btn setTag:3+i];
        [viewTwo addSubview:btn];
        
        UILabel *lab = [[UILabel alloc]init];
        lab.frame = FRAME(40, 0.5+(108.5/2*i), 100, 108/2);
        lab.font = [UIFont systemFontOfSize:13];
        lab.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
        lab.text = titleArr[i];
        [viewTwo addSubview:lab];
        
        UIButton *butn = [UIButton buttonWithType:UIButtonTypeCustom];
        butn.frame = FRAME(SELF_VIEW_WIDTH-18-15/2-10, (108-8)/4-5+(i*108/2)-3, 20, 20);
        [butn setBackgroundImage:[UIImage imageNamed:@"s-right-arrow"] forState:UIControlStateNormal];
        [viewTwo addSubview:butn];
    }
    
    UILabel *simika = [[UILabel alloc]init];
    simika.frame = FRAME(80, 108/4-25/2, 200, 25);
//    simika.text = @"真人私秘,一对一服务";
    simika.textAlignment = NSTextAlignmentRight;
    simika.textColor = HEX_TO_UICOLOR(TEXT_COLOR, 1.0);
    simika.backgroundColor = DEFAULT_COLOR;
    simika.font = [UIFont systemFontOfSize:13];
    [viewTwo addSubview:simika];
    
    UILabel *huiyuanka = [[UILabel alloc]init];
    huiyuanka.frame = FRAME(80, 108/4-25/2+109/2, 200, 25);
    huiyuanka.text = @"充值最高返现2000元";
    huiyuanka.textAlignment = NSTextAlignmentRight;
    huiyuanka.textColor = HEX_TO_UICOLOR(TEXT_COLOR, 1.0);
    huiyuanka.backgroundColor = DEFAULT_COLOR;
    huiyuanka.font = [UIFont systemFontOfSize:13];
    [viewTwo addSubview:huiyuanka];
    
    UILabel *jifen = [[UILabel alloc]init];
    jifen.frame = FRAME(80, 108/4-25/2+109/2+108/2, 200, 25);
    [jifen setTag:909];
    jifen.textAlignment = NSTextAlignmentRight;
    jifen.textColor = HEX_TO_UICOLOR(TEXT_COLOR, 1.0);
    jifen.backgroundColor = DEFAULT_COLOR;
    jifen.font = [UIFont systemFontOfSize:13];
    [viewTwo addSubview:jifen];
    

}

- (void)oneAction:(UIButton *)sennder
{
    ISLoginManager *_logmanager = [ISLoginManager shareManager];
    
    if (sennder.tag == 1) {
        
        if (_logmanager.isLogin) {
            UserInfoViewController *userinfo = [[UserInfoViewController alloc]init];
            [self presentViewController:userinfo animated:YES completion:nil];
//            [self.navigationController pushViewController:userinfo animated:YES];
        }else{
//            MyLogInViewController *userinfo = [[MyLogInViewController alloc]init];
//            userinfo.vCLID=0;
////            [self presentViewController:userinfo animated:YES completion:nil];
//            [self.navigationController pushViewController:userinfo animated:YES];
        }
    }else if (sennder.tag == 2) {
        
        if (_logmanager.isLogin) {
            UsedDressViewController *dress = [[UsedDressViewController alloc]init];
            [self.navigationController pushViewController:dress animated:YES];
            
        }else{
//            MyLogInViewController *userinfo = [[MyLogInViewController alloc]init];
//            userinfo.vCLID=0;
////            [self presentViewController:userinfo animated:YES completion:nil];
//            [self.navigationController pushViewController:userinfo animated:YES];

        }
        
    }else if (sennder.tag == 3){
        if (_logmanager.isLogin) {
//            simiViewController *_controller = [[simiViewController alloc]init];
//            [self.navigationController pushViewController:_controller animated:YES];
            Order_ListViewController *order =[[Order_ListViewController alloc]init];
            //order.leixing = @"我的";
            [self.navigationController pushViewController:order animated:YES];
            
            
        }else{
//            MyLogInViewController *userinfo = [[MyLogInViewController alloc]init];
//            userinfo.vCLID=0;
////            [self presentViewController:userinfo animated:YES completion:nil];
//            [self.navigationController pushViewController:userinfo animated:YES];


        }
        
    }else if (sennder.tag == 4){

        if (_logmanager.isLogin) {
            HuiYuanCenterController *_controller = [[HuiYuanCenterController alloc]init];
            [self.navigationController pushViewController:_controller animated:YES];
            
        }else{
//            MyLogInViewController *userinfo = [[MyLogInViewController alloc]init];
//            userinfo.vCLID=0;
////            [self presentViewController:userinfo animated:YES completion:nil];
//            [self.navigationController pushViewController:userinfo animated:YES];

        }
        
    }else if (sennder.tag == 5){
        
        if (_logmanager.isLogin) {
            UILabel *_label = (UILabel *)[_myscroll viewWithTag:909];
            JifenViewController *dress = [[JifenViewController alloc]init];
            dress.jifenstring = [NSString stringWithFormat:@"%@",_label.text];
            [self.navigationController pushViewController:dress animated:YES];
            
        }else{
//            MyLogInViewController *userinfo = [[MyLogInViewController alloc]init];
//            userinfo.vCLID=0;
////            [self presentViewController:userinfo animated:YES completion:nil];
//            [self.navigationController pushViewController:userinfo animated:YES];

        }
        
    }else if (sennder.tag == 6){
        
        if (_logmanager.isLogin) {
            MineJifenViewController *dress = [[MineJifenViewController alloc]init];
            [self.navigationController pushViewController:dress animated:YES];
            
        }else{
//            MyLogInViewController *userinfo = [[MyLogInViewController alloc]init];
//            userinfo.vCLID=0;
////            [self presentViewController:userinfo animated:YES completion:nil];
//            [self.navigationController pushViewController:userinfo animated:YES];

        }
        
    }else if (sennder.tag == 7)
    {
//        if (_logmanager.isLogin) {
//            simiViewController *_controller = [[simiViewController alloc]init];
//            [self.navigationController pushViewController:_controller animated:YES];
//            
//        }else{
//            MyLogInViewController *userinfo = [[MyLogInViewController alloc]init];
////            [self presentViewController:userinfo animated:YES completion:nil];
//            [self.navigationController pushViewController:userinfo animated:YES];

        if (_logmanager.isLogin) {
            MoreViewController *more = [[MoreViewController alloc]init];
            [self.navigationController pushViewController:more animated:YES];
            
        }else{
//            MyLogInViewController *userinfo = [[MyLogInViewController alloc]init];
//            userinfo.vCLID=0;
//            //            [self presentViewController:userinfo animated:YES completion:nil];
//            [self.navigationController pushViewController:userinfo animated:YES];
        }
    }
//    else if (sennder.tag == 8)
//    {
//        if (_logmanager.isLogin) {
//            MoreViewController *more = [[MoreViewController alloc]init];
//            [self.navigationController pushViewController:more animated:YES];
//            
//        }else{
//            MyLogInViewController *userinfo = [[MyLogInViewController alloc]init];
////            [self presentViewController:userinfo animated:YES completion:nil];
//            [self.navigationController pushViewController:userinfo animated:YES];
//
//        }
//    }
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
