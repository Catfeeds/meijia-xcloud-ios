//
//  YijianFankuiViewController.m
//  simi
//
//  Created by 赵中杰 on 14/12/19.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "YijianFankuiViewController.h"
#import "YijianView.h"
#import "DownloadManager.h"
#import "MBProgressHUD+Add.h"
#import "NSString+StrSize.h"
#import "ISLoginManager.h"
#import "ChoiceDefine.h"
@interface YijianFankuiViewController ()
<YIJIANDELEGATE>
{
    UIButton *_rightBtn;
    NSString *mystring;
}

@end

@implementation YijianFankuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navlabel.text = @"意见反馈";
    
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MytextDidChange:) name:@"YIJIANTEXT" object:nil];
//    
//    
//    YijianView *_myview = [[YijianView alloc]initWithFrame:FRAME(0, 64, _WIDTH, _HEIGHT-64)];
//    _myview.delegate = self;
//    [self.view addSubview:_myview];
    

    
}

- (void)MytextDidChange:(NSNotification *)noti
{
    NSLog(@"==== %@",noti.object);
    
    mystring = [NSString stringWithFormat:@"%@",noti.object];
    
    if (mystring.length) {
        _rightBtn.userInteractionEnabled = YES;
        [_rightBtn setTitleColor:COLOR_VAULES(255.0, 255.0, 255.0, 1.0) forState:UIControlStateNormal];
        
    }else{
        _rightBtn.userInteractionEnabled = NO;
        [_rightBtn setTitleColor:COLOR_VAULE(218.0) forState:UIControlStateNormal];
        
    }
}

- (void)TijiaoBtnPressed:(UIButton *)sender
{
    [self tijiaoMessageToPhpSever:mystring];
}

- (void)TijiaoYijianBtnPressed:(NSString *)message
{
    [self tijiaoMessageToPhpSever:message];
}


- (void)tijiaoMessageToPhpSever:(NSString *)tijiaostr
{
    if (tijiaostr.length > 0) {
        
        ISLoginManager *_manager = [ISLoginManager shareManager];
        NSDictionary *_dict = @{@"user_id":_manager.telephone,@"content":[tijiaostr urlEncodeString]};
        
        DownloadManager *_download = [[DownloadManager alloc]init];
        [_download requestWithUrl:YIJIAN_FANKUI dict:_dict view:self.view delegate:self finishedSEL:@selector(DownloadFinish:) isPost:YES failedSEL:@selector(FailDown:)];
        
    }else{
        [MBProgressHUD showSuccess:@"意见不能为空" toView:self.view];
        
    }
    
}



- (void)DownloadFinish:(id)responsobject
{
    NSLog(@"object is %@",responsobject);
    
    NSInteger status = [[responsobject objectForKey:@"status"] integerValue];
    if (status == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您的建议已收到，我们会尽快查找原因并尽快解决。非常感谢对私秘的关注！" delegate:nil cancelButtonTitle:@"不客气" otherButtonTitles:nil, nil];
        [alert show];
        
        [self performSelector:@selector(PopToUpcontroller) withObject:nil afterDelay:1.5];
    }
    
}

- (void)PopToUpcontroller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)FailDown:(id)error
{
    NSLog(@"object is %@",error);
    
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
