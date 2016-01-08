//
//  MingxiTableViewCell.h
//  simi
//
//  Created by 赵中杰 on 14/12/11.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JIFENData.h"

@interface MingxiTableViewCell : UITableViewCell
{
    JIFENData *_mydata;
}

@property (nonatomic, strong) JIFENData *mydata;

@end
