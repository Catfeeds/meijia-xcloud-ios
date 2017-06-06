//
//  CollectRegisterViewController.h
//  yxz
//
//  Created by 白玉林 on 16/3/31.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface CollectRegisterViewController : FatherViewController<UIScrollViewDelegate,UITextFieldDelegate>
@property(nonatomic ,strong)NSArray *dataArray;
@end
