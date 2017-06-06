//
//  Workplace_askTableViewCell.h
//  yxz
//
//  Created by 白玉林 on 16/6/3.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Workplace_askTableViewCell : UITableViewCell
{
    NSString *_moneyImagStr;
    NSString *_goldLabelStr;
    NSString *_titleLabelStr;
    NSString *_timelabelStr;
    NSString *_headeImageStr;
    NSString *_namelabelStr;
    NSString *_textLabelsStr;
}
@property (nonatomic ,strong)NSString *moneyImagStr;
@property (nonatomic ,strong)NSString *goldLabelStr;
@property (nonatomic ,strong)NSString *titleLabelStr;
@property (nonatomic ,strong)NSString *timelabelStr;
@property (nonatomic ,strong)NSString *headeImageStr;
@property (nonatomic ,strong)NSString *namelabelStr;
@property (nonatomic ,strong)NSString *textLabelsStr;
@property (nonatomic ,strong)UIButton *askButton;

@property (nonatomic ,strong)UIImageView *moneyImag;
@property (nonatomic ,strong)UILabel *goldLabel;
@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)UILabel *timelabel;
@property (nonatomic ,strong)UIImageView *headeImage;
@property (nonatomic ,strong)UILabel *namelabel;
@property (nonatomic ,strong)UILabel *textLabels;
@end
