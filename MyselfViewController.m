//
//  MyselfViewController.m
//  simi
//
//  Created by 白玉林 on 15/8/17.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "MyselfViewController.h"
#import "MineViewController.h"
#import "ISLoginManager.h"
#import "ImgWebViewController.h"
#import "FXBlurView.h"

#import "ISLoginManager.h"
#import "DownloadManager.h"

#import "PageTableViewCell.h"
#import "DetailsViewController.h"
#import "UserInfoViewController.h"
#import "ChatViewController.h"

#import "WXApi.h"
#import "MineJifenViewController.h"
#import "Order_ListViewController.h"
#import "JifenViewController.h"

#import "CreditWebViewController.h"
#import "MyWalletViewController.h"
#import "RootViewController.h"
#import "MoreViewController.h"

#import "WaterfallViewController.h"
#import "UsedDressViewController.h"

#import "FriendViewController.h"
#import "IntegralListViewController.h"
@interface MyselfViewController ()
{
    FXBlurView *blurView;
    UIView *qrCodeView;
    //UIView *headView;
    UIImageView *headIamageView;
    UIImageView *headeView;
    UIImageView *tmtView;
    
    UIScrollView *tableScrollView;
    UIImageView *lineIamgeView;
    
    UILabel *nameLabel;
    UILabel *distanceLabel;
    UILabel *positionLabel;
    //卡片Label
    UILabel *cradLabel;
    //订单label
    UILabel *orderLabel;
    //关注label
    UILabel *concernLabel;
    
    NSString *nameString;
    NSString *distanceString;
    NSString *positionString;
    //卡片文字
    NSString *cradString;
    //订单数字
    NSString *orderString;
    //关注数字
    NSString *concernString;
    
    NSDictionary *dict;
    
    UIImageView *genderIamgeView;
    UIButton *gradeButton;
    
    UILabel *titleLabel;
    
    NSArray *myReleaseArray;
    NSString *myReleaseString;
    NSArray *myParticipateArray;
    NSString *myParticipateString;
    
    UILabel *lableHY;
    
    NSDictionary *_dict;
    
    NSDictionary *dct;
    int tableID;
    
    NSString *webURL;
    
    RootViewController *vcRoot;
    UIView *layoutView;
    UIWebView *myWebView;
    UIActivityIndicatorView *webActivityView;
    UIActivityIndicatorView *indView;
    UILabel *webTitleLabel;
    
    UsedDressViewController *userdressVC;
}
@end

@implementation MyselfViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBarHidden=YES;
   
   
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的"];
}
-(void)viewDidAppear:(BOOL)animated
{
    [indView stopAnimating]; // 结束旋转
    [indView setHidesWhenStopped:YES]; //当旋转结束时隐藏
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dic = @{@"user_id":_view_userID};
    [_download requestWithUrl:USER_QRCODE dict:_dic view:self.view delegate:self finishedSEL:@selector(qRcodeSuccess:) isPost:NO failedSEL:@selector(qRcodeFailure:)];
    [self dataLayout];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame=FRAME(0, 0, WIDTH, HEIGHT-50);
    [indView removeFromSuperview];
    indView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indView.center = CGPointMake(WIDTH/2, HEIGHT/2);
    indView.color = [UIColor redColor];
    [indView startAnimating];
    [self.view addSubview:indView];
    if (_rootId==0) {
        ISLoginManager *_manager = [ISLoginManager shareManager];
        _userID=_manager.telephone;
        _view_userID=_manager.telephone;
    }
    self.backBtn.hidden=YES;
    self.navlabel.hidden=YES;
    self.navlabel.text=@"个人主页";
    self.view.userInteractionEnabled=YES;
}
-(void)dataLayout
{
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dicts = @{@"user_id":_userID,@"view_user_id":_view_userID};
    [_download requestWithUrl:USER_GRZY dict:_dicts view:self.view delegate:self finishedSEL:@selector(DownloadFinish1:) isPost:NO failedSEL:@selector(FailDownload:)];
}
- (void)DownloadFinish1:(id)responsobject
{
    NSLog(@"用户数据%@",responsobject);
    dict = [responsobject objectForKey:@"data"];
    [self imageViewLayout];
    NSLog(@"下载成功的数据%@",dict);
    
}
- (void)FailDownload:(id)error
{
    NSLog(@"error: %@",error);
}

