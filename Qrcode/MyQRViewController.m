//
//  MyQRViewController.m
//  LBXScanDemo
//
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "MyQRViewController.h"
#import "LBXScanWrapper.h"

@interface MyQRViewController ()
{
    UIImageView *imgview;
}
@end

@implementation MyQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button=[[UIButton alloc]initWithFrame:FRAME(5, 20, 60, 40)];
    //button.backgroundColor=[UIColor redColor];
    [button addTarget:self action:@selector(butAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:FRAME(18, 10, 10, 20)];
    image.image=[UIImage imageNamed:@"title_left_back"];
    [button addSubview:image];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    imgview = [[UIImageView alloc]init];
    imgview.bounds = CGRectMake(0, 0, CGRectGetWidth(self.view.frame)*4/5, CGRectGetWidth(self.view.frame)*4/5);
    imgview.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2-40);
    
    [self.view addSubview:imgview];
    
    self.view.backgroundColor = [UIColor whiteColor];
     ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dic = @{@"user_id":_manager.telephone};
    [_download requestWithUrl:USER_QRCODE dict:_dic view:self.view delegate:self finishedSEL:@selector(qRcodeSuccess:) isPost:NO failedSEL:@selector(qRcodeFailure:)];
}
-(void)butAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)qRcodeSuccess:(id)sender
{
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    [imgview setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
//    imgview.image=[UIImage imageNamed:@""];
}
-(void)qRcodeFailure:(id)sender
{
    
}
@end
