//
//  DisplayStarView.h
//  yxz
//
//  Created by 白玉林 on 16/6/16.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface DisplayStarView : UIView
{
    CGFloat _starSize;        /* 根据字体大小来确定星星的大小 */
    NSInteger _maxStar;      /* 总共的长度 */
    NSInteger _showStar;    //需要显示的星星的长度
    UIColor *_emptyColor;   //未点亮时候的颜色
    UIColor *_fullColor;    //点亮的星星的颜色
}
@property (nonatomic, assign) CGFloat starSize;
@property (nonatomic, assign) NSInteger maxStar;
@property (nonatomic, assign) NSInteger showStar;
@property (nonatomic, retain) UIColor *emptyColor;
@property (nonatomic, retain) UIColor *fullColor;
@end
