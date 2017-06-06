//
//  ViewController.m
//  Example
//
//  Created by Jonathan Tribouharet.
//

#import "ViewController.h"
#import "ISLoginManager.h"
#import "DownloadManager.h"
#import "PageTableViewCell.h"
#import "DetailsListViewController.h"
#import "WXApi.h"
#import "MineViewController.h"
#import "QRcodeViewController.h"
#import "LBXScanViewStyle.h"
#import "LBXScanViewController.h"

#import "ClerkViewController.h"
#import "FountWebViewController.h"
#import "CycleScrollView.h"

#import "Dynamic_DetailsViewController.h"
#import "BookingViewController.h"
#import "ChatListViewController.h"
#import "WebPageViewController.h"
#import "LeaveDetailsViewController.h"
#import "LeaveListViewController.h"
#import "ApplyFriendsListViewController.h"
#import "AttendanceViewController.h"
#import "WaterListViewController.h"
#import "Order_DetailsViewController.h"

//#import "UMCommunityViewController.h"
#import "Set_Up_ScheduleViewController.h"
#import "ask_listDetailsViewController.h"

#import "JTCalendarMenuMonthView.h"
#import "MeetingViewController.h"
@interface ViewController (){
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
    UIView *foldingView;
    UIImageView *foldingImage;
    
    int  upID;
    int  downID;
    UIView *viewLine;
    NSMutableArray *monthsViews;

}

@end
CGFloat newHeight = 290;
int FF=0,MM=0,NN=0,SS,eyeIDS=0;
@implementation ViewController
@synthesize latString,lngString;
float lastContentOffset;
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [super viewWillAppear:animated];
    if (_needRefresh) {
        [_refreshHeader beginRefreshing];
        _needRefresh = NO;
    }

    [MobClick beginLogPageView:@"提醒"];
    
    if (vc.L==1) {
        _tableView.scrollEnabled =NO;
    }
//    [self rlLayout];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"提醒"];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    NSDate *  senddates=[NSDate date];
   ISLoginManager *_manager = [ISLoginManager shareManager];
    NSDateFormatter  *yerformatter=[[NSDateFormatter alloc] init];
    [yerformatter setDateFormat:@"yyyy"];
    NSString *  yearStr=[yerformatter stringFromDate:senddates];
    
    NSDateFormatter  *monthformatter=[[NSDateFormatter alloc] init];
    [monthformatter setDateFormat:@"MM"];
    NSString *  monthStr=[monthformatter stringFromDate:senddates];
    DownloadManager *download = [[DownloadManager alloc]init];
    NSDictionary *dict=@{@"user_id":_manager.telephone,@"year":yearStr,@"month":monthStr};
    [download requestWithUrl:@"simi/app/user/msg/total_by_month.json"  dict:dict view:self.view delegate:self finishedSEL:@selector(RiLiSuccess:) isPost:NO failedSEL:@selector(RiLiFailure:)];
    
    UIView *headeView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 20)];
    headeView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:headeView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    page=1;
    numberArray=[[NSMutableArray alloc]init];
