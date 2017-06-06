//
//  MyAccountController.m
//  simi
//
//  Created by 高鸿鹏 on 15/6/15.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "MyAccountController.h"
#import "MyAccountView.h"
@interface MyAccountController ()

@end

@implementation MyAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navlabel.text = @"我的账户";
    
    MyAccountView *accountView = [[MyAccountView alloc]initWithFrame:FRAME(0, 69, SELF_VIEW_WIDTH, 9+70+54*6+15)];
    [self.view addSubview:accountView];
    
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
