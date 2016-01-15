//
//  ImageView.m
//  yxz
//
//  Created by 白玉林 on 16/1/11.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "ImageView.h"

@implementation ImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    UIImageView*iamgeView=(UIImageView *)[self viewWithTag:100];
    iamgeView.image=[UIImage imageNamed:@"cal-bg.jpg"];
//    self.frame=FRAME(0, 0, WIDTH, 370);
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
