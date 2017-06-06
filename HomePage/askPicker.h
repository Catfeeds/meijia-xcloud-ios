//
//  askPicker.h
//  yxz
//
//  Created by 白玉林 on 16/6/4.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol askPickerDelegate <NSObject>

- (void)suanle;

- (void)hours:(NSString *)hours ;//minutes:(NSString *)minutes;

@end
@interface askPicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    __weak id<askPickerDelegate>_delegate;
    
    UIPickerView *pickerView;
    NSArray *hoursArray;
    NSMutableArray *MinutesArray;
    
}
@property (nonatomic, assign)NSInteger txRow;
@property (nonatomic, weak)  id<askPickerDelegate>delegate;

@end
