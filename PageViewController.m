//
//  PageViewController.m
//  simi
//
//  Created by 白玉林 on 15/7/29.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "PageViewController.h"
#import "NSDate+Calendar.h"
#import "JBCalendarLogic.h"

#import "JBUnitView.h"
#import "JBUnitGridView.h"
#import "PageTableViewCell.h"
#import "DetailsViewController.h"

#import "JBSXRCUnitTileView.h"

#import "DownloadManager.h"
#import "ISLoginManager.h"
#import "ShareFriendViewController.h"
int B=0;
@interface PageViewController () <JBUnitGridViewDelegate, JBUnitGridViewDataSource, JBUnitViewDelegate, JBUnitViewDataSource>
{
    UILabel *mouthLabel;
    UIButton *buttonR;
    NSArray *numberArray;
    NSString *service_date_str;
    NSDictionary *_dict;
    DownloadManager *_download;
    UIView *viewMR;
    
}



@property (nonatomic, retain) JBUnitView *unitView;
@property (nonatomic, retain) UITableView *tableview;

- (void)selectorForButton;
@property (nonatomic, strong, readwrite) NSString *year;
@property (nonatomic, strong, readwrite) NSString *month;
@property (nonatomic, strong, readwrite) NSString *day;
@property (nonatomic, strong)NSString *string;
@end

@implementation PageViewController

float lastContentOffset;
CGFloat newHeight ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        super.navigationController.tabBarController.tabBar.hidden=YES;

    }
    
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.view addSubview:mouthLabel];
    [self.view addSubview:buttonR];
    [self selectorForButton];

    
    
    
   
}
-(void)viewDidAppear:(BOOL)animated
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *  morelocationString=[dateformatter stringFromDate:senddate];
    NSLog(@"日期数据%@",morelocationString);
    service_date_str=morelocationString;
    _download = [[DownloadManager alloc]init];
    
    _dict = @{@"service_date":service_date_str,@"user_id":_manager.telephone,@"card_from":@"0",@"page":@"1"};
    NSLog(@"字典数据%@",_dict);
     [_download requestWithUrl:CARD_LIST dict:_dict view:self.tableview delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
       [self.view setUserInteractionEnabled:YES];
    self.view.backgroundColor=[UIColor blackColor];
       //  Example 1.1:
    self.unitView = [[JBUnitView alloc] initWithFrame:self.view.bounds UnitType:UnitTypeMonth SelectedDate:[NSDate date] AlignmentRule:JBAlignmentRuleTop Delegate:self DataSource:self];
    [self.view addSubview:self.unitView];
    
   
    
    self.view.backgroundColor=[UIColor blackColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0.0f, 400.0f, 50.0f, 50.0f);
    [button setTitle:@"Today" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectorForButton) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:button];
    
}

-(void)logDowLoadFinish:(id)sender
{
    
    NSLog(@"登录后信息：%@",sender);
    NSString *senderString=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    //if([tmpStr1 isEqualToString:tmpStr2])
    if([senderString isEqualToString:@""])
    {
        [self.tableview removeFromSuperview];
        [viewMR removeFromSuperview];
        viewMR=[[UIView alloc]initWithFrame:CGRectMake(0.0f, self.unitView.frame.size.height+44, self.view.bounds.size.width, self.view.frame.size.height - (self.unitView.bounds.size.height+95))];
        //view.backgroundColor=[UIColor brownColor];
        UILabel *la=[[UILabel alloc]initWithFrame:FRAME(20, 30, WIDTH-40, 20)];
        la.text=@"貌似这天你没事哦~";
        la.textColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
        [viewMR addSubview:la];
        [self.view addSubview:viewMR];
    }else
    {
        [self.tableview removeFromSuperview];
        numberArray=[sender objectForKey:@"data"];
        self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, self.unitView.frame.size.height+44, self.view.bounds.size.width, self.view.frame.size.height - (self.unitView.bounds.size.height+95))];
        //self.tableview.hidden=YES;
        self.tableview.separatorStyle=UITableViewCellSelectionStyleNone;
        self.tableview.delegate=self;
        self.tableview.dataSource=self;
        [self.view addSubview:self.tableview];
        NSLog(@"数组个数%lu",(unsigned long)numberArray.count);
        
    }
    
}
-(void)DownFail:(id)sender
{
    NSLog(@"erroe is %@",sender);
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    lastContentOffset = scrollView.contentOffset.y;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (lastContentOffset <scrollView.contentOffset.y) {
        NSLog(@"向上滚动");
        
    }else{
        NSLog(@"向下滚动");
        
        
    }
    
}


