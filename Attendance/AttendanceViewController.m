//
//  AttendanceViewController.m
//  yxz
//
//  Created by 白玉林 on 16/1/13.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "AttendanceViewController.h"
#import "AttendUserDressMapViewController.h"
#import "AttendCompViewController.h"
@interface AttendanceViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIActivityIndicatorView *view;
    AttendUserDressMapViewController *usedVC;
    AttendCompViewController *compVC;
    NSString *nameString;
    NSString *compID;
    UILabel *promptLabel;
    NSString *weekString;
    UILabel *nameLabel;
    UILabel *weekLabel;
    UITableView *myTableView;
    NSArray *dataSourceArray;
    
    UIView *layoutView;
    UIWebView *myWebView;
    UILabel *webTitleLabel;
    NSString *urlString;
    UIActivityIndicatorView *webActivityView;
}
@end

@implementation AttendanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navlabel.text=@"签到";
    self.backlable.backgroundColor=HEX_TO_UICOLOR(0xea8010, 1.0);
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
    CGRect tmpRect = [self.navlabel.text boundingRectWithSize:CGSizeMake(WIDTH, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil] context:nil];
    self.helpBut.hidden=NO;
    self.helpBut.frame=FRAME((WIDTH-tmpRect.size.width)/2, 20, tmpRect.size.width+20, 44);
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:FRAME(self.helpBut.frame.size.width-20, 12, 20, 20)];
    image.image=[UIImage imageNamed:@"iconfont_yingyongbangzhu"];
    [self.helpBut addSubview:image];

    _navlabel.textColor = [UIColor whiteColor];
    self.img.hidden=YES;
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 20, 20)];
    img.image = [UIImage imageNamed:@"iconfont-p-back"];
    [_backBtn addSubview:img];
    self.view.backgroundColor=[UIColor whiteColor];
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期六",@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五", nil];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit |NSWeekdayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    int week = (int)[comps weekday]%7;
    weekString=[NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:week]];
    if (_webID==0) {
        [self webViewLayout];
    }else if (_webID==1){
        [self viewLayout];
        [self tableViewLayout];
    }
}
-(void)tableViewLayout
{
    myTableView=[[UITableView alloc]initWithFrame:FRAME(0, 164, WIDTH, HEIGHT-164-WIDTH/4)];
    myTableView.dataSource=self;
    myTableView.delegate=self;
    [self.view addSubview:myTableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [myTableView setTableFooterView:v];
}
-(void)defaultInterfaceLayout
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    
    NSDictionary *_dict = @{@"user_id":_manager.telephone};
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",ATTEND_DEFAULT] dict:_dict view:self.view delegate:self finishedSEL:@selector(addDressSuccess:) isPost:YES failedSEL:@selector(addDressFail:)];

}
#pragma mark默认班次数据成功方法
-(void)addDressSuccess:(id)source
{
    NSLog(@"默认班次数据:%@",source);
    NSString *string=[NSString stringWithFormat:@"%@",[source objectForKey:@"data"]];
    if (string==nil||string==NULL||[string isEqualToString:@""]) {
        
    }else{
        NSDictionary *dic=[source objectForKey:@"data"];
        dataSourceArray=[dic objectForKey:@"list"];
        nameString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"companyName"]];
        compID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"companyId"]];
        [self nameLabelLayout];
        [myTableView reloadData];
    }
    
}
#pragma mark默认班次数据失败方法
-(void)addDressFail:(id)source
{
    NSLog(@"默认班次数据失败:%@",source);
}
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self defaultInterfaceLayout];
}
-(void)webViewLayout
{
    UIWebView *meWebView= [[UIWebView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    meWebView.delegate=self;
    meWebView.scrollView.delegate=self;
    [self.view addSubview:meWebView];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://123.57.173.36/simi-h5/show/company-reg.html"]];//http://123.57.173.36/simi-h5/show/company-reg.html
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [meWebView loadRequest:request];

}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    view=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    view.center = CGPointMake(WIDTH/2, HEIGHT/2);
    [self.view addSubview:view];
    [view startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [view stopAnimating]; // 结束旋转
    [view setHidesWhenStopped:YES]; //当旋转结束时隐藏
    
    [webActivityView stopAnimating]; // 结束旋转
    [webActivityView setHidesWhenStopped:YES]; //当旋转结束时隐藏
    webTitleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

-(void)viewLayout
{
    UIView *attendanceView=[[UIView alloc]initWithFrame:FRAME(0, 64, WIDTH, 100)];
    attendanceView.backgroundColor=self.backlable.backgroundColor;
    [self.view addSubview:attendanceView];
    nameLabel=[[UILabel alloc]init];//WithFrame:FRAME(20, 20, <#w#>, <#h#>)
    [self nameLabelLayout];
    [attendanceView addSubview:nameLabel];
    
    weekLabel=[[UILabel alloc]init];
    [self weekLaelLayout];
    [attendanceView addSubview:weekLabel];
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    
    UILabel *timeLabel=[[UILabel alloc]init];
    timeLabel.text=[dateformatter stringFromDate:senddate];
    timeLabel.textAlignment=NSTextAlignmentLeft;
    timeLabel.font=[UIFont fontWithName:@"Arial" size:18];
    [timeLabel setNumberOfLines:1];
    [timeLabel sizeToFit];
    timeLabel.frame=FRAME(20, 75, timeLabel.frame.size.width, 22);
    timeLabel.textColor=[UIColor whiteColor];
    [attendanceView addSubview:timeLabel];
    
    UIButton *signButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-100, 33, 90, 35)];
    signButton.backgroundColor=[UIColor whiteColor];
    signButton.layer.cornerRadius=5;
    [signButton setTitle:@"签到记录" forState:UIControlStateNormal];
    signButton.titleLabel.font=[UIFont fontWithName:@"Arial" size:18];
    [signButton addTarget:self action:@selector(signBut) forControlEvents:UIControlEventTouchUpInside];
    [signButton setTitleColor:self.backlable.backgroundColor forState:UIControlStateNormal];
    [attendanceView addSubview:signButton];
    
    UIButton *attendanceBut=[[UIButton alloc]initWithFrame:FRAME((WIDTH-WIDTH/4)/2, HEIGHT-WIDTH/4, WIDTH/4, WIDTH/4)];
    [attendanceBut setImage:[UIImage imageNamed:@"iconfont-icon"] forState:UIControlStateNormal];
    [attendanceBut addTarget:self action:@selector(attendBut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:attendanceBut];
    
    UIButton *companyBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH-70, 26, 60, 30)];
    [companyBut setTitle:@"公司" forState:UIControlStateNormal];
    [companyBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [companyBut addTarget:self action:@selector(companyBut) forControlEvents:UIControlEventTouchUpInside];
    companyBut.layer.cornerRadius=5;
    companyBut.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
}
-(void)signBut
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    urlString=[NSString stringWithFormat:@"http://123.57.173.36/simi-h5/show/checkin-index.html?user_id=%@",_manager.telephone];
    [self webLayout];
}
-(void)nameLabelLayout
{
    nameLabel.text=nameString;
    nameLabel.textAlignment=NSTextAlignmentLeft;
    nameLabel.font=[UIFont fontWithName:@"Arial" size:18];
    [nameLabel setNumberOfLines:1];
    [nameLabel sizeToFit];
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.frame=FRAME(20, 10, nameLabel.frame.size.width, 22);

}
-(void)weekLaelLayout
{
    weekLabel.text=weekString;
    weekLabel.textAlignment=NSTextAlignmentLeft;
    weekLabel.font=[UIFont fontWithName:@"Arial" size:35];
    [weekLabel setNumberOfLines:1];
    [weekLabel sizeToFit];
    weekLabel.textColor=[UIColor whiteColor];
    weekLabel.frame=FRAME(20, 35, weekLabel.frame.size.width, 38);

}
-(void)attendBut
{
    if (compID==nil||compID==NULL||nameString==nil||nameString==NULL) {
        
        
        [promptLabel removeFromSuperview];
        promptLabel =[[UILabel alloc]initWithFrame:FRAME(0, HEIGHT-WIDTH/4-30, WIDTH, 30)];
        promptLabel.text=@"请选择所要签到的公司！！";
        promptLabel.font=[UIFont fontWithName:@"Arial" size:18];
        promptLabel.alpha=0.7;
        promptLabel.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
        promptLabel.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:promptLabel];
        [NSTimer scheduledTimerWithTimeInterval:2.0f
                                         target:self
                                       selector:@selector(timerFireMethod)
                                       userInfo:promptLabel
                                        repeats:NO];
    }else{
        usedVC=[[AttendUserDressMapViewController alloc]init];
        usedVC.company_id=compID;
        [self.navigationController pushViewController:usedVC animated:YES];
    }
    
}
-(void)timerFireMethod
{
    promptLabel.hidden=YES;
}
-(void)companyBut
{
    compVC=[[AttendCompViewController alloc]init];
    [self.navigationController pushViewController:compVC animated:YES];
}
- (void)backAction
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSLog(@"有值么%@",_manager.telephone);
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict=@{@"user_id":_manager.telephone};
    [_download requestWithUrl:USER_INFO dict:_dict view:self.view delegate:self finishedSEL:@selector(QJDowLoadFinish:) isPost:NO failedSEL:@selector(QJDownFail:)];
}
#pragma mark用户信息详情获取成功方法
-(void)QJDowLoadFinish:(id)sender
{
    NSLog(@"数据详情%@",sender);
    NSDictionary *dic=[sender objectForKey:@"data"];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.globalDic=@{@"user_id":[dic objectForKey:@"id"],@"sec_id":[dic objectForKey:@"sec_id"],@"is_senior":[dic objectForKey:@"is_senior"],@"senior_range":[dic objectForKey:@"senior_range"],@"mobile":[dic objectForKey:@"mobile"],@"user_type":[dic objectForKey:@"user_type"],@"name":[dic objectForKey:@"name"],@"has_company":[dic objectForKey:@"has_company"],@"head_img":[dic objectForKey:@"head_img"],@"company_id":[dic objectForKey:@"company_id"],@"company_name":[dic objectForKey:@"company_name"]};
    NSLog(@"看看是什么啊%@",delegate.globalDic);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark用户信息详情获取失败方法
-(void)QJDownFail:(id)sender
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSourceArray.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=dataSourceArray[indexPath.row];
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    UITableViewCell *Cell = [tableView cellForRowAtIndexPath:indexPath];
    if (Cell == nil) {
        Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    UIImageView *timeImageView=[[UIImageView alloc]initWithFrame:FRAME(20, 10, 20, 20)];
    timeImageView.image=[UIImage imageNamed:@"icon_sec_time"];
    [Cell addSubview:timeImageView];
    UILabel *timeLabel=[[UILabel alloc]init];
    timeLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"checkinTime"]];
    timeLabel.font=[UIFont fontWithName:@"Arial" size:20];
    [timeLabel setNumberOfLines:1];
    [timeLabel sizeToFit];
    timeLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    timeLabel.frame=FRAME(timeImageView.frame.size.width+timeImageView.frame.origin.x+5, timeImageView.frame.origin.y, timeLabel.frame.size.width, 20);
    [Cell addSubview:timeLabel];
    
    UIImageView *addimageView=[[UIImageView alloc]initWithFrame:FRAME(20, 40, 20, 20)];
    addimageView.image=[UIImage imageNamed:@"icon_sec_addr"];
    [Cell addSubview:addimageView];
    UILabel *addLabel=[[UILabel alloc]init];
    addLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"poiName"]];
    addLabel.font=[UIFont fontWithName:@"Arial" size:18];
    [addLabel setNumberOfLines:1];
    [addLabel sizeToFit];
    addLabel.frame=FRAME(addimageView.frame.size.width+addimageView.frame.origin.x+5, addimageView.frame.origin.y, addLabel.frame.size.width, 20);
    [Cell addSubview:addLabel];

    [Cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return Cell;
}


