//
//  BookingViewController.m
//  simi
//
//  Created by 白玉林 on 15/8/6.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "BookingViewController.h"
#import "DatePicker.h"
#import "TixingTimePicker.h"
#import "DCRoundSwitch.h"
#import "SwickControl.h"

#import "TimePicker.h"
#import "CityViewController.h"
#import "ISLoginManager.h"
#import "DownloadManager.h"
#import "ConTentViewController.h"
#import "ClerkViewController.h"
#import "FXBlurView.h"

#import "SetRemindViewController.h"
#import "UILocalNotification+ASK.h"

#import "CustomerViewController.h"

#import "RelevantPersonnelViewController.h"
int y,x=0,time_ID;

@interface BookingViewController ()<datePicDelegate,TixingTimePic,timePickerDelegate>
{
    UIButton *startingButton;
    UIButton *arriveButton;
    UIButton *dateButton;
    UIButton *timeButton;
    
    UILabel *startingLabel;
    UILabel *arriveLabel;
    UILabel *dateLabelView;
    UILabel *timeViewLabel;
    UILabel *remindLabel;
    UILabel *contentLabel;
    
    FXBlurView *maskView;
    
    UIImageView *startingImage;
    UIImageView *arriveImage;
    UIImageView *msImageView;
    UIView *msView;
    
    TimePicker *picker;
    DatePicker *datePicker;
    TixingTimePicker *timePicker;
    UIView *headeView;
    NSString *dateString;
    NSString *timeString;
    NSString *startingStr;
    NSString *arriveStr;
    NSString *remindString;
    NSString *contentString;
    
    NSString *periodString;
    //出发与到达城市名称Label
    UILabel *setoutLabel;
    UILabel *destinationLabel;
    
    
    SwickControl *switchButton;
    SwickControl *switchBut;
    
    UIImage *startingImages;
    UIImage *arriveImages;
    UIImage *msImages;
    
    
    CityViewController *vc;
    ConTentViewController *viewController;
    NSInteger ctID;
    
    int card_type_ID;
    int set_now_send_ID;
    int mscl_int;
    
    int switchBT;
    int periodID;
    NSNumber *from_ID;
    NSNumber *to_ID;
    
    NSString *clientString;
    UIButton *clientButton;
    
    int clientId;
    
    
    int clientID;
    CustomerViewController *customerVC;
    UILabel *whoLabel;
    NSInteger _index;
    NSString *nameString;
    int viewID;
    UIView *tabBarView;
    
    int switchButID;
    
    UIView *personnelView;
    
    RelevantPersonnelViewController *viewVC;
    
    UILabel *nameLabel;
    UILabel *numberLabel;
    NSString *peronnelName;
    NSString *numberString;
    NSArray *nameArray;
    NSArray *mobilArray;
    NSArray *mutableArray;
    NSArray *idArray;
    NSString *string;
    
    NSDictionary *zjDic;
    int releID;
   
}
@end

