//
//  AddOrderDiscussViewController.h
//  simi
//
//  Created by 赵中杰 on 14/12/15.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface AddOrderDiscussViewController : FatherViewController
{

}

@property (nonatomic, strong) NSString *ordernumber;
@property (nonatomic, assign) NSInteger telephone;

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *ServiceType;
@end
