//
//  OrderDetailViewController.h
//  simi
//
//  Created by 赵中杰 on 14/12/5.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import "ORDERLISTData.h"
#import "Header.h"
@interface OrderDetailViewController : FatherViewController
{
    NSString *_ordernumber;
}

@property (nonatomic, strong)ORDERLISTData *listdata;


@end
