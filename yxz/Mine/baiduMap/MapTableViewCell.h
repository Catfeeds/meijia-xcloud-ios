//
//  MapTableViewCell.h
//  simi
//
//  Created by 高鸿鹏 on 15-5-12.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAddressMapModel.h"

@interface MapTableViewCell : UITableViewCell
{
    UserAddressMapModel *_model;
}

@property (nonatomic,strong) UserAddressMapModel *mymodel;

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *addressLab;


@end
