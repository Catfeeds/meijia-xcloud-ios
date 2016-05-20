//
//  WaterListViewController.m
//  yxz
//
//  Created by 白玉林 on 16/3/2.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "WaterListViewController.h"
#import "WaterOrderViewController.h"
#import "Order_DetailsViewController.h"
#import "HairTableViewCell.h"
#import "foundWebViewController.h"
@interface WaterListViewController ()
{
    UIActivityIndicatorView *view;
    NSString *nameString;
    NSString *compID;
    UILabel *promptLabel;
    NSString *weekString;
    UILabel *nameLabel;
    UILabel *weekLabel;
    UITableView *myTableView;
    NSMutableArray *dataSourceArray;
    NSString *urlString;
    
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    NSInteger   page;
    int  pushID;
}
@end

@implementation WaterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navlabel.text=_titleName;
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
    CGRect tmpRect = [self.navlabel.text boundingRectWithSize:CGSizeMake(WIDTH, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil] context:nil];
    self.helpBut.hidden=NO;
    self.helpBut.frame=FRAME((WIDTH-tmpRect.size.width)/2, 20, tmpRect.size.width+20, 44);
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:FRAME(self.helpBut.frame.size.width-20, 12, 20, 20)];
    image.image=[UIImage imageNamed:@"iconfont_yingyongbangzhu"];
    [self.helpBut addSubview:image];

    _navlabel.textColor = [UIColor whiteColor];
    self.backlable.backgroundColor=HEX_TO_UICOLOR(0x56abe4, 1.0);
    self.img.hidden=YES;
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 20, 20)];
    img.image = [UIImage imageNamed:@"iconfont-p-back"];
    [_backBtn addSubview:img];
    dataSourceArray=[[NSMutableArray alloc]init];
    page=1;
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期六",@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五", nil];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit |NSWeekdayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    int week = (int)[comps weekday]%7;
    weekString=[NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:week]];
    
    [self tableViewLayout];
    [self viewLayout];

    // Do any additional setup after loading the view.
}
-(void)tableViewLayout
{
    myTableView=[[UITableView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-114)];
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
    if (pushID==111) {
        ISLoginManager *_manager = [ISLoginManager shareManager];
        NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
        NSDictionary *_dict = @{@"user_id":_manager.telephone,@"page":pageStr};
        
        DownloadManager *_download = [[DownloadManager alloc]init];
        [_download requestWithUrl:[NSString stringWithFormat:@"%@",ORDER_ORDER_LIST] dict:_dict view:self.view delegate:self finishedSEL:@selector(addDressSuccess:) isPost:NO failedSEL:@selector(addDressFail:)];
    }else{
        ISLoginManager *_manager = [ISLoginManager shareManager];
        NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *_dict = @{@"user_id":_manager.telephone,@"page":pageStr,@"service_type_id":@"239"};
        [_download requestWithUrl:[NSString stringWithFormat:@"%@",COMPANY_LIST] dict:_dict view:self.view delegate:self finishedSEL:@selector(addDressSuccess:) isPost:NO failedSEL:@selector(addDressFail:)];
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
        [dataSourceArray removeAllObjects];
        [myTableView reloadData];
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
       
        [self nameLabelLayout];
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
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.navlabel.text];
    pushID=1000;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self defaultInterfaceLayout];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.navlabel.text];
}

