//
//  NewsViewController.m
//  simi
//
//  Created by 白玉林 on 15/7/31.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "NewsViewController.h"
#import "ChatViewController.h"
#import "ISLoginManager.h"
#import "DownloadManager.h"
#import "MeetingViewController.h"

@interface JKTest : NSObject
@property(nonatomic,strong) id object;

@end
@implementation JKTest
@synthesize object=_object;
-(void)setObject:(id)object
{
    _object=object;
    NSLog(@"%s",__func__);
}
-(id)object
{
    NSLog(@"%s",__func__);
    return _object;
}
+(BOOL)accessInstanceVariablesDirectly
{
    NSLog(@"%s",__func__);
    return [super accessInstanceVariablesDirectly];
}
-(id)valueForKey:(NSString *)key
{
    NSLog(@"%s",__func__);
    return [super valueForKey:key];
}
-(void)setValue:(id)value forKey:(NSString *)key
{
    NSLog(@"%s",__func__);
    [super setValue:value forKey:key];
}

@end
@interface NewsViewController ()
{
    UITableView *_tableView;
    NSDictionary *dict;
    NSMutableArray *array;
    ISLoginManager *_manager;
    MeetingViewController *vc;
    
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    NSInteger   page;
    
}
@end

@implementation NewsViewController
@synthesize shujuArray;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_needRefresh) {
        [_refreshHeader beginRefreshing];
        _needRefresh = NO;
    }

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.backBtn.hidden=YES;
//    self.navlabel.text=@"消息";
    self.navigationController.navigationBarHidden=YES;
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self dataLayout];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    page=1;
    array=[[NSMutableArray alloc]init];
    JKTest *text=[JKTest new];
    [text setValue:@"KVC" forKey:@"object"];
    [text valueForKey:@"object"];
    NSLog( @"通讯录的数据信息%@",shujuArray);
   _manager = [ISLoginManager shareManager];
    [_tableView removeFromSuperview];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-101)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_tableView setTableFooterView:v];
    _refreshHeader = [[MJRefreshHeaderView alloc] init];
    _refreshHeader.delegate = self;
    _refreshHeader.scrollView = _tableView;
    
    _moreFooter = [[MJRefreshFooterView alloc] init];
    _moreFooter.delegate = self;
    _moreFooter.scrollView = _tableView;
}

-(void)dataLayout
{
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *user_ID=_manager.telephone;
    NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *_dict = @{@"user_id":user_ID,@"page":pageStr};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:USER_HYXX dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
}
-(void)logDowLoadFinish:(id)sender
{
    NSLog(@"好友消息列表数据%@",sender);
//    array=[sender objectForKey:@"data"];
    NSLog(@"数组个数%lu",(unsigned long)array.count);
    NSArray *arraySS=[sender objectForKey:@"data"];
    if (arraySS.count<10*page) {
        _hasMore=YES;
    }else{
        _hasMore=NO;
    }
    if (page==1) {
        [array removeAllObjects];
        [array addObjectsFromArray:arraySS];
    }else{
        for (int i=0; i<arraySS.count; i++) {
            if ([array containsObject:arraySS[i]]) {
                
            }else{
                [array addObject:arraySS[i]];
            }
        }
        
    }

    [_tableView reloadData];
}
-(void)DownFail:(id)sender
{
    NSLog(@"获取好友消息失败");
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
    
    [self dataLayout];
    
    
    
}
#pragma mark 表格刷新相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=array[indexPath.row];
    NSString *identifier =[NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
        
    }
    UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 40, 40)];
    NSString *headString=[NSString stringWithFormat:@"%@",[dic objectForKeyedSubscript:@"head_img"]];
    NSLog( @"123%@",headString);
    if (headString == nil||headString == NULL||[headString isEqualToString:@"<null>"]||[headString length]==0) {
        headImage.image =[UIImage imageNamed:@"家-我_默认头像"];
    }else
    {
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"head_img"]];
        [headImage setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
//        headImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"head_img"]]]];
    }
    
    headImage.layer.cornerRadius=headImage.frame.size.width/2;
    headImage.clipsToBounds = YES;
    [cell addSubview:headImage];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(headImage.frame.origin.x+headImage.frame.size.width+10, 15, WIDTH-130, 20)];
    nameLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    nameLabel.font=[UIFont fontWithName:@"Arial" size:15];
    [cell addSubview:nameLabel];
    
    double inTime=[[dic objectForKey:@"add_time"] doubleValue];
    NSDateFormatter* inTimeformatter =[[NSDateFormatter alloc] init];
    inTimeformatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [inTimeformatter setDateStyle:NSDateFormatterMediumStyle];
    [inTimeformatter setTimeStyle:NSDateFormatterShortStyle];
    [inTimeformatter setDateFormat:@"HH:mm"];
    NSDate* inTimedate = [NSDate dateWithTimeIntervalSince1970:inTime];
    NSString* inTimeString = [inTimeformatter stringFromDate:inTimedate];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH-50, 25, 40, 10)];
    timeLabel.text=[NSString stringWithFormat:@"%@",inTimeString];
    timeLabel.font=[UIFont fontWithName:@"Arial" size:10];
    [cell addSubview:timeLabel];
    
    UILabel *textLabel=[[UILabel alloc]initWithFrame:CGRectMake(headImage.frame.origin.x+headImage.frame.size.width+10, cell.frame.size.height, WIDTH-90, 15)];
    textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"im_content"]];
    textLabel.font=[UIFont fontWithName:@"Arial" size:10];
    textLabel.textColor=[UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1];
    [cell addSubview:textLabel];
    
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        dispatch_async(dispatch_get_main_queue(),^{
            [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        });
    }

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=array[indexPath.row];
    ChatViewController *vcr=[[ChatViewController alloc]initWithChatter:[dic objectForKey:@"to_im_user_name"] isGroup:NO];
    vcr.title=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    [vcr.navigationController setNavigationBarHidden:NO];
    NSLog(@"%@,,,%@",[dict objectForKey:@"im_sec_nickname"],[dict objectForKey:@"im_sec_username"]);
    [self.navigationController pushViewController:vcr animated:YES];
    //取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
