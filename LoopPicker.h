//
//  LoopPicker.h
//  yxz
//
//  Created by 白玉林 on 16/6/15.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoopPickerDelegate <NSObject>

- (void)closePicker;

- (void)loopHours:(NSString *)hours ;//minutes:(NSString *)minutes;

@end

@interface LoopPicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    __weak id<LoopPickerDelegate>_delegate;
    
    UIPickerView *pickerView;
    NSMutableArray *hoursArray;
    NSMutableArray *MinutesArray;
    NSString *_timeString;
}
@property (nonatomic, assign)NSInteger txRow;
@property (nonatomic, weak)  id<LoopPickerDelegate>delegate;
@property (nonatomic, strong)NSString *timeString;

@end
