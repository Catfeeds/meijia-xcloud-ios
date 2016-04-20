//
//  My_QR_codeViewController.m
//  yxz
//
//  Created by 白玉林 on 16/4/20.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "My_QR_codeViewController.h"

@interface My_QR_codeViewController ()
{
    UIView *qrCodeView;
}
@end

@implementation My_QR_codeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [qrCodeView removeFromSuperview];
    qrCodeView=[[UIView alloc]initWithFrame:FRAME(WIDTH, 64, WIDTH, HEIGHT-64)];
    qrCodeView.backgroundColor=[UIColor whiteColor];
    qrCodeView.frame=FRAME(0, 64, WIDTH, HEIGHT-64);
    ISLoginManager *_manager = [ISLoginManager shareManager];
    [self.view addSubview:qrCodeView];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dic = @{@"user_id":_manager.telephone};
    [_download requestWithUrl:USER_QRCODE dict:_dic view:self.view delegate:self finishedSEL:@selector(qRcodeSuccess:) isPost:NO failedSEL:@selector(qRcodeFailure:)];
    // Do any additional setup after loading the view.
}
-(void)qRcodeSuccess:(id)sender
{
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapQRActiion)];
    tap.delegate=self;
    tap.cancelsTouchesInView=YES;
    [qrCodeView addGestureRecognizer:tap];
//    UIButton *returnBut=[[UIButton alloc]initWithFrame:FRAME(0, 20, 70, 40)];
//    [returnBut addTarget:self action:@selector(tapQRActiion) forControlEvents:UIControlEventTouchUpInside];
//    [qrCodeView addSubview:returnBut];
//    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 10, 20)];
//    img.image = [UIImage imageNamed:@"title_left_back"];
//    [returnBut addSubview:img];
    
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
-(void)tapQRActiion
{
    [self.navigationController popViewControllerAnimated:YES];
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
