//
//  ZXShopCartViewController.m
//  ZXShopCart
//
//  Created by Xiang on 16/2/2.
//  Copyright © 2016年 周想. All rights reserved.
//

#import "ZXShopCartViewController.h"
#import "GoodsModel.h"
#import "GoodsCategory.h"
#import "MJExtension.h"
#import "MenuItemCell.h"
#import "ShopCartView.h"
#import "ThrowLineTool.h"
#import "DetailListCell.h"
#import "CollectRegisterViewController.h"
#define ZXColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface ZXShopCartViewController ()<UITableViewDelegate, UITableViewDataSource, MenuItemCellDelegate, ThrowLineToolDelegate, DetailListCellDelegate>
{
    NSMutableData *data;
    NSMutableArray *dataArrays;
}
@property (nonatomic, strong) UITableView   *leftTableView;
@property (nonatomic, strong) UITableView   *rightTableView;
@property (nonatomic, strong) NSArray       *dataArray;
@property (nonatomic, assign) BOOL          isRelate;
@property (nonatomic, strong) UIImageView   *redView;   //抛物线红点
@property (nonatomic, strong) ShopCartView  *shopCartView;
@property (nonatomic, assign) NSInteger     totalOrders;    //总数量

@end

@implementation ZXShopCartViewController

static NSString * const cellID = @"MenuItemCell";
static NSString * const ListCellID = @"DetailListCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DistrictLayout:) name:@"DISTRICT" object:nil];
    self.title = @"购物车";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    CGRect viewBounds = self.view.bounds;
    float navBarHeight = self.navigationController.navigationBar.frame.size.height + 20;
    viewBounds.size.height = ([[UIScreen mainScreen] bounds].size.height) - navBarHeight;
    self.view.bounds = viewBounds;
    
    [self leftTableView];
    [self rightTableView];
    [self shopCartView];
    [self collectCategory];
    [ThrowLineTool sharedTool].delegate = self;
    _isRelate = YES;
}
-(void)DistrictLayout:(NSNotification *)dataSource
{
    NSArray *array=dataSource.object;
    CollectRegisterViewController *collectVC=[[CollectRegisterViewController alloc]init];
    collectVC.dataArray=array;
    [self.navigationController  pushViewController:collectVC animated:YES];
}

-(void)collectCategory
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *company_ID=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"company_id"]];
    NSDictionary *_dict = @{@"user_id":_manager.telephone,@"company_id":company_ID};
    DownloadManager *_download = [[DownloadManager alloc]init];
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",COMPANY_COLLECT_CATEGORY] dict:_dict view:self.view delegate:self finishedSEL:@selector(CollectSuccess:) isPost:NO failedSEL:@selector(CollectFail:)];
}
-(void)CollectFail:(id)source
{
    NSLog(@"%@",source);
}

-(void)CollectSuccess:(id)source
{
    NSLog(@"%@",source);
    
    int status=[[source objectForKey:@"status"]intValue];
    NSDictionary *dataDic=[source objectForKey:@"data"];
    NSArray *ar=dataDic.allKeys;
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    //排序后
    NSMutableArray *dicarray=[[NSMutableArray alloc]init];
    NSArray *arrays = [ar sortedArrayUsingComparator:cmptr];
    for (int i=0; i<arrays.count; i++) {
        NSDictionary *dic=@{@"id":arrays[i],@"fiel":[dataDic objectForKey:arrays[i]]};
        [dicarray addObject:dic];
    }
    
//    _rightTableSource=dicarray;
    [dataArrays removeAllObjects];
    dataArrays=[[NSMutableArray alloc]init];
    for (int i=0; i<dicarray.count; i++) {
        NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *path = [NSString stringWithFormat:@"%@/simi.db", pathDocuments];
        sqlite3_open([path UTF8String], &xcompany_setting);
        
        sqlite3_stmt *statement;
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM xcompany_setting where id=%@",[dicarray[i]objectForKey:@"id"]];
        
        if (sqlite3_prepare_v2(xcompany_setting, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *_id = (char *)sqlite3_column_text(statement, 0);
                NSString *idStr = [[NSString alloc] initWithUTF8String:_id];
                
                char *name = (char *)sqlite3_column_text(statement, 2);
                NSString *nameStr = [[NSString alloc] initWithUTF8String:name];
                
                
                NSDictionary *dic=@{@"id":idStr,@"name":nameStr,@"data":[dataDic objectForKey:idStr]};
                if ([dataArrays containsObject:dic]) {
                    
                }else{
                    [dataArrays addObject:dic];
                }

                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(xcompany_setting);
    }


    [self loadData];
    
}

#pragma mark - 获取商品数据
- (void)loadData {
    if (!_dataArray) {
        _dataArray = [NSArray new];
        // 解析本地JSON文件获取数据，生产环境中从网络获取JSON

        _dataArray = [GoodsCategory objectArrayWithKeyValuesArray:dataArrays];
    }
    [_leftTableView reloadData];
    [_rightTableView reloadData];
    
}

- (NSMutableArray *)orderArray {
    if (!_orderArray) {
        _orderArray = [NSMutableArray array];
    }
    return _orderArray;
    [_shopCartView.detailListView.listTableView reloadData];
}

- (UITableView *)leftTableView {
    if (nil == _leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width * 0.31, self.view.frame.size.height - 50)];
        _leftTableView.backgroundColor = [UIColor whiteColor];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_leftTableView];
        UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
        [_leftTableView setTableFooterView:v];
    }
    return _leftTableView;
    
}

