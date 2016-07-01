//
//  DynamicViewController.m
//  yxz
//
//  Created by 白玉林 on 15/12/14.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "DynamicViewController.h"
#import "DynamicTableViewCell.h"
#import "Dynamic_DetailsViewController.h"
@interface DynamicViewController ()
{
    int arrayID;
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    NSInteger   page;

}
@end

@implementation DynamicViewController
{
    NSMutableArray *dataSourceArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    page=1;
    dataSourceArray=[[NSMutableArray alloc]init];
    self.view.frame=FRAME(0, 0, WIDTH, HEIGHT-50);
//    self.backBtn.hidden=YES;
//    self.navlabel.text=@"动态";
    if (_vcLayoutID==100) {
        _tableView=[[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT-HEIGHT*0.43-106)];
    }else{
        _tableView=[[UITableView alloc]initWithFrame:FRAME(0, 110, WIDTH, HEIGHT-110)];
    }
    
    [self.view addSubview:_tableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [_tableView setTableFooterView:v];
    _refreshHeader = [[MJRefreshHeaderView alloc] init];
    _refreshHeader.delegate = self;
    _refreshHeader.scrollView = _tableView;
    
    _moreFooter = [[MJRefreshFooterView alloc] init];
    _moreFooter.delegate = self;
    _moreFooter.scrollView = _tableView;
    [self portData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_needRefresh) {
        [_refreshHeader beginRefreshing];
        _needRefresh = NO;
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [self portData];
}
-(void)portData
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *dic;
    NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];

    if (_vcLayoutID==100) {
        dic=@{@"user_id":_friendID,@"feed_from":@"1",@"page":pageStr};
    }else{
        dic=@{@"user_id":_manager.telephone,@"feed_from":@"0",@"page":pageStr};
    }
    [_download requestWithUrl:DYNAMIC_CARD dict:dic view:self.view delegate:self finishedSEL:@selector(ProtSuccess:) isPost:NO failedSEL:@selector(ProtFailure:)];
}
#pragma mark 获取动态列表数据成功
-(void)ProtSuccess:(id)dataSource
{
    NSLog(@"获取动态列表数据成功:%@",dataSource);
//    dataSourceArray=[dataSource objectForKey:@"data"];
    NSString *string=[NSString stringWithFormat:@"%@",[dataSource objectForKey:@"data"]];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    if (string==nil||string==NULL||[string isEqualToString:@""]) {
        arrayID=100;
    }else{
        
        NSArray *array=[dataSource objectForKey:@"data"];
        if (array.count<10) {
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

        [_tableView reloadData];
    }

}
#pragma mark 获取动态列表数据失败
-(void)ProtFailure:(id)dataSource
{
    NSLog(@"获取动态列表数据失败:%@",dataSource);
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
    
    [self portData];
    
    
    
}
#pragma mark 表格刷新相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (arrayID==100) {
        return 0;
    }
    return dataSourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDic=dataSourceArray[indexPath.row];
    NSString *identifier =[NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    DynamicTableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
    
    UIView *lineView=[[UIView alloc]init];
    UIView *view=[[UIView alloc]init];
    if (cell == nil) {
        cell = [[DynamicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
        [cell addSubview:lineView];
        [cell addSubview:view];
        //        [cell setImageVIew:[UIImage imageNamed:@"SYCELL_HEAD_CY_@2x"] setLabel:@"18:00和刘总晚餐" label:@"刚刚" promptLabel:@"麻辣诱惑"];
    }
    NSString *url=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"head_img"]];
    [cell.headeImageView setImageWithURL:[NSURL URLWithString:url]placeholderImage:nil];
//    cell.headeImageView.image=headeIamgeArray[indexPath.row];
    cell.titleLabel.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"name"]];
    [cell.titleLabel setNumberOfLines:1];
    [cell.titleLabel sizeToFit];
    cell.timeLabel.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"add_time_str"]];
    [cell.timeLabel setNumberOfLines:1];
    [cell.timeLabel sizeToFit];
    cell.textLabels.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"title"]];
    cell.textLabels.lineBreakMode=NSLineBreakByTruncatingTail;
    [cell.textLabels setNumberOfLines:2];
    [cell.textLabels sizeToFit];
    UIFont *font=[UIFont fontWithName:@"Heiti SC" size:17];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize size = [cell.textLabels.text boundingRectWithSize:CGSizeMake(WIDTH-40, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    NSArray *arrayImage=[dataDic objectForKey:@"feed_imgs"];
    NSLog(@"图片%@",arrayImage);
    int H=0;
    if (arrayImage.count==0) {
        H=0;
    }else if (arrayImage.count==1){
        H=(WIDTH-50)/3+20;
        NSString *urlStr=[NSString stringWithFormat:@"%@",[arrayImage[0] objectForKey:@"img_middle"]];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME(20, 71+size.height, (WIDTH-50)/3*2, (WIDTH-50)/3)];
        [imageView setImageWithURL:[NSURL URLWithString:urlStr]placeholderImage:nil];
        [cell addSubview:imageView];
    }else if (arrayImage.count==4){
        H=(WIDTH-50)/3*2+25;
        int X=0;
        int Y=71+size.height;
        for (int i=0; i<arrayImage.count; i++) {
            if (i==2) {
                X=0;
                Y=Y+(WIDTH-50)/3+5;
            }
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME(20+((WIDTH-50)/3+5)*X, Y, (WIDTH-50)/3, (WIDTH-50)/3)];
            NSString *urlStr=[NSString stringWithFormat:@"%@",[arrayImage[i] objectForKey:@"img_small"]];
            [imageView setImageWithURL:[NSURL URLWithString:urlStr]placeholderImage:nil];
            [cell addSubview:imageView];
            X++;
        }
       
    }else{
        if (arrayImage.count<4){
            H=(WIDTH-50)/3+20;
        }else if (arrayImage.count>4&&arrayImage.count<7){
            H=(WIDTH-50)/3*2+25;
        }else if (arrayImage.count==7||arrayImage.count>7){
            H=(WIDTH-50)/3*3+25;
        }
        int X=0;
        int Y=71+size.height;
        for (int i=0; i<arrayImage.count; i++) {
            if (i%3==0&&i!=0) {
                X=0;
                Y=Y+(WIDTH-50)/3+5;
            }
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME(20+((WIDTH-50)/3+5)*X, Y, (WIDTH-50)/3, (WIDTH-50)/3)];
            NSString *urlStr=[NSString stringWithFormat:@"%@",[arrayImage[i] objectForKey:@"img_small"]];
            [imageView setImageWithURL:[NSURL URLWithString:urlStr]placeholderImage:nil];
            [cell addSubview:imageView];
            X++;
        }

    }

    NSLog(@"%d",H);
    lineView.frame=FRAME(0, 71+size.height+H, WIDTH, 1);
    lineView.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    
    view.frame=FRAME(0, 71+size.height+H+40, WIDTH, 10);
    view.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    
    UIView *shangline=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 1)];
    shangline.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    [view addSubview:shangline];
    UIView *xiaLine=[[UIView alloc]initWithFrame:FRAME(0, 9, WIDTH, 1)];
    xiaLine.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    [view addSubview:xiaLine];
    
    NSArray *array=@[@"common_icon_like_c@2x(1)",@"common_icon_review@2x(1)",@"common_icon_share@2x(1)"];
    UIButton *zaButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 72+size.height+H, WIDTH/3-0.5, 40)];
    UIImageView *zaImageView=[[UIImageView alloc]initWithFrame:FRAME((zaButton.frame.size.width-20)/2-5, 10, 20, 20)];
    zaImageView.image=[UIImage imageNamed:array[0]];
    [zaButton addSubview:zaImageView];
    [zaButton setTag:indexPath.row];
    [zaButton addTarget:self action:@selector(zaButtonan:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:zaButton];
    UILabel *zaLabel=[[UILabel alloc]init];
    zaLabel.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"total_zan"]];
    zaLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
    [zaLabel setNumberOfLines:1];
    [zaLabel sizeToFit];
    zaLabel.frame=FRAME(zaImageView.frame.size.width+zaImageView.frame.origin.x, zaImageView.frame.origin.y, zaLabel.frame.size.width, 20);
    [zaButton addSubview:zaLabel];
    
    UIButton *plButton=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH/3*1+0.5, 72+size.height+H, WIDTH/3-1, 40)];
    UIImageView *plImageView=[[UIImageView alloc]initWithFrame:FRAME((plButton.frame.size.width-20)/2-5, 10, 20, 20)];
    plImageView.image=[UIImage imageNamed:array[1]];
    [plButton addSubview:plImageView];
    [plButton setTag:indexPath.row];
    [plButton addTarget:self action:@selector(plButtonan:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:plButton];
    UILabel *plLabel=[[UILabel alloc]init];
    plLabel.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"total_comment"]];
    plLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
    [plLabel setNumberOfLines:1];
    [plLabel sizeToFit];
    plLabel.frame=FRAME(plImageView.frame.size.width+plImageView.frame.origin.x, plImageView.frame.origin.y, plLabel.frame.size.width, 20);
    [plButton addSubview:plLabel];
    
    UIButton *fxButton=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH/3*2-0.5, 72+size.height+H, WIDTH/3-0.5, 40)];
    UIImageView *fxImageView=[[UIImageView alloc]initWithFrame:FRAME((fxButton.frame.size.width-20)/2, 10, 20, 20)];
    fxImageView.image=[UIImage imageNamed:array[2]];
    [fxButton addSubview:fxImageView];
    [fxButton setTag:indexPath.row];
    [fxButton addTarget:self action:@selector(fxButtonan:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:fxButton];
    for (int i=0; i<2; i++) {
        UIView *lineView=[[UIView alloc]initWithFrame:FRAME(WIDTH/3-0.5+WIDTH/3*i, 82+size.height+H, 1, 20)];
        lineView.backgroundColor=[UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1];
        [cell addSubview:lineView];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDic=dataSourceArray[indexPath.row];
    NSArray *array=[dataDic objectForKey:@"feed_imgs"];
    int H=0;
    if (array.count<4&&array.count>0){
        H=(WIDTH-50)/3+20;
    }else if (array.count>4&&array.count<7){
        H=(WIDTH-50)/3*2+25;
    }else if (array.count==7||array.count>7){
        H=(WIDTH-50)/3*3+25;
    }else if(array.count==4){
        H=(WIDTH-50)/3*2+25;
    }
    NSString *string=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"title"]];
    DynamicTableViewCell *cell =[[DynamicTableViewCell alloc]init];
    UIFont *font=[UIFont fontWithName:@"Heiti SC" size:18];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize size = [string boundingRectWithSize:CGSizeMake(WIDTH-40, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return cell.layoutView.frame.size.height+size.height+H;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dyDic=dataSourceArray[indexPath.row];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    Dynamic_DetailsViewController *dyVC=[[Dynamic_DetailsViewController alloc]init];
    dyVC.dyNamicID=[NSString stringWithFormat:@"%@",[dyDic objectForKey:@"fid"]];
    [self.navigationController pushViewController:dyVC animated:YES];
}
-(void)zaButtonan:(UIButton *)sender
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSString *fidStr=[dataSourceArray[sender.tag]objectForKey:@"fid"];
    NSDictionary *_dict = @{@"fid":fidStr,@"user_id":_manager.telephone};
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:DYNAMIC_SHARE dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadDA:) isPost:YES failedSEL:@selector(DZDownFail:)];
    
}


