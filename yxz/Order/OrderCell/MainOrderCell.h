//
//  MainOrderCell.h
//  simi
//
//  Created by 赵中杰 on 14/11/28.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewCell.h"
#import "ORDERLISTData.h"

@interface MainOrderCell : FatherViewCell
{
    ORDERLISTData *_datamodel;
    NSArray *_cityArray;
}

@property (nonatomic, strong) ORDERLISTData *datamodel;
@property (nonatomic, strong) NSArray *cityArray;

@end
