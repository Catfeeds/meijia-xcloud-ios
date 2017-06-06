//
//  DetailsViewController.m
//  simi
//
//  Created by 白玉林 on 15/8/5.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "DetailsViewController.h"
#import "DownloadManager.h"
#import "ISLoginManager.h"
#import "DetailsTableViewCell.h"
#import "WXApi.h"

#import "BookingViewController.h"
#import "MeetingViewController.h"
#import "AppDelegate.h"
#import "FXBlurView.h"
#import "RootViewController.h"

int height,Y,processID=0;
@interface DetailsViewController ()
{
    UITableView *_tableView;
    UIView *liNeView;
    UITextView *textView;
    UIView *underView;
    NSDictionary *_dict;
    
    DownloadManager *_pllb;
    NSDictionary *dic;
    NSMutableArray *plArray;
    NSString *plString;
    //点赞个数label
    UILabel *zambiaLabel;
    UIButton *zambiaButton;
    int cellNum;
    NSString *personnel;
    
    NSString *zambiaString;
    
    int seekID;
    int frame;
    int seekButID;
    UIButton *seekButton;
    UILabel *texLabel;
    
    UIButton *processButton;
    UIScrollView *processView;
    UIButton *commentButton;
    UIView *selfView;
    
    UIButton *modifyButton;
    
    UILabel *processLabel;
    UILabel *modifyLabel;
    
    UILabel *textViewLabel;
    UILabel *alertLabel;
    
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    NSInteger   page;
    
}
@end

@implementation DetailsViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_needRefresh) {
        [_refreshHeader beginRefreshing];
        _needRefresh = NO;
    }
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *card_Id=[NSString stringWithFormat:@"%d",_card_ID];
    NSLog(@"ID%@  %d",card_Id, _card_ID);
    _dict = @{@"card_id":card_Id,@"user_id":_manager.telephone};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CARD_DETAILS dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
    
    [self userInfo];
    [self selfViewLayout];
   // NSDictionary *processDic=
    
}
-(void)userInfo
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *dict = @{@"user_id":_manager.telephone};
    NSLog(@"字典数据%@",dict);
    [_download requestWithUrl:USER_INFO dict:dict view:self.view delegate:self finishedSEL:@selector(msgm:) isPost:NO failedSEL:@selector(Downmsgm:)];
}
#pragma mark 刷新
-(void)refresh
{
    [_refreshHeader beginRefreshing];
}
-(void)msgm:(id)sender
{
    NSLog(@"用户数据:%@",sender);
    NSDictionary *diction=[sender objectForKey:@"data"];
    seekID=[[diction objectForKey:@"user_type"]intValue];
}

