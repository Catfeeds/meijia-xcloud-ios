//
//  GuideViewController.m
//  simi
//
//  Created by zrj on 14-12-22.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "GuideViewController.h"
#import "AppDelegate.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;

//    self.automaticallyAdjustsScrollViewInsets = NO;     //解决了 scrollview 坐标y不是从0开始
    
    myscrollview = [[UIScrollView alloc]initWithFrame:FRAME(0, -20, self.view.frame.size.width, self.view.frame.size.height+20)];
    myscrollview.contentSize = CGSizeMake(self.view.frame.size.width, 0);
    myscrollview.showsHorizontalScrollIndicator = NO;
    myscrollview.delegate = self;
    myscrollview.pagingEnabled = YES;
    myscrollview.backgroundColor = [UIColor clearColor];
    myscrollview.contentSize = CGSizeMake(WIDTH*3, self.view.frame.size.height);
    [self.view addSubview:myscrollview];
    
    CGFloat y = 600-64-100-20;
    if (!IS_iPhone5) {
        y = 600-64-100-10-80;
    }
    pagecontrol = [[UIPageControl alloc] initWithFrame:CGRectMake(108, y, 100, 50)];
    pagecontrol.backgroundColor = [UIColor clearColor];
    pagecontrol.hidesForSinglePage = YES;
    pagecontrol.userInteractionEnabled = NO;
    pagecontrol.numberOfPages = 0;     //几个小点
    [self.view addSubview:pagecontrol];
    [self.view insertSubview:myscrollview atIndex:0];
    
    //将图像添加到scrollview中
    UIImageView *imageview1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageview1 setImage:[UIImage imageNamed:@"引导页1.jpg"]];
    UIImageView *imageview2=[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageview2 setImage:[UIImage imageNamed:@"引导页2.jpg"]];
    UIImageView *imageview3=[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH*2, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageview3 setImage:[UIImage imageNamed:@"引导页3.jpg"]];
//    UIImageView *imageview4=[[UIImageView alloc]initWithFrame:CGRectMake(640+320, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [imageview4 setImage:[UIImage imageNamed:@"boot_4.jpg"]];
    [myscrollview addSubview:imageview1];
    [myscrollview addSubview:imageview2];
    [myscrollview addSubview:imageview3];
//    [myscrollview addSubview:imageview4];
    
    imageview3.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(push)];
    [imageview3 addGestureRecognizer:tap];
    //    UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _button.backgroundColor = [UIColor clearColor];
    //    [_button setBackgroundImage:[UIImage imageNamed:@"intro-btn.png"] forState:UIControlStateNormal];
    //    [_button addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    //    _button.frame = FRAME(50, self.view.frame.size.height-60, 223, 74/2);
    //    [imageview4 addSubview:_button];
    // Dispose of any resources that can be recreate
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;   //当前是第几个视图
    NSLog(@"index：%d",index);
    pagecontrol.currentPage = index;
}
-(void)push
{
    NSUserDefaults *_userdefaults = [NSUserDefaults standardUserDefaults];
    [_userdefaults setObject:@"FIRSTRELOAD" forKey:@"GUIDE"];
    [_userdefaults synchronize];

    AppDelegate *_mydelegate = [UIApplication sharedApplication].delegate;
    _mydelegate.pushID=1;
    [_mydelegate ChoseRootController];
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
