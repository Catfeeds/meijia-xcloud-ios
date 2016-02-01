//
//  MineJifenViewController.m
//  simi
//
//  Created by 赵中杰 on 14/12/23.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "MineJifenViewController.h"
#import "DownloadManager.h"
#import "YouhuijuanCell.h"
#import "MBProgressHUD+Add.h"
#import "ISLoginManager.h"
#import "BaiduMobStat.h"
#import "PaymentViewController.h"
#import "OrderPayViewController.h"
@interface MineJifenViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>
{
    NSMutableArray *_listArray;
    UITableView *_mytableview;
    UITextField *_myfiled;
    YOUHUIData *mydata;
    YOUHUIBaseClass *_baseclass;
    NSArray *array;
    
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    NSInteger   page;

}

@end

@implementation MineJifenViewController
@synthesize delegate = _delegate,controlName,juanLX;
-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"我的优惠券", nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"我的优惠券", nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    page=1;
    // Do any additional setup after loading the view.
    
    self.navlabel.text = @"我的优惠券";
    
    _listArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    UILabel *_headlabel = [[UILabel alloc]initWithFrame:FRAME(0, 64, _WIDTH, 54)];
    _headlabel.backgroundColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];//HEX_TO_UICOLOR(ROUND_COLOR, 1.0);
    [self.view addSubview:_headlabel];
    
    UILabel *_backlabel1 = [[UILabel alloc]initWithFrame:FRAME(14, 64+9, _WIDTH-28, 35)];
    _backlabel1.layer.cornerRadius = 4.0;
    _backlabel1.layer.borderWidth = 0.5;
    _backlabel1.layer.masksToBounds = YES;
    _backlabel1.backgroundColor = COLOR_VAULE(255.0);
   // _backlabel1.layer.borderColor = COLOR_VAULES(179.0, 71.0, 36.0, 1.0).CGColor;//b34724
    [self.view addSubview:_backlabel1];
    
    UIImageView *_searchview = [[UIImageView alloc]initWithFrame:FRAME(14+10, 64+5+10, 26, 25)];
    [_searchview setImage:IMAGE_NAMED(@"search_")];
    [self.view addSubview:_searchview];
    
    UIButton *_duihuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_duihuanBtn setTitle:@"兑换" forState:UIControlStateNormal];
    _duihuanBtn.frame = FRAME(_WIDTH-62, 64, 42, 54);
    [_duihuanBtn setTitleColor:HEX_TO_UICOLOR(TEXT_COLOR, 1.0) forState:UIControlStateNormal];
    _duihuanBtn.titleLabel.font = MYFONT(13.5);
    [_duihuanBtn addTarget:self action:@selector(DuihuanBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_duihuanBtn];
    
    _myfiled = [[UITextField alloc]initWithFrame:FRAME(14+10+30, 64+10, _WIDTH-54-62, 34)];
    _myfiled.placeholder = @"请输入兑换码";
    _myfiled.font = MYFONT(13.5);
    _myfiled.textColor = COLOR_VAULE(177.0);
//    _myfiled.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_myfiled];
    
    _mytableview = [[UITableView alloc]initWithFrame:FRAME(0, 118, _WIDTH, _HEIGHT-118) style:UITableViewStylePlain];
    _mytableview.delegate = self;
    _mytableview.dataSource = self;
    _mytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mytableview];
    _refreshHeader = [[MJRefreshHeaderView alloc] init];
    _refreshHeader.delegate = self;
    _refreshHeader.scrollView = _mytableview;
    
    _moreFooter = [[MJRefreshFooterView alloc] init];
    _moreFooter.delegate = self;
    _moreFooter.scrollView = _mytableview;
    [self PLJKLayout];
    
}
-(void)PLJKLayout
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *_dict = @{@"user_id":_manager.telephone,@"page":pageStr};
    [_download requestWithUrl:MINEYOUHUIJUAN dict:_dict view:self.view delegate:self finishedSEL:@selector(DownloadFinish:) isPost:NO failedSEL:@selector(FailDownload:)];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_needRefresh) {
        [_refreshHeader beginRefreshing];
        _needRefresh = NO;
    }
}
#pragma mark 获取优惠卷列表
- (void)DownloadFinish:(id)responsobject
{
    NSLog(@"获取优惠劵数据%@",responsobject);
    array=[responsobject objectForKey:@"data"];
    _baseclass = [[YOUHUIBaseClass alloc]initWithDictionary:responsobject];
//    [_listArray removeAllObjects];
//    for (int i = 0; i < _baseclass.data.count; i ++) {
//        
//        YOUHUIData *mydata2 = [_baseclass.data objectAtIndex:i];
//        
//        [_listArray addObject:mydata2];
//    
//    }
    if (array.count==0) {
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }else{
//        NSArray *array=[sender objectForKey:@"data"];
        if (array.count<10*page) {
            _hasMore=YES;
        }else{
            _hasMore=NO;
        }
        if (page==1) {
            [_listArray removeAllObjects];
            [_listArray addObjectsFromArray:array];
        }else{
            for (int i=0; i<array.count; i++) {
                if ([_listArray containsObject:array[i]]) {
                    
                }else{
                    [_listArray addObject:array[i]];
                }
            }
            
        }
        [_mytableview reloadData];
    }
    
}
#pragma mark 表格刷新相关
#pragma mark 刷新
-(void)refresh
{
    [_refreshHeader beginRefreshing];
}


