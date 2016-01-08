//
//  DynamicImageViewController.h
//  yxz
//
//  Created by 白玉林 on 15/12/29.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicImageViewController : UIViewController<UIScrollViewDelegate>
@property (nonatomic ,strong)UIScrollView *scrollview;
@property (nonatomic ,strong)NSArray *imageArray;
@property (nonatomic ,assign)int TG;
@end
