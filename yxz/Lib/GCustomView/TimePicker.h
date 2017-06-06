//
//  TimePicker.h
//  simi
//
//  Created by zrj on 14-11-27.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol timePickerDelegate <NSObject>

- (void)suanle;

- (void)hours:(NSString *)hours ;//minutes:(NSString *)minutes;

@end

@interface TimePicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    __weak id<timePickerDelegate>_delegate;
    
    UIPickerView *pickerView;
    NSArray *hoursArray;
    NSMutableArray *MinutesArray;

}
@property (nonatomic, assign)NSInteger txRow;
@property (nonatomic, weak)  id<timePickerDelegate>delegate;

@end
