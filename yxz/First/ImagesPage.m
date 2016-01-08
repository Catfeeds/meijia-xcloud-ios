//
//  ImagesPage.m
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "ImagesPage.h"
#import "AppCommon.h"
#import "UIImageView+WebCache.h"
#import "SERVICEBannerAd.h"
@implementation ImagesPage
@synthesize delegate = _delegate;
#define YSPACE 64
#define WIDTHs  self.bounds.size.width
#define HEIGHTs 244/2

- (id)initWithFrame:(CGRect)frame imgArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        pageIndex = -1;//记录中间图片的下标,开始总是为1
        
        myScrollView =[[UIScrollView alloc]initWithFrame:FRAME(0, 0, self.bounds.size.width, HEIGHTs)];
        myScrollView.contentSize = CGSizeMake(self.bounds.size.width*array.count, HEIGHTs);
        myScrollView.showsVerticalScrollIndicator = NO;
        myScrollView.delegate = self;
        myScrollView.pagingEnabled = YES;
        myScrollView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:myScrollView];
        
        myPage = [[UIPageControl alloc]initWithFrame:FRAME(210, 90, 100, 50)];
        myPage.backgroundColor = DEFAULT_COLOR;
        myPage.hidesForSinglePage = YES;
        myPage.userInteractionEnabled = NO;
        myPage.numberOfPages = array.count;
        [self addSubview:myPage];
        
        modelArray = [[NSArray alloc]init];
        
        modelArray = array;
        
        NSLog(@"imgurl++++++++ = %@",array);

        for (int i = 0; i < array.count; i++) {
        
            SERVICEBannerAd *_admodel = [array objectAtIndex:i];
            
            UIImageView *imageview = [[UIImageView alloc]initWithFrame:FRAME(i*WIDTHs, 0, WIDTHs, HEIGHTs)];
            
            imageview.userInteractionEnabled = YES;
            
            [imageview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_admodel.imgUrl]]];
            
            imageview.tag = i+100;
            
            [myScrollView addSubview:imageview];
            
             NSLog(@"%@",_admodel.imgUrl);
            

            UIButton *btn = [[UIButton alloc]initWithFrame:FRAME(i*WIDTHs, 0, WIDTHs, HEIGHTs)];
            
            btn.userInteractionEnabled = YES;
            
            //            [btn setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_admodel.imgUrl]]];
            
            btn.tag = i+100;
            
            [btn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
            
            [myScrollView addSubview:btn];
            
            
            [self timeAdd];
        }
        
    }
    return self;
}

-(void)timeAdd{
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
}

- (void)timeAction{
    BOOL zou = YES;
    int index;
    
    if (zou == YES) {
        index = fabs(myScrollView.contentOffset.x) / myScrollView.frame.size.width;
    }
    
    if (index == 0) {
        [myScrollView setContentOffset:CGPointMake(WIDTHs*1, 0) animated:YES];
        myPage.currentPage = 1;
        zou = NO;
        return;
    }
    if (index == 1) {
        [myScrollView setContentOffset:CGPointMake(WIDTHs*2, 0) animated:YES];
        myPage.currentPage = 2;
        zou = NO;
        return;
    }
    if (index ==2) {
        [myScrollView setContentOffset:CGPointMake(WIDTHs*0, 0) animated:YES];
        myPage.currentPage = 0;
        index = 0;
        zou = NO;
        return;
    }
}

//滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   
    int index = fabs(myScrollView.contentOffset.x) / myScrollView.frame.size.width;   //当前是第几个视图
        NSLog(@"index：%d",index);
        myPage.currentPage = index;

//    if (myScrollView.contentOffset.x > WIDTH*2) {
//        [myScrollView setContentOffset:CGPointMake(WIDTH*0, 0) animated:YES];
//        myPage.currentPage = 0;
//    }
    
}
- (void)btnTouch:(UIButton *)butn
{
    if (butn.tag == 100) {
        NSLog(@"1");
        SERVICEBannerAd *_admodel = [modelArray objectAtIndex:0];
        [self.delegate imgdelegate:butn imgUrl:_admodel.gotoUrl];
    }
    if (butn.tag == 101) {
        NSLog(@"2");
        SERVICEBannerAd *_admodel = [modelArray objectAtIndex:1];
        [self.delegate imgdelegate:butn imgUrl:_admodel.gotoUrl];
    }
    if (butn.tag == 102) {
        NSLog(@"3");
        SERVICEBannerAd *_admodel = [modelArray objectAtIndex:2];
        [self.delegate imgdelegate:butn imgUrl:_admodel.gotoUrl];
    }
    
}
@end
