//
//  IntegralListViewController.m
//  yxz
//
//  Created by 白玉林 on 16/4/7.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "IntegralListViewController.h"
#import "CreditWebViewController.h"
@interface IntegralListViewController ()
{
    UIView *headeView;
    UITableView *myTableView;
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    NSInteger   page;
    NSMutableArray *dataSourceArray;
}
@end

@implementation IntegralListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navlabel.text=@"我的金币";
    self.navlabel.textColor=[UIColor whiteColor];
    self.lineLable.hidden=YES;
    self.img.hidden=YES;
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 20, 20)];
    img.image = [UIImage imageNamed:@"iconfont-p-back"];
    [_backBtn addSubview:img];
    self.backlable.backgroundColor=[UIColor colorWithRed:241/255.0f green:90/255.0f blue:90/255.0f alpha:1];
    page=1;
    dataSourceArray=[[NSMutableArray alloc]init];
    
    headeView=[[UIView alloc]initWithFrame:FRAME(0, 64, WIDTH, 180)];
    headeView.backgroundColor=[UIColor colorWithRed:241/255.0f green:90/255.0f blue:90/255.0f alpha:1];
    [self.view addSubview:headeView];
    [self HeadeViewLayout];
    myTableView=[[UITableView alloc]initWithFrame:FRAME(0, headeView.frame.size.height+64, WIDTH, HEIGHT-(headeView.frame.size.height+64))style:UITableViewStyleGrouped];
    myTableView.delegate=self;
    myTableView.dataSource=self;
    [self.view addSubview:myTableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [myTableView setTableFooterView:v];
    _refreshHeader = [[MJRefreshHeaderView alloc] init];
    _refreshHeader.delegate = self;
    _refreshHeader.scrollView = myTableView;
    
    _moreFooter = [[MJRefreshFooterView alloc] init];
    _moreFooter.delegate = self;
    _moreFooter.scrollView = myTableView;
    // Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self dataSourceLayout];
}
#pragma mark 头部试图布局
-(void)HeadeViewLayout
{
    UIView *view=[[UIView alloc]initWithFrame:FRAME(30/2, 30/2, WIDTH-30, 150)];
    view.backgroundColor=[UIColor whiteColor];
    view.layer.cornerRadius=5;
    view.clipsToBounds=YES;
    [headeView addSubview:view];
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.text=@"当前金币";
    titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    titleLabel.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    [titleLabel setNumberOfLines:1];
    [titleLabel sizeToFit];
    titleLabel.frame=FRAME(10, 36/2, titleLabel.frame.size.width, 15);
    [view addSubview:titleLabel];
    
    UIButton *markBut=[[UIButton alloc]initWithFrame:FRAME(view.frame.size.width-(titleLabel.frame.size.width+45), 24, (titleLabel.frame.size.width+30), 30)];
    [markBut addTarget:self action:@selector(markBut:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:markBut];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME(0, 5, 20, 20)];
    imageView.image=[UIImage imageNamed:@"iconfont-wenhao"];
    [markBut addSubview:imageView];
    
    UILabel *textLabel=[[UILabel alloc]initWithFrame:FRAME(30, 5, titleLabel.frame.size.width, 20)];
    textLabel.text=@"金币说明";
    textLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    textLabel.textColor=[UIColor colorWithRed:49/255.0f green:144/255.0f blue:232/255.0f alpha:1];
    [textLabel setNumberOfLines:1];
    [textLabel sizeToFit];
    [markBut addSubview:textLabel];
    
    UILabel *integralLabel=[[UILabel alloc]init];
    integralLabel.text=_productFractionStr;
    integralLabel.font=[UIFont fontWithName:@"Heiti SC" size:36];
    integralLabel.textColor=[UIColor colorWithRed:247/255.0f green:202/255.0f blue:44/255.0f alpha:1];
    [integralLabel setNumberOfLines:1];
    [integralLabel sizeToFit];
    integralLabel.frame=FRAME(10, titleLabel.frame.origin.y+37, integralLabel.frame.size.width, 40);
    [view addSubview:integralLabel];
    UILabel *label=[[UILabel alloc]initWithFrame:FRAME(integralLabel.frame.size.width+integralLabel.frame.origin.x, titleLabel.frame.origin.y+57, 20, 20)];
    label.font=[UIFont fontWithName:@"Heiti SC" size:17];
    label.textColor=[UIColor colorWithRed:247/255.0f green:202/255.0f blue:44/255.0f alpha:1];
    label.text=@"分";
    [view addSubview:label];
    
    UIButton *button=[[UIButton alloc]initWithFrame:FRAME(12, 100, view.frame.size.width-24, 42)];
    [button addTarget:self action:@selector(ButAction:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor=[UIColor colorWithRed:254/255.0f green:109/255.0f blue:71/255.0f alpha:1];
    [button setTitle:@"金币兑换商品" forState:UIControlStateNormal];
    button.layer.cornerRadius=5;
    button.clipsToBounds=YES;
    [view addSubview:button];
}
#pragma mark  积分说明按钮方法
-(void)markBut:(UIButton *)button
{
    WebPageViewController *webPageVC=[[WebPageViewController alloc]init];
    webPageVC.barIDS=100;
    webPageVC.webURL=[NSString stringWithFormat:@"http://123.57.173.36/simi-h5/show/score-intro.html"];
    [self.navigationController pushViewController:webPageVC animated:YES];
}
#pragma mark  积分兑换商品按钮方法
-(void)ButAction:(UIButton *)button
{
//    self.backlable.hidden=YES;
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSString *url=[NSString stringWithFormat:@"http://123.57.173.36/simi/app/user/score_shop.json?user_id=%@",_manager.telephone];
    CreditWebViewController *web=[[CreditWebViewController alloc]initWithUrl:url];//实际中需要改为带签名的地址
    //如果已经有UINavigationContoller了，就 创建出一个 CreditWebViewController 然后 push 进去
    [self.navigationController pushViewController:web animated:YES];
}
#pragma mark  积分明细列表数据请求方法
-(void)dataSourceLayout
{
    
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *_dict = @{@"user_id":_manager.telephone,@"page":pageStr};
    DownloadManager *_download = [[DownloadManager alloc]init];
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",USER_DETAILED_LIST] dict:_dict view:self.view delegate:self finishedSEL:@selector(SignSuccess:) isPost:NO failedSEL:@selector(SignFail:)];
}
#pragma mark 获取数据成功
-(void)SignSuccess:(id)dataSource
{
    int status=[[dataSource objectForKey:@"status"]intValue];
    if (status==0) {
        NSString *string=[NSString stringWithFormat:@"%@",[dataSource objectForKey:@"data"]];
        if (string==nil||string==NULL||[string isEqualToString:@"(\n)"]) {
            [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        }else{
            
            NSArray *array=[dataSource objectForKey:@"data"];
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

}
#pragma mark 获取数据失败
-(void)SignFail:(id)dataSource
{
    NSLog(@"读取金币明细列表失败:%@",dataSource);
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
    [self dataSourceLayout];
}
#pragma mark 表格刷新相关


#pragma mark - 列表组头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 50;
    
}
#pragma mark  列表组头view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    sectionView.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    UILabel *label=[[UILabel alloc]init];
    label.text=@"最近30天金币记录";
    label.lineBreakMode=NSLineBreakByTruncatingTail;
    [label setNumberOfLines:1];
    [label sizeToFit];
    label.textColor=[UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1];
    label.font=[UIFont fontWithName:@"Heiti SC" size:15];
    label.frame=FRAME(10,20, label.frame.size.width, 20);
    [sectionView addSubview:label];
    
    return sectionView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSourceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic=dataSourceArray[indexPath.row];
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:FRAME(20, 13, 100, 16)];
    titleLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"remarks"]];
    titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    titleLabel.textColor=[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
    [cell addSubview:titleLabel];
    
    
    int textId=[[dic objectForKey:@"is_consume"]intValue];
    UILabel *textLabel=[[UILabel alloc]init];
    if (textId==0) {
        textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"score"]];
        textLabel.textColor=[UIColor colorWithRed:92/255.0f green:189/255.0f blue:33/255.0f alpha:1];
    }else if (textId==1){
        textLabel.text=@"使用";
        textLabel.textColor=[UIColor colorWithRed:254/255.0f green:140/255.0f blue:28/255.0f alpha:1];
    }
    
    textLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    
    [textLabel setNumberOfLines:1];
    [textLabel sizeToFit];
    textLabel.frame=FRAME(WIDTH-textLabel.frame.size.width-18, 13, textLabel.frame.size.width, 16);
    [cell addSubview:textLabel];
    
    int  timeint=[[dic objectForKey:@"add_time"]intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeint];
    NSLog(@"1296035591  = %@",confromTimesp);
    NSString *timeStr = [formatter stringFromDate:confromTimesp];
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:FRAME(20, 39, WIDTH-40, 16)];
    timeLabel.text=[NSString stringWithFormat:@"%@",timeStr];
    timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    timeLabel.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    [cell addSubview:timeLabel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        dispatch_async(dispatch_get_main_queue(),^{
            [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        });
    }

    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [myTableView deselectRowAtIndexPath:indexPath animated:NO];
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
