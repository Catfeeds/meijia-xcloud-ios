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
#import "DetailsViewController.h"
#import "ShareFriendViewController.h"
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
    DetailsViewController *vc;
    
    
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

}

@end
CGFloat newHeight = 290;
int F=0,M=0,N=0,S,eyeID=0;
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

    [MobClick beginLogPageView:@"首页"];
    
    if (vc.L==1) {
        _tableView.scrollEnabled =NO;
    }
//    [self rlLayout];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"首页"];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *headeView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 20)];
    headeView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:headeView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    page=1;
    numberArray=[[NSMutableArray alloc]init];
//    self.imageView.image=[UIImage imageNamed:@"cal-bg.jpg"];
    
    self.imageView.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
//    UIImageView *imageView=(UIImageView *)[self.view viewWithTag:100];
//    imageView.image=[UIImage imageNamed:@"cal-bg.jpg"];
    
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
    
    UIButton *eyeButton=[[UIButton alloc]initWithFrame:FRAME(15, 25, 50, 40)];
    [eyeButton addTarget:self action:@selector(eyeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:eyeButton];
    
    UIImageView *eyeImage=[[UIImageView alloc]initWithFrame:FRAME(5, 10, 20, 20)];
    eyeImage.image=[UIImage imageNamed:@"iconfont-saoma"];//EYE_BT
    [eyeButton addSubview:eyeImage];
    
    UIButton *calenderButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-50, 25, 50, 40)];
    [calenderButton addTarget:self action:@selector(didChangeModeTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:calenderButton];
    
    UIImageView *calenderImage=[[UIImageView alloc]initWithFrame:FRAME(10, 10, 20, 20)];
    calenderImage.image=[UIImage imageNamed:@"icon_rili"];
    [calenderButton addSubview:calenderImage];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    riliArray=delegate.riliArray;
    foldingView=[[UIView alloc]initWithFrame:FRAME((WIDTH-40)/2, newHeight+70, 40, 10)];
    foldingView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:foldingView];
    foldingImage=[[UIImageView alloc]initWithFrame:FRAME(10, 0, 20, 10)];
    foldingImage.image=[UIImage imageNamed:@"rili_arrow_down"];
    [foldingView addSubview:foldingImage];
    [self rlLayout];
   
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
    
    [self PLJKLayout];
    
    
    
}