//    self.imageView.image=[UIImage imageNamed:@"cal-bg.jpg"];
    
    self.imageView.backgroundColor=[UIColor whiteColor];//colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    // 开始时时定位
    [locationManager startUpdatingLocation];
    
    
    
    actView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    actView.center = CGPointMake(WIDTH/2, HEIGHT/2);
    actView.color = [UIColor blackColor];
    [actView startAnimating];
    [self.tableView addSubview:actView];
    imageArray=[[NSMutableArray alloc]init];
    self.view.frame=FRAME(0, 0, WIDTH, HEIGHT-50);
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    timeString=locationString;
    
    
    UIButton *myButton=[[UIButton alloc]initWithFrame:FRAME(15, 25, 30, 30)];
    [myButton addTarget:self action:@selector(myButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *myImage=[[UIImageView alloc]initWithFrame:FRAME(5, 5, 20, 20)];
    myImage.image=[UIImage imageNamed:@"GRZX_BT"];
    [myButton addSubview:myImage];
    
    UIButton *eyeButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-50, 25, 50, 40)];
    [eyeButton addTarget:self action:@selector(eyeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    eyeButton.tag=1101;
    [self.view addSubview:eyeButton];
    
    UIImageView *eyeImage=[[UIImageView alloc]initWithFrame:FRAME(15, 10, 20, 20)];
    eyeImage.image=[UIImage imageNamed:@"提醒"];//EYE_BT
    [eyeButton addSubview:eyeImage];
    
    
    UIButton *addBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH-100, 25, 50, 40)];
    addBut.tag=1102;
    [addBut addTarget:self action:@selector(eyeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBut];
    
    UIImageView *addImage=[[UIImageView alloc]initWithFrame:FRAME(15, 10, 20, 20)];
    addImage.image=[UIImage imageNamed:@"快速提醒"];//EYE_BT
    [addBut addSubview:addImage];
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    riliArray=delegate.riliArray;
    viewLine=[[UIView alloc]initWithFrame:FRAME(0, newHeight+74.5, WIDTH, 1)];
    viewLine.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [self.view addSubview:viewLine];
    foldingView=[[UIView alloc]initWithFrame:FRAME((WIDTH-40)/2, newHeight+70, 40, 10)];
    foldingView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:foldingView];
    foldingImage=[[UIImageView alloc]initWithFrame:FRAME(10, 0, 20, 10)];
    foldingImage.image=[UIImage imageNamed:@"rili_arrow_down"];
    [foldingView addSubview:foldingImage];
    
    [self rlLayout];
   
}


-(void)RiLiSuccess:(id)sender
{
    NSArray *array=[sender objectForKey:@"data"];
    AppDelegate *delegates=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegates.riliArray removeAllObjects];
    for (int i=0; i<array.count; i++) {
        if([delegates.riliArray containsObject:array[i]])
        {
            
        }else{
            [delegates.riliArray addObject:array[i]];
        }
    }
    [delegates.eventsByDate removeAllObjects];
    for(int i = 0; i <delegates.riliArray.count; ++i){
        NSDictionary *dic=delegates.riliArray[i];
        NSString *riliStr=[NSString stringWithFormat:@"%@ 07:10:00",[dic objectForKey:@"service_date"]];
        NSString *theFirstTime1=[NSString stringWithFormat:@"%@",riliStr];
        NSDateFormatter *theFirstformatte1 = [[NSDateFormatter alloc] init];
        [theFirstformatte1 setDateStyle:NSDateFormatterMediumStyle];
        [theFirstformatte1 setTimeStyle:NSDateFormatterShortStyle];
        [theFirstformatte1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* theFirstdate1 = [theFirstformatte1 dateFromString:theFirstTime1];
        //        NSDate *randomDate = [theFirstformatte1 dateFromString:theFirstTime1];//[NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        NSString *key = [[self dateFormatter] stringFromDate:theFirstdate1];
        
        if(!delegates.eventsByDate[key]){
            delegates.eventsByDate[key] = [NSMutableArray new];
        }
        
        [delegates.eventsByDate[key] addObject:theFirstdate1];
    }

    
}
-(void)RiLiFailure:(id)sender
{
    NSLog(@"日历布局失败返回:是啥%@",sender);
    alertLabel=[[UILabel alloc]initWithFrame:FRAME((WIDTH-260)/2, (HEIGHT-40)/2, 260, 40)];
    alertLabel.backgroundColor=[UIColor blackColor];
    alertLabel.alpha=0.4;
    alertLabel.text=@"还没有输入评论内容哦～";
    alertLabel.textColor=[UIColor whiteColor];
    alertLabel.textAlignment=NSTextAlignmentCenter;
    //    [self.view addSubview:alertLabel];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f
                                     target:self
                                   selector:@selector(viewLayout:)
                                   userInfo:alertLabel
                                    repeats:NO];
}
-(void)viewLayout:(UILabel *)albel
{
    
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
    //通过控制page控制更多 网路数据
    //    [_service reqwithPageSize:INVESTPAGESIZE page:page];
    //    [self loadImg];
    
    //本底数据
    //    [_arrData addObjectsFromArray:[UIFont familyNames]];
    
    [self PLJKLayout];
    
    
    
}

