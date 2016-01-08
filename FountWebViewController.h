//
//  FountWebViewController.h
//  yxz
//
//  Created by 白玉林 on 15/12/10.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface FountWebViewController : FatherViewController<UIWebViewDelegate,UIScrollViewDelegate>
@property(nonatomic ,strong)NSString *goto_type;
@property(nonatomic ,strong)NSString *imgurl;
@property(nonatomic ,strong)NSString *service_type_id;
@property(nonatomic ,strong)NSString *titleName;
@end
