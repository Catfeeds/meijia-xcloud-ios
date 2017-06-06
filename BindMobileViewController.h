//
//  BindMobileViewController.h
//  yxz
//
//  Created by 白玉林 on 15/11/17.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindMobileViewController : UIViewController<UITextFieldDelegate>
@property(nonatomic ,strong)UITextField *mobileField;
@property(nonatomic ,strong)UITextField *veriFicationField;
@property(nonatomic ,strong)UIButton *veriFicationButton;

@end