- (UITableView *)rightTableView {
    if (nil == _rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.31, 64, self.view.frame.size.width * 0.69, self.view.frame.size.height - 50)];
        _rightTableView.backgroundColor = [UIColor whiteColor];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        //_rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MenuItemCell class]) bundle:nil] forCellReuseIdentifier:cellID];
        [self.view addSubview:_rightTableView];
    }
    return _rightTableView;
}

- (ShopCartView *)shopCartView {
    if (!_shopCartView) {
        _shopCartView = [[ShopCartView alloc] initWithFrame:CGRectMake(0, HEIGHT - 50, CGRectGetWidth(self.view.bounds), 50) inView:self.view];
        [self.view addSubview:_shopCartView];
        _shopCartView.userInteractionEnabled=YES;
        //_shopCartView.orderArray = [NSMutableArray new];
        _shopCartView.detailListView.listTableView.delegate = self;
        _shopCartView.detailListView.listTableView.dataSource = self;
        [_shopCartView.detailListView.listTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DetailListCell class]) bundle:nil] forCellReuseIdentifier:ListCellID];
    }
    return _shopCartView;
}

- (UIImageView *)redView {
    if (!_redView) {
        _redView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _redView.image = [UIImage imageNamed:@"adddetail"];
        _redView.layer.cornerRadius = 10;
    }
    return _redView;
}

#pragma mark dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _leftTableView) {
        return 1;
    } else if (tableView == _rightTableView) {
        return [_dataArray count];
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //该项目的demo就是数组里面装着很多字典，字典里面又有数组
    //NSDictionary *item = [_dataArray objectAtIndex:section];
    GoodsCategory *goodsCategory = _dataArray[section];
    if (tableView == _leftTableView) {
        return _dataArray.count;
    } else if (tableView == _rightTableView) {
        //return [[item objectForKey:@"goodsArray"] count];
        return goodsCategory.goodsArray.count;
    } else {
        return _orderArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _leftTableView) {
        NSString *CellIdentifier =[NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            cell.backgroundColor = ZXColor(240, 240, 240);
            UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            selectedBackgroundView.backgroundColor = [UIColor whiteColor];
            cell.selectedBackgroundView = selectedBackgroundView;
            
            // 左侧示意条
            UIView *liner = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 6, 40)];
            liner.backgroundColor = [UIColor orangeColor];
            [selectedBackgroundView addSubview:liner];
        }
        
        GoodsCategory *goodsCategory = _dataArray[indexPath.row];
//        cell.textLabel.font=[UIFont fontWithName:@"Heiti SC" size:17];
//        cell.textLabel.text = goodsCategory.goodsCategoryName;

        UILabel *label=[[UILabel alloc]initWithFrame:FRAME(6, 0, cell.frame.size.width-6, cell.frame.size.height)];
        label.text=goodsCategory.goodsCategoryName;
        label.font=[UIFont fontWithName:@"Heiti SC" size:17];
        [cell addSubview:label];
        return cell;
    } else if (tableView == _rightTableView) {
        
        MenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.delegate = self;
        
        GoodsCategory *goodsCategory = _dataArray[indexPath.section];
        GoodsModel *goods = goodsCategory.goodsArray[indexPath.row];
        
        cell.goods = goods;
        
        return cell;
    } else if (tableView == _shopCartView.detailListView.listTableView) {
        DetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:ListCellID];
        cell.delegate = self;
        GoodsModel *goods = [_orderArray objectAtIndex:indexPath.row];
        cell.goods = goods;
        
        return cell;
    } else {
        return nil;
    }
}

#pragma mark delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        return 40;
    } else if (tableView == _rightTableView) {
        return 70;
    } else {
        return 50;
    }
}

//返回每一个组头的高度，如果想达到有那种效果则一定要做这个操作
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _rightTableView) {
        return 30;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == _rightTableView) {
        return 0.01;
    } else {
        return 0;
    }
}