#pragma mark -
#pragma mark - Class Extensions
- (void)selectorForButton
{
    
    [self.unitView selectDate:[NSDate date]];
}

#pragma mark -
#pragma mark - JBUnitGridViewDelegate
/**************************************************************
 *@Description:获取当前UnitGridView中UnitTileView的高度
 *@Params:
 *  unitGridView:当前unitGridView
 *@Return:当前unitGridView中UnitTileView的高度
 **************************************************************/
- (CGFloat)heightOfUnitTileViewsInUnitGridView:(JBUnitGridView *)unitGridView
{
    
    return 46.0f;
}


/**************************************************************
 *@Description:获取当前UnitGridView中UnitTileView的宽度
 *@Params:
 *  unitGridView:当前unitGridView
 *@Return:当前UnitGridView中UnitTileView的宽度
 **************************************************************/
- (CGFloat)widthOfUnitTileViewsInUnitGridView:(JBUnitGridView *)unitGridView
{
    
    return 46.0f;
}


//  ------------选中了当前月份或周之外的时间--------------
/**************************************************************
 *@Description:选中了当前Unit的上一个Unit中的时间点
 *@Params:
 *  unitGridView:当前unitGridView
 *  date:选中的时间点
 *@Return:nil
 **************************************************************/
- (void)unitGridView:(JBUnitGridView *)unitGridView selectedOnPreviousUnitWithDate:(JBCalendarDate *)date
{
    
}

/**************************************************************
 *@Description:选中了当前Unit的下一个Unit中的时间点
 *@Params:
 *  unitGridView:当前unitGridView
 *  date:选中的时间点
 *@Return:nil
 **************************************************************/
- (void)unitGridView:(JBUnitGridView *)unitGridView selectedOnNextUnitWithDate:(JBCalendarDate *)date
{
    
}

#pragma mark -
#pragma mark - JBUnitGridViewDataSource
/**************************************************************
 *@Description:获得unitTileView
 *@Params:
 *  unitGridView:当前unitGridView
 *@Return:unitTileView
 **************************************************************/
- (JBUnitTileView *)unitTileViewInUnitGridView:(JBUnitGridView *)unitGridView
{
    
    return [[JBSXRCUnitTileView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 46.0f, 46.0f)];
}

/**************************************************************
 *@Description:设置unitGridView中的weekdaysBarView
 *@Params:
 *  unitGridView:当前unitGridView
 *@Return:weekdaysBarView
 **************************************************************/
- (UIView *)weekdaysBarViewInUnitGridView:(JBUnitGridView *)unitGridView
{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weekdaysBarView"]];
    return imageView;
}


/**************************************************************
 *@Description:获取calendarDate对应的时间范围内的事件的数量
 *@Params:
 *  unitGridView:当前unitGridView
 *  calendarDate:时间范围
 *  completedBlock:回调代码块
 *@Return:nil
 **************************************************************/
- (void)unitGridView:(JBUnitGridView *)unitGridView NumberOfEventsInCalendarDate:(JBCalendarDate *)calendarDate WithCompletedBlock:(void (^)(NSInteger eventCount))completedBlock
{
    
    completedBlock(calendarDate.day);
}

/**************************************************************
 *@Description:获取calendarDate对应的时间范围内的事件
 *@Params:
 *  unitGridView:当前unitGridView
 *  calendarDate:时间范围
 *  completedBlock:回调代码块
 *@Return:nil
 **************************************************************/
- (void)unitGridView:(JBUnitGridView *)unitGridView EventsInCalendarDate:(JBCalendarDate *)calendarDate WithCompletedBlock:(void (^)(NSArray *events))completedBlock
{
    NSLog(@"////NSArray%@",completedBlock);
    
    completedBlock(nil);
}


#pragma mark -
#pragma mark - JBUnitViewDelegate
/**************************************************************
 *@Description:获取当前UnitView中UnitTileView的高度
 *@Params:
 *  unitView:当前unitView
 *@Return:当前UnitView中UnitTileView的高度
 **************************************************************/
- (CGFloat)heightOfUnitTileViewsInUnitView:(JBUnitView *)unitView
{
    
    return 46.0f;
}

/**************************************************************
 *@Description:获取当前UnitView中UnitTileView的宽度
 *@Params:
 *  unitView:当前unitView
 *@Return:当前UnitView中UnitTileView的宽度
 **************************************************************/