@implementation BookingViewController
@synthesize setoutString,destinationString,fromID,toID;
-(void)viewWillAppear:(BOOL)animated
{
    if (releID==100) {
        peronnelName=viewVC.selectString;
        numberString=viewVC.numberString;
        nameArray=viewVC.nameArray;
        mobilArray=viewVC.mobileArray;
        mutableArray=viewVC.mutableArray;
        idArray=viewVC.idArray;
    }
    
    [self personnelLayout];
    maskView.hidden=YES;
    if (viewController.textString==NULL||viewController.textString==nil) {
    }else
    {
        contentString=viewController.textString;
    }
    
    NSLog(@"%@",contentString);
    [self contentLayout];
    
    

    if (ctID==20001) {
        if(vc.setout==nil||vc.setout==NULL)
        {

        }else{
            setoutString=vc.setout;
            from_ID=vc.fromCityID;
        }
        
        
    }else if (ctID==20002)
    {
        if(vc.destination==nil||vc.destination==NULL)
        {

        }else{
            to_ID=vc.toCityId;
            destinationString=vc.destination;
        }

        
    }
    
    fromID=from_ID;
    toID=to_ID;
    NSLog(@"%@,%@",fromID,toID);
    [self uibuttonLayout];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSLog(@"有值么%@",_manager.telephone);
    DownloadManager *_download = [[DownloadManager alloc]init];
    
    NSDictionary *_dict = @{@"user_id":_manager.telephone};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:USER_INFO dict:_dict view:self.view delegate:self finishedSEL:@selector(msgm:) isPost:NO failedSEL:@selector(Downmsgm:)];
    if (customerVC.clientString==nil||customerVC.clientString==NULL) {

    }else {
        clientString=customerVC.clientString;
        _index=customerVC.cellIndex;
        nameString=customerVC.nameString;
    }
    
}
-(void)msgm:(id)sender
{
    NSLog(@"用户数据:%@",sender);
    NSDictionary *diction=[sender objectForKey:@"data"];
    periodString=[NSString stringWithFormat:@"%@",[diction objectForKey:@"is_senior"]];
    periodID=[periodString intValue];
    clientID=[[diction objectForKey:@"user_type"]intValue];
    
    if (clientID==1) {
        clientButton.hidden=NO;
        
    }else{
        clientButton.hidden=YES;
    }
  
    if (viewID==1) {
        [self viewLayout];
        [self LabelLayout];
        [self clientButtonLayout];
    }
    
    viewID=0;
    
}
-(void)Downmsgm:(id)sender
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.img.hidden=YES;
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 20, 20)];
    img.image = [UIImage imageNamed:@"iconfont-p-back"];
    [_backBtn addSubview:img];
    self.backlable.backgroundColor=HEX_TO_UICOLOR(0x56abe4, 1.0);
    _navlabel.textColor = [UIColor whiteColor];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *mobli=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"mobile"]];
    zjDic=@{@"name":@"自己",@"mobil":mobli,@"user_id":_manager.telephone};
    idArray=@[[zjDic objectForKey:@"user_id"]];
    mobilArray =@[[zjDic objectForKey:@"mobil"]];
    nameArray =@[[zjDic objectForKey:@"name"]];
    mutableArray=@[[zjDic objectForKey:@"mobil"]];
    peronnelName =[nameArray componentsJoinedByString:@","];
    numberString=[NSString stringWithFormat:@"共%lu人",(unsigned long)nameArray.count];
    
    
    viewID=1;
    _index=-1;
    switchBT=1;
    _cardsID=1;
    clientId=0;
    card_type_ID=5;
    self.navlabel.text=_titleName;
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    startingStr=@"出发城市";
    arriveStr=@"到达城市";
    remindString=@"按时提醒";
    msImages=[UIImage imageNamed:@"chuli"];
    startingImages=[UIImage imageNamed:@"CLGH_CFCS_TB_@2x"];
    arriveImages=[UIImage imageNamed:@"CLGH_FHCS_TB@2x"];
    if (_pushID==1) {
        ISLoginManager *_manager = [ISLoginManager shareManager];
        NSLog(@"有值么%@",_manager.telephone);
        DownloadManager *_download = [[DownloadManager alloc]init];
        
        NSDictionary *_dict = @{@"card_id":_cardString,@"user_id":_manager.telephone};
        NSLog(@"字典数据%@",_dict);
        [_download requestWithUrl:CARD_DETAILS dict:_dict view:self.view delegate:self finishedSEL:@selector(KPgm:) isPost:NO failedSEL:@selector(KPDownmsgm:)];

    }

}
-(void)KPgm:(id)sender
{
    NSLog(@"sender%@",sender);
    NSDictionary *dic=[sender objectForKey:@"data"];
    from_ID=[dic objectForKey:@"ticket_from_city_id"];
    to_ID=[dic objectForKey:@"ticket_to_city_id"];
    string=[dic objectForKey:@"service_time"];
    switchButID=[[dic objectForKey:@"set_sec_do"]intValue];
    setoutString=[dic objectForKey:@"ticket_from_city_name"];
    destinationString=[dic objectForKey:@"ticket_to_city_name"];
    NSString *timeStr=[dic objectForKey:@"service_time"];
    int time=[timeStr intValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    dateString=[currentDateStr substringWithRange:NSMakeRange(0, 10)];
    timeString=[currentDateStr substringFromIndex:12];
    int reminId=[[dic objectForKey:@"set_remind"]intValue];
    if (reminId==0) {
        remindString=@"不提醒";
    }else if (reminId==1){
        remindString=@"按时提醒";
    }else if (reminId==2){
        remindString=@"提前5分钟";
    }else if (reminId==3){
        remindString=@"提前15分钟";
    }else if (reminId==4){
        remindString=@"提前30分钟";
    }else if (reminId==5){
        remindString=@"提前1小时";
    }else if (reminId==6){
        remindString=@"提前2小时";
    }else if (reminId==7){
        remindString=@"提前6小时";
    }else if (reminId==8){
        remindString=@"提前1天";
    }else if (reminId==9){
        remindString=@"提前2天";
    }
    contentString=[dic objectForKey:@"service_content"];
    
    NSString *userStr=[dic objectForKey:@"user_id"];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    if (userStr==_manager.telephone) {
        nameString=@"自己";
    }else{
        nameString=[dic objectForKey:@"name"];
    }
    [self clientButtonLayout];
    [self viewLayout];
    [self LabelLayout];
}
-(void)KPDownmsgm:(id)sender
{
    
}
-(void)clientButtonLayout
{
    [clientButton removeFromSuperview];
    clientButton=[[UIButton alloc]initWithFrame:FRAME(0, 64+13/2, WIDTH, 34)];
    [clientButton addTarget:self action:@selector(clientAction:) forControlEvents:UIControlEventTouchUpInside];
    clientButton.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:clientButton];
    
    UIImageView *clientImage=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-35/2-20, (34-15)/2, 15, 15)];
    clientImage.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
    [clientButton addSubview:clientImage];
    
    UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 33, WIDTH, 1)];
    view.backgroundColor=[UIColor colorWithRed:241.0 / 255.0 green:241.0 / 255.0 blue:241.0 / 255.0 alpha:1];
    [clientButton addSubview:view];
    UILabel *clienLabel=[[UILabel alloc]initWithFrame:FRAME(35/2, 13/2, 60, 20)];
    clienLabel.text=@"给谁创建:";
    clienLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    [clientButton addSubview:clienLabel];
    whoLabel =[[UILabel alloc]init];
    whoLabel.text=nameString;
    whoLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    whoLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [whoLabel setNumberOfLines:1];
    [whoLabel sizeToFit];
    whoLabel.frame=FRAME(45/2+60, 13/2, whoLabel.frame.size.width, 20);
    if (clientID==1) {
        clientButton.hidden=NO;
        
    }else{
        clientButton.hidden=YES;
    }
    [clientButton addSubview:whoLabel];
}
-(void)clientAction:(UIButton *)sender
{
    customerVC=[[CustomerViewController alloc]init];
    customerVC.index=_index;
    [self.navigationController pushViewController:customerVC animated:YES];
}
-(void)viewLayout
{

    [headeView removeFromSuperview];
    
    headeView=[[UIView alloc]initWithFrame:CGRectMake(0, 97, WIDTH, 15/2)];
    headeView.userInteractionEnabled = YES;
    headeView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:headeView];
    
    //提醒人员入口
    personnelView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 40)];
    [headeView addSubview:personnelView];
    UITapGestureRecognizer *personnelTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personnelAction:)];
    [personnelView addGestureRecognizer:personnelTap];
    UILabel *label=[[UILabel alloc]initWithFrame:FRAME(32/2, 6, 70, 15)];
    label.text=@"差旅人员:";
    label.font=[UIFont fontWithName:@"Heiti SC" size:14];
    [personnelView addSubview:label];
    UILabel *personnelLabel=[[UILabel alloc]initWithFrame:FRAME(32/2, 21, 50, 13)];
    personnelLabel.text=@"已选择:";
    personnelLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    [personnelView addSubview:personnelLabel];
    nameLabel=[[UILabel alloc]init];
    numberLabel=[[UILabel alloc]init];
    [self  personnelLayout];
    
    UIImageView *arrowImage=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-35/2-20, 25/2, 15, 15)];
    arrowImage.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
    [personnelView addSubview:arrowImage];
    
    UIView *lineVw=[[UIView alloc]initWithFrame:FRAME(0, 41, WIDTH, 1)];
    lineVw.backgroundColor=[UIColor colorWithRed:241.0 / 255.0 green:241.0 / 255.0 blue:241.0 / 255.0 alpha:1];
    [headeView addSubview:lineVw];
    //出发城市按钮 头像 label 控件初始化
    startingButton=[[UIButton alloc]initWithFrame:CGRectMake(35/2, 22/2+40, WIDTH-173/2, 33)];
    startingButton.tag=20001;
    [startingButton addTarget:self action:@selector(cityAction:) forControlEvents:UIControlEventTouchUpInside];
    [startingButton.layer setMasksToBounds:YES];
    [startingButton.layer setCornerRadius:8.0]; //设置矩圆角半径
    [startingButton.layer setBorderWidth:1.0];//边框宽度
    startingButton.layer.backgroundColor=[[UIColor colorWithRed:241.0 / 255.0 green:241.0 / 255.0 blue:241.0 / 255.0 alpha:1] CGColor];
    startingButton.layer.cornerRadius=8.0f;
    startingButton.layer.masksToBounds=YES;
    startingButton.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    startingButton.layer.borderWidth= 1.0f;
    
    startingImage=[[UIImageView alloc]initWithFrame:CGRectMake(11/2, 15/2, startingButton.frame.size.height-15, startingButton.frame.size.height-15)];
    
    startingLabel=[[UILabel alloc]initWithFrame:CGRectMake(startingImage.frame.origin.x+startingImage.frame.size.width+6, 15/2, startingLabel.frame.size.width, startingButton.frame.size.height-15)];
    UIImageView *starImage=[[UIImageView alloc]initWithFrame:FRAME(startingButton.frame.size.width-20, (33-15)/2, 15, 15)];
    starImage.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
    [startingButton addSubview:starImage];
    //出发城市名称Label
    setoutLabel=[[UILabel alloc]initWithFrame:FRAME(startingLabel.frame.origin.x+startingLabel.frame.size.width, 15/2, startingButton.frame.size.width-15-(startingLabel.frame.origin.x+startingLabel.frame.size.width), startingButton.frame.size.height-15)];
    setoutLabel.textAlignment=NSTextAlignmentCenter;
    setoutLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [startingButton addSubview:setoutLabel];
    
    
    //到达城市安妮 头像 label初始化
    arriveButton=[[UIButton alloc]initWithFrame:CGRectMake(35/2, 55+40, WIDTH-173/2, 33)];
    arriveButton.tag=20002;
    [arriveButton addTarget:self action:@selector(cityAction:) forControlEvents:UIControlEventTouchUpInside];
    [arriveButton.layer setMasksToBounds:YES];
    [arriveButton.layer setCornerRadius:8.0]; //设置矩圆角半径
    [arriveButton.layer setBorderWidth:1.0];//边框宽度
    arriveButton.layer.backgroundColor=[[UIColor colorWithRed:241.0 / 255.0 green:241.0 / 255.0 blue:241.0 / 255.0 alpha:1] CGColor];
    arriveButton.layer.cornerRadius=8.0f;
    arriveButton.layer.masksToBounds=YES;
    arriveButton.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    arriveButton.layer.borderWidth= 1.0f;
    
    arriveImage=[[UIImageView alloc]initWithFrame:CGRectMake(11/2, 15/2, startingButton.frame.size.height-15, startingButton.frame.size.height-15)];
    
    arriveLabel=[[UILabel alloc]initWithFrame:CGRectMake(arriveImage.frame.origin.x+arriveImage.frame.size.width+6, 15/2, arriveLabel.frame.size.width, arriveButton.frame.size.height-15)];
    UIImageView *arrImage=[[UIImageView alloc]initWithFrame:FRAME(arriveButton.frame.size.width-20, (33-15)/2, 15, 15)];
    arrImage.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
    [arriveButton addSubview:arrImage];
    
    
    //到达城市名称Label
    destinationLabel=[[UILabel alloc]initWithFrame:FRAME(arriveLabel.frame.origin.x+arriveLabel.frame.size.width, 15/2, arriveButton.frame.size.width-15-(arriveLabel.frame.origin.x+arriveLabel.frame.size.width), arriveButton.frame.size.height-15)];
    destinationLabel.textAlignment=NSTextAlignmentCenter;
    destinationLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [arriveButton addSubview:destinationLabel];
    
    
    [self uibuttonLayout];

    
    //出发城市与到达城市转换按钮
    UIButton *exchangeButton=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH-51, 84+11/2-15, 30, 30)];
    [exchangeButton setImage:[UIImage imageNamed:@"CLGH_ZH_TB_@2x"] forState:UIControlStateNormal];
    [exchangeButton addTarget:self action:@selector(exchangeButtonAN) forControlEvents:UIControlEventTouchUpInside];
    [headeView addSubview:exchangeButton];
    
    //出发日期设置
    dateButton=[[UIButton alloc]initWithFrame:CGRectMake(35/2, 99+40, WIDTH-35, 33)];
    [dateButton.layer setMasksToBounds:YES];
    [dateButton addTarget:self action:@selector(dateButtonPicKer) forControlEvents:UIControlEventTouchUpInside];
    [dateButton.layer setCornerRadius:8.0]; //设置矩圆角半径
    [dateButton.layer setBorderWidth:1.0];//边框宽度
    dateButton.layer.backgroundColor=[[UIColor colorWithRed:241.0 / 255.0 green:241.0 / 255.0 blue:241.0 / 255.0 alpha:1] CGColor];
    dateButton.layer.cornerRadius=8.0f;
    dateButton.layer.masksToBounds=YES;
    dateButton.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    dateButton.layer.borderWidth= 1.0f;

    [headeView addSubview:dateButton];
    UIImageView *dateImg=[[UIImageView alloc]initWithFrame:FRAME(dateButton.frame.size.width-20, (33-15)/2, 15, 15)];
    dateImg.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
    [dateButton addSubview:dateImg];
    
    
    UIImageView *dateImage=[[UIImageView alloc]initWithFrame:CGRectMake(11/2, 15/2, startingButton.frame.size.height-15, startingButton.frame.size.height-15)];
    dateImage.image=[UIImage imageNamed:@"CLGH_RQ_TB_@2x"];
    dateImage.layer.cornerRadius=dateImage.frame.size.width/2;
    [dateButton addSubview:dateImage];
    UILabel *dateLabel=[[UILabel alloc]init];
    dateLabel.frame=CGRectMake(dateImage.frame.origin.x+dateImage.frame.size.width+6, 15/2, dateLabel.frame.size.width, dateButton.frame.size.height-15);
    dateLabel.text=@"出发日期";
    dateLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    dateLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [dateLabel setNumberOfLines:0];
    [dateLabel sizeToFit];
    [dateButton addSubview:dateLabel];
    
    dateLabelView=[[UILabel alloc]initWithFrame:CGRectMake(dateLabel.frame.origin.x+dateLabel.frame.size.width+8, 15/2, dateLabelView.frame.size.width, dateButton.frame.size.height-15)];
    
    //出发时间相关布局设置
    timeButton=[[UIButton alloc]initWithFrame:CGRectMake(35/2, dateButton.frame.origin.y+dateButton.frame.size.height+11, WIDTH-35, 33)];
    [timeButton addTarget:self action:@selector(timeButtonPicker) forControlEvents:UIControlEventTouchUpInside];
    [timeButton.layer setMasksToBounds:YES];
    [timeButton.layer setCornerRadius:8.0]; //设置矩圆角半径
    [timeButton.layer setBorderWidth:1.0];//边框宽度
    timeButton.layer.backgroundColor=[[UIColor colorWithRed:241.0 / 255.0 green:241.0 / 255.0 blue:241.0 / 255.0 alpha:1] CGColor];
    timeButton.layer.cornerRadius=8.0f;
    timeButton.layer.masksToBounds=YES;
    timeButton.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    timeButton.layer.borderWidth= 1.0f;
    [headeView addSubview:timeButton];
    UIImageView *timeImg=[[UIImageView alloc]initWithFrame:FRAME(timeButton.frame.size.width-20, (33-15)/2, 15, 15)];
    timeImg.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
    [timeButton addSubview:timeImg];
    
    
    
    UIImageView *timeImage=[[UIImageView alloc]initWithFrame:CGRectMake(11/2, 15/2, startingButton.frame.size.height-15, startingButton.frame.size.height-15)];
    timeImage.image=[UIImage imageNamed:@"CLGH_SJ_TB_@2x"];
    timeImage.layer.cornerRadius=timeImage.frame.size.width/2;
    [timeButton addSubview:timeImage];
    UILabel *timeLabel=[[UILabel alloc]init];
    timeLabel.frame=CGRectMake(timeImage.frame.origin.x+timeImage.frame.size.width+6, 15/2, timeLabel.frame.size.width, timeButton.frame.size.height-15);
    timeLabel.text=@"出发时间";
    timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    timeLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [timeLabel setNumberOfLines:0];
    [timeLabel sizeToFit];
    [timeButton addSubview:timeLabel];
    
    timeViewLabel=[[UILabel alloc]initWithFrame:CGRectMake(timeLabel.frame.origin.x+timeLabel.frame.size.width+8, 15/2, timeViewLabel.frame.size.width, timeButton.frame.size.height-15)];
    
    //备注信息、提醒设置、订机票相关布局
    NSArray *array=@[@"备注信息",@"提醒设置",@"订机票"];
    NSArray *imageArray=@[@"CLGH_NR_TB_@2x",@"CLGH_TX_TB_@2x",@"CLGH_JP_TB_@2x"];
    for (int i=0; i<3; i++) {
        int Y=timeButton.frame.origin.y+timeButton.frame.size.height+5+43*i;
        UIView *lineView=[[UIView alloc]init];
        lineView.frame=CGRectMake(35/2, Y, WIDTH-35, 1);
        lineView.backgroundColor=[UIColor colorWithRed:241.0 / 255.0 green:241.0 / 255.0 blue:241.0 / 255.0 alpha:1];
        lineView.userInteractionEnabled = YES;
        [headeView addSubview:lineView];
        
        UIView *labelView=[[UIView alloc]initWithFrame:FRAME(0, Y+1, WIDTH, 84/2)];
        labelView.backgroundColor=[UIColor whiteColor];
        [headeView addSubview:labelView];
        
        UIImageView *headimageView=[[UIImageView alloc]init];
        if (i==1) {
            headimageView.frame=CGRectMake(39/2, 27/2, 32/2, 32/2);
        }else
        {
            headimageView.frame=CGRectMake(39/2, 27/2, 20, 32/2);
        }
        headimageView.image=[UIImage imageNamed:imageArray[i]];
        [labelView addSubview:headimageView];
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(headimageView.frame.origin.x+30, 23/2, label.frame.size.width, 32/2);
        label.text=array[i];
        label.lineBreakMode=NSLineBreakByTruncatingTail;
        [label sizeToFit];
        label.font=[UIFont fontWithName:@"Heiti SC" size:14];
        [labelView addSubview:label];
        if (i==0) {
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentTap:)];
            [labelView addGestureRecognizer:tap];
            contentLabel=[[UILabel alloc]initWithFrame:FRAME(label.frame.size.width+label.frame.origin.x+5, 23/2, WIDTH-(label.frame.size.width+label.frame.origin.x+5)-10, labelView.frame.size.height-22)];
            contentLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
            [self contentLayout];
            [labelView addSubview:contentLabel];
            UIImageView *bzImage=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-35/2-20, (42-15)/2, 15, 15)];
            bzImage.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
            [labelView addSubview:bzImage];
        }

        if (i==1)
        {
            labelView.userInteractionEnabled=YES;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTap:)];
            [labelView addGestureRecognizer:tap];
            remindLabel=[[UILabel alloc]init];
           
            [self timeTXLayout];
        }
        if (i==2) {
            
            switchButton=[[SwickControl alloc]initWithFrame:CGRectMake(WIDTH-50-35/2, 44/4, 50, 42/2)];
            if(_pushID==1)
            {
                if (switchButID==1) {
                    switchButton.on=YES;
                }else{
                    switchButton.on=NO;
                }
            }else{
                switchButton.on=NO;
            }
            switchButton.tag=1001;
            [switchButton addTarget:self action:@selector(switchButAction:) forControlEvents:UIControlEventValueChanged];
            switchButton.onText = @"YES"; //NSLocalizedString(@"YES", @"");
            switchButton.offText = @"NO";//NSLocalizedString(@"NO", @"");
            [labelView addSubview:switchButton];
        }
        
        y=Y;
    }
    if (clientID==1) {
        headeView.frame=CGRectMake(0, 97+15/2, WIDTH, y+43);
    }else{
        headeView.frame=CGRectMake(0, 64+15/2, WIDTH, y+43);
    }
    [self textLabelLayout];
    
}
#pragma mark 差旅人员显示方法
-(void)personnelLayout
{
    nameLabel.text=peronnelName;
    nameLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [nameLabel setNumberOfLines:1];
    [nameLabel sizeToFit];
    nameLabel.frame=FRAME(50+32/2, 21, WIDTH-50-67/2-20, 13);
    nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    nameLabel.textColor=[UIColor colorWithRed:164/255.0f green:164/255.0f blue:164/255.0f alpha:1];
    [personnelView addSubview:nameLabel];
    
    numberLabel.text=numberString;
    numberLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [numberLabel setNumberOfLines:1];
    [numberLabel sizeToFit];
    numberLabel.frame=FRAME(WIDTH-60-numberLabel.frame.size.width, 6, numberLabel.frame.size.width, 13);
    numberLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    numberLabel.textColor=[UIColor colorWithRed:164/255.0f green:164/255.0f blue:164/255.0f alpha:1];
    [personnelView addSubview:numberLabel];
    
}
#pragma mark 差旅人员点击方法
-(void)personnelAction:(id)sender
{
    viewVC=[[RelevantPersonnelViewController alloc]init];
    viewVC.dataMutableArray=mutableArray;
    viewVC.dataNameArray=nameArray;
    viewVC.dataMobileArray=mobilArray;
    viewVC.dataIdArray=idArray;
    [self.navigationController pushViewController:viewVC animated:YES];
    releID=100;
}
-(void)contentLayout
{
    contentLabel.text=contentString;
}
#pragma mark出发城市与到达城市的变化方法
-(void)uibuttonLayout
{
    [headeView addSubview:startingButton];
    
    startingImage.image=startingImages;
    startingImage.layer.cornerRadius=startingImage.frame.size.width/2;
    [startingButton addSubview:startingImage];
    
    startingLabel.text=startingStr;
    startingLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    startingLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [startingLabel setNumberOfLines:0];
    [startingLabel sizeToFit];
    [startingButton addSubview:startingLabel];
    NSLog(@"城市名称%@",setoutString);
    setoutLabel.text=setoutString;
    setoutLabel.frame=FRAME(startingLabel.frame.origin.x+startingLabel.frame.size.width, 15/2, startingButton.frame.size.width-15-(startingLabel.frame.origin.x+startingLabel.frame.size.width), startingButton.frame.size.height-15);
    
    
    
    [headeView addSubview:arriveButton];
    arriveImage.image=arriveImages;
    arriveImage.layer.cornerRadius=arriveImage.frame.size.width/2;
    [arriveButton addSubview:arriveImage];
    arriveLabel.text=arriveStr;
    arriveLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    arriveLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [arriveLabel setNumberOfLines:0];
    [arriveLabel sizeToFit];
    [arriveButton addSubview:arriveLabel];
    destinationLabel.text=destinationString;
    destinationLabel.frame=FRAME(arriveLabel.frame.origin.x+arriveLabel.frame.size.width, 15/2, arriveButton.frame.size.width-15-(arriveLabel.frame.origin.x+arriveLabel.frame.size.width), arriveButton.frame.size.height-15);
}
#pragma mark出发日期与出发时间的label现实变化方法
-(void)textLabelLayout
{
    if (dateString==nil||dateString==NULL) {
        
    }else{
        dateLabelView.text=dateString;
    }
    
    dateLabelView.font=[UIFont fontWithName:@"Heiti SC" size:14];
    dateLabelView.lineBreakMode=NSLineBreakByTruncatingTail;
    [dateLabelView setNumberOfLines:1];
    [dateLabelView sizeToFit];
    dateLabelView.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [dateButton addSubview:dateLabelView];
    if (timeString==nil||timeString==NULL) {
        
    }else{
        timeViewLabel.text=timeString;
    }
    timeViewLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    timeViewLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [timeViewLabel setNumberOfLines:1];
    [timeViewLabel sizeToFit];
    timeViewLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [timeButton addSubview:timeViewLabel];
    
    
}
-(void)timeTXLayout
{
    remindLabel.text=remindString;
    remindLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    remindLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [remindLabel setNumberOfLines:1];
    [remindLabel sizeToFit];
    remindLabel.frame=FRAME(WIDTH-remindLabel.frame.size.width-32/2, timeButton.frame.origin.y+timeButton.frame.size.height+48+29/2, remindLabel.frame.size.width, 32/2);
    [headeView addSubview:remindLabel];
}
#pragma mark秘书处理与创建按钮布局方法
-(void)LabelLayout
{
    [msView removeFromSuperview];
    msView=[[UIView alloc]init];
    if(clientID==1){
        msView.frame=CGRectMake(0, y+107+36/2+33, WIDTH, 42);
    }else{
        msView.frame=CGRectMake(0, y+107+36/2, WIDTH, 42);
    }
    
    msView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:msView];
    
    msImageView=[[UIImageView alloc]init];
    msImageView.frame=CGRectMake(39/2, 29/2, 32/2, 32/2);
    
    UILabel *label=[[UILabel alloc]init];
    label.frame=CGRectMake(msImageView.frame.origin.x+msImageView.frame.size.width+10, 25/2, label.frame.size.width, 32/2);
    label.text=@"交给秘书处理";
    label.font=[UIFont fontWithName:@"Heiti SC" size:14];
    label.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    label.lineBreakMode=NSLineBreakByTruncatingTail;
    [label setNumberOfLines:0];
    [label sizeToFit];
    [self msImageViewLayout];
    [msView addSubview:label];
    
    switchBut=[[SwickControl alloc]initWithFrame:CGRectMake(WIDTH-50-35/2, 44/4, 50, 42/2)];
    switchBut.noId=1;
    
    [switchBut addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    if (periodID==0) {
        
    }else{
        switchBut.ID=switchBT;
        if(_pushID==1)
        {
            if (switchButID==1) {
                switchBut.on=YES;
            }else{
                switchBut.on=NO;
            }
        }else{
            switchBut.on=NO;
        }

    }
    
    switchBut.swickID=1;
    switchBut.onText = @"YES"; //NSLocalizedString(@"YES", @"");
    switchBut.offText = @"NO";//NSLocalizedString(@"NO", @"");
    [msView addSubview:switchBut];
    
    //创建按钮的相关布局
    [tabBarView removeFromSuperview];
    tabBarView=[[UIView alloc]init];
    tabBarView.frame=CGRectMake(0, HEIGHT-49, WIDTH, 49);
    tabBarView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:tabBarView];
    
    UIButton *button=[[UIButton alloc]init];
    button.frame=FRAME(14, 5, WIDTH-28, 41);
    if(_pushID==1){
        [button setTitle:@"确认修改" forState:UIControlStateNormal];
    }else{
        [button setTitle:@"创建" forState:UIControlStateNormal];
    }
    
    button.backgroundColor=self.backlable.backgroundColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius=5;
    [button addTarget:self action:@selector(establish:) forControlEvents:UIControlEventTouchUpInside];
    [tabBarView addSubview:button];
}
-(void)msImageViewLayout
{
    msImageView.image=msImages;
    [msView addSubview:msImageView];
}
#pragma mark datePicker初始化以及出发日期按钮的点击方法
-(void)dateButtonPicKer
{
    [datePicker removeFromSuperview];
    datePicker = [[DatePicker alloc]initWithFrame:FRAME(0, HEIGHT, WIDTH, 250)];
    datePicker.delegate = self;
    [self.view addSubview:datePicker];
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    datePicker.frame = CGRectMake(0, HEIGHT-250, WIDTH, 250);
    timePicker.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    picker.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
}
#pragma mark timePicker初始化以及出发时间按钮的点击方法
-(void)timeButtonPicker
{
    [timePicker removeFromSuperview];
    timePicker=[[TixingTimePicker alloc]initWithFrame:FRAME(0, HEIGHT, WIDTH, 220)];
    timePicker.delegate=self;
    [self.view addSubview:timePicker];
    
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    timePicker.frame=FRAME(0, HEIGHT-220, WIDTH, 220);
    datePicker.frame = FRAME(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 250);
    picker.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
}
#pragma mark datePicker代理方法
- (void)dateQuxiao
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    datePicker.frame = FRAME(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 250);
    [UIView commitAnimations];
    
}
-(void)dateQueding:(NSString *)date
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    datePicker.frame = FRAME(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 250);
    [UIView commitAnimations];
    
    NSString *year = [date substringWithRange:NSMakeRange(0, 4)];
    NSString *day = [date substringWithRange:NSMakeRange(8, 2)];
    NSString *month = [date substringWithRange:NSMakeRange(5, 2)];
    dateString=[NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    NSLog(@"jshah%@",dateString);
    [self textLabelLayout];
}
#pragma mark TimePicker代理方法
- (void)timepicCanle
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    timePicker.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
}
- (void)TimePicSure:(NSString *)timeStr
{
    NSLog(@"time %@",timeStr);
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    timePicker.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
    timeString=[NSString stringWithFormat:@"%@",timeStr];
    
    [self textLabelLayout];
}

