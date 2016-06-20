//
//  DetailsListViewController.m
//  yxz
//
//  Created by 白玉林 on 16/3/3.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "DetailsListViewController.h"
#import "RootViewController.h"
#import "BookingViewController.h"
#import "MeetingViewController.h"
int heights,Y,processIDs=0;
@interface DetailsListViewController ()
{
    UITableView *myTableView;
    UIScrollView *myScrollView;
    UIView *layoutView;
    
    UIButton *cancelBut;
    UIButton *modifyBut;
    
    NSMutableArray *plArray;
    int cellNum;
    int seekID;
    int frame;
    NSDictionary *dic;
    int seekButID;
    UIButton *seekButton;
    
    UIView *underView;
    UIButton *commentButton;
    UITextView *textView;
    UILabel *textViewLabel;
    UILabel *alertLabel;
    
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    NSInteger   page;
    UILabel *zambiaLabel;
    
}

@end

@implementation DetailsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGesture.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:tapGesture];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    page=1;
    plArray=[[NSMutableArray alloc]init];
    self.view.backgroundColor=[UIColor whiteColor];
    UIButton *backBut=[[UIButton alloc]initWithFrame:FRAME(0, 20, 60, 44)];
    [backBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBut];
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 10, 20)];
    img.image = [UIImage imageNamed:@"title_left_back"];
    [backBut addSubview:img];

    UIView *navLineView=[[UIView alloc]initWithFrame:FRAME(0, 63, WIDTH, 1)];
    navLineView.backgroundColor=[UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1];
    [self.view addSubview:navLineView];
    
    modifyBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH-50, 25, 40, 30)];
    [modifyBut setTitle:@"修改" forState:UIControlStateNormal];
    modifyBut.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    modifyBut.layer.cornerRadius=4;
    [modifyBut addTarget:self action:@selector(modifyBut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:modifyBut];
    
    cancelBut=[[UIButton alloc]initWithFrame:FRAME(modifyBut.frame.origin.x-50, 25, 40, 30)];
    [cancelBut setTitle:@"取消" forState:UIControlStateNormal];
    cancelBut.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    cancelBut.layer.cornerRadius=4;
    [cancelBut addTarget:self action:@selector(cancelBut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBut];
    
    myTableView=[[UITableView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-113)];
    myTableView.dataSource=self;
    myTableView.delegate=self;
    myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:myTableView];
    _refreshHeader = [[MJRefreshHeaderView alloc] init];
    _refreshHeader.delegate = self;
    _refreshHeader.scrollView = myTableView;
    
    _moreFooter = [[MJRefreshFooterView alloc] init];
    _moreFooter.delegate = self;
    _moreFooter.scrollView = myTableView;
}


-(void)viewTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    [self.view endEditing:YES];
    underView.frame=CGRectMake(0, HEIGHT-49, WIDTH, 49);
    [UIView commitAnimations];
    
}
-(void)modifyBut
{
    NSString *card=[NSString stringWithFormat:@"%@",[dic objectForKey:@"card_type"]];
    int card_type=[card intValue];
    int statusID=[[dic objectForKey:@"status"]intValue];
    if(card_type==5){
        if (statusID==2) {
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"秘书已接单，如需修改请与秘书直接联系！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
        }else{
            BookingViewController *bookVc=[[BookingViewController alloc]init];
            bookVc.pushID=1;
            bookVc.cardString=[NSString stringWithFormat:@"%d",_card_ID];
            //_card_ID
            [self.navigationController pushViewController:bookVc animated:YES];
        }
        
    }else{
        if (statusID==2) {
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"秘书已接单，如需修改请与秘书直接联系！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
        }else{
            int vcId=[[dic objectForKey:@"card_type"]intValue];
            MeetingViewController *bookVc=[[MeetingViewController alloc]init];
            bookVc.pushID=1;
            bookVc.cardString=[NSString stringWithFormat:@"%d",_card_ID];
            if (vcId==1) {
                bookVc.vcID=1001;
            }else if (vcId==2){
                bookVc.vcID=1002;
            }else if (vcId==3){
                bookVc.vcID=1003;
            }else if (vcId==4){
                bookVc.vcID=1004;
            }
            
            //_card_ID
            [self.navigationController pushViewController:bookVc animated:YES];
        }
        
    }
    NSLog(@"点击了处理流程");
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString* msg = [[NSString alloc] initWithFormat:@"%ld",(long)buttonIndex];
    
    if (alertView.tag==1101) {
        if ([msg isEqualToString:@"0"]) {
            ISLoginManager *_manager = [ISLoginManager shareManager];
            DownloadManager *_download = [[DownloadManager alloc]init];
            NSString *card_Id=[NSString stringWithFormat:@"%d",_card_ID];
            NSLog(@"ID%@  %d",card_Id, _card_ID);
            NSDictionary *_dict = @{@"user_id":_manager.telephone,@"card_id":card_Id,@"status":@"0"};
            NSLog(@"字典数据%@",_dict);
            [_download requestWithUrl:CARD_QXJK dict:_dict view:self.view delegate:self finishedSEL:@selector(QXFinish:) isPost:YES failedSEL:@selector(QXDownFail:)];
        }
    }
}
-(void)cancelBut
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要取消卡片吗？取消后会在日程中删除，并且所有提醒人员将收不到提醒。"  delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"返回",nil];
    alert.tag=1101;
    [alert show];
    
}
//取消成功方法
-(void)QXFinish:(id)sender
{
    NSDictionary *dict=[sender objectForKey:@"data"];
    //删除原来的闹钟
    NSArray *narry=[[UIApplication sharedApplication] scheduledLocalNotifications];
    NSUInteger acount=[narry count];
    if (acount>0)
    {// 遍历找到对应nfkey和notificationtag的通知
        for (int i=0; i<acount; i++)
        {
            UILocalNotification *myUILocalNotification = [narry objectAtIndex:i];
            NSDictionary *userInfo = [myUILocalNotification.userInfo objectForKey:@"dic"];
            NSNumber *obj = [userInfo objectForKey:@"ci"];
            int mytag=[obj intValue];
            NSString *card_id=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
            int notificationtag=[card_id intValue];
            if (mytag==notificationtag)
            {
                //删除本地通知
                [[UIApplication sharedApplication] cancelLocalNotification:myUILocalNotification];
                break;
            }
        }
    }//删除原来的闹钟
    [self.navigationController popViewControllerAnimated:YES];
}
//取消失败方法
-(void)QXDownFail:(id)sender
{
    
}

