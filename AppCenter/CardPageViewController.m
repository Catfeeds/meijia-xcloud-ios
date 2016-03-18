//
//  CardPageViewController.m
//  yxz
//
//  Created by 白玉林 on 16/2/29.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "CardPageViewController.h"
#import "ISLoginManager.h"
#import "DownloadManager.h"
#import "PageTableViewCell.h"
#import "DetailsListViewController.h"
//#import "WXApi.h"
#import "MineViewController.h"
#import "QRcodeViewController.h"
#import "LBXScanViewStyle.h"
#import "LBXScanViewController.h"

#import "ClerkViewController.h"
#import "FountWebViewController.h"
#import "CycleScrollView.h"


#import "BookingViewController.h"
#import "MeetingViewController.h"
#import "UpLoadViewController.h"
#import "AttendanceViewController.h"
#import "ApplyForLeaveViewController.h"
#import "WebPageViewController.h"
@interface CardPageViewController ()
{
    NSMutableDictionary *eventsByDate;
    UILabel *timeLabel;
    NSString *timeString;
    DownloadManager *_download;
    NSDictionary *_dict;
    UIView *viewMR;
    NSMutableArray *numberArray;
    
    UIButton *foldingBut;
    UIView *OcclusionView;
    UISwipeGestureRecognizer *up;
    UISwipeGestureRecognizer *down;
    DetailsListViewController *vc;
    
    
    CycleScrollView *adView;
    NSArray *arrayImage;
    NSMutableArray *imageArray;
    UILabel *alertLabel;
    UIActivityIndicatorView *actView;
    NSString *dataString;
    UIPageControl *pageControl;
    NSTimer *timer;
    CLLocationManager *locationManager;
    NSString *senderString;
    
    NSArray *riliArray;
    
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    NSInteger   page;
}
@end

