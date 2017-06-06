//
//  SwickControl.h
//  simi
//
//  Created by 白玉林 on 15/9/23.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class DCRoundSwitchToggleLayer;
@class DCRoundSwitchOutlineLayer;
@class DCRoundSwitchKnobLayer;

@interface SwickControl : UIControl
{
@private
    DCRoundSwitchOutlineLayer *outlineLayer;
    DCRoundSwitchToggleLayer *toggleLayer;
    DCRoundSwitchKnobLayer *knobLayer;
    CAShapeLayer *clipLayer;
    BOOL ignoreTap;
}

@property (nonatomic, retain) UIColor *onTintColor;		// default: blue (matches normal UISwitch)
@property (nonatomic, getter=isOn) BOOL on;				// default: NO
@property (nonatomic, copy) NSString *onText;			// default: 'ON' - automatically localized
@property (nonatomic, copy) NSString *offText;			// default: 'OFF' - automatically localized
@property (nonatomic, assign)int ID;
@property (nonatomic,assign)int swickID;
@property (nonatomic,assign)int noId;
@property (nonatomic, strong) NSString *switchStr;
- (void)setOn:(BOOL)newOn animated:(BOOL)animated;
- (void)setOn:(BOOL)newOn animated:(BOOL)animated ignoreControlEvents:(BOOL)ignoreControlEvents;
@end
