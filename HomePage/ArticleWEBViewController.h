//
//  ArticleWEBViewController.h
//  yxz
//
//  Created by 白玉林 on 16/5/24.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"
@interface ArticleWEBViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,NJKWebViewProgressDelegate,UITableViewDelegate,UITableViewDataSource,UMSocialUIDelegate,MJRefreshBaseViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
@property (nonatomic ,strong)NSString *webURL;
@property (nonatomic ,assign)int vcIDs;
@property (nonatomic ,assign)int barIDS;
@property (nonatomic ,assign)int qdIDl;
@property (nonatomic ,assign)int pushID;
@property (nonatomic ,strong)NSString *listID;
@property (nonatomic ,strong)NSTimer *myTimer;


@end
