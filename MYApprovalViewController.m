//
//  MYApprovalViewController.m
//  yxz
//
//  Created by 白玉林 on 16/1/28.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "MYApprovalViewController.h"
#import "LeaveDetailsViewController.h"
#import "ApplyForLeaveViewController.h"
@interface MYApprovalViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *myTableView;
    UIActivityIndicatorView *meView;
    
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    NSInteger   page;
    NSString *senderString;
    NSMutableArray *numberArray;
}
@end

@implementation MYApprovalViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    page=1;
    self.navlabel.text=@"请假审批";
    self.tyPeStr=@"leave_pass";
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
    CGRect tmpRect = [self.navlabel.text boundingRectWithSize:CGSizeMake(WIDTH, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil] context:nil];
    self.helpBut.hidden=NO;
    self.helpBut.frame=FRAME((WIDTH-tmpRect.size.width)/2, 20, tmpRect.size.width+20, 44);
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:FRAME(self.helpBut.frame.size.width-20, 12, 20, 20)];
    image.image=[UIImage imageNamed:@"iconfont_yingyongbangzhu"];
    [self.helpBut addSubview:image];
    self.backlable.backgroundColor=HEX_TO_UICOLOR(0x11cd6e, 1.0);
    _navlabel.textColor = [UIColor whiteColor];
    self.img.hidden=YES;
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 20, 20)];
    img.image = [UIImage imageNamed:@"iconfont-p-back"];
    [_backBtn addSubview:img];
    UIButton *eyeButton=[[UIButton alloc]initWithFrame:FRAME(14, HEIGHT-46, WIDTH-28, 41)];
    eyeButton.backgroundColor=self.backlable.backgroundColor;
    eyeButton.layer.cornerRadius=5;
    eyeButton.clipsToBounds=YES;
    [eyeButton addTarget:self action:@selector(eyeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [eyeButton setTitle:@"新建" forState:UIControlStateNormal];
    [self.view addSubview:eyeButton];
    numberArray=[[NSMutableArray alloc]init];
    myTableView=[[UITableView alloc]initWithFrame:FRAME(0, 106, WIDTH, HEIGHT-152)];
    myTableView.dataSource=self;
    myTableView.delegate=self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [myTableView setTableFooterView:v];
    meView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    meView.center = CGPointMake(WIDTH/2, HEIGHT/2);
    meView.color = [UIColor redColor];
    [self.view addSubview:meView];
    [meView startAnimating];// Do any additional setup after loading the view.
    
    _refreshHeader = [[MJRefreshHeaderView alloc] init];
    _refreshHeader.delegate = self;
    _refreshHeader.scrollView = myTableView;
    
    _moreFooter = [[MJRefreshFooterView alloc] init];
    _moreFooter.delegate = self;
    _moreFooter.scrollView = myTableView;
}
-(void)eyeButtonAction
{
    ApplyForLeaveViewController *applyVC=[[ApplyForLeaveViewController alloc]init];
    applyVC.colorid=100;
    [self.navigationController pushViewController:applyVC animated:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self tableViewSource];
}
-(void)tableViewSource
{
    NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
    ISLoginManager *manager = [[ISLoginManager alloc]init];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict=@{@"user_id":manager.telephone,@"leave_from":@"1",@"page":pageStr};
    [_download requestWithUrl:USER_LEAVE_LIST dict:_dict view:self.view delegate:self finishedSEL:@selector(LeaveSuccess:) isPost:NO failedSEL:@selector(LeaveFail:)];
}
#pragma mark获取请假列表成功
-(void)LeaveSuccess:(id)Sourcedata
{
    NSLog(@"获取请假列表成功返回数据：%@",Sourcedata);
    senderString=[NSString stringWithFormat:@"%@",[Sourcedata objectForKey:@"data"]];
    if ([senderString isEqualToString:@""]||[senderString isEqualToString:@"(\n)"]) {
        [meView stopAnimating]; // 结束旋转
        [meView setHidesWhenStopped:YES]; //当旋转结束时隐藏
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        numberArray=nil;
    }else{
        NSArray *array=[Sourcedata objectForKey:@"data"];
        if (array.count<10*page) {
            _hasMore=YES;
            [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        }else{
            _hasMore=NO;
        }
        if (page==1) {
            [numberArray removeAllObjects];
            [numberArray addObjectsFromArray:array];
        }else{
            for (int i=0; i<array.count; i++) {
                if ([numberArray containsObject:array[i]]) {
                    
                }else{
                    [numberArray addObject:array[i]];
                }
            }
            
        }
        [myTableView reloadData];
    }

}
#pragma mark获取请假列表失败
-(void)LeaveFail:(id)Sourcedata
{
    NSLog(@"获取请假列表失败返回数据：%@",Sourcedata);
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
    
    [self tableViewSource];
    
    
    
}
#pragma mark 表格刷新相关

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return numberArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDic=numberArray[indexPath.row];
    NSString *identifier = [NSString stringWithFormat:@"cell%ld,%ld",(long)indexPath.row,(long)indexPath.section];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
    }
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        dispatch_async(dispatch_get_main_queue(),^{
            [meView stopAnimating]; // 结束旋转
            [meView setHidesWhenStopped:YES]; //当旋转结束时隐藏
            [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        });
    }
    UIImageView *headimageView=[[UIImageView alloc]initWithFrame:FRAME(10, 20, 40, 40)];
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"head_img"]];
    [headimageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
    headimageView.layer.cornerRadius=headimageView.frame.size.width/2;
    headimageView.clipsToBounds=YES;
    [cell addSubview:headimageView];
    
    UILabel *nameLabel=[[UILabel alloc]init];
    nameLabel.text=[NSString stringWithFormat:@"%@的请假",[dataDic objectForKey:@"name"]];
    [nameLabel setNumberOfLines:1];
    [nameLabel sizeToFit];
    nameLabel.frame=FRAME(60, 15, nameLabel.frame.size.width, 20);
    [cell addSubview:nameLabel];
    
    UILabel *timeLabel=[[UILabel alloc]init];
    timeLabel.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"add_time_str"]];
    timeLabel.textColor=[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1];
    timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    [timeLabel setNumberOfLines:1];
    [timeLabel sizeToFit];
    timeLabel.frame=FRAME(WIDTH-10-timeLabel.frame.size.width, 15, timeLabel.frame.size.width, 15);
    [cell addSubview:timeLabel];
    
    UILabel *textLabel=[[UILabel alloc]init];
    textLabel.textColor=[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1];
    textLabel.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"status_name"]];
    textLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    [textLabel setNumberOfLines:1];
    [textLabel sizeToFit];
    textLabel.frame=FRAME(60, 50, textLabel.frame.size.width, 15);
    [cell addSubview:textLabel];
    
    UIView *cellLineView=[[UIView alloc]initWithFrame:FRAME(0, 80, WIDTH, 1)];
    cellLineView.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f  blue:232/255.0f  alpha:1];
    [cell addSubview:cellLineView];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [myTableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dataDic=numberArray[indexPath.row];
    LeaveDetailsViewController *leaveDetailsVC=[[LeaveDetailsViewController alloc]init];
    leaveDetailsVC.leave_id=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"leave_id"]];
    leaveDetailsVC.leaveVC_id=101;
    [self.navigationController pushViewController:leaveDetailsVC animated:YES];
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
