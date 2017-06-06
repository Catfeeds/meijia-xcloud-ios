//
//  MailListViewController.h
//  simi
//
//  Created by 白玉林 on 15/9/22.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "THContactPickerView.h"
#import "THContactPickerTableViewCell.h"
@interface MailListViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate,ABPersonViewControllerDelegate,THContactPickerDelegate>
@property (nonatomic ,strong)UITableView *mailTableview;
@property (nonatomic ,strong)THContactPickerView *contactPickerView;
@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, strong) NSMutableArray *selectedContacts;
@property (nonatomic, strong) NSArray *filteredContacts;
@property (nonatomic, strong)NSString *selectString;
@property (nonatomic, strong)NSString *numberString;
@property (nonatomic, strong)NSMutableArray *nameArray;
@property (nonatomic, strong)NSMutableArray *mobileArray;
@property (nonatomic, strong)NSMutableArray *idArray;
@property (nonatomic, assign)int theNumber;

@property (nonatomic, strong)NSArray *seleArray;
@property (nonatomic, strong) NSArray *passNameArray;
@property (nonatomic, strong) NSArray *passMobielArray;
@property (nonatomic, strong) NSArray *passIdArray;
@end
