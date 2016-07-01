//
//  SchoolViewController.m
//  yxz
//
//  Created by 白玉林 on 16/4/21.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "SchoolViewController.h"
#import "SchoolTableViewCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "SearchVoiceViewController.h"
@interface SchoolViewController ()
{
    UIScrollView *myScrollView;
    NSMutableArray *sourceArray;
    UIScrollView *rootView;
    NSMutableArray *W;
    UIImageView *lineImageView;
    NSArray *arraY;
    CGFloat maximumOffset;
    CGFloat currentOffset;
    int scrollID;
    int buttID;
    int widths;
    
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    int   page;
}
@end

@implementation SchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page=1;
    W=[[NSMutableArray alloc]init];
    arraY=@[@"精选",@"人力",@"行政",@"企管",@"考证",@"技能"];
    sourceArray=[[NSMutableArray alloc]init];
    UIView *reView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 64)];
    reView.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [self.view addSubview:reView];
    UIButton *searchButton=[[UIButton alloc]initWithFrame:FRAME(50, 30, WIDTH-70, 25)];
    searchButton.backgroundColor=[UIColor whiteColor];//colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [searchButton addTarget:self action:@selector(searchButAction) forControlEvents:UIControlEventTouchUpInside];
    [reView addSubview:searchButton];
    UIImageView *searchImage=[[UIImageView alloc]initWithFrame:FRAME(5, 5, 15, 15)];
    searchImage.image=[UIImage imageNamed:@"search_@2x"];
    [searchButton addSubview:searchImage];
    UIImageView *voiceImage=[[UIImageView alloc]initWithFrame:FRAME(searchButton.frame.size.width-20, 5, 15, 15)];
    voiceImage.image=[UIImage imageNamed:@"iconfont-yuyin-copy"];
    [searchButton addSubview:voiceImage];
    UILabel *searchLabel=[[UILabel alloc]initWithFrame:FRAME(45, 5, searchButton.frame.size.width-90, 15)];
    searchLabel.text=@"点击搜索相关信息";
    searchLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
    searchLabel.textAlignment=NSTextAlignmentCenter;
    searchLabel.textColor=[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
    [searchButton addSubview:searchLabel];
    
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = FRAME(0, 20, 50, 40);
    _backBtn.tag=33;
    _backBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 20, 20)];
    img.image = [UIImage imageNamed:@"iconfont-p-back"];
    [_backBtn addSubview:img];
    
    
    
    _myTableView =[[UITableView alloc]initWithFrame:FRAME(0, 102, WIDTH, HEIGHT-102)];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_myTableView setTableFooterView:v];
    
    _refreshHeader = [[MJRefreshHeaderView alloc] init];
    _refreshHeader.delegate = self;
    _refreshHeader.scrollView = _myTableView;
    
    _moreFooter = [[MJRefreshFooterView alloc] init];
    _moreFooter.delegate = self;
    _moreFooter.scrollView = _myTableView;
    [self tabBarLayout];
    // Do any additional setup after loading the view.
}
-(void)tabBarLayout
{
    [rootView removeFromSuperview];
    [W removeAllObjects];
    rootView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 38)];
    rootView.backgroundColor=[UIColor whiteColor];
    //    rootView.contentSize=CGSizeMake(WIDTH/4*array.count, 37);
    rootView.showsVerticalScrollIndicator = FALSE;
    rootView.showsHorizontalScrollIndicator = FALSE;
    //rootView.pagingEnabled=YES;
    rootView.bounces=NO;
    rootView.delegate=self;
    [self.view addSubview:rootView];
    
    UIView *lineView=[[UIView alloc]initWithFrame:FRAME(0, 101, WIDTH, 1)];
    lineView.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    [self.view addSubview:lineView];
    
    lineImageView=[[UIImageView alloc]init];
    lineImageView.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [rootView addSubview:lineImageView];
    int K=0;
    int Ks=0;
    for (int i=0; i<arraY.count; i++)
    {
//        NSDictionary *dic=arraY[i];
        UILabel *butLabel=[[UILabel alloc]init];
        butLabel.text=[NSString stringWithFormat:@"%@",arraY[i]];
        butLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        [butLabel setNumberOfLines:1];
        [butLabel sizeToFit];
        butLabel.frame=FRAME(10, 8, butLabel.frame.size.width, 21);
        Ks=Ks+butLabel.frame.size.width;
    }
    K=Ks+20*(int)(arraY.count+1);
    int X=0;
    for (int i=0; i<arraY.count; i++) {
//        NSDictionary *dic=arraY[i];
        UIButton *button=[[UIButton alloc]init];
        [button setTitle:[NSString stringWithFormat:@"%@",arraY[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tabbarButton:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            [button setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1]forState:UIControlStateNormal];
        }
        
        [button setTag:1000+i];
        button.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        
        UILabel *butLabel=[[UILabel alloc]init];
        butLabel.text=[NSString stringWithFormat:@"%@",arraY[i]];
        butLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        [butLabel setNumberOfLines:1];
        [butLabel sizeToFit];
        butLabel.frame=FRAME(10, 8, butLabel.frame.size.width, 21);
        //        [button addSubview:butLabel];
        //        button.titleLabel.textColor=;
        int S=0;
        if (K<WIDTH) {
            
            button.frame=CGRectMake((WIDTH-Ks)/(arraY.count+1)+X+(WIDTH-Ks)/(arraY.count+1)*i, 0, butLabel.frame.size.width, 37);
            X=X+butLabel.frame.size.width;
            if (i==0||i==arraY.count-1) {
                S=button.frame.size.width+(WIDTH-Ks)/(arraY.count+1)*3/2;
            }else{
                S=button.frame.size.width+(WIDTH-Ks)/(arraY.count+1);
            }
        }else{
            button.frame=CGRectMake(20+X+20*i, 0, butLabel.frame.size.width, 37);
            X=X+butLabel.frame.size.width;
            if (i==0||i==arraY.count-1) {
                S=button.frame.size.width+20*3/2;
            }else{
                S=button.frame.size.width+20;
            }
        }
        [rootView addSubview:button];
        
        
        NSString *stringt=[NSString stringWithFormat:@"%d",S];
        [W addObject:stringt];
    }
    int kuan=0;
    for (int i=0; i<W.count; i++) {
        int k=[[W objectAtIndex:i]intValue];
        kuan+=k;
    }
    rootView.contentSize=CGSizeMake(K, 37);
    maximumOffset = rootView.contentSize.width;
    CGRect bounds = rootView.bounds;
    UIEdgeInsets inset = rootView.contentInset;
    currentOffset = rootView.contentOffset.x+bounds.size.width - inset.bottom;
    int s=[[W objectAtIndex:0]intValue];
    lineImageView.frame=CGRectMake(0, 35, s, 2);

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    scrollID=0;
    [self getLayout];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)tabbarButton:(UIButton *)sender
{
    page=1;
    int huang=0,kuan=0;
    int width=[[W objectAtIndex:(sender.tag-1000)]intValue];
    for (int i=0; i<(sender.tag-1000); i++) {
        NSString *string=W[i];
        int s=[string intValue];
        huang+=s;
    }
    for (int i=0; i<W.count; i++) {
        int t=[[W objectAtIndex:i]intValue];
        kuan+=t;
    }
    int _offSet=(int)(sender.tag-1000);
//    NSDictionary *dic=array[_offSet];
    if (kuan>WIDTH) {
        if (_offSet>2&&_offSet!=arraY.count-1&&_offSet>scrollID) {
            buttID=1;
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:1];
            if (currentOffset==maximumOffset||currentOffset>maximumOffset) {
                
            }else{
                if (maximumOffset-currentOffset==width) {
                    rootView.contentOffset=CGPointMake(rootView.contentOffset.x+width, 0);
                    widths=width;
                }else if (maximumOffset-currentOffset<width){
                    rootView.contentOffset=CGPointMake(rootView.contentOffset.x+maximumOffset-currentOffset, 0);
                    widths=maximumOffset-currentOffset;
                }else{
                    rootView.contentOffset=CGPointMake(rootView.contentOffset.x+width, 0);
                    widths=width;
                }
                
            }
            
            [UIView commitAnimations];
            
        }else if (buttID==1&&_offSet<scrollID){
            if (currentOffset==WIDTH) {
                
            }else{
                [UIView beginAnimations: @"Animation" context:nil];
                [UIView setAnimationDuration:1];
                if (currentOffset-WIDTH==width) {
                    rootView.contentOffset=CGPointMake(rootView.contentOffset.x-width, 0);
                    widths=width;
                }else if (currentOffset-WIDTH<width){
                    rootView.contentOffset=CGPointMake(rootView.contentOffset.x-(currentOffset-WIDTH), 0);
                    widths=maximumOffset-currentOffset;
                }else{
                    rootView.contentOffset=CGPointMake(rootView.contentOffset.x-width, 0);
                    widths=width;
                }
                
                //
                //                if (widths!=0) {
                //                    rootView.contentOffset=CGPointMake(rootView.contentOffset.x-widths, 0);
                //                }else{
                //                    rootView.contentOffset=CGPointMake(rootView.contentOffset.x-width, 0);
                //                }
                //
                [UIView commitAnimations];
                
            }
            
            
            //            if (_offSet==3||_offSet<3) {
            //                buttID=0;
            //            }
        }
        
        
    }
    static int currentSelectButtonIndex = 0;
    static int previousSelectButtonIndex=1000;
    currentSelectButtonIndex=(int)sender.tag;
    UIButton *previousBtn=(UIButton *)[self.view viewWithTag:previousSelectButtonIndex];
    [previousBtn setTitleColor:[UIColor colorWithRed:120/255.0f green:120/255.0f blue:120/255.0f alpha:1] forState:UIControlStateNormal];
    previousBtn.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    UIButton *currentBtn = (UIButton *)[self.view viewWithTag:currentSelectButtonIndex];;
    [currentBtn setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
    currentBtn.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    previousSelectButtonIndex=currentSelectButtonIndex;
    
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    
    lineImageView.frame=CGRectMake(huang, 35, width, 2);
    [UIView commitAnimations];
    scrollID=(int)(sender.tag-1000);
    [self getLayout];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    
    
    
    
    CGRect bounds = scrollView.bounds;
    
    
    
    
    UIEdgeInsets inset = scrollView.contentInset;
    
    
    
    
    currentOffset = scrollView.contentOffset.x+bounds.size.width - inset.bottom;
    
    
    
}