@implementation CardPageViewController
int F=0,M=0,N=0,S,eyeID=0;
@synthesize latString,lngString;
float lastContentOffset;
-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"首页"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
   
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"首页"];
    
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.view.userInteractionEnabled=YES;
    self.img.hidden=YES;
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 20, 20)];
    img.image = [UIImage imageNamed:@"iconfont-p-back"];
    [_backBtn addSubview:img];
    self.navlabel.text=_navlabelName;
    _navlabel.textColor = [UIColor whiteColor];
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
     CGRect tmpRect = [self.navlabel.text boundingRectWithSize:CGSizeMake(WIDTH, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil] context:nil];
    page=1;
    numberArray=[[NSMutableArray alloc]init];
    NSLog(@"%d",_vcID);
    switch (_vcID) {
        case 1001:
            self.backlable.backgroundColor=HEX_TO_UICOLOR(0x11cd6e, 1.0);
            break;
        case 1002:
            self.backlable.backgroundColor=HEX_TO_UICOLOR(0xf4c600, 1.0);
            break;
        case 1003:
            self.backlable.backgroundColor=HEX_TO_UICOLOR(0x56abe4, 1.0);
            break;
        case 1004:
            self.backlable.backgroundColor=HEX_TO_UICOLOR(0x00bb9c, 1.0);
            break;
        case 1005:
            self.backlable.backgroundColor=HEX_TO_UICOLOR(0x56abe4, 1.0);
            break;
            
        default:
            break;
    }
    
    self.helpBut.hidden=NO;
    self.helpBut.frame=FRAME((WIDTH-tmpRect.size.width)/2, 20, tmpRect.size.width+20, 44);
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:FRAME(self.helpBut.frame.size.width-20, 12, 20, 20)];
    image.image=[UIImage imageNamed:@"iconfont_yingyongbangzhu"];
    [self.helpBut addSubview:image];
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    // 开始时时定位
    [locationManager startUpdatingLocation];
    
    
    
    actView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    actView.center = CGPointMake(WIDTH/2, HEIGHT/2);
    actView.color = [UIColor blackColor];
    [actView startAnimating];
    [self.view addSubview:actView];
    imageArray=[[NSMutableArray alloc]init];
    self.view.frame=FRAME(0, 0, WIDTH, HEIGHT-50);
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    timeString=locationString;
    
    
    
    UIButton *eyeButton=[[UIButton alloc]initWithFrame:FRAME(14, HEIGHT-46, WIDTH-28, 41)];
    [eyeButton addTarget:self action:@selector(eyeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    eyeButton.backgroundColor=self.backlable.backgroundColor;
    [eyeButton setTitle:@"新建" forState:UIControlStateNormal];
    eyeButton.layer.cornerRadius=5;
    eyeButton.clipsToBounds=YES;
    [self.view addSubview:eyeButton];
    
//    UIButton *calenderButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-50, 25, 50, 40)];
//    [calenderButton addTarget:self action:@selector(didChangeModeTouch) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:calenderButton];
    
//    UIImageView *calenderImage=[[UIImageView alloc]initWithFrame:FRAME(10, 10, 20, 20)];
//    calenderImage.image=[UIImage imageNamed:@"RL_BT"];
//    [calenderButton addSubview:calenderImage];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    riliArray=delegate.riliArray;
    [self tableViewLayout];
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
    [self PLJKLayout];
}
#pragma mark 表格刷新相关
#pragma mark 首页右上按钮点击方法
-(void)eyeButtonAction:(UIButton *)button
{
    if (_vcID<1005) {
        MeetingViewController *meetVC=[[MeetingViewController alloc]init];
        meetVC.vcID=_vcID;
        [self.navigationController pushViewController:meetVC animated:YES];
    }else if (_vcID==1005){
        BookingViewController *bookVC=[[BookingViewController alloc]init];
        [self.navigationController pushViewController:bookVC animated:YES];
    }else if (_vcID==1006){
        AttendanceViewController *userVC=[[AttendanceViewController alloc]init];
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString *has_company=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"has_company"]];
        int has=[has_company intValue];
        if (has==0) {
            userVC.webID=0;
        }else{
            userVC.webID=1;
        }
        
        [self.navigationController pushViewController:userVC animated:YES];
    }else if (_vcID==1007){
        ApplyForLeaveViewController *applyVC=[[ApplyForLeaveViewController alloc]init];
        [self.navigationController pushViewController:applyVC animated:YES];
    }else if (_vcID==1008){
        UpLoadViewController *vcd=[[UpLoadViewController alloc]init];
        [self.navigationController pushViewController:vcd animated:YES];
    }
}
-(void)tableViewLayout
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 64, WIDTH,HEIGHT-110)];
    self.tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    [self.view addSubview:self.tableView];
    NSLog(@"数组个数%lu",(unsigned long)numberArray.count);
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor=[UIColor whiteColor];
    [_tableView setTableFooterView:v];
    _refreshHeader = [[MJRefreshHeaderView alloc] init];
    _refreshHeader.delegate = self;
    _refreshHeader.scrollView = _tableView;
    
    _moreFooter = [[MJRefreshFooterView alloc] init];
    _moreFooter.delegate = self;
    _moreFooter.scrollView = _tableView;
    
}
#pragma mark 首页左上按钮点击方法
-(void)myButtonAction:(UIButton *)button
{
    MineViewController *mineVC=[[MineViewController alloc]init];
    [self.navigationController pushViewController:mineVC animated:YES];
}
#pragma mark广告未View布局及初始化
-(void)adViewLayout
{
    [adView removeFromSuperview];
    NSMutableArray *viewsArray = [@[] mutableCopy];
    for (int i=0; i<arrayImage.count; i++) {
        NSDictionary *dic=arrayImage[i];
        UIButton *viewImage=[[UIButton alloc]initWithFrame:FRAME(WIDTH*i, 0, WIDTH, (WIDTH*0.42+40))];
        viewImage.backgroundColor=[UIColor whiteColor];
        [viewImage addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
        viewImage.tag=i;
        [viewsArray addObject:viewImage];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME(0, 0, WIDTH, WIDTH*0.42)];
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"img_url"]];
        [imageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
        [viewImage addSubview:imageView];
        UILabel *textLabel=[[UILabel alloc]initWithFrame:FRAME(20, WIDTH*0.42, WIDTH-30, 40)];
        textLabel.textAlignment=NSTextAlignmentCenter;
        textLabel.textColor=[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1];
        textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
        [viewImage addSubview:textLabel];
    }
    adView= [[CycleScrollView alloc]initWithFrame:FRAME(0, 134, WIDTH, (WIDTH*0.42+40)) animationDuration:5];
    adView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
    
    adView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    adView.totalPagesCount = ^NSInteger(void){
        return 5;
    };
    adView.TapActionBlock = ^(NSInteger pageIndex){
        NSLog(@"点击了第%ld个",(long)pageIndex);
    };
    [self.view addSubview:adView];
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(WIDTH-5*arrayImage.count-10*(arrayImage.count+1), WIDTH*0.42+134, 5*arrayImage.count+10*(arrayImage.count+1), 30)];
    pageControl.numberOfPages = arrayImage.count;
    pageControl.alpha=0.5;
    pageControl.backgroundColor=[UIColor whiteColor];
    pageControl.currentPage = 0;
    [self.view addSubview:pageControl];
    //    [self addTimer];
    
}
-(void)butAction:(UIButton *)sender
{
    NSDictionary *dic=arrayImage[sender.tag];
    NSString *string=[NSString stringWithFormat:@"%@",[dic objectForKey:@"goto_type"]];
    if ([string isEqualToString:@"app"]) {
        ClerkViewController *clerkVC=[[ClerkViewController alloc]init];
        clerkVC.service_type_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_type_ids"]];
        [self.navigationController pushViewController:clerkVC animated:YES];
    }else{
        FountWebViewController *fountVC=[[FountWebViewController alloc]init];
        fountVC.goto_type=[NSString stringWithFormat:@"%@",[dic objectForKey:@"goto_type"]];
        fountVC.imgurl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"goto_url"]];
        fountVC.service_type_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_type_ids"]];
        [self.navigationController pushViewController:fountVC animated:YES];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    DownloadManager *download = [[DownloadManager alloc]init];
    NSDictionary *dict=@{@"channel_id":@"0"};
    [download requestWithUrl:CHANNEL_CARD dict:dict view:self.view delegate:self finishedSEL:@selector(ChannelSuccess:) isPost:NO failedSEL:@selector(ChannelFailure:)];
    
}