#pragma mark 表格刷新相关
#pragma mark日历
-(void)rlLayout
{
    
    self.calendar = [JTCalendar new];
    
    // All modifications on calendarAppearance have to be done before setMenuMonthsView and setContentView
    // Or you will have to call reloadAppearance
    {
        self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
        self.calendar.calendarAppearance.ratioContentMenu = 1.;
    }
    
//    [self.calendar setMenuMonthsView:self.calendarMenuView];
//    [self.calendar setContentView:self.calendarContentView];
//    [self.calendar setDataSource:self];
    OcclusionView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, _tableView.frame.size.height)];
    OcclusionView.backgroundColor=[UIColor blueColor];
    OcclusionView.userInteractionEnabled=YES;
    [_tableView addSubview:OcclusionView];
    OcclusionView.hidden=YES;
    
    
//    self.calendarContentView.alpha=0.8;
//    self.calendarMenuView.alpha=0.8;
//    self.calendar
    self.calendarMenuView.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
    
    [self createRandomEvents];
    
    [self.calendar reloadData];
    
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    [self transitionExample];
   
    [self tableViewLayout];
    
    UISwipeGestureRecognizer *upGe;
    upGe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [upGe setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [[self calendarContentView] addGestureRecognizer:upGe];
    
    UISwipeGestureRecognizer *downGe;
    downGe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [downGe setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self calendarContentView] addGestureRecognizer:downGe];
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        if (downID%2==0) {
            if (upID==0) {
                upID++;
            }
            downID++;
            [self didChangeModeTouch];
        }
        
        NSLog(@"swipe down");
        //执行程序
    }
    if(recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
        if (upID==1) {
            if (upID%2!=0) {
                upID--;
            }
            if (downID!=0) {
                downID--;
            }
            [self didChangeModeTouch];
        }
                NSLog(@"swipe up");
        //执行程序
    }
}
#pragma mark 首页右上按钮点击方法
-(void)eyeButtonAction:(UIButton *)button
{
//    NSArray *arrayItems = @[@[@"模拟qq扫码界面",@"qqStyle"]];
//    NSArray* array = arrayItems[0];
//    NSString *methodName = [array lastObject];
//    
//    SEL normalSelector = NSSelectorFromString(methodName);
//    if ([self respondsToSelector:normalSelector]) {
//        
//        ((void (*)(id, SEL))objc_msgSend)(self, normalSelector);
//    }
    if (button.tag==1101) {
        Set_Up_ScheduleViewController *setVC=[[Set_Up_ScheduleViewController alloc]init];
        [self.navigationController pushViewController:setVC animated:YES];
    }else if (button.tag==1102){
        MeetingViewController *meetVC=[[MeetingViewController alloc]init];
        meetVC.vcID=1003;
        [self.navigationController pushViewController:meetVC animated:YES];
    }
    
}
#pragma mark -模仿qq界面
- (void)qqStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    style.photoframeLineW = 6;
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //qq里面的线条图片
    UIImage *imgLine = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    style.animationImage = imgLine;
    
    LBXScanViewController *lBvc = [LBXScanViewController new];
    lBvc.style = style;
    lBvc.isQQSimulator = YES;
    [self.navigationController pushViewController:lBvc animated:YES];
}
-(void)tableViewLayout
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, newHeight+80, WIDTH,HEIGHT-newHeight-129)];
    self.tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=[UIColor whiteColor];//colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
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
    adView= [[CycleScrollView alloc]initWithFrame:FRAME(0, newHeight+80, WIDTH, (WIDTH*0.42+40)) animationDuration:5];
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
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(WIDTH-5*arrayImage.count-10*(arrayImage.count+1), WIDTH*0.42+newHeight+80, 5*arrayImage.count+10*(arrayImage.count+1), 30)];
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
-(void)removeTimer
{
    [timer invalidate];
    timer = nil;
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
//    NSLog(@"%@,,%@",lngString,latString);
//    if ((lngString==nil&&latString==nil)||(lngString==NULL&&latString==NULL)) {
//        lngString=@"";
//        latString=@"";
//    }
    [actView startAnimating];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    _download = [[DownloadManager alloc]init];
   
    NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
    _dict =@{@"user_id":_manager.telephone,@"service_date":timeString,@"page":pageStr};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CADR_NEWSLIST dict:_dict view:self.view  delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
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
    viewMR=[[UIView alloc]initWithFrame:CGRectMake(0.0f, newHeight+80, WIDTH,HEIGHT-newHeight-129)];
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
        if (array.count<10) {
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
    }
    _tableView.frame=CGRectMake(0, newHeight+80, WIDTH,HEIGHT-newHeight-129);
//    self.tableView.tableHeaderView=adView;
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

- (void)viewDidLayoutSubviews
{
//    [self.calendar repositionViews];
}

#pragma mark - Buttons callback

- (void)didGoTodayTouch
{
    [self.calendar setCurrentDate:[NSDate date]];
}

- (void)didChangeModeTouch
{
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    [self transitionExample];
}


- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *  locationString=[dateformatter stringFromDate:date];
    timeString=locationString;
    NSLog(@"Date: %@ events", locationString);
    page=1;
    monthsViews = [NSMutableArray new];
    AppDelegate *delegates=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    monthsViews=delegates.monthsViews;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSDate* dates = [formatter dateFromString:timeString];
    JTCalendarMenuMonthView *monthView = [monthsViews lastObject];
    
    [monthsViews removeLastObject];
    [monthsViews insertObject:monthView atIndex:1];
    
    // Update monthView
    {
        [monthView setMonthIndex:dates];
    }
    
    [monthView reloadAppearance];
    [self.calendarMenuView reloadAppearance];
    [self PLJKLayout];
}

