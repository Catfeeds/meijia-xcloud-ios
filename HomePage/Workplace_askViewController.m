//
//  Workplace_askViewController.m
//  yxz
//
//  Created by 白玉林 on 16/6/3.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "Workplace_askViewController.h"
#import "Workplace_askTableViewCell.h"
#import "Up_askViewController.h"
#import "ask_listDetailsViewController.h"
#import "myAskTextViewController.h"
@interface Workplace_askViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>
{
    UITableView *myTableVIew;
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    int   page;
    NSMutableArray *dataArray;
    int  butID;
    UIButton * oldButon;
    UIView *headLineView;
}
@end

@implementation Workplace_askViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navlabel.text=@"问答互助";
    butID=1000;
    page=1;
    dataArray=[[NSMutableArray alloc]init];
    UIButton *askButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-60, 20, 50, 44)];
    [askButton setTitle:@"提问" forState:UIControlStateNormal];
    askButton.titleLabel.font = [UIFont systemFontOfSize: 20.0];
    [askButton setTitleColor:[UIColor colorWithRed:42/255.0f green:142/255.0f blue:241/255.0f alpha:1] forState:UIControlStateNormal];
    [askButton addTarget:self action:@selector(askButAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:askButton];
    UIView *headerView=[[UIView alloc]initWithFrame:FRAME(0, 64, WIDTH, 51)];
    headerView.backgroundColor=[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
    [self.view addSubview:headerView];
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:FRAME(0, 50, WIDTH, 1)];
    lineLabel.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    [headerView addSubview:lineLabel];
    NSArray *array=@[@"最新",@"悬赏",@"精选",@"我的"];
    NSArray * idArr = @[@"1000",@"1002",@"1003",@"1001"];
    for (int i=0; i<4; i++) {
        UIButton *button=[[UIButton alloc]initWithFrame:FRAME(0+60*i, 5, 60, 40)];
        [button setTitle:[NSString stringWithFormat:@"%@",array[i]] forState:UIControlStateNormal];
        if (i==0) {
            [button setTitleColor:[UIColor colorWithRed:70/255.0f green:144/255.0f blue:255/255.0f alpha:1] forState:UIControlStateNormal];
            oldButon = button;
        }else{
            [button setTitleColor:[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1] forState:UIControlStateNormal];
        }
        button.tag=[idArr[i] integerValue];
        button.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        [button addTarget:self action:@selector(tabBarAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
    }
    headLineView=[[UIView alloc]initWithFrame:FRAME(0, 49, 60, 2)];
    headLineView.backgroundColor=[UIColor colorWithRed:70/255.0f green:144/255.0f blue:255/255.0f alpha:1];
    [headerView addSubview:headLineView];
    
    myTableVIew=[[UITableView alloc]initWithFrame:FRAME(0, 115, WIDTH, HEIGHT-115)];
    myTableVIew.dataSource=self;
    myTableVIew.delegate=self;
    myTableVIew.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    myTableVIew.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableVIew];

    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [myTableVIew setTableFooterView:v];
    
    
    _refreshHeader = [[MJRefreshHeaderView alloc] init];
    _refreshHeader.delegate = self;
    _refreshHeader.scrollView = myTableVIew;
    
    _moreFooter = [[MJRefreshFooterView alloc] init];
    _moreFooter.delegate = self;
    _moreFooter.scrollView = myTableVIew;
    // Do any additional setup after loading the view.
    
}
-(void)tabBarAction:(UIButton *)button
{
    page=1;
    
        [oldButon setTitleColor:[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1] forState:UIControlStateNormal];
        oldButon.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        [button setTitleColor:[UIColor colorWithRed:70/255.0f green:144/255.0f blue:255/255.0f alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        oldButon = button;
        [UIView beginAnimations: @"Animation" context:nil];
        [UIView setAnimationDuration:0.3];

//    static int currentSelectButtonIndex = 0;
//    static int previousSelectButtonIndex=1000;
//    currentSelectButtonIndex=(int)button.tag;
//    UIButton *previousBtn=(UIButton *)[self.view viewWithTag:previousSelectButtonIndex];
//    [previousBtn setTitleColor:[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1] forState:UIControlStateNormal];
//    previousBtn.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
//    UIButton *currentBtn = (UIButton *)[self.view viewWithTag:currentSelectButtonIndex];;
//    [currentBtn setTitleColor:[UIColor colorWithRed:70/255.0f green:144/255.0f blue:255/255.0f alpha:1] forState:UIControlStateNormal];
//    currentBtn.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
//    previousSelectButtonIndex=currentSelectButtonIndex;
//    
//    [UIView beginAnimations: @"Animation" context:nil];
//    [UIView setAnimationDuration:0.3];
    
    NSInteger tagX = 0 ;
    switch (button.tag) {
        case 1000:
            tagX = 0;
            break;
        case 1001:
            tagX = 3;
            break;
        case 1002:
            tagX = 1;
            break;
        case 1003:
            tagX = 2;
            break;
        default:
            break;
    }
    headLineView.frame=CGRectMake(60*tagX, 49, 60, 2);
    [UIView commitAnimations];
    butID=(int)button.tag;
    if (butID==1001) {
        if (self.loginYesOrNo) {
            [self interfaceLayout];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                MyLogInViewController *loginViewController = [[MyLogInViewController alloc] init];
                loginViewController.vCYMID=100;
                UMComNavigationController *navigationController = [[UMComNavigationController alloc] initWithRootViewController:loginViewController];
                [self presentViewController:navigationController animated:YES completion:^{
                }];
            });
        }
    }else{
        [self interfaceLayout];
    }
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self interfaceLayout];
}
-(void)interfaceLayout
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
     NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *dict;
    if (butID!=1001) {
        NSString * formType = [NSString stringWithFormat:@"%d",butID - 1000];
        if (self.loginYesOrNo) {
            dict=@{@"user_id":_manager.telephone,@"feed_from":formType,@"feed_type":@"2",@"page":pageStr};
        }else{
            dict=@{@"feed_from":formType,@"feed_type":@"2",@"page":pageStr};
        }
        
        [_download requestWithUrl:[NSString stringWithFormat:@"%@",DYNAMIC_CARD] dict:dict view:self.view delegate:self finishedSEL:@selector(InterFaceSuccess:) isPost:NO failedSEL:@selector(InterFaceFail:)];
    }else {
        if (self.loginYesOrNo) {
            
            dict=@{@"user_id":_manager.telephone,@"feed_from":@"1",@"feed_type":@"2",@"page":pageStr};
            [_download requestWithUrl:[NSString stringWithFormat:@"%@",DYNAMIC_CARD] dict:dict view:self.view delegate:self finishedSEL:@selector(InterFaceSuccess:) isPost:NO failedSEL:@selector(InterFaceFail:)];
        }else{
            butID=1000;
//            static int currentSelectButtonIndexs = 0;
//            static int previousSelectButtonIndexs=1001;
//            currentSelectButtonIndexs=butID;
            UIButton *previousBtn=(UIButton *)[self.view viewWithTag:1001];
            [previousBtn setTitleColor:[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1] forState:UIControlStateNormal];
            previousBtn.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
            UIButton *currentBtn = (UIButton *)[self.view viewWithTag:1000];;
            [currentBtn setTitleColor:[UIColor colorWithRed:70/255.0f green:144/255.0f blue:255/255.0f alpha:1] forState:UIControlStateNormal];
            currentBtn.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
//            previousSelectButtonIndexs=currentSelectButtonIndexs;
            
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            headLineView.frame=CGRectMake(0, 49, 60, 2);
            [UIView commitAnimations];

        }
        
    }
    
    
}
- (void) dimissAlert:(UIAlertView *)alert {
    if(alert)     {
//        static int currentSelectButtonIndex = 0;
//        static int previousSelectButtonIndex=1001;
//        currentSelectButtonIndex=butID;
        UIButton *previousBtn=(UIButton *)[self.view viewWithTag:1001];
        [previousBtn setTitleColor:[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1] forState:UIControlStateNormal];
        previousBtn.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        UIButton *currentBtn = (UIButton *)[self.view viewWithTag:1000];;
        [currentBtn setTitleColor:[UIColor colorWithRed:70/255.0f green:144/255.0f blue:255/255.0f alpha:1] forState:UIControlStateNormal];
        currentBtn.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
//        previousSelectButtonIndex=currentSelectButtonIndex;
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
        [UIView beginAnimations: @"Animation" context:nil];
        [UIView setAnimationDuration:0.3];
        headLineView.frame=CGRectMake(0, 49, 60, 2);
        [UIView commitAnimations];
    }
}