- (void)suanle
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    picker.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
}

- (void)hours:(NSString *)hours //minutes:(NSString *)minutes
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    picker.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
    remindString=[NSString stringWithFormat:@"%@",hours];

    
    
    [self timeTXLayout];
}
#pragma mark目的地与始发地转换按钮方法
-(void)exchangeButtonAN
{

    if (x%2==0) {
        [UIView beginAnimations:@"Animation" context:nil];
        [UIView setAnimationDuration:0.5];
        
        startingButton.frame=CGRectMake(35/2, 55+40, WIDTH-173/2, 33);
        startingImages=[UIImage imageNamed:@"CLGH_FHCS_TB@2x"];
        startingStr=@"到达城市";
        fromID=to_ID;
        toID=from_ID;
        arriveButton.frame=CGRectMake(35/2, 22/2+40, WIDTH-173/2, 33);
        arriveImages=[UIImage imageNamed:@"CLGH_CFCS_TB_@2x"];
        arriveStr=@"出发城市";
        [UIView commitAnimations];

        
    }else{
        [UIView beginAnimations:@"Animation" context:nil];
        [UIView setAnimationDuration:0.5];
        startingButton.frame=CGRectMake(35/2, 22/2+40, WIDTH-173/2, 33);
        startingImages=[UIImage imageNamed:@"CLGH_CFCS_TB_@2x"];
        startingStr=@"出发城市";
        
        arriveButton.frame=CGRectMake(35/2, 55+40, WIDTH-173/2, 33);
        arriveImages=[UIImage imageNamed:@"CLGH_FHCS_TB@2x"];
        arriveStr=@"到达城市";
        [UIView commitAnimations];
        fromID=from_ID;
        toID=to_ID;
    }
    [self uibuttonLayout];
    x+=1;
}

