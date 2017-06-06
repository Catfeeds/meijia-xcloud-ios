//
//  JiaDianCell.h
//  simi
//
//  Created by zrj on 14-11-11.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JiadianDelegate <NSObject>

- (void)duigouBtnAction:(UIButton *)sender;
- (void)duigouHidden:(UIButton *)sender;
@end
@interface JiaDianCell : UITableViewCell
{
    __weak id<JiadianDelegate>_delegate;
}

@property (nonatomic, weak) __weak id<JiadianDelegate>delegate;
@property (nonatomic, retain) UILabel *titleLab;
@property (nonatomic, retain) UILabel *DetailLab;
@property (nonatomic, retain) UIButton *youBtn;
@property (nonatomic, retain) UIButton *youButn;
@property (nonatomic, retain) UIImageView *img;
@end