-(void)InterFaceSuccess:(id)dataSource
{
    NSLog(@"%@",dataSource);
    NSString *senderStr=[NSString stringWithFormat:@"%@",[dataSource objectForKey:@"data"]];
    NSLog(@"%lu",(unsigned long)[senderStr length]);
    
    if (senderStr==nil||senderStr==NULL||[senderStr isEqualToString:@"(\n)"]||[senderStr length]==0) {
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        if (butID==1001) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你还没有提过问题" message:nil  delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            alert.tag=199;
            [alert show];
            [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:1];
            
        }
        butID=1000;
        
        
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
                    
                }else{
                    [dataArray addObject:dict];
                }
            
        }
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        
        [myTableVIew reloadData];
    }
}
-(void)InterFaceFail:(id)dataSource
{
    NSLog(@"获取问答列表失败返回%@",dataSource);
}
#pragma mark提问按钮点击事件
-(void)askButAction
{
    if (self.loginYesOrNo) {
        Up_askViewController *up_askVC=[[Up_askViewController alloc]init];
        [self.navigationController pushViewController:up_askVC animated:YES];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic=dataArray[indexPath.row];
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    Workplace_askTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[Workplace_askTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        dispatch_async(dispatch_get_main_queue(),^{
            [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        });
    }

    cell.goldLabelStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"feed_extra"]];
    int  golId=[cell.goldLabelStr intValue];
    if (golId==0) {
        
    }else{
        cell.moneyImagStr=@"金币(1)";
    }
    cell.titleLabelStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    cell.timelabelStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"add_time_str"]];
    cell.namelabelStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    cell.textLabelsStr=[NSString stringWithFormat:@"%@个答案",[dic  objectForKey:@"total_comment"]];
    cell.headeImageStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"head_img"]];
    [cell.askButton addTarget:self action:@selector(askAction:) forControlEvents:UIControlEventTouchUpInside];
    int status=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]]intValue];
    if (status==0) {
        [cell.askButton setTitle:@"我来答" forState:UIControlStateNormal];
        [cell.askButton setTitleColor:[UIColor colorWithRed:70/255.0f green:144/255.0f blue:255/255.0f alpha:1] forState:UIControlStateNormal];
        cell.askButton.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    }else if(status == 2){
        cell.askButton.enabled=FALSE;
        [cell.askButton setTitle:@"已关闭" forState:UIControlStateNormal];
        [cell.askButton setTitleColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1] forState:UIControlStateNormal];
        cell.askButton.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    }else {
        cell.askButton.enabled=FALSE;
        [cell.askButton setTitle:@"已采纳" forState:UIControlStateNormal];
        [cell.askButton setTitleColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1] forState:UIControlStateNormal];
        cell.askButton.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    
    }
    
    cell.askButton.tag=indexPath.row;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSDictionary *dic=dataArray[indexPath.row];
//    Workplace_askTableViewCell *cell=[[Workplace_askTableViewCell alloc]init];
    NSString *string=[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    UIFont *font=[UIFont fontWithName:@"Heiti SC" size:15];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize size = [string boundingRectWithSize:CGSizeMake(WIDTH-70, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size.height+106;
}
#pragma mark 列表点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=dataArray[indexPath.row];
    [myTableVIew deselectRowAtIndexPath:indexPath animated:NO];
    ask_listDetailsViewController *ask_listVC=[[ask_listDetailsViewController alloc]init];
    ask_listVC.dataDic=dic;
    [self.navigationController pushViewController:ask_listVC animated:YES];
}
-(void)askAction:(UIButton *)button
{
    if (self.loginYesOrNo) {
        NSDictionary *dic=dataArray[button.tag];
        myAskTextViewController *myAskVC=[[myAskTextViewController alloc]init];
        myAskVC.askVCID=100;
        myAskVC.dataDic=dic;
        [self.navigationController pushViewController:myAskVC animated:YES];
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
    [self interfaceLayout];
    
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
