//
//  PageTableViewCell.h
//  simi
//
//  Created by 白玉林 on 15/7/30.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageTableViewCell : UITableViewCell
@property(nonatomic ,strong)UIImageView *heideImage;
@property(nonatomic ,strong)UILabel *titleLabel;
@property(nonatomic ,strong)UILabel *timeLabel;
@property(nonatomic ,strong)UILabel *praiseLabel;
@property(nonatomic ,strong)UILabel *commentLabel;

@property(nonatomic ,strong) UIView *view;
@property(nonatomic ,strong)UILabel *promptlabel;
@property(nonatomic ,strong)UILabel *inTimeLabel;
@property(nonatomic ,strong)UILabel *addressLabel;
@property(nonatomic ,strong)UILabel *costLabel;
@property(nonatomic ,strong)UILabel *contentLabel;
@property(nonatomic ,strong)UIImageView *descriptionView;

@property(nonatomic ,strong)UIButton *zaButton;
@property(nonatomic ,strong)UIButton *plButton;
@property(nonatomic ,strong)UIButton *fxButton;

@property(nonatomic ,strong)UILabel *sjLabel;
@property(nonatomic ,strong)UILabel *moneyLabel;
@property(nonatomic ,strong)UILabel *address;
//-(void)setImageVIew:(UIImage *)image  setLabel:(NSString *)tiTleLabel label:(NSString *)tiMeLabel promptLabel:(NSString *)promPtLabel;
@end
