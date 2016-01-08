//
//  CalendarViewController.h
//  simi
//
//  Created by zrj on 14-12-14.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface CalendarViewController : FatherViewController<UIPickerViewDelegate,UIPickerViewDataSource>
{
    
}
@property(nonatomic, retain) UIPickerView  *pickerView;
@property(retain, nonatomic) UIView *titleView;
@end
