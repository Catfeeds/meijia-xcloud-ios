//
//  FountWebViewController.h
//  yxz
//
//  Created by 白玉林 on 15/12/10.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"
@interface FountWebViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,NJKWebViewProgressDelegate,UITableViewDelegate,UITableViewDataSource,UMSocialUIDelegate,MJRefreshBaseViewDelegate>
@property(nonatomic ,strong)NSString *goto_type;
@property(nonatomic ,strong)NSString *imgurl;
@property(nonatomic ,strong)NSString *service_type_id;
@property(nonatomic ,strong)NSString *titleName;
@property(nonatomic ,strong)UIButton *liftButton;
@property(nonatomic ,strong)UIButton *cancelBut;
@property(nonatomic ,strong)UIButton *rightButton;
@end