-(void)Downmsgm:(id)sender
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    seekButID=0;
    page=1;
    plArray=[[NSMutableArray alloc]init];
    self.view.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGesture.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:tapGesture];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    self.view.backgroundColor=[UIColor whiteColor];
    self.lineLable.hidden=YES;
    //修改按钮
    processButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-50, 25, 40, 30)];
    //[processButton setTitle:@"修改" forState:UIControlStateNormal];
    processButton.layer.cornerRadius=4;
    [self.view addSubview:processButton];
    processLabel=[[UILabel alloc]initWithFrame:FRAME(0, 0, 40, 30)];
    processLabel.text=@"修改";
    processLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    processLabel.textAlignment=NSTextAlignmentCenter;
    [processButton addSubview:processLabel];
    //取消按钮
    modifyButton=[[UIButton alloc]initWithFrame:FRAME(processButton.frame.origin.x-50, 25, 40, 30)];
    //[modifyButton setTitle:@"取消" forState:UIControlStateNormal];
    modifyButton.layer.cornerRadius=4;
    [self.view addSubview:modifyButton];
    
    modifyLabel=[[UILabel alloc]initWithFrame:FRAME(0, 0, 40, 30)];
    modifyLabel.text=@"取消";
    modifyLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    modifyLabel.textAlignment=NSTextAlignmentCenter;
    [modifyButton addSubview:modifyLabel];
    //self.view.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    
    [self selfViewLayout];
    [self tableViewLayout];
    
    // Do any additional setup after loading the view.
}
-(void)selfViewLayout
{
    [selfView removeFromSuperview];
    selfView=[[UIView alloc]init];
    selfView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:selfView];
}
//取消按钮点击方法
-(void)modifAction:(UIButton *)sender
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *card_Id=[NSString stringWithFormat:@"%d",_card_ID];
    NSLog(@"ID%@  %d",card_Id, _card_ID);
    _dict = @{@"user_id":_manager.telephone,@"card_id":card_Id,@"status":@"0"};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CARD_QXJK dict:_dict view:self.view delegate:self finishedSEL:@selector(QXFinish:) isPost:YES failedSEL:@selector(QXDownFail:)];
}
//修改按钮点击方法
-(void)processAction:(UIButton *)sender
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
- (void)backAction
{
    if (_S==1000) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[RootViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }else{
        _backBtn.enabled = NO;
        [self.navigationController popViewControllerAnimated:YES];
        _backBtn.enabled = YES;
    }
    
}
//取消成功方法
-(void)QXFinish:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//取消失败方法
-(void)QXDownFail:(id)sender
{
    
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

-(void)logDowLoadFinish:(id)sender
{
    dic=[sender objectForKey:@"data"];
    NSLog(@"登录后信息：%@",sender);
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *processDic = @{@"user_id":_manager.telephone};
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",USER_INFO] dict:processDic view:self.view delegate:self finishedSEL:@selector(DownloadFinish1:) isPost:NO failedSEL:@selector(FailDownload:)];
   
    [self selfViewLayout];
    [self textLabelLayout];
    [self viewLayout];
    [self zamLayout];
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
    
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSString *user_id=_manager.telephone;
    NSString *create_user_id=[dic objectForKey:@"create_user_id"];
    NSLog(@"自己 %@创建者%@",user_id,create_user_id);
    if(create_user_id==user_id){
        int statusID=[[dic objectForKey:@"status"]intValue];
        if (statusID==1||statusID==2) {
            processButton.enabled=TRUE;
            processLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
            
            modifyButton.enabled=TRUE;
            modifyLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
        }else{
            processButton.enabled=FALSE;
            processLabel.textColor=[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
            
            modifyButton.enabled=FALSE;
            modifyLabel.textColor=[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
        }

        
        
    }else{
        processButton.enabled=FALSE;
        processLabel.textColor=[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
        
        modifyButton.enabled=FALSE;
        modifyLabel.textColor=[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
    }
    [processButton addTarget:self action:@selector(processAction:) forControlEvents:UIControlEventTouchUpInside];
    [modifyButton addTarget:self action:@selector(modifAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navlabel.text=[dic objectForKey:@"card_type_name"];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 6)];
    view.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    [selfView addSubview:view];
    NSArray *headImageArray=@[@"HYXQ_HEAD",@"MSJZ_HEAD",@"SWTX_HEAD",@"YYTZ_HEAD",@"CLGH_HEAD"];
    NSArray *headImgArray=@[@"HY",@"JZ",@"SW",@"YYTZ",@"CL"];
    
    UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(35/2, 6+25/2, 30, 30)];
    NSString *card=[NSString stringWithFormat:@"%@",[dic objectForKey:@"card_type"]];
    int card_type=[card intValue];
    if (card_type==1) {
        headImage.image=[UIImage imageNamed:headImgArray[card_type-1]];
    }else if (card_type==2){
         headImage.image=[UIImage imageNamed:headImgArray[card_type-1]];
    }else if (card_type==3){
         headImage.image=[UIImage imageNamed:headImgArray[card_type-1]];
    }else if (card_type==4){
         headImage.image=[UIImage imageNamed:headImgArray[card_type-1]];
    }else if (card_type==5){
        headImage.image=[UIImage imageNamed:headImgArray[card_type-1]];
    }
    
    if (card_type!=5) {
        NSArray *nameArray=[dic objectForKey:@"attends"];
        NSMutableArray *nameArr=[[NSMutableArray alloc]init];
        for (int i=0; i<nameArray.count; i++) {
            NSString *nameString=[NSString stringWithFormat:@"%@",[nameArray[i] objectForKey:@"name"]];
            [nameArr addObject:nameString];
        }
       personnel =[nameArr componentsJoinedByString:@","];
    }
    headImage.layer.cornerRadius=headImage.frame.size.width/2;
    [selfView addSubview:headImage];
    
    UILabel *timeLabel=[[UILabel alloc]init];
    timeLabel.frame=CGRectMake(headImage.frame.origin.x+headImage.frame.size.width+10, 6+25/2+15/2, timeLabel.frame.size.width, 15);
    double inTime=[[dic objectForKey:@"service_time"] doubleValue];
    NSDateFormatter* inTimeformatter =[[NSDateFormatter alloc] init];
    inTimeformatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [inTimeformatter setDateStyle:NSDateFormatterMediumStyle];
    [inTimeformatter setTimeStyle:NSDateFormatterShortStyle];
    [inTimeformatter setDateFormat:@"HH:mm"];
    NSDate* inTimedate = [NSDate dateWithTimeIntervalSince1970:inTime];
    NSString* inTimeString = [inTimeformatter stringFromDate:inTimedate];
    
    timeLabel.text=inTimeString;
    timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    timeLabel.lineBreakMode =NSLineBreakByTruncatingTail ;
    [timeLabel setNumberOfLines:0];
    [timeLabel sizeToFit];
    [selfView addSubview:timeLabel];
    
    NSString *textStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
    int clID=[textStr intValue];
    texLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self textLabelLayout];
    [selfView addSubview:texLabel];
    
    
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(texLabel.frame.size.width, 0, 10, texLabel.frame.size.height)];
    image.image=[UIImage imageNamed:@"SYCELL_YHB_@2x"];
    
    [texLabel addSubview:image];
    UIImageView *image2=[[UIImageView alloc]initWithFrame:CGRectMake(-20, 0, texLabel.frame.size.width+20,texLabel.frame.size.height)];
    image2.image=[UIImage imageNamed:@"SYCELL_YHBY_@2x"];
    [texLabel addSubview:image2];
    
    
    
    UIImageView *weatherImage=[[UIImageView alloc]initWithFrame:CGRectMake(19, texLabel.frame.origin.y+texLabel.frame.size.height+29/2,100, 100)];
       //weatherImage.backgroundColor=[UIColor yellowColor];
    [selfView addSubview:weatherImage];
    
    UIView *line=[[UIView alloc]initWithFrame:FRAME(0, weatherImage.frame.origin.y-5, WIDTH, 1)];
    line.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    [selfView addSubview:line];
    
    UILabel *addressLabel=[[UILabel alloc]init];
    NSString *cityDicjson=[NSString stringWithFormat:@"%@",[dic objectForKey:@"card_extra"]];
    NSData *jsonData = [cityDicjson dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *cityDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    NSString *fromCityString=[cityDic objectForKey:@"ticket_from_city_name"];
    NSString *toCityString=[cityDic objectForKey:@"ticket_to_city_name"];
    NSString *textString=[NSString stringWithFormat:@"从 %@ 到 %@",fromCityString,toCityString];
    [selfView addSubview:addressLabel];
    
//    double inTime1=[[dic objectForKey:@"service_time"] doubleValue];
    NSDateFormatter* inTimeformatter1 =[[NSDateFormatter alloc] init];
    inTimeformatter1.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [inTimeformatter1 setDateStyle:NSDateFormatterMediumStyle];
    [inTimeformatter1 setTimeStyle:NSDateFormatterShortStyle];
    [inTimeformatter1 setDateFormat:@"时间：YYYY年MM月dd日 HH:mm:ss"];
    NSDate* inTimedate1 = [NSDate dateWithTimeIntervalSince1970:inTime];
    NSString* inTimeString1 = [inTimeformatter1 stringFromDate:inTimedate1];
    UILabel *shijianLabel=[[UILabel alloc]init];
    [selfView addSubview:shijianLabel];
    
    UILabel *cityLabel=[[UILabel alloc]init];
    cityLabel.hidden=YES;
    [selfView addSubview:cityLabel];
    
    UILabel *promptLabel=[[UILabel alloc]init];
    promptLabel.frame=CGRectMake(38/2, weatherImage.frame.origin.y+weatherImage.frame.size.height+21/2, WIDTH-38, 14);
    promptLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_content"]];
    promptLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
    promptLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [promptLabel setNumberOfLines:0];
    [promptLabel sizeToFit];
    promptLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    [selfView addSubview:promptLabel];
    
    
    
    UILabel *inTimeLabel=[[UILabel alloc]init];
    inTimeLabel.frame=CGRectMake(38/2, promptLabel.frame.origin.y+promptLabel.frame.size.height+5, inTimeLabel.frame.size.width, 10);
    inTimeLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"add_time_str"]];
    inTimeLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [inTimeLabel setNumberOfLines:0];
    [inTimeLabel sizeToFit];
    inTimeLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
    inTimeLabel.font=[UIFont fontWithName:@"Heiti SC" size:10];
    [selfView addSubview:inTimeLabel];
    
    if (card_type==1)
    {
        cityLabel.hidden=NO;
        NSString *cityString=[NSString stringWithFormat:@"提醒人:%@",personnel];
        
        weatherImage.image=[UIImage imageNamed:headImageArray[card_type-1]];
        
        addressLabel.text=inTimeString1;
        addressLabel.font=[UIFont fontWithName:@"Heiti SC" size:11];
        addressLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        [addressLabel setNumberOfLines:0];
        [addressLabel sizeToFit];
        addressLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        addressLabel.frame=CGRectMake(weatherImage.frame.origin.x+weatherImage.frame.size.width+10, weatherImage.frame.origin.y+10, WIDTH-(weatherImage.frame.origin.x+weatherImage.frame.size.width+20), 12);
        
        shijianLabel.text=[NSString stringWithFormat:@"会议地点:%@",[dic objectForKey:@"service_addr"]];
//        shijianLabel.backgroundColor=[UIColor redColor];
        shijianLabel.font=[UIFont fontWithName:@"Heiti SC" size:11];
        [shijianLabel setNumberOfLines:0];
        [shijianLabel sizeToFit];
        shijianLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        shijianLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        shijianLabel.frame=FRAME(addressLabel.frame.origin.x, addressLabel.frame.origin.y+addressLabel.frame.size.height+10, addressLabel.frame.size.width, 13);
        
        cityLabel.text=cityString;
        UIFont *font = [UIFont fontWithName:@"Heiti SC" size:11];
        cityLabel.font=font;
        [cityLabel setNumberOfLines:0];
        [cityLabel sizeToFit];
        cityLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        CGSize constraint = CGSizeMake(WIDTH-addressLabel.frame.origin.x-20, 200.0f);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        CGSize size = [cityString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        cityLabel.lineBreakMode=NSLineBreakByWordWrapping;
        cityLabel.frame=FRAME(addressLabel.frame.origin.x, shijianLabel.frame.origin.y+shijianLabel.frame.size.height+10, WIDTH-addressLabel.frame.origin.x-20, size.height);
        
    }else if (card_type==2)
    {
        cityLabel.hidden=YES;
        NSString *cityString=[NSString stringWithFormat:@"提醒人:%@",personnel];
        weatherImage.image=[UIImage imageNamed:headImageArray[card_type-1]];
        
        addressLabel.text=inTimeString1;
        addressLabel.font=[UIFont fontWithName:@"Heiti SC" size:11];
        addressLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        [addressLabel setNumberOfLines:0];
        [addressLabel sizeToFit];
        addressLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        addressLabel.frame=CGRectMake(weatherImage.frame.origin.x+weatherImage.frame.size.width+10, weatherImage.frame.origin.y+10, WIDTH-(weatherImage.frame.origin.x+weatherImage.frame.size.width+20), 12);
        
        shijianLabel.text=cityString;
//        shijianLabel.backgroundColor=[UIColor redColor];
        shijianLabel.font=[UIFont fontWithName:@"Heiti SC" size:11];
        [shijianLabel setNumberOfLines:0];
        [shijianLabel sizeToFit];
        shijianLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        shijianLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        shijianLabel.frame=FRAME(addressLabel.frame.origin.x, addressLabel.frame.origin.y+addressLabel.frame.size.height+10, addressLabel.frame.size.width, 13);
        
        
        
    }else if (card_type==3)
    {
        
        cityLabel.hidden=YES;
        NSString *cityString=[NSString stringWithFormat:@"提醒人:%@",personnel];
        weatherImage.image=[UIImage imageNamed:headImageArray[card_type-1]];
        
        addressLabel.text=inTimeString1;
        addressLabel.font=[UIFont fontWithName:@"Heiti SC" size:11];
        addressLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        [addressLabel setNumberOfLines:0];
        [addressLabel sizeToFit];
        addressLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        addressLabel.frame=CGRectMake(weatherImage.frame.origin.x+weatherImage.frame.size.width+10, weatherImage.frame.origin.y+10, WIDTH-(weatherImage.frame.origin.x+weatherImage.frame.size.width+20), 12);
        
        shijianLabel.text=cityString;
//        shijianLabel.backgroundColor=[UIColor redColor];
        shijianLabel.font=[UIFont fontWithName:@"Heiti SC" size:11];
        [shijianLabel setNumberOfLines:0];
        [shijianLabel sizeToFit];
        shijianLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        shijianLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        shijianLabel.frame=FRAME(addressLabel.frame.origin.x, addressLabel.frame.origin.y+addressLabel.frame.size.height+10, addressLabel.frame.size.width, 13);
        
        
        
    }else if (card_type==4)
    {
        cityLabel.hidden=YES;
        NSString *cityString=[NSString stringWithFormat:@"邀约人:%@",personnel];
        weatherImage.image=[UIImage imageNamed:headImageArray[card_type-1]];
        
        addressLabel.text=inTimeString1;
        addressLabel.font=[UIFont fontWithName:@"Heiti SC" size:11];
        addressLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        [addressLabel setNumberOfLines:0];
        [addressLabel sizeToFit];
        addressLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        addressLabel.frame=CGRectMake(weatherImage.frame.origin.x+weatherImage.frame.size.width+10, weatherImage.frame.origin.y+10, WIDTH-(weatherImage.frame.origin.x+weatherImage.frame.size.width+20), 12);
        
        shijianLabel.text=cityString;
//        shijianLabel.backgroundColor=[UIColor redColor];
        shijianLabel.font=[UIFont fontWithName:@"Heiti SC" size:11];
        [shijianLabel setNumberOfLines:0];
        [shijianLabel sizeToFit];
        shijianLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        shijianLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        shijianLabel.frame=FRAME(addressLabel.frame.origin.x, addressLabel.frame.origin.y+addressLabel.frame.size.height+10, addressLabel.frame.size.width, 13);
        
    }else if (card_type==5)
    {
        cityLabel.hidden=NO;
        weatherImage.image=[UIImage imageNamed:headImageArray[card_type-1]];
        
        addressLabel.text=textString;
        addressLabel.font=[UIFont fontWithName:@"Heiti SC" size:11];
        addressLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        [addressLabel setNumberOfLines:0];
        [addressLabel sizeToFit];
        addressLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        addressLabel.frame=CGRectMake(weatherImage.frame.origin.x+weatherImage.frame.size.width+10, weatherImage.frame.origin.y+10, WIDTH-(weatherImage.frame.origin.x+weatherImage.frame.size.width+20), 12);
        
        shijianLabel.text=inTimeString1;
        //shijianLabel.backgroundColor=[UIColor redColor];
        shijianLabel.font=[UIFont fontWithName:@"Heiti SC" size:11];
        [shijianLabel setNumberOfLines:0];
        [shijianLabel sizeToFit];
        shijianLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        shijianLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        shijianLabel.frame=FRAME(addressLabel.frame.origin.x, addressLabel.frame.origin.y+addressLabel.frame.size.height+10, addressLabel.frame.size.width, 13);
        
        cityLabel.text=@"航班:";
        cityLabel.font=[UIFont fontWithName:@"Heiti SC" size:11];
        [cityLabel setNumberOfLines:0];
        [cityLabel sizeToFit];
        cityLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        cityLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cityLabel.frame=FRAME(addressLabel.frame.origin.x, shijianLabel.frame.origin.y+shijianLabel.frame.size.height+10, addressLabel.frame.size.width, 13);
        
    }

    
    UIView *lineView=[[UIView alloc]init];
    lineView.frame=CGRectMake(0, inTimeLabel.frame.origin.y+inTimeLabel.frame.size.height+10, WIDTH, 1);
    lineView.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    [selfView addSubview:lineView];
    
    zambiaButton=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH-114, lineView.frame.origin.y-35, 30, 30)];
    //[zambiaButton setImage:[UIImage imageNamed:@"common_icon_like_c@2x(1)"] forState:UIControlStateNormal];
    UIImageView *imagView=[[UIImageView alloc]initWithFrame:FRAME(5, 5, 20, 20)];
    imagView.image=[UIImage imageNamed:@"common_icon_like_c@2x(1)"];
    [zambiaButton addSubview:imagView];
    [zambiaButton addTarget:self action:@selector(zmaAction:) forControlEvents:UIControlEventTouchUpInside];
    //zambiaButton.backgroundColor=[UIColor redColor];
    [selfView addSubview:zambiaButton];
    
//    zambiaLabel=[[UILabel alloc]init];
//    [selfView addSubview:zambiaLabel];
    [self zamLayout];
    
    
    
    UIButton *shareButton=[[UIButton alloc]init];
    shareButton.frame=CGRectMake(WIDTH-40, lineView.frame.origin.y-35, 30, 30);
//    [shareButton setImage:[UIImage imageNamed:@"common_icon_share@2x(1)"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(fxButtonan:) forControlEvents:UIControlEventTouchUpInside];
    [selfView addSubview:shareButton];
    UIImageView *imaView=[[UIImageView alloc]initWithFrame:FRAME(5, 5, 20, 20)];
    imaView.image=[UIImage imageNamed:@"common_icon_share@2x(1)"];
    [shareButton addSubview:imaView];
    UIView *seekView=[[UIView alloc]init];
    [selfView addSubview:seekView];
#pragma mark 秘书 
    if (seekID==1) {
        //processButton.hidden=YES;
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
        seekView.frame=FRAME(0, lineView.frame.origin.y+1, WIDTH, linView.frame.origin.y+1);
        ISLoginManager *_manager = [ISLoginManager shareManager];
        NSString *user_id=_manager.telephone;
        NSString *create_user_id=[dic objectForKey:@"create_user_id"];
        if(user_id==create_user_id)
        {
            frame=lineView.frame.origin.y;
            seekView.hidden=YES;
        }else{
            frame=seekView.frame.origin.y+seekView.frame.size.height;
            seekView.hidden=NO;
        }
        
    }else{
        frame=lineView.frame.origin.y;
        processButton.hidden=NO;
    }
    
    
    UILabel *iamgeView=[[UILabel alloc]initWithFrame:FRAME(8, frame+15, 30, 20)];
    iamgeView.text=@"点赞";
    iamgeView.font=[UIFont fontWithName:@"Heiti SC" size:14];
    iamgeView.textColor=[UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1];
    //iamgeView.image=[UIImage imageNamed:@"common_icon_like_c@2x(1)"];
    [selfView addSubview:iamgeView];
    
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
        
        [selfView addSubview:headeView];
        if (i==num-1) {
            UILabel *label=[[UILabel alloc]init];
            label.text=[NSString stringWithFormat:@"共%lu人",(unsigned long)headArray.count];
            label.lineBreakMode=NSLineBreakByTruncatingTail;
            [label setNumberOfLines:1];
            [label sizeToFit];
            label.font=[UIFont fontWithName:@"Heiti SC" size:10];
            label.textColor=[UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1];
            label.frame=FRAME(headeView.frame.size.width+headeView.frame.origin.x+5, headeView.frame.origin.y+5, label.frame.size.width, 20);
            [selfView addSubview:label];
        }
        //headeView.layer.cornerRadius=headeView.frame.size.width/2;
    }
    
    
    liNeView=[[UIView alloc]init];
    liNeView.frame=CGRectMake(0, frame+49, WIDTH, 1);
    liNeView.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    [selfView addSubview:liNeView];
    selfView.frame=FRAME(0, 64, WIDTH, liNeView.frame.origin.y+1);
    [self commwntLayout];
    [self PLJKLayout];
}
#pragma mark处理状态文本显示
-(void)textLabelLayout
{
    NSString *textStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
    int clID=[textStr intValue];
    if (clID==1) {
        texLabel.text=@"处理中";
        texLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
        
    }else if (clID==2){
        texLabel.text=@"秘书处理中";
        texLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    }else if(clID==3){
        texLabel.text=@"已完成";
        texLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    }else if (clID==0){
        texLabel.text=@"已取消";
        texLabel.textColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    }
    //    textLabel.text=cell.promptlabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    
    texLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    [texLabel setNumberOfLines:0];
    [texLabel sizeToFit];
    texLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    texLabel.frame=CGRectMake(WIDTH-texLabel.frame.size.width-5/2-15, 7+25/2, texLabel.frame.size.width, 56/2);
}
#pragma mark秘书处理按钮点击方法－－－－－－－－－－－－
-(void)seekButAction:(UIButton *)sender
{
    NSString *cardString;
    if (seekButID==0) {
        cardString=@"2";
        [seekButton setTitle:@"完成" forState:UIControlStateNormal];
        seekButton.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    }else if (seekButID==1){
        cardString=@"3";
        [seekButton setTitle:@"已完成" forState:UIControlStateNormal];
        seekButton.enabled = FALSE;
        seekButton.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    }
    seekButID+=1;
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *cardIDString=[dic objectForKey:@"card_id"];
    NSDictionary *dict = @{@"card_id":cardIDString,@"sec_id":_manager.telephone,@"status":cardString};
    NSLog(@"字典数据%@",dict);
    [_download requestWithUrl:SEEK_CLJK dict:dict view:self.view delegate:self finishedSEL:@selector(seekHandleFinish:) isPost:YES failedSEL:@selector(seekHandleDownFail:)];
}
#pragma mark传递数据成功返回信息
-(void)seekHandleFinish:(id)sender
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *card_Id=[NSString stringWithFormat:@"%d",_card_ID];
    NSLog(@"ID%@  %d",card_Id, _card_ID);
    _dict = @{@"card_id":card_Id,@"user_id":_manager.telephone};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CARD_DETAILS dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
    NSLog(@"成功!");
}
#pragma mark传递数据失败返回信息
-(void)seekHandleDownFail:(id)sender
{
    NSLog(@"失败!%@",sender);
}
-(void)fxButtonan:(UIButton *)sender
{
    [UMSocialWechatHandler setWXAppId:@"wx93aa45d30bf6cba3" appSecret:@"7a4ec42a0c548c6e39ce9ed25cbc6bd7" url:Handlers];
    [UMSocialQQHandler setQQWithAppId:@"1104934408" appKey:@"bRW2glhUCR6aJYIZ" url:QQHandlerss];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"247547429" RedirectURL:SSOHandlers];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:YMAPPKEY shareText:@"菠萝HR，人事行政必备神器！我们专注“人事行政”的成长与服务！快来体验吧：http://bolohr.com/web" shareImage:[UIImage imageNamed:@"bolohr-logo512.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina,nil] delegate:self];
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
    _dict = @{@"card_id":card_Id,@"user_id":_manager.telephone};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CARD_DZ dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadDA:) isPost:YES failedSEL:@selector(DZDownFail:)];
}
-(void)logDowLoadDA:(id)sender
{
    NSLog(@"点赞成功");
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *card_Id=[NSString stringWithFormat:@"%d",_card_ID];
    NSLog(@"ID%@  %d",card_Id, _card_ID);
    _dict = @{@"card_id":card_Id,@"user_id":_manager.telephone};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CARD_DETAILS dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
    
}
-(void)DZDownFail:(id)sender
{
     NSLog(@"点赞失败");
}
-(void)zamLayout
{
    [zambiaLabel removeFromSuperview];
    
    zambiaString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"total_zan"]];
    //j
    zambiaLabel=[[UILabel alloc]init];
    
    zambiaLabel.text=zambiaString;
    zambiaLabel.font=[UIFont fontWithName:@"Heiti SC" size:10];
    [zambiaLabel setNumberOfLines:1];
    [zambiaLabel sizeToFit];
    zambiaLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    zambiaLabel.textColor=[UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1];
    zambiaLabel.frame=FRAME(zambiaButton.frame.origin.x+zambiaButton.frame.size.width+5, zambiaButton.frame.origin.y+4, WIDTH-(zambiaButton.frame.origin.x+zambiaButton.frame.size.width+5)-41, 22);
    [selfView addSubview:zambiaLabel];
    
}
-(void)PLJKLayout
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    
    NSString *card_Id=[NSString stringWithFormat:@"%d",_card_ID];
    NSLog(@"ID%@  %d",card_Id, _card_ID);
    NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
    DownloadManager *_download = [[DownloadManager alloc]init];
    _dict = @{@"card_id":card_Id,@"user_id":_manager.telephone,@"page":pageStr};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CARD_PLLB dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadPLLB:) isPost:NO failedSEL:@selector(PLLBbDownFail:)];
}
-(void)logDowLoadPLLB:(id)sender
{
    NSLog(@"返回数据 %@",sender);
    plString=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    
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
    _tableView.frame=CGRectMake(0, liNeView.frame.origin.y+66, WIDTH, HEIGHT-liNeView.frame.origin.y-116);
    [_tableView reloadData];
    
}
-(void)PLLBbDownFail:(id)sender
{
    
}

-(void)tableViewLayout
{
    NSLog(@"能不能成功");
    [_tableView removeFromSuperview];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, liNeView.frame.origin.y+66, WIDTH, HEIGHT-liNeView.frame.origin.y-116)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //tableView.backgroundColor=[UIColor yellowColor];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    _refreshHeader = [[MJRefreshHeaderView alloc] init];
    _refreshHeader.delegate = self;
    _refreshHeader.scrollView = _tableView;
    
    _moreFooter = [[MJRefreshFooterView alloc] init];
    _moreFooter.delegate = self;
    _moreFooter.scrollView = _tableView;
    
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
        _dict = @{@"card_id":card_Id,@"user_id":_manager.telephone,@"comment":textView.text};
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
    height = keyboardRect.size.height;
    underView.frame=CGRectMake(0, HEIGHT-height-49, WIDTH, 49);
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

//    [cell.layer setMasksToBounds:YES];
//    cell.layer.cornerRadius=10;
//    cell.layer.borderColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1].CGColor;
//    cell.layer.borderWidth=1;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
