//
//  ApplyFriendsListViewController.m
//  yxz
//
//  Created by 白玉林 on 16/2/22.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "ApplyFriendsListViewController.h"
#import "FriendsApprovalDetailsViewController.h"
@interface ApplyFriendsListViewController ()
{
    UITableView *myTableView;
    NSMutableArray *dataArray;
    
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    NSInteger   page;
    
}
@end

@implementation ApplyFriendsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_vcID==100) {
        self.backBtn.hidden=NO;
        self.navlabel.text=@"好友申请";
    }else{
        self.backBtn.hidden=YES;
    }
    page=1;
    dataArray=[[NSMutableArray alloc]init];
    myTableView=[[UITableView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-101)];
    myTableView.dataSource=self;
    myTableView.delegate=self;
    [self.view addSubview:myTableView];
    self.view.backgroundColor=[UIColor whiteColor];
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
-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self dataLayout];
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
    [self dataLayout];
}
-(void)dataLayout
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *_dict = @{@"user_id":_manager.telephone,@"page":pageStr};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:USER_APPLYFRIENDS dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
}
-(void)logDowLoadFinish:(id)sender
{
    //    secretArray=[sender objectForKey:@"data"];
    NSString *senderStr=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    NSLog(@"%lu",(unsigned long)[senderStr length]);
    
    if (senderStr==nil||senderStr==NULL||[senderStr isEqualToString:@"(\n)"]||[senderStr length]==0) {
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }
    [dataArray removeAllObjects];
    NSArray *array=[sender objectForKey:@"data"];
    for (int i=0; i<array.count; i++) {
        if ([dataArray containsObject:array[i]]) {
            
        }else{
            [dataArray addObject:array[i]];
        }
    }
    [myTableView reloadData];
    NSLog(@"好友列表数据%@",sender);
}
-(void)DownFail:(id)sender
{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDic=dataArray[indexPath.row];
    NSString *identifier = [NSString stringWithFormat:@"cell%ld,%ld",(long)indexPath.row,(long)indexPath.section];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        dispatch_async(dispatch_get_main_queue(),^{
            [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        });
    }
    UIImageView *headeImageView=[[UIImageView alloc]initWithFrame:FRAME(10, 10, 40, 40)];
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"head_img"]];
    [headeImageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
    headeImageView.layer.cornerRadius=headeImageView.frame.size.width/2;
    headeImageView.clipsToBounds=YES;
    [cell addSubview:headeImageView];
    UILabel *nameLabel=[[UILabel alloc]init];
    nameLabel.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"name"]];
    nameLabel.font=[UIFont fontWithName:@"Arial" size:16];
    [nameLabel setNumberOfLines:1];
    [nameLabel sizeToFit];
    nameLabel.frame=FRAME(headeImageView.frame.size.width+20, 20, nameLabel.frame.size.width, 20);
    [cell addSubview:nameLabel];
    
    int statusID=[[dataDic objectForKey:@"status"]intValue];
    int req_typeID=[[dataDic objectForKey:@"req_type"]intValue];
    if (req_typeID==0) {
        UILabel *addLabel=[[UILabel alloc]initWithFrame:FRAME(WIDTH-70, 15, 60, 30)];
        if (statusID==0) {
            addLabel.text=@"申请中";
        }else if (statusID==1){
            addLabel.text=@"已同意";
        }else{
            addLabel.text=@"被拒绝";
        }
        addLabel.textColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
        addLabel.font=[UIFont fontWithName:@"Arial" size:18];
        [cell addSubview:addLabel];
    }else{
        UIButton *addButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-70, 15, 60, 30)];
        if (statusID==0) {
            addButton.enabled=TRUE;
            [addButton.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
            [addButton.layer setCornerRadius:5];
            [addButton.layer setBorderWidth:1];//设置边界的宽度
            //设置按钮的边界颜色
            CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
            CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){1,0,0,1});
            [addButton.layer setBorderColor:color];
            [addButton setTitle:@"添加" forState:UIControlStateNormal];
            [addButton setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
        }else{
            [addButton setTitle:@"已添加" forState:UIControlStateNormal];
            [addButton setTitleColor:[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1] forState:UIControlStateNormal];
            addButton.enabled=FALSE;
        }
        addButton.titleLabel.font=[UIFont fontWithName:@"Arial" size:18];
        addButton.tag=indexPath.row;
        [addButton addTarget:self action:@selector(addButAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:addButton];
    }
    
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    PageTableViewCell *cell =[[PageTableViewCell alloc]init];
    //    return cell.view.frame.size.height;
    return 61;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [myTableView deselectRowAtIndexPath:indexPath animated:NO];
//    FriendsApprovalDetailsViewController *friendsVC=[[FriendsApprovalDetailsViewController alloc]init];
//    [self.navigationController pushViewController:friendsVC animated:YES];
}
-(void)addButAction:(UIButton *)button
{
    NSDictionary *addDic=dataArray[button.tag];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *friend_id=[NSString stringWithFormat:@"%@",[addDic objectForKey:@"friend_id"]];
    NSDictionary *_dict = @{@"user_id":_manager.telephone,@"friend_id":friend_id,@"status":@"1"};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:USER_CHECK_FRIENDS_LIST dict:_dict view:self.view delegate:self finishedSEL:@selector(FriendsAddFinish:) isPost:YES failedSEL:@selector(FriendsAddFail:)];
}
-(void)FriendsAddFinish:(id)source
{
    [self dataLayout];
}
-(void)FriendsAddFail:(id)source
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
