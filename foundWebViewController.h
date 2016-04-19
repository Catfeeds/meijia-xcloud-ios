//
//  foundWebViewController.h
//  yxz
//
//  Created by 白玉林 on 16/4/8.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"
@interface foundWebViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,NJKWebViewProgressDelegate,UITableViewDelegate,UITableViewDataSource,UMSocialUIDelegate,MJRefreshBaseViewDelegate>
@property(nonatomic ,strong)NSString *goto_type;
@property(nonatomic ,strong)NSString *imgurl;
@property(nonatomic ,strong)NSString *service_type_id;
@property(nonatomic ,strong)NSString *titleName;
@property(nonatomic ,strong)NSString *moneyStr;
@property(nonatomic ,strong)NSString *buyString;
@property(nonatomic ,assign)int cardTypeID;
@property(nonatomic ,strong)NSString *sec_ID;
@property(nonatomic ,strong)NSString *service_price_id;
@property(nonatomic ,strong)NSString *addssID;
@property (nonatomic ,strong)NSDictionary *zeroDic;
@property(nonatomic ,strong)NSString *moneystring;
@end