-(void)getLayout
{
    NSString *urlStr;
    switch (scrollID) {
        case 0:
        {
//            page=1;
            NSString *string=[NSString stringWithFormat:@"http://51xingzheng.cn/?json=get_tag_posts&count=10&order=DESC&slug=精选课程&include=id,title,modified,url,thumbnail,custom_fields"];
            urlStr=[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
            break;
        case 1:
        {
//            page=1;
            NSString *string=@"http://51xingzheng.cn/?json=get_tag_posts&count=10&order=DESC&slug=人力课程&include=id,title,modified,url,thumbnail,custom_fields";
            urlStr=[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
            break;
        case 2:
        {
//            page=1;
            NSString *string=@"http://51xingzheng.cn/?json=get_tag_posts&count=10&order=DESC&slug=行政课程&include=id,title,modified,url,thumbnail,custom_fields";
            urlStr=[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
            break;
        case 3:
        {
//            page=1;
            NSString *string=@"http://51xingzheng.cn/?json=get_tag_posts&count=10&order=DESC&slug=企管课程&include=id,title,modified,url,thumbnail,custom_fields";
            urlStr=[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
            break;
        case 4:
        {
//            page=1;
            NSString *string=@"http://51xingzheng.cn/?json=get_tag_posts&count=10&order=DESC&slug=考证课程&include=id,title,modified,url,thumbnail,custom_fields";
            urlStr=[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
            break;
        case 5:
        {
//            page=1;
            NSString *string=@"http://51xingzheng.cn/?json=get_tag_posts&count=10&order=DESC&slug=技能课程&include=id,title,modified,url,thumbnail,custom_fields";
            urlStr=[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
            break;
        default:
            break;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@&page=%d",urlStr,page];
    AFHTTPRequestOperationManager *mymanager = [AFHTTPRequestOperationManager manager];
    
    [mymanager GET:[NSString stringWithFormat:@"%@",urlString] parameters:nil success:^(AFHTTPRequestOperation *opretion, id responseObject){
        
        if(page==1){
            [sourceArray removeAllObjects];
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
            if ([sourceArray containsObject:dict]) {
                
            }else{
                [sourceArray addObject:dict];
            }
        }
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];

//        if (array.count<5) {
//            selectedID=YES;
//        }
        [_myTableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *opration, NSError *error){
        
        NSLog(@"失败数据%@",error);
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];

        
    }];

    
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return sourceArray.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    NSDictionary *dict=sourceArray[indexPath.row];
    //指定cellIdentifier为自定义的cell
    
    static NSString *CellIdentifier = @"Cell";
    
    //自定义cell类
    
    SchoolTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[SchoolTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setIntroductionText:dict];
//    if([indexPath row] == ((NSIndexPath*)[[_myTableView indexPathsForVisibleRows] lastObject]).row){
//        //end of loading
//        dispatch_async(dispatch_get_main_queue(),^{
//            [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
//            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
//        });
//    }

    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SchoolTableViewCell*cell = [self tableView:_myTableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%f",cell.frame.size.height);
    return cell.frame.size.height;  
    
}

#pragma mark 列表点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_myTableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic=sourceArray[indexPath.row];
    WebPageViewController *webPageVC=[[WebPageViewController alloc]init];
    webPageVC.barIDS=100;
    webPageVC.webURL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]];
    [self.navigationController pushViewController:webPageVC animated:YES];
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
    
    [self getLayout];
    
    
    
}
#pragma mark 表格刷新相关
-(void)searchButAction{
    SearchVoiceViewController *searchVC=[[SearchVoiceViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
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
