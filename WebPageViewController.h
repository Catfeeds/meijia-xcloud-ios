//
//  WebPageViewController.h
//  yxz
//
//  Created by 白玉林 on 16/1/27.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface WebPageViewController : FatherViewController<UIWebViewDelegate,UIScrollViewDelegate>
@property (nonatomic ,strong)NSString *webURL;
@property (nonatomic ,assign)int vcIDs;
@end
