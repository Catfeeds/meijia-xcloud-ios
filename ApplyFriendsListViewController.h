//
//  ApplyFriendsListViewController.h
//  yxz
//
//  Created by 白玉林 on 16/2/22.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyFriendsListViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
@property (nonatomic ,assign)int vcID;
@property (nonatomic ,assign)int listID;
@end
