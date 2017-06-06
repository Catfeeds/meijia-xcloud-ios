//
//  addressViewController.h
//  simi
//
//  Created by zrj on 14-11-12.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@protocol DressDelegate <NSObject>

- (void)xiaoqu:(NSString *)xiaoqu menpai:(NSString *)menpaihao dressId:(NSString *)C_id;

@end
@interface addressViewController : FatherViewController
{
    __weak id<DressDelegate>_delegate;
}

@property (nonatomic, weak) __weak id<DressDelegate>delegate;

@end
