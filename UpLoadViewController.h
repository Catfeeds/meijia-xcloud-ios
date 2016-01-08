//
//  UpLoadViewController.h
//  阿西吧
//
//  Created by jinboli on 15/6/29.
//  Copyright (c) 2015年 刘佳坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpLoadViewController : UIViewController<UIActionSheetDelegate,UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
@property (strong ,nonatomic)UIView *upView;
@property (nonatomic ,strong)UIImageView *addImageView;
@property (nonatomic ,strong)NSMutableArray *imgArray;
@property (strong ,nonatomic)NSMutableArray *images;

@property (strong ,nonatomic)UITextField *titleField;
@property (strong ,nonatomic)UITextView *descriptionView;
@property (strong ,nonatomic)UILabel *timaLabel;
@property (strong ,nonatomic)UITextField *labelField;
@property (strong ,nonatomic)UITextField *priceField;
@property (strong ,nonatomic)UIView *fieldView;
@end