-(void)todoSomething
{
    if (_vcIDS==1000) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
       [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)backAction
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething) object:nil];
    [self performSelector:@selector(todoSomething) withObject:nil afterDelay:0.2f];
    
    //    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)PLJKLayout
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    
    NSString *card_Id=[NSString stringWithFormat:@"%d",_card_ID];
    NSLog(@"ID%@  %d",card_Id, _card_ID);
    NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict = @{@"card_id":card_Id,@"user_id":_manager.telephone,@"page":pageStr};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CARD_PLLB dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadPLLB:) isPost:NO failedSEL:@selector(PLLBbDownFail:)];
}

-(void)logDowLoadPLLB:(id)sender
{
    NSLog(@"返回数据 %@",sender);
    NSString *plString=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    
    NSLog(@"string的值%@",plString);
    if ([plString isEqualToString:@""]) {
        cellNum=0;
    }else
    {
        NSArray *array=[sender objectForKey:@"data"];
        if (array.count<10) {
            _hasMore=YES;
        }else{
            _hasMore=NO;
        }
        
        if (page==1) {
            [plArray removeAllObjects];
            [plArray addObjectsFromArray:array];
        }else{
            for (int i=0; i<array.count; i++) {
                if ([plArray containsObject:array[i]]) {
                    
                }else{
                    [plArray addObject:array[i]];
                }
            }
        }
        
        cellNum=(int)plArray.count;
    }
    myTableView.tableHeaderView=layoutView;
    [myTableView reloadData];
    
}
-(void)PLLBbDownFail:(id)sender
{
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
   
}
-(void)viewDidAppear:(BOOL)animated
{
    [self cardDetails];
    [self uiserInfo];
    
}
-(void)cardDetails
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *card_Id=[NSString stringWithFormat:@"%d",_card_ID];
    NSLog(@"ID%@  %d",card_Id, _card_ID);
    NSDictionary *_dict = @{@"card_id":card_Id,@"user_id":_manager.telephone};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CARD_DETAILS dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
