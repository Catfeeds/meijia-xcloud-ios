//
//  WebPageViewController.h
//  yxz
//
//  Created by 白玉林 on 16/1/27.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"
@interface WebPageViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,NJKWebViewProgressDelegate>
@property (nonatomic ,strong)NSString *webURL;
@property (nonatomic ,assign)int vcIDs;
@property (nonatomic ,assign)int barIDS;
@end