-(void)backAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)imageViewLayout
{
    [blurView removeFromSuperview];
    [headeView removeFromSuperview];
    [headIamageView removeFromSuperview];
    NSString *headString=[NSString stringWithFormat:@"%@",[dict objectForKeyedSubscript:@"head_img"]];
    NSLog(@"1%@2",headString);
    if (_rootId==1) {
        
//        headeView=[[UIImageView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT*0.51-HEIGHT*0.07-24)];
        if ([headString length]==1||[headString length]==0) {
            headeView.image =[UIImage imageNamed:@"家-我_默认头像"];
        }else
        {
//            NSString *imageUrl=[NSString stringWithFormat:@"%@",[dict objectForKey:@"head_img"]];
//            [headeView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
//            headeView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"head_img"]]]];
        }
        headeView.backgroundColor=HEX_TO_UICOLOR(0xe8374a, 1.0);
        NSString *imageUrl=@"http://123.57.173.36/simi-h5/img/my_bg_update.jpg";
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        headeView.image=[UIImage imageWithData:data];
        [self.view addSubview:headeView];
        
        self.backBtn.hidden=NO;
        self.navlabel.hidden=NO;
        blurView = [FXBlurView new];
        blurView.frame = CGRectMake(0, 64, WIDTH, HEIGHT*0.51-HEIGHT*0.07-44);
        blurView.backgroundColor = [UIColor brownColor];
        [blurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin];
        [self.view addSubview:blurView];
    }else{
        self.backBtn.hidden=YES;
        self.navlabel.hidden=YES;
        headeView=[[UIImageView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT*0.51-HEIGHT*0.07-24)];
        if ([headString length]==1||[headString length]==0) {
//            headeView.image = [UIImage imageNamed:@"家-我_默认头像"];
        }else
        {
//            NSString *imageUrl=[NSString stringWithFormat:@"%@",[dict objectForKey:@"head_img"]];
//            [headeView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
//            headeView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"head_img"]]]];
        }
        headeView.backgroundColor=HEX_TO_UICOLOR(0xe8374a, 1.0);
        NSString *imageUrl=@"http://123.57.173.36/simi-h5/img/my_bg_update.jpg";
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        headeView.image=[UIImage imageWithData:data];
        
        [self.view addSubview:headeView];
        self.backBtn.hidden=YES;
        titleLabel.hidden=YES;
        blurView = [FXBlurView new];
        blurView.frame = CGRectMake(0, 0, WIDTH, HEIGHT*0.51-HEIGHT*0.07-24);
        blurView.backgroundColor = [UIColor brownColor];
        [blurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin];
        [self.view addSubview:blurView];
    }
    
    headIamageView=[[UIImageView alloc]initWithFrame:FRAME((WIDTH-HEIGHT*0.14)/2, HEIGHT*0.04+20, HEIGHT*0.14, HEIGHT*0.14)];
    if ([headString length]==0||[headString length]==1) {
        headIamageView.image = [UIImage imageNamed:@"家-我_默认头像"];
    }else
    {
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[dict objectForKey:@"head_img"]];
        [headIamageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
//        headIamageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"head_img"]]]];
    }
    [headIamageView.layer setCornerRadius:CGRectGetHeight([headIamageView bounds]) / 2];
    headIamageView.layer.masksToBounds = YES;
    headIamageView.layer.borderWidth = 2;
    headIamageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActiion:)];
    tap.delegate=self;
    tap.cancelsTouchesInView=YES;
    [headIamageView addGestureRecognizer:tap];
    [blurView addSubview:headIamageView];
    blurView.userInteractionEnabled=YES;
    headIamageView.userInteractionEnabled=YES;
    [self controlLayour];
    [tableScrollView removeFromSuperview];
    if(_rootId==1){
        tableScrollView=[[UIScrollView alloc]initWithFrame:FRAME(0, blurView.frame.size.height+blurView.frame.origin.y+20, WIDTH, HEIGHT-blurView.frame.size.height-114)];
    }else{
        tableScrollView=[[UIScrollView alloc]initWithFrame:FRAME(0, blurView.frame.size.height+blurView.frame.origin.y, WIDTH, HEIGHT-blurView.frame.size.height-50)];
    }
    
    tableScrollView.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:232/255.0f];
    tableScrollView.contentSize=CGSizeMake(WIDTH, 131*3+80);
    tableScrollView.delegate=self;
    [self.view addSubview:tableScrollView];
    NSArray *toolArray=@[@"Wallet_Lcon",@"Coupon_Lcon",@"Order_Lcon",@"iconfont-changyongdizhi"];
    NSArray *growArray=@[@"Knowledge_Lcon",@"iconfont-gongzuotuijian",@"Integral_Lcon",@"Part-time-job_Lcon"];
    for (int i=0; i<4; i++) {
        UIView *view=[[UIView alloc]init];
        if (i!=3) {
            view.frame=FRAME(0, 10+131*i, WIDTH, 121);
        }else{
            view.frame=FRAME(0, 10+131*i, WIDTH, 61);
        }
        view.backgroundColor=[UIColor whiteColor];
        [tableScrollView addSubview:view];
        UIView *lineView=[[UIView alloc]init];
        lineView.backgroundColor=[UIColor colorWithRed:205/255.0f green:205/255.0f blue:205/255.0f alpha:1];
        [view addSubview:lineView];
        switch (i) {
            case 0:
            {
                lineView.frame=FRAME(0, 50, WIDTH, 1);
                UIView *lineVw=[[UIView alloc]initWithFrame:FRAME(0, 121, WIDTH, 1)];
                lineVw.backgroundColor=[UIColor colorWithRed:205/255.0f green:205/255.0f blue:205/255.0f alpha:1];
                [view addSubview:lineVw];
                
                UIImageView *toolHeadeImage=[[UIImageView alloc]initWithFrame:FRAME(10, 15, 20, 20)];
                toolHeadeImage.image=[UIImage imageNamed:@"Toolbox_Lcon"];
                [view addSubview:toolHeadeImage];
                UILabel *toolLabel=[[UILabel alloc]initWithFrame:FRAME(toolHeadeImage.frame.size.width+toolHeadeImage.frame.origin.x, 10, 80, 30)];
                toolLabel.text=@"工具箱";
                toolLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
                toolLabel.textColor=[UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1];
                [view addSubview:toolLabel];
                
//                UIButton *toolMoreBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH-70, 10, 50, 30)];
//                [toolMoreBut addTarget:self action:@selector(toolMoreButAction) forControlEvents:UIControlEventTouchUpInside];
//                [view addSubview:toolMoreBut];
                
                UIView *toolMoreBut=[[UIView alloc]initWithFrame:FRAME(WIDTH-70, 10, 50, 30)];
                [view addSubview:toolMoreBut];
                UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
                longPressGr.minimumPressDuration = 5.0;
                [toolMoreBut addGestureRecognizer:longPressGr];
                
                
                UILabel *toolViceLabel=[[UILabel alloc]initWithFrame:FRAME(0, 5, 40, 20)];
                toolViceLabel.text=@"更多";
                toolViceLabel.textAlignment=NSTextAlignmentRight;
                toolViceLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
                toolViceLabel.textColor=[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1];
//                [toolMoreBut addSubview:toolViceLabel];
                
                UIImageView *toolMoreImage=[[UIImageView alloc]initWithFrame:FRAME(40, 5, 20, 20)];
                toolMoreImage.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
//                [toolMoreBut addSubview:toolMoreImage];
                
                NSArray *array=@[@"钱包",@"优惠劵",@"订单",@"常用地址"];
                for (int j=0; j<array.count; j++) {
                    UIButton *toolButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH/4*j, 51, WIDTH/4, 70)];
                    toolButton.tag=100+j;
                    [toolButton addTarget:self action:@selector(toolButAction:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:toolButton];
                    UIImageView *lconImageView=[[UIImageView alloc]initWithFrame:FRAME((WIDTH/4-30)/2, 10, 30, 30)];
                    //lconImageView.backgroundColor=[UIColor redColor];
                    lconImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",toolArray[j]]];
                    [toolButton addSubview:lconImageView];
                    
                    UILabel *lconLabel=[[UILabel alloc]initWithFrame:FRAME(0, 45, WIDTH/4, 15)];
                    lconLabel.text=[NSString stringWithFormat:@"%@",array[j]];
                    lconLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
                    lconLabel.textAlignment=NSTextAlignmentCenter;
                    lconLabel.textColor=[UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1];
                    [toolButton addSubview:lconLabel];
                }
            }
                break;
            case 1:
            {
                lineView.frame=FRAME(0, 50, WIDTH, 1);
                UIView *lineVw=[[UIView alloc]initWithFrame:FRAME(0, 121, WIDTH, 1)];
                lineVw.backgroundColor=[UIColor colorWithRed:205/255.0f green:205/255.0f blue:205/255.0f alpha:1];
                [view addSubview:lineVw];
                
                UIImageView *growHeadeImage=[[UIImageView alloc]initWithFrame:FRAME(10, 15, 20, 20)];
                growHeadeImage.image=[UIImage imageNamed:@"Grow-up_Lcon"];
                [view addSubview:growHeadeImage];
                UILabel *growLabel=[[UILabel alloc]initWithFrame:FRAME(growHeadeImage.frame.size.width+growHeadeImage.frame.origin.x, 10, 80, 30)];
                growLabel.text=@"会员服务";
                growLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
                growLabel.textColor=[UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1];
                [view addSubview:growLabel];
                
                UIButton *growMoreBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH-70, 10, 50, 30)];
                [growMoreBut addTarget:self action:@selector(growMoreButAction) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:growMoreBut];
                
                UILabel *growViceLabel=[[UILabel alloc]initWithFrame:FRAME(0, 5, 40, 20)];
                growViceLabel.text=@"LV3";
                growViceLabel.textAlignment=NSTextAlignmentRight;
                growViceLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
                growViceLabel.textColor=[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1];
                //[growMoreBut addSubview:growViceLabel];
                
                UIImageView *growMoreImage=[[UIImageView alloc]initWithFrame:FRAME(40, 5, 20, 20)];
                growMoreImage.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
                //[growMoreBut addSubview:growMoreImage];

                
                NSArray *array=@[@"知识库",@"工作推荐",@"积分商城",@"开店"];
                for (int k=0; k<array.count; k++) {
                    UIButton *growButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH/4*k, 51, WIDTH/4, 70)];
                    growButton.tag=1000+k;
                    [growButton addTarget:self action:@selector(growButAction:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:growButton];
                    UIImageView *lconImageView=[[UIImageView alloc]initWithFrame:FRAME((WIDTH/4-30)/2, 10, 30, 30)];
                    //lconImageView.backgroundColor=[UIColor redColor];
                    lconImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",growArray[k]]];
                    [growButton addSubview:lconImageView];
                    
                    UILabel *lconLabel=[[UILabel alloc]initWithFrame:FRAME(0, 45, WIDTH/4, 15)];
                    lconLabel.text=[NSString stringWithFormat:@"%@",array[k]];
                    lconLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
                    lconLabel.textAlignment=NSTextAlignmentCenter;
                    lconLabel.textColor=[UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1];
                    [growButton addSubview:lconLabel];
                }

            }
                break;
            case 2:
            {
                lineView.frame=FRAME(0, 60, WIDTH, 1);
                UIView *lineVw=[[UIView alloc]initWithFrame:FRAME(0, 121, WIDTH, 1)];
                lineVw.backgroundColor=[UIColor colorWithRed:205/255.0f green:205/255.0f blue:205/255.0f alpha:1];
                [view addSubview:lineVw];
                NSArray *otherArray=@[@"推荐给好友",@"更多"];
                NSArray *otherImageArray=@[@"Recommend_Lcon",@"More_lcon"];
                for (int s=0; s<otherArray.count; s++) {
                    UIButton *otherButton=[[UIButton alloc]initWithFrame:FRAME(0, 61*s, WIDTH, 60)];
                    otherButton.tag=10000+s;
                    [otherButton addTarget:self action:@selector(otherButAction:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:otherButton];
                    
                    UIImageView *otherHeadeImage=[[UIImageView alloc]initWithFrame:FRAME(10, 20, 20, 20)];
                    otherHeadeImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",otherImageArray[s]]];
                    [otherButton addSubview:otherHeadeImage];
                    
                    UILabel *otherLabel=[[UILabel alloc]initWithFrame:FRAME(otherHeadeImage.frame.size.width+otherHeadeImage.frame.origin.x, 15, 90, 30)];
                    otherLabel.text=[NSString stringWithFormat:@"%@",otherArray[s]];
                    otherLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
                    otherLabel.textColor=[UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1];
                    [otherButton addSubview:otherLabel];
                    
                    UIImageView *arrowImage=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-30, 20, 20, 20)];
                    arrowImage.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
                    [otherButton addSubview:arrowImage];
                    
                }
                
                
            }
                break;
            case 3:
            {
                lineView.frame=FRAME(0, 60, WIDTH, 1);
                UIButton *merchantButton=[[UIButton alloc]initWithFrame:FRAME(0, 0, WIDTH, 60)];
                merchantButton.tag=10;
                [merchantButton addTarget:self action:@selector(merchantButAction:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:merchantButton];
                
                UIImageView *merchantHeadeImage=[[UIImageView alloc]initWithFrame:FRAME(10, 20, 20, 20)];
                merchantHeadeImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"Merchant_Lcon"]];
                [merchantButton addSubview:merchantHeadeImage];
                
                UILabel *merchantLabel=[[UILabel alloc]initWithFrame:FRAME(merchantHeadeImage.frame.size.width+merchantHeadeImage.frame.origin.x, 15, 90, 30)];
                merchantLabel.text=@"我是商家";
                merchantLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
                merchantLabel.textColor=[UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1];
                [merchantButton addSubview:merchantLabel];
                
                UIImageView *arrowImage=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-30, 20, 20, 20)];
                arrowImage.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
                [merchantButton addSubview:arrowImage];
                
                UILabel *mobileLabel=[[UILabel alloc]init];
                mobileLabel.text=@"400-169-1615";
                mobileLabel.textColor=[UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1];
                mobileLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
                [mobileLabel setNumberOfLines:1];
                [mobileLabel sizeToFit];
                mobileLabel.frame=FRAME(WIDTH-30-mobileLabel.frame.size.width, 20, mobileLabel.frame.size.width, 20);
                [merchantButton addSubview:mobileLabel];


            }
                break;

            default:
                break;
        }
    }
    
    
}
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        WaterfallViewController *centerVC=[[WaterfallViewController alloc]init];
        [self.navigationController pushViewController:centerVC animated:YES];
    }
}
#pragma mark 工具箱更多按钮点击方法
-(void)toolMoreButAction
{
    NSLog(@"更多工具被点击了！！！");
    WaterfallViewController *centerVC=[[WaterfallViewController alloc]init];
    [self.navigationController pushViewController:centerVC animated:YES];
}
#pragma mark 我的成长等级按钮点击方法
-(void)growMoreButAction
{
    NSLog(@"我在查看等级哦！！！");
}
#pragma mark 工具箱多个按钮的点击方法
-(void)toolButAction:(UIButton *)sender
{
    NSInteger tag=sender.tag;
    int tg=(int)tag;
    NSArray *array=@[@"钱包",@"优惠劵",@"订单",@"常用地址"];
    NSLog(@"%@--被点击了",array[tg-100]);
    switch (tg) {
        case 100:
        {
            MyWalletViewController *mywalletVC=[[MyWalletViewController alloc]init];
            [self.navigationController pushViewController:mywalletVC animated:YES];
        }
            break;
        case 101:
        {
            MineJifenViewController *mineVc=[[MineJifenViewController alloc]init];
            [self.navigationController pushViewController:mineVc animated:YES];
        }
            break;
        case 102:
        {
            Order_ListViewController *orderVc=[[Order_ListViewController alloc]init];
            [self.navigationController pushViewController:orderVc animated:YES];
        }
            break;
        case 103:
        {
            userdressVC=[[UsedDressViewController alloc]init];
            [self.navigationController pushViewController:userdressVC animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark 我的成长中多个按钮点击方法
-(void)growButAction:(UIButton *)sender
{
    NSInteger tag=sender.tag;
    int tg=(int)tag;
    NSArray *array=@[@"知识库",@"工作推荐",@"积分商城",@"开店"];
    NSLog(@"%@--被点击了",array[tg-1000]);
    switch (tg) {
        case 1000:
        {
            webURL=@"http://51xingzheng.cn/";
            [self webViewLayout];
        }
            break;
        case 1001:
        {
           webURL=@"http://m.58.com/bj/renli/?PGTID=0d303652-0000-171b-6d46-e307e18a1ae0&ClickID=3";
            [self webViewLayout];
            
        }
            break;
        case 1002:
        {
            ISLoginManager *_manager = [ISLoginManager shareManager];
            NSString *url=[NSString stringWithFormat:@"http://123.57.173.36/simi/app/user/score_shop.json?user_id=%@",_manager.telephone];
            CreditWebViewController *web=[[CreditWebViewController alloc]initWithUrl:url];//实际中需要改为带签名的地址
            //如果已经有UINavigationContoller了，就 创建出一个 CreditWebViewController 然后 push 进去
            [self.navigationController pushViewController:web animated:YES];
                    }
            break;
        case 1003:
        {
            webURL=[NSString stringWithFormat:@"http://123.57.173.36/simi-h5/show/store-my-index.html?user_id=%@",_userID];
            [self webViewLayout];
            
        }
            break;
        default:
            break;
    }

}
-(void)webViewLayout
{
    [layoutView removeFromSuperview];
    layoutView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT-50)];
    layoutView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:layoutView];
    
    [myWebView removeFromSuperview];
    myWebView= [[UIWebView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-120)];
    myWebView.delegate=self;
    //self.meWebView.hidden=YES;
    myWebView.scrollView.delegate=self;
    [layoutView addSubview:myWebView];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",webURL]];
    //NSLog(@"gourl  =  %@",_imgurl);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:request];
    
    UIButton *liftButton=[[UIButton alloc]initWithFrame:FRAME(10, 20, 50, 30)];
    //liftButton.backgroundColor=[UIColor blackColor];
    [liftButton addTarget:self action:@selector(liftButAction) forControlEvents:UIControlEventTouchUpInside];
    [layoutView addSubview:liftButton];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:FRAME(18, 5, 10, 20)];
    image.image = [UIImage imageNamed:@"title_left_back"];
    [liftButton addSubview:image];
    
    webTitleLabel=[[UILabel alloc]initWithFrame:FRAME(60, 20, WIDTH-120, 30)];
    webTitleLabel.textAlignment=NSTextAlignmentCenter;
    webTitleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    [layoutView addSubview:webTitleLabel];
    
    UIButton *rightButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-60, 20, 50, 30)];
    //rightButton.backgroundColor=[UIColor blackColor];
    [rightButton addTarget:self action:@selector(rightButAction) forControlEvents:UIControlEventTouchUpInside];
    [layoutView addSubview:rightButton];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(10, 0, 30, 30)];
    img.image = [UIImage imageNamed:@"WEB_QX"];
    [rightButton addSubview:img];
}
-(void)rightButAction
{
    [layoutView removeFromSuperview];
}
-(void)liftButAction
{
    if([myWebView canGoBack])
    {
        [myWebView goBack];
    }else{
        [layoutView removeFromSuperview];
    }

}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [webActivityView removeFromSuperview];
    webActivityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    webActivityView.center = CGPointMake(WIDTH/2, HEIGHT/2);
    webActivityView.color = [UIColor redColor];
    [webActivityView startAnimating];
    [myWebView addSubview:webActivityView];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webActivityView stopAnimating]; // 结束旋转
    [webActivityView setHidesWhenStopped:YES]; //当旋转结束时隐藏
    webTitleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}