- (void)calendarDidLoadPreviousPage
{
    NSLog(@"Previous page loaded");
}

- (void)calendarDidLoadNextPage
{
    NSLog(@"Next page loaded");
}

#pragma mark - Transition examples

- (void)transitionExample
{
    
    if(self.calendar.calendarAppearance.isWeekMode){
        newHeight = 65;
        [UIView beginAnimations:nil context:nil];
        //设置动画时长
        [UIView setAnimationDuration:0.5];
        foldingImage.image=[UIImage imageNamed:@"rili_arrow_down"];
        foldingView.frame=FRAME((WIDTH-40)/2, newHeight+70, 40, 10);
        viewLine.frame=FRAME(0, newHeight+74.5, WIDTH, 1);
        [foldingBut setTitle:@"展开" forState:UIControlStateNormal];
        [UIView commitAnimations];
    }else{
        newHeight = 290;
        [UIView beginAnimations:nil context:nil];
        //设置动画时长
        [UIView setAnimationDuration:0.5];
        foldingImage.image=[UIImage imageNamed:@"rili_arrow_up"];
        foldingView.frame=FRAME((WIDTH-40)/2, newHeight+70, 40, 10);
        viewLine.frame=FRAME(0, newHeight+74.5, WIDTH, 1);
        [foldingBut setTitle:@"收起" forState:UIControlStateNormal];
        [UIView commitAnimations];
    }
    [self scrollLayout];
}

-(void)scrollLayout
{
    [UIView animateWithDuration:.5
                     animations:^{
                         [UIView beginAnimations:nil context:nil];
                         //设置动画时长
                         [UIView setAnimationDuration:0.5];
                         self.calendarContentViewHeight.constant = newHeight;
                         [UIView commitAnimations];
                         
                         [self.view layoutIfNeeded];
                     }];
    
    [UIView animateWithDuration:.25
                     animations:^{
                         self.calendarContentView.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.calendar reloadAppearance];
                         
                         [UIView animateWithDuration:.25
                                          animations:^{
                                              self.calendarContentView.layer.opacity = 0.9;
                                          }];
                     }];
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    adView.frame=FRAME(0, newHeight+80, WIDTH, WIDTH*0.42+40);
    if (dataString==nil||dataString==NULL||dataString.length==0||[dataString isEqualToString:@""]){
       viewMR.frame=CGRectMake(0.0f, newHeight+80, WIDTH,HEIGHT-newHeight-129);
        self.tableView.frame=CGRectMake(0.0f, newHeight+80, WIDTH,HEIGHT-newHeight-129);
    }else{
        viewMR.frame=CGRectMake(0.0f, newHeight+80, WIDTH,HEIGHT-newHeight-129);
        self.tableView.frame=CGRectMake(0.0f, newHeight+80, WIDTH,HEIGHT-newHeight-129);
    }
    
    
    
    [UIView commitAnimations];
    
}
#pragma mark - Fake data

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    
    return dateFormatter;
}

