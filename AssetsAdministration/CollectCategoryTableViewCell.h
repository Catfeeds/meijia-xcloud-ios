//
//  CollectCategoryTableViewCell.h
//  yxz
//
//  Created by 白玉林 on 16/4/1.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectCategoryTableViewCell : UITableViewCell
@property(nonatomic ,assign)int numbar;
@property(nonatomic ,strong)UILabel *numLabel;
@property(nonatomic ,strong)UIButton *addBut;
@property(nonatomic ,strong)UILabel *shuLabel;
@property(nonatomic ,strong)UIButton *reduceBut;
@property(nonatomic ,strong)UILabel *nameLabel;
@property(nonatomic ,strong)NSArray *arrayss;
//-(void)addBut:(UIButton *)button;
//-(void)_reduceBut:(UIButton *)button;
@end