//
}
-(void)uiserInfo
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *dict = @{@"user_id":_manager.telephone};
    NSLog(@"字典数据%@",dict);
    [_download requestWithUrl:USER_INFO dict:dict view:self.view delegate:self finishedSEL:@selector(msgm:) isPost:NO failedSEL:@selector(Downmsgm:)];

}
#pragma mark用户信息
-(void)msgm:(id)sender
{
    NSLog(@"用户数据:%@",sender);
    NSDictionary *diction=[sender objectForKey:@"data"];
    seekID=[[diction objectForKey:@"user_type"]intValue];
}
-(void)Downmsgm:(id)sender
{
    
}
#pragma mark卡片详情
-(void)logDowLoadFinish:(id)sender
{
    dic=[sender objectForKey:@"data"];
    NSLog(@"登录后信息：%@",sender);
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *processDic = @{@"user_id":_manager.telephone};
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",USER_INFO] dict:processDic view:self.view delegate:self finishedSEL:@selector(DownloadFinish1:) isPost:NO failedSEL:@selector(FailDownload:)];
    [self viewLayout];
}
-(void)DownFail:(id)sender
{
    NSLog(@"erroe is %@",sender);
}
#pragma mark获取用户秘书信息
-(void)DownloadFinish1:(id)sender
{
    NSLog(@"%@",sender);
    NSDictionary *processDic=[sender objectForKey:@"data"];
    NSLog(@"获取用户秘书信息%@",processDic);
    NSString *card_id=[dic objectForKey:@"card_id"];
    NSString *sec_id=[processDic objectForKey:@"sec_id"];
    NSString *status=[dic objectForKey:@"status"];
    //ISLoginManager *_manager = [ISLoginManager shareManager];
    if([[processDic objectForKey:@"is_senior"]intValue]==1){
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *proDic = @{@"card_id":card_id,@"sec_id":sec_id,@"status":status};
        [_download requestWithUrl:[NSString stringWithFormat:@"%@",SEEK_MSCL] dict:proDic view:self.view delegate:self finishedSEL:@selector(MSCLDownloadFinish1:) isPost:YES failedSEL:@selector(MSCLFailDownload:)];
    }
    
    
}
-(void)FailDownload:(id)sender
{
    
}
#pragma mark处理信息获取成功方法
-(void)MSCLDownloadFinish1:(id)sender
{
    NSLog(@"处理信息%@",sender);
}
#pragma mark处理信息获取失败方法
-(void)MSCLFailDownload:(id)sender
{
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        NSLog(@"------是列表---");
    }
    else {
        NSLog(@"------是滚动试图----");
    }
}
-(void)viewLayout
{
    [layoutView removeFromSuperview];
    layoutView=[[UIView alloc]init];
    layoutView.backgroundColor=[UIColor whiteColor];
//    [myScrollView addSubview:layoutView];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSString *user_id=_manager.telephone;
    NSString *create_user_id=[dic objectForKey:@"create_user_id"];
    NSLog(@"自己 %@创建者%@",user_id,create_user_id);
    if(create_user_id==user_id){
        int statusID=[[dic objectForKey:@"status"]intValue];
        if (statusID==1||statusID==2) {
            modifyBut.enabled=TRUE;
            [modifyBut setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];//textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
            cancelBut.enabled=TRUE;
            [cancelBut setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
        }else{
            modifyBut.enabled=FALSE;
            [modifyBut setTitleColor:[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1] forState:UIControlStateNormal];
            
            cancelBut.enabled=FALSE;
            [cancelBut setTitleColor:[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1] forState:UIControlStateNormal];
        }
    }else{
        modifyBut.enabled=FALSE;
        [modifyBut setTitleColor:[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1] forState:UIControlStateNormal];
        
        cancelBut.enabled=FALSE;
        [cancelBut setTitleColor:[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1] forState:UIControlStateNormal];
    }
    NSString *titleStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"card_type_name"]];
    self.title=titleStr;
    UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 6)];
    view.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    [myScrollView addSubview:view];
    UIImageView *headeiamgeView=[[UIImageView alloc]initWithFrame:FRAME(15, 25/2, 30, 30)];
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"head_img_create_user"]];
    [headeiamgeView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
    headeiamgeView.layer.cornerRadius=headeiamgeView.frame.size.width/2;
    headeiamgeView.clipsToBounds=YES;
    [layoutView addSubview:headeiamgeView];
    
    UILabel *headeTime=[[UILabel alloc]init];
    headeTime.frame=CGRectMake(headeiamgeView.frame.origin.x+headeiamgeView.frame.size.width+10, 6+25/2+15/2, headeTime.frame.size.width, 15);
    double inTime=[[dic objectForKey:@"service_time"] doubleValue];
    NSDateFormatter* inTimeformatter =[[NSDateFormatter alloc] init];
    inTimeformatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [inTimeformatter setDateStyle:NSDateFormatterMediumStyle];
    [inTimeformatter setTimeStyle:NSDateFormatterShortStyle];
    [inTimeformatter setDateFormat:@"HH:mm"];
    NSDate* inTimedate = [NSDate dateWithTimeIntervalSince1970:inTime];
    NSString* inTimeString = [inTimeformatter stringFromDate:inTimedate];
    headeTime.text=inTimeString;
    headeTime.font=[UIFont fontWithName:@"Heiti SC" size:14];
    headeTime.lineBreakMode =NSLineBreakByTruncatingTail ;
    [headeTime setNumberOfLines:0];
    [headeTime sizeToFit];
    [layoutView addSubview:headeTime];
    
    UILabel *stateLabel=[[UILabel alloc]init];
    NSString *textStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
    int clID=[textStr intValue];
    if (clID==1) {
        stateLabel.text=@"处理中";
        stateLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    }else if (clID==2){
        stateLabel.text=@"秘书处理中";
        stateLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    }else if(clID==3){
        stateLabel.text=@"已完成";
        stateLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    }else if (clID==0){
        stateLabel.text=@"已取消";
        stateLabel.textColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    }
    stateLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    [stateLabel setNumberOfLines:0];
    [stateLabel sizeToFit];
    stateLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    stateLabel.textAlignment=NSTextAlignmentRight;
    
    stateLabel.frame=CGRectMake(WIDTH-stateLabel.frame.size.width-30, (55-28)/2, stateLabel.frame.size.width+20, 56/2);
    [layoutView addSubview:stateLabel];
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(stateLabel.frame.size.width, 0, 10, stateLabel.frame.size.height)];
    image.image=[UIImage imageNamed:@"SYCELL_YHB_@2x"];
    [stateLabel addSubview:image];
