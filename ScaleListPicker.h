//
//  ScaleListPicker.h
//  yxz
//
//  Created by 白玉林 on 16/7/6.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ScaleListPickerDelegate <NSObject>

- (void)closePicker;

- (void)loopHours:(NSString *)hours ;//minutes:(NSString *)minutes;

@end
@interface ScaleListPicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    __weak id<ScaleListPickerDelegate>_delegate;
    
    UIPickerView *pickerView;
    NSArray *hoursArray;
    NSMutableArray *MinutesArray;
}
@property (nonatomic, assign)NSInteger txRow;
@property (nonatomic, weak)  id<ScaleListPickerDelegate>delegate;
@property (nonatomic, strong)NSString *timeString;


@end
