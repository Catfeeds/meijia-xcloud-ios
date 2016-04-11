//
//  LeaveDetailsViewController.m
//  yxz
//
//  Created by 白玉林 on 16/1/28.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "LeaveDetailsViewController.h"

@interface LeaveDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,UIScrollViewDelegate>
{
    UITableView *myTableView;
    UIActivityIndicatorView *meView;
    
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    NSString *senderString;
    NSMutableArray *numberArray;
    
    
    UIScrollView *layoutView;
    UIImageView *headIMageView;
    UILabel *nameLabel;
    UILabel *auditLabel;
    UILabel *numberLabel;
    UILabel *sectorLabel;
    UILabel *typeLabel;
    UILabel *startLabel;
    UILabel *endLabel;
    UILabel *daysLabel;
    UILabel *contentLabel;
    UILabel *enclosureLabel;
    UILabel *imageLabel;
    UILabel *titleLabel;
    
    int W,K;
    int number_height,sector_height,type_height,start_height,end_height,days_height,content_height,enclosure_height;
    NSDictionary *sourceDic;
    UIButton *leftButton;
    UIButton *rightButton;
    
    NSArray *leave_typeArray;
    NSArray *imageArray;
}
@end

@implementation LeaveDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navlabel.text=@"请假审批";
    leave_typeArray=@[@"病假",@"事假",@"婚假",@"丧假",@"产假",@"年休假",@"其他"];
    imageArray=@[@"iconfont-shenpi-faqi",@"iconfont-shenpi-dengdai",@"iconfont-shenpi-tongyi",@"iconfont-shenpi-jujue",@"iconfont-shenpi-chexiao"];
    numberArray=[[NSMutableArray alloc]init];
    
    
    
    self.view.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [self viewLayout];
    [self tableViewLayout];
    titleLabel=[[UILabel alloc]init];
    titleLabel.text=@"审批进度";
    titleLabel.textColor=[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1];
    titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleLabel setNumberOfLines:1];
    [titleLabel sizeToFit];
    titleLabel.frame=FRAME(20, 334, titleLabel.frame.size.width, 30);
    [self.view addSubview:titleLabel];
    leftButton=[[UIButton alloc]initWithFrame:FRAME(0, HEIGHT-50, WIDTH/2-0.5, 50)];
    leftButton.backgroundColor=[UIColor colorWithRed:86/255.0f green:171/255.0f blue:228/255.0f alpha:1];
    if (_leaveVC_id==100) {
        [leftButton setTitle:@"" forState:UIControlStateNormal];
    }else if (_leaveVC_id==101){
        [leftButton setTitle:@"同意" forState:UIControlStateNormal];
    }
    leftButton.tag=1001;
    [leftButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    rightButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH/2+0.5, HEIGHT-50, WIDTH/2-0.5, 50)];
    rightButton.backgroundColor=[UIColor colorWithRed:242/255.0f green:153/255.0f blue:63/255.0f alpha:1];
    if (_leaveVC_id==100) {
        [rightButton setTitle:@"撤销" forState:UIControlStateNormal];
    }else if (_leaveVC_id==101){
        [rightButton setTitle:@"拒绝" forState:UIControlStateNormal];
    }
    rightButton.tag=1002;
    [rightButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}