#pragma mark - MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        //头 -》 刷新
        if (_moreFooter.isRefreshing) {
            //正在加载更多，取消本次请求
            [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            return;
        }
        page = 1;
        //刷新
        [self loadData];
        
    }else if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
        //尾 -》 更多
        if (_refreshHeader.isRefreshing) {
            //正在刷新，取消本次请求
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            
            return;
        }
        
        if (_hasMore==YES) {
            //没有更多了
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            //            [_tableView reloadData];
            return;
        }
        page++;
        
        //加载更多
        
        [self loadData];
    }
}

-(void)loadData
{
    //    if (_service == nil) {
    //        _service = [[zzProjectListService alloc] init];
    //        _service.delegate = self;
    //    }
    
    //通过控制page控制更多 网路数据
    //    [_service reqwithPageSize:INVESTPAGESIZE page:page];
    //    [self loadImg];
    
    //本底数据
    //    [_arrData addObjectsFromArray:[UIFont familyNames]];
    
    [self PLJKLayout];
    
    
    
}
#pragma mark 表格刷新相关
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YOUHUIData *_mydata = [_listArray objectAtIndex:indexPath.row];
    CGSize _dessize = [self returnMysizeWithCgsize:CGSizeMake(_WIDTH-60, WIDTH) text:_mydata.dataDescription font:MYFONT(10)];

    return 65+10+_dessize.height + 16 + 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"YouhuijuanTableViewCellId";
    YouhuijuanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[YouhuijuanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.mydata = [_listArray objectAtIndex:indexPath.row];
    if (array.count==0) {
        
    }else{
        NSDictionary *dic=array[indexPath.row];
        cell.dic=[NSString stringWithFormat:@"%@",[dic objectForKey:@"to_date"]];
    }
    
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        dispatch_async(dispatch_get_main_queue(),^{
            [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        });
    }

    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YOUHUIData *data=[_listArray objectAtIndex:indexPath.row];
//    NSLog(@"优惠劵数据 查看%f,%@,%@,%f,%f,%@,%f,%f,%f,%f,%f,%@,%f,%f,%f,%@,%f",data.dataIdentifier,data.serviceType,data.dataDescription,data.rangFrom,data.expTime,data.introduction,data.rangeType,data.userId,data.couponId,data.value,data.isUsed,data.cardPasswd,data.usedTime,data.addTime,data.addTime,data.orderNo,data.updateTime);

    int vale=(int)data.value;
    _moneyString=[NSString stringWithFormat:@"%d",vale];
    int couponId=(int)data.dataIdentifier;
    _coupon_id=[NSString stringWithFormat:@"%d",couponId];
    if (_viewConllorID==1) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[PaymentViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }else{
        
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[OrderPayViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
    if ([controlName isEqualToString:@"支付"]) {
        mydata = [_baseclass.data objectAtIndex:indexPath.row];
        NSString *leixing = [NSString stringWithFormat:@"%@",mydata.serviceType];
        NSLog(@"leixing: %@",leixing);
        if (mydata.rangFrom == 1) {
            [self showAlertViewWithTitle:@"" message:@"抱歉，您选择的优惠券不能在App端使用，请重新选择。"];
            return;
        }
        
        NSRange range = [leixing rangeOfString:juanLX];
       
        if (range.location == NSNotFound) {
            NSLog(@"没找到");
        }else{
            NSLog(@"找到了");
        }
        
        if([leixing isEqualToString:@"0"]||range.location != NSNotFound )
        {
            [self.delegate CardPasswdIs:mydata.cardPasswd money:mydata.value];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [self showAlertViewWithTitle:@"" message:@"您选择的优惠券服务类型不符，请重新选择。"];
        }

    }
    

}

#pragma mark 下载失败
- (void)FailDownload:(id)responsobject
{
    NSLog(@"%@",responsobject);
}

#pragma mark 兑换按钮点击
- (void)DuihuanBtnPressed:(UIButton *)sender
{
    DownloadManager *_download = [[DownloadManager alloc]init];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSDictionary *_dict = @{@"user_id":_manager.telephone,@"card_passwd":_myfiled.text};
    [_download requestWithUrl:YOUHUIJUAN_DUIHUAN dict:_dict view:self.view delegate:self finishedSEL:@selector(DuihuanChenggong:) isPost:YES failedSEL:@selector(FailDownload:)];
}

- (void)DuihuanChenggong:(id)responsobject
{
    NSLog(@"responsobject is %@",responsobject);
    
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict = @{@"user_id":_manager.telephone};
    [_download requestWithUrl:MINEYOUHUIJUAN dict:_dict view:self.view delegate:self finishedSEL:@selector(DownloadFinish:) isPost:NO failedSEL:@selector(FailDownload:)];
    
//    [_myfiled resignFirstResponder];
//    
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    
//    float status = [[responsobject objectForKey:@"status"] floatValue];
//    if (status == 0) {
//        YOUHUIData *_mydata = [[YOUHUIData alloc]initWithDictionary:[responsobject objectForKey:@"data"]];
//        [_listArray insertObject:_mydata atIndex:0];
//        
//
//    }else{
//        
//    }
  
    
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