//    UIImageView *image2=[[UIImageView alloc]initWithFrame:CGRectMake(-20, 0, stateLabel.frame.size.width+20,stateLabel.frame.size.height)];
//    image2.image=[UIImage imageNamed:@"SYCELL_YHBY_@2x"];
//    [stateLabel addSubview:image2];
    stateLabel.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"SYCELL_YHBY_@2x"]];
    
    UIView *lineView=[[UIView alloc]initWithFrame:FRAME(0, headeiamgeView.frame.size.height+25, WIDTH, 1)];
    lineView.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [layoutView addSubview:lineView];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:FRAME(20, lineView.frame.origin.y+16, WIDTH-40, 13)];
    NSDateFormatter* inTimeformatter1 =[[NSDateFormatter alloc] init];
    inTimeformatter1.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [inTimeformatter1 setDateStyle:NSDateFormatterMediumStyle];
    [inTimeformatter1 setTimeStyle:NSDateFormatterShortStyle];
    [inTimeformatter1 setDateFormat:@"时间：YYYY年MM月dd日 HH:mm:ss"];
    NSDate* inTimedate1 = [NSDate dateWithTimeIntervalSince1970:inTime];
    NSString* inTimeString1 = [inTimeformatter1 stringFromDate:inTimedate1];
    timeLabel.text=inTimeString1;
    timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
    timeLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
    [layoutView addSubview:timeLabel];
    
    NSArray *nameArray=[dic objectForKey:@"attends"];
    NSMutableArray *nameArr=[[NSMutableArray alloc]init];
    for (int i=0; i<nameArray.count; i++) {
        NSString *nameString=[NSString stringWithFormat:@"%@",[nameArray[i] objectForKey:@"name"]];
        [nameArr addObject:nameString];
    }
    NSString *personnel =[nameArr componentsJoinedByString:@","];
    UILabel *remindLabel=[[UILabel alloc]init];
    remindLabel.text=[NSString stringWithFormat:@"提醒人:%@",personnel];
//    remindLabel.backgroundColor=[UIColor redColor];
    UIFont *font = [UIFont fontWithName:@"Heiti SC" size:13];
    remindLabel.font=font;
    [remindLabel setNumberOfLines:0];
    [remindLabel sizeToFit];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil];
    CGSize size = [personnel boundingRectWithSize:CGSizeMake(WIDTH-40, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    remindLabel.frame=FRAME(20, timeLabel.frame.size.height+timeLabel.frame.origin.y+15, WIDTH-40, size.height);
    remindLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
    [layoutView addSubview:remindLabel];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:remindLabel.text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:1];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [remindLabel.text length])];
    [remindLabel setAttributedText:attributedString1];
    
    
    UILabel *addressLabel=[[UILabel alloc]initWithFrame:FRAME(20, remindLabel.frame.size.height+remindLabel.frame.origin.y+15, WIDTH-40, 13)];
    NSString *cityDicjson=[NSString stringWithFormat:@"%@",[dic objectForKey:@"card_extra"]];
    NSData *jsonData = [cityDicjson dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *cityDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
    NSString *fromCityString=[cityDic objectForKey:@"ticket_from_city_name"];
    NSString *toCityString=[cityDic objectForKey:@"ticket_to_city_name"];
    NSString *textString=[NSString stringWithFormat:@"从 %@ 到 %@",fromCityString,toCityString];
    addressLabel.text=textString;
    addressLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
    addressLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
//    addressLabel.backgroundColor=[UIColor redColor];
    [layoutView addSubview:addressLabel];
    
    UILabel *flightLabel=[[UILabel alloc]initWithFrame:FRAME(20, addressLabel.frame.size.height+addressLabel.frame.origin.y+15, WIDTH-40, 13)];
    flightLabel.text=@"航班";
    flightLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
    flightLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
    [layoutView addSubview:flightLabel];
    
   
        NSString *card=[NSString stringWithFormat:@"%@",[dic objectForKey:@"card_type"]];
    int card_type=[card intValue];
    switch (card_type) {
        case 1:
        {
            timeLabel.hidden=NO;
            remindLabel.hidden=NO;
            addressLabel.hidden=NO;
            addressLabel.text=[NSString stringWithFormat:@"会议地点:%@",[dic objectForKey:@"service_addr"]];
            flightLabel.hidden=YES;
            frame=addressLabel.frame.origin.y+23;
        }
            break;
        case 2:
        {
            timeLabel.hidden=NO;
            remindLabel.hidden=NO;
            addressLabel.hidden=YES;
            flightLabel.hidden=YES;
            frame=remindLabel.frame.origin.y+remindLabel.frame.size.height+10;
            
        }
            break;
        case 3:
        {
            timeLabel.hidden=NO;
            remindLabel.hidden=NO;
            addressLabel.hidden=YES;
            flightLabel.hidden=YES;
            frame=remindLabel.frame.origin.y+remindLabel.frame.size.height+10;
        }
            break;
        case 4:
        {
            timeLabel.hidden=NO;
            remindLabel.hidden=NO;
            addressLabel.hidden=YES;
            flightLabel.hidden=YES;
            frame=remindLabel.frame.origin.y+remindLabel.frame.size.height+10;
            
        }
            break;
        case 5:
        {
            timeLabel.hidden=NO;
            remindLabel.hidden=NO;
            addressLabel.hidden=NO;
            flightLabel.hidden=NO;
            frame=flightLabel.frame.origin.y+23;
            
        }
            break;
        case 0:
        {
            timeLabel.hidden=NO;
            remindLabel.hidden=NO;
            addressLabel.hidden=YES;
            flightLabel.hidden=YES;
            frame=remindLabel.frame.origin.y+remindLabel.frame.size.height+10;
            
        }
            break;
            
        default:
            break;
    }
    UILabel *service_contentlabel=[[UILabel alloc]init];
    service_contentlabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_content"]];
    NSDictionary *dicts = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
    CGSize sizes = [service_contentlabel.text boundingRectWithSize:CGSizeMake(WIDTH-20, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicts context:nil].size;
    service_contentlabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    [service_contentlabel setNumberOfLines:0];
    [service_contentlabel sizeToFit];
    service_contentlabel.frame=FRAME(10, frame+10, WIDTH-20, sizes.height);
    [layoutView addSubview:service_contentlabel];

    UIButton *zambiaButton=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH-114, service_contentlabel.frame.origin.y+sizes.height+5, 30, 30)];
    UIImageView *imagView=[[UIImageView alloc]initWithFrame:FRAME(5, 5, 20, 20)];
    imagView.image=[UIImage imageNamed:@"common_icon_like_c@2x(1)"];
    [zambiaButton addSubview:imagView];
    [zambiaButton addTarget:self action:@selector(zmaAction:) forControlEvents:UIControlEventTouchUpInside];
    [layoutView addSubview:zambiaButton];
    
    zambiaLabel=[[UILabel alloc]init];
    zambiaLabel.frame=FRAME(WIDTH-114+35, zambiaButton.frame.origin.y+9, WIDTH-(WIDTH-114+35)-50, 12);