#pragma mark - JTCalendarDataSource

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    eventsByDate = [NSMutableDictionary new];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    eventsByDate=delegate.eventsByDate;
   
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(eventsByDate[key] && [eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
}
- (void)createRandomEvents
{
    eventsByDate = [NSMutableDictionary new];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    riliArray=delegate.riliArray;
    for(int i = 0; i < riliArray.count; ++i){
        NSDictionary *dic=riliArray[i];
        NSString *riliStr=[NSString stringWithFormat:@"%@ 07:10:00",[dic objectForKey:@"service_date"]];
        NSString *theFirstTime1=[NSString stringWithFormat:@"%@",riliStr];
        NSDateFormatter *theFirstformatte1 = [[NSDateFormatter alloc] init];
        [theFirstformatte1 setDateStyle:NSDateFormatterMediumStyle];
        [theFirstformatte1 setTimeStyle:NSDateFormatterShortStyle];
        [theFirstformatte1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* theFirstdate1 = [theFirstformatte1 dateFromString:theFirstTime1];
//        NSDate *randomDate = [theFirstformatte1 dateFromString:theFirstTime1];//[NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        NSString *key = [[self dateFormatter] stringFromDate:theFirstdate1];
        
        if(!eventsByDate[key]){
            eventsByDate[key] = [NSMutableArray new];
        }
             
        [eventsByDate[key] addObject:theFirstdate1];
    }
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
    NSDictionary *dataDic=numberArray[indexPath.row];
    NSString *identifier = [NSString stringWithFormat:@"cell%ld,%ld",(long)indexPath.row,(long)indexPath.section];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    UIImageView *headImageView=[[UIImageView alloc]initWithFrame:FRAME(10, 10, 50, 50)];
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"icon_url"]];
    [headImageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
    headImageView.layer.cornerRadius=headImageView.frame.size.width/2;
    headImageView.clipsToBounds=YES;
    [cell addSubview:headImageView];
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.font=[UIFont fontWithName:@"STHeitiSC-Light" size:16];
    titleLabel.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"title"]];
    [titleLabel setNumberOfLines:1];
    [titleLabel sizeToFit];
    titleLabel.frame=FRAME(headImageView.frame.size.width+20, 13, titleLabel.frame.size.width, 20);
    [cell addSubview:titleLabel];
    
    UILabel *msg_timeLab=[[UILabel alloc]init];
    msg_timeLab.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"msg_time"]];
    msg_timeLab.font=[UIFont fontWithName:@"Heiti SC" size:12];
    msg_timeLab.textColor=[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
    [msg_timeLab setNumberOfLines:1];
    [msg_timeLab sizeToFit];
    msg_timeLab.frame=FRAME(WIDTH-msg_timeLab.frame.size.width-10, 13, msg_timeLab.frame.size.width, 13);
    [cell addSubview:msg_timeLab];
    
    UILabel *summaryLab=[[UILabel alloc]initWithFrame:FRAME(titleLabel.frame.origin.x, 37, WIDTH-titleLabel.frame.origin.x-10, 20)];
    summaryLab.font=[UIFont fontWithName:@"STHeitiSC-Light" size:14];
    summaryLab.textColor=[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1];
    summaryLab.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"summary"]];
    summaryLab.lineBreakMode=NSLineBreakByTruncatingTail;
    [cell addSubview:summaryLab];
    
    UIView *lineView=[[UIView alloc]initWithFrame:FRAME(headImageView.frame.size.width+20, 70 , WIDTH-(headImageView.frame.size.width+20), 1)];
    lineView.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [cell addSubview:lineView];
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        dispatch_async(dispatch_get_main_queue(),^{
            [actView stopAnimating]; // 结束旋转
            [actView setHidesWhenStopped:YES]; //当旋转结束时隐藏
            [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        });
    }

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    PageTableViewCell *cell =[[PageTableViewCell alloc]init];
//    return cell.view.frame.size.height;
    return 71;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary *dataDic=numberArray[indexPath.row];
    NSString *categoryStr=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"category"]];
    NSString *actionStr=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"action"]];
    if ([categoryStr isEqualToString:@"app"]) {
        if ([actionStr isEqualToString:@"card"]) {
            NSString *card_ID=[numberArray[indexPath.row]objectForKey:@"params"];
            NSLog(@"card_id%@",card_ID);
            vc=[[DetailsListViewController alloc]init];
            vc.card_ID=[card_ID intValue];
            vc.S=SS;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([actionStr isEqualToString:@"feed"]){
            
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
            ask_listDetailsViewController *dyVC=[[ask_listDetailsViewController alloc]init];
            dyVC.msg_id=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"params"]];
            dyVC.vcID=100;
            [self.navigationController pushViewController:dyVC animated:YES];

        }else if ([actionStr isEqualToString:@"checkin"]){
            AttendanceViewController *bookVC=[[AttendanceViewController alloc]init];
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
            NSString *has_company=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"has_company"]];
            int has=[has_company intValue];
            if (has==0) {
                bookVC.webID=0;
            }else{
                bookVC.webID=1;
            }

            [self.navigationController pushViewController:bookVC animated:YES];
            
        }else if ([actionStr isEqualToString:@"im"]){
            ChatListViewController *chatListVC=[[ChatListViewController alloc]init];
            chatListVC.listVcID=100;
            [self.navigationController pushViewController:chatListVC animated:YES];
        }else if ([actionStr isEqualToString:@"leave_pass"]){
            LeaveDetailsViewController *leaveVC=[[LeaveDetailsViewController alloc]init];
            leaveVC.leaveVC_id=101;
            leaveVC.leave_id=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"params"]];
            [self.navigationController pushViewController:leaveVC animated:YES];
        }else if ([actionStr isEqualToString:@"leave"]){
            LeaveListViewController *leaveVC=[[LeaveListViewController alloc]init];
            [self.navigationController pushViewController:leaveVC animated:YES];
        }else if ([actionStr isEqualToString:@"friends"]){
            ApplyFriendsListViewController *friendsVC=[[ApplyFriendsListViewController alloc]init];
            friendsVC.vcID=100;
            friendsVC.listID=1001;
            [self.navigationController pushViewController:friendsVC animated:YES];
        }else if ([actionStr isEqualToString:@"company_pass"]){
            ApplyFriendsListViewController *friendsVC=[[ApplyFriendsListViewController alloc]init];
            friendsVC.vcID=100;
            friendsVC.listID=1002;
            [self.navigationController pushViewController:friendsVC animated:YES];
        }else if ([actionStr isEqualToString:@"water"]){
            Order_DetailsViewController *order_vc=[[Order_DetailsViewController alloc]init];
            order_vc.order_ID=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"params"]];
            order_vc.user_ID=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"user_id"]];
            [self.navigationController pushViewController:order_vc animated:YES];
        }else if ([actionStr isEqualToString:@"recycle"]){
            Order_DetailsViewController *order_vc=[[Order_DetailsViewController alloc]init];
            order_vc.order_ID=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"params"]];
            order_vc.user_ID=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"user_id"]];
            [self.navigationController pushViewController:order_vc animated:YES];
        }else if ([actionStr isEqualToString:@"clean"]){
            Order_DetailsViewController *order_vc=[[Order_DetailsViewController alloc]init];
            order_vc.order_ID=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"params"]];
            order_vc.user_ID=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"user_id"]];
            [self.navigationController pushViewController:order_vc animated:YES];
        }else if ([actionStr isEqualToString:@"teamwork"]){
            Order_DetailsViewController *order_vc=[[Order_DetailsViewController alloc]init];
            order_vc.order_ID=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"params"]];
            order_vc.user_ID=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"user_id"]];
            [self.navigationController pushViewController:order_vc animated:YES];
        }else if ([actionStr isEqualToString:@"express"]){
            
        }
    }else{
        WebPageViewController *webPageVC=[[WebPageViewController alloc]init];
        webPageVC.barIDS=100;
        webPageVC.webURL=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"goto_url"]];
        [self.navigationController pushViewController:webPageVC animated:YES];
    }
}


@end
