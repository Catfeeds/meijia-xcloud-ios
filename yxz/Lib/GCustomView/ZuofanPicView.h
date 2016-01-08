//
//  ZuofanPicView.h
//  simi
//
//  Created by zrj on 15-1-23.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol zuofanPic <NSObject>

- (void)quxiao;
- (void)queding:(NSString *)date hours:(NSString *)hours minutes:(NSString *)minutes;

@end
@interface ZuofanPicView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
{
    __weak id<zuofanPic>_delegate;
    
    UIPickerView *pickerView;
    NSMutableArray *hoursArray;
    NSMutableArray *MinutesArray;
    NSString *today;
    NSMutableArray *dateArray;
    NSString *mingtian;
    NSInteger xiaoshi;
}

- (id)initWithFrame:(CGRect)frame hours:(NSInteger )hours;

@property (nonatomic, weak)  id<zuofanPic> delegate;

@end
