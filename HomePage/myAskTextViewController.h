//
//  myAskTextViewController.h
//  yxz
//
//  Created by 白玉林 on 16/6/6.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface myAskTextViewController : FatherViewController<UIScrollViewDelegate>
@property (nonatomic ,strong)NSDictionary *dataDic;
@property (nonatomic ,assign)int askVCID;
@property (nonatomic ,strong)NSTimer *myTimer;
@end