//    zambiaLabel.backgroundColor=[UIColor redColor];
    [self zamLayout];
    [layoutView addSubview:zambiaLabel];
    
    UIButton *shareButton=[[UIButton alloc]init];
    shareButton.frame=CGRectMake(WIDTH-50, zambiaButton.frame.origin.y, 30, 30);
    [shareButton addTarget:self action:@selector(fxButtonan:) forControlEvents:UIControlEventTouchUpInside];
    [layoutView addSubview:shareButton];
    UIImageView *imaView=[[UIImageView alloc]initWithFrame:FRAME(5, 5, 20, 20)];
    imaView.image=[UIImage imageNamed:@"common_icon_share@2x(1)"];
    [shareButton addSubview:imaView];
    UIView *seekView=[[UIView alloc]init];
    [layoutView addSubview:seekView];
    
    UIView *lineViews=[[UIView alloc]init];
    lineViews.frame=CGRectMake(0, shareButton.frame.origin.y+shareButton.frame.size.height+10, WIDTH, 1);
    lineViews.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    [layoutView addSubview:lineViews];
#pragma mark 秘书
    if (seekID==1) {
        NSString *imgString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"user_head_img"]];
        
        
        UIImageView *seekImage=[[UIImageView alloc]initWithFrame:FRAME(20, 10, 30, 30)];
        seekImage.layer.cornerRadius=seekImage.frame.size.width/2;
        if ([imgString length]==1||[imgString length]==0) {
            seekImage.image =[UIImage imageNamed:@"家-我_默认头像"];
            //            headeView.backgroundColor=[UIColor redColor];
        }else
        {
            seekImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"user_head_img"]]]];
        }
        seekImage.clipsToBounds = YES;
        //seekImage.backgroundColor=[UIColor brownColor];
        [seekView addSubview:seekImage];
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:FRAME(seekImage.frame.size.width+seekImage.frame.origin.x+5, 10, WIDTH-(seekImage.frame.size.width+seekImage.frame.origin.x+80), 15)];
        nameLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"user_name"]];
        nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
        [seekView addSubview:nameLabel];
        UILabel *periodLabel=[[UILabel alloc]initWithFrame:FRAME(nameLabel.frame.origin.x, 27, nameLabel.frame.size.width, 12)];
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        periodLabel.text=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"senior_range"]];
        periodLabel.font=[UIFont fontWithName:@"Heiti SC" size:10];
        [seekView addSubview:periodLabel];
        
        seekButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-65, 10, 55, 30)];
        seekButton.layer.cornerRadius=5;
        seekButton.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
        [seekButton addTarget:self action:@selector(seekButAction:) forControlEvents:UIControlEventTouchUpInside];
        if (clID==1) {
            [seekButton setTitle:@"接单" forState:UIControlStateNormal];
            seekButton.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
            seekButton.enabled = TRUE;
            seekButID=0;
            
        }else if (clID==2){
            seekButID=1;
            [seekButton setTitle:@"完成" forState:UIControlStateNormal];
            seekButton.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
            seekButton.enabled = TRUE;
        }else if (clID==3){
            [seekButton setTitle:@"已完成" forState:UIControlStateNormal];
            seekButton.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
            seekButton.enabled = FALSE;
        }
        [seekView addSubview:seekButton];
        
        UILabel *textLabel=[[UILabel alloc]initWithFrame:FRAME(nameLabel.frame.origin.x, 45, WIDTH-(seekImage.frame.size.width+seekImage.frame.origin.x+30), 15)];
        textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"set_sec_remarks"]];
        textLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
        textLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        [textLabel setNumberOfLines:0];
        [textLabel sizeToFit];
        textLabel.frame=FRAME(nameLabel.frame.origin.x, 45, WIDTH-(seekImage.frame.size.width+seekImage.frame.origin.x+30), textLabel.frame.size.height);
        [seekView addSubview:textLabel];
        UIView *linView=[[UIView alloc]initWithFrame:FRAME(0, textLabel.frame.size.height+textLabel.frame.origin.y+3, WIDTH, 1)];
        linView.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
        [seekView addSubview:linView];
        seekView.frame=FRAME(0, lineViews.frame.origin.y+1, WIDTH, linView.frame.origin.y+1);
        ISLoginManager *_manager = [ISLoginManager shareManager];
        NSString *user_id=_manager.telephone;
        NSString *create_user_id=[dic objectForKey:@"create_user_id"];
        if(user_id!=create_user_id)
        {
            frame=lineViews.frame.origin.y;
            seekView.hidden=YES;
        }else{
            frame=seekView.frame.origin.y+seekView.frame.size.height;
            seekView.hidden=NO;
        }
        
    }else{
        frame=lineViews.frame.origin.y;
        modifyBut.hidden=NO;
    }
    
    UILabel *iamgeView=[[UILabel alloc]initWithFrame:FRAME(8, frame+15, 30, 20)];
    iamgeView.text=@"点赞";
    iamgeView.font=[UIFont fontWithName:@"Heiti SC" size:14];
    iamgeView.textColor=[UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1];
    //iamgeView.image=[UIImage imageNamed:@"common_icon_like_c@2x(1)"];
    [layoutView addSubview:iamgeView];
    
    NSArray *headArray=[dic objectForKey:@"zan_top10"];
    NSLog(@"%@",dic);
    NSInteger num;
    NSLog(@"%@",headArray);
    NSLog( @"%lu",(unsigned long)headArray.count);
    if (headArray.count>5) {
        num=5;
    }else{
        num=headArray.count;
    }
    for (int i=0; i<num; i++) {
        NSDictionary *dict=headArray[i];
        UIImageView *headeView=[[UIImageView alloc]init];
        headeView.frame=CGRectMake(48+45*i, frame+10, 30, 30);
        //headeView.backgroundColor=[UIColor brownColor];
        // headeView.layer.cornerRadius=headeView.frame.size.width/2;
        NSString *headString=[dict objectForKey:@"head_img"];
        headeView.clipsToBounds = YES;
        NSLog(@"1%@1",headString);
        if ([headString length]==0||[headString length]==1) {
            headeView.image=[UIImage imageNamed:@"家-我_默认头像"];
            headeView.layer.cornerRadius=headeView.frame.size.width/2;
        }else{
            headeView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"head_img"]]]];
            headeView.layer.cornerRadius=headeView.frame.size.width/2;
        }
        
        [layoutView addSubview:headeView];
        if (i==num-1) {
            UILabel *label=[[UILabel alloc]init];
            label.text=[NSString stringWithFormat:@"共%lu人",(unsigned long)headArray.count];
            label.lineBreakMode=NSLineBreakByTruncatingTail;
            [label setNumberOfLines:1];
            [label sizeToFit];
            label.font=[UIFont fontWithName:@"Heiti SC" size:10];
            label.textColor=[UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1];
            label.frame=FRAME(headeView.frame.size.width+headeView.frame.origin.x+5, headeView.frame.origin.y+5, label.frame.size.width, 20);
            [layoutView addSubview:label];
        }
        //headeView.layer.cornerRadius=headeView.frame.size.width/2;
    }

    
    layoutView.frame=FRAME(0, 0, WIDTH, frame+50);
