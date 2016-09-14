//
//  VideoArticleToolBar.m
//  yxz
//
//  Created by xiaotao on 16/9/13.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "VideoArticleToolBar.h"

@interface VideoArticleToolBar ()
{
    UIImageView *plImageView;
    UIImageView *clickImageView;
    UIImageView *fxImageView;
}
@end

@implementation VideoArticleToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews
{
    UIButton *fieldView=[[UIButton alloc]initWithFrame:FRAME(31/2, 9, WIDTH-340/2, 32)];
    fieldView.backgroundColor=[UIColor whiteColor];
    fieldView.layer.borderWidth = 1;
    fieldView.layer.borderColor = [[UIColor colorWithRed:203/255.0f green:203/255.0f blue:203/255.0f alpha:1] CGColor];
    fieldView.layer.cornerRadius=32/2;
    fieldView.clipsToBounds=YES;
    [fieldView addTarget:self action:@selector(fieldBut) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:fieldView];
    
    UILabel *plTextField=[[UILabel alloc]initWithFrame:FRAME(14, 0, fieldView.frame.size.width-28, 32)];
    plTextField.text=@"写评论...";
    plTextField.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    [fieldView addSubview:plTextField];
    NSArray *imageArray=@[@"评论 (1)",@"赞-点击前",@"分享"];
    for (int  i=0; i<3; i++) {
        UIButton *button=[[UIButton alloc]initWithFrame:FRAME(WIDTH-309/2+i*(309/2/3), 0, 309/2/3, 50)];
        [self addSubview:button];
        button.tag=i;
        [button addTarget:self action:@selector(ButAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            plImageView=[[UIImageView alloc]initWithFrame:FRAME((button.frame.size.width-22)/2, 28/2, 22, 22)];
            plImageView.tag=10+i;
            plImageView.image=[UIImage imageNamed:imageArray[i]];
            [button addSubview:plImageView];
        }else if (i==1){
            clickImageView=[[UIImageView alloc]initWithFrame:FRAME((button.frame.size.width-22)/2, 28/2, 22, 22)];
            clickImageView.tag=10+i;
            clickImageView.image=[UIImage imageNamed:imageArray[i]];
            [button addSubview:clickImageView];
        }else{
            fxImageView=[[UIImageView alloc]initWithFrame:FRAME((button.frame.size.width-22)/2, 28/2, 22, 22)];
            fxImageView.tag=10+i;
            fxImageView.image=[UIImage imageNamed:imageArray[i]];
            [button addSubview:fxImageView];
        }
    }
}

- (void)fieldBut
{
    _block();
}


@end
