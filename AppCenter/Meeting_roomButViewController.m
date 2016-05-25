//
//  Meeting_roomButViewController.m
//  yxz
//
//  Created by 白玉林 on 16/2/25.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "Meeting_roomButViewController.h"

@interface Meeting_roomButViewController ()
{
    UITableView *myTableView;
    NSMutableArray *dataArray;
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    NSInteger   page;
    NSString *senderStr;
    
    int  cellID;
}
@end

@implementation Meeting_roomButViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navlabel.text=@"会议室";
    cellID=-1;
    dataArray =[[NSMutableArray alloc]init];
    page=1;
    myTableView=[[UITableView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    myTableView.dataSource=self;
    myTableView.delegate=self;
    //    myTableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [self.view addSubview:myTableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor=[UIColor whiteColor];
    [myTableView setTableFooterView:v];
    _refreshHeader = [[MJRefreshHeaderView alloc] init];
    _refreshHeader.delegate = self;
    _refreshHeader.scrollView = myTableView;
    
    _moreFooter = [[MJRefreshFooterView alloc] init];
    _moreFooter.delegate = self;
    _moreFooter.scrollView = myTableView;
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *company_id=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"company_id"]];
    if(company_id==nil||company_id==NULL||[company_id isEqualToString:@""])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self PLJKLayout];

    // Do any additional setup after loading the view.
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
-(void)PLJKLayout
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager*_download = [[DownloadManager alloc]init];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *company_id=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"company_id"]];
    //    NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary*_dict =@{@"user_id":_manager.telephone,@"setting_type":@"meeting-room",@"company_id":company_id};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:MEETING_ROOM dict:_dict view:self.view  delegate:self finishedSEL:@selector(Meeting_roomSuccess:) isPost:NO failedSEL:@selector(Meeting_roomFail:)];
}
-(void)Meeting_roomSuccess:(id)sender
{
    NSLog(@"会议室数据:%@",sender);
    senderStr=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    if (senderStr==nil||senderStr==NULL||[senderStr isEqualToString:@"(\n)"]||[senderStr length]==0) {
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        
    }else{
        NSArray *array=[sender objectForKey:@"data"];
        if (array.count<10) {
            _hasMore=YES;
        }else{
            _hasMore=NO;
        }
        if (page==1) {
            [dataArray removeAllObjects];
            [dataArray addObjectsFromArray:array];
            
            
           
            
        }else{
            for (int i=0; i<array.count; i++) {
                if ([dataArray containsObject:array[i]]) {
                    
                }else{
                    
                    [dataArray addObject:array[i]];
                }
            }
        }
        
    }
    if (dataArray.count==0) {
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }
    
    [myTableView reloadData];
}
-(void)Meeting_roomFail:(id)sender
{
    NSLog(@"erroe is %@",sender);
    [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}



//绘制Cell

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary*dataDic=dataArray[indexPath.row];
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell%ld,%ld",(long)indexPath.row,(long)indexPath.section];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        dispatch_async(dispatch_get_main_queue(),^{
            [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        });
    }
    if (cellID==indexPath.row) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    UILabel *nameLabel=[[UILabel alloc]init];
    nameLabel.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"name"]];
    nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    [nameLabel setNumberOfLines:1];
    [nameLabel sizeToFit];
    nameLabel.frame=FRAME(20, 20, nameLabel.frame.size.width, 20);
    [cell addSubview:nameLabel];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=dataArray[indexPath.row];
    [myTableView deselectRowAtIndexPath:indexPath animated:NO];
    cellID=(int)indexPath.row;
    _textFieldString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    [myTableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
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
