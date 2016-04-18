//
//  Modify_InformationViewController.h
//  yxz
//
//  Created by 白玉林 on 16/4/15.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UpdateUserProfileSuccess @"update user profile success!"
@class UMComUser, UMComUserAccount, UMComImageView;
@interface Modify_InformationViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UMComUserAccount *userAccount;
@property (nonatomic, copy) void (^settingCompletion)(UIViewController *viewController, UMComUserAccount *userAccount);
@property (nonatomic, copy) void (^updateCompletion)(id responseObject, NSError *error) ;
@property (nonatomic, strong)UMComImageView *userPortrait;
@end
