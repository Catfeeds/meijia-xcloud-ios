//
//  AddOrderDiscussViewController.m
//  simi
//
//  Created by 赵中杰 on 14/12/15.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "AddOrderDiscussViewController.h"
#import "AddOrderDiscussView.h"
#import "DownloadManager.h"
#import "ISLoginManager.h"

@interface AddOrderDiscussViewController ()
<
    ADDDISCUSSDELEGATE
>
{
    UIScrollView *_myscroll;
    AddOrderDiscussView *_myview;
}

@end

@implementation AddOrderDiscussViewController
@synthesize ordernumber = _ordernumber;
@synthesize telephone = _telephone;
@synthesize ServiceType,address,startTime;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navlabel setText:@"评价"];
    
    _myscroll = [[UIScrollView alloc]initWithFrame:FRAME(0, 64, _WIDTH, _HEIGHT-64)];
    [self.view addSubview:_myscroll];
    
    _myview = [[AddOrderDiscussView alloc]initWithFrame:FRAME(0, 0, _WIDTH, _HEIGHT-64)serviceType:self.ServiceType startTime:self.startTime adress:self.address];
    _myview.delegate = self;
    [_myscroll addSubview:_myview];
    
    UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbtn.frame = FRAME(SELF_VIEW_WIDTH-18-20-10, 30, 40, 20);
    [rightbtn setTitle:@"提交" forState:UIControlStateNormal];
    rightbtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightbtn addTarget:self action:@selector(tijaio) forControlEvents:UIControlEventTouchUpInside];
    rightbtn.tag =100;
    [self.view addSubview:rightbtn];
    
    NSLog(@"---------%@",self.ordernumber);
}
- (void)tijaio
{
    [self adddiscussWithContent:_myview._myfiled.text status:_myview.discussstatus];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)adddiscussWithContent:(NSString *)content status:(NSInteger)selectstatus
{
    
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSMutableDictionary *sourceDic = [[NSMutableDictionary alloc]init];
    [sourceDic setObject:_manager.telephone  forKey:@"user_id"];
    [sourceDic setObject:[NSString stringWithFormat:@"%@",self.ordernumber] forKey:@"order_no"];
    [sourceDic setObject:[NSString stringWithFormat:@"%ld",(long)selectstatus]  forKey:@"order_rate"];
    [sourceDic setObject:content  forKey:@"order_rate_content"];
     NSLog(@"%@",sourceDic);
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",DISCUSS_ORDER] dict:sourceDic view:self.view delegate:self finishedSEL:@selector(DownlLoadFinish:) isPost:YES failedSEL:@selector(DownloadFail:)];
}

- (void)DownlLoadFinish:(id)responsobject
{
    NSLog(@"%@",responsobject);
    NSInteger _statuss = [[responsobject objectForKey:@"status"] integerValue];
    
    if (_statuss == 0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_ORDERSTATUS" object:@"discuss"];


        [self.navigationController popViewControllerAnimated:YES];
            

    }
    
    
}

- (void)DownloadFail:(id)responsobject
{
    NSLog(@"%@",responsobject);
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
