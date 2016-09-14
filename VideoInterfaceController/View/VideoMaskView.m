//
//  VideoMaskView.m
//  yxz
//
//  Created by xiaotao on 16/9/14.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "VideoMaskView.h"

@interface VideoMaskView () 

@end

@implementation VideoMaskView

- (id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor=[UIColor colorWithRed:243/255.0f green:246/255.0f blue:246/255.0f alpha:1];
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews
{
    UITextView *myTextView=[[UITextView alloc]initWithFrame:FRAME(9, 9, WIDTH-18, 90)];
    myTextView.backgroundColor=[UIColor whiteColor];
    myTextView.layer.cornerRadius=8;
    myTextView.clipsToBounds=YES;
    myTextView.delegate=self;
    [self addSubview:myTextView];
    
    UILabel *viewLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, 200, 20)];
    viewLabel.enabled = NO;
    viewLabel.text = @"写下您的看法与见解...";
    viewLabel.font =  [UIFont systemFontOfSize:15];
    viewLabel.textColor = [UIColor lightGrayColor];
    [myTextView addSubview:viewLabel];
    
    UIButton *publishButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-57, 108, 48, 28)];
    publishButton.backgroundColor=[UIColor colorWithRed:202/255.0f green:202/255.0f blue:202/255.0f alpha:1];
    [publishButton setTitle:@"发布" forState:UIControlStateNormal];
    publishButton.enabled=FALSE;
    [publishButton addTarget:self action:@selector(publishBut) forControlEvents:UIControlEventTouchUpInside];
    publishButton.layer.cornerRadius=5;
    publishButton.clipsToBounds=YES;
    [self addSubview:publishButton];

}
@end
