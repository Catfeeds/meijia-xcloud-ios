//
//  PimiViewController.m
//  simi
//
//  Created by zrj on 14-11-17.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "PimiViewController.h"
#import "ChoiceDefine.h"
@interface PimiViewController ()
{
    UITextView  *textfield;
}
@end

@implementation PimiViewController
@synthesize delegate = _delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navlabel.text = @"平米数";
    
    UIView *view = [[UIView alloc]initWithFrame:FRAME(0, NAV_HEIGHT+8.5, SELF_VIEW_WIDTH, 216/2+1)];
    view.backgroundColor = HEX_TO_UICOLOR(CHOICE_BACK_VIEW_COLOR, 1.0);
    [self.view addSubview:view];
    
    textfield = [[UITextView alloc]initWithFrame:FRAME(0, 0.5, SELF_VIEW_WIDTH, 216/2)];
    textfield.textAlignment = NSTextAlignmentLeft;
    textfield.backgroundColor = [UIColor whiteColor];
    textfield.keyboardType = UIKeyboardTypeNumberPad;
    [view addSubview:textfield];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = HEX_TO_UICOLOR(ROUND_COLOR, 1.0);
    btn.frame = FRAME(14, NAV_HEIGHT+9+216/2+1+14, SELF_VIEW_WIDTH-30, 108/2);
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(quedingAction) forControlEvents:UIControlEventTouchUpInside];
    [btn.layer setCornerRadius:5.0];//设置矩形四个圆角半径
    [self.view addSubview:btn];
    // Do any additional setup after loading the view.
}
- (void)quedingAction
{
    [self.delegate pingmiDelegate:textfield.text];
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
