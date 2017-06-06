//
//  ImageViewController.h
//  yxz
//
//  Created by 白玉林 on 15/11/12.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface ImageViewController : FatherViewController<UIScrollViewDelegate>
@property (nonatomic ,assign)int offSet;
@property (nonatomic ,strong)NSArray *iamgeArray;
@property (nonatomic ,strong)NSString *sec_ID;
@end
