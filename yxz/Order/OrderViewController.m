//
//  OrderViewController.m
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "OrderViewController.h"
#import "MainOrderCell.h"
#import "LoadMoreCell.h"
#import "DownloadManager.h"
#import "ORDERLISTDataModels.h"
#import "OrderDetailViewController.h"
#import "AppDelegate.h"
#import "ISLoginManager.h"
#import "MBProgressHUD+Add.h"
#import "ChatViewController.h"
#import "SimiOrderDetaileVC.h"
@interface OrderViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
LOADMOREDELAGATE,
UIScrollViewDelegate
>
{
    ORDERLISTBaseClass *_baseclass;
    UITableView *_mytableview;
    NSArray *_cityArray;
    
    NSInteger _indexpath;
    DownloadManager *_download;
    NSMutableArray *_listArray;
    
    NSString *_pagestring;
}

@end

@implementation OrderViewController
@synthesize leixing;
#define TABLE_HEIGHT 82

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([leixing isEqualToString:@"订单支付"]) {
            self.backBtn.hidden = YES;

        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[backBtn setBackgroundImage:[UIImage imageNamed:@"title_left_back"] forState:UIControlStateNormal];
        backBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(0, (40-20)/2, 10, 20)];
        img.image = [UIImage imageNamed:@"title_left_back"];
        [backBtn addSubview:img];

        backBtn.frame = FRAME(18, (40-50/2)/2+25, 50/2, 50/2);
        [backBtn addTarget:self action:@selector(backAction1) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backBtn];
    }
    
    self.navlabel.text = @"订单";
    
    _listArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    _cityArray = [NSArray arrayWithArray:((AppDelegate *)([[UIApplication sharedApplication] delegate])).stockDataArray];
    
    _mytableview = [[UITableView alloc]initWithFrame:FRAME(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    _mytableview.delegate = self;
    _mytableview.dataSource = self;
    _mytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mytableview.backgroundColor = DEFAULT_COLOR;
    [self.view addSubview:_mytableview];

    _pagestring = @"1";
    
    [MBProgressHUD showMessag:@"加载中" toView:self.view];
    
//    [super viewWillAppear:animated];
}

- (void)backAction1
{
    if ([self.leixing isEqualToString:@"我的"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self pushToIM];
    }
}

- (void)viewWillAppear:(BOOL)animated
{

}

- (void)viewDidAppear:(BOOL)animated
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    _pagestring = @"1";
    
    if (_download == nil) {
        _download = [[DownloadManager alloc]init];
    }
    
    if (_listArray != nil) {
        [_listArray removeAllObjects];
    }
    
    [self loadmoreWithPage:@"1"];
    [super viewDidAppear:animated];
    
}

- (void)loadmoreWithPage:(NSString *)page
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 _manager.telephone, @"user_id",
                                 page, @"page",
                                 nil];
    [_download requestWithUrl:ORDER_LIST dict:dict view:self.view delegate:self finishedSEL:@selector(DownloadFinish:) isPost:NO failedSEL:@selector(DownloadFail:)];
}

#pragma mark 下载成功
- (void)DownloadFinish:(NSDictionary *)dict
{
    NSLog(@"%@",dict);
    
    _baseclass = [[ORDERLISTBaseClass alloc]initWithDictionary:dict];
    
    for (int i = 0; i < _baseclass.data.count; i ++) {
        ORDERLISTData *_listdata = [_baseclass.data objectAtIndex:i];
        [_listArray addObject:_listdata];
    }
    
    [_mytableview reloadData];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ORDERAAA" object:nil];
}

#pragma mark 下载失败
- (void)DownloadFail:(id)object
{
    NSLog(@"error is %@",object);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _listArray.count) {
        return 40;
    }
    return TABLE_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != _listArray.count) {   //是不是最后一行
        static NSString *CellIdentifier = @"OrderTableViewCellId";
        MainOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell){
            cell = [[MainOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.datamodel = [_listArray objectAtIndex:indexPath.row];
        
        return cell;
        
    }else{
        static NSString *CellIdentifier = @"MoreTableViewCellId";
        LoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.delegate = self;
        if (!cell){
            cell = [[LoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.orderCount = _baseclass.status;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != _listArray.count) {
//        OrderDetailViewController *_controller = [[OrderDetailViewController alloc]init];
        ORDERLISTData *_data = [_listArray objectAtIndex:indexPath.row];
        SimiOrderDetaileVC *detail = [[SimiOrderDetaileVC alloc]init];
        detail.orderNo = _data.orderNo;
        [self.navigationController pushViewController:detail animated:YES];
//        _controller.listdata = _data;
        
//        _indexpath = indexPath.row;
        
//        [self.navigationController pushViewController:_controller animated:YES];
        
        
        
    }
}

- (void)loadMoreOrder
{
    if (_baseclass.status == 999) {
        [self showAlertViewWithTitle:@"提示" message:@"没有更多数据了"];
    }else{
        _pagestring = [NSString stringWithFormat:@"%d",[_pagestring intValue]+1];
        [self loadmoreWithPage:_pagestring];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