-(void)viewLayout
{
    UIView *attendanceView=[[UIView alloc]initWithFrame:FRAME(0, 64, WIDTH, 100)];
    attendanceView.backgroundColor=[UIColor colorWithRed:89/255.0f green:181/255.0f blue:218/255.0f alpha:1];
//    [self.view addSubview:attendanceView];
    nameLabel=[[UILabel alloc]init];//WithFrame:FRAME(20, 20, <#w#>, <#h#>)
    [self nameLabelLayout];
    [attendanceView addSubview:nameLabel];
    
    weekLabel=[[UILabel alloc]init];
    [self weekLaelLayout];
    [attendanceView addSubview:weekLabel];
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    
    UILabel *timeLabel=[[UILabel alloc]init];
    timeLabel.text=[dateformatter stringFromDate:senddate];
    timeLabel.textAlignment=NSTextAlignmentLeft;
    timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:18];
    [timeLabel setNumberOfLines:1];
    [timeLabel sizeToFit];
    timeLabel.frame=FRAME(20, 75, timeLabel.frame.size.width, 22);
    timeLabel.textColor=[UIColor whiteColor];
    [attendanceView addSubview:timeLabel];
    
    UIButton *signButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-100, 33, 90, 35)];
    signButton.backgroundColor=[UIColor whiteColor];
    signButton.layer.cornerRadius=5;
    [signButton setTitle:@"一键结算" forState:UIControlStateNormal];
    signButton.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:18];
    [signButton addTarget:self action:@selector(signBut) forControlEvents:UIControlEventTouchUpInside];
    [signButton setTitleColor:[UIColor colorWithRed:89/255.0f green:181/255.0f blue:218/255.0f alpha:1] forState:UIControlStateNormal];
    [attendanceView addSubview:signButton];
    
    UIView *butView=[[UIView alloc]initWithFrame:FRAME(0, HEIGHT-56, WIDTH, 56)];
    butView.backgroundColor=self.backlable.backgroundColor;
    [self.view addSubview:butView];
    UIButton *wasteBut=[[UIButton alloc]initWithFrame:FRAME(0, 0, WIDTH/2-0.5, 56)];
    [wasteBut setTitle:@"一键送水" forState:UIControlStateNormal];
    wasteBut.tag=1001;
    [wasteBut addTarget:self action:@selector(butViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [butView addSubview:wasteBut];
    UIView *verticalView=[[UIView alloc]initWithFrame:FRAME(WIDTH/2-0.5, 10, 1, 36)];
    verticalView.backgroundColor=[UIColor whiteColor];
    [butView addSubview:verticalView];
    UIButton *referBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH/2+0.5, 0, WIDTH/2-0.5, 56)];
    [referBut setTitle:@"服务记录" forState:UIControlStateNormal];
    referBut.tag=1002;
    [referBut addTarget:self action:@selector(butViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [butView addSubview:referBut];
    
}
-(void)butViewAction:(UIButton *)button
{
    if (button.tag==1001) {
        pushID=1000;
        WaterOrderViewController *waterVC=[[WaterOrderViewController alloc]init];
        [self.navigationController pushViewController:waterVC animated:YES];
    }else{
        pushID=111;
        page=1;
        [self defaultInterfaceLayout];
    }
}
-(void)signBut
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    urlString=[NSString stringWithFormat:@"http://123.57.173.36/simi-h5/show/checkin-index.html?user_id=%@",_manager.telephone];
}
-(void)nameLabelLayout
{
    nameLabel.text=nameString;
    nameLabel.textAlignment=NSTextAlignmentLeft;
    nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:18];
    [nameLabel setNumberOfLines:1];
    [nameLabel sizeToFit];
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.frame=FRAME(20, 10, nameLabel.frame.size.width, 22);
    
}
-(void)weekLaelLayout
{
    weekLabel.text=weekString;
    weekLabel.textAlignment=NSTextAlignmentLeft;
    weekLabel.font=[UIFont fontWithName:@"Heiti SC" size:35];
    [weekLabel setNumberOfLines:1];
    [weekLabel sizeToFit];
    weekLabel.textColor=[UIColor whiteColor];
    weekLabel.frame=FRAME(20, 35, weekLabel.frame.size.width, 38);
    
}
//-(void)attendBut
//{
//    WaterOrderViewController *waterVC=[[WaterOrderViewController alloc]init];
//    [self.navigationController pushViewController:waterVC animated:YES];
//}
-(void)timerFireMethod
{
    promptLabel.hidden=YES;
}
-(void)companyBut
{
    
}
#pragma mark用户信息详情获取成功方法
-(void)QJDowLoadFinish:(id)sender
{
    NSLog(@"数据详情%@",sender);
    NSDictionary *dic=[sender objectForKey:@"data"];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.globalDic=@{@"user_id":[dic objectForKey:@"id"],@"sec_id":[dic objectForKey:@"sec_id"],@"is_senior":[dic objectForKey:@"is_senior"],@"senior_range":[dic objectForKey:@"senior_range"],@"mobile":[dic objectForKey:@"mobile"],@"user_type":[dic objectForKey:@"user_type"],@"name":[dic objectForKey:@"name"],@"has_company":[dic objectForKey:@"has_company"],@"head_img":[dic objectForKey:@"head_img"],@"company_id":[dic objectForKey:@"company_id"],@"company_name":[dic objectForKey:@"company_name"]};
    NSLog(@"看看是什么啊%@",delegate.globalDic);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark用户信息详情获取失败方法
-(void)QJDownFail:(id)sender
{
    NSLog(@"%@",sender);
    
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
    if (pushID==111) {
        return 120;
    }else{
       return 250;
    }
    return 0;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=dataSourceArray[indexPath.row];
    if (pushID==111) {
        NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
        UITableViewCell *Cell = [tableView cellForRowAtIndexPath:indexPath];
        if (Cell == nil) {
            Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
        }
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME(20, 25, 70, 70)];
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"img_url"]];
        [imageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];;
        [Cell addSubview:imageView];
        UILabel *moneyLabel=[[UILabel alloc]initWithFrame:FRAME(imageView.frame.size.width+30, 20, WIDTH-(imageView.frame.size.width+100), 20)];
        moneyLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        [moneyLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        moneyLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_price_name"]];
        [Cell addSubview:moneyLabel];
        UILabel *stateLabel=[[UILabel alloc]init];
        stateLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        int dis_price=[[dic objectForKey:@"dis_price"]intValue];
        int the_number=[[dic objectForKey:@"service_num"]intValue];
        int monetStr=dis_price*the_number;
        stateLabel.text=[NSString stringWithFormat:@"订单金额:%@",[dic objectForKey:@"order_pay"]];
        [stateLabel setNumberOfLines:1];
        [stateLabel sizeToFit];
        stateLabel.frame=FRAME(moneyLabel.frame.origin.x, 50, stateLabel.frame.size.width, 20);
        [Cell addSubview:stateLabel];
        
        UILabel *label=[[UILabel alloc]initWithFrame:FRAME(stateLabel.frame.origin.x+stateLabel.frame.size.width+10, 50, 30, 20)];
        label.font=[UIFont fontWithName:@"Heiti SC" size:15];
        label.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"order_status_name"]];
        [Cell addSubview:label];
        
        UILabel *waterLabel=[[UILabel alloc]initWithFrame:FRAME(moneyLabel.frame.origin.x, 80, moneyLabel.frame.size.width, 20)];
        waterLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        waterLabel.text=[NSString stringWithFormat:@"下单时间:%@",[dic objectForKey:@"add_time_str"]];
        [Cell addSubview:waterLabel];
        [Cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        int  order_ext_status=[[dic objectForKey:@"order_ext_status"]intValue];
        UIButton *button=[[UIButton alloc]initWithFrame:FRAME(WIDTH-60, 45, 50, 30)];
        button.backgroundColor=[UIColor colorWithRed:89/255.0f green:181/255.0f blue:218/255.0f alpha:1];
        if (order_ext_status==2) {
            [button setTitle:@"已签收" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1] forState:UIControlStateNormal];
        }else{
            [button setTitle:@"签收" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
            //end of loading
            dispatch_async(dispatch_get_main_queue(),^{
                [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
                [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            });
        }
        
        button.tag=indexPath.row;
        button.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        [button addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
        [Cell addSubview:button];
        return Cell;
    }else{
        NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
        UILabel *textLabel=[[UILabel alloc]init];
        HairTableViewCell *Cell = [tableView cellForRowAtIndexPath:indexPath];
        if (Cell == nil) {
            Cell = [[HairTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
        }
        
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"img_url"]];
        [Cell.pictureImageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
        textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        textLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        textLabel.textColor=[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1];
        //        [textLabel setNumberOfLines:1];
        //        [textLabel sizeToFit];
        textLabel.textAlignment=NSTextAlignmentCenter;
        textLabel.frame=FRAME(10, 10, WIDTH-20, 20);
        [Cell.labelView addSubview:textLabel];
        
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
            //end of loading
            dispatch_async(dispatch_get_main_queue(),^{
                [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
                [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            });
        }
        return Cell;
    }
   
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(pushID==111){
        NSDictionary *dic=dataSourceArray[indexPath.row];
        Order_DetailsViewController *order_vc=[[Order_DetailsViewController alloc]init];
        order_vc.order_ID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"order_id"]];
        order_vc.user_ID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"user_id"]];
        [self.navigationController pushViewController:order_vc animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        foundWebViewController *_controller = [[foundWebViewController alloc]init];
        _controller.moneystring = @"0";
        NSDictionary *dic=dataSourceArray[indexPath.row];
        NSString *dayString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        _controller.buyString=dayString;
        _controller.moneyStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"dis_price"]];
        _controller.cardTypeID=1;
        _controller.service_type_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_type_id"]];
        _controller.service_price_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_price_id"]];
        _controller.sec_ID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"partner_user_id"]];
        _controller.addssID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"is_addr"]];
        _controller.zeroDic=dic;
        _controller.imgurl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"detail_url"]];
        _controller.goto_type=@"h5+list";
        _controller.titleName=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        NSString  *str=[NSString stringWithFormat:@"%@",[dic objectForKey:@"detail_url"]];
        if (str==nil||str==NULL||[str isEqualToString:@""]) {
            
        }else{
            [self.navigationController pushViewController:_controller animated:YES];
            
        }
        
    }