- (CGFloat)widthOfUnitTileViewsInUnitView:(JBUnitView *)unitView
{
    
    return 46.0f;
}
/**************************************************************
 *@Description:更新unitView的frame
 *@Params:
 *  unitView:当前unitView
 *  newFrame:新的frame
 *@Return:nil
 **************************************************************/
- (void)unitView:(JBUnitView *)unitView UpdatingFrameTo:(CGRect)newFrame
{
    
    self.tableview.frame = CGRectMake(0.0f, newFrame.size.height+44, self.view.bounds.size.width, self.view.frame.size.height - (newFrame.size.height+95));
}

/**************************************************************
 *@Description:重新设置unitView的frame
 *@Params:
 *  unitView:当前unitView
 *  newFrame:新的frame
 *@Return:nil
 **************************************************************/
- (void)unitView:(JBUnitView *)unitView UpdatedFrameTo:(CGRect)newFrame
{
    
    //NSLog(@"OK");
}

#pragma mark -
#pragma mark - JBUnitViewDataSource
/**************************************************************
 *@Description:获得unitTileView
 *@Params:
 *  unitView:当前unitView
 *@Return:unitTileView
 **************************************************************/
- (JBUnitTileView *)unitTileViewInUnitView:(JBUnitView *)unitView
{

    return [[JBSXRCUnitTileView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 46.0f, 46.0f)];
}

/**************************************************************
 *@Description:设置unitView中的weekdayView
 *@Params:
 *  unitView:当前unitView
 *@Return:weekdayView
 **************************************************************/
- (UIView *)weekdaysBarViewInUnitView:(JBUnitView *)unitView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    //imageView.backgroundColor=[UIColor redColor];
    imageView.frame =CGRectMake(0, 0, self.view.frame.size.width, 44);
    

    NSArray *weekArray=@[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    for (int i=0; i<weekArray.count; i++) {
        UIButton *weekButton=[[UIButton alloc]init];
        weekButton.frame=CGRectMake((self.view.frame.size.width-210)/8+7+(30+(self.view.frame.size.width-210)/8)*i, imageView.frame.size.height-15, 30, 10);
        //weekButton.backgroundColor=[UIColor redColor];
        UILabel *butLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 10)];
        butLabel.text=weekArray[i];
        butLabel.font=[UIFont fontWithName:@"Arial" size:10];
        [weekButton addSubview:butLabel];
        [weekButton setTitle:weekArray[i] forState:UIControlStateNormal];
        [weekButton setTintColor:[UIColor blackColor]];
        [imageView addSubview:weekButton];
    }
    
    return imageView;
}

/**************************************************************
 *@Description:选择某一天
 *@Params:
 *  unitView:当前unitView
 *  date:选择的日期
 *@Return:nil
 **************************************************************/
- (void)unitView:(JBUnitView *)unitView SelectedDate:(NSDate *)date
{
    
    [mouthLabel removeFromSuperview];
//    self.year=[date year];
//    self.month=[date month];
//    self.day=[date day];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:date];
    NSLog( @"时间信息%@",locationString);
//    NSString *string=[NSString stringWithFormat:@"%@",date];
//    NSString *interceptString=[string substringWithRange:NSMakeRange(0,10)];
//    NSLog(@"%@",interceptString);
    
    //NSString *interceptString=[NSString stringWithFormat:@"%ld-%ld-%ld",(long)self.year,(long)self.month,(long)self.day];
    //NSLog(@"点击时的日期%@",interceptString);
    self.string=locationString;
    mouthLabel=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 25, 100, 15)];
    mouthLabel.font=[UIFont fontWithName:@"Arial" size:15];
    // mouthLabel.backgroundColor=[UIColor redColor];
    mouthLabel.text=self.string;
    mouthLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:mouthLabel];
    
    [buttonR removeFromSuperview];
    buttonR=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH-50, 30, 30, 20)];
    [buttonR addTarget:self action:@selector(buttonRed) forControlEvents:UIControlEventTouchUpInside];
    [buttonR setImage:[UIImage imageNamed:@"iconfont-chakan"] forState:UIControlStateNormal];
    [self.view addSubview:buttonR];
    
    NSLog(@"selected date:%@", locationString);
    service_date_str=locationString;
    ISLoginManager *_manager = [ISLoginManager shareManager];
    _dict = @{@"service_date":service_date_str,@"user_id":_manager.telephone,@"card_from":@"0",@"page":@"1"};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CARD_LIST dict:_dict view:self.tableview delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
    
}
-(void)buttonRed
{
    NSLog(@"你好啊！%d",B);
    if (B%2==0) {
        [buttonR setImage:[UIImage imageNamed:@"iconfont-chakan (1)"] forState:UIControlStateNormal];
    }else{
        [buttonR setImage:[UIImage imageNamed:@"iconfont-chakan"] forState:UIControlStateNormal];

    }
    B++;
}
/**************************************************************
 *@Description:获取calendarDate对应的时间范围内的事件的数量
 *@Params:
 *  unitView:当前unitView
 *  calendarDate:时间范围
 *  completedBlock:回调代码块
 *@Return:nil
 **************************************************************/