-(void)viewLayout
{
    layoutView=[[UIScrollView alloc]initWithFrame:FRAME(0, 69, WIDTH, 265)];
    layoutView.bounces=NO;
    layoutView.showsVerticalScrollIndicator = FALSE;
    layoutView.showsHorizontalScrollIndicator = FALSE;
    layoutView.delegate=self;
    layoutView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:layoutView];
    headIMageView=[[UIImageView alloc]initWithFrame:FRAME(30, 10, 40, 40)];
    headIMageView.layer.cornerRadius=headIMageView.frame.size.width/2;
    headIMageView.clipsToBounds=YES;
    [layoutView addSubview:headIMageView];
    nameLabel=[[UILabel alloc]init];
    [layoutView addSubview:nameLabel];
    auditLabel=[[UILabel alloc]init];
    [layoutView addSubview:auditLabel];
    UIView *lineView=[[UIView alloc]initWithFrame:FRAME(10, 59, WIDTH-20, 1)];
    lineView.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [layoutView addSubview:lineView];
    int Y=lineView.frame.origin.y+11;
    NSArray *nameArray=@[@"审批编号:",@"所在部门:",@"请假类型:",@"开始时间:",@"结束时间:",@"请假天数:",@"请假事由:",@"附件:"];
    for (int i=0; i<nameArray.count; i++) {
        UILabel *label=[[UILabel alloc]init];
        label.text=[NSString stringWithFormat:@"%@",nameArray[i]];
        label.textColor=[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1];
        [label setNumberOfLines:1];
        [label sizeToFit];
        if (i!=7) {
            [layoutView addSubview:label];
        }
        
        switch (i) {
            case 0:
            {
                label.frame=FRAME(20, Y+25*i, label.frame.size.width, 20);
                number_height=Y+25*i;
                W=label.frame.size.width;
                numberLabel=[[UILabel alloc]init];
                [layoutView addSubview:numberLabel];
            }
                break;
            case 1:
            {
                label.frame=FRAME(20, Y+25*i, label.frame.size.width, 20);
                sector_height=Y+25*i;
                W=label.frame.size.width;
                sectorLabel=[[UILabel alloc]init];
                [layoutView addSubview:sectorLabel];
            }
                break;
            case 2:
            {
                label.frame=FRAME(20, Y+25*i, label.frame.size.width, 20);
                type_height=Y+25*i;
                W=label.frame.size.width;
                typeLabel=[[UILabel alloc]init];
                [layoutView addSubview:typeLabel];
            }
                break;
            case 3:
            {
                label.frame=FRAME(20, Y+25*i, label.frame.size.width, 20);
                start_height=Y+25*i;
                W=label.frame.size.width;
                startLabel=[[UILabel alloc]init];
                [layoutView addSubview:startLabel];
            }
                break;
            case 4:
            {
                label.frame=FRAME(20, Y+25*i, label.frame.size.width, 20);
                end_height=Y+25*i;
                W=label.frame.size.width;
                endLabel=[[UILabel alloc]init];
                [layoutView addSubview:endLabel];
            }
                break;
            case 5:
            {
                label.frame=FRAME(20, Y+25*i, label.frame.size.width, 20);
                days_height=Y+25*i;
                W=label.frame.size.width;
                daysLabel=[[UILabel alloc]init];
                [layoutView addSubview:daysLabel];
            }
                break;
            case 6:
            {
                label.frame=FRAME(20, Y+25*i, label.frame.size.width, 20);
                content_height=Y+25*i;
                W=label.frame.size.width;
                contentLabel=[[UILabel alloc]init];
                [layoutView addSubview:contentLabel];
            }
                break;
            case 7:
            {
                imageLabel=[[UILabel alloc]init];
                imageLabel.text=[NSString stringWithFormat:@"%@",nameArray[i]];
                imageLabel.textColor=[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1];
                [imageLabel setNumberOfLines:1];
                [imageLabel sizeToFit];
                imageLabel.frame=FRAME(20, Y+25*i, label.frame.size.width, 20);
                [layoutView addSubview:imageLabel];
                enclosure_height=Y+25*i;
                K=label.frame.size.width;
                enclosureLabel=[[UILabel alloc]init];
                [layoutView addSubview:enclosureLabel];
            }
                break;
            default:
                break;
        }
    }
    layoutView.contentSize=CGSizeMake(WIDTH, enclosure_height+30);
}
-(void)tableViewLayout
{
    myTableView=[[UITableView alloc]initWithFrame:FRAME(0, 364, WIDTH, HEIGHT-414)];
    myTableView.backgroundColor=[UIColor whiteColor];
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
    [self tableViewSource];

}
-(void)labelLayout
{
    
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[sourceDic objectForKey:@"head_img"]];
    [headIMageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
    
    nameLabel.text=[NSString stringWithFormat:@"%@",[sourceDic objectForKey:@"name"]];
    nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:20];
    [nameLabel setNumberOfLines:1];
    [nameLabel sizeToFit];
    nameLabel.frame=FRAME(90, 10, nameLabel.frame.size.width, 20);
    
    auditLabel.text=[NSString stringWithFormat:@"%@",[sourceDic objectForKey:@"status_name"]];
    auditLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    auditLabel.textColor=[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1];
    [auditLabel setNumberOfLines:1];
    [auditLabel sizeToFit];
    auditLabel.frame=FRAME(90, 35, auditLabel.frame.size.width, 15);
    
    numberLabel.text=@"";
    [numberLabel setNumberOfLines:1];
    [numberLabel sizeToFit];
    numberLabel.frame=FRAME(25+W, number_height, numberLabel.frame.size.width, 20);
    
    sectorLabel.text=@"";
    [sectorLabel setNumberOfLines:1];
    [sectorLabel sizeToFit];
    sectorLabel.frame=FRAME(25+W, sector_height, sectorLabel.frame.size.width, 20);
    
    int typeID=[[sourceDic objectForKey:@"leave_type"]intValue];
    typeLabel.text=[NSString stringWithFormat:@"%@",leave_typeArray[typeID]];
    [typeLabel setNumberOfLines:1];
    [typeLabel sizeToFit];
    typeLabel.frame=FRAME(25+W, type_height, typeLabel.frame.size.width, 20);
    
    startLabel.text=[NSString stringWithFormat:@"%@",[sourceDic objectForKey:@"start_date"]];
    [startLabel setNumberOfLines:1];
    [startLabel sizeToFit];
    startLabel.frame=FRAME(25+W, start_height, startLabel.frame.size.width, 20);
    
    endLabel.text=[NSString stringWithFormat:@"%@",[sourceDic objectForKey:@"end_date"]];
    [endLabel setNumberOfLines:1];
    [endLabel sizeToFit];
    endLabel.frame=FRAME(25+W, end_height, endLabel.frame.size.width, 20);
    
    daysLabel.text=[NSString stringWithFormat:@"%@",[sourceDic objectForKey:@"total_days"]];
    [daysLabel setNumberOfLines:1];
    [daysLabel sizeToFit];
    daysLabel.frame=FRAME(25+W, days_height, daysLabel.frame.size.width, 20);
    
    contentLabel.text=[NSString stringWithFormat:@"%@",[sourceDic objectForKey:@"remarks"]];
    UIFont *font=[UIFont fontWithName:@"Heiti SC" size:18];
    contentLabel.font=font;
    [contentLabel setNumberOfLines:0];
    [contentLabel sizeToFit];
    contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake(WIDTH-35-W, 200);
    CGSize expectSize = [contentLabel sizeThatFits:maximumLabelSize];
    contentLabel.frame=FRAME(25+W, content_height, expectSize.width, expectSize.height);