#pragma mark 推荐给好友与更多按钮点击方法
-(void)otherButAction:(UIButton *)sender
{
    NSInteger tag=sender.tag;
    int tg=(int)tag;
    NSArray *array=@[@"推荐给好友",@"更多"];
    NSLog(@"%@--被点击了",array[tg-10000]);
    switch (tg) {
        case 10000:
            [UMSocialSnsService presentSnsIconSheetView:self appKey:YMAPPKEY shareText:@"云行政，企业行政服务第一平台！极大降低企业行政管理成本，有效提升行政综合服务能力，快来试试吧！体验就送礼哦：http://51xingzheng.cn/h5-app-download.html" shareImage:[UIImage imageNamed:@"yunxingzheng-Logo-512.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina,nil] delegate:self];
            break;
        case 10001:
        {
            MoreViewController *moreVC=[[MoreViewController alloc]init];
            [self.navigationController pushViewController:moreVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark 我是商家按钮点击方法
-(void)merchantButAction:(UIButton *)sender
{
    NSLog(@"我是商家--被点击了");
    NSString *phoneNum = @"";// 电话号码
    
    phoneNum = @"400-169-1615";
    
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    
    UIWebView *phoneCallWebView;
    
    if ( !phoneCallWebView ) {
        
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        
    }
    
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    phoneCallWebView.userInteractionEnabled=YES;
    [self.view addSubview:phoneCallWebView];
}
//头像点击事件
-(void)tapActiion:(UITapGestureRecognizer *)sender
{
    UserInfoViewController *userinfo = [[UserInfoViewController alloc]init];
    [self presentViewController:userinfo animated:YES completion:nil];
    NSLog(@"点击了 ");
}
-(void)controlLayour
{
    
    [self nameLabelLayout];
    
    genderIamgeView=[[UIImageView alloc]initWithFrame:FRAME(nameLabel.frame.origin.x+nameLabel.frame.size.width+10, nameLabel.frame.origin.y+5/2, 10, 15)];
    genderIamgeView.image=[UIImage imageNamed:@"WD_XB_ ♀_TB"];
    [blurView addSubview:genderIamgeView];
    
    gradeButton=[[UIButton alloc]initWithFrame:FRAME(genderIamgeView.frame.size.width+genderIamgeView.frame.origin.x+10, headIamageView.frame.origin.y+headIamageView.frame.size.height+HEIGHT*0.02, 30, 20)];
    UIImageView *iamgeView=[[UIImageView alloc]initWithFrame:FRAME(0, 5/2, 30, 15)];
    iamgeView.image=[UIImage imageNamed:@"WD_DJ_TB_@2x"];
    [gradeButton addSubview:iamgeView];
    //gradeButton.backgroundColor=[UIColor blackColor];
    UILabel *label=[[UILabel alloc]initWithFrame:FRAME(0, 0, 30, 20)];
    label.text=@"LV1";
    label.font=[UIFont fontWithName:@"Heiti SC" size:10];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    [gradeButton addSubview:label];
    [blurView addSubview:gradeButton];
    
    distanceLabel=[[UILabel alloc]init];
    positionLabel=[[UILabel alloc]init];
    [self distanceLabelLayout];

    int userId=[_userID intValue];
    int viewUserId=[_view_userID intValue];
    //添加好友按钮
    UIButton *addButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH/2-221/2, distanceLabel.frame.size.height+distanceLabel.frame.origin.y+HEIGHT*0.019, 204/2, HEIGHT*0.04)];
    if (userId==viewUserId) {
        addButton.hidden=YES;
    }else{
        addButton.hidden=NO;
    }
    for (int i=0; i<_array.count; i++) {
        NSDictionary *dic=_array[i];
        NSString *user_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"friend_id"]];
        int usID=[user_id intValue];
        if (viewUserId==usID) {
            addButton.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
            addButton.enabled=FALSE;
            break;
        }else{
            addButton.backgroundColor=[UIColor colorWithRed:231/255.0f green:55/255.0f blue:74/255.0f alpha:1];
            addButton.enabled=TRUE;
        }
    }
    
    addButton.layer.cornerRadius=4;
    [addButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [blurView addSubview:addButton];
    
    UILabel *addLabel=[[UILabel alloc]init];
    addLabel.text=@"添加好友";
    addLabel.textColor=[UIColor whiteColor];
    addLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    addLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [addLabel setNumberOfLines:1];
    [addLabel sizeToFit];
    addLabel.frame=FRAME((addButton.frame.size.width-addLabel.frame.size.width)/2, (addButton.frame.size.height-addLabel.frame.size.height)/2, addLabel.frame.size.width, addLabel.frame.size.height);
    [addButton addSubview:addLabel];
    //私聊按钮
    UIButton *whisperButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH/2+17/2, addButton.frame.origin.y, 204/2, HEIGHT*0.04)];
    if (userId==viewUserId) {
        whisperButton.hidden=YES;
    }else{
        whisperButton.hidden=NO;
    }
    whisperButton.backgroundColor=[UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1];
    whisperButton.layer.cornerRadius=4;
    [whisperButton addTarget:self action:@selector(whisperAction:) forControlEvents:UIControlEventTouchUpInside];
    [blurView addSubview:whisperButton];
    
    UILabel *whisperLabel=[[UILabel alloc]init];
    whisperLabel.text=@"私聊";
    whisperLabel.textColor=[UIColor whiteColor];
    whisperLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    whisperLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [whisperLabel setNumberOfLines:1];
    [whisperLabel sizeToFit];
    whisperLabel.frame=FRAME((whisperButton.frame.size.width-whisperLabel.frame.size.width)/2, (whisperButton.frame.size.height-whisperLabel.frame.size.height)/2, whisperLabel.frame.size.width, whisperLabel.frame.size.height);
    [whisperButton addSubview:whisperLabel];
    
    tmtView=[[UIImageView  alloc]initWithFrame:FRAME(0, blurView.frame.size.height-HEIGHT*0.09, WIDTH, HEIGHT*0.09)];
    tmtView.userInteractionEnabled=YES;
    tmtView.image=[UIImage imageNamed:@"TMT(2)(4)"];
    if (_rootId==1) {
        tmtView.hidden=YES;
    }else{
        tmtView.hidden=NO;
    }
    [blurView addSubview:tmtView];
    //个人中心按钮
    UIButton *meButton=[[UIButton alloc]initWithFrame:FRAME(29/2, 38/2, 30, 30)];
    if(_rootId==1){
        meButton.hidden=YES;
    }else{
        meButton.hidden=NO;
    }
    [meButton addTarget:self action:@selector(meAction:) forControlEvents:UIControlEventTouchUpInside];
    [meButton setImage:[UIImage imageNamed:@"WD_GRZX_TB_@2"] forState:UIControlStateNormal];
    //[blurView addSubview:meButton];
    //信封按钮
    UIButton *envelopeButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-29/2-40, 38/2, 40, 30)];
    envelopeButton.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [envelopeButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    UIButton *qrCode=[[UIButton alloc]initWithFrame:FRAME(WIDTH-109/2, 38/2+10,40, 40)];
    if(_rootId==1){
        qrCode.hidden=YES;
    }else{
        qrCode.hidden=NO;
    }
    qrCode.layer.cornerRadius=qrCode.frame.size.width/2;
    qrCode.clipsToBounds=YES;
    [qrCode addTarget:self action:@selector(qrCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    //[qrCode setImage:[UIImage imageNamed:@"QRcode"] forState:UIControlStateNormal];
    [blurView addSubview:qrCode];
    
    UIImageView *qrCodeIamge=[[UIImageView alloc]initWithFrame:FRAME(5/2, 5/2, 25, 25)];
    qrCodeIamge.image=[UIImage imageNamed:@"QRcode"];
    [qrCode addSubview:qrCodeIamge];

    NSArray *array=@[@"好友",@"动态",@"积分"];
    for (int i=0; i<array.count; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:FRAME(WIDTH/3*i+0.5, tmtView.frame.size.height-19/2-11, WIDTH/3-0.5, 11)];
        label.text=array[i];
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor whiteColor];
        label.font=[UIFont fontWithName:@"Heiti SC" size:11];
        [tmtView addSubview:label];
        
        UIButton *button=[[UIButton alloc]initWithFrame:FRAME(WIDTH/3*i+0.5, 0, WIDTH/3-0.5, tmtView.frame.size.height)];
        button.tag=i;
        [button addTarget:self action:@selector(headeBut:) forControlEvents:UIControlEventTouchUpInside];
        [tmtView addSubview:button];
        if (i!=2) {
            UIView *lineView=[[UIView alloc]initWithFrame:FRAME(WIDTH/3-0.5+WIDTH/3*i, (HEIGHT*0.09-HEIGHT*0.037)/2, 1, HEIGHT*0.037)];
            lineView.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
            [tmtView addSubview:lineView];
        }
        
    }
    cradLabel=[[UILabel alloc]init];
    [self cradLabelLayout];
    orderLabel=[[UILabel alloc]init];
    [self orderLabelLayout];
    concernLabel=[[UILabel alloc]init];
    [self concernLabelLayout];
    
}
-(void)tapQRActiion
{
    qrCodeView.frame=FRAME(WIDTH, 0, WIDTH, HEIGHT);
}
#pragma mark 我的二维码按钮点击方法
-(void)qrCodeAction:(UIButton *)sender
{
    qrCodeView.frame=FRAME(0, 0, WIDTH, HEIGHT);
    
    [self.view addSubview:qrCodeView];
}
-(void)qRcodeSuccess:(id)sender
{
    [qrCodeView removeFromSuperview];
    qrCodeView=[[UIView alloc]initWithFrame:FRAME(WIDTH, 0, WIDTH, HEIGHT-50)];
    qrCodeView.backgroundColor=[UIColor whiteColor];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapQRActiion)];
    tap.delegate=self;
    tap.cancelsTouchesInView=YES;
    [qrCodeView addGestureRecognizer:tap];
    UIButton *returnBut=[[UIButton alloc]initWithFrame:FRAME(0, 20, 70, 40)];
    [returnBut addTarget:self action:@selector(tapQRActiion) forControlEvents:UIControlEventTouchUpInside];
    [qrCodeView addSubview:returnBut];
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 10, 20)];
    img.image = [UIImage imageNamed:@"title_left_back"];
    [returnBut addSubview:img];
    
    UILabel *textLabel=[[UILabel alloc]initWithFrame:FRAME(10, (qrCodeView.frame.size.height-(WIDTH-60))/2-28, WIDTH-20, 18)];
    textLabel.text=@"我的二维码名片";
    textLabel.textAlignment=NSTextAlignmentCenter;
    textLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    [qrCodeView addSubview:textLabel];
    UIImageView *qrImageView=[[UIImageView alloc]initWithFrame:FRAME(30, (qrCodeView.frame.size.height-(WIDTH-60))/2, WIDTH-60, WIDTH-60)];
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    [qrImageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
    [qrCodeView addSubview:qrImageView];
    
    UILabel *explainLabel=[[UILabel alloc]initWithFrame:FRAME(10, qrImageView.frame.size.height+qrImageView.frame.origin.y+30, WIDTH-20, 20)];
    explainLabel.text=@"点击任意处可退出";
    explainLabel.textAlignment=NSTextAlignmentCenter;
    explainLabel.font=[UIFont fontWithName:@"Heiti SC" size:18];
    explainLabel.textColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    [qrCodeView addSubview:explainLabel];
    [self.view addSubview:qrCodeView];
}
-(void)qRcodeFailure:(id)sender
{
    NSLog(@"获取二维码失败%@",sender);
}
#pragma mark卡片文字显示方法
-(void)cradLabelLayout
{
    NSString *moneyString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"total_friends"]];
    NSLog(@"%@",moneyString);
    if (moneyString==NULL||moneyString==nil||[moneyString length]==0) {
        cradString=@"0";
    }else{
        cradString=[NSString stringWithFormat:@"%@",moneyString];
    }

    cradLabel.text=cradString;
    cradLabel.textAlignment=NSTextAlignmentCenter;
    cradLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [cradLabel setNumberOfLines:1];
    [cradLabel sizeToFit];
    cradLabel.frame=FRAME(0, HEIGHT*0.09*0.2, WIDTH/3-0.5, 32/2);
    cradLabel.textColor=[UIColor whiteColor];
    cradLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    [tmtView addSubview:cradLabel];
    
}
#pragma mar订单文字显示方法
-(void)orderLabelLayout
{
    
    orderString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"total_feed"]];
    orderLabel.text=orderString;
    orderLabel.textAlignment=NSTextAlignmentCenter;
    orderLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [orderLabel setNumberOfLines:1];
    [orderLabel sizeToFit];
    orderLabel.frame=FRAME(WIDTH/3+0.5, HEIGHT*0.09*0.2, WIDTH/3-1, 32/2);
    orderLabel.textColor=[UIColor whiteColor];
    orderLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    [tmtView addSubview:orderLabel];
}
#pragma mark关注文字显示方法
-(void)concernLabelLayout
{
    concernString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"score"]];
    concernLabel.text=concernString;
    concernLabel.textAlignment=NSTextAlignmentCenter;
    concernLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [concernLabel setNumberOfLines:1];
    [concernLabel sizeToFit];
    concernLabel.frame=FRAME(WIDTH/3*2+0.5, HEIGHT*0.09*0.2, WIDTH/3-0.5, 32/2);
    concernLabel.textColor=[UIColor whiteColor];
    concernLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    [tmtView addSubview:concernLabel];
}
-(void)nameLabelLayout
{
    [nameLabel removeFromSuperview];
    nameLabel=[[UILabel alloc]init];
    NSString *nameStr=[dict objectForKey:@"name"];
    NSLog(@"用户昵称%@",nameStr);
    if (nameStr==nil||nameStr==NULL||[nameStr isEqual:@""]) {
        nameString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"mobile"]];
    }else{
        nameString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
    }
    nameLabel.text=nameString;
    nameLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [nameLabel setNumberOfLines:1];
    [nameLabel sizeToFit];
    nameLabel.adjustsFontSizeToFitWidth=YES;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font=[UIFont systemFontOfSize:18];
    nameLabel.frame=FRAME((WIDTH-nameLabel.frame.size.width)/2, headIamageView.frame.origin.y+headIamageView.frame.size.height+HEIGHT*0.02, nameLabel.frame.size.width, 20);
    nameLabel.textColor=[UIColor whiteColor];
    
    [blurView addSubview:nameLabel];
    genderIamgeView.frame=FRAME(nameLabel.frame.origin.x+nameLabel.frame.size.width+10, nameLabel.frame.origin.y+2, 10, 16);
    gradeButton.frame=FRAME(genderIamgeView.frame.size.width+genderIamgeView.frame.origin.x+10, nameLabel.frame.origin.y, 30, 20);
}
-(void)distanceLabelLayout
{
    distanceString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"province_name"]];
