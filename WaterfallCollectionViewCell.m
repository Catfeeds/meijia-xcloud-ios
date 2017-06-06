//
//  WaterfallCollectionViewCell.m
//  yxz
//
//  Created by 白玉林 on 15/12/4.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "WaterfallCollectionViewCell.h"

@implementation WaterfallCollectionViewCell
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.lconImageView=[[UIImageView alloc]initWithFrame:FRAME(0 , 0, WIDTH/4, WIDTH/4)];
        [self addSubview:self.lconImageView];
        self.nameLabel=[[UILabel alloc]initWithFrame:FRAME(5, CGRectGetMinY(self.lconImageView.frame)+55, CGRectGetWidth(self.frame)-10, 15)];
        [self addSubview:self.nameLabel];
    }
    return self;
}
@end
