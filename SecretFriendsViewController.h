//
//  SecretFriendsViewController.h
//  simi
//
//  Created by 白玉林 on 15/7/31.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface SecretFriendsViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic ,strong)UITableView *_tableView;
@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, strong) NSMutableArray *selectedContacts;
@property (nonatomic, strong) NSArray *filteredContacts;
@end