//    positionString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"province_name"]];
    distanceLabel.text=distanceString;
    distanceLabel.textAlignment = NSTextAlignmentRight;
    distanceLabel.adjustsFontSizeToFitWidth=YES;
    [distanceLabel setNumberOfLines:1];
    [distanceLabel sizeToFit];
    distanceLabel.frame=FRAME((WIDTH-distanceLabel.frame.size.width)/2/*-distanceLabel.frame.size.width/2-5*/, nameLabel.frame.size.height+nameLabel.frame.origin.y+HEIGHT*0.02, distanceLabel.frame.size.width, 10);
    distanceLabel.font=[UIFont fontWithName:@"Heiti SC" size:10];
    distanceLabel.textColor=[UIColor whiteColor];
    [blurView addSubview:distanceLabel];
    
    positionLabel.text=positionString;
    positionLabel.textAlignment = NSTextAlignmentLeft;
    [positionLabel setNumberOfLines:1];
    [positionLabel sizeToFit];
    positionLabel.adjustsFontSizeToFitWidth=YES;
    positionLabel.font=[UIFont fontWithName:@"Heiti SC" size:9];
    positionLabel.textColor=[UIColor whiteColor];
    positionLabel.frame=FRAME(WIDTH/2+5, distanceLabel.frame.origin.y+1, positionLabel.frame.size.width, 9);
    [blurView addSubview:positionLabel];
}