//    NSDictionary *dic=dataSourceArray[indexPath.row];
//    Order_DetailsViewController *order_vc=[[Order_DetailsViewController alloc]init];
//    order_vc.order_ID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"order_id"]];
//    order_vc.user_ID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"user_id"]];
//    [self.navigationController pushViewController:order_vc animated:YES];
}

-(void)butAction:(UIButton *)button
{
    NSDictionary *dic=dataSourceArray[button.tag];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    
    NSDictionary *_dict = @{@"user_id":_manager.telephone,@"order_id":[dic objectForKey:@"order_id"]};
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",WATER_LIST_SIGN] dict:_dict view:self.view delegate:self finishedSEL:@selector(order_signSuccess:) isPost:YES failedSEL:@selector(order_signFail:)];
}
-(void)order_signSuccess:(id)source
{
    [self defaultInterfaceLayout];
}
-(void)order_signFail:(id)source
{
    
}

-(void)todoSomething
{
    if (pushID==111) {
        pushID=1000;
        [self defaultInterfaceLayout];
        page=1;
    }else{
        ISLoginManager *_manager = [ISLoginManager shareManager];
        NSLog(@"有值么%@",_manager.telephone);
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *_dict=@{@"user_id":_manager.telephone};
        [_download requestWithUrl:USER_INFO dict:_dict view:self.view delegate:self finishedSEL:@selector(QJDowLoadFinish:) isPost:NO failedSEL:@selector(QJDownFail:)];
//        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)backAction
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething) object:nil];
    [self performSelector:@selector(todoSomething) withObject:nil afterDelay:0.2f];
    
    //    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    
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
