//
//  ask_listDetailsViewController.m
//  yxz
//
//  Created by 白玉林 on 16/6/4.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "ask_listDetailsViewController.h"
#import "ask_listDetailsTableViewCell.h"
#import "myAskTextViewController.h"
@interface ask_listDetailsViewController ()
{
    UITableView *myTableView;
    UIView *tableHeaderView;
    NSMutableArray *dataArray;
    
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    int   page;
    
    UIButton *closeBut;
    NSDictionary *detailsDic;
    UIButton *askBut;
}
@end

@implementation ask_listDetailsViewController

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString* msg = [[NSString alloc] initWithFormat:@"%ld",(long)buttonIndex];
    
    if ([msg isEqualToString:@"0"]) {
        ISLoginManager *_manager = [ISLoginManager shareManager];
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSString *fidStr=[NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"fid"]];
        NSDictionary *dic=@{@"user_id":_manager.telephone,@"fid":fidStr,@"feed_type":@"2"};
        [_download requestWithUrl:[NSString stringWithFormat:@"%@",COMMENT_CLOSE] dict:dic view:self.view delegate:self finishedSEL:@selector(CloseSuccess:) isPost:YES failedSEL:@selector(CloseFail:)];
    }
}
-(void)closeAction
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定关闭此问题？（问题关闭之后将不会收到新的答案）"  delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"返回",nil];
    [alert show];
    
}
-(void)CloseSuccess:(id)source
{
    [self commentLayout];
}
-(void)CloseFail:(id)source
{
    NSLog(@"%@",source);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    closeBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH-80, 20, 80, 44)];
    [closeBut setTitle:@"关闭问题" forState:UIControlStateNormal];
    [closeBut setTitleColor:[UIColor colorWithRed:42/255.0f green:142/255.0f blue:241/255.0f alpha:1] forState:UIControlStateNormal];
    [closeBut addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    closeBut.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    [self.view addSubview:closeBut];
    
    page=1;
    dataArray=[[NSMutableArray alloc]init];
    self.navlabel.text=[NSString stringWithFormat:@"%@的提问",[_dataDic objectForKey:@"name"]];
    myTableView=[[UITableView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-110)];
    myTableView.dataSource=self;
    myTableView.delegate=self;
    myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    _refreshHeader = [[MJRefreshHeaderView alloc] init];
    _refreshHeader.delegate = self;
    _refreshHeader.scrollView = myTableView;
    
    _moreFooter = [[MJRefreshFooterView alloc] init];
    _moreFooter.delegate = self;
    _moreFooter.scrollView = myTableView;
    
    tableHeaderView=[[UIView alloc]init];
    tableHeaderView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:tableHeaderView];
    
    if (_vcID==100) {
        
    }else{
        [self headeView];
    }
    
    askBut=[[UIButton alloc]initWithFrame:FRAME(14, HEIGHT-44, WIDTH-28, 40)];
    askBut.backgroundColor=[UIColor colorWithRed:35/255.0f green:140/255.0f blue:253/255.0f alpha:1];
    [askBut setTitle:@"我来回答" forState:UIControlStateNormal];
    askBut.layer.cornerRadius=8;
    askBut.clipsToBounds=YES;
    [askBut addTarget:self action:@selector(askButAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:askBut];
    
    // Do any additional setup after loading the view.
}
-(void)commentLayout
{
//    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *fidStr;
    if (_vcID==100) {
        fidStr=[NSString stringWithFormat:@"%@",_msg_id];
    }else{
        fidStr=[NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"fid"]];
    }
    NSDictionary *dic=@{@"fid":fidStr,@"feed_type":@"2"};
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",DYNAMIC_DETAILS] dict:dic view:self.view delegate:self finishedSEL:@selector(DetailsSuccess:) isPost:NO failedSEL:@selector(DetailseFail:)];
}
-(void)headeView
{
    if (_vcID==100) {
        _dataDic=detailsDic;
        self.navlabel.text=[NSString stringWithFormat:@"%@的提问",[_dataDic objectForKey:@"name"]];
    }
    UILabel *askLabbel=[[UILabel alloc]init];
    askLabbel.text=@"问：";
    askLabbel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    askLabbel.textColor=[UIColor colorWithRed:42/255.0f green:142/255.0f blue:241/255.0f alpha:1];
    [askLabbel setNumberOfLines:1];
    [askLabbel sizeToFit];
    askLabbel.frame=FRAME(10, 10, askLabbel.frame.size.width, 20);
    [tableHeaderView addSubview:askLabbel];
    NSString *feed_extra=[NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"feed_extra"]];
    UIImageView *goleImageView;
    UILabel *goleLabel;
    if (feed_extra==nil||feed_extra==NULL||[feed_extra isEqualToString:@""]||[feed_extra isEqualToString:@"0"]) {
        
    }else{
        goleImageView=[[UIImageView alloc]initWithFrame:FRAME(10+askLabbel.frame.size.width, 10, 20, 20)];
        goleImageView.image=[UIImage imageNamed:@"金币(1)"];
        [tableHeaderView addSubview:goleImageView];
        goleLabel=[[UILabel alloc]init];
        goleLabel.text=[NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"feed_extra"]];
        goleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        goleLabel.textColor=[UIColor colorWithRed:234/255.0f green:149/255.0f blue:24/255.0f alpha:1];
        [goleLabel setNumberOfLines:1];
        [goleLabel sizeToFit];
        goleLabel.frame=FRAME(30+goleImageView.frame.size.width, 10, goleLabel.frame.size.width, 20);
        [tableHeaderView addSubview:goleLabel];
    }
    
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.text=[NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"title"]];
    titleLabel.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:15];
    
    UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:15];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize size = [titleLabel.text boundingRectWithSize:CGSizeMake(WIDTH-(10+askLabbel.frame.size.width+goleLabel.frame.size.width+10), 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    [titleLabel setNumberOfLines:0];
    [titleLabel sizeToFit];
    if (feed_extra==nil||feed_extra==NULL||[feed_extra isEqualToString:@""]||[feed_extra isEqualToString:@"0"]) {
        titleLabel.frame=FRAME(10+askLabbel.frame.size.width, 10, WIDTH-(10+askLabbel.frame.size.width+10), size.height);
    }else{
        titleLabel.frame=FRAME(goleLabel.frame.origin.x+goleLabel.frame.size.width+10, 10, WIDTH-(goleLabel.frame.origin.x+goleLabel.frame.size.width+10), size.height);
    }
    //    titleLabel.backgroundColor=[UIColor redColor];
    [tableHeaderView addSubview:titleLabel];
    
    
    
    
    UILabel *timeLabel=[[UILabel alloc]init];
    timeLabel.text=[NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"add_time_str"]];
    timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    timeLabel.textColor=[UIColor colorWithRed:157/255.0f green:157/255.0f blue:157/255.0f alpha:1];
    [timeLabel setNumberOfLines:1];
    [timeLabel sizeToFit];
    timeLabel.frame=FRAME(10, 20+size.height, timeLabel.frame.size.width, 15);
    [tableHeaderView addSubview:timeLabel];
    
    UILabel *answerLabel=[[UILabel alloc]init];
    answerLabel.text=[NSString stringWithFormat:@"%@个答案",[_dataDic objectForKey:@"total_comment"]];
    answerLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    answerLabel.textColor=[UIColor colorWithRed:157/255.0f green:157/255.0f blue:157/255.0f alpha:1];
    [answerLabel setNumberOfLines:1];
    [answerLabel sizeToFit];
    answerLabel.frame=FRAME(WIDTH-answerLabel.frame.size.width-10, 20+size.height, answerLabel.frame.size.width, 15);
    [tableHeaderView addSubview:answerLabel];
    
    UIView *view=[[UIView alloc]initWithFrame:FRAME(0, answerLabel.frame.origin.y+25, WIDTH, 10)];
    view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    [tableHeaderView addSubview:view];
    
    tableHeaderView.frame=FRAME(0, 0, WIDTH, view.frame.origin.y+10);
    myTableView.tableHeaderView=tableHeaderView;
}
-(void)DetailsSuccess:(id)source
{
    detailsDic=[source objectForKey:@"data"];
    if (_vcID==100) {
        _dataDic=detailsDic;
    }
    ISLoginManager *_manager = [ISLoginManager shareManager];
    int user_id=[_manager.telephone intValue];
    int ask_user_id=[[NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"user_id"]]intValue];
    int status=[[NSString stringWithFormat:@"%@",[detailsDic objectForKey:@"status"]]intValue];
    if (user_id==ask_user_id) {
        if(status==0||status==1){
             closeBut.hidden=NO;
        }else{
            askBut.enabled=FALSE;
            [askBut setTitle:@"问题已关闭" forState:UIControlStateNormal];
            askBut.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
            [askBut setTitleColor:[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1] forState:UIControlStateNormal];
             closeBut.hidden=YES;
        }
       
    }else{
        if(status==0||status==1){
            closeBut.hidden=NO;
        }else{
            askBut.enabled=FALSE;
            [askBut setTitle:@"问题已关闭" forState:UIControlStateNormal];
            askBut.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
            [askBut setTitleColor:[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1] forState:UIControlStateNormal];
            closeBut.hidden=YES;
        }
        closeBut.hidden=YES;
    }
    if (_vcID==100) {
        [self headeView];
    }
    [self interfaceLayout];
}
-(void)DetailseFail:(id)source
{
    
}
#pragma mark 我来回答按钮点击事件
-(void)askButAction
{
    if (self.loginYesOrNo) {
        myAskTextViewController *myAskVC=[[myAskTextViewController alloc]init];
        myAskVC.dataDic=_dataDic;
        [self.navigationController presentViewController:myAskVC animated:YES completion:nil];
    }else{
        if (self.loginYesOrNo) {
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                MyLogInViewController *loginViewController = [[MyLogInViewController alloc] init];
                loginViewController.vCYMID=100;
                UMComNavigationController *navigationController = [[UMComNavigationController alloc] initWithRootViewController:loginViewController];
                [self presentViewController:navigationController animated:YES completion:^{
                }];
            });
        }
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self commentLayout];
}
-(void)interfaceLayout
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *fidStr=[NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"fid"]];
    NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *dict;
    if (self.loginYesOrNo) {
        dict=@{@"user_id":_manager.telephone,@"fid":fidStr,@"feed_type":@"2",@"page":pageStr};
    }else{
        dict=@{@"fid":fidStr,@"feed_type":@"2",@"page":pageStr};
    }
  
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",DYNAMIC_COM_CARD] dict:dict view:self.view delegate:self finishedSEL:@selector(InterFaceSuccess:) isPost:NO failedSEL:@selector(InterFaceFail:)];
}
#pragma mark 问答详情页面列表接口成功返回
-(void)InterFaceSuccess:(id)dataSource
{
    NSLog(@"问答详情页面列表接口成功返回%@",dataSource);
    NSString *senderStr=[NSString stringWithFormat:@"%@",[dataSource objectForKey:@"data"]];
    NSLog(@"%lu",(unsigned long)[senderStr length]);
    
    if (senderStr==nil||senderStr==NULL||[senderStr isEqualToString:@"(\n)"]||[senderStr length]==0) {
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }else{
        if(page==1){
            [dataArray removeAllObjects];
        }
        NSLog(@"获取问答列表成功数据%@",dataSource);
        NSArray *array=[dataSource objectForKey:@"data"];
        if (array.count<10) {
            _hasMore=YES;
        }else{
            _hasMore=NO;
        }
        
        for (int i=0; i<array.count; i++) {
            NSDictionary *dict=array[i];
            if ([dataArray containsObject:dict]) {
                [dataArray removeObject:dict];
                [dataArray addObject:dict];
            }else{
                [dataArray addObject:dict];
            }
        }
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        
        [myTableView reloadData];
    }
}
#pragma mark 问答详情页面列表接口失败返回
-(void)InterFaceFail:(id)dataSource
{
    NSLog(@"问答详情页面列表接口失败返回%@",dataSource);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic=dataArray[indexPath.row];
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    ask_listDetailsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ask_listDetailsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        dispatch_async(dispatch_get_main_queue(),^{
            [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        });
    }
    cell.headeImageStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"head_img"]];
    cell.nameStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    cell.timeStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"add_time_str"]];
    cell.titleStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"comment"]];
    NSString *zanstr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"is_zan"]];
    int zan=[zanstr intValue];
    if (zan==0) {
        
        cell.zanImageStr=@"赞-点击前";
    }else{
        cell.zanImageStr=@"赞-点击后";
    }
    cell.zanStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"total_zan"]];
    [cell.zanBut addTarget:self action:@selector(zanButAcyion:) forControlEvents:UIControlEventTouchUpInside];
    cell.zanBut.tag=indexPath.row;
    int status=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]]intValue];
    cell.adoptBut.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSString *userId=_manager.telephone;
    NSString *cellUserId=[NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"user_id"]];
    int user_id,celluser_id;
    user_id=[userId intValue];
    celluser_id=[cellUserId intValue];
    int details_id=[[NSString stringWithFormat:@"%@",[detailsDic objectForKey:@"status"]]intValue];
    if (self.loginYesOrNo) {
        cell.adoptLabel.hidden=YES;
    }else{
        if (status==0) {
            
        }else{
            cell.adoptLabel.hidden=NO;
            cell.adoptLabel.text=@"已采纳";
            cell.adoptLabel.layer.borderColor=[[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1]CGColor];
        }
        
    }
    if (details_id==0) {
        if (user_id==celluser_id) {
            cell.adoptBut.hidden=NO;
        }else{
            cell.adoptBut.hidden=YES;
        }
        
    }else if(details_id==1){
        if (user_id==celluser_id) {
            if (status==0) {
                cell.adoptBut.hidden=YES;
            }else{
                cell.adoptBut.hidden=NO;
            }
            
        }else{
            
            cell.adoptBut.hidden=YES;
            if (status==0) {
                
            }else{
                cell.adoptLabel.hidden=NO;
                cell.adoptLabel.text=@"已采纳";
                cell.adoptLabel.layer.borderColor=[[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1]CGColor];
            }
        }
    }else{
        cell.adoptBut.hidden=YES;
    }
    
    if (status==0) {
        [cell.adoptBut setTitle:@"采纳" forState:UIControlStateNormal];
        [cell.adoptBut setTitleColor:[UIColor colorWithRed:70/255.0f green:144/255.0f blue:241/255.0f alpha:1] forState:UIControlStateNormal];
        cell.adoptBut.enabled=TRUE;
        cell.adoptBut.layer.borderColor=[[UIColor colorWithRed:42/255.0f green:142/255.0f blue:241/255.0f alpha:1]CGColor];
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//        
//        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 100, 180, 224, 1 });
//        [cell.adoptBut.layer setBorderColor:colorref];//边框颜色
        cell.adoptBut.backgroundColor=[UIColor whiteColor];
       
    }else{
        [cell.adoptBut setTitle:@"已采纳" forState:UIControlStateNormal];
        [cell.adoptBut setTitleColor:[UIColor colorWithRed:70/255.0f green:144/255.0f blue:255/255.0f alpha:1] forState:UIControlStateNormal];
        cell.adoptBut.enabled=FALSE;
        cell.adoptBut.layer.borderColor=[[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1]CGColor];
        cell.adoptBut.backgroundColor=[UIColor whiteColor];

    }
    [cell.adoptBut addTarget:self action:@selector(adoptButAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.adoptBut.tag=indexPath.row;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark 问答答案点赞方法
-(void)zanButAcyion:(UIButton *)button
{
    if (self.loginYesOrNo) {
        
        NSDictionary *dic=dataArray[button.tag];
        ISLoginManager *_manager = [ISLoginManager shareManager];
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSString *fidStr=[NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"fid"]];
        NSString *comment_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        int is_zan=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"is_zan"]]intValue];
        NSString *action;
        if (is_zan==0) {
            action=@"add";
        }else{
            action=@"del";
        }
        NSDictionary *dict=@{@"user_id":_manager.telephone,@"fid":fidStr,@"feed_type":@"2",@"comment_id":comment_id,@"action":action};
        [_download requestWithUrl:[NSString stringWithFormat:@"%@",DYNAMIC_SHARE] dict:dict view:self.view delegate:self finishedSEL:@selector(ZanSuccess:) isPost:YES failedSEL:@selector(ZanFail:)];
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            MyLogInViewController *loginViewController = [[MyLogInViewController alloc] init];
            loginViewController.vCYMID=100;
            UMComNavigationController *navigationController = [[UMComNavigationController alloc] initWithRootViewController:loginViewController];
            [self presentViewController:navigationController animated:YES completion:^{
            }];
        });
    }

    
}
#pragma mark 点赞成功
-(void)ZanSuccess:(id)source
{
    NSLog(@"点赞成功%@",source);
    [self interfaceLayout];
}
#pragma mark 点赞失败
-(void)ZanFail:(id)source
{
    NSLog(@"点赞失败%@",source);
}
#pragma mark 问答答案采纳点击方法
-(void)adoptButAction:(UIButton *)button
{
    if (self.loginYesOrNo) {
        NSDictionary *dic=dataArray[button.tag];
        ISLoginManager *_manager = [ISLoginManager shareManager];
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSString *fidStr=[NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"fid"]];
        NSString *comment_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        NSDictionary *dict=@{@"user_id":_manager.telephone,@"fid":fidStr,@"feed_type":@"2",@"comment_id":comment_id};
        [_download requestWithUrl:[NSString stringWithFormat:@"%@",COMMENT_ADOPY] dict:dict view:self.view delegate:self finishedSEL:@selector(AdoptSuccess:) isPost:YES failedSEL:@selector(AdoptZanFail:)];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            MyLogInViewController *loginViewController = [[MyLogInViewController alloc] init];
            loginViewController.vCYMID=100;
            UMComNavigationController *navigationController = [[UMComNavigationController alloc] initWithRootViewController:loginViewController];
            [self presentViewController:navigationController animated:YES completion:^{
            }];
        });
    }
    
}
#pragma mark 采纳成功
-(void)AdoptSuccess:(id)source
{
    NSLog(@"采纳成功%@",source);
    [self commentLayout];
}
#pragma mark 采纳失败
-(void)AdoptZanFail:(id)source
{
    NSLog(@"采纳失败%@",source);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=dataArray[indexPath.row];
    //    Workplace_askTableViewCell *cell=[[Workplace_askTableViewCell alloc]init];
    NSString *string=[NSString stringWithFormat:@"%@",[dic objectForKey:@"comment"]];
    UIFont *font=[UIFont fontWithName:@"Heiti SC" size:15];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize size = [string boundingRectWithSize:CGSizeMake(WIDTH-70, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size.height+121;
}
#pragma mark 列表点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [myTableView deselectRowAtIndexPath:indexPath animated:NO];
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
    [self commentLayout];
    
}
#pragma mark 表格刷新相关
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
