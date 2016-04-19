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
#import "Order_DetailsViewController.h"
#import "HairTableViewCell.h"
@interface WasteRecoveryViewController ()
{
    UITableView *myTableView;
    NSMutableArray *dataSourceArray;
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    NSInteger   page;
    int  pushID;
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
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
    CGRect tmpRect = [self.navlabel.text boundingRectWithSize:CGSizeMake(WIDTH, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil] context:nil];
    self.helpBut.hidden=NO;
    self.helpBut.frame=FRAME((WIDTH-tmpRect.size.width)/2, 20, tmpRect.size.width+20, 44);
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:FRAME(self.helpBut.frame.size.width-20, 12, 20, 20)];
    image.image=[UIImage imageNamed:@"iconfont_yingyongbangzhu"];
    [self.helpBut addSubview:image];

    _navlabel.textColor = [UIColor whiteColor];
    self.img.hidden=YES;
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 20, 20)];
    img.image = [UIImage imageNamed:@"iconfont-p-back"];
    [_backBtn addSubview:img];
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
        [wasteBut setTitle:@"一键预约" forState:UIControlStateNormal];
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
        [referBut setTitle:@"智能配置" forState:UIControlStateNormal];
    }else if (_wasteID==102){
        [referBut setTitle:@"团建记录" forState:UIControlStateNormal];
    }else if (_wasteID==103){
        [referBut setTitle:@"叫快递" forState:UIControlStateNormal];
    }
    
    referBut.tag=1002;
    [referBut addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
    [butView addSubview:referBut];
    // Do any additional setup after loading the view.
}
-(void)butAction:(UIButton *)button
{
    if (button.tag==1001) {
        pushID=1000;
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
        webPageVC.barIDS=100;
        if (_wasteID==100) {
            webPageVC.webURL=@"http://123.57.173.36/simi-h5/show/recycle-price.html";//废品回收参考价格跳转URL
            [self.navigationController pushViewController:webPageVC animated:YES];
        }else if (_wasteID==101){
            webPageVC.webURL=@"http://123.57.173.36/simi-h5/show/clean-set.html";//保洁智能设置跳转URL
            [self.navigationController pushViewController:webPageVC animated:YES];
        }else if (_wasteID==102){
//            webPageVC.webURL=@"http://123.57.173.36/simi-h5/show/teamwork-set.html";//团建智能设置跳转URL
            
            ISLoginManager *_manager = [ISLoginManager shareManager];
            NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
            NSDictionary *_dict = @{@"user_id":_manager.telephone,@"page":pageStr};
            DownloadManager *_download = [[DownloadManager alloc]init];
            [_download requestWithUrl:[NSString stringWithFormat:@"%@",LWAGYEBUILDING_LIST] dict:_dict view:self.view delegate:self finishedSEL:@selector(addDressSuccess:) isPost:NO failedSEL:@selector(addDressFail:)];
            pushID=104;
        }else if (_wasteID==103){
            webPageVC.webURL=@"http://m.kuaidi100.com/courier/search.jsp";//团建智能设置跳转URL
            [self.navigationController pushViewController:webPageVC animated:YES];
        }
        
        
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
        NSDictionary *_dict = @{@"user_id":_manager.telephone,@"page":pageStr,@"service_type_id":@"79"};
        [_download requestWithUrl:[NSString stringWithFormat:@"%@",COMPANY_LIST] dict:_dict view:self.view delegate:self finishedSEL:@selector(addDressSuccess:) isPost:NO failedSEL:@selector(addDressFail:)];
    }else if (_wasteID==103){
        [_download requestWithUrl:[NSString stringWithFormat:@"%@",EXPRESS_ORDER_LIST] dict:_dict view:self.view delegate:self finishedSEL:@selector(addDressSuccess:) isPost:NO failedSEL:@selector(addDressFail:)];
    }
    
    
}
#pragma mark默认班次数据成功方法
-(void)addDressSuccess:(id)source
{
    NSLog(@"快递，保洁，团建，废品回收数据:%@",source);
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
    pushID=1000;
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
    int  hed=0;
    if (_wasteID==100||_wasteID==101||_wasteID==103||pushID==104) {
        hed=120;
    }else{
        hed=250;
    }
    return hed;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(_wasteID==100||_wasteID==101||_wasteID==103||pushID==104){
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
        moneyLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        [moneyLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
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
        stateLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
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
        UILabel *waterLabel=[[UILabel alloc]initWithFrame:FRAME(moneyLabel.frame.origin.x, 80, WIDTH-(imageView.frame.size.width+40), 20)];
        waterLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        waterLabel.text=[NSString stringWithFormat:@"下单时间:%@",[dic objectForKey:@"add_time_str"]];
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
        //    button.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        //    [button addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
        //    [Cell addSubview:button];
        return Cell;
    }else{
        NSDictionary *dic=dataSourceArray[indexPath.row];
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
        
        
//        UILabel *moneyLabel=[[UILabel alloc]initWithFrame:FRAME(textLabel.frame.size.width+10, 10, WIDTH-textLabel.frame.size.width-20, 20)];
//        moneyLabel.text=[NSString stringWithFormat:@"价钱:%@",[dic objectForKey:@"dis_price"]];
//        moneyLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
//        moneyLabel.textColor=[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1];
//        [moneyLabel setNumberOfLines:1];
//        moneyLabel.textAlignment=NSTextAlignmentRight;
//        [Cell.labelView addSubview:moneyLabel];
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
    if(_wasteID==100||_wasteID==101||pushID==104){
        NSDictionary *dic=dataSourceArray[indexPath.row];
        Order_DetailsViewController *order_vc=[[Order_DetailsViewController alloc]init];
        order_vc.order_ID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"order_id"]];
        order_vc.user_ID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"user_id"]];
        [self.navigationController pushViewController:order_vc animated:YES];
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
