//
//  DynamicImageViewController.m
//  yxz
//
//  Created by 白玉林 on 15/12/29.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "DynamicImageViewController.h"

@interface DynamicImageViewController ()
{
    UIImageView *labelView;
    int imgID,S,butID;
    UIView *scrollImView;
}
@end

@implementation DynamicImageViewController

- (void)viewDidLoad {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [super viewDidLoad];
    butID=0;
    self.view.backgroundColor=[UIColor blackColor];
    scrollImView=[[UIView alloc]initWithFrame:FRAME(0, 20, WIDTH, 40)];
    // scrollImView.hidden=YES;
    [self.view addSubview:scrollImView];
    
    UIButton *fhBut=[[UIButton alloc]initWithFrame:FRAME(10, 5, 50, 30)];
//    fhBut.backgroundColor=[UIColor redColor];
    [fhBut addTarget:self action:@selector(fhAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollImView addSubview:fhBut];
    UIImageView *fhImageView=[[UIImageView alloc]initWithFrame:FRAME(8, 5, 20, 20)];
    fhImageView.image=[UIImage imageNamed:@"title_left_back_white_black"];
    [fhBut addSubview:fhImageView];
    
    _scrollview=[[UIScrollView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    _scrollview.contentSize=CGSizeMake(WIDTH*_imageArray.count, HEIGHT-64);
    _scrollview.pagingEnabled=YES;
    _scrollview.delegate=self;
    _scrollview.showsVerticalScrollIndicator = FALSE;
    _scrollview.showsHorizontalScrollIndicator = FALSE;
    _scrollview.contentOffset=CGPointMake(WIDTH*_TG, 0);
    _scrollview.tag = 200;
    [self.view addSubview:_scrollview];
    
    for (int i=0; i<_imageArray.count; i++) {
        UIButton *imageButton=[[UIButton alloc]initWithFrame:FRAME(i*WIDTH,0, WIDTH, _scrollview.frame.size.height)];
        [imageButton addTarget:self action:@selector(imgAction:) forControlEvents:UIControlEventTouchUpInside];
        imageButton.tag=i;
        [_scrollview addSubview:imageButton];
        UIImageView *imageView=[[UIImageView alloc]init];
        imageView.frame=CGRectMake(0,0, WIDTH, imageButton.frame.size.height);
        imageView.contentMode = UIViewContentModeRedraw;
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[_imageArray[i] objectForKey:@"img_url"]];
        [imageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
        [imageButton addSubview:imageView];
        
    }
    if (_imageArray.count==1||imgID==0) {
        [self label];
    }
}
#pragma mark 大图返回按钮点击方法
-(void)fhAction:(id)sender
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:1];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController popViewControllerAnimated:YES];
    [UIView commitAnimations];
    
}
#pragma mark 大图点击方法
-(void)imgAction:(UIButton *)sender
{
    NSLog(@"sender%@",sender);
      if (butID%2==0) {
        [UIView beginAnimations: @"Animation" context:nil];
        [UIView setAnimationDuration:1];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        scrollImView.frame=FRAME(0, -40, WIDTH, 40);
        _scrollview.frame=FRAME(0, 10, WIDTH, HEIGHT-20);
        [UIView commitAnimations];
    }else{
        [UIView beginAnimations: @"Animation" context:nil];
        [UIView setAnimationDuration:1];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        scrollImView.frame=FRAME(0, 20, WIDTH, 40);
        _scrollview.frame=FRAME(0, 64, WIDTH, HEIGHT-64);
        [UIView commitAnimations];
        
    }
    butID++;
    
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    S=1;
}
- (void) scrollViewDidScroll:(UIScrollView *)sender {
    //[scrollView removeFromSuperview];
    // 得到每页宽度
    CGFloat pageWidth = sender.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    imgID= floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self label];
}
#pragma mark 当前页数显示方法
-(void)label
{
    [labelView removeFromSuperview];
    labelView=[[UIImageView alloc]initWithFrame:CGRectMake((WIDTH-60)/2, 7.5, 60, 25)];
    labelView.image=[UIImage imageNamed:@"CKDT-YM@2px"];
    [scrollImView addSubview:labelView];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, labelView.frame.size.height/2-10, 60 , 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    [labelView addSubview:label];
    
    if (S==0) {
        int ID=_TG+1;
        NSString *string=[NSString stringWithFormat:@"%d/",ID];
        NSString *string1=[NSString stringWithFormat:@"%@ %ld",string,(unsigned long)_imageArray.count];
        label.text=string1;
    }else
    {
        int ID;
        if (_imageArray.count==1) {
            ID=_TG+1;
        }else {
            ID=imgID+1;
        }
        
        NSString *string=[NSString stringWithFormat:@"%d/",ID];
        NSString *string1=[NSString stringWithFormat:@"%@%ld",string,(unsigned long)_imageArray.count];
        label.text=string1;
    }
    //    remID=imgID;
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
