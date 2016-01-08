//
//  DetailsTableViewCell.h
//  simi
//
//  Created by 白玉林 on 15/9/10.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsTableViewCell : UITableViewCell
@property(nonatomic ,strong)UIView *cellView;
@property(nonatomic ,strong)UILabel *nameLabel;
@property(nonatomic ,strong)UILabel *timeLabel;
@property(nonatomic ,strong)UILabel *contentLabel;
@property(nonatomic ,strong)NSDictionary *dic;
@end
