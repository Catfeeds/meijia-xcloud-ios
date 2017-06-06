//
//  XiYiCell.h
//  simi
//
//  Created by zrj on 14-11-5.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol cellDelegate <NSObject>

- (void)cellDelegate:(UIButton *)supsender;
- (void)cellDelegateTwo:(UIButton *)addsender;

@end

@interface XiYiCell : UITableViewCell
{
    __weak id <cellDelegate>_delegate;
}
@property (nonatomic, weak) __weak id <cellDelegate>delegate;

@property (nonatomic, retain) UILabel *titleLab;
@property (nonatomic, retain) UILabel *shichangLab;
@property (nonatomic, retain) UILabel *youhuiLab;
@property (nonatomic, retain) UILabel *shuziLab;
@property (nonatomic, retain) UIView *yellowLab;
@property (nonatomic, retain) UIImageView *img;
@property (nonatomic, retain) UIButton *zuoBtn;
@property (nonatomic, retain) UIButton *youBtn;
@property (nonatomic, retain) UIView *xiaxian;
@end