- (void)unitView:(JBUnitView *)unitView NumberOfEventsInCalendarDate:(JBCalendarDate *)calendarDate WithCompletedBlock:(void (^)(NSInteger eventCount))completedBlock
{
    
    completedBlock(calendarDate.day);
    //NSLog(@"/////////%ld",(long)(calendarDate.day));
}

/**************************************************************
 *@Description:获取calendarDate对应的时间范围内的事件
 *@Params:
 *  unitView:当前unitView
 *  calendarDate:时间范围
 *  completedBlock:回调代码块
 *@Return:nil
 **************************************************************/
- (void)unitView:(JBUnitView *)unitView EventsInCalendarDate:(JBCalendarDate *)calendarDate WithCompletedBlock:(void (^)(NSArray *events))completedBlock
{
    
    completedBlock(nil);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    
    return numberArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=numberArray[indexPath.row];
    static NSString *identifier = @"cell";
    
    PageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
//        [cell setImageVIew:[UIImage imageNamed:@"SYCELL_HEAD_CY_@2x"] setLabel:@"18:00和刘总晚餐" label:@"刚刚" promptLabel:@"麻辣诱惑"];
        NSString *clString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        int clID=[clString intValue];
        if (clID==1) {
            cell.promptlabel.text=@"处理中";
        }else if (clID==2){
            cell.promptlabel.text=@"秘书处理中";
        }else if(clID==3){
            cell.promptlabel.text=@"以完成";
        }else if (clID==0){
            cell.promptlabel.text=@"以取消";
        }
        
        //cell.promptlabel.backgroundColor=[UIColor blueColor];
        [cell.promptlabel setNumberOfLines:1];
        [cell.promptlabel sizeToFit];
        cell.promptlabel.frame=CGRectMake(WIDTH-cell.promptlabel.frame.size.width-15 ,14,cell.promptlabel.frame.size.width,55-26);
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(cell.promptlabel.frame.size.width, 0, 10, cell.promptlabel.frame.size.height)];
        image.image=[UIImage imageNamed:@"SYCELL_YHB_@2x"];
        
        [cell.promptlabel addSubview:image];
        UIImageView *image2=[[UIImageView alloc]initWithFrame:CGRectMake(-20, 0, cell.promptlabel.frame.size.width+20, cell.promptlabel.frame.size.height)];
        image2.image=[UIImage imageNamed:@"SYCELL_YHBY_@2x"];
        
        [cell.promptlabel addSubview:image2];
        
    }
    
    int card_type_Id=[[dic objectForKey:@"card_type"]intValue];
    NSArray *headImageArray=@[@"HYXQ_HEAD",@"MSJZ_HEAD",@"SWTX_HEAD",@"YYTZ_HEAD",@"CLGH_HEAD"];
    NSArray *headArray=@[@"HY",@"ZJ",@"SW",@"YYTZ",@"CL"];
    cell.heideImage.image=[UIImage imageNamed:@"SYCELL_HEAD_CY_@2x"];
    
    cell.titleLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"card_type_name"]];
    [cell.titleLabel setNumberOfLines:1];
    [cell.titleLabel sizeToFit];
    