//    if (layoutView.frame.size.height+200>HEIGHT-113) {
//        myScrollView.contentSize=CGSizeMake(WIDTH, layoutView.frame.size.height+206);
//        myTableView.frame=FRAME(0, layoutView.frame.size.height, WIDTH, 200);
//    }else if (layoutView.frame.size.height+200==HEIGHT-113){
//        myScrollView.contentSize=CGSizeMake(WIDTH, HEIGHT-64);
//        myTableView.frame=FRAME(0, layoutView.frame.size.height, WIDTH, HEIGHT-113-layoutView.frame.size.height);
//    }else{
//        myScrollView.contentSize=CGSizeMake(WIDTH, HEIGHT-113);
//        myTableView.frame=FRAME(0, layoutView.frame.size.height, WIDTH, HEIGHT-113-layoutView.frame.size.height);
//    }
    [self commwntLayout];
    [self PLJKLayout];
}
-(void)commwntLayout
{
    underView=[[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-49, WIDTH, 49)];
    underView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:underView];
    textView=[[UITextView alloc]initWithFrame:CGRectMake(17/2,9, WIDTH-86, 31)];
    textView.delegate=self;
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    textView.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    textView.layer.borderWidth = 0.6f;
    textView.layer.cornerRadius = 6.0f;
    [underView addSubview:textView];
    
    textViewLabel=[[UILabel alloc]initWithFrame:FRAME(3, 8, WIDTH-39, 15)];
    textViewLabel.text=@"等你来评论...";
    textViewLabel.textColor=[UIColor colorWithRed:164/255.0f green:164/255.0f blue:164/255.0f alpha:1];
    textViewLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    textViewLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [textViewLabel setNumberOfLines:1];
    [textViewLabel sizeToFit];
    [textView addSubview:textViewLabel];
    
    commentButton=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH-60-15/2, 9, 60, 31)];
    commentButton.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [commentButton setTitle:@"评论" forState:UIControlStateNormal];
    commentButton.titleLabel.textColor=[UIColor whiteColor];
    commentButton.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    commentButton.layer.cornerRadius=7;
    //    commentButton.enabled = FALSE;
    [commentButton addTarget:self action:@selector(commentButtonAN) forControlEvents:UIControlEventTouchUpInside];
    
    [underView addSubview:commentButton];
}
- (void)timerFireMethod:(NSTimer*)theTimer
{
    alertLabel.hidden=YES;
}
-(void)commentButtonAN
{
    NSString *textString=textView.text;
    if(textString==nil||textString==NULL||[textString isKindOfClass:[NSNull class]]||[[textString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        [alertLabel removeFromSuperview];
        alertLabel=[[UILabel alloc]initWithFrame:FRAME((WIDTH-260)/2, underView.frame.origin.y-70, 260, 40)];
        alertLabel.backgroundColor=[UIColor blackColor];
        alertLabel.alpha=0.4;
        alertLabel.text=@"还没有输入评论内容哦～";
        alertLabel.textColor=[UIColor whiteColor];
        alertLabel.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:alertLabel];
        
        [NSTimer scheduledTimerWithTimeInterval:2.0f
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:alertLabel
                                        repeats:NO];
    }else{
        [UIView beginAnimations:nil context:nil];
        //设置动画时长
        [UIView setAnimationDuration:0.5];
        [self.view endEditing:YES];
        underView.frame=CGRectMake(0, HEIGHT-49, WIDTH, 49);
        [UIView commitAnimations];
        //[selfView addSubview:underView];
        ISLoginManager *_manager = [ISLoginManager shareManager];
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSString *card_Id=[NSString stringWithFormat:@"%d",_card_ID];
        NSLog(@"ID%@  %d",card_Id, _card_ID);
        NSDictionary *_dict = @{@"card_id":card_Id,@"user_id":_manager.telephone,@"comment":textView.text};
        NSLog(@"字典数据%@",_dict);
        [_download requestWithUrl:CARD_PL dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadPingLun:) isPost:YES failedSEL:@selector(PingLubDownFail:)];
        [textView setText:@""];
        
        NSLog(@"text%@",textView.text);
    }
}
- (void)textViewDidChange:(UITextView *)textview
{
    
    if ([textView.text length] == 0) {
        [textViewLabel setHidden:NO];
    }else{
        [textViewLabel setHidden:YES];
    }
}
-(void)logDowLoadPingLun:(id)sender
{
    [self PLJKLayout];
    NSLog(@"评论成功");
}
-(void)PingLubDownFail:(id)sender
{
    NSLog(@"评论失败");
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textview
{
    NSLog(@"textViewShouldBeginEditing");
    return YES;
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    heights = keyboardRect.size.height;
    underView.frame=CGRectMake(0, HEIGHT-heights-49, WIDTH, 49);
}

-(void)fxButtonan:(UIButton *)sender
{
    [UMSocialWechatHandler setWXAppId:@"wx93aa45d30bf6cba3" appSecret:@"7a4ec42a0c548c6e39ce9ed25cbc6bd7" url:Handlers];
    [UMSocialQQHandler setQQWithAppId:@"1104934408" appKey:@"bRW2glhUCR6aJYIZ" url:QQHandlerss];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"247547429" RedirectURL:SSOHandlers];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:YMAPPKEY shareText:@"云行政，企业行政服务第一平台！极大降低企业行政管理成本，有效提升行政综合服务能力，快来试试吧！体验就送礼哦：http://51xingzheng.cn/h5-app-download.html！" shareImage:[UIImage imageNamed:@"yunxingzheng-Logo-512.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina,nil] delegate:self];
}
#pragma mark 分享成功返回
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

-(void)zmaAction:(UIButton *)sender
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *card_Id=[NSString stringWithFormat:@"%d",_card_ID];
    NSLog(@"ID%@  %d",card_Id, _card_ID);
    NSDictionary *_dict = @{@"card_id":card_Id,@"user_id":_manager.telephone};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CARD_DZ dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadDA:) isPost:YES failedSEL:@selector(DZDownFail:)];
}
-(void)logDowLoadDA:(id)sender
{
    NSLog(@"点赞成功");
    [self cardDetails];
    
}
-(void)DZDownFail:(id)sender
{
    NSLog(@"点赞失败");
}

