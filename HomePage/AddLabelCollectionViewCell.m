//
//  AddLabelCollectionViewCell.m
//  yxz
//
//  Created by 白玉林 on 16/5/27.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "AddLabelCollectionViewCell.h"

@implementation AddLabelCollectionViewCell
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.nameLabel=[[UILabel alloc]initWithFrame:FRAME(5, 10, CGRectGetWidth(self.frame)-10, 20)];
        [self addSubview:self.nameLabel];
    }
    return self;
}

@end
