//
//  DisplayStarView.m
//  yxz
//
//  Created by 白玉林 on 16/6/16.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "DisplayStarView.h"

@implementation DisplayStarView
@synthesize starSize = _starSize;
@synthesize maxStar = _maxStar;
@synthesize showStar = _showStar;
@synthesize emptyColor = _emptyColor;
@synthesize fullColor = _fullColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        //默认的星星的大小是 13.0f
        self.starSize = 15.0f;
        //未点亮时的颜色是 灰色的
        self.emptyColor = [UIColor colorWithRed:167.0f / 255.0f green:167.0f / 255.0f blue:167.0f / 255.0f alpha:1.0f];
        //点亮时的颜色是 亮黄色的
        self.fullColor = [UIColor colorWithRed:255.0f / 255.0f green:121.0f / 255.0f blue:22.0f / 255.0f alpha:1.0f];
        //默认的长度设置为100
        self.maxStar = 100;
    }
    
    return self;
}

//重绘视图
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSString* stars = @"★★★★★";
    UIColor *videoTitleColor = [UIColor colorWithRed:167.0f / 255.0f green:167.0f / 255.0f blue:167.0f / 255.0f alpha:1.0f];
    rect = self.bounds;
    UIFont *font = [UIFont boldSystemFontOfSize:_starSize];
    NSDictionary *attributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:videoTitleColor};
    CGSize starSize = [stars sizeWithAttributes:attributes];
    rect.size=starSize;
    [_emptyColor set];
//    [stars drawInRect:rect withFont:font];
    [stars drawInRect:rect withAttributes:attributes];
    CGRect clip = rect;
    clip.size.width = clip.size.width * _showStar / _maxStar;
    CGContextClipToRect(context,clip);
    [_fullColor set];
    UIColor *videoColor=[UIColor colorWithRed:255.0f / 255.0f green:121.0f / 255.0f blue:22.0f / 255.0f alpha:1.0f];
    NSDictionary *attr = @{NSFontAttributeName:font,NSForegroundColorAttributeName:videoColor};
    [stars drawInRect:rect withAttributes:attr];
}
@end
