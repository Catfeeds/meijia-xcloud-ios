//
//  BeiZhuViewController.h
//  simi
//
//  Created by zrj on 14-11-4.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@protocol BeiZhuDelegate <NSObject>

- (void)BeiZhuDelegateLable:(NSString *)textViewtext;

@end
@interface BeiZhuViewController : FatherViewController<UITextViewDelegate>
{
    __weak id<BeiZhuDelegate>_delegate;

        UITextView *text;
}
@property (nonatomic, weak) __weak id<BeiZhuDelegate>delegate;

@property (nonatomic, strong) NSString *beizhu;

@end