//返回组头部的那块View
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == _rightTableView) {
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(0, 0, tableView.frame.size.width, 30);
        view.backgroundColor = ZXColor(240, 240, 240);
        [view setAlpha:0.7];
        UILabel *label = [[UILabel alloc]initWithFrame:view.bounds];
        //NSDictionary *item = [_dataArray objectAtIndex:section];
        GoodsCategory *goodsCategory = [_dataArray objectAtIndex:section];
        NSString *title = goodsCategory.goodsCategoryDesc;
        [label setText:[NSString stringWithFormat:@"  %@",title]];
        [view addSubview:label];
        return view;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //左边tableView
    if (tableView == _leftTableView) {
        _isRelate = NO;
        [self.leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        
        //点击了左边的cell，让右边的tableView跟着滚动
        [self.rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else if (tableView == _rightTableView) {
        [_rightTableView deselectRowAtIndexPath:indexPath animated:NO];
        
        NSLog(@"点击这里可以跳到详情页面");
    } else {
        [_shopCartView.detailListView.listTableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (_isRelate) {
        NSInteger topCellSection = [[[tableView indexPathsForVisibleRows] firstObject] section];
        if (tableView == _rightTableView) {
            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:topCellSection inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section {
    if (_isRelate) {
        NSInteger topCellSection = [[[tableView indexPathsForVisibleRows] firstObject] section];
        if (tableView == _rightTableView) {
            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:topCellSection inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
}

#pragma mark - UISCrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _isRelate = YES;
}

#pragma mark - MenuItemCellDelegate
- (void)menuItemCellDidClickMinusButton:(MenuItemCell *)itemCell {
    // 计算总价
    _totalPrice = _totalPrice - itemCell.goods.price;
    
    // 设置总价
    [_shopCartView setTotalPrice:_totalPrice];
    
    --self.totalOrders;
    _shopCartView.badgeValue = self.totalOrders;
    
    
    // 将商品从购物车中移除
    if (itemCell.goods.orderCount == 0) {
        [self.orderArray removeObject:itemCell.goods];
    }
    [_shopCartView.detailListView.listTableView reloadData];
    _shopCartView.detailListView.objects = _orderArray;
    _shopCartView.orderArray = _orderArray;
}

- (void)menuItemCellDidClickPlusButton:(MenuItemCell *)itemCell {
    // 计算总价
    _totalPrice = _totalPrice + itemCell.goods.price;
    // 设置总价
    [_shopCartView setTotalPrice:_totalPrice];

    //通过坐标转换得到抛物线的起点和终点
    CGRect parentRectA = [itemCell convertRect:itemCell.plusButton.frame toView:self.view];
    CGRect parentRectB = [_shopCartView convertRect:_shopCartView.shopCartBtn.frame toView:self.view];
    [self.view addSubview:self.redView];
    [[ThrowLineTool sharedTool] throwObject:self.redView from:parentRectA.origin to:parentRectB.origin];
    ++self.totalOrders;
    _shopCartView.badgeValue = self.totalOrders;
    
    
    // 如果这个商品已经在购物车中，就不用再添加
    if ([self.orderArray containsObject:itemCell.goods]) {
        [_shopCartView.detailListView.listTableView reloadData];
    } else {
        // 添加需要购买的商品
        [self.orderArray addObject:itemCell.goods];
        [_shopCartView.detailListView.listTableView reloadData];
    }
    _shopCartView.detailListView.objects = _orderArray;
    _shopCartView.orderArray = _orderArray;
}

#pragma mark - ThrowLineToolDelegate
- (void)animationDidFinish {
    
    [self.redView removeFromSuperview];
    [UIView animateWithDuration:0.1 animations:^{
        _shopCartView.shopCartBtn.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            _shopCartView.shopCartBtn.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
        }];

    }];
}

#pragma mark - DetailListCellDelegate
- (void)orderDetailCellPlusButtonClicked:(DetailListCell *)cell {
    NSLog(@"订单 + 按钮点击: %@ %@ %i", cell.goods.seq, cell.goods.name, cell.goods.stock);
    // 计算总价
    _totalPrice = _totalPrice + cell.goods.price;
    // 设置总价
    [_shopCartView setTotalPrice:_totalPrice];
    ++self.totalOrders;
    _shopCartView.badgeValue = self.totalOrders;
    
    _shopCartView.detailListView.objects = _orderArray;
    _shopCartView.orderArray = _orderArray;
    [_shopCartView updateFrame:_shopCartView.detailListView];
    [_shopCartView.detailListView.listTableView reloadData];
    [_rightTableView reloadData];
}

- (void)orderDetailCellMinusButtonClicked:(DetailListCell *)cell {
    NSLog(@"订单 - 按钮点击: %@ %@ %i", cell.goods.seq, cell.goods.name, cell.goods.stock);
    // 计算总价
    _totalPrice = _totalPrice - cell.goods.price;
    // 设置总价
    [_shopCartView setTotalPrice:_totalPrice];
    --self.totalOrders;
    _shopCartView.badgeValue = self.totalOrders;
    
    // 将商品从购物车中移除
    if (cell.goods.orderCount == 0) {
        [self.orderArray removeObject:cell.goods];
    }
    _shopCartView.detailListView.objects = _orderArray;
    _shopCartView.orderArray = _orderArray;
    [_shopCartView updateFrame:_shopCartView.detailListView];
    [_shopCartView.detailListView.listTableView reloadData];
    [_rightTableView reloadData];
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com