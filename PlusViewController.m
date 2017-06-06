//
//  PlusViewController.m
//  simi
//
//  Created by 白玉林 on 15/8/5.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "PlusViewController.h"
#import "BookingViewController.h"
#import "BaojieViewController.h"
#import "RemindViewController.h"
@interface PlusViewController ()
{
    UIImageView *view;
}

@end

@implementation PlusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.hidden=YES;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    imageView.image=[UIImage imageNamed:@"启动页"];
    [self.view addSubview:imageView];
    [self viewLayout];
    NSLog(@"677");
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"655");
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:3];
    view.frame=CGRectMake(0, 64, WIDTH, HEIGHT-113);
    [UIView commitAnimations];
}
-(void)viewLayout
{
    view=[[UIImageView alloc]initWithFrame:CGRectMake(0, HEIGHT-49, WIDTH, HEIGHT-113)];
//    view.image=[UIImage imageNamed:@"TJZZ_B"];
    view.backgroundColor=[UIColor whiteColor];
    view.userInteractionEnabled = YES;
    view.alpha=0.90;
    [self.view addSubview:view];
    int X=(WIDTH-150)/3;
    int Y=100;
    int a=0;
    for (int i=0; i<6; i++) {
        
        if (i%3==0&&i!=0) {
            a=0;
            Y=Y+100;
            UIButton *button=[[UIButton alloc]init];
            [button setTitle:@"机票" forState:UIControlStateNormal];
            button.backgroundColor=[UIColor blackColor];
            [button addTarget:self action:@selector(jipiao:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            button.tag=(1000+i);
            button.frame=CGRectMake(X/2+(X+50)*a, Y, 50, 30);
        }else{
            UIButton *button=[[UIButton alloc]init];
            [button setTitle:@"机票" forState:UIControlStateNormal];
            button.backgroundColor=[UIColor blackColor];
            [button addTarget:self action:@selector(jipiao:) forControlEvents:UIControlEventTouchUpInside];
             button.frame=CGRectMake(X/2+(X+50)*a, Y, 50, 30);
            button.tag=(1000+i);
            [view addSubview:button];
           
        }
        
        a++;
    }
    
}
-(void)jipiao:(UIButton *)tag
{
    NSLog(@"订机票%ld",(long)tag.tag);
    if (tag.tag==1000) {
        BookingViewController *vc=[[BookingViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (tag.tag==1001)
    {
        BaojieViewController *vc=[[BaojieViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(tag.tag==1002)
    {
        RemindViewController *vc=[[RemindViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
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