#pragma mark 获取频道列表成功返回方法
-(void)ChannelSuccess:(id)sender
{
    NSLog(@"获取频道列表成功数据%@",sender);
    arrayImage=[sender objectForKey:@"data"];
    dataString=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    if (dataString==nil||dataString==NULL||dataString.length==0||[dataString isEqualToString:@""]) {
        [actView stopAnimating]; // 结束旋转
        [actView setHidesWhenStopped:YES]; //当旋转结束时隐藏
        [alertLabel removeFromSuperview];
        alertLabel=[[UILabel alloc]initWithFrame:FRAME((WIDTH-260)/2,HEIGHT-200, 260, 40)];
        alertLabel.backgroundColor=[UIColor blackColor];
        alertLabel.alpha=0.4;
        alertLabel.text=[NSString stringWithFormat:@"没有数据%@",[sender objectForKey:@"msg"]];//@"还没有输入评论内容哦～";
        alertLabel.textColor=[UIColor whiteColor];
        alertLabel.textAlignment=NSTextAlignmentCenter;
        //[self.view addSubview:alertLabel];
        
        [NSTimer scheduledTimerWithTimeInterval:2.0f
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:alertLabel
                                        repeats:NO];
        
    }else{
        [actView stopAnimating]; // 结束旋转
        [actView setHidesWhenStopped:YES]; //当旋转结束时隐藏
        //        [self adViewLayout];
    }
    [self PLJKLayout];
}
-(void)PLJKLayout
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    _download = [[DownloadManager alloc]init];
    NSLog(@"%@,,%@",lngString,latString);
    if ((lngString==nil&&latString==nil)||(lngString==NULL&&latString==NULL)) {
        lngString=@"";
        latString=@"";
    }
    NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
    int card_typeId=_vcID-1000;
    NSString *card_type=[NSString stringWithFormat:@"%d",card_typeId];
    _dict =@{@"user_id":_manager.telephone,@"card_from":@"0",@"page":pageStr,@"lng":lngString,@"lat":latString,@"card_type":card_type};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CARD_LIST dict:_dict view:self.view  delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
}
// 错误信息
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error1234567%@",error);
    NSString *errorString;
    [manager stopUpdatingLocation];
    NSLog(@"Error: %@",[error localizedDescription]);
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"Access to Location Services denied by user";
            //Do something...
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"Location data unavailable";
            //Do something else...
            break;
        default:
            errorString = @"An unknown error has occurred";
            break;
    }
    
}