//    double timeS=[[dic objectForKey:@"add_time_str"] doubleValue];
//    NSDateFormatter* formatter =[[NSDateFormatter alloc] init];
//    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"HH:mm"];
//    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeS];
//    NSString* dateString = [formatter stringFromDate:date];
    
    cell.timeLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"add_time_str"]];
    [cell.timeLabel setNumberOfLines:1];
    [cell.timeLabel sizeToFit];
    
    if (card_type_Id==1) {
        cell.heideImage.image=[UIImage imageNamed:headArray[card_type_Id-1]];
        cell.descriptionView.image=[UIImage imageNamed:headImageArray[card_type_Id-1]];
        cell.sjLabel.text=@"时间:";
        [cell.sjLabel setNumberOfLines:1];
        [cell.sjLabel sizeToFit];
        cell.sjLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.sjLabel.frame=CGRectMake(129, 13, cell.sjLabel.frame.size.width, 14);
        
        cell.moneyLabel.text=@"会议地点:";
        [cell.moneyLabel setNumberOfLines:1];
        [cell.moneyLabel sizeToFit];
        cell.moneyLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.moneyLabel.frame=CGRectMake(129, 36, cell.moneyLabel.frame.size.width, 14);
        
        cell.address.hidden=NO;
        cell.address.text=@"提醒人:";
        [cell.address setNumberOfLines:1];
        [cell.address sizeToFit];
        cell.address.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.address.frame=CGRectMake(129, 59, cell.address.frame.size.width, 14);
        
        double inTime=[[dic objectForKey:@"service_time"] doubleValue];
        NSDateFormatter* inTimeformatter =[[NSDateFormatter alloc] init];
        inTimeformatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
        [inTimeformatter setDateStyle:NSDateFormatterMediumStyle];
        [inTimeformatter setTimeStyle:NSDateFormatterShortStyle];
        [inTimeformatter setDateFormat:@"YYYY年MM月dd日 HH:mm:ss"];
        NSDate* inTimedate = [NSDate dateWithTimeIntervalSince1970:inTime];
        NSString* inTimeString = [inTimeformatter stringFromDate:inTimedate];
        
        cell.inTimeLabel.text=[NSString stringWithFormat:@"%@",inTimeString];
        cell.inTimeLabel.frame=CGRectMake(cell.sjLabel.frame.size.width+cell.sjLabel.frame.origin.x, 13, WIDTH-148-cell.sjLabel.frame.size.width, 14);
        
        cell.costLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_addr"]];
        cell.costLabel.frame=CGRectMake(cell.moneyLabel.frame.size.width+cell.moneyLabel.frame.origin.x, 36, WIDTH-148-cell.moneyLabel.frame.size.width, 14);
        NSArray *nameArray=[dic objectForKey:@"attends"];
        NSMutableArray *nameArr=[[NSMutableArray alloc]init];
        for (int i=0; i<nameArray.count; i++) {
            NSString *nameString=[NSString stringWithFormat:@"%@",[nameArray[i] objectForKey:@"name"]];
            [nameArr addObject:nameString];
        }
        NSString *personnel=[nameArr componentsJoinedByString:@","];
        cell.addressLabel.hidden=NO;
        cell.addressLabel.text=[NSString stringWithFormat:@"%@",personnel];
        cell.addressLabel.frame=CGRectMake(cell.address.frame.size.width+cell.address.frame.origin.x, 59, WIDTH-148-cell.address.frame.size.width, 14);
        
    }else if (card_type_Id==2){
        cell.heideImage.image=[UIImage imageNamed:headArray[card_type_Id-1]];
        cell.descriptionView.image=[UIImage imageNamed:headImageArray[card_type_Id-1]];
        cell.sjLabel.text=@"时间:";
        [cell.sjLabel setNumberOfLines:1];
        [cell.sjLabel sizeToFit];
        cell.sjLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.sjLabel.frame=CGRectMake(129, 13, cell.sjLabel.frame.size.width, 14);
        
        cell.moneyLabel.text=@"提醒人:";
        [cell.moneyLabel setNumberOfLines:1];
        [cell.moneyLabel sizeToFit];
        cell.moneyLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.moneyLabel.frame=CGRectMake(129, 36, cell.moneyLabel.frame.size.width, 14);
        
        cell.address.hidden=YES;
        cell.address.text=@"提醒人:";
        [cell.address setNumberOfLines:1];
        [cell.address sizeToFit];
        cell.address.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.address.frame=CGRectMake(129, 59, cell.address.frame.size.width, 14);
        
        double inTime=[[dic objectForKey:@"service_time"] doubleValue];
        NSDateFormatter* inTimeformatter =[[NSDateFormatter alloc] init];
        inTimeformatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
        [inTimeformatter setDateStyle:NSDateFormatterMediumStyle];
        [inTimeformatter setTimeStyle:NSDateFormatterShortStyle];
        [inTimeformatter setDateFormat:@"YYYY年MM月dd日 HH:mm:ss"];
        NSDate* inTimedate = [NSDate dateWithTimeIntervalSince1970:inTime];
        NSString* inTimeString = [inTimeformatter stringFromDate:inTimedate];
        
        cell.inTimeLabel.text=[NSString stringWithFormat:@"%@",inTimeString];
        cell.inTimeLabel.frame=CGRectMake(cell.sjLabel.frame.size.width+cell.sjLabel.frame.origin.x, 13, WIDTH-148-cell.sjLabel.frame.size.width, 14);
        
        NSArray *nameArray=[dic objectForKey:@"attends"];
        NSMutableArray *nameArr=[[NSMutableArray alloc]init];
        for (int i=0; i<nameArray.count; i++) {
            NSString *nameString=[NSString stringWithFormat:@"%@",[nameArray[i] objectForKey:@"name"]];
            [nameArr addObject:nameString];
        }
        NSString *personnel=[nameArr componentsJoinedByString:@","];
        cell.costLabel.text=[NSString stringWithFormat:@"%@",personnel];
        cell.costLabel.frame=CGRectMake(cell.moneyLabel.frame.size.width+cell.moneyLabel.frame.origin.x, 36, WIDTH-148-cell.moneyLabel.frame.size.width, 14);
        cell.addressLabel.hidden=YES;
        
    }else if (card_type_Id==3){
        cell.heideImage.image=[UIImage imageNamed:headArray[card_type_Id-1]];
        cell.descriptionView.image=[UIImage imageNamed:headImageArray[card_type_Id-1]];
        cell.sjLabel.text=@"时间:";
        [cell.sjLabel setNumberOfLines:1];
        [cell.sjLabel sizeToFit];
        cell.sjLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.sjLabel.frame=CGRectMake(129, 13, cell.sjLabel.frame.size.width, 14);
        
        cell.moneyLabel.text=@"提醒人:";
        [cell.moneyLabel setNumberOfLines:1];
        [cell.moneyLabel sizeToFit];
        cell.moneyLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.moneyLabel.frame=CGRectMake(129, 36, cell.moneyLabel.frame.size.width, 14);
        
        cell.address.hidden=YES;
        cell.address.text=@"提醒人:";
        [cell.address setNumberOfLines:1];
        [cell.address sizeToFit];
        cell.address.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.address.frame=CGRectMake(129, 59, cell.address.frame.size.width, 14);
        
        double inTime=[[dic objectForKey:@"service_time"] doubleValue];
        NSDateFormatter* inTimeformatter =[[NSDateFormatter alloc] init];
        inTimeformatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
        [inTimeformatter setDateStyle:NSDateFormatterMediumStyle];
        [inTimeformatter setTimeStyle:NSDateFormatterShortStyle];
        [inTimeformatter setDateFormat:@"YYYY年MM月dd日 HH:mm:ss"];
        NSDate* inTimedate = [NSDate dateWithTimeIntervalSince1970:inTime];
        NSString* inTimeString = [inTimeformatter stringFromDate:inTimedate];
        
        cell.inTimeLabel.text=[NSString stringWithFormat:@"%@",inTimeString];
        cell.inTimeLabel.frame=CGRectMake(cell.sjLabel.frame.size.width+cell.sjLabel.frame.origin.x, 13, WIDTH-148-cell.sjLabel.frame.size.width, 14);
        
        NSArray *nameArray=[dic objectForKey:@"attends"];
        NSMutableArray *nameArr=[[NSMutableArray alloc]init];
        for (int i=0; i<nameArray.count; i++) {
            NSString *nameString=[NSString stringWithFormat:@"%@",[nameArray[i] objectForKey:@"name"]];
            [nameArr addObject:nameString];
        }
        NSString *personnel=[nameArr componentsJoinedByString:@","];
        cell.costLabel.text=[NSString stringWithFormat:@"%@",personnel];
        cell.costLabel.frame=CGRectMake(cell.moneyLabel.frame.size.width+cell.moneyLabel.frame.origin.x, 36, WIDTH-148-cell.moneyLabel.frame.size.width, 14);
        
        cell.addressLabel.hidden=YES;
    }else if (card_type_Id==4){
        cell.heideImage.image=[UIImage imageNamed:headArray[card_type_Id-1]];
        cell.descriptionView.image=[UIImage imageNamed:headImageArray[card_type_Id-1]];
        cell.sjLabel.text=@"时间:";
        [cell.sjLabel setNumberOfLines:1];
        [cell.sjLabel sizeToFit];
        cell.sjLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.sjLabel.frame=CGRectMake(129, 13, cell.sjLabel.frame.size.width, 14);
        
        cell.moneyLabel.text=@"邀约人:";
        [cell.moneyLabel setNumberOfLines:1];
        [cell.moneyLabel sizeToFit];
        cell.moneyLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.moneyLabel.frame=CGRectMake(129, 36, cell.moneyLabel.frame.size.width, 14);
        
        cell.address.hidden=YES;
        cell.address.text=@"提醒人:";
        [cell.address setNumberOfLines:1];
        [cell.address sizeToFit];
        cell.address.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.address.frame=CGRectMake(129, 59, cell.address.frame.size.width, 14);
        
        double inTime=[[dic objectForKey:@"service_time"] doubleValue];
        NSDateFormatter* inTimeformatter =[[NSDateFormatter alloc] init];
        inTimeformatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
        [inTimeformatter setDateStyle:NSDateFormatterMediumStyle];
        [inTimeformatter setTimeStyle:NSDateFormatterShortStyle];
        [inTimeformatter setDateFormat:@"YYYY年MM月dd日 HH:mm:ss"];
        NSDate* inTimedate = [NSDate dateWithTimeIntervalSince1970:inTime];
        NSString* inTimeString = [inTimeformatter stringFromDate:inTimedate];
        
        cell.inTimeLabel.text=[NSString stringWithFormat:@"%@",inTimeString];
        cell.inTimeLabel.frame=CGRectMake(cell.sjLabel.frame.size.width+cell.sjLabel.frame.origin.x, 13, WIDTH-148-cell.sjLabel.frame.size.width, 14);
        
        NSArray *nameArray=[dic objectForKey:@"attends"];
        NSMutableArray *nameArr=[[NSMutableArray alloc]init];
        for (int i=0; i<nameArray.count; i++) {
            NSString *nameString=[NSString stringWithFormat:@"%@",[nameArray[i] objectForKey:@"name"]];
            [nameArr addObject:nameString];
        }
        NSString *personnel=[nameArr componentsJoinedByString:@","];
        cell.costLabel.text=[NSString stringWithFormat:@"%@",personnel];
        cell.costLabel.frame=CGRectMake(cell.moneyLabel.frame.size.width+cell.moneyLabel.frame.origin.x, 36, WIDTH-148-cell.moneyLabel.frame.size.width, 14);
        
        cell.addressLabel.hidden=YES;
    }else if (card_type_Id==5){
        cell.heideImage.image=[UIImage imageNamed:headArray[card_type_Id-1]];
        cell.descriptionView.image=[UIImage imageNamed:headImageArray[card_type_Id-1]];
        cell.sjLabel.text=@"城市:";
        [cell.sjLabel setNumberOfLines:1];
        [cell.sjLabel sizeToFit];
        cell.sjLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.sjLabel.frame=CGRectMake(129, 13, cell.sjLabel.frame.size.width, 14);
        
        cell.moneyLabel.text=@"时间:";
        [cell.moneyLabel setNumberOfLines:1];
        [cell.moneyLabel sizeToFit];
        cell.moneyLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.moneyLabel.frame=CGRectMake(129, 36, cell.moneyLabel.frame.size.width, 14);
        
        cell.address.text=@"航班:";
        [cell.address setNumberOfLines:1];
        [cell.address sizeToFit];
        cell.address.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.address.frame=CGRectMake(129, 59, cell.address.frame.size.width, 14);
        
        double inTime=[[dic objectForKey:@"service_time"] doubleValue];
        NSDateFormatter* inTimeformatter =[[NSDateFormatter alloc] init];
        inTimeformatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
        [inTimeformatter setDateStyle:NSDateFormatterMediumStyle];
        [inTimeformatter setTimeStyle:NSDateFormatterShortStyle];
        [inTimeformatter setDateFormat:@"YYYY年MM月dd日 HH:mm:ss"];
        NSDate* inTimedate = [NSDate dateWithTimeIntervalSince1970:inTime];
        NSString* inTimeString = [inTimeformatter stringFromDate:inTimedate];
        
        NSString *fromCityName=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ticket_from_city_name"]];
        NSLog(@"出发%@",fromCityName);
        NSString *toCityName=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ticket_to_city_name"]];
        NSString *cityName=[NSString stringWithFormat:@"从 %@ 到 %@",fromCityName,toCityName];
        cell.inTimeLabel.text=[NSString stringWithFormat:@"%@",cityName];
        cell.inTimeLabel.frame=CGRectMake(cell.sjLabel.frame.size.width+cell.sjLabel.frame.origin.x, 13, WIDTH-148-cell.sjLabel.frame.size.width, 14);
        
        cell.costLabel.text=[NSString stringWithFormat:@"%@",inTimeString];
        NSLog(@"%@",inTimeString);
        cell.costLabel.frame=CGRectMake(cell.moneyLabel.frame.size.width+cell.moneyLabel.frame.origin.x, 36, WIDTH-148-cell.moneyLabel.frame.size.width, 14);
        cell.addressLabel.text=[NSString stringWithFormat:@"航班"];
        cell.addressLabel.frame=CGRectMake(cell.address.frame.size.width+cell.address.frame.origin.x, 59, WIDTH-148-cell.address.frame.size.width, 14);
    }

    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_content"]];
    
    
    cell.praiseLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"total_zan"]];
    cell.commentLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"total_comment"]];
    
    cell.zaButton.hidden=YES;
    cell.plButton.hidden=YES;
    cell.fxButton.hidden=YES;
    NSArray *array=@[@"common_icon_like_c@2x",@"common_icon_review@2x",@"common_icon_share@2x"];
    UIButton *zaButton=[[UIButton alloc]initWithFrame:CGRectMake(42, cell.view.frame.size.height-36, 22, 22)];
    [zaButton setImage:[UIImage imageNamed:array[0]] forState:UIControlStateNormal];
    [zaButton setTag:indexPath.row];
    [zaButton addTarget:self action:@selector(zaButtonan:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:zaButton];
    UIButton *plButton=[[UIButton alloc]initWithFrame:CGRectMake(42+WIDTH/3*1, cell.view.frame.size.height-36, 22, 22)];
    [plButton setImage:[UIImage imageNamed:array[1]] forState:UIControlStateNormal];
    [plButton setTag:indexPath.row];
    [plButton addTarget:self action:@selector(plButtonan:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:plButton];
    UIButton *fxButton=[[UIButton alloc]initWithFrame:CGRectMake(42+WIDTH/3*2, cell.view.frame.size.height-36, 22, 22)];
    [fxButton setImage:[UIImage imageNamed:array[2]] forState:UIControlStateNormal];
    [fxButton setTag:indexPath.row];
    [fxButton addTarget:self action:@selector(fxButtonan:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:fxButton];
    

//    [cell.plButton addTarget:self action:@selector(buttonan:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.fxButton addTarget:self action:@selector(buttonan:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PageTableViewCell *cell =[[PageTableViewCell alloc]init];
    return cell.view.frame.size.height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *card_ID=[numberArray[indexPath.row]objectForKey:@"card_id"];
    NSLog(@"card_id%@",card_ID);
    DetailsViewController *vc=[[DetailsViewController alloc]init];
    //vc.pathId=(int)indexPath.row;
    vc.card_ID=[card_ID intValue];
    [self.navigationController pushViewController:vc animated:YES];
    [self.tableview deselectRowAtIndexPath:indexPath animated:NO];
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
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *  morelocationString=[dateformatter stringFromDate:senddate];
    service_date_str=morelocationString;
    _download = [[DownloadManager alloc]init];
    
    _dict = @{@"service_date":service_date_str,@"user_id":_manager.telephone,@"card_from":@"0",@"page":@"1"};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CARD_LIST dict:_dict view:self.tableview delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
    
}
-(void)DZDownFail:(id)sender
{
    NSLog(@"点赞失败");
}

-(void)plButtonan:(UIButton *)sender
{
    NSString *card_ID=[numberArray[sender.tag]objectForKey:@"card_id"];
    NSLog(@"card_id%@",card_ID);
    DetailsViewController *vc=[[DetailsViewController alloc]init];
    //vc.pathId=(int)indexPath.row;
    vc.card_ID=[card_ID intValue];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)fxButtonan:(UIButton *)sender
{
//    NSString *card_ID=[numberArray[sender.tag]objectForKey:@"card_id"];
//    NSLog(@"card_id%@",card_ID);
//    DetailsViewController *vc=[[DetailsViewController alloc]init];
//    //vc.pathId=(int)indexPath.row;
//    vc.card_ID=[card_ID intValue];
//    [self.navigationController pushViewController:vc animated:YES];
    ShareFriendViewController *_controller = [[ShareFriendViewController alloc]init];
    [self.navigationController pushViewController:_controller animated:YES];


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
