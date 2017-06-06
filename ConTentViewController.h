//
//  ConTentViewController.h
//  simi
//
//  Created by 白玉林 on 15/9/9.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface ConTentViewController : FatherViewController<UITextViewDelegate>
@property (nonatomic ,strong)UITextView *textView;
@property (nonatomic ,strong)NSString *textString;
@property (nonatomic ,assign)NSInteger card_id;
@end
