//
//  PickerView.h
//  simi
//
//  Created by zrj on 14-11-3.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol picDelegate <NSObject>

- (void)quxiao;

- (void)queding:(NSString *)date hours:(NSString *)hours minutes:(NSString *)minutes;

@end

@interface PickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
{
    __weak id<picDelegate>_delegate;
    
    UIPickerView *pickerView;
    NSMutableArray *hoursArray;
    NSMutableArray *MinutesArray;
    NSString *today;
    NSMutableArray *dateArray;
    NSString *mingtian;
}

@property (nonatomic, weak) id<picDelegate>HidDelegate;

@end
