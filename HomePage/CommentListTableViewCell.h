//
//  CommentListTableViewCell.h
//  yxz
//
//  Created by 白玉林 on 16/5/19.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentListTableViewCell : UITableViewCell

@property(nonatomic ,strong)UILabel *nameLabel;
@property(nonatomic ,strong)UILabel *timeLabel;
@property(nonatomic ,strong)UILabel *texLabel;
@property(nonatomic ,strong)UIImageView *headImageView;
@property(nonatomic ,assign)int gaodu;
@property(nonatomic ,assign)int cellTag;
@end
