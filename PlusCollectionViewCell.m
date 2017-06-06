//
//  PlusCollectionViewCell.m
//  yxz
//
//  Created by 白玉林 on 16/1/30.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "PlusCollectionViewCell.h"

@implementation PlusCollectionViewCell
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.lconImageView=[[UIImageView alloc]initWithFrame:FRAME(0 , 0, WIDTH/4, 95)];
        [self addSubview:self.lconImageView];
        self.nameLabel=[[UILabel alloc]initWithFrame:FRAME(5, CGRectGetMinY(self.lconImageView.frame)+70, CGRectGetWidth(self.frame)-10, 15)];
        [self addSubview:self.nameLabel];
    }
    return self;
}

@end
