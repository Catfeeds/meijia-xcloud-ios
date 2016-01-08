//
//  HowGetViewController.m
//  simi
//
//  Created by 赵中杰 on 14/12/12.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "HowGetViewController.h"
#import "GetJifenView.h"
#import "BaiduMobStat.h"
@interface HowGetViewController ()

@end

@implementation HowGetViewController
-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"怎样获取积分", nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"怎样获取积分", nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navlabel.text = @"怎 样 获 取 积 分";
    
    GetJifenView *_myview = [[GetJifenView alloc]initWithFrame:FRAME(0, 64, _WIDTH, _HEIGHT-64)];
    [self.view addSubview:_myview];
    
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
