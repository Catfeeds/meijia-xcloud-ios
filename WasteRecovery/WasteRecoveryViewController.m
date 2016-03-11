//
//  WasteRecoveryViewController.m
//  yxz
//
//  Created by 白玉林 on 16/3/4.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "WasteRecoveryViewController.h"
#import "WasteRecoveryOrderViewController.h"
#import "Order_CleanViewController.h"
#import "Order_TeamworkViewController.h"
#import "Express_RegisterViewController.h"
@interface WasteRecoveryViewController ()
{
    UITableView *myTableView;
    NSMutableArray *dataSourceArray;
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    NSInteger   page;
}
@end

@implementation WasteRecoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_wasteID==100) {
        self.navlabel.text=@"废品回收";
    }else if (_wasteID==101){
        self.navlabel.text=@"保洁";
    }else if (_wasteID==102){
        self.navlabel.text=@"团队拓展";
    }else if (_wasteID==103){
        self.navlabel.text=@"快递";
    }
    
    if (_wasteID==100) {
        self.backlable.backgroundColor=HEX_TO_UICOLOR(0x11cd6e, 1.0);
    }else if (_wasteID==101){
        self.backlable.backgroundColor=HEX_TO_UICOLOR(0x56abe4, 1.0);
    }else if (_wasteID==102){
        self.backlable.backgroundColor=HEX_TO_UICOLOR(0xea8010, 1.0);
    }else if (_wasteID==103){
        self.backlable.backgroundColor=HEX_TO_UICOLOR(0x00bb9c, 1.0);
    }
   
    dataSourceArray=[[NSMutableArray alloc]init];
    page=1;
    [self tableViewLayout];
    
    UIView *butView=[[UIView alloc]initWithFrame:FRAME(0, HEIGHT-56, WIDTH, 56)];
    butView.backgroundColor=self.backlable.backgroundColor;
    [self.view addSubview:butView];
    
    UIButton *wasteBut=[[UIButton alloc]initWithFrame:FRAME(0, 0, WIDTH/2-0.5, 56)];
    if (_wasteID==100) {
        [wasteBut setTitle:@"上门回收" forState:UIControlStateNormal];
    }else if (_wasteID==101){
        [wasteBut setTitle:@"上门服务" forState:UIControlStateNormal];
    }else if (_wasteID==102){
        [wasteBut setTitle:@"团队建设" forState:UIControlStateNormal];
    }else if (_wasteID==103){
        [wasteBut setTitle:@"快递登记" forState:UIControlStateNormal];
    }
    wasteBut.tag=1001;
    [wasteBut addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
    [butView addSubview:wasteBut];
    
    UIView *verticalView=[[UIView alloc]initWithFrame:FRAME(WIDTH/2-0.5, 10, 1, 36)];
    verticalView.backgroundColor=[UIColor whiteColor];
    [butView addSubview:verticalView];
    
    UIButton *referBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH/2+0.5, 0, WIDTH/2-0.5, 56)];
    if (_wasteID==100) {
       [referBut setTitle:@"参考价格" forState:UIControlStateNormal];
    }else if (_wasteID==101){
        [referBut setTitle:@"智能设置" forState:UIControlStateNormal];
    }else if (_wasteID==102){
        [referBut setTitle:@"智能设置" forState:UIControlStateNormal];
    }else if (_wasteID==103){
        
    }
    
    referBut.tag=1002;
    [referBut addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
    [butView addSubview:referBut];
    // Do any additional setup after loading the view.
}
-(void)butAction:(UIButton *)button
{
    if (button.tag==1001) {
        if (_wasteID==100) {
            WasteRecoveryOrderViewController *orderVC=[[WasteRecoveryOrderViewController alloc]init];
            [self.navigationController pushViewController:orderVC animated:YES];
        }else if (_wasteID==101){
            Order_CleanViewController *orderVC=[[Order_CleanViewController alloc]init];
            [self.navigationController pushViewController:orderVC animated:YES];
        }else if (_wasteID==102){
            Order_TeamworkViewController *orderVC=[[Order_TeamworkViewController alloc]init];
            [self.navigationController pushViewController:orderVC animated:YES];
        }else if (_wasteID==103){
            Express_RegisterViewController *orderVC=[[Express_RegisterViewController alloc]init];
            [self.navigationController pushViewController:orderVC animated:YES];
        }
        
    }else{
        WebPageViewController *webPageVC=[[WebPageViewController alloc]init];
        if (_wasteID==100) {
            webPageVC.webURL=@"http://123.57.173.36/simi-h5/show/recycle-price.html";//废品回收参考价格跳转URL
        }else if (_wasteID==101){
            webPageVC.webURL=@"http://123.57.173.36/simi-h5/show/clean-set.html";//保洁智能设置跳转URL
        }else if (_wasteID==102){
            webPageVC.webURL=@"http://123.57.173.36/simi-h5/show/teamwork-set.html";//团建智能设置跳转URL
        }else if (_wasteID==103){
            webPageVC.webURL=@"http://123.57.173.36/simi-h5/show/express-set.html";//团建智能设置跳转URL
        }
        
        [self.navigationController pushViewController:webPageVC animated:YES];
    }
}
-(void)tableViewLayout
{
    myTableView=[[UITableView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-120)];
    myTableView.dataSource=self;
    myTableView.delegate=self;
    [self.view addSubview:myTableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [myTableView setTableFooterView:v];
    _refreshHeader = [[MJRefreshHeaderView alloc] init];
    _refreshHeader.delegate = self;
    _refreshHeader.scrollView = myTableView;
    
    _moreFooter = [[MJRefreshFooterView alloc] init];
    _moreFooter.delegate = self;
    _moreFooter.scrollView = myTableView;
}
-(void)defaultInterfaceLayout
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *_dict = @{@"user_id":_manager.telephone,@"page":pageStr};
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    if (_wasteID==100) {
        [_download requestWithUrl:[NSString stringWithFormat:@"%@",WASTE_LIST] dict:_dict view:self.view delegate:self finishedSEL:@selector(addDressSuccess:) isPost:NO failedSEL:@selector(addDressFail:)];
    }else if (_wasteID==101){
        [_download requestWithUrl:[NSString stringWithFormat:@"%@",CLEAN_ORDER_LIST] dict:_dict view:self.view delegate:self finishedSEL:@selector(addDressSuccess:) isPost:NO failedSEL:@selector(addDressFail:)];
    }else if (_wasteID==102){
        [_download requestWithUrl:[NSString stringWithFormat:@"%@",LWAGYEBUILDING_LIST] dict:_dict view:self.view delegate:self finishedSEL:@selector(addDressSuccess:) isPost:NO failedSEL:@selector(addDressFail:)];
    }else if (_wasteID==103){
        [_download requestWithUrl:[NSString stringWithFormat:@"%@",EXPRESS_ORDER_LIST] dict:_dict view:self.view delegate:self finishedSEL:@selector(addDressSuccess:) isPost:NO failedSEL:@selector(addDressFail:)];
    }
    
    
}
#pragma mark默认班次数据成功方法
-(void)addDressSuccess:(id)source
{
    NSLog(@"默认班次数据:%@",source);
    NSString *string=[NSString stringWithFormat:@"%@",[source objectForKey:@"data"]];
    if (string==nil||string==NULL||[string isEqualToString:@"(\n)"]) {
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }else{
        
        NSArray *array=[source objectForKey:@"data"];
        if (array.count<10*page) {
            _hasMore=YES;
        }else{
            _hasMore=NO;
        }
        if (page==1) {
            [dataSourceArray removeAllObjects];
            [dataSourceArray addObjectsFromArray:array];
        }else{
            for (int i=0; i<array.count; i++) {
                if ([dataSourceArray containsObject:array[i]]) {
                    
                }else{
                    [dataSourceArray addObject:array[i]];
                }
            }
            
        }
        [myTableView reloadData];
    }
}
#pragma mark默认班次数据失败方法
-(void)addDressFail:(id)source
{
    NSLog(@"默认班次数据失败:%@",source);
}
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self defaultInterfaceLayout];
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
    
    [self defaultInterfaceLayout];
    
    
    
}
#pragma mark 表格刷新相关

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSourceArray.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=dataSourceArray[indexPath.row];
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    UITableViewCell *Cell = [tableView cellForRowAtIndexPath:indexPath];
    if (Cell == nil) {
        Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME(20, 25, 70, 70)];
    NSString *imageUrl;
    if (_wasteID==100) {
        imageUrl=@"http://123.57.173.36/simi-h5/icon/icon-dingdan-caolv.png";
    }else if (_wasteID==101){
        imageUrl=@"http://123.57.173.36/simi-h5/icon/icon-dingdan-qianlan.png";
    }else if (_wasteID==102){
        imageUrl=@"http://123.57.173.36/simi-h5/icon/icon-dingdan-chenghuang.png";
    }else if (_wasteID==103){
        imageUrl=@"http://123.57.173.36/simi-h5/icon/icon-dingdan-molv.png";
    }
    [imageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];;
    [Cell addSubview:imageView];
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:FRAME(imageView.frame.size.width+30, 20, WIDTH-(imageView.frame.size.width+100), 20)];
    moneyLabel.font=[UIFont fontWithName:@"Arial" size:15];
    if (_wasteID==100) {
        moneyLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"recycle_type_name"]];
    }else if (_wasteID==101){
        moneyLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"clean_type_name"]];
    }else if (_wasteID==102){
        moneyLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"team_type_name"]];
    }else if (_wasteID==103){
        int exp_typ=[[dic objectForKey:@"express_type"]intValue];
        if (exp_typ==0) {
           moneyLabel.text=@"收件";
        }else if (exp_typ==1){
           moneyLabel.text=@"寄件";
        }
        
    }
    
    [Cell addSubview:moneyLabel];
    UILabel *stateLabel=[[UILabel alloc]initWithFrame:FRAME(moneyLabel.frame.origin.x, 50, moneyLabel.frame.size.width, 20)];
    stateLabel.font=[UIFont fontWithName:@"Arial" size:15];
    if (_wasteID==103) {
        int is_done=[[dic objectForKey:@"is_done"]intValue];
        if (is_done==0) {
            stateLabel.text=@"在路上";
        }else if (is_done==1){
            stateLabel.text=@"已送达";
        }
        
    }else{
        stateLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"order_status_name"]];
    }
    
    [Cell addSubview:stateLabel];
    UILabel *waterLabel=[[UILabel alloc]initWithFrame:FRAME(moneyLabel.frame.origin.x, 80, moneyLabel.frame.size.width, 20)];
    waterLabel.font=[UIFont fontWithName:@"Arial" size:15];
    waterLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"add_time_str"]];
    [Cell addSubview:waterLabel];
    [Cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        dispatch_async(dispatch_get_main_queue(),^{
            [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        });
    }
    
//    button.tag=indexPath.row;
//    button.titleLabel.font=[UIFont fontWithName:@"Arial" size:15];
//    [button addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
//    [Cell addSubview:button];
    return Cell;
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