-(void)logDowLoadDA:(id)sender
{
    NSLog(@"点赞成功");
    [self portData];
}
-(void)DZDownFail:(id)sender
{
    NSLog(@"点赞失败");
}

-(void)plButtonan:(UIButton *)sender
{
    NSDictionary *dyDic=dataSourceArray[sender.tag];
    Dynamic_DetailsViewController *dyVC=[[Dynamic_DetailsViewController alloc]init];
    dyVC.dyNamicID=[NSString stringWithFormat:@"%@",[dyDic objectForKey:@"fid"]];
    [self.navigationController pushViewController:dyVC animated:YES];
}
-(void)fxButtonan:(UIButton *)sender
{
    [UMSocialWechatHandler setWXAppId:@"wx93aa45d30bf6cba3" appSecret:@"7a4ec42a0c548c6e39ce9ed25cbc6bd7" url:Handlers];
    [UMSocialQQHandler setQQWithAppId:@"1104934408" appKey:@"bRW2glhUCR6aJYIZ" url:QQHandlerss];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"247547429" RedirectURL:SSOHandlers];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:YMAPPKEY shareText:@"菠萝HR，企业行政服务第一平台！极大降低企业行政管理成本，有效提升行政综合服务能力，快来试试吧！体验就送礼哦：http://51xingzheng.cn/h5-app-download.html" shareImage:[UIImage imageNamed:@"yunxingzheng-Logo-512.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina,nil] delegate:self];
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
