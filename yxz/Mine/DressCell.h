//
//  DressCell.h
//  simi
//
//  Created by zrj on 14-11-7.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUSTOMDRESSDatamodel.h"

@interface DressCell : UITableViewCell
{
    CUSTOMDRESSData *_mydata;
}

@property (nonatomic, strong)CUSTOMDRESSData *mydata;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UIButton *btn;
@end