-(void)addAction:(UIButton *)sender
{
    
    
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    
    NSString *name=[NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
    NSString *mobile=[NSString stringWithFormat:@"%@",[dict objectForKey:@"mobile"]];
    NSDictionary *_dicts = @{@"user_id":_view_userID,@"name":name,@"mobile":mobile};
    NSLog(@"字典数据%@",_dicts);
    [_download requestWithUrl:USER_TJHY dict:_dicts view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:YES failedSEL:@selector(DownFail:)];
}
-(void)logDowLoadFinish:(id)sender
{
    NSLog(@"添加成功:");
}
-(void)DownFail:(id)sender
{
    
}
-(void)whisperAction:(UIButton *)sender
{
    ChatViewController *vcr=[[ChatViewController alloc]initWithChatter:[dict objectForKey:@"im_user_name"] isGroup:NO];
    vcr.title=[NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
    [vcr.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:vcr animated:YES];
}
//-(void)envelopeAction:(UIButton *)sender
//{
//    ISLoginManager *manager = [[ISLoginManager alloc]init];
//    NSString *url = [NSString stringWithFormat:@"http://123.57.173.36/simi-wwz/wx-news-list.html?user_id=%@&page=1",manager.telephone];
//    ImgWebViewController *img = [[ImgWebViewController alloc]init];
//    img.imgurl =url;
//    img.title = @"消息列表";
//    [self.navigationController pushViewController:img animated:YES];
//}

-(void)meAction:(UIButton *)sender
{
    MineViewController *vc=[[MineViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 头部三个按钮点击事件
-(void)headeBut:(UIButton *)button
{
    switch (button.tag) {
        case 0:
        {
            FriendViewController *foundVC=[[FriendViewController alloc]init];
            foundVC.friendVcID=101;
            [self.navigationController pushViewController:foundVC animated:YES];
        }
            break;
        case 1:
        {
            FriendViewController *foundVC=[[FriendViewController alloc]init];
            foundVC.friendVcID=100;
            [self.navigationController pushViewController:foundVC animated:YES];
        }
            break;
        case 2:
        {
            IntegralListViewController *integraVC=[[IntegralListViewController alloc]init];
            integraVC.productFractionStr=concernString;
            [self.navigationController pushViewController:integraVC animated:YES];
        }
            break;
            
        default:
            break;
    }
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
