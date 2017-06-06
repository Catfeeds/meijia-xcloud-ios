//
//  ShopViewController.m
//  yxz
//
//  Created by 白玉林 on 16/1/7.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "ShopViewController.h"

@interface ShopViewController ()

@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT-(HEIGHT*0.43+116))];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel *textLabel=[[UILabel alloc]initWithFrame:FRAME(30, 30, WIDTH-60, 20)];
    textLabel.text=@"此好友尚未开店！！";
    textLabel.textColor=[UIColor colorWithRed:100/255.0f green:100/255.0f  blue:100/255.0f  alpha:1];
    [view addSubview:textLabel];
    // Do any additional setup after loading the view.
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
