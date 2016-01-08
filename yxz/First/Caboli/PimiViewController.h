//
//  PimiViewController.h
//  simi
//
//  Created by zrj on 14-11-17.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@protocol pingmiDelegate <NSObject>

- (void)pingmiDelegate:(NSString *)str;

@end

@interface PimiViewController : FatherViewController
{
    __weak id<pingmiDelegate>_delegate;
}

@property (nonatomic, weak) __weak id<pingmiDelegate>delegate;

@end
