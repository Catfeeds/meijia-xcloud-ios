//
//  AttendanceViewController.h
//  yxz
//
//  Created by 白玉林 on 16/1/13.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface AttendanceViewController : FatherViewController<UIWebViewDelegate,UIScrollViewDelegate>
@property (nonatomic ,assign)int webID;
@end
