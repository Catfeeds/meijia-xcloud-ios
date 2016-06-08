//
//  RemindSetUpPicker.m
//  yxz
//
//  Created by 白玉林 on 16/5/30.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "RemindSetUpPicker.h"
#import "ChoiceDefine.h"
@implementation RemindSetUpPicker
@synthesize delegate = _delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEX_TO_UICOLOR(BAC_VIEW_COLOR, 1.0);
        
        UIView *view = [[UIView alloc]initWithFrame:FRAME(0, 1, self_Width, 38)];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        
        UIButton *quxiao = [UIButton buttonWithType:UIButtonTypeCustom];
        quxiao.frame = FRAME(16, 10, 40, 20);
        quxiao.titleLabel.font = [UIFont systemFontOfSize:13];
        [quxiao setTitle:@"取消" forState:UIControlStateNormal];
        [quxiao setTitleColor:HEX_TO_UICOLOR(NAV_COLOR, 1.0) forState:UIControlStateNormal];
        [quxiao addTarget:self action:@selector(quxiaoAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:quxiao];
        
        UIButton *queding = [UIButton buttonWithType:UIButtonTypeCustom];
        queding.frame = FRAME(self_Width-16-25-14, 10, 40, 20);
        queding.titleLabel.font = [UIFont systemFontOfSize:13];
        [queding setTitle:@"确定" forState:UIControlStateNormal];
        [queding setTitleColor:HEX_TO_UICOLOR(NAV_COLOR, 1.0) forState:UIControlStateNormal];
        [queding addTarget:self action:@selector(quedingAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:queding];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:FRAME(16, 10, self_Width-32, 20)];
        lable.text = @"提醒设置";
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
        lable.font = [UIFont systemFontOfSize:13];
        [view addSubview:lable];
        
        pickerView = [[UIPickerView alloc]initWithFrame:FRAME(0, 40, self_Width, 180)];
        pickerView.backgroundColor = [UIColor whiteColor];
        //    指定Delegate
        pickerView.delegate= self;
        pickerView.dataSource = self;
        
        //    显示选中框
        pickerView.showsSelectionIndicator=YES;
        [self addSubview:pickerView];
        hoursArray = @[@"1天前",@"3天前",@"7天前",@"不提醒"];
        
        MinutesArray = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)quxiaoAction:(UIButton *)sender
{
    [self.delegate suanle];
    
}
- (void)quedingAction:(UIButton *)sender
{
    
    
    NSInteger row = [pickerView selectedRowInComponent:0];
    // NSLog(@"%ld",(long)row);
    //NSInteger row1 = [pickerView selectedRowInComponent:1];
    self.txRow=row;
    [self.delegate hours:[hoursArray objectAtIndex:row]];
    
    
}
//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    switch (component){
            
        case 0:
            return [hoursArray count];
    }
    return 0;
}
#pragma mark Picker Delegate Methods

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component){
            
        case 0:
            
            return [hoursArray objectAtIndex:row];
    }
    return nil;
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    
    UILabel *myView = nil;
    
    if(component == 0){
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
        
        myView.text = [hoursArray objectAtIndex:row];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.textColor = [UIColor blackColor];
        
        myView.font = [UIFont systemFontOfSize:16];
        
        myView.backgroundColor = [UIColor clearColor];
        
    }
    else
    {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
        
        myView.text = [MinutesArray objectAtIndex:row];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.textColor = [UIColor blackColor];
        
        myView.font = [UIFont systemFontOfSize:16];
        
        myView.backgroundColor = [UIColor clearColor];
    }
    
    return myView;
    
}


@end
