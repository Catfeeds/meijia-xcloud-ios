//
//  DetailsListViewController.h
//  yxz
//
//  Created by 白玉林 on 16/3/3.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UMSocialUIDelegate,MJRefreshBaseViewDelegate,UIScrollViewDelegate>
@property(nonatomic ,assign)int pathId;
@property(nonatomic ,assign)int card_ID;
@property(nonatomic ,assign)int S;
@property(nonatomic ,assign)int L;
@property(nonatomic ,assign)int vcIDS;


@end