#pragma mark 开关按钮switchBut的点击相应事件方法
-(void)switchAction:(id)sender
{
    if (periodID==0) {
        ClerkViewController *seekVC=[[ClerkViewController alloc]init];
        seekVC.service_type_id=@"75";
        [self.navigationController pushViewController:seekVC animated:YES];
        switchBut.noId=1;
        
    }else{
        switchBut.noId=0;
        UISwitch *switchBuT=(UISwitch *)sender;
        if (switchBuT.isOn) {
            msImages=[UIImage imageNamed:@"chuli"];
            mscl_int=1;
            switchButton.ID=1;
            switchButton.on=YES;
            switchButton.switchStr=@"YES";
            [self switchButAction:@"YES"];
        }else
        {
            mscl_int=0;
            switchButton.ID=1;
            switchButton.on=NO;
            
            msImages=[UIImage imageNamed:@"chuli"];
            [self switchButAction:@"NO"];
            switchButton.switchStr=@"NO";
            
        }
        
        [self msImageViewLayout];
    }
    
    
}
//取消按钮点击方法
-(void)cancelAction:(id)sender
{
    maskView.hidden=YES;
}
//确定按钮点击方法
-(void)sureAction:(id)sender
{
//    SeekViewController *vce=[[SeekViewController alloc]init];
//    [self.navigationController pushViewController:vce animated:YES];
}
#pragma mark 开关按钮switchButton的相应事件方法
-(void)switchButAction:(id)sender
{
    
    if (switchButton.isOn)
    {
        set_now_send_ID=1;
    }else
    {
        //
        set_now_send_ID=0;
        if (mscl_int==1) {
            switchButton.ID=1;
        }else{
            switchButton.ID=0;
        }
        
    }
}
-(void)contentTap:(id)sender
{
    viewController=[[ConTentViewController alloc]init];
    viewController.textString=contentString;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark 234657890--------=-----------=-=-=-=-=-=-=-=-=-
-(void)labelTap:(id)sender
{
    if (timeString==NULL||timeString==nil||[timeString length]==0) {
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"你还没有选择出发日期和时间，请选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [tsView show];
        
    }else{
        [picker removeFromSuperview];
        picker = [[TimePicker alloc]initWithFrame:FRAME(0, HEIGHT, WIDTH, 220)];
        picker.delegate = self;
        [self.view addSubview:picker];
        [UIView beginAnimations: @"Animation" context:nil];
        [UIView setAnimationDuration:0.3];
        picker.frame = CGRectMake(0, HEIGHT-220, WIDTH, 220);
        datePicker.frame = FRAME(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 250);
        timePicker.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
        [UIView commitAnimations];
    }
    
  
}
-(void)nazhong
{
    if([remindString isEqualToString:@"不提醒"])
    {
        
    }else
    {
        
        if ([remindString isEqualToString:@"按时提醒"]) {
            time_ID=0;
        }else if ([remindString isEqualToString:@"提前5分钟"]){
            time_ID=300;
        }else if ([remindString isEqualToString:@"提前15分钟"]){
            time_ID=15*60;
        }else if ([remindString isEqualToString:@"提前30分钟"]){
            time_ID=30*60;
        }else if ([remindString isEqualToString:@"提前1小时"]){
            time_ID=1*60*60;
        }else if ([remindString isEqualToString:@"提前2小时"]){
            time_ID=2*60*60;
        }else if ([remindString isEqualToString:@"提前6小时"]){
            time_ID=6*60*60;
        }else if ([remindString isEqualToString:@"提前1天"]){
            time_ID=1*24*60*60;
        }else if ([remindString isEqualToString:@"提前2天"]){
            time_ID=2*24*60*60;
        }
        
        // 初始化本地通知对象
        
    }

    
    NSString *str=[NSString stringWithFormat:@"%@ %@",dateString,timeString];
    if (dateString==NULL||timeString==NULL||dateString==nil||timeString==nil) {
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"你还没有选择日期和时间，请选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [tsView show];

    }else{
        NSLog(@"时间%@",str);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* dat = [formatter dateFromString:str];
        
        int timeID=[[timeString substringWithRange:NSMakeRange(6,2)] intValue];
        NSLog(@"timeID___%d",timeID);
            if ([nameArray containsObject:@"自己"]) {
                UILocalNotification *notification=[[UILocalNotification alloc] init];
                if (notification!=nil) {
                    notification.fireDate=[dat dateByAddingTimeInterval:-(time_ID+timeID)];//10秒后通知
                    
                    notification.repeatInterval=0;//循环次数，kCFCalendarUnitWeekday一周一次
                    
                    notification.timeZone=[NSTimeZone defaultTimeZone];
                    
                    notification.applicationIconBadgeNumber=1; //应用的红色数字
                    
                    
                    notification.soundName=@"simivoice.caf";//声音，可以换成alarm.soundName = @"myMusic.caf"
                    
                    //去掉下面2行就不会弹出提示框
                    
                    notification.alertBody=self.navlabel.text;//提示信息 弹出提示框
                    
                    notification.alertAction = @"打开";  //提示框按钮
                    
                    //notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
                    
                    
                    
                    // NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
                    
                    //notification.userInfo = infoDict; //添加额外的信息
                    
                    
                    
                    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                    
                }

            }
//        }
        
    }
    
}

-(void)establish:(id)sender
{
    //获取当前时间
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    NSLog(@"locationString:%@",locationString);
    NSDateFormatter *formatte = [[NSDateFormatter alloc] init];
    [formatte setDateStyle:NSDateFormatterMediumStyle];
    [formatte setTimeStyle:NSDateFormatterShortStyle];
    [formatte setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [formatte dateFromString:locationString];
    NSTimeInterval _secondDate = [date timeIntervalSince1970]*1;
    
    //获取当前时间
    NSString *str=[NSString stringWithFormat:@"%@ %@",dateString,timeString];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* dat = [formatter dateFromString:str]; //------------将字符串按formatter转成nsdate
    NSLog(@"%@",dat);

    NSTimeInterval _fitstDate;

    _fitstDate = [dat timeIntervalSince1970]*1;
    
    NSLog(@"创建");
    if (clientID==1) {
        if (nameString==nil||nameString==NULL) {
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"给谁创建" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if (peronnelName==nil||peronnelName==NULL) {
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择差旅人员！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if (setoutString==nil||setoutString==NULL) {
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选城市" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if (destinationString==nil||destinationString==NULL){
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择城市" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if (dateString==nil||dateString==NULL){
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择出发日期" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if (timeString==nil||timeString==NULL){
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择出发时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if (contentString==nil||contentString==NULL){
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请填写备注信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if([remindString isEqualToString:@"不提醒"]){
            if(_secondDate-_fitstDate>0){
                
                UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"您选择的出发日期活出发时间无效，请选择有效时间！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [tsView show];
            }else{
                if(mscl_int==1){
                    if(_fitstDate-_secondDate==2*24*60*60)
                    {
                        //没有闹钟调用
                        [self CardCreationLayout];
                    }else{
                        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"您给秘书预留的时间过短，至少要预留出2天的时间哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [tsView show];
                    }
                }else{
                    //没有闹钟调用
                    [self CardCreationLayout];
                }

            }
            
            
        }else{
            if(_secondDate-_fitstDate>0){
                
                UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"您选择的出发日期活出发时间无效，请选择有效时间！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [tsView show];
            }else{
                
                if(mscl_int==1){
                    if(_fitstDate-_secondDate==2*24*60*60)
                    {
                        //有闹钟时调用
                        [self CardClockLayout];
                    }else{
                        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"您给秘书预留的时间过短，至少要预留出2天的时间哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [tsView show];
                    }
                }else{
                    //有闹钟时调用
                    [self CardClockLayout];
                }

            }
            
            
        }

    }else {
        if (peronnelName==nil||peronnelName==NULL) {
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择差旅人员！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if (setoutString==nil||setoutString==NULL) {
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选城市" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if (destinationString==nil||destinationString==NULL){
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择城市" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if (dateString==nil||dateString==NULL){
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择出发日期" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if (timeString==nil||timeString==NULL){
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择出发时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if (contentString==nil||contentString==NULL){
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请填写备注信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if([remindString isEqualToString:@"不提醒"]){
            if(_secondDate-_fitstDate>0){
                
                UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"您选择的出发日期活出发时间无效，请选择有效时间！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [tsView show];
            }else{
                if(mscl_int==1){
                    if(_fitstDate-_secondDate==2*24*60*60)
                    {
                        //没有闹钟调用
                        [self CardCreationLayout];
                    }else{
                        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"您给秘书预留的时间过短，至少要预留出2天的时间哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [tsView show];
                    }
                }else{
                    //没有闹钟调用
                    [self CardCreationLayout];
                }

            }
            
        }else{
            if(_secondDate-_fitstDate>0){
                
                UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"您选择的出发日期活出发时间无效，请选择有效时间！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [tsView show];
            }else{
                if(mscl_int==1){
                    if(_fitstDate-_secondDate==2*24*60*60)
                    {
                        //有闹钟时调用
                        [self CardClockLayout];
                    }else{
                        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"您给秘书预留的时间过短，至少要预留出2天的时间哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [tsView show];
                    }
                }else{
                    //有闹钟时调用
                    [self CardClockLayout];
                }
                

            }
            
            
        }

    }
    
    
}
//没有闹钟调用
-(void)CardCreationLayout
{
    NSString *str=[NSString stringWithFormat:@"%@ %@",dateString,timeString];
    NSLog(@"时间%@",str);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* dat = [formatter dateFromString:str]; //------------将字符串按formatter转成nsdate
    NSLog(@"%@",dat);

    int a=[dat timeIntervalSince1970];
    NSString *timestring = [NSString stringWithFormat:@"%d", a];
    NSLog( @"当前时间戳%@",timestring);
    NSTimeInterval timestr;
    timestr=a;
    NSLog(@"%f",timestr);
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSLog(@"有值么%@",_manager.telephone);
    
    NSString *type_ID=[NSString stringWithFormat:@"%d",card_type_ID];
    NSString *txROW=[NSString stringWithFormat:@"%ld",(long)picker.txRow];
    NSString *sendString=[NSString stringWithFormat:@"%d",set_now_send_ID];
    NSString *msclString=[NSString stringWithFormat:@"%d",mscl_int];
    NSString *fromString=[NSString stringWithFormat:@"%@",fromID];
    NSString *toString=[NSString stringWithFormat:@"%@",toID];
    NSString *create_user_id=[[NSString alloc]init];
    NSString *user_id=[[NSString alloc]init];
    NSMutableArray *dicArray=[[NSMutableArray alloc]init];
    for (int i=0; i<nameArray.count; i++) {
        NSDictionary *dict=@{@"mobile":mobilArray[i],@"name":nameArray[i]};
        [dicArray addObject:dict];
    }
    NSArray *infor=[NSArray arrayWithArray:dicArray];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infor options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableArray *cityArray=[[NSMutableArray alloc]init];
    NSDictionary *cityDic=@{@"ticket_type":sendString,@"ticket_from_city_id":fromString,@"ticket_to_city_id":toString};
    [cityArray addObject:cityDic];
    NSArray *cityinfor=[NSArray arrayWithArray:cityArray];
    NSError *cityerror;
    NSData *cityjsonData = [NSJSONSerialization dataWithJSONObject:cityinfor options:NSJSONWritingPrettyPrinted error:&cityerror];
    NSString *cityJsonString = [[NSString alloc] initWithData:cityjsonData encoding:NSUTF8StringEncoding];
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    if (clientString==NULL||clientString==nil) {
        create_user_id=_manager.telephone;
        user_id=_manager.telephone;
    }else{
        create_user_id=_manager.telephone;
        user_id=clientString;
    }
    NSDictionary *_dict;
    if (_pushID==1) {
        _dict = @{@"card_id":_cardString,@"card_type":type_ID,@"create_user_id":create_user_id,@"user_id":user_id,@"service_time":timestring,@"service_content":contentString,@"set_remind":txROW,@"set_now_send":sendString,@"set_sec_do":msclString,@"card_extra":cityJsonString,@"attends":jsonString};
    }else{
        _dict = @{@"card_id":@"0",@"card_type":type_ID,@"create_user_id":create_user_id,@"user_id":user_id,@"service_time":timestring,@"service_content":contentString,@"set_remind":txROW,@"set_now_send":sendString,@"set_sec_do":msclString,@"card_extra":cityJsonString,@"attends":jsonString};
    }
    
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CREATE_CARD dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:YES failedSEL:@selector(DownFail:)];
}
//有闹钟时调用
-(void)CardClockLayout
{
    [self nazhong];
    NSString *str=[NSString stringWithFormat:@"%@ %@",dateString,timeString];
    NSLog(@"时间%@",str);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* dat = [formatter dateFromString:str]; //------------将字符串按formatter转成nsdate
    NSLog(@"%@",dat);

    int a=[dat timeIntervalSince1970];
    NSString *timestring = [NSString stringWithFormat:@"%d", a];
    NSLog( @"当前时间戳%@",timestring);
    NSTimeInterval timestr;
    timestr=a;
    NSLog(@"%f",timestr);

    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSLog(@"有值么%@",_manager.telephone);
    
    NSString *type_ID=[NSString stringWithFormat:@"%d",card_type_ID];
    NSString *txROW=[NSString stringWithFormat:@"%ld",(long)picker.txRow];
    NSString *sendString=[NSString stringWithFormat:@"%d",set_now_send_ID];
    NSString *msclString=[NSString stringWithFormat:@"%d",mscl_int];
    NSString *fromString=[NSString stringWithFormat:@"%@",fromID];
    NSString *toString=[NSString stringWithFormat:@"%@",toID];
    NSString *create_user_id=[[NSString alloc]init];
    NSString *user_id=[[NSString alloc]init];
    NSMutableArray *dicArray=[[NSMutableArray alloc]init];
    for (int i=0; i<nameArray.count; i++) {
        NSDictionary *dict=@{@"mobile":mobilArray[i],@"name":nameArray[i]};
        [dicArray addObject:dict];
    }
    NSArray *infor=[NSArray arrayWithArray:dicArray];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infor options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
//    NSMutableArray *cityArray=[[NSMutableArray alloc]init];
    NSDictionary *cityDic=@{@"ticket_type":sendString,@"ticket_from_city_id":fromString,@"ticket_to_city_id":toString};
//    [cityArray addObject:cityDic];
//    NSArray *cityinfor=[NSArray arrayWithArray:cityArray];
    NSError *cityerror;
    NSData *cityjsonData = [NSJSONSerialization dataWithJSONObject:cityDic options:NSJSONWritingPrettyPrinted error:&cityerror];
    NSString *cityJsonString = [[NSString alloc] initWithData:cityjsonData encoding:NSUTF8StringEncoding];
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    if (clientString==NULL||clientString==nil) {
        create_user_id=_manager.telephone;
        user_id=_manager.telephone;
    }else{
        create_user_id=_manager.telephone;
        user_id=clientString;
    }
    NSDictionary *_dict;
    if (_pushID==1) {
        _dict = @{@"card_id":_cardString,@"card_type":type_ID,@"create_user_id":create_user_id,@"user_id":user_id,@"service_time":timestring,@"service_content":contentString,@"set_remind":txROW,@"set_now_send":sendString,@"set_sec_do":msclString,@"card_extra":cityJsonString,@"attends":jsonString};
    }else{
        _dict = @{@"card_id":@"0",@"card_type":type_ID,@"create_user_id":create_user_id,@"user_id":user_id,@"service_time":timestring,@"service_content":contentString,@"set_remind":txROW,@"set_now_send":sendString,@"set_sec_do":msclString,@"card_extra":cityJsonString,@"attends":jsonString};
    }
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CREATE_CARD dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:YES failedSEL:@selector(DownFail:)];
}
-(void)logDowLoadFinish:(id)sender
{
    [self backAction];
    NSLog(@"登录后信息：%@",sender);

}
- (void)backAction
{
    _backBtn.enabled = NO;
    [self.navigationController popViewControllerAnimated:YES];
    _backBtn.enabled = YES;
}
-(void)DownFail:(id)sender
{
    NSLog(@"erroe is %@",sender);
}
-(void)cityAction:(UIButton *)sender
{
    vc=[[CityViewController alloc]init];

    switch (sender.tag) {
        case 20001:
        {
            ctID=sender.tag;
            vc.cityID=sender.tag;
        }
            break;
        case 20002:
        {
            ctID=sender.tag;
            vc.cityID=sender.tag;
        }
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
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
