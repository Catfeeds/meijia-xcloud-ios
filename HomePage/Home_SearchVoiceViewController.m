//
//  Home_SearchVoiceViewController.m
//  yxz
//
//  Created by 白玉林 on 16/6/14.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "Home_SearchVoiceViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "HomePageTableViewCell.h"
#import "ArticleWEBViewController.h"
@interface Home_SearchVoiceViewController ()
{
    UISearchBar *mySearchBar;
    UITableView *myTableView;
    NSMutableArray *seekArray;
    int Y;
    int height;
    //    NSMutableArray *imageArray;
    NSString *sec_Id;
    NSString *secID;
    int is_senior;
    NSArray *arr;
    UILabel *alertLabel;
    NSString *searchStr;
    
    NSString *senderString;
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    NSInteger   page;
    UILabel *arletView;
}
@end

@implementation Home_SearchVoiceViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    page=1;
    seekArray=[[NSMutableArray alloc]init];
    //    imageArray=[[NSMutableArray alloc]init];
    mySearchBar=[[UISearchBar alloc]initWithFrame:FRAME(60, 25, WIDTH-100, 30)];
    mySearchBar.placeholder=@"搜索";
    mySearchBar.delegate=self;
    //mySearchBar.backgroundColor = color;
    //mySearchBar.layer.cornerRadius = 18;
    mySearchBar.layer.masksToBounds = YES;
    [mySearchBar.layer setBorderWidth:8];
    [mySearchBar.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.view addSubview:mySearchBar];
    
    
    
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    [topView setBarStyle:UIBarStyleBlackTranslucent];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 5, 50, 25);
    [btn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"shouqi"] forState:UIControlStateNormal];
    [btn setTitle:@"隐藏" forState:UIControlStateNormal];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    [mySearchBar setInputAccessoryView:topView];
    
    UITapGestureRecognizer *tapSelf=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tapSelf.delegate=self;
    [self.view addGestureRecognizer:tapSelf];
    [myTableView removeFromSuperview];
    myTableView =[[UITableView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
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
    
    
    arletView=[[UILabel alloc]initWithFrame:FRAME(20, HEIGHT-100, WIDTH-40, 30)];
    arletView.alpha=0.4;
    arletView.textAlignment=NSTextAlignmentCenter;
    arletView.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    arletView.text=@"没有找到相关结果";
    arletView.hidden=YES;
    [self.view addSubview:arletView];
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
    if (searchStr==nil||searchStr==NULL||[searchStr isEqualToString:@""]) {
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }else{
        [self handleSearchForTerm:searchStr];
    }
    
    
    
    
}

#pragma mark 表格刷新相关

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
-(void)tapAction:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    [mySearchBar resignFirstResponder];
    [UIView commitAnimations];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UITextField class]])
    {
        return NO;
    }
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar

{
    searchStr = searchBar.text;
    [mySearchBar resignFirstResponder];
    [self handleSearchForTerm:searchStr];
}
-(void)handleSearchForTerm:(NSString *)string
{
    
    NSString *urlStr;
    NSString *stringss=[NSString stringWithFormat:@"http://51xingzheng.cn/api/get_search_results/?s=%@&count=10&order=DESC&include=id,title,url,thumbnail,custom_fields",searchStr];
    urlStr=[stringss stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"%@&page=%ld",urlStr,(long)page];
    AFHTTPRequestOperationManager *mymanager = [AFHTTPRequestOperationManager manager];
    
    [mymanager GET:[NSString stringWithFormat:@"%@",urlString] parameters:nil success:^(AFHTTPRequestOperation *opretion, id responseObject){
        
        if(page==1){
            [seekArray removeAllObjects];
        }
        NSLog(@"数据%@",responseObject);
        NSArray *array=[responseObject objectForKey:@"posts"];
        if (array.count<10) {
            _hasMore=YES;
        }else{
            _hasMore=NO;
        }
        
        for (int i=0; i<array.count; i++) {
            NSDictionary *dict=array[i];
            if ([seekArray containsObject:dict]) {
                
            }else{
                [seekArray addObject:dict];
            }
        }
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        
        //        if (array.count<5) {
        //            selectedID=YES;
        //        }
        if (seekArray.count<1) {
            arletView.hidden=NO;
//            NSTimer
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(arletViewTime) userInfo:nil repeats:NO];
        }
        [myTableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *opration, NSError *error){
        
        NSLog(@"失败数据%@",error);
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        
        
    }];

}
-(void)arletViewTime
{
    arletView.hidden=YES;
}
- (void)timerFireMethod:(NSTimer*)theTimer
{
    alertLabel.hidden=YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return seekArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic=seekArray[indexPath.row];
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    HomePageTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[HomePageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"thumbnail"]];
    [cell.headeImageVIew setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
    cell.titleLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    [cell.titleLabel setNumberOfLines:2];
    [cell.titleLabel sizeToFit];
    NSArray *viewsArray=[[dic objectForKey:@"custom_fields"]objectForKey:@"views"];
    cell.subTitleLabel.text=[NSString stringWithFormat:@"%@人已看过",viewsArray[0]];
    
    return cell;}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    [mySearchBar resignFirstResponder];
    [UIView commitAnimations];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic=seekArray[indexPath.row];
    ArticleWEBViewController *webPageVC=[[ArticleWEBViewController alloc]init];
    webPageVC.barIDS=100;
    webPageVC.pushID=100;
    webPageVC.listID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    webPageVC.webURL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]];
    [self.navigationController pushViewController:webPageVC animated:YES];

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