//    contentLabel.backgroundColor=[UIColor redColor];
    
    enclosureLabel.text=@"";
    [enclosureLabel setNumberOfLines:1];
    [enclosureLabel sizeToFit];
    enclosureLabel.frame=FRAME(25+W, content_height+expectSize.height+5, enclosureLabel.frame.size.width, 20);
    
    imageLabel.frame=FRAME(20, content_height+expectSize.height+5, K, 20);
    layoutView.contentSize=CGSizeMake(WIDTH, 20*8+5*7+expectSize.height+60);
    
}
-(void)tableViewSource
{
    ISLoginManager *manager = [[ISLoginManager alloc]init];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict=@{@"user_id":manager.telephone,@"leave_id":_leave_id};
    [_download requestWithUrl:USER_LEAVE_DETAILS dict:_dict view:self.view delegate:self finishedSEL:@selector(LeaveSuccess:) isPost:NO failedSEL:@selector(LeaveFail:)];
}
#pragma mark获取请假列表成功
-(void)LeaveSuccess:(id)Sourcedata
{
    NSLog(@"获取请假列表成功返回数据：%@",Sourcedata);
    senderString=[NSString stringWithFormat:@"%@",[Sourcedata objectForKey:@"data"]];
    if ([senderString isEqualToString:@""]) {
        [meView stopAnimating]; // 结束旋转
        [meView setHidesWhenStopped:YES]; //当旋转结束时隐藏
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        numberArray=nil;
    }else{
        sourceDic=[Sourcedata objectForKey:@"data"];
        NSArray *array=[sourceDic objectForKey:@"pass_users"];
        [numberArray removeAllObjects];
        for (int i=0; i<array.count; i++) {
            if ([numberArray containsObject:array[i]]) {
                    
                }else{
                    [numberArray addObject:array[i]];
                }
            }
        if (_leaveVC_id==100) {
            int status=[[sourceDic objectForKey:@"status"]intValue];
            if (status!=0) {
                leftButton.hidden=YES;
                rightButton.hidden=YES;
                myTableView.frame=FRAME(0, 364, WIDTH, HEIGHT-364);
            }else{
                leftButton.hidden=NO;
                rightButton.hidden=NO;
                myTableView.frame=FRAME(0, 364, WIDTH, HEIGHT-414);
            }

        }else if (_leaveVC_id==101){
             ISLoginManager *manager = [[ISLoginManager alloc]init];
            int status=[[sourceDic objectForKey:@"status"]intValue];
            if (status!=0) {
                leftButton.hidden=YES;
                rightButton.hidden=YES;
                myTableView.frame=FRAME(0, 364, WIDTH, HEIGHT-364);
            }else{
                for (int i=0; i<numberArray.count; i++) {
                    NSDictionary *dic=numberArray[i];
                    NSString *status_name=[NSString stringWithFormat:@"%@",[dic objectForKey:@"status_name"]];
                    NSString *user_Id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"user_id"]];
                    NSString *my_userid=[NSString stringWithFormat:@"%@",manager.telephone];
                    if ([user_Id isEqualToString:my_userid]) {
                        if ([status_name isEqualToString:@"审批中"]) {
                            leftButton.hidden=NO;
                            rightButton.hidden=NO;
                            myTableView.frame=FRAME(0, 364, WIDTH, HEIGHT-414);
                        }else{
                            leftButton.hidden=YES;
                            rightButton.hidden=YES;
                            myTableView.frame=FRAME(0, 364, WIDTH, HEIGHT-364);
                        }
                    }
                }

            }
        }
        [myTableView reloadData];
        [self labelLayout];
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
    NSString *status_name=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"status_name"]];
    NSString *status=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"status"]];
    UIImageView *headimageView=[[UIImageView alloc]initWithFrame:FRAME(30, 5, 30, 30)];
