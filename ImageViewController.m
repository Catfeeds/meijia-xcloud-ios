//
//  ImageViewController.m
//  yxz
//
//  Created by 白玉林 on 15/11/12.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "ImageViewController.h"
#import "DownloadManager.h"
@interface ImageViewController ()
{
    UIScrollView *scrollView;
    int S,imgID,butID;
    UIView *scrollImView;
    UIImageView *labelView;
    UIActivityIndicatorView *tpView;
}
@end

@implementation ImageViewController
-(void)viewWillAppear:(BOOL)animated{
    tpView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    tpView.center=CGPointMake(WIDTH/2,HEIGHT/2);
    [self.view addSubview:tpView];
    [tpView startAnimating];
}
-(void)viewDidAppear:(BOOL)animated
{
    [tpView stopAnimating]; // 结束旋转
    [tpView setHidesWhenStopped:YES]; //当旋转结束时隐藏
}
- (void)viewDidLoad {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [super viewDidLoad];
    super.navigationController.navigationBarHidden=YES;
    super.view.backgroundColor=[UIColor blackColor];
    super.backlable.hidden=YES;
    super.lineLable.hidden=YES;
    super.navlabel.hidden=YES;
    super.backBtn.hidden=YES;
    
    scrollImView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 64)];
    scrollImView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:scrollImView];
    //    UIButton *fhBut=[[UIButton alloc]initWithFrame:FRAME(10, 5, 50, 30)];
    //    fhBut.backgroundColor=[UIColor redColor];
    //    [fhBut addTarget:self action:@selector(fhAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [scrollImView addSubview:fhBut];
    
    //    UIButton *remBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH-40, 5, 30, 30)];
    //    remBut.backgroundColor=[UIColor redColor];
    //    [remBut addTarget:self action:@selector(remAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [scrollImView addSubview:remBut];
    
    
    
    DownloadManager *imageDownload = [[DownloadManager alloc]init];
    NSDictionary *dic=@{@"user_id":_sec_ID};
    [imageDownload requestWithUrl:USER_YHTP dict:dic view:self.view delegate:self finishedSEL:@selector(imageDown:) isPost:NO failedSEL:@selector(imageFailDown:)];
    // Do any additional setup after loading the view.
}

#pragma mark 获取图片成功接口返回方法
-(void)imageDown:(id)sender
{
    NSLog(@"图片数据%@",sender);
    _iamgeArray=[sender objectForKey:@"data"];
    [self scrollViewLayout];
    [self label];
}
#pragma mark 获取图片失败接口返回方法
-(void)imageFailDown:(id)sender
{
    
}

-(void)scrollViewLayout
{
    [scrollView removeFromSuperview];
    scrollView=[[UIScrollView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    scrollView.contentSize=CGSizeMake(WIDTH*_iamgeArray.count, HEIGHT-64);
    scrollView.pagingEnabled=YES;
    //    scrollView.showsHorizontalScrollIndicator=NO;
    //    scrollView.showsVerticalScrollIndicator=NO;
    //    scrollView.bounces=NO;
    scrollView.delegate=self;
    scrollView.contentOffset=CGPointMake(WIDTH*_offSet, 0);
    scrollView.tag = 200;
    [self.view addSubview:scrollView];
    
    for (int i=0; i<_iamgeArray.count; i++) {
        NSDictionary *dict=_iamgeArray[i];
        UIButton *imageButton=[[UIButton alloc]initWithFrame:FRAME(i*WIDTH,0, WIDTH, HEIGHT-64)];
        [imageButton addTarget:self action:@selector(imgAction:) forControlEvents:UIControlEventTouchUpInside];
        imageButton.tag=i;
        UIImageView *imageView=[[UIImageView alloc]init];
        imageView.frame=CGRectMake(0,0, WIDTH, HEIGHT-60);
        
        imageView.contentMode = UIViewContentModeRedraw;
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[dict objectForKey:@"img_url"]];
        [imageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];

//        imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"img_url"]]]];
        [imageButton addSubview:imageView];
        [scrollView addSubview:imageButton];
    }
    
    if (_iamgeArray.count==1||imgID==0) {
        [self label];
    }
    
    
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
    labelView=[[UIImageView alloc]initWithFrame:CGRectMake((WIDTH-60)/2, 27.5, 60, 25)];
    labelView.image=[UIImage imageNamed:@"CKDT-YM@2px"];
    [scrollImView addSubview:labelView];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, labelView.frame.size.height/2-10, 60 , 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    [labelView addSubview:label];
    
    if (S==0) {
        int ID=_offSet+1;
        NSString *string=[NSString stringWithFormat:@"%d/",ID];
        NSString *string1=[NSString stringWithFormat:@"%@ %ld",string,(unsigned long)_iamgeArray.count];
        label.text=string1;
    }else
    {
        int ID;
        if (_iamgeArray.count==1) {
            ID=_offSet+1;
        }else {
            ID=imgID+1;
        }
        
        NSString *string=[NSString stringWithFormat:@"%d/",ID];
        NSString *string1=[NSString stringWithFormat:@"%@%ld",string,(unsigned long)_iamgeArray.count];
        label.text=string1;
    }
}

#pragma mark 大图点击方法
-(void)imgAction:(UIButton *)sender
{
    NSLog(@"sender%@",sender);
    [self backAction];
    
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 大图返回按钮点击方法
-(void)fhAction:(id)sender
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:1];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [UIView commitAnimations];
    
}

#pragma mark 删除按钮点击当法
-(void)remAction:(UIButton *)sender
{
    //    for (UIImageView *view_ in scrollView.subviews) {
    //        if (view_.tag == remID-1) {
    //            [view_ removeFromSuperview];
    //        }
    //    }
    //    NSString *string=[NSString stringWithFormat:@"%lu",(unsigned long)imgArray.count];
    //    int str=[string intValue];
    //    int x=str-1;
    if (imgID==0) {
        _offSet=0;
    }
    if (_offSet!=0) {
        if (_iamgeArray.count!=1) {
            _offSet=_offSet-1;
        }
        
    }
    if (_iamgeArray.count==1) {
        [UIView beginAnimations: @"Animation" context:nil];
        [UIView setAnimationDuration:1];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        
        [UIView commitAnimations];
        
        
    }else{
        
        [self scrollViewLayout];
        
    }
    
    //scrollImView.hidden=YES;
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