-(void)zamLayout
{
    NSString *zambiaString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"total_zan"]];
    //j
    zambiaLabel.text=zambiaString;
    zambiaLabel.font=[UIFont fontWithName:@"Heiti SC" size:10];
    [zambiaLabel setNumberOfLines:1];
    [zambiaLabel sizeToFit];
    zambiaLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    zambiaLabel.textColor=[UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 29;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    sectionView.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    UILabel *label=[[UILabel alloc]init];
    label.text=@"评论";
    label.lineBreakMode=NSLineBreakByTruncatingTail;
    [label setNumberOfLines:1];
    [label sizeToFit];
    label.textColor=[UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1];
    label.font=[UIFont fontWithName:@"Heiti SC" size:14];
    label.frame=FRAME(10, 4, label.frame.size.width, 20);
    [sectionView addSubview:label];
    UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 24, WIDTH, 5)];
    view.backgroundColor=[UIColor whiteColor];
    [sectionView addSubview:view];
    
    return sectionView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return cellNum;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *plDic=plArray[indexPath.row];
    NSString *CellIdentifier =[NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    UILabel *nameLabel=[[UILabel alloc]init];
    UILabel *textLabel=[[UILabel alloc]init];
    UIView *lineView=[[UIView alloc]init];
    UILabel *timeLabel=[[UILabel alloc]init];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        nameLabel.frame=FRAME(10, 10, 200, 13);
        // nameLabel.backgroundColor=[UIColor redColor];
        [cell addSubview:nameLabel];
        [cell addSubview:timeLabel];
        [cell addSubview:textLabel];
        [cell addSubview:lineView];
    }
    nameLabel.text=[NSString stringWithFormat:@"%@",[plDic objectForKey:@"name"]];
    nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
    nameLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
    
    
    double inTime=[[plDic objectForKey:@"add_time"] doubleValue];
    NSDateFormatter* inTimeformatter =[[NSDateFormatter alloc] init];
    inTimeformatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [inTimeformatter setDateStyle:NSDateFormatterMediumStyle];
    [inTimeformatter setTimeStyle:NSDateFormatterShortStyle];
    [inTimeformatter setDateFormat:@"HH:mm"];
    NSDate* inTimedate = [NSDate dateWithTimeIntervalSince1970:inTime];
    NSString* inTimeString = [inTimeformatter stringFromDate:inTimedate];
    
    
    timeLabel.text=inTimeString;
    // timeLabel.backgroundColor=[UIColor redColor];
    timeLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
    timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
    timeLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [timeLabel setNumberOfLines:1];
    [timeLabel sizeToFit];
    timeLabel.frame=FRAME(WIDTH-20-timeLabel.frame.size.width, 10, timeLabel.frame.size.width, 13);
    
    
    
    
    textLabel.text=[NSString stringWithFormat:@"%@",[plDic objectForKey:@"comment"]];
    [textLabel setNumberOfLines:0];
    //textLabel.backgroundColor=[UIColor blueColor];
    textLabel.lineBreakMode=NSLineBreakByWordWrapping;
    //    CGSize size = [textLabel sizeThatFits:CGSizeMake(WIDTH-20, 300)];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
    
    CGSize size = [textLabel.text boundingRectWithSize:CGSizeMake(WIDTH-20, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    textLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    textLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
    textLabel.frame =CGRectMake(10, nameLabel.frame.size.height+nameLabel.frame.origin.y+7, WIDTH-20, size.height);
    
    //cell.backgroundColor=[UIColor brownColor];
    
    
    lineView.frame=FRAME(0, textLabel.frame.size.height+textLabel.frame.origin.y+9, WIDTH, 1);
    lineView.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        dispatch_async(dispatch_get_main_queue(),^{
            [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        });
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *plDic=plArray[indexPath.row];
    NSString *inforStr = [NSString stringWithFormat:@"%@",[plDic objectForKey:@"comment"]];
    UIFont *font = [UIFont systemFontOfSize:14];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize size = [inforStr boundingRectWithSize:CGSizeMake(WIDTH-20, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size.height+40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