//    NSString *imageUrl=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"head_img"]];
//    [headimageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
    if ([status_name isEqualToString:@"发起审批"]) {
        headimageView.image=[UIImage imageNamed:imageArray[0]];
    }else if ([status isEqualToString:@"0"]){
        headimageView.image=[UIImage imageNamed:imageArray[1]];
    }else if ([status isEqualToString:@"1"]){
        headimageView.image=[UIImage imageNamed:imageArray[2]];
    }else if ([status isEqualToString:@"2"]){
        headimageView.image=[UIImage imageNamed:imageArray[3]];
    }else if ([status isEqualToString:@"3"]){
        headimageView.image=[UIImage imageNamed:imageArray[4]];
    }
    headimageView.layer.cornerRadius=headimageView.frame.size.width/2;
    headimageView.clipsToBounds=YES;
    [cell addSubview:headimageView];
    
    UILabel *labelName=[[UILabel alloc]init];
    labelName.text=[NSString stringWithFormat:@"%@  %@",[dataDic objectForKey:@"name"],[dataDic objectForKey:@"status_name"]];
    [labelName setNumberOfLines:1];
    [labelName sizeToFit];
    labelName.frame=FRAME(80, 10, labelName.frame.size.width, 20);
    [cell addSubview:labelName];
    
    UILabel *timeLabel=[[UILabel alloc]init];
    timeLabel.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"add_time_str"]];
    timeLabel.textColor=[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1];
    timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    [timeLabel setNumberOfLines:1];
    [timeLabel sizeToFit];
    timeLabel.frame=FRAME(WIDTH-10-timeLabel.frame.size.width, 45/2, timeLabel.frame.size.width, 15);
    [cell addSubview:timeLabel];
    
    UIView *upperView=[[UIView alloc]initWithFrame:FRAME(30+(30-1)/2, 0, 1, 5)];
    upperView.backgroundColor=[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1];
    [cell addSubview:upperView];
    if (indexPath.row==0) {
        upperView.hidden=YES;
    }else{
        upperView.hidden=NO;
    }
    UIView *lowerView=[[UIView alloc]initWithFrame:FRAME(30+(30-1)/2, 35, 1, 5)];
    lowerView.backgroundColor=[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1];
    [cell addSubview:lowerView];
    if (indexPath.row==numberArray.count-1) {
        lowerView.hidden=YES;
    }else{
        lowerView.hidden=NO;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [myTableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark底部按钮点击方法
-(void)buttonAction:(UIButton *)button
{
    switch (button.tag) {
        case 1001:
        {
            if (_leaveVC_id==100) {
                
            }else if(_leaveVC_id==101){
                ISLoginManager *manager = [[ISLoginManager alloc]init];
                DownloadManager *_download = [[DownloadManager alloc]init];
                NSDictionary *_dict=@{@"pass_user_id":manager.telephone,@"leave_id":_leave_id,@"status":@"1"};
                [_download requestWithUrl:USER_LEAVE_AUDIT dict:_dict view:self.view delegate:self finishedSEL:@selector(AuditSuccess:) isPost:YES failedSEL:@selector(AuditFail:)];
            }
        }
            break;
        case 1002:
        {
            if (_leaveVC_id==100) {
                ISLoginManager *manager = [[ISLoginManager alloc]init];
                DownloadManager *_download = [[DownloadManager alloc]init];
                NSDictionary *_dict=@{@"user_id":manager.telephone,@"leave_id":_leave_id};
                [_download requestWithUrl:USER_LEAVE_REVOKE dict:_dict view:self.view delegate:self finishedSEL:@selector(RevokeSuccess:) isPost:YES failedSEL:@selector(RevokeFail:)];
            }else if(_leaveVC_id==101){
                ISLoginManager *manager = [[ISLoginManager alloc]init];
                DownloadManager *_download = [[DownloadManager alloc]init];
                NSDictionary *_dict=@{@"pass_user_id":manager.telephone,@"leave_id":_leave_id,@"status":@"2"};
                [_download requestWithUrl:USER_LEAVE_AUDIT dict:_dict view:self.view delegate:self finishedSEL:@selector(AuditSuccess:) isPost:YES failedSEL:@selector(AuditFail:)];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark审批接口成功返回
-(void)AuditSuccess:(id)auditData
{
    [self tableViewSource];
    [self backAction];
}
#pragma mark审批接口失败返回
-(void)AuditFail:(id)auditData
{
    NSLog(@"审批接口失败返回数据:%@",auditData);
}
#pragma mark撤销接口成功返回
-(void)RevokeSuccess:(id)revokeData
{
    [self backAction];
}
#pragma mark撤销接口失败返回
-(void)RevokeFail:(id)revokeData
{
    NSLog(@"审批接口失败返回数据:%@",revokeData);
}

-(void)todoSomething
{
    [self.navigationController popViewControllerAnimated:YES];
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
