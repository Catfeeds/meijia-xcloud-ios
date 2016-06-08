//
//  RemindSetUpPicker.h
//  yxz
//
//  Created by 白玉林 on 16/5/30.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RemindSetUpPickerDelegate <NSObject>

- (void)suanle;

- (void)hours:(NSString *)hours ;//minutes:(NSString *)minutes;

@end
@interface RemindSetUpPicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    __weak id<RemindSetUpPickerDelegate>_delegate;
    
    UIPickerView *pickerView;
    NSArray *hoursArray;
    NSMutableArray *MinutesArray;
    
}
@property (nonatomic, assign)NSInteger txRow;
@property (nonatomic, weak)  id<RemindSetUpPickerDelegate>delegate;
@end
