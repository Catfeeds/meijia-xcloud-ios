//
//  DynamicTableViewCell.h
//  yxz
//
//  Created by 白玉林 on 15/12/26.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicTableViewCell : UITableViewCell
@property (nonatomic ,strong)UIImageView *headeImageView;
@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)UILabel *timeLabel;
@property (nonatomic ,strong)UILabel *textLabels;
@property (nonatomic ,strong)NSArray *imageArray;
@property (nonatomic ,strong)UIView *layoutView;
@end
