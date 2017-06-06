//
//  Publish_DynamicViewController.h
//  yxz
//
//  Created by 白玉林 on 15/12/25.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface Publish_DynamicViewController : FatherViewController<UIActionSheetDelegate,UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
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

@property (strong ,nonatomic)NSString *cityStr;
@property (strong ,nonatomic)NSString *latString;
@property (strong ,nonatomic)NSString *lngString;

@end
