//
//  SchoolViewController.h
//  yxz
//
//  Created by 白玉林 on 16/4/21.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface SchoolViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,AVCaptureMetadataOutputObjectsDelegate,NSURLConnectionDataDelegate,MJRefreshBaseViewDelegate>
@property(nonatomic, retain)UITableView *myTableView;
@end