-(void)webLayout
{
    [layoutView removeFromSuperview];
    layoutView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
    layoutView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:layoutView];
    
    [myWebView removeFromSuperview];
    myWebView= [[UIWebView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    myWebView.delegate=self;
    myWebView.scrollView.delegate=self;
    [layoutView addSubview:myWebView];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:request];
    
    UIButton *liftButton=[[UIButton alloc]initWithFrame:FRAME(10, 20, 50, 30)];
    [liftButton addTarget:self action:@selector(liftWebButAction) forControlEvents:UIControlEventTouchUpInside];
    [layoutView addSubview:liftButton];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:FRAME(18, 5, 10, 20)];
    image.image = [UIImage imageNamed:@"title_left_back"];
    [liftButton addSubview:image];
    
    webTitleLabel=[[UILabel alloc]initWithFrame:FRAME(60, 20, WIDTH-120, 30)];
    webTitleLabel.textAlignment=NSTextAlignmentCenter;
    webTitleLabel.font=[UIFont fontWithName:@"Arial" size:15];
    [layoutView addSubview:webTitleLabel];
    
    UIButton *rightButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-60, 20, 50, 30)];
    [rightButton addTarget:self action:@selector(rightButAction) forControlEvents:UIControlEventTouchUpInside];
    [layoutView addSubview:rightButton];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(10, 0, 30, 30)];
    img.image = [UIImage imageNamed:@"WEB_QX"];
    [rightButton addSubview:img];
}
-(void)rightButAction
{
    [layoutView removeFromSuperview];
}
-(void)liftWebButAction
{
    if([myWebView canGoBack])
    {
        [myWebView goBack];
    }else{
        [layoutView removeFromSuperview];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