// 6.0 以上调用这个函数
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"%lu", (unsigned long)[locations count]);
    
    CLLocation *newLocation = locations[0];
    CLLocationCoordinate2D oldCoordinate= newLocation.coordinate;
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    lngString=[NSString stringWithFormat:@"%f",oldCoordinate.longitude];
    latString=[NSString stringWithFormat:@"%f",oldCoordinate.latitude];
    [manager stopUpdatingLocation];
    
}

// 6.0 调用此函数
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"%@", @"ok");
}


#pragma mark 获取频道列表失败返回方法
-(void)ChannelFailure:(id)sender
{
    NSLog(@"获取频道列表失败数据%@",sender);
}
- (void)timerFireMethod:(NSTimer*)theTimer
{
    alertLabel.hidden=YES;
}

-(void)logDowLoadFinish:(id)sender
{
    
    NSLog(@"登录后信息：%@",sender);
    senderString=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    //if([tmpStr1 isEqualToString:tmpStr2])
    
    
    //    [self.tableView removeFromSuperview];
    [viewMR removeFromSuperview];
    viewMR=[[UIView alloc]initWithFrame:CGRectMake(0.0f, 134, WIDTH,HEIGHT-64-119)];
    viewMR.backgroundColor=[UIColor colorWithRed:236/255.0f green:236/255.0f blue:236/255.0f alpha:1];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME((WIDTH-100)/2, 40, 100, 100)];
    imageView.image=[UIImage imageNamed:@"家-服务单-无订单_03"];
    [viewMR addSubview:imageView];
    UILabel *la=[[UILabel alloc]init];
    la.text=@"貌似这天你没事哦~";
    la.textAlignment=NSTextAlignmentCenter;
    la.lineBreakMode=NSLineBreakByTruncatingTail;
    [la setNumberOfLines:1];
    [la sizeToFit];
    la.frame=FRAME(20, imageView.frame.origin.y+imageView.frame.size.height, WIDTH-40, 20);
    la.textColor=[UIColor colorWithRed:106/255.0f green:106/255.0f blue:106/255.0f alpha:1];
    //la.backgroundColor=[UIColor redColor];
    [viewMR addSubview:la];
    
    
    
    if ([senderString isEqualToString:@""]) {
        numberArray=nil;
    }else{
        NSArray *array=[sender objectForKey:@"data"];
        if (array.count<10*page) {
            _hasMore=YES;
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
    }
    [self.view addSubview:self.tableView];
    [_tableView reloadData];
    if ((dataString==nil||dataString==NULL||dataString.length==0||[dataString isEqualToString:@""])&&[senderString isEqualToString:@""]){
        viewMR.hidden=NO;
        [self.view addSubview:viewMR];
    }else{
        viewMR.hidden=YES;
        
    }
}
-(void)DownFail:(id)sender
{
    NSLog(@"erroe is %@",sender);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return numberArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=numberArray[indexPath.row];
    NSString *identifier =[NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    int card_type_Id=[[dic objectForKey:@"card_type"]intValue];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
    }
    UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 10)];
    view.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [cell addSubview:view];
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:FRAME(0, 10, WIDTH, 1)];
    lineLabel.backgroundColor=[UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1];
    [cell addSubview:lineLabel];
    
    UIImageView *headeImageView=[[UIImageView alloc]initWithFrame:FRAME(10, 18.5, 40, 40)];
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"head_img_create_user"]];
    [headeImageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
    headeImageView.layer.cornerRadius=headeImageView.frame.size.width/2;
    headeImageView.clipsToBounds=YES;
    [cell addSubview:headeImageView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:FRAME(headeImageView.frame.size.width+20, 24, (WIDTH-60)*0.66, 15)];
    titleLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"card_type_name"]];
    [titleLabel setNumberOfLines:0];
    titleLabel.lineBreakMode =NSLineBreakByTruncatingTail ;
    titleLabel.font=[UIFont fontWithName:@"Arial" size:14];
    [cell addSubview:titleLabel];
    
    UILabel *timeLabels=[[UILabel alloc]initWithFrame:FRAME(headeImageView.frame.size.width+20, titleLabel.frame.size.height+titleLabel.frame.origin.y+8, (WIDTH-60)*0.5, 12)];
    timeLabels.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"card_type_name"]];
    [timeLabels setNumberOfLines:0];
    timeLabels.lineBreakMode =NSLineBreakByTruncatingTail ;
    timeLabels.font=[UIFont fontWithName:@"Arial" size:10];
    [cell addSubview:timeLabels];
    
    UILabel *_promptlabel = [[UILabel alloc] init];//后面还会重新设置其size。
    NSString *clString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
    int clID=[clString intValue];
    
    if (clID==1) {
        _promptlabel.text=@"处理中";
        _promptlabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    }else if (clID==2){
        _promptlabel.text=@"秘书处理中";
        _promptlabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    }else if(clID==3){
        _promptlabel.text=@"已完成";
        _promptlabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    }else if (clID==0){
        _promptlabel.text=@"已取消";
        _promptlabel.textColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    }
    _promptlabel.textAlignment = NSTextAlignmentRight;
    _promptlabel.font=[UIFont fontWithName:@"Arial" size:14];
    [_promptlabel setNumberOfLines:1];
    [_promptlabel sizeToFit];
    _promptlabel.textColor=[UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1];
    _promptlabel.frame=CGRectMake(WIDTH-_promptlabel.frame.size.width-5,25,_promptlabel.frame.size.width,27);
    [cell addSubview:_promptlabel];
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(_promptlabel.frame.size.width, 0, 10, _promptlabel.frame.size.height)];
    image.image=[UIImage imageNamed:@"SYCELL_YHB_@2x"];
    [_promptlabel addSubview:image];
    UIImageView *image2=[[UIImageView alloc]initWithFrame:CGRectMake(-20, 0, _promptlabel.frame.size.width+20, _promptlabel.frame.size.height)];
    image2.image=[UIImage imageNamed:@"SYCELL_YHBY_@2x"];
    [_promptlabel addSubview:image2];
    
    UILabel*_contentLabel=[[UILabel alloc]init];
    _contentLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_content"]];
    _contentLabel.font=[UIFont fontWithName:@"Arial" size:13];
    _contentLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
    _contentLabel.numberOfLines=0;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil];
    CGSize size = [_contentLabel.text boundingRectWithSize:CGSizeMake(WIDTH-20, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;;
    _contentLabel.frame=CGRectMake(18, headeImageView.frame.size.height+45, WIDTH-36, size.height);
    [cell addSubview:_contentLabel];
    
    UIView *lineViews=[[UIView alloc]initWithFrame:FRAME(0, _contentLabel.frame.size.height+_contentLabel.frame.origin.y+20, WIDTH, 1)];
    lineViews.backgroundColor=[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
    [cell addSubview:lineViews];
    
    UILabel *total_zan=[[UILabel alloc]initWithFrame:FRAME(WIDTH/3/2+5, _contentLabel.frame.size.height+_contentLabel.frame.origin.y+30, (WIDTH-42-66)/3, 22)];
    total_zan.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"total_zan"]];
    total_zan.textAlignment=NSTextAlignmentLeft;
    total_zan.lineBreakMode=NSLineBreakByTruncatingTail;
    [total_zan setNumberOfLines:1];
    [total_zan sizeToFit];
    total_zan.font=[UIFont fontWithName:@"Arial" size:13];
    total_zan.textColor=[UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1];
    [cell addSubview:total_zan];
    
    UILabel *_commentLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/3/2+5+WIDTH/3, _contentLabel.frame.size.height+_contentLabel.frame.origin.y+30, (WIDTH-42-66)/3, 22)];
    _commentLabel.textAlignment=NSTextAlignmentLeft;
    _commentLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"total_comment"]];
    _commentLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [_commentLabel setNumberOfLines:1];
    [_commentLabel sizeToFit];
    _commentLabel.font=[UIFont fontWithName:@"Arial" size:13];
    _commentLabel.textColor=[UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1];
    [cell addSubview:_commentLabel];
    
    NSArray *array=@[@"common_icon_like_c@2x(1)",@"common_icon_review@2x(1)",@"common_icon_share@2x(1)"];
    UIButton *zaButton=[[UIButton alloc]initWithFrame:CGRectMake(0, _contentLabel.frame.size.height+_contentLabel.frame.origin.y+21, WIDTH/3-0.5, 40)];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME((zaButton.frame.size.width-20)/2-5, 10, 20, 20)];
    imageView.image=[UIImage imageNamed:array[0]];
    [zaButton addSubview:imageView];
    [zaButton setTag:indexPath.row];
    [zaButton addTarget:self action:@selector(zaButtonan:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:zaButton];
    UIButton *plButton=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH/3*1+0.5, zaButton.frame.origin.y, WIDTH/3-1, 40)];
    UIImageView *plImageView=[[UIImageView alloc]initWithFrame:FRAME((plButton.frame.size.width-20)/2-5, 10, 20, 20)];
    plImageView.image=[UIImage imageNamed:array[1]];
    [plButton addSubview:plImageView];
    [plButton setTag:indexPath.row];
    [plButton addTarget:self action:@selector(plButtonan:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:plButton];
    UIButton *fxButton=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH/3*2-0.5, zaButton.frame.origin.y, WIDTH/3-0.5, 40)];
    UIImageView *fxImageView=[[UIImageView alloc]initWithFrame:FRAME((fxButton.frame.size.width-20)/2, 10, 20, 20)];
    fxImageView.image=[UIImage imageNamed:array[2]];
    [fxButton addSubview:fxImageView];
    [fxButton setTag:indexPath.row];
    [fxButton addTarget:self action:@selector(fxButtonan:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:fxButton];

    UIView *lineView=[[UIView alloc]initWithFrame:FRAME(0,zaButton.frame.origin.y+40, WIDTH, 1)];
    lineView.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [cell addSubview:lineView];
    for (int i=0; i<2; i++) {
        UIView *lineView=[[UIView alloc]initWithFrame:FRAME(WIDTH/3-0.5+WIDTH/3*i, zaButton.frame.origin.y+10, 1, 20)];
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
    
    NSDictionary *plDic=numberArray[indexPath.row];
    NSString *inforStr = [NSString stringWithFormat:@"%@",[plDic objectForKey:@"service_content"]];
    UIFont *font = [UIFont systemFontOfSize:14];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize size = [inforStr boundingRectWithSize:CGSizeMake(WIDTH-20, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size.height+148;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    int card_type_Id=[[numberArray[indexPath.row] objectForKey:@"card_type"]intValue];
    if (card_type_Id==99) {
        
    }else{
        NSString *card_ID=[numberArray[indexPath.row]objectForKey:@"card_id"];
        NSLog(@"card_id%@",card_ID);
        vc=[[DetailsListViewController alloc]init];
        vc.card_ID=[card_ID intValue];
        vc.S=S;
        [self.navigationController pushViewController:vc animated:YES];
    }

    
}
-(void)zaButtonan:(UIButton *)sender
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    //DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *card_Id=[numberArray[sender.tag]objectForKey:@"card_id"];
    NSLog(@"ID%@",card_Id);
    _dict = @{@"card_id":card_Id,@"user_id":_manager.telephone};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CARD_DZ dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadDA:) isPost:YES failedSEL:@selector(DZDownFail:)];
    
}
-(void)logDowLoadDA:(id)sender
{
    NSLog(@"点赞成功");
    [self PLJKLayout];
    
}
-(void)DZDownFail:(id)sender
{
    NSLog(@"点赞失败");
}

-(void)plButtonan:(UIButton *)sender
{
    NSString *card_ID=[numberArray[sender.tag]objectForKey:@"card_id"];
    NSLog(@"card_id%@",card_ID);
    vc=[[DetailsListViewController alloc]init];
    vc.S=S;
    vc.card_ID=[card_ID intValue];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)fxButtonan:(UIButton *)sender
{
    [UMSocialSnsService presentSnsIconSheetView:self appKey:YMAPPKEY shareText:@"云行政，企业行政服务第一平台！极大降低企业行政管理成本，有效提升行政综合服务能力，快来试试吧！体验就送礼哦：http://51xingzheng.cn/h5-app-download.html" shareImage:[UIImage imageNamed:@"yunxingzheng-Logo-512.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina,nil] delegate:self];
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
