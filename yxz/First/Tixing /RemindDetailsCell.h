//
//  RemindDetailsCell.h
//  simi
//
//  Created by zrj on 14-12-6.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RemindDetailsDelegate <NSObject>

- (void)editOrdelete:(NSInteger)btnTag;

@end

@interface RemindDetailsCell : UITableViewCell
{
    __weak id<RemindDetailsDelegate>_delegate;
}

@property (nonatomic, weak) id<RemindDetailsDelegate>delegate;

@property (nonatomic, retain) UIView *xiaxian;

@property (nonatomic, retain) UIImageView *oneImg;

@property (nonatomic, retain) UIImageView *twoImg;

@property (nonatomic, retain) UILabel *timeLab;

@property (nonatomic, retain) UILabel *dateLab;

@property (nonatomic, retain) UILabel *DetailsLab;

@property (nonatomic, retain) UIButton *editBtn;

@property (nonatomic, retain) UIButton *deleteBtn;

@end
