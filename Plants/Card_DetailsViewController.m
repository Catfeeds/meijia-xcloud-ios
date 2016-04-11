//
//  Card_DetailsViewController.m
//  yxz
//
//  Created by 白玉林 on 16/3/3.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "Card_DetailsViewController.h"
#import "RootViewController.h"
@interface Card_DetailsViewController ()
{
    UITableView *myTableView;
    UIScrollView *myScrollView;
    UIView *layoutView;
    
    UIButton *cancelBut;
    UIButton *modifyBut;
    
    NSMutableArray *plArray;
    int cellNum;
    int seekID;
    NSDictionary *dic;
    
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    NSInteger   page;
    
}

@end

@implementation Card_DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page=1;
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
    [cancelBut setTitle:@"修改" forState:UIControlStateNormal];
    cancelBut.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    cancelBut.layer.cornerRadius=4;
    [cancelBut addTarget:self action:@selector(cancelBut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBut];
    
    myScrollView=[[UIScrollView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    myScrollView.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    myScrollView.delegate=self;
    [self.view addSubview:myScrollView];
    
    myTableView=[[UITableView alloc]init];
    //    myTableView.dataSource=self;
    //    myTableView.delegate=self;
    myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:myTableView];
    _refreshHeader = [[MJRefreshHeaderView alloc] init];
    _refreshHeader.delegate = self;
    _refreshHeader.scrollView = myTableView;
    
    _moreFooter = [[MJRefreshFooterView alloc] init];
    _moreFooter.delegate = self;
    _moreFooter.scrollView = myTableView;
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
    [self PLJKLayout];
}

#pragma mark 表格刷新相关

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self cardDetails];
    [self PLJKLayout];
}
-(void)backAction
{
    if (_S==1000) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[RootViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
    
    
    NSDictionary *dict = @{@"user_id":_manager.telephone};
    NSLog(@"字典数据%@",dict);
    [_download requestWithUrl:USER_INFO dict:dict view:self.view delegate:self finishedSEL:@selector(msgm:) isPost:NO failedSEL:@selector(Downmsgm:)];
    if (_S==1) {
        _L=1;
    }
    
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
    //    NSString *proString=[sender objectForKey:@"data"];
    //    NSDictionary *prodic=[sender objectForKey:@"data"];
    //    if (proString is) {
    //        <#statements#>
    //    }
}
#pragma mark处理信息获取失败方法
-(void)MSCLFailDownload:(id)sender
{
    
}


-(void)viewLayout
{
    [layoutView removeFromSuperview];
    layoutView=[[UIView alloc]init];
    layoutView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:layoutView];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSString *user_id=_manager.telephone;
    NSString *create_user_id=[dic objectForKey:@"create_user_id"];
    NSLog(@"自己 %@创建者%@",user_id,create_user_id);
    if(create_user_id==user_id){
        int statusID=[[dic objectForKey:@"status"]intValue];
        if (statusID==1||statusID==2) {
            modifyBut.enabled=TRUE;
            [modifyBut setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];//textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
            cancelBut.enabled=FALSE;
            [cancelBut setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
        }else{
            modifyBut.enabled=FALSE;
            [modifyBut setTitleColor:[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1] forState:UIControlStateNormal];
            
            cancelBut.enabled=TRUE;
            [cancelBut setTitleColor:[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1] forState:UIControlStateNormal];
        }
    }else{
        modifyBut.enabled=FALSE;
        [modifyBut setTitleColor:[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1] forState:UIControlStateNormal];
        
        cancelBut.enabled=TRUE;
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
    stateLabel.frame=CGRectMake(WIDTH-stateLabel.frame.size.width-5/2-15, 7+25/2, stateLabel.frame.size.width, 56/2);
    [layoutView addSubview:stateLabel];
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(stateLabel.frame.size.width, 0, 10, stateLabel.frame.size.height)];
    image.image=[UIImage imageNamed:@"SYCELL_YHB_@2x"];
    
    [stateLabel addSubview:image];
    UIImageView *image2=[[UIImageView alloc]initWithFrame:CGRectMake(-20, 0, stateLabel.frame.size.width+20,stateLabel.frame.size.height)];
    image2.image=[UIImage imageNamed:@"SYCELL_YHBY_@2x"];
    [stateLabel addSubview:image2];
    
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
    remindLabel.backgroundColor=[UIColor redColor];
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
    [addressLabel setNumberOfLines:0];
    [addressLabel sizeToFit];
    addressLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [layoutView addSubview:addressLabel];
    
    UILabel *flightLabel=[[UILabel alloc]initWithFrame:FRAME(20, addressLabel.frame.size.height+addressLabel.frame.origin.y+15, WIDTH-40, 13)];
    flightLabel.text=@"航班";
    flightLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
    flightLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
    [layoutView addSubview:flightLabel];
    
    layoutView.frame=FRAME(0, 70, WIDTH, flightLabel.frame.origin.y+23);
    if (layoutView.frame.size.height+200>HEIGHT-64) {
        myScrollView.contentSize=CGSizeMake(WIDTH, layoutView.frame.size.height+206);
        myTableView.frame=FRAME(0, layoutView.frame.size.height+70, WIDTH, 200);
    }else if (layoutView.frame.size.height+200==HEIGHT-64){
        myScrollView.contentSize=CGSizeMake(WIDTH, HEIGHT-64);
        myTableView.frame=FRAME(0, layoutView.frame.size.height+70, WIDTH, HEIGHT-70-layoutView.frame.size.height);
    }else{
        myScrollView.contentSize=CGSizeMake(WIDTH, HEIGHT-64);
        myTableView.frame=FRAME(0, layoutView.frame.size.height+70, WIDTH, HEIGHT-70-layoutView.frame.size.height);
    }
    
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
        if (array.count<10*page) {
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
    //    [myTableView reloadData];
    
}
-(void)PLLBbDownFail:(id)sender
{
    
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
