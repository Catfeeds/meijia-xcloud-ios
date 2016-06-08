//
//  ask_listDetailsTableViewCell.h
//  yxz
//
//  Created by 白玉林 on 16/6/4.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ask_listDetailsTableViewCell : UITableViewCell
{
    NSString *_headeImageStr;
    NSString *_nameStr;
    NSString *_timeStr;
    NSString *_titleStr;
    NSString *_zanImageStr;
    NSString *_zanStr;
}
@property (nonatomic ,strong)NSString *headeImageStr;
@property (nonatomic ,strong)NSString *nameStr;
@property (nonatomic ,strong)NSString *timeStr;
@property (nonatomic ,strong)NSString *titleStr;
@property (nonatomic ,strong)NSString *zanImageStr;
@property (nonatomic ,strong)UIImageView *headeImageView;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)UILabel *timeLabel;
@property (nonatomic ,strong)UIImageView *zanImageView;
@property (nonatomic ,strong)NSString *zanStr;
@property (nonatomic ,strong)UILabel *zanLabel;
@property (nonatomic ,strong)UIButton *zanBut;
@property (nonatomic ,strong)UIButton *adoptBut;
@property (nonatomic ,strong)UILabel *adoptLabel;
@end