#pragma mark 表格刷新相关
#pragma mark日历
-(void)rlLayout
{
    
    self.calendar = [JTCalendar new];
    {
        self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
        self.calendar.calendarAppearance.ratioContentMenu = 2.;
        self.calendar.calendarAppearance.focusSelectedDayChangeMode = YES;
        
        // Customize the text for each month
        self.calendar.calendarAppearance.monthBlock = ^NSString *(NSDate *date, JTCalendar *jt_calendar){
            NSCalendar *calendar = jt_calendar.calendarAppearance.calendar;
            NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
            NSInteger currentMonthIndex = comps.month;
            
            static NSDateFormatter *dateFormatter;
            if(!dateFormatter){
                dateFormatter = [NSDateFormatter new];
                dateFormatter.timeZone = jt_calendar.calendarAppearance.calendar.timeZone;
            }
            
            while(currentMonthIndex <= 0){
                currentMonthIndex += 12;
            }
            
            NSString *monthText = [[dateFormatter standaloneMonthSymbols][currentMonthIndex - 1] capitalizedString];
            
            return [NSString stringWithFormat:@"%ld\n%@", (long)comps.year, monthText];
        };
    }
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

}
#pragma mark 首页右上按钮点击方法
-(void)eyeButtonAction:(UIButton *)button
{
    NSArray *arrayItems = @[@[@"模拟qq扫码界面",@"qqStyle"]];
    NSArray* array = arrayItems[0];
    NSString *methodName = [array lastObject];
    
    SEL normalSelector = NSSelectorFromString(methodName);
    if ([self respondsToSelector:normalSelector]) {
        
        ((void (*)(id, SEL))objc_msgSend)(self, normalSelector);
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
//    adView=[[UIScrollView alloc]initWithFrame:FRAME(0, newHeight+70, WIDTH, (WIDTH*0.42+40))];
//    adView.bounces=NO;
//    adView.delegate=self;
//    adView.pagingEnabled = YES;
//    adView.showsHorizontalScrollIndicator = NO;
//    adView.contentSize=CGSizeMake(WIDTH*arrayImage.count, WIDTH*0.42+40);
//    adView.autoresizingMask = 0xFF;
//    adView.contentMode = UIViewContentModeCenter;
//    adView.contentOffset = CGPointMake(CGRectGetWidth(adView.frame), 0);
//    adView.pagingEnabled = YES;
        //[self.view addSubview:adView];
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
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView1
//{
//    pageControl.currentPage = scrollView1.contentOffset.x/WIDTH;
//}
//
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [self removeTimer];
//}
//
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    [self addTimer];
//}
//
//-(void)addTimer
//{
//    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
//}

//-(void)nextPage
//{
//    long page = pageControl.currentPage;
//    if (page == arrayImage.count - 1) {
//        page =0;
//        CGFloat offsetX = page * adView.frame.size.width;
//        CGPoint offset = CGPointMake(offsetX, 0);
//        [adView setContentOffset:offset animated:NO];
//    }
//    else {
//        page = pageControl.currentPage + 1;
//        CGFloat offsetX = page * adView.frame.size.width;
//        CGPoint offset = CGPointMake(offsetX, 0);
//        [adView setContentOffset:offset animated:YES];
//    }
//    
//}

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
    [self.calendar repositionViews];
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
        foldingImage.image=[UIImage imageNamed:@"rili_arrow_down"];
        foldingView.frame=FRAME((WIDTH-40)/2, newHeight+70, 40, 10);
        [foldingBut setTitle:@"展开" forState:UIControlStateNormal];
    }else{
        newHeight = 290;
        foldingImage.image=[UIImage imageNamed:@"rili_arrow_up"];
        foldingView.frame=FRAME((WIDTH-40)/2, newHeight+70, 40, 10);
        [foldingBut setTitle:@"收起" forState:UIControlStateNormal];
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
    UIImageView *headImageView=[[UIImageView alloc]initWithFrame:FRAME(10, 10, 40, 40)];
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
    titleLabel.frame=FRAME(headImageView.frame.size.width+20, 10, titleLabel.frame.size.width, 20);
    [cell addSubview:titleLabel];
    
    UILabel *msg_timeLab=[[UILabel alloc]init];
    msg_timeLab.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"msg_time"]];
    msg_timeLab.font=[UIFont fontWithName:@"Arial" size:10];
    msg_timeLab.textColor=[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
    [msg_timeLab setNumberOfLines:1];
    [msg_timeLab sizeToFit];
    msg_timeLab.frame=FRAME(WIDTH-msg_timeLab.frame.size.width-10, 10, msg_timeLab.frame.size.width, 10);
    [cell addSubview:msg_timeLab];
    
    UILabel *summaryLab=[[UILabel alloc]initWithFrame:FRAME(titleLabel.frame.origin.x, 30, WIDTH-titleLabel.frame.origin.x-10, 20)];
    summaryLab.font=[UIFont fontWithName:@"STHeitiSC-Light" size:14];
    summaryLab.textColor=[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1];
    summaryLab.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"summary"]];
    summaryLab.lineBreakMode=NSLineBreakByTruncatingTail;
    [cell addSubview:summaryLab];
    
    UIView *lineView=[[UIView alloc]initWithFrame:FRAME(headImageView.frame.size.width+20, 60, WIDTH-(headImageView.frame.size.width+20), 1)];
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
    return 61;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
//    if (indexPath.row==1) {
//        WebPageViewController *webPageVC=[[WebPageViewController alloc]init];
//        webPageVC.webURL=@"http://123.57.173.36/simi-h5/show/order-meeting.html";
//        [self.navigationController pushViewController:webPageVC animated:YES];
//    }
    
    NSDictionary *dataDic=numberArray[indexPath.row];
    NSString *categoryStr=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"category"]];
    NSString *actionStr=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"action"]];
    if ([categoryStr isEqualToString:@"app"]) {
        if ([actionStr isEqualToString:@"card"]) {
            NSString *card_ID=[numberArray[indexPath.row]objectForKey:@"params"];
            NSLog(@"card_id%@",card_ID);
            vc=[[DetailsViewController alloc]init];
            vc.card_ID=[card_ID intValue];
            vc.S=S;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([actionStr isEqualToString:@"feed"]){
            
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
            Dynamic_DetailsViewController *dyVC=[[Dynamic_DetailsViewController alloc]init];
            dyVC.dyNamicID=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"params"]];
            [self.navigationController pushViewController:dyVC animated:YES];

        }else if ([actionStr isEqualToString:@"checkin"]){
            BookingViewController *bookVC=[[BookingViewController alloc]init];
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
        }
    }else{
        WebPageViewController *webPageVC=[[WebPageViewController alloc]init];
        webPageVC.webURL=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"goto_url"]];
        [self.navigationController pushViewController:webPageVC animated:YES];
    }
}


@end
