//
//  RemindView.h
//  simi
//
//  Created by zrj on 14-11-3.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CallDelegate <NSObject>

- (void)CallAction;

@end

@interface RemindView : UIView<UIScrollViewDelegate>
{
    
    __weak id<CallDelegate>_delegate;
    
    UIScrollView *_myscrollview;
    UITextView *textview;
    NSTimer *textTimer;
    BOOL top ;
}

- (id)initWithFrame:(CGRect)frame labletext:(NSString *)str;

@property (nonatomic, weak) id<CallDelegate>delegate;

@end
