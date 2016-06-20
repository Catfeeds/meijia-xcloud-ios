//
//  MeetingViewController.m
//  simi
//
//  Created by 白玉林 on 15/8/10.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "MeetingViewController.h"
#import <AddressBook/AddressBook.h>
//#import "SwickControl.h"
#import "TimePicker.h"
#import "MeetingPickerView.h"
#import "DCRoundSwitch.h"
#import "DownloadManager.h"
#import "ISLoginManager.h"
//#import "MeetingViewController.h"

#import "FXBlurView.h"
#import "ConTentViewController.h"

#import "ClerkViewController.h"

#import "RelevantPersonnelViewController.h"

#import "CustomerViewController.h"
#import "Meeting_roomButViewController.h"

#import "LoopPicker.h"
int heights;
int H = 0,time_ID;
@interface MeetingViewController ()<timePickerDelegate,meetingPickerDelegate,LoopPickerDelegate>
{
    UIView *backgroundView;
    
    UILabel *selectLabel;
    UILabel *numberLabel;
    UILabel *timeLabel;
    UILabel *placeLabel;
    UILabel *meetingLabel;
    UILabel *contentLabel;
    
    NSString *selectString;
    NSString *numberString;
    NSString *timeString;
    NSString *placeString;
    NSString *meetingString;
    NSString *remarksString;
    NSString *contentString;
    
    NSString *periodString;
    
    UIButton *timeButton;
    UIButton *placeButton;
    
    UIView *secretaryView;
    DCRoundSwitch *switchButton;
    DCRoundSwitch *switchBut;
    UITextView *remarksView;
    CGRect frame;
    TimePicker *picker;
    MeetingPickerView *meetingDatePicker;
    
    LoopPicker *loopPicker;
    
    UITapGestureRecognizer *tapSelf;
    UIView *selfView;
    
    UIImageView *msImageView;
    UIImage *msImages;
    
    UIView *sendView;
    int card_type_ID;
    int txIndex;
    int mscl;
    int whether_to_send;
    int periodID;
    ConTentViewController *viewController;
    
    FXBlurView *maskView;
    
    UITextField *meetingField;
    NSString *textFieldString;
    int fieldID;
    
    NSString *clientString;
    UIButton *clientButton;
    int clientId;
    
    
    RelevantPersonnelViewController *viewVC;
    
    NSArray *mobileArray;
    NSArray *nameArray;
    NSArray *mutableArray;
    NSArray *idArray;
    UILabel *textViewLabel;
    
    int clientID;
    
    CustomerViewController *customerVC;
    UILabel *whoLabel;
    NSInteger _index;
    NSString *nameString;
    
    NSDictionary *dic;
    
    int switchButID;
    
    NSString *switchId;
    NSString *switchID;
    
    UILabel *label1;
    
    NSDictionary *sourceDic;
    NSDictionary *zjDic;
    
    int releID;
    Meeting_roomButViewController *meetingVC;
    int meetingVCid;
    
    UIButton *upBUt;
    UIImageView *upbutImage;
    int upButInt;
    
    UILabel *loopLabel;
    NSString *loopString;
    NSString *loopUpStr;
    int push_IDSSS;
}
@property (nonatomic, assign) ABAddressBookRef addressBookRef;
@end

@implementation MeetingViewController
@synthesize textID,time;



- (void)viewDidLoad {
    [super viewDidLoad];
    loopString=@"一次性提醒";
    [self loopLayout:loopString];
    remarksString=@"";
    _navlabel.textColor = [UIColor whiteColor];
    self.img.hidden=YES;
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 20, 20)];
    img.image = [UIImage imageNamed:@"iconfont-p-back"];
    [_backBtn addSubview:img];
    switchButID=0;
    _index=-1;
    _cardsID=1;
    textID=0;
    time=0;
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
            
        default:
            break;
    }

    //theNumber=1;
    msImages=[UIImage imageNamed:@"chuli"];
    [self selfViewLayout];
    //增加监听，当键盘出现或改变时收出消息
    ISLoginManager *_manager = [ISLoginManager shareManager];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *mobli=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"mobile"]];
    zjDic=@{@"name":@"自己",@"mobil":mobli,@"user_id":_manager.telephone};
    idArray=@[[zjDic objectForKey:@"user_id"]];
    mobileArray =@[[zjDic objectForKey:@"mobil"]];
    nameArray =@[[zjDic objectForKey:@"name"]];
    mutableArray=@[[zjDic objectForKey:@"mobil"]];
    selectString =[nameArray componentsJoinedByString:@","];
    numberString=[NSString stringWithFormat:@"共%lu人",(unsigned long)nameArray.count];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
//    self.view.tag=1005;
    tapSelf=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tapSelf];
    switch (_vcID) {
        case 1001:
        {
//            self.navlabel.text=@"会议安排";
            card_type_ID=1;
        }
            break;
        case 1002:
        {
//            self.navlabel.text=@"通知公告";
            card_type_ID=2;
        }
            break;
        case 1003:
        {
//            self.navlabel.text=@"事务提醒";
            card_type_ID=3;
        }
            break;
        case 1004:
        {
//            self.navlabel.text=@"面试邀约";
            card_type_ID=4;
        }
            break;
            
        default:
            break;
    }

    self.navlabel.text=_titleName;
    selfView.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    
    
    
    textViewLabel=[[UILabel alloc]initWithFrame:FRAME(39/2, 5, WIDTH-39, 15)];
    textViewLabel.text=@"您可以给秘书捎句话...";
    textViewLabel.textColor=[UIColor colorWithRed:164/255.0f green:164/255.0f blue:164/255.0f alpha:1];
    textViewLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    textViewLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [textViewLabel setNumberOfLines:1];
    [textViewLabel sizeToFit];
    [remarksView addSubview:textViewLabel];
    
    if (_pushID==1) {
        ISLoginManager *_manager = [ISLoginManager shareManager];
        NSLog(@"有值么%@",_manager.telephone);
        DownloadManager *_download = [[DownloadManager alloc]init];
        
        NSDictionary *_dict = @{@"card_id":_cardString,@"user_id":_manager.telephone};
        NSLog(@"字典数据%@",_dict);
        [_download requestWithUrl:CARD_DETAILS dict:_dict view:self.view delegate:self finishedSEL:@selector(KPgm:) isPost:NO failedSEL:@selector(KPDownmsgm:)];
        
    }

    // Do any additional setup after loading the view.
}

-(void)KPgm:(id)sender
{
    dic=[sender objectForKey:@"data"];
    NSString *userStr=[dic objectForKey:@"user_id"];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    if (userStr==_manager.telephone) {
        nameString=@"自己";
    }else{
        nameString=[dic objectForKey:@"name"];
    }
   // =[dic objectForKey:@"attends"];
    NSArray *array=[dic objectForKey:@"attends"];
    NSMutableArray *nameArr=[[NSMutableArray alloc]init];
    NSMutableArray *mobileArr=[[NSMutableArray alloc]init];
    NSMutableArray *idArr=[[NSMutableArray alloc]init];
    for (int i=0; i<array.count; i++) {
        NSString *string=[NSString stringWithFormat:@"%@",[array[i] objectForKey:@"name"]];
        NSString *mobString=[NSString stringWithFormat:@"%@",[array[i] objectForKey:@"mobile"]];
        NSString *idString=[NSString stringWithFormat:@"%@",[array[i]objectForKey:@"user_id"]];
        [idArr addObject:idString];
        [mobileArr addObject:mobString];
        [nameArr addObject:string];
    }
    selectString =[nameArr componentsJoinedByString:@","];
    idArray=idArr;
    mobileArray =mobileArr;
    nameArray =nameArr;
    mutableArray=mobileArr;
    int q=[[dic objectForKey:@"period"]intValue];
    if (q==0) {
        loopString=@"一次性提醒";
    }else if (q==1){
        loopString=@"每天";
    }else if (q==2){
        loopString=@"工作日(周一至周五)";
    }else if (q==3){
        loopString=@"每周";
    }else if (q==4){
        loopString=@"每月";
    }else if (q==5){
        loopString=@"每年";
    }

    [self loopLayout:loopString];
    numberString=[NSString stringWithFormat:@"共%lu人",(unsigned long)array.count];
    
    double inTime=[[dic objectForKey:@"service_time"] doubleValue];
    NSDateFormatter* inTimeformatter =[[NSDateFormatter alloc] init];
    inTimeformatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [inTimeformatter setDateStyle:NSDateFormatterMediumStyle];
    [inTimeformatter setTimeStyle:NSDateFormatterShortStyle];
    [inTimeformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* inTimedate = [NSDate dateWithTimeIntervalSince1970:inTime];
    NSString* inTimeString = [inTimeformatter stringFromDate:inTimedate];
    timeString=inTimeString;
    contentString=[dic objectForKey:@"service_content"];
    
    

   // meetingString=@"6";
    [self clientButtonLayout];
    if(_pushID==1){
        [self viewLayout];
       
    }
    
}
-(void)KPDownmsgm:(id)sender
{
    
}
- (void)viewWillAppear:(BOOL)animated {
    maskView.hidden=YES;
    NSLog(@"%@       %d    %@",switchId,switchButID,switchID);
    if (viewController.textString==NULL||viewController.textString==nil) {
//        contentString=contentString;
    }else
    {
        contentString=viewController.textString;
    }
    [self contentLabelLayout];
    if (releID==100) {
        selectString=viewVC.selectString;
        numberString=viewVC.numberString;
        nameArray=viewVC.nameArray;
        mobileArray=viewVC.mobileArray;
        mutableArray=viewVC.mutableArray;
        idArray=viewVC.idArray;
    }
    
    [self ParticipationLabelLayout];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSLog(@"有值么%@",_manager.telephone);
    DownloadManager *_download = [[DownloadManager alloc]init];
    
    NSDictionary *_dict = @{@"user_id":_manager.telephone};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:USER_INFO dict:_dict view:self.view delegate:self finishedSEL:@selector(msgm:) isPost:NO failedSEL:@selector(Downmsgm:)];
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    [remarksView resignFirstResponder];
    [meetingField resignFirstResponder];
    remarksView.frame=frame;
    remarksString=@"";
    [self labelLayout];
    [UIView commitAnimations];
    
    if (customerVC.clientString==nil||customerVC.clientString==NULL) {
        //        clientString=clientString;
        //        _index=_index;
    }else {
        clientString=customerVC.clientString;
        _index=customerVC.cellIndex;
        nameString=customerVC.nameString;
    }
    if (meetingVCid==100) {
        if (meetingVC.textFieldString==nil||meetingVC.textFieldString==NULL) {
            if (textFieldString==nil||textFieldString==NULL) {
                meetingField.placeholder = @"请输入地址！";
            }else{
                meetingField.text=textFieldString;
            }
        }else{
            textFieldString=meetingVC.textFieldString;
        }
        meetingVCid=0;
    }else{
        if (textFieldString==nil||textFieldString==NULL) {
            meetingField.placeholder = @"请输入地址！";
        }else{
            meetingField.text=textFieldString;
        }
    }
    [self selfViewLayout];
}
-(void)viewDidAppear:(BOOL)animated
{
    picker = [[TimePicker alloc]initWithFrame:FRAME(0, HEIGHT, WIDTH, 220)];
    picker.delegate = self;
    [self.view addSubview:picker];
    
    meetingDatePicker=[[MeetingPickerView alloc]initWithFrame:FRAME(0, HEIGHT, WIDTH, 250)];
    meetingDatePicker.delegate=self;
    [self.view addSubview:meetingDatePicker];
    
   
    
    if (periodID==0) {
        
    }else{
        switchBut.ID=1;
    }
}

-(void)msgm:(id)sender
{
    NSLog(@"用户数据:%@",sender);
    NSDictionary *diction=[sender objectForKey:@"data"];
    periodString=[NSString stringWithFormat:@"%@",[diction objectForKey:@"is_senior"]];
    periodID=[periodString intValue];
    if (periodID==0) {
        
    }else{
        switchBut.ID=1;
    }
    clientID=[[diction objectForKey:@"user_type"]intValue];
    if (clientID==1) {
        clientButton.hidden=NO;
    }else{
        clientButton.hidden=YES;
    }
    [self clientButtonLayout];
    if (_pushID!=1||push_IDSSS==100) {
       // ／ssss
         push_IDSSS=1;
        [self viewLayout];
    }
    
    
}
-(void)Downmsgm:(id)sender
{
    
}
-(void)selfViewLayout
{
    [selfView removeFromSuperview];
    selfView=[[UIView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    [self.view addSubview:selfView];
}
-(void)upBUTAction
{
    if (upButInt%2==0) {
        UIView *vie=(UIView *)[self.view viewWithTag:10014];
        vie.hidden=NO;
        upButInt++;
        upBUt.hidden=YES;
        upbutImage.hidden=YES;
        if (_vcID==1003) {
            
            [UIView beginAnimations:@"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            if(clientID==1)
            {
                backgroundView.frame=FRAME(0, 33+15/2, WIDTH,H+(84/2*3)+86/2);
            }else{
                backgroundView.frame=FRAME(0, 15/2, WIDTH,H+(84/2*3)+86/2);
            }

            [UIView commitAnimations];
        }else{
            [UIView beginAnimations:@"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            
            if(clientID==1)
            {
                backgroundView.frame=FRAME(0, 33+15/2, WIDTH,H+(84/2*2)+86/2);
            }else{
                backgroundView.frame=FRAME(0, 15/2, WIDTH,H+(84/2*2)+86/2);
            }
            [UIView commitAnimations];
         
        }
        [UIView beginAnimations:@"Animation" context:nil];
        [UIView setAnimationDuration:0.3];
        secretaryView.frame=FRAME(0, backgroundView.frame.origin.y+backgroundView.frame.size.height+8, WIDTH, 84/2);
        upBUt.frame=FRAME((WIDTH-110)/2, secretaryView.frame.origin.y+124/2, 110, 30);
        upbutImage.frame=FRAME((WIDTH-15)/2, upBUt.frame.origin.y+30, 15, 30);
        UIView *view1=(UIView *)[self.view viewWithTag:1003];
        view1.hidden=NO;
        UIView *view2=(UIView *)[self.view viewWithTag:1004];
        view2.hidden=NO;
        UIView *view3=(UIView *)[self.view viewWithTag:1005];
        view3.hidden=NO;
        [UIView commitAnimations];
        
    }else{
        upButInt--;
        UIView *view1=(UIView *)[self.view viewWithTag:1003];
        view1.hidden=YES;
        UIView *view2=(UIView *)[self.view viewWithTag:1004];
        view2.hidden=YES;
        UIView *view3=(UIView *)[self.view viewWithTag:1005];
        view3.hidden=YES;
        [UIView beginAnimations:@"Animation" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView commitAnimations];
        [UIView beginAnimations:@"Animation" context:nil];
        [UIView setAnimationDuration:0.3];
        if(clientID==1)
        {
            backgroundView.frame=FRAME(0, 33+15/2, WIDTH,H+(84/2*0)+86/2);
        }else{
            backgroundView.frame=FRAME(0, 15/2, WIDTH,H+(84/2*0)+86/2);
        }
        secretaryView.frame=FRAME(0, backgroundView.frame.origin.y+backgroundView.frame.size.height+8, WIDTH, 84/2);
        upBUt.frame=FRAME((WIDTH-110)/2, secretaryView.frame.origin.y+124/2, 110, 30);
        [UIView commitAnimations];
    }
}
#pragma mark 页面布局的方法
-(void)viewLayout
{
    backgroundView=[[UIView alloc]init];
    backgroundView.backgroundColor=[UIColor whiteColor];
    [selfView addSubview:backgroundView];
    [self LineViewLayout];
    [self labelViewLayout];
    
    secretaryView=[[UIView alloc]initWithFrame:FRAME(0, backgroundView.frame.origin.y+backgroundView.frame.size.height+8, WIDTH, 84/2)];
    secretaryView.backgroundColor=[UIColor whiteColor];
    [selfView addSubview:secretaryView];
    
    upBUt=[[UIButton alloc]initWithFrame:FRAME((WIDTH-110)/2, secretaryView.frame.origin.y+124/2, 110, 30)];
    [upBUt addTarget:self action:@selector(upBUTAction) forControlEvents:UIControlEventTouchUpInside];
    [upBUt setTitle:@"显示完整设置" forState:UIControlStateNormal];
    if (_vcID==1003) {
        if (upButInt%2==0) {
            upBUt.hidden=NO;
        }else{
            upBUt.hidden=YES;
        }
        
    }else{
        upBUt.hidden=YES;
    }
    upBUt.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    upBUt.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    upBUt.layer.cornerRadius=10;
    upBUt.clipsToBounds=YES;
    [upBUt setTitleColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1] forState:UIControlStateNormal];
    [selfView addSubview:upBUt];
    upbutImage=[[UIImageView alloc]initWithFrame:FRAME((WIDTH-15)/2, upBUt.frame.origin.y+30, 10, 10)];
    upbutImage.image=[UIImage imageNamed:@"xiangxiachakan50X58"];
    if (_vcID==1003) {
        if (upButInt%2==0) {
            upbutImage.hidden=NO;
        }else{
            upbutImage.hidden=YES;
        }

    }else{
        upbutImage.hidden=YES;
    }
    [selfView addSubview:upbutImage];;
    
    
    msImageView=[[UIImageView alloc]init];
    msImageView.frame=CGRectMake(39/2, 29/2, 32/2, 32/2);
    [self msImageViewLayout];
    UILabel *label=[[UILabel alloc]init];
    label.frame=CGRectMake(msImageView.frame.origin.x+msImageView.frame.size.width+10, 25/2, label.frame.size.width, 32/2);
    label.text=@"交给秘书处理";
    label.font=[UIFont fontWithName:@"Heiti SC" size:14];
    label.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    label.lineBreakMode=NSLineBreakByTruncatingTail;
    [label setNumberOfLines:0];
    [label sizeToFit];
    [secretaryView addSubview:label];
    
    label1=[[UILabel alloc]init];
    label1.frame=CGRectMake(20, secretaryView.frame.size.height+secretaryView.frame.origin.y+74, WIDTH-40, 32/2);
    label1.text=@"提示：秘书工作时间为7:00～19:00，请在此时间内设置秘书提醒时间";
    label1.font=[UIFont fontWithName:@"Heiti SC" size:14];
    label1.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    label1.lineBreakMode=NSLineBreakByTruncatingTail;
    label1.hidden=YES;
    [label1 setNumberOfLines:0];
    [label1 sizeToFit];
    [self.view addSubview:label1];
    
    switchBut=[[DCRoundSwitch alloc]initWithFrame:CGRectMake(WIDTH-50-35/2, 44/4, 50, 42/2)];
    int set_sec_do=[[dic objectForKey:@"set_sec_do"]intValue];
    if (periodID==0) {
        
    }else{
        switchBut.ID=1;
    }
    if (_pushID==1) {
        if (set_sec_do==0) {
            switchBut.on=NO;
        }else{
            switchBut.on=YES;
        }
    }else{
        if (whether_to_send==0) {
            switchBut.on=NO;
        }else{
            switchBut.on=YES;
        }
        
    }
    //switchButton.backgroundColor=[UIColor redColor];
    
    //            [switchButton setOn:NO];
    [switchBut addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    switchBut.onText = @"YES"; //NSLocalizedString(@"YES", @"");
    switchBut.offText = @"NO";//NSLocalizedString(@"NO", @"");
    [secretaryView addSubview:switchBut];
    
    remarksView=[[UITextView alloc]initWithFrame:FRAME(0, secretaryView.frame.origin.y+secretaryView.frame.size.height+1, WIDTH, 84/2)];
    remarksView.backgroundColor=[UIColor colorWithRed:251/255.0f green:251/255.0f blue:251/255.0f alpha:1];
    remarksView.delegate=self;
    [self labelLayout];
    //[selfView addSubview:remarksView];
    frame=remarksView.frame;
    
    sendView=[[UIView alloc]initWithFrame:FRAME(0, HEIGHT-50, WIDTH, 50)];
    sendView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:sendView];
    UIView *lineView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 1)];
    lineView.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    [sendView addSubview:lineView];
    UIButton *sendButton=[[UIButton alloc]initWithFrame:FRAME(14, 5, WIDTH-28, 41)];
    [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    sendButton.backgroundColor=self.backlable.backgroundColor;
    sendButton.layer.cornerRadius=5;
    if (_pushID==1) {
        [sendButton setTitle:@"确认修改" forState:UIControlStateNormal];
    }else{
        switch (_vcID) {
            case 1001:
            {
                [sendButton setTitle:@"发起会议" forState:UIControlStateNormal];
            }
                break;
            case 1002:
            {
                [sendButton setTitle:@"发起公告" forState:UIControlStateNormal];
            }
                break;
            case 1003:
            {
                [sendButton setTitle:@"事务提醒" forState:UIControlStateNormal];
            }
                break;
            case 1004:
            {
                [sendButton setTitle:@"面试邀约" forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }

    }
    [sendView addSubview:sendButton];
    
}

-(void)msImageViewLayout
{
    msImageView.image=msImages;
    [secretaryView addSubview:msImageView];
}
#pragma mark 灰色线的位置方法
-(void)LineViewLayout
{
    int a=1;
    int  s;
    if (_vcID==1003) {
        s=5;
    }else{
        s=4;
    }
    for (int i=0; i<s; i++) {
        UIView *lineView=[[UIView alloc]init];
        lineView.tag=10010+i;
        lineView.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];

        if (i==0) {
            lineView.frame=FRAME(35/2, 58, WIDTH-35, 1);
        }else if (i==1)
        {
            switch (_vcID) {
                case 1001:
                {
                    H=165;
                    lineView.frame=FRAME(35/2, H, WIDTH-35, 1);
                }
                    break;
                case 1002:
                {
                    H=117;
                    lineView.frame=FRAME(35/2, H, WIDTH-35, 1);
                }
                    break;
                case 1003:
                {
                    H=117;
                    lineView.frame=FRAME(35/2, H, WIDTH-35, 1);
                }
                    break;
                case 1004:
                {
                    H=117;
                    lineView.frame=FRAME(35/2, H, WIDTH-35, 1);
                }
                    break;
                    
                default:
                    break;
            }
            //lineView.frame=FRAME(35/2, 165, WIDTH-35, 1);
        }else
        {
            lineView.frame=FRAME(35/2, H+84/2*a, WIDTH-35, 1);
            a++;
        }
        if (i==4) {
            lineView.hidden=YES;
        }
        [backgroundView addSubview:lineView];
        if (_vcID!=1003) {
            if(clientID==1)
            {
                backgroundView.frame=FRAME(0, 33+15/2, WIDTH,lineView.frame.origin.y+86/2);
            }else{
                backgroundView.frame=FRAME(0, 15/2, WIDTH,lineView.frame.origin.y+86/2);
            }

        }
        
    }
    if (_vcID==1003) {
        if (upButInt%2!=0) {
            if(clientID==1)
            {
                backgroundView.frame=FRAME(0, 33+15/2, WIDTH,H+(84/2*3)+86/2);
            }else{
                backgroundView.frame=FRAME(0, 15/2, WIDTH,H+(84/2*3)+86/2);
            }
        }else{
            if(clientID==1)
            {
                backgroundView.frame=FRAME(0, 33+15/2, WIDTH,H+(84/2*0)+86/2);
            }else{
                backgroundView.frame=FRAME(0, 15/2, WIDTH,H+(84/2*0)+86/2);
            }
        }
        

    }
    
}

#pragma mark 页面显示view的相关布局
-(void)labelViewLayout
{
    int a=0;
    NSArray *array=[[NSArray alloc]init];
    switch (_vcID) {
        case 1001:
        {
            
            array=@[@"会议内容",@"提醒设置",@"立即给相关人员消息"];
        }
            break;
        case 1002:
        {
            
            array=@[@"公告内容",@"提醒设置",@"立即给相关人员消息"];
        }
            break;
        case 1003:
        {
            array=@[@"提醒内容",@"提醒设置",@"重复周期",@"立即给相关人员消息"];
            
        }
            break;
        case 1004:
        {
            array=@[@"邀约内容",@"提醒设置",@"立即给相关人员消息"];
            
        }
            break;
            
        default:
            break;
    }

    NSArray *imageArray;//=@[@"",@"",@"HYAP_TX_TB_@2x",@"CLGH_TX_TB_@2x",@"HYAP_XG_TB_@2x"];
    int i_id;
    if (_vcID==1003) {
        i_id=6;
        imageArray=@[@"",@"",@"HYAP_TX_TB_@2x",@"CLGH_TX_TB_@2x",@"周期出租",@"HYAP_XG_TB_@2x"];
    }else{
        i_id=5;
        imageArray=@[@"",@"",@"HYAP_TX_TB_@2x",@"CLGH_TX_TB_@2x",@"HYAP_XG_TB_@2x"];
    }
    for (int i=0; i<i_id; i++) {
        UIView *labelView=[[UIView alloc]init];
        labelView.tag=1000+i;
        if (i==0) {
            labelView.frame=FRAME(35/2, 0, WIDTH-35, 58);
            
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapParticipationAction)];
            [labelView addGestureRecognizer:tap];
            
            
            UILabel *titleLabel=[[UILabel alloc]init];
            switch (_vcID) {
                case 1001:
                {
                   titleLabel.text=@"参会人员";
                }
                    break;
                case 1002:
                {
                    titleLabel.text=@"通知人员";
                }
                    break;
                case 1003:
                {
                    titleLabel.text=@"提醒人员";
                }
                    break;
                case 1004:
                {
                    titleLabel.text=@"邀约人员";
                }
                    break;
                    
                default:
                    break;
            }

            UIImageView *jTImageView=[[UIImageView alloc]initWithFrame:FRAME(labelView.frame.size.width-20, (58-15)/2, 15, 15)];
            jTImageView.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
            [labelView addSubview:jTImageView];
            titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
            [titleLabel setNumberOfLines:0];
            [titleLabel sizeToFit];
            titleLabel.frame=FRAME(6/2, 20, titleLabel.frame.size.width, 14);
            titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
            [labelView addSubview:titleLabel];
            UILabel *chooseLabel=[[UILabel alloc]init];
            chooseLabel.frame=FRAME(6/2,34+17/2, 40, 11);
            chooseLabel.text=@"已选择:";
            chooseLabel.font=[UIFont fontWithName:@"Heiti SC" size:11];
            chooseLabel.textColor=[UIColor colorWithRed:164/255.0f green:164/255.0f blue:164/255.0f alpha:1];
            [labelView addSubview:chooseLabel];
            selectLabel=[[UILabel alloc]init];
            numberLabel=[[UILabel alloc]init];
            [self ParticipationLabelLayout];
            
        }else if (i==1)
        {
            
            switch (_vcID) {
                case 1001:
                {
                    labelView.frame=FRAME(35/2, 59, WIDTH-35, 106);
                }
                    break;
                case 1002:
                {
                    labelView.frame=FRAME(35/2, 59, WIDTH-35, 58);
                }
                    break;
                case 1003:
                {
                    labelView.frame=FRAME(35/2, 59, WIDTH-35, 58);
                }
                    break;
                case 1004:
                {
                    labelView.frame=FRAME(35/2, 59, WIDTH-35, 58);
                }
                    break;
                    
                default:
                    break;
            }

            timeButton=[[UIButton alloc]initWithFrame:FRAME(0, 10, WIDTH-35, 33)];
            [timeButton addTarget:self action:@selector(timeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [timeButton.layer setCornerRadius:8.0]; //设置矩圆角半径
            [timeButton.layer setBorderWidth:1.0];//边框宽度
            timeButton.layer.backgroundColor=[[UIColor colorWithRed:241.0 / 255.0 green:241.0 / 255.0 blue:241.0 / 255.0 alpha:1] CGColor];
            timeButton.layer.cornerRadius=8.0f;
            timeButton.layer.masksToBounds=YES;
            timeButton.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
            timeButton.layer.borderWidth= 1.0f;
            [labelView addSubview:timeButton];
            timeLabel=[[UILabel alloc]init];
            UILabel *inTimeLabel=[[UILabel alloc]init];
            switch (_vcID) {
                case 1001:
                {
                    inTimeLabel.text=@"会议时间";
                }
                    break;
                case 1002:
                {
                    inTimeLabel.text=@"通知时间";
                }
                    break;
                case 1003:
                {
                    inTimeLabel.text=@"提醒时间";
                }
                    break;
                case 1004:
                {
                    inTimeLabel.text=@"邀约时间";
                }
                    break;
                    
                default:
                    break;
            }

            
            inTimeLabel.lineBreakMode=NSLineBreakByTruncatingTail;
            [inTimeLabel setNumberOfLines:0];
            [inTimeLabel sizeToFit];
            inTimeLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
            inTimeLabel.frame=FRAME(10, 10, inTimeLabel.frame.size.width, timeButton.frame.size.height-20);
            [timeButton addSubview:inTimeLabel];
            UIImageView *timeImg=[[UIImageView alloc]initWithFrame:FRAME(timeButton.frame.size.width-20, (33-15)/2, 15, 15)];
            timeImg.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
            [timeButton addSubview:timeImg];
            
            
            placeButton=[[UIButton alloc]initWithFrame:FRAME(0, 53, WIDTH-35, 33)];
            switch (_vcID) {
                case 1001:
                {
                    placeButton.hidden=NO;
                }
                    break;
                case 1002:
                {
                    placeButton.hidden=YES;
                }
                    break;
                case 1003:
                {
                    placeButton.hidden=YES;                }
                    break;
                case 1004:
                {
                    placeButton.hidden=YES;
                }
                    break;
                    
                default:
                    break;
            }
            [placeButton.layer setCornerRadius:8.0]; //设置矩圆角半径
            [placeButton.layer setBorderWidth:1.0];//边框宽度
            placeButton.layer.backgroundColor=[[UIColor colorWithRed:241.0 / 255.0 green:241.0 / 255.0 blue:241.0 / 255.0 alpha:1] CGColor];
            placeButton.layer.cornerRadius=8.0f;
            placeButton.layer.masksToBounds=YES;
            placeButton.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
            placeButton.layer.borderWidth= 1.0f;
            [labelView addSubview:placeButton];
            
            UIImageView *placeImg=[[UIImageView alloc]initWithFrame:FRAME(placeButton.frame.size.width-20, (33-15)/2, 15, 15)];
            placeImg.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
            [placeButton addSubview:placeImg];
            
            placeLabel=[[UILabel alloc]init];
            UILabel *plaLabel=[[UILabel alloc]init];
            plaLabel.text=@"会议地点";
            plaLabel.lineBreakMode=NSLineBreakByTruncatingTail;
            [plaLabel setNumberOfLines:0];
            [plaLabel sizeToFit];
            plaLabel.frame=FRAME(10, 10, plaLabel.frame.size.width, placeButton.frame.size.height-20);
            plaLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
            [placeButton addSubview:plaLabel];
            meetingField=[[UITextField alloc]initWithFrame:FRAME(65, 1.5, placeButton.frame.size.width-145, 30)];
            meetingField.delegate=self;
//            meetingField.layer.cornerRadius=8.0f;
//            meetingField.layer.masksToBounds=YES;
//            meetingField.layer.borderColor=[[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1]CGColor];
//            meetingField.layer.borderWidth= 1.0f;
            UIButton *meeting_roomBut=[[UIButton alloc]initWithFrame:FRAME(placeButton.frame.size.width-62, (33-25)/2, 60, 25)];
            [meeting_roomBut.layer setCornerRadius:25/2]; //设置矩圆角半径
            [meeting_roomBut.layer setBorderWidth:1.0];//边框宽度
            meeting_roomBut.layer.backgroundColor=[[UIColor colorWithRed:241.0 / 255.0 green:241.0 / 255.0 blue:241.0 / 255.0 alpha:1] CGColor];
            meeting_roomBut.layer.cornerRadius=25/2;
            meeting_roomBut.layer.masksToBounds=YES;
            meeting_roomBut.layer.borderColor = [[UIColor colorWithRed:190 / 255.0 green:190 / 255.0 blue:190 / 255.0 alpha:1] CGColor];
            meeting_roomBut.layer.borderWidth= 1.0f;
            [meeting_roomBut setTitle:@"会议室" forState:UIControlStateNormal];
            [meeting_roomBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            meeting_roomBut.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
            [meeting_roomBut addTarget:self action:@selector(meeting_roomBut) forControlEvents:UIControlEventTouchUpInside];
            [placeButton addSubview:meeting_roomBut];
            if (textFieldString==nil||textFieldString==NULL) {
                meetingField.placeholder = @"请输入地址！";
            }else{
                meetingField.text=textFieldString;
            }
            
            meetingField.font=[UIFont fontWithName:@"Heiti SC" size:13];
            [placeButton addSubview:meetingField];
            [self timeLabelLayout];
            
            
        }else
        {
            if (_vcID==1003) {
                if (i!=2) {
                    if (upButInt%2!=0) {
                        labelView.hidden=NO;
                    }else{
                        labelView.hidden=YES;
                    }
                    
                }
            }
            
            labelView.frame=FRAME(35/2, H+1+86/2*a, WIDTH-35, 84/2);
            UIImageView *headimageView=[[UIImageView alloc]init];
            if (i==3) {
                headimageView.frame=CGRectMake(2, 25/2, 32/2, 32/2);
            }else{
                headimageView.frame=CGRectMake(2, 25/2, 20, 32/2);
            }
            
            headimageView.image=[UIImage imageNamed:imageArray[i]];
            //headimageView.backgroundColor=[UIColor redColor];
            [labelView addSubview:headimageView];
            
            UILabel *label=[[UILabel alloc]init];
            label.frame=CGRectMake(headimageView.frame.origin.x+30, 23/2, label.frame.size.width, 32/2);
            label.text=array[a];
            label.lineBreakMode=NSLineBreakByTruncatingTail;
            [label sizeToFit];
            label.font=[UIFont fontWithName:@"Heiti SC" size:14];
            [labelView addSubview:label];
            if (i==2) {
                contentLabel=[[UILabel alloc]initWithFrame:FRAME(label.frame.size.width+label.frame.origin.x+5,23/2, labelView.frame.size.width-(label.frame.size.width+label.frame.origin.x+5), labelView.frame.size.height-22)];
                //contentLabel.backgroundColor=[UIColor brownColor];
                [labelView addSubview:contentLabel];
                [self contentLabelLayout];
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapContentAction)];
                [labelView addGestureRecognizer:tap];
                
                UIImageView *labelImg=[[UIImageView alloc]initWithFrame:FRAME(labelView.frame.size.width-20, (42-15)/2, 15, 15)];
                labelImg.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
                [labelView addSubview:labelImg];
                
            }
            if (i==3) {
                meetingLabel=[[UILabel alloc]init];
                [self labelLayout];
                UIImageView *labelImg=[[UIImageView alloc]initWithFrame:FRAME(labelView.frame.size.width-20, (42-15)/2, 15, 15)];
                labelImg.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
                [labelView addSubview:labelImg];
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRemindAction)];
                [labelView addGestureRecognizer:tap];
                if (_pushID==1) {
                    int reminId=[[dic objectForKey:@"set_remind"]intValue];
                    if (reminId==0) {
                        meetingString=@"不提醒";
                    }else if (reminId==1){
                        meetingString=@"按时提醒";
                    }else if (reminId==2){
                        meetingString=@"提前5分钟";
                    }else if (reminId==3){
                        meetingString=@"提前15分钟";
                    }else if (reminId==4){
                        meetingString=@"提前30分钟";
                    }else if (reminId==5){
                        meetingString=@"提前1小时";
                    }else if (reminId==6){
                        meetingString=@"提前2小时";
                    }else if (reminId==7){
                        meetingString=@"提前6小时";
                    }else if (reminId==8){
                        meetingString=@"提前1天";
                    }else if (reminId==9){
                        meetingString=@"提前2天";
                    }
                }else{
                   meetingString=@"按时提醒";
                }
                
                [self remindLabelLayout];
                
            }
            if (i==4)
            {
                if (_vcID==1003) {
                    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loopPickerAction)];
                    [labelView addGestureRecognizer:tap];
                    UIImageView *labelImg=[[UIImageView alloc]initWithFrame:FRAME(labelView.frame.size.width-20, (42-15)/2, 15, 15)];
                    labelImg.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
                    [labelView addSubview:labelImg];
                    loopLabel=[[UILabel alloc]initWithFrame:FRAME(label.frame.size.width+label.frame.origin.x, 23/2, labelView.frame.size.width-(label.frame.size.width+label.frame.origin.x+20), 32/2)];
                    loopLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
                    loopLabel.textAlignment=NSTextAlignmentRight;
                    [labelView addSubview:loopLabel];
                    [self looplabelLayout];
                }else{
                    switchButton=[[DCRoundSwitch alloc]initWithFrame:CGRectMake(labelView.frame.size.width-50, 44/4, 50, 42/2)];
                    int set_now_send=[[dic objectForKey:@"set_now_send"]intValue];
                    if (_pushID==1) {
                        if (set_now_send==0) {
                            switchButton.on=NO;
                        }else{
                            switchButton.on=YES;
                        }
                    }else{
                        if (mscl==0) {
                            switchButton.on=NO;
                        }else{
                            switchButton.on=YES;
                        }
                    }
                    
                    
                    switchButton.ID=1;
                    [switchButton addTarget:self action:@selector(switchButAction:) forControlEvents:UIControlEventValueChanged];
                    switchButton.onText = @"YES"; //NSLocalizedString(@"YES", @"");
                    switchButton.offText = @"NO";//NSLocalizedString(@"NO", @"");
                    [labelView addSubview:switchButton];
                }
                
            }
            if (i==5) {
                switchButton=[[DCRoundSwitch alloc]initWithFrame:CGRectMake(labelView.frame.size.width-50, 44/4, 50, 42/2)];
                int set_now_send=[[dic objectForKey:@"set_now_send"]intValue];
                if (_pushID==1) {
                    if (set_now_send==0) {
                        switchButton.on=NO;
                    }else{
                        switchButton.on=YES;
                    }
                }else{
                    if (mscl==0) {
                        switchButton.on=NO;
                    }else{
                        switchButton.on=YES;
                    }
                }
                
                
                switchButton.ID=1;
                [switchButton addTarget:self action:@selector(switchButAction:) forControlEvents:UIControlEventValueChanged];
                switchButton.onText = @"YES"; //NSLocalizedString(@"YES", @"");
                switchButton.offText = @"NO";//NSLocalizedString(@"NO", @"");
                [labelView addSubview:switchButton];
            }
            a++;
        }
        //labelView.backgroundColor=[UIColor redColor];
        [backgroundView addSubview:labelView];
    }
}
-(void)meeting_roomBut
{
    meetingVC=[[Meeting_roomButViewController alloc]init];
    meetingVCid=100;
    [self.navigationController pushViewController:meetingVC animated:YES];
}
#pragma mark参会人员及个数label显示
-(void)ParticipationLabelLayout
{
    //selectString=@"白 ,马";
    selectLabel.text=selectString;
    selectLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [selectLabel setNumberOfLines:1];
    [selectLabel sizeToFit];
    selectLabel.frame=FRAME(41/2+40,34+17/2,WIDTH-41/2-50,11);
    selectLabel.font=[UIFont fontWithName:@"Heiti SC" size:11];
    selectLabel.textColor=[UIColor colorWithRed:164/255.0f green:164/255.0f blue:164/255.0f alpha:1];
    [backgroundView addSubview:selectLabel];
    
    //numberString=@"3位";
    numberLabel.text=numberString;
    numberLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [numberLabel setNumberOfLines:0];
    [numberLabel sizeToFit];
    numberLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    numberLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    numberLabel.frame=FRAME(WIDTH-99/2-numberLabel.frame.size.width, 20, numberLabel.frame.size.width, 14);
    [backgroundView addSubview:numberLabel];
}
#pragma mark会议时间label显示
-(void)timeLabelLayout
{
    //timeString=@"2015/08/11  16:16";
    timeLabel.text=timeString;
    timeLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [timeLabel setNumberOfLines:1];
    [timeLabel sizeToFit];
    timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    timeLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    timeLabel.frame=FRAME(65, 10, timeLabel.frame.size.width, 14);
    timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
    [timeButton addSubview:timeLabel];
}
#pragma mark会议地点文本显示
-(void)addressLabelLayout
{
    placeString=@"宇飞大厦";
    placeLabel.text=placeString;
    placeLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [placeLabel setNumberOfLines:0];
    [placeLabel sizeToFit];
    placeLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    placeLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    placeLabel.frame=FRAME(65, 10, placeLabel.frame.size.width, 14);
    placeLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
    [placeButton addSubview:placeLabel];

}
#pragma mark会议内容文本显示
-(void)contentLabelLayout
{
    
    contentLabel.text=contentString;
    contentLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    
}
#pragma mark提醒设置label显示
-(void)remindLabelLayout
{
    meetingLabel.text=meetingString;
    meetingLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
    meetingLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [meetingLabel setNumberOfLines:1];
    [meetingLabel sizeToFit];
    //meetingLabel.backgroundColor=[UIColor redColor];
    meetingLabel.frame=FRAME(WIDTH-meetingLabel.frame.size.width-75/2, H+84/2+(42-32/2)/2, meetingLabel.frame.size.width, 32/2);
    [backgroundView addSubview:meetingLabel];
}

#pragma mark textView的自适应
-(void)labelLayout
{
    
//    if ([remarksString isEqual:@""]||remarksString==NULL) {
//        textID=0;
//    }else
//    {
//        textID=1;
//    }
//    //NSLog(@"日了 %@",remarksString);
//    //NSString *desContent=remarksString;
//    if (textID==1) {
//        CGRect orgRect=remarksView.frame;//获取原始UITextView的frame
//        CGSize  size = [remarksString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240, 100) lineBreakMode:0];
//        
//        orgRect.size.height=size.height+10;//获取自适应文本内容高度
//        remarksView.frame=orgRect;//重设UITextView的frame
//    }
    //remarksView.text=remarksString;
    
}
#pragma mark 循环按钮点击方法
-(void)loopPickerAction
{
    if (timeString==NULL||timeString==nil||[timeString length]==0) {
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"你还没有选择时间，请选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [tsView show];
        
    }else{
        if([nameArray containsObject:@"自己"]&&nameArray.count==1){
            if([meetingString isEqualToString:@"不提醒"])
            {
                UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"提醒设置为“不提醒”，没有闹钟不可设置重复周期！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [tsView show];
            }else{
                [loopPicker removeFromSuperview];
                
                loopPicker=[[LoopPicker alloc]initWithFrame:FRAME(0, HEIGHT, WIDTH, 220)];
                loopPicker.timeString=timeString;
                loopPicker.delegate=self;
                [self.view addSubview:loopPicker];
                [UIView beginAnimations: @"Animation" context:nil];
                [UIView setAnimationDuration:0.3];
                
                loopPicker.frame = CGRectMake(0, HEIGHT-220, WIDTH, 220);
                meetingDatePicker.frame=FRAME(0, HEIGHT, WIDTH, 250);
                picker.frame = CGRectMake(0, HEIGHT, WIDTH, 220);
                [UIView commitAnimations];
            }
            
        }else{
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"只有单独给自己设置闹钟在可以设置重复周期哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
        }
        
    }
    
}

#pragma mark 循环按钮选择器代理方法
-(void)closePicker
{
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    loopPicker.frame=FRAME(0, HEIGHT, WIDTH, 220);
    [UIView commitAnimations];
}
-(void)loopHours:(NSString *)hours
{
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    loopPicker.frame=FRAME(0, HEIGHT, WIDTH, 220);
    loopString=hours;
    [self loopLayout:loopString];
    [self looplabelLayout];
    [UIView commitAnimations];
}
-(void)looplabelLayout
{
    loopLabel.text=loopString;
}
#pragma mark 开关按钮switchBut的点击相应事件方法
-(void)switchAction:(id)sender
{
    if (periodID==0) {
        ClerkViewController *seekVC=[[ClerkViewController alloc]init];
        seekVC.service_type_id=@"75";
        [self.navigationController pushViewController:seekVC animated:YES];
    }else{
        switchButton.ID=1;
        UISwitch *switchBuT=(UISwitch *)sender;
        if (switchBuT.isOn) {
            whether_to_send=1;
            switchId=@"YES";
            label1.hidden=NO;
            msImages=[UIImage imageNamed:@"chuli"];
            [self switchButAction:@"YES"];
        }else
        {
            switchId=@"NO";
            label1.hidden=YES;
            whether_to_send=0;
            msImages=[UIImage imageNamed:@"chuli"];
            switchButton.ID=1;

        }
        [self msImageViewLayout];
        switchButID=1;
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
//    SeekViewController *vc=[[SeekViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 开关按钮switchButton的相应事件方法
-(void)switchButAction:(id)sender
{
    
    //UISwitch *switchBuT=(UISwitch *)sender;
    if (switchButton.isOn) {
        mscl=1;
        switchID=@"YES";
        
    }else
    {
        mscl=0;
        switchID=@"NO";
        //switchButton.ID=0;
    }
    switchButID=1;
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    fieldID=1;
    [remarksView resignFirstResponder];
    //[meetingField resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textFieldString=meetingField.text;
    if (textFieldString==nil) {
        meetingField.placeholder = @"请输入地址！";
    }else{
        meetingField.text=textFieldString;
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    fieldID=0;
    //[remarksView resignFirstResponder];
    [meetingField resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    remarksView.frame=CGRectMake(0, HEIGHT-heights-84/2-49-24, WIDTH, 49);
    [UIView commitAnimations];

    
}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    heights = keyboardRect.size.height;
    if (fieldID!=1) {
        [UIView beginAnimations:nil context:nil];
        //设置动画时长
        [UIView setAnimationDuration:0.5];
        remarksView.frame=CGRectMake(0, HEIGHT-heights-84/2-49-24, WIDTH, 49);
        [UIView commitAnimations];
    }
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>=100)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"超过最大字数不能输入了"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        [alert show];
        //[self.view endEditing:YES];
        return  NO;
            }
    else
    {
        return YES;
    }
}
- (void) textViewDidChange:(UITextView *)textView{
    if ([textView.text length] == 0) {
        [textViewLabel setHidden:NO];
    }else{
        [textViewLabel setHidden:YES];
    }
}
#pragma mark点击空白隐藏键盘方法
-(void)tapAction:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    [remarksView resignFirstResponder];
    [meetingField resignFirstResponder];
    remarksView.frame=frame;
    remarksString=remarksView.text;
    [self labelLayout];
    [UIView commitAnimations];
}

#pragma mark TimePicker提醒设置代理方法
- (void)suanle
{
    //sendView.hidden=YES;
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    picker.frame = CGRectMake(0, HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
}

- (void)hours:(NSString *)hours //minutes:(NSString *)minutes
{
    
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    picker.frame = CGRectMake(0, HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
    meetingString=[NSString stringWithFormat:@"%@",hours];
    
    [self remindLabelLayout];
    [self labelLayout];
}

-(void)nazhong
{
    if([meetingString isEqualToString:@"不提醒"])
    {
        
    }else
    {
        //NSString *str=[[NSString alloc]init];
        
        if ([meetingString isEqualToString:@"按时提醒"]) {
            time_ID=0;
        }else if ([meetingString isEqualToString:@"提前5分钟"]){
            time_ID=300;
        }else if ([meetingString isEqualToString:@"提前15分钟"]){
            time_ID=15*60;
        }else if ([meetingString isEqualToString:@"提前30分钟"]){
            time_ID=30*60;
        }else if ([meetingString isEqualToString:@"提前1小时"]){
            time_ID=1*60*60;
        }else if ([meetingString isEqualToString:@"提前2小时"]){
            time_ID=2*60*60;
        }else if ([meetingString isEqualToString:@"提前6小时"]){
            time_ID=6*60*60;
        }else if ([meetingString isEqualToString:@"提前1天"]){
            time_ID=1*24*60*60;
        }else if ([meetingString isEqualToString:@"提前2天"]){
            time_ID=2*24*60*60;
        }
        
        // 初始化本地通知对象
        
    }

    NSString *str=[NSString stringWithFormat:@"%@",timeString];
    if (timeString==NULL||timeString==nil||[timeString length]==0) {
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"你还没有选择时间，请选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [tsView show];

    }else{
        NSLog(@"时间%@",str);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* dat = [formatter dateFromString:str];
        
        int timeID=[[timeString substringWithRange:NSMakeRange(17,2)] intValue];
        NSLog(@"timeID___%d",timeID);
//        if ([nameArray containsObject:@"自己"]) {
//            UILocalNotification *notification=[[UILocalNotification alloc] init];
//            if (notification!=nil) {
//                
//                //NSDate *now=[NSDate new];
//                
//                notification.fireDate=[dat dateByAddingTimeInterval:-(time_ID+timeID)];//10秒后通知
//                
//                notification.repeatInterval=0;//循环次数，kCFCalendarUnitWeekday一周一次
//                
//                notification.timeZone=[NSTimeZone defaultTimeZone];
//                
//                notification.applicationIconBadgeNumber=1; //应用的红色数字
//                
//                
//                notification.soundName=@"simivoice.caf";//声音，可以换成alarm.soundName = @"myMusic.caf"
//                
//                //去掉下面2行就不会弹出提示框
//                notification.alertTitle=self.navlabel.text;
//                notification.alertBody=contentString;//提示信息 弹出提示框
//                
//                notification.alertAction = @"打开";  //提示框按钮
//                
//                //notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
//                
//                
//                
//                // NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
//                
//                //notification.userInfo = infoDict; //添加额外的信息
//                
//                
//                
//                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//                
//            }
//
//        }
    }
    
}

#pragma mark点击会议参与人员的响应方法
-(void)tapParticipationAction
{
    [self meetingDateQuxiao];
    [self suanle];
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    [remarksView resignFirstResponder];
    [meetingField resignFirstResponder];
    remarksView.frame=frame;
    remarksString=remarksView.text;
    [self labelLayout];
    [UIView commitAnimations];
    viewVC=[[RelevantPersonnelViewController alloc]init];
    viewVC.dataMutableArray=mutableArray;
    viewVC.dataNameArray=nameArray;
    viewVC.dataMobileArray=mobileArray;
    viewVC.dataIdArray=idArray;
    releID=100;
    [self.navigationController pushViewController:viewVC animated:YES];
     push_IDSSS=100;
    
}

#pragma mark点击会议内容的响应方法
-(void)tapContentAction
{
     push_IDSSS=100;
    [self meetingDateQuxiao];
    [self suanle];
    [UIView setAnimationDuration:0.5];
    [remarksView resignFirstResponder];
    [meetingField resignFirstResponder];
    remarksView.frame=frame;
    remarksString=remarksView.text;
    [self labelLayout];
    [UIView commitAnimations];
    viewController=[[ConTentViewController alloc]init];
    viewController.textString=contentString;
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark点击提醒设置的响应方法
-(void)tapRemindAction
{
    if (timeString==NULL||timeString==nil||[timeString length]==0) {
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"你还没有选择时间，请选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [tsView show];
        
    }else{
        //        datePicker.backgroundColor = [UIColor grayColor];
        [UIView beginAnimations: @"Animation" context:nil];
        [UIView setAnimationDuration:0.3];
        picker.frame = CGRectMake(0, HEIGHT-220, WIDTH, 220);
        meetingDatePicker.frame=FRAME(0, HEIGHT, WIDTH, 250);
        loopPicker.frame=FRAME(0, HEIGHT, WIDTH, 220);
        [UIView commitAnimations];
    }
    
}
#pragma mark会议时间点击方法
-(void)timeButtonAction:(id)sender
{
    
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    [remarksView resignFirstResponder];
    [meetingField resignFirstResponder];
    remarksView.frame=frame;
    meetingDatePicker.frame=FRAME(0, HEIGHT-250, WIDTH, 250);
    loopPicker.frame=FRAME(0, HEIGHT, WIDTH, 220);
    picker.frame = CGRectMake(0, HEIGHT, WIDTH, 220);
    [UIView commitAnimations];
}
#pragma mark 会议时间选择器代理方法
-(void)meetingDateQuxiao
{
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    meetingDatePicker.frame=FRAME(0, HEIGHT, WIDTH, 250);
    [UIView commitAnimations];
}
-(void)meetingDateQueding:(NSString *)date
{
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    meetingDatePicker.frame=FRAME(0, HEIGHT, WIDTH, 250);
    timeString=date;
    [self timeLabelLayout];
    [UIView commitAnimations];
}

#pragma mark 发起任务请求按钮点击方法
-(void)sendAction:(UIButton *)sender
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
    //当前时间第一个时间段
    NSString *theFirstTime1=[NSString stringWithFormat:@"%@ 00:01:00",[locationString substringWithRange:NSMakeRange(0,10)]];
    NSDateFormatter *theFirstformatte1 = [[NSDateFormatter alloc] init];
    [theFirstformatte1 setDateStyle:NSDateFormatterMediumStyle];
    [theFirstformatte1 setTimeStyle:NSDateFormatterShortStyle];
    [theFirstformatte1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* theFirstdate1 = [theFirstformatte1 dateFromString:theFirstTime1];
    int theFirst1 = [theFirstdate1 timeIntervalSince1970]*1;
    
    NSString *theFirstTime2=[NSString stringWithFormat:@"%@ 15:00:00",[locationString substringWithRange:NSMakeRange(0,10)]];
    NSDateFormatter *theFirstformatte2 = [[NSDateFormatter alloc] init];
    [theFirstformatte2 setDateStyle:NSDateFormatterMediumStyle];
    [theFirstformatte2 setTimeStyle:NSDateFormatterShortStyle];
    [theFirstformatte2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* theFirstdate2 = [theFirstformatte2 dateFromString:theFirstTime2];
    int theFirst2 = [theFirstdate2 timeIntervalSince1970]*1;
    NSLog(@"时间%@,%@",theFirstTime1,theFirstTime2);
    //当前时间第二个时间段
    NSString *theTwoTime1=[NSString stringWithFormat:@"%@ 15:01:00",[locationString substringWithRange:NSMakeRange(0,10)]];
    NSDateFormatter *theTwoformatte1 = [[NSDateFormatter alloc] init];
    [theTwoformatte1 setDateStyle:NSDateFormatterMediumStyle];
    [theTwoformatte1 setTimeStyle:NSDateFormatterShortStyle];
    [theTwoformatte1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* theTwotdate1 = [theTwoformatte1 dateFromString:theTwoTime1];
    int theTwo1 = [theTwotdate1 timeIntervalSince1970]*1;
    
    NSString *theTwoTime2=[NSString stringWithFormat:@"%@ 00:00:00",[locationString substringWithRange:NSMakeRange(0,10)]];
    NSDateFormatter *theTwoformatte2 = [[NSDateFormatter alloc] init];
    [theTwoformatte2 setDateStyle:NSDateFormatterMediumStyle];
    [theTwoformatte2 setTimeStyle:NSDateFormatterShortStyle];
    [theTwoformatte2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* theTwodate2 = [theTwoformatte2 dateFromString:theTwoTime2];
    int theTwo2 = [theTwodate2 timeIntervalSince1970]*1;
    
    //当前时间第三个时间段
    NSString *theThreeTime1=[NSString stringWithFormat:@"%@ 00:00:00",[locationString substringWithRange:NSMakeRange(0,10)]];
    NSDateFormatter *theThreeformatte1 = [[NSDateFormatter alloc] init];
    [theThreeformatte1 setDateStyle:NSDateFormatterMediumStyle];
    [theThreeformatte1 setTimeStyle:NSDateFormatterShortStyle];
    [theThreeformatte1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* theThreedate1 = [theThreeformatte1 dateFromString:theThreeTime1];
    NSTimeInterval theThree1 = [theThreedate1 timeIntervalSince1970]*1;
    
    NSString *theThreeTime2=[NSString stringWithFormat:@"%@ 23:59:00",[locationString substringWithRange:NSMakeRange(0,10)]];
    NSDateFormatter *theThreeformatte2 = [[NSDateFormatter alloc] init];
    [theThreeformatte2 setDateStyle:NSDateFormatterMediumStyle];
    [theThreeformatte2 setTimeStyle:NSDateFormatterShortStyle];
    [theThreeformatte2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* theThreedate2 = [theThreeformatte2 dateFromString:theThreeTime2];
    NSTimeInterval theThree2 = [theThreedate2 timeIntervalSince1970]*1;
    
    //当前时间的日期
    NSString *theDateString=[locationString substringWithRange:NSMakeRange(0,10)];
    NSDateFormatter *theDateformatte = [[NSDateFormatter alloc] init];
    [theDateformatte setDateStyle:NSDateFormatterMediumStyle];
    [theDateformatte setTimeStyle:NSDateFormatterShortStyle];
    [theDateformatte setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* theDate = [theDateformatte dateFromString:theDateString];
    int theDateint = [theDate timeIntervalSince1970]*1;
    
    //----------------------------提醒时间---------
    
    
    
    
    
    if (clientID==1) {
        if (nameString==nil||nameString==NULL) {
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"给谁创建不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if (selectString==nil||selectString==NULL) {
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择人员" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if (timeString==nil||timeString==NULL){
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if (meetingField.text==nil||meetingField.text==NULL){
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择会议地点" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if (contentString==nil||contentString==NULL){
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请填写内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if([meetingString isEqualToString:@"不提醒"]){
            if (whether_to_send==1) {
                NSString *str=[NSString stringWithFormat:@"%@",timeString];
                NSLog(@"时间%@",str);
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate* dat = [formatter dateFromString:str];
                int _fitstDate = [dat timeIntervalSince1970]*1;
                
                //提醒时间第一个时间段
                NSString *alertFirstTime1=[NSString stringWithFormat:@"%@ 11:00:00",[str substringWithRange:NSMakeRange(0,10)]];
                NSDateFormatter *alertFirstformatte1 = [[NSDateFormatter alloc] init];
                [alertFirstformatte1 setDateStyle:NSDateFormatterMediumStyle];
                [alertFirstformatte1 setTimeStyle:NSDateFormatterShortStyle];
                [alertFirstformatte1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate* alertFirstdate1 = [alertFirstformatte1 dateFromString:alertFirstTime1];
                int alertFirst1 = [alertFirstdate1 timeIntervalSince1970]*1;
                
                NSString *alertFirstTime2=[NSString stringWithFormat:@"%@ 19:00:00",[str substringWithRange:NSMakeRange(0,10)]];
                NSDateFormatter *alertFirstformatte2 = [[NSDateFormatter alloc] init];
                [alertFirstformatte2 setDateStyle:NSDateFormatterMediumStyle];
                [alertFirstformatte2 setTimeStyle:NSDateFormatterShortStyle];
                [alertFirstformatte2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate* alertFirstdate2 = [alertFirstformatte2 dateFromString:alertFirstTime2];
                int alertFirst2 = [alertFirstdate2 timeIntervalSince1970]*1;
                
                //提醒时间第二个时间段
                NSString *alertTwoTime1=[NSString stringWithFormat:@"%@ 07:00:00",[str substringWithRange:NSMakeRange(0,10)]];
                NSDateFormatter *alertTwoformatte1 = [[NSDateFormatter alloc] init];
                [alertTwoformatte1 setDateStyle:NSDateFormatterMediumStyle];
                [alertTwoformatte1 setTimeStyle:NSDateFormatterShortStyle];
                [alertTwoformatte1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate* alertTwodate1 = [alertTwoformatte1 dateFromString:alertTwoTime1];
                int alertTwo1 = [alertTwodate1 timeIntervalSince1970]*1;
                
                NSString *alertTwoTime2=[NSString stringWithFormat:@"%@ 19:00:00",[str substringWithRange:NSMakeRange(0,10)]];
                NSDateFormatter *alertTwoformatte2 = [[NSDateFormatter alloc] init];
                [alertTwoformatte2 setDateStyle:NSDateFormatterMediumStyle];
                [alertTwoformatte2 setTimeStyle:NSDateFormatterShortStyle];
                [alertTwoformatte2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate* alertTwodate2 = [alertTwoformatte2 dateFromString:alertTwoTime2];
                int alertTwo2 = [alertTwodate2 timeIntervalSince1970]*1;
                
                //提醒时间第三个时间段
                NSString *alertThreeTime1=[NSString stringWithFormat:@"%@ 07:00:00",[str substringWithRange:NSMakeRange(0,10)]];
                NSDateFormatter *alertThreeformatte1 = [[NSDateFormatter alloc] init];
                [alertThreeformatte1 setDateStyle:NSDateFormatterMediumStyle];
                [alertThreeformatte1 setTimeStyle:NSDateFormatterShortStyle];
                [alertThreeformatte1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate* alertThreedate1 = [alertThreeformatte1 dateFromString:alertThreeTime1];
                NSTimeInterval alertThree1 = [alertThreedate1 timeIntervalSince1970]*1;
                
                NSString *alertThreeTime2=[NSString stringWithFormat:@"%@ 19:00:00",[str substringWithRange:NSMakeRange(0,10)]];
                NSDateFormatter *alertThreeformatte2 = [[NSDateFormatter alloc] init];
                [alertThreeformatte2 setDateStyle:NSDateFormatterMediumStyle];
                [alertThreeformatte2 setTimeStyle:NSDateFormatterShortStyle];
                [alertThreeformatte2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate* alertThreedate2 = [alertThreeformatte2 dateFromString:alertThreeTime2];
                NSTimeInterval alertThree2 = [alertThreedate2 timeIntervalSince1970]*1;
                
                
                //提醒时间的日期
                NSString *alertDateString=[str substringWithRange:NSMakeRange(0,10)];
                NSDateFormatter *alertDateformatte = [[NSDateFormatter alloc] init];
                [alertDateformatte setDateStyle:NSDateFormatterMediumStyle];
                [alertDateformatte setTimeStyle:NSDateFormatterShortStyle];
                [alertDateformatte setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate* alertDate = [alertDateformatte dateFromString:alertDateString];
                int alertDateint = [alertDate timeIntervalSince1970]*1;
                NSLog(@"当前时间1%d，当亲时间%f，当前时间2%d",theFirst1,_secondDate,theFirst2);
                if(theFirst1<=_secondDate && _secondDate<=theFirst2 && alertFirst1<=_fitstDate && _fitstDate<=alertFirst2)
                {
                    if((_fitstDate-_secondDate)>=4*3600){
                        [self CardCreationLayout];
                    }else{
                        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"您给秘书预留的时间过短，至少要预留出4小时的时间哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [tsView show];
                    }

                    
                    
                }else if(theTwo1<=_secondDate && _secondDate<=theTwo2 && alertTwo1<=_fitstDate && _fitstDate<=alertTwo2)
                {
                    int dat=theDateint-alertDateint;
                    NSLog(@"时间差值%d",dat);
                    if (dat%86400==0) {
                        [self CardCreationLayout];
                    }else{
                        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"提示：秘书工作时间为7:00～19:00，请在此时间内设置秘书提醒时间，0:01—15:00可以设置当天11:00之后的提醒；15:00至0:00可以设置次日7:00之后的提醒." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [tsView show];
                    }
                }else if (theThree1<=_secondDate && _secondDate<=theThree2 && alertThree1<=_fitstDate && _fitstDate<=alertThree2){
                    int dat=theDateint-alertDateint;
                    NSLog(@"时间差值%d",dat);
                    if (dat%86400==0) {
                        [self CardCreationLayout];
                    }else{
                        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"提示：秘书工作时间为7:00～19:00，请在此时间内设置秘书提醒时间，0:01—15:00可以设置当天11:00之后的提醒；15:00至0:00可以设置次日7:00之后的提醒." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [tsView show];
                    }

                }else{
                    UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"提示：秘书工作时间为7:00～19:00，请在此时间内设置秘书提醒时间，0:01—15:00可以设置当天11:00之后的提醒；15:00至0:00可以设置次日7:00之后的提醒." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [tsView show];
                }

            }else{
                [self CardCreationLayout];
            }
            
        }else{
            //获取当前时间
            //获取当前时间
            NSString *str=[NSString stringWithFormat:@"%@",timeString];
            NSLog(@"时间%@",str);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* dat = [formatter dateFromString:str];
            int _fitstDate = [dat timeIntervalSince1970]*1;
            
            //提醒时间第一个时间段
            NSString *alertFirstTime1=[NSString stringWithFormat:@"%@ 11:00:00",[str substringWithRange:NSMakeRange(0,10)]];
            NSDateFormatter *alertFirstformatte1 = [[NSDateFormatter alloc] init];
            [alertFirstformatte1 setDateStyle:NSDateFormatterMediumStyle];
            [alertFirstformatte1 setTimeStyle:NSDateFormatterShortStyle];
            [alertFirstformatte1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* alertFirstdate1 = [alertFirstformatte1 dateFromString:alertFirstTime1];
            int alertFirst1 = [alertFirstdate1 timeIntervalSince1970]*1;
            
            NSString *alertFirstTime2=[NSString stringWithFormat:@"%@ 19:00:00",[str substringWithRange:NSMakeRange(0,10)]];
            NSDateFormatter *alertFirstformatte2 = [[NSDateFormatter alloc] init];
            [alertFirstformatte2 setDateStyle:NSDateFormatterMediumStyle];
            [alertFirstformatte2 setTimeStyle:NSDateFormatterShortStyle];
            [alertFirstformatte2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* alertFirstdate2 = [alertFirstformatte2 dateFromString:alertFirstTime2];
            int alertFirst2 = [alertFirstdate2 timeIntervalSince1970]*1;
            
            //提醒时间第二个时间段
            NSString *alertTwoTime1=[NSString stringWithFormat:@"%@ 07:00:00",[str substringWithRange:NSMakeRange(0,10)]];
            NSDateFormatter *alertTwoformatte1 = [[NSDateFormatter alloc] init];
            [alertTwoformatte1 setDateStyle:NSDateFormatterMediumStyle];
            [alertTwoformatte1 setTimeStyle:NSDateFormatterShortStyle];
            [alertTwoformatte1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* alertTwodate1 = [alertTwoformatte1 dateFromString:alertTwoTime1];
            int alertTwo1 = [alertTwodate1 timeIntervalSince1970]*1;
            
            NSString *alertTwoTime2=[NSString stringWithFormat:@"%@ 19:00:00",[str substringWithRange:NSMakeRange(0,10)]];
            NSDateFormatter *alertTwoformatte2 = [[NSDateFormatter alloc] init];
            [alertTwoformatte2 setDateStyle:NSDateFormatterMediumStyle];
            [alertTwoformatte2 setTimeStyle:NSDateFormatterShortStyle];
            [alertTwoformatte2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* alertTwodate2 = [alertTwoformatte2 dateFromString:alertTwoTime2];
            int alertTwo2 = [alertTwodate2 timeIntervalSince1970]*1;
            
            //提醒时间第三个时间段
            NSString *alertThreeTime1=[NSString stringWithFormat:@"%@ 07:00:00",[str substringWithRange:NSMakeRange(0,10)]];
            NSDateFormatter *alertThreeformatte1 = [[NSDateFormatter alloc] init];
            [alertThreeformatte1 setDateStyle:NSDateFormatterMediumStyle];
            [alertThreeformatte1 setTimeStyle:NSDateFormatterShortStyle];
            [alertThreeformatte1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* alertThreedate1 = [alertThreeformatte1 dateFromString:alertThreeTime1];
            NSTimeInterval alertThree1 = [alertThreedate1 timeIntervalSince1970]*1;
            
            NSString *alertThreeTime2=[NSString stringWithFormat:@"%@ 19:00:00",[str substringWithRange:NSMakeRange(0,10)]];
            NSDateFormatter *alertThreeformatte2 = [[NSDateFormatter alloc] init];
            [alertThreeformatte2 setDateStyle:NSDateFormatterMediumStyle];
            [alertThreeformatte2 setTimeStyle:NSDateFormatterShortStyle];
            [alertThreeformatte2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* alertThreedate2 = [alertThreeformatte2 dateFromString:alertThreeTime2];
            NSTimeInterval alertThree2 = [alertThreedate2 timeIntervalSince1970]*1;
            
            
            //提醒时间的日期
            NSString *alertDateString=[str substringWithRange:NSMakeRange(0,10)];
            NSDateFormatter *alertDateformatte = [[NSDateFormatter alloc] init];
            [alertDateformatte setDateStyle:NSDateFormatterMediumStyle];
            [alertDateformatte setTimeStyle:NSDateFormatterShortStyle];
            [alertDateformatte setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* alertDate = [alertDateformatte dateFromString:alertDateString];
            int alertDateint = [alertDate timeIntervalSince1970]*1;
            if(_secondDate-_fitstDate>0){
                
                UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"您选择的日期时间无效，请选择有效时间哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [tsView show];
            }else{
                if (whether_to_send==1) {
                    NSLog(@"当前时间1%d，当亲时间%f，当前时间2%d",theFirst1,_secondDate,theFirst2);
                    if(theFirst1<=_secondDate && _secondDate<=theFirst2 && alertFirst1<=_fitstDate && _fitstDate<=alertFirst2)
                    {
                        if((_fitstDate-_secondDate)>=4*3600){
                            [self CardClockLayout];
                        }else{
                            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"您给秘书预留的时间过短，至少要预留出4小时的时间哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [tsView show];
                        }
                        
                        
                    }else if(theTwo1<=_secondDate && _secondDate<=theTwo2 && alertTwo1<=_fitstDate && _fitstDate<=alertTwo2)
                    {
                        int dat=theDateint-alertDateint;
                        NSLog(@"时间差值%d",dat);
                        if (dat%86400==0) {
                            [self CardClockLayout];
                        }else{
                            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"提示：秘书工作时间为7:00～19:00，请在此时间内设置秘书提醒时间，0:01—15:00可以设置当天11:00之后的提醒；15:00至0:00可以设置次日7:00之后的提醒." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [tsView show];
                        }
                    }else if (theThree1<=_secondDate && _secondDate<=theThree2 && alertThree1<=_fitstDate && _fitstDate<=alertThree2){
                        int dat=theDateint-alertDateint;
                        NSLog(@"时间差值%d",dat);
                        if (dat%86400==0) {
                            [self CardClockLayout];
                        }else{
                            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"提示：秘书工作时间为7:00～19:00，请在此时间内设置秘书提醒时间，0:01—15:00可以设置当天11:00之后的提醒；15:00至0:00可以设置次日7:00之后的提醒." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [tsView show];
                        }
                        
                    }else{
                        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"提示：秘书工作时间为7:00～19:00，请在此时间内设置秘书提醒时间，0:01—15:00可以设置当天11:00之后的提醒；15:00至0:00可以设置次日7:00之后的提醒." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [tsView show];
                    }
                    
                }else{
                    [self CardClockLayout];
                }
                
            }
            
        }

    }else{
        if (selectString==nil||selectString==NULL) {
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择人员" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if (timeString==nil||timeString==NULL){
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if (meetingField.text==nil||meetingField.text==NULL){
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择会议地点" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if (contentString==nil||contentString==NULL){
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请填写内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if([meetingString isEqualToString:@"不提醒"])
        {
            if (whether_to_send==1) {
                NSString *str=[NSString stringWithFormat:@"%@",timeString];
                NSLog(@"时间%@",str);
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate* dat = [formatter dateFromString:str];
                int _fitstDate = [dat timeIntervalSince1970]*1;
                
                //提醒时间第一个时间段
                NSString *alertFirstTime1=[NSString stringWithFormat:@"%@ 11:00:00",[str substringWithRange:NSMakeRange(0,10)]];
                NSDateFormatter *alertFirstformatte1 = [[NSDateFormatter alloc] init];
                [alertFirstformatte1 setDateStyle:NSDateFormatterMediumStyle];
                [alertFirstformatte1 setTimeStyle:NSDateFormatterShortStyle];
                [alertFirstformatte1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate* alertFirstdate1 = [alertFirstformatte1 dateFromString:alertFirstTime1];
                int alertFirst1 = [alertFirstdate1 timeIntervalSince1970]*1;
                
                NSString *alertFirstTime2=[NSString stringWithFormat:@"%@ 19:00:00",[str substringWithRange:NSMakeRange(0,10)]];
                NSDateFormatter *alertFirstformatte2 = [[NSDateFormatter alloc] init];
                [alertFirstformatte2 setDateStyle:NSDateFormatterMediumStyle];
                [alertFirstformatte2 setTimeStyle:NSDateFormatterShortStyle];
                [alertFirstformatte2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate* alertFirstdate2 = [alertFirstformatte2 dateFromString:alertFirstTime2];
                int alertFirst2 = [alertFirstdate2 timeIntervalSince1970]*1;
                
                //提醒时间第二个时间段
                NSString *alertTwoTime1=[NSString stringWithFormat:@"%@ 07:00:00",[str substringWithRange:NSMakeRange(0,10)]];
                NSDateFormatter *alertTwoformatte1 = [[NSDateFormatter alloc] init];
                [alertTwoformatte1 setDateStyle:NSDateFormatterMediumStyle];
                [alertTwoformatte1 setTimeStyle:NSDateFormatterShortStyle];
                [alertTwoformatte1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate* alertTwodate1 = [alertTwoformatte1 dateFromString:alertTwoTime1];
                int alertTwo1 = [alertTwodate1 timeIntervalSince1970]*1;
                
                NSString *alertTwoTime2=[NSString stringWithFormat:@"%@ 19:00:00",[str substringWithRange:NSMakeRange(0,10)]];
                NSDateFormatter *alertTwoformatte2 = [[NSDateFormatter alloc] init];
                [alertTwoformatte2 setDateStyle:NSDateFormatterMediumStyle];
                [alertTwoformatte2 setTimeStyle:NSDateFormatterShortStyle];
                [alertTwoformatte2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate* alertTwodate2 = [alertTwoformatte2 dateFromString:alertTwoTime2];
                int alertTwo2 = [alertTwodate2 timeIntervalSince1970]*1;
                
                //提醒时间第三个时间段
                NSString *alertThreeTime1=[NSString stringWithFormat:@"%@ 07:00:00",[str substringWithRange:NSMakeRange(0,10)]];
                NSDateFormatter *alertThreeformatte1 = [[NSDateFormatter alloc] init];
                [alertThreeformatte1 setDateStyle:NSDateFormatterMediumStyle];
                [alertThreeformatte1 setTimeStyle:NSDateFormatterShortStyle];
                [alertThreeformatte1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate* alertThreedate1 = [alertThreeformatte1 dateFromString:alertThreeTime1];
                NSTimeInterval alertThree1 = [alertThreedate1 timeIntervalSince1970]*1;
                
                NSString *alertThreeTime2=[NSString stringWithFormat:@"%@ 19:00:00",[str substringWithRange:NSMakeRange(0,10)]];
                NSDateFormatter *alertThreeformatte2 = [[NSDateFormatter alloc] init];
                [alertThreeformatte2 setDateStyle:NSDateFormatterMediumStyle];
                [alertThreeformatte2 setTimeStyle:NSDateFormatterShortStyle];
                [alertThreeformatte2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate* alertThreedate2 = [alertThreeformatte2 dateFromString:alertThreeTime2];
                NSTimeInterval alertThree2 = [alertThreedate2 timeIntervalSince1970]*1;
                
                
                //提醒时间的日期
                NSString *alertDateString=[str substringWithRange:NSMakeRange(0,10)];
                NSDateFormatter *alertDateformatte = [[NSDateFormatter alloc] init];
                [alertDateformatte setDateStyle:NSDateFormatterMediumStyle];
                [alertDateformatte setTimeStyle:NSDateFormatterShortStyle];
                [alertDateformatte setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate* alertDate = [alertDateformatte dateFromString:alertDateString];
                int alertDateint = [alertDate timeIntervalSince1970]*1;
                NSLog(@"当前时间1%d，当亲时间%f，当前时间2%d",theFirst1,_secondDate,theFirst2);
                if(theFirst1<=_secondDate && _secondDate<=theFirst2 && alertFirst1<=_fitstDate && _fitstDate<=alertFirst2)
                {
                    if((_fitstDate-_secondDate)>=4*3600){
                        [self CardCreationLayout];
                    }else{
                        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"您给秘书预留的时间过短，至少要预留出4小时的时间哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [tsView show];
                    }
                    
                }else if(theTwo1<=_secondDate && _secondDate<=theTwo2 && alertTwo1<=_fitstDate && _fitstDate<=alertTwo2)
                {
                    int dat=theDateint-alertDateint;
                    NSLog(@"时间差值%d",dat);
                    if (dat%86400==0) {
                        [self CardCreationLayout];
                    }else{
                        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"提示：秘书工作时间为7:00～19:00，请在此时间内设置秘书提醒时间，0:01—15:00可以设置当天11:00之后的提醒；15:00至0:00可以设置次日7:00之后的提醒." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [tsView show];
                    }
                }else if (theThree1<=_secondDate && _secondDate<=theThree2 && alertThree1<=_fitstDate && _fitstDate<=alertThree2){
                    int dat=theDateint-alertDateint;
                    NSLog(@"时间差值%d",dat);
                    if (dat%86400==0) {
                        [self CardCreationLayout];
                    }else{
                        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"提示：秘书工作时间为7:00～19:00，请在此时间内设置秘书提醒时间，0:01—15:00可以设置当天11:00之后的提醒；15:00至0:00可以设置次日7:00之后的提醒." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [tsView show];
                    }
                    
                }else{
                    UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"提示：秘书工作时间为7:00～19:00，请在此时间内设置秘书提醒时间，0:01—15:00可以设置当天11:00之后的提醒；15:00至0:00可以设置次日7:00之后的提醒." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [tsView show];
                }
                
            }else{
                [self CardCreationLayout];
            }

            
        }else{
            //获取当前时间
            NSString *str=[NSString stringWithFormat:@"%@",timeString];
            NSLog(@"时间%@",str);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* dat = [formatter dateFromString:str];
            int _fitstDate = [dat timeIntervalSince1970]*1;
            
            //提醒时间第一个时间段
            NSString *alertFirstTime1=[NSString stringWithFormat:@"%@ 11:00:00",[str substringWithRange:NSMakeRange(0,10)]];
            NSDateFormatter *alertFirstformatte1 = [[NSDateFormatter alloc] init];
            [alertFirstformatte1 setDateStyle:NSDateFormatterMediumStyle];
            [alertFirstformatte1 setTimeStyle:NSDateFormatterShortStyle];
            [alertFirstformatte1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* alertFirstdate1 = [alertFirstformatte1 dateFromString:alertFirstTime1];
            int alertFirst1 = [alertFirstdate1 timeIntervalSince1970]*1;
            
            NSString *alertFirstTime2=[NSString stringWithFormat:@"%@ 19:00:00",[str substringWithRange:NSMakeRange(0,10)]];
            NSDateFormatter *alertFirstformatte2 = [[NSDateFormatter alloc] init];
            [alertFirstformatte2 setDateStyle:NSDateFormatterMediumStyle];
            [alertFirstformatte2 setTimeStyle:NSDateFormatterShortStyle];
            [alertFirstformatte2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* alertFirstdate2 = [alertFirstformatte2 dateFromString:alertFirstTime2];
            int alertFirst2 = [alertFirstdate2 timeIntervalSince1970]*1;
            
            //提醒时间第二个时间段
            NSString *alertTwoTime1=[NSString stringWithFormat:@"%@ 07:00:00",[str substringWithRange:NSMakeRange(0,10)]];
            NSDateFormatter *alertTwoformatte1 = [[NSDateFormatter alloc] init];
            [alertTwoformatte1 setDateStyle:NSDateFormatterMediumStyle];
            [alertTwoformatte1 setTimeStyle:NSDateFormatterShortStyle];
            [alertTwoformatte1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* alertTwodate1 = [alertTwoformatte1 dateFromString:alertTwoTime1];
            int alertTwo1 = [alertTwodate1 timeIntervalSince1970]*1;
            
            NSString *alertTwoTime2=[NSString stringWithFormat:@"%@ 19:00:00",[str substringWithRange:NSMakeRange(0,10)]];
            NSDateFormatter *alertTwoformatte2 = [[NSDateFormatter alloc] init];
            [alertTwoformatte2 setDateStyle:NSDateFormatterMediumStyle];
            [alertTwoformatte2 setTimeStyle:NSDateFormatterShortStyle];
            [alertTwoformatte2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* alertTwodate2 = [alertTwoformatte2 dateFromString:alertTwoTime2];
            int alertTwo2 = [alertTwodate2 timeIntervalSince1970]*1;
            
            //提醒时间第三个时间段
            NSString *alertThreeTime1=[NSString stringWithFormat:@"%@ 07:00:00",[str substringWithRange:NSMakeRange(0,10)]];
            NSDateFormatter *alertThreeformatte1 = [[NSDateFormatter alloc] init];
            [alertThreeformatte1 setDateStyle:NSDateFormatterMediumStyle];
            [alertThreeformatte1 setTimeStyle:NSDateFormatterShortStyle];
            [alertThreeformatte1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* alertThreedate1 = [alertThreeformatte1 dateFromString:alertThreeTime1];
            NSTimeInterval alertThree1 = [alertThreedate1 timeIntervalSince1970]*1;
            
            NSString *alertThreeTime2=[NSString stringWithFormat:@"%@ 19:00:00",[str substringWithRange:NSMakeRange(0,10)]];
            NSDateFormatter *alertThreeformatte2 = [[NSDateFormatter alloc] init];
            [alertThreeformatte2 setDateStyle:NSDateFormatterMediumStyle];
            [alertThreeformatte2 setTimeStyle:NSDateFormatterShortStyle];
            [alertThreeformatte2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* alertThreedate2 = [alertThreeformatte2 dateFromString:alertThreeTime2];
            NSTimeInterval alertThree2 = [alertThreedate2 timeIntervalSince1970]*1;
            
            
            //提醒时间的日期
            NSString *alertDateString=[str substringWithRange:NSMakeRange(0,10)];
            NSDateFormatter *alertDateformatte = [[NSDateFormatter alloc] init];
            [alertDateformatte setDateStyle:NSDateFormatterMediumStyle];
            [alertDateformatte setTimeStyle:NSDateFormatterShortStyle];
            [alertDateformatte setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* alertDate = [alertDateformatte dateFromString:alertDateString];
            int alertDateint = [alertDate timeIntervalSince1970]*1;
            //获取当前时间
            if(_secondDate-_fitstDate>0){
                
                UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"您选择的日期时间无效，请选择有效时间哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [tsView show];
            }else{
                if (whether_to_send==1) {
                    NSLog(@"当前时间1%d，当亲时间%f，当前时间2%d",theFirst1,_secondDate,theFirst2);
                    if(theFirst1<=_secondDate && _secondDate<=theFirst2 && alertFirst1<=_fitstDate && _fitstDate<=alertFirst2)
                    {
                        if((_fitstDate-_secondDate)>=4*3600){
                            [self CardClockLayout];
                        }else{
                            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"您给秘书预留的时间过短，至少要预留出4小时的时间哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [tsView show];
                        }
                        
                        
                    }else if(theTwo1<=_secondDate && _secondDate<=theTwo2 && alertTwo1<=_fitstDate && _fitstDate<=alertTwo2)
                    {
                        int dat=theDateint-alertDateint;
                        NSLog(@"时间差值%d",dat);
                        if (dat%86400==0) {
                            [self CardClockLayout];
                        }else{
                            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"提示：秘书工作时间为7:00～19:00，请在此时间内设置秘书提醒时间，0:01—15:00可以设置当天11:00之后的提醒；15:00至0:00可以设置次日7:00之后的提醒." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [tsView show];
                        }
                    }else if (theThree1<=_secondDate && _secondDate<=theThree2 && alertThree1<=_fitstDate && _fitstDate<=alertThree2){
                        int dat=theDateint-alertDateint;
                        NSLog(@"时间差值%d",dat);
                        if (dat%86400==0) {
                            [self CardClockLayout];
                        }else{
                            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"提示：秘书工作时间为7:00～19:00，请在此时间内设置秘书提醒时间，0:01—15:00可以设置当天11:00之后的提醒；15:00至0:00可以设置次日7:00之后的提醒." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [tsView show];
                        }
                        
                    }else{
                        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"提示：秘书工作时间为7:00～19:00，请在此时间内设置秘书提醒时间，0:01—15:00可以设置当天11:00之后的提醒；15:00至0:00可以设置次日7:00之后的提醒." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [tsView show];
                    }
                    
                }else{
                    [self CardClockLayout];
                }

            }
            
        }

    }
}
//没有闹钟调用
-(void)CardCreationLayout
{
    NSString *str=[NSString stringWithFormat:@"%@",timeString];
    NSLog(@"时间%@",str);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* dat = [formatter dateFromString:str];
    int a=[dat timeIntervalSince1970];
    NSString *timestring = [NSString stringWithFormat:@"%d", a];
    NSLog( @"当前时间戳%@",timestring);
    
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSLog(@"有值么%@",_manager.telephone);
    
    NSString *type_ID=[NSString stringWithFormat:@"%d",card_type_ID];
    NSString *txROW;
    if ([meetingString isEqualToString:@"不提醒"]) {
        txROW=[NSString stringWithFormat:@"0"];
    }else if ([meetingString isEqualToString:@"按时提醒"]){
        txROW=[NSString stringWithFormat:@"1"];
    }else{
        txROW=[NSString stringWithFormat:@"%ld",(long)picker.txRow];
    }
    
    NSString *whether=[NSString stringWithFormat:@"%d",whether_to_send];
    NSString *msclString=[NSString stringWithFormat:@"%d",mscl];
    
    NSMutableArray *dicArray=[[NSMutableArray alloc]init];
    for (int i=0; i<nameArray.count; i++) {
        NSDictionary *dict=@{@"mobile":mobileArray[i],@"name":nameArray[i],@"user_id":idArray[i]};
        [dicArray addObject:dict];
    }
    NSArray *infor=[NSArray arrayWithArray:dicArray];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infor options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSLog(@"有没有成功%@",jsonString);
    NSString *create_user_id=[[NSString alloc]init];
    NSString *user_id=[[NSString alloc]init];
    if (clientString==NULL||clientString==nil) {
        create_user_id=_manager.telephone;
        user_id=_manager.telephone;
    }else{
        create_user_id=_manager.telephone;
        user_id=clientString;
    }
    NSDictionary *_dict;
    if(_pushID==1){
        if (_vcID==1003) {
           _dict = @{@"card_id":_cardString,@"card_type":type_ID,@"create_user_id":create_user_id,@"user_id":user_id,@"attends":jsonString,@"service_time":timestring,@"service_addr":meetingField.text,@"service_content":contentString,@"set_remind":txROW,@"set_now_send":msclString,@"set_sec_do":whether,@"set_sec_remarks":remarksString,@"period":loopUpStr};
        }else{
            _dict = @{@"card_id":_cardString,@"card_type":type_ID,@"create_user_id":create_user_id,@"user_id":user_id,@"attends":jsonString,@"service_time":timestring,@"service_addr":meetingField.text,@"service_content":contentString,@"set_remind":txROW,@"set_now_send":msclString,@"set_sec_do":whether,@"set_sec_remarks":remarksString};
        }
        
    }else{
        if (_vcID==1003) {
            _dict = @{@"card_id":@"0",@"card_type":type_ID,@"create_user_id":create_user_id,@"user_id":user_id,@"attends":jsonString,@"service_time":timestring,@"service_addr":meetingField.text,@"service_content":contentString,@"set_remind":txROW,@"set_now_send":msclString,@"set_sec_do":whether,@"set_sec_remarks":remarksString,@"period":loopUpStr};
        }else{
            _dict = @{@"card_id":@"0",@"card_type":type_ID,@"create_user_id":create_user_id,@"user_id":user_id,@"attends":jsonString,@"service_time":timestring,@"service_addr":meetingField.text,@"service_content":contentString,@"set_remind":txROW,@"set_now_send":msclString,@"set_sec_do":whether,@"set_sec_remarks":remarksString};
        }
        
    }
    
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CREATE_CARD dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:YES failedSEL:@selector(DownFail:)];
}
//有闹钟的调用
-(void)CardClockLayout
{
    [self nazhong];
    NSString *str=[NSString stringWithFormat:@"%@",timeString];
    NSLog(@"时间%@",str);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* dat = [formatter dateFromString:str];
    int a=[dat timeIntervalSince1970];
    NSString *timestring = [NSString stringWithFormat:@"%d", a];
    NSLog( @"当前时间戳%@",timestring);
    
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSLog(@"有值么%@",_manager.telephone);
    
    NSString *type_ID=[NSString stringWithFormat:@"%d",card_type_ID];
    NSString *txROW;
    if ([meetingString isEqualToString:@"不提醒"]) {
        txROW=[NSString stringWithFormat:@"0"];
    }else if ([meetingString isEqualToString:@"按时提醒"]){
        txROW=[NSString stringWithFormat:@"1"];
    }else{
        txROW=[NSString stringWithFormat:@"%ld",(long)picker.txRow];
    }
    NSString *whether=[NSString stringWithFormat:@"%d",whether_to_send];
    NSString *msclString=[NSString stringWithFormat:@"%d",mscl];
    
    NSMutableArray *dicArray=[[NSMutableArray alloc]init];
    for (int i=0; i<nameArray.count; i++) {
        NSDictionary *dict=@{@"mobile":mobileArray[i],@"name":nameArray[i],@"user_id":idArray[i]};
        [dicArray addObject:dict];
    }
    NSArray *infor=[NSArray arrayWithArray:dicArray];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infor options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSLog(@"有没有成功%@",jsonString);
    NSString *create_user_id=[[NSString alloc]init];
    NSString *user_id=[[NSString alloc]init];
    if (clientString==NULL||clientString==nil) {
        create_user_id=_manager.telephone;
        user_id=_manager.telephone;
    }else{
        create_user_id=_manager.telephone;
        user_id=clientString;
    }
    
    NSDictionary *_dict;
    if(_pushID==1){
        if (_vcID==1003) {
            _dict = @{@"card_id":_cardString,@"card_type":type_ID,@"create_user_id":create_user_id,@"user_id":user_id,@"attends":jsonString,@"service_time":timestring,@"service_addr":meetingField.text,@"service_content":contentString,@"set_remind":txROW,@"set_now_send":msclString,@"set_sec_do":whether,@"set_sec_remarks":remarksString,@"period":loopUpStr};
        }else{
            _dict = @{@"card_id":_cardString,@"card_type":type_ID,@"create_user_id":create_user_id,@"user_id":user_id,@"attends":jsonString,@"service_time":timestring,@"service_addr":meetingField.text,@"service_content":contentString,@"set_remind":txROW,@"set_now_send":msclString,@"set_sec_do":whether,@"set_sec_remarks":remarksString};
        }
       
    }else{
        if (_vcID==1003) {
            _dict = @{@"card_id":@"0",@"card_type":type_ID,@"create_user_id":create_user_id,@"user_id":user_id,@"attends":jsonString,@"service_time":timestring,@"service_addr":meetingField.text,@"service_content":contentString,@"set_remind":txROW,@"set_now_send":msclString,@"set_sec_do":whether,@"set_sec_remarks":remarksString,@"period":loopUpStr};
        }else{
            _dict = @{@"card_id":@"0",@"card_type":type_ID,@"create_user_id":create_user_id,@"user_id":user_id,@"attends":jsonString,@"service_time":timestring,@"service_addr":meetingField.text,@"service_content":contentString,@"set_remind":txROW,@"set_now_send":msclString,@"set_sec_do":whether,@"set_sec_remarks":remarksString};
        }
        
    }
    
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CREATE_CARD dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:YES failedSEL:@selector(DownFail:)];
}


-(void)logDowLoadFinish:(id)sender
{
    int set_remind=[[[sender objectForKey:@"data"]objectForKey:@"set_remind"]intValue];
    if (set_remind!=0) {
        NSDate *  date=[NSDate date];
        NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"Sunday", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
        
        [calendar setTimeZone: timeZone];
        
        NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
        
        NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
        int week = (int)[theComponents weekday]%7;
        NSLog(@"%@",[weekdays objectAtIndex:week]);
        int fireDateTim = 0;
        if (_pushID==1) {
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
                    int notificationtag=[[NSString stringWithFormat:@"%@",[dict objectForKey:@"card_id"]]intValue];
                    if (mytag==notificationtag)
                    {
                        //删除本地通知
                        [[UIApplication sharedApplication] cancelLocalNotification:myUILocalNotification];
                        break;
                    }
                }
            }//删除原来的闹钟
            
            NSString *timaString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"service_time"]];
            int theTwo1 = [timaString intValue];
            
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
            int  _secondDate = [date timeIntervalSince1970];
            NSLog(@"%d",theTwo1-_secondDate);
            int period=[[NSString stringWithFormat:@"%@",[dict objectForKey:@"period"]]intValue];
            
            
            // 时间戳转时间的方法:
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"HH:mm:ss"];
            NSDate *timedate = [formatter dateFromString:timaString];
            NSString *confromTimespStr = [formatter stringFromDate:timedate];
            NSLog(@"date1:%@",timedate);
            
            NSDateFormatter  *dateform=[[NSDateFormatter alloc] init];
            
            [dateform setDateFormat:@"yyyy-MM-dd"];
            
            NSString *  locationStr=[dateform stringFromDate:senddate];
            
            NSString *timeStrings=[NSString stringWithFormat:@"%@ %@",locationStr,confromTimespStr];
            NSLog(@"locationString:%@",locationString);
            NSDateFormatter *formattes = [[NSDateFormatter alloc] init];
            [formatte setDateStyle:NSDateFormatterMediumStyle];
            [formatte setTimeStyle:NSDateFormatterShortStyle];
            [formatte setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* datesss = [formattes dateFromString:timeStrings];
            int  _secondTime = [datesss timeIntervalSince1970];
            
            
            
            if (period==0) {
                fireDateTim=theTwo1-_secondDate;
            }else if(period==1){
                if (theTwo1-_secondDate>=0) {
                    fireDateTim=_secondTime-_secondDate;
                }else if (theTwo1-_secondDate<0){
                    
                    fireDateTim=_secondTime+24*3600-_secondDate;
                }
            }else if(period==2){
                if (theTwo1-_secondDate>=0) {
                    if (week>1) {
                        fireDateTim=_secondTime-_secondDate;
                    }else if (week==0){
                        fireDateTim=_secondTime+24*2*3600-_secondDate;
                    }else if(week==1){
                        fireDateTim=_secondTime+24*3600-_secondDate;
                    }
                    
                }else if (theTwo1-_secondDate<0){
                    if (week<5&&week>1) {
                        fireDateTim=_secondTime+24*3600-_secondDate;
                    }else if (week==5){
                        fireDateTim=_secondTime+24*3*3600-_secondDate;
                    }else if (week==0){
                        fireDateTim=_secondTime+24*2*3600-_secondDate;
                    }else if (week==1){
                        fireDateTim=_secondTime+24*3600-_secondDate;
                    }
                    
                }
            }else if(period==3){
                //    int
                NSDate *timedate = [NSDate dateWithTimeIntervalSince1970:[timaString intValue]];
                
                int  string=[self weekdayStringFromDate:timedate];
                if (theTwo1-_secondDate>=0) {
                    if (week==string) {
                        fireDateTim=_secondTime-_secondDate;
                    }else{
                        fireDateTim=theTwo1-_secondDate;
                    }
                }else if(theTwo1-_secondDate<0){
                    if (week==string) {
                        fireDateTim=_secondTime+24*7*3600-_secondDate;
                    }else{
                        fireDateTim=theTwo1+24*7*3600-_secondDate;
                    }
                }
                
                //            notification.repeatInterval=kCFCalendarUnitWeek;//循环次数，kCFCalendarUnitWeekday一周一次
            }else if(period==4){
                if (theTwo1-_secondDate>=0) {
                    fireDateTim=theTwo1-_secondDate;
                }else if(theTwo1-_secondDate<0){
                    NSDate *timedate = [NSDate dateWithTimeIntervalSince1970:[timaString intValue]];
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateStyle:NSDateFormatterMediumStyle];
                    [format setTimeStyle:NSDateFormatterShortStyle];
                    [format setDateFormat:@"dd HH:mm:ss"];
                    NSString *  timeStr=[format stringFromDate:timedate];
                    NSDateFormatter  *dateform=[[NSDateFormatter alloc] init];
                    [dateform setDateFormat:@"yyyy-MM"];
                    NSString *  locationStr=[dateform stringFromDate:senddate];
                    
                    NSString *datyString=[NSString stringWithFormat:@"%@-%@",locationStr,timeStr];
                    
                    NSDateFormatter *formattesMM = [[NSDateFormatter alloc] init];
                    [formattesMM setDateStyle:NSDateFormatterMediumStyle];
                    [formattesMM setTimeStyle:NSDateFormatterShortStyle];
                    [formattesMM setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate* dateMM = [formattesMM dateFromString:datyString];
                    int  _secondMM = [dateMM timeIntervalSince1970];
                    
                    NSDate *now = [NSDate date];
                    NSCalendar *calendar = [NSCalendar currentCalendar];
                    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
                    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
                    if (_secondMM-_secondDate>=0) {
                        fireDateTim=_secondMM-_secondDate;
                    }else{
                        NSCalendar *calendar = [NSCalendar currentCalendar];
                        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
                        NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
                        
                        NSInteger iCurYear = [components year];  //当前的年份
                        int iCurMonth = (int)[components month];  //当前的月份
                        if (iCurMonth==1||iCurMonth==3||iCurMonth==5||iCurMonth==7||iCurMonth==8||iCurMonth==10||iCurMonth==12) {
                            fireDateTim=_secondMM+30*24*3600-_secondDate;
                        }else if(iCurMonth==2){
                            if ((iCurYear%4==0 && iCurYear %100 !=0) || iCurYear%400==0) {
                                fireDateTim=_secondMM+29*24*3600-_secondDate;
                            }else {
                                fireDateTim=_secondMM+28*24*3600-_secondDate;
                            }
                            
                        }
                    }
                    
                }
                //            notification.repeatInterval=NSCalendarUnitMonth;//循环次数，NSCalendarUnitMonth一月一次
            }else if(period==5){
                
                //            notification.repeatInterval=NSCalendarUnitYear;//循环次数，NSCalendarUnitYear一年一次
            }
            
            if([nameArray containsObject:@"自己"]&&nameArray.count==1){
                NSLog(@"登录后信息：%@",sender);
                
                
                UILocalNotification *notification=[[UILocalNotification alloc] init];
                if (notification!=nil) {
                    NSDate *timedate = [NSDate dateWithTimeIntervalSince1970:[timaString intValue]];
                    
                    NSDateFormatter *formattesMM = [[NSDateFormatter alloc] init];
                    [formattesMM setDateStyle:NSDateFormatterMediumStyle];
                    [formattesMM setTimeStyle:NSDateFormatterShortStyle];
                    [formattesMM setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *  locationStr=[dateform stringFromDate:timedate];
                    //        NSDate *now=[NSDate new];
                    
                    notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:fireDateTim];//10秒后通知
                    
                    notification.timeZone=[NSTimeZone defaultTimeZone];
                    if (period==0) {
                        notification.repeatInterval=0;//循环次数，kCFCalendarUnitWeekday一周一次
                    }else if(period==1){
                        notification.repeatInterval=kCFCalendarUnitDay;//循环次数，kCFCalendarUnitDay一天一次
                    }else if(period==2){
                        notification.repeatInterval=kCFCalendarUnitWeekday;//循环次数，kCFCalendarUnitWeekday工作日
                    }else if(period==3){
                        notification.repeatInterval=kCFCalendarUnitWeek;//循环次数，kCFCalendarUnitWeekday一周一次
                    }else if(period==4){
                        notification.repeatInterval=NSCalendarUnitMonth;//循环次数，NSCalendarUnitMonth一月一次
                    }else if(period==5){
                        notification.repeatInterval=NSCalendarUnitYear;//循环次数，NSCalendarUnitYear一年一次
                    }
                    
                    
                    notification.applicationIconBadgeNumber++; //应用的红色数字
                    
                    
                    notification.soundName=@"simivoice.caf";//声音，可以换成alarm.soundName = @"myMusic.caf"
                    
                    //去掉下面2行就不会弹出提示框
                    notification.alertTitle=/*@"明天会响么钱钱钱？";//*/[NSString stringWithFormat:@"事物提醒"];
                    notification.alertBody=/*@"明天会响么清清浅浅？";//*/[NSString stringWithFormat:@"%@",[dict objectForKey:@"service_content"]];//提示信息 弹出提示框
                    
                    notification.alertAction = @"打开";  //提示框按钮
                    
                    //notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
                    
                    
                    
                    NSDictionary *dictts = @{@"ac":@"s",@"ci":[dict objectForKey:@"card_id"],@"rt":@"事物提醒",@"rc":[dict objectForKey:@"service_content"],@"re":timaString};
                    NSDictionary *infoDict = @{@"dic":dictts,@"yes_or_no":@"no"};
                    notification.userInfo = infoDict; //添加额外的信息
                    
                    
                    
                    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                    ISLoginManager *_manager = [ISLoginManager shareManager];
                    DownloadManager *_download = [[DownloadManager alloc]init];
                    NSDictionary *dics=@{@"user_id":_manager.telephone,@"card_id":[dict objectForKey:@"card_id"]};
                    [_download requestWithUrl:PUSH_NOTICE dict:dics view:self.view delegate:self finishedSEL:@selector(Success:) isPost:YES failedSEL:@selector(Fail:)];
                }
                
            }
            
        }else{
            if([nameArray containsObject:@"自己"]&&nameArray.count==1){
                
                NSLog(@"登录后信息：%@",sender);
                NSDictionary *dict=[sender objectForKey:@"data"];
                NSString *timaString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"service_time"]];
                //    NSDateFormatter *theTwoformatte1 = [[NSDateFormatter alloc] init];
                //    [theTwoformatte1 setDateStyle:NSDateFormatterMediumStyle];
                //    [theTwoformatte1 setTimeStyle:NSDateFormatterShortStyle];
                //    [theTwoformatte1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                //    NSDate* theTwotdate1 = [theTwoformatte1 dateFromString:timaString];
                int theTwo1 = [timaString intValue];
                
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
                int  _secondDate = [date timeIntervalSince1970];
                NSLog(@"%d",theTwo1-_secondDate);
                int period=[[NSString stringWithFormat:@"%@",[dict objectForKey:@"period"]]intValue];
                UILocalNotification *notification=[[UILocalNotification alloc] init];
                if (notification!=nil) {
                    
                    //        NSDate *now=[NSDate new];
                    
                    notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:theTwo1-_secondDate];//10秒后通知
                    
                    notification.timeZone=[NSTimeZone defaultTimeZone];
                    if (period==0) {
                        notification.repeatInterval=0;//循环次数，kCFCalendarUnitWeekday一周一次
                    }else if(period==1){
                        notification.repeatInterval=kCFCalendarUnitDay;//循环次数，kCFCalendarUnitDay一天一次
                    }else if(period==2){
                        notification.repeatInterval=kCFCalendarUnitWeekday;//循环次数，kCFCalendarUnitWeekday工作日
                    }else if(period==3){
                        notification.repeatInterval=kCFCalendarUnitWeek;//循环次数，kCFCalendarUnitWeekday一周一次
                    }else if(period==4){
                        notification.repeatInterval=NSCalendarUnitMonth;//循环次数，NSCalendarUnitMonth一月一次
                    }else if(period==5){
                        notification.repeatInterval=NSCalendarUnitYear;//循环次数，NSCalendarUnitYear一年一次
                    }
                    
                    
                    notification.applicationIconBadgeNumber++; //应用的红色数字
                    
                    
                    notification.soundName=@"simivoice.caf";//声音，可以换成alarm.soundName = @"myMusic.caf"
                    
                    //去掉下面2行就不会弹出提示框
                    notification.alertTitle=/*@"明天会响么钱钱钱？";//*/[NSString stringWithFormat:@"事物提醒"];
                    notification.alertBody=/*@"明天会响么清清浅浅？";//*/[NSString stringWithFormat:@"%@",[dict objectForKey:@"service_content"]];//提示信息 弹出提示框
                    
                    notification.alertAction = @"打开";  //提示框按钮
                    
                    //notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
                    NSDate *timedate = [NSDate dateWithTimeIntervalSince1970:[timaString intValue]];
                    
                    NSDateFormatter *formattesMM = [[NSDateFormatter alloc] init];
                    [formattesMM setDateStyle:NSDateFormatterMediumStyle];
                    [formattesMM setTimeStyle:NSDateFormatterShortStyle];
                    [formattesMM setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *  locationStr=[formattesMM stringFromDate:timedate];
                    
                    
                    NSDictionary *dictts = @{@"ac":@"s",@"ci":[dict objectForKey:@"card_id"],@"rt":@"事物提醒",@"rc":[dict objectForKey:@"service_content"],@"re":timaString};
                    NSDictionary *infoDict = @{@"dic":dictts,@"yes_or_no":@"no"};
                    notification.userInfo = infoDict; //添加额外的信息
                    
                    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                    
                }
                
            }
            
        }
        NSDictionary *dict=[sender objectForKey:@"data"];
        
        ISLoginManager *_manager = [ISLoginManager shareManager];
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *dics=@{@"user_id":_manager.telephone,@"card_id":[dict objectForKey:@"card_id"]};
        [_download requestWithUrl:PUSH_NOTICE dict:dics view:self.view delegate:self finishedSEL:@selector(Success:) isPost:YES failedSEL:@selector(Fail:)];
    }
    [self backAction];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
-(int)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"Sunday", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    int weeks=(int)theComponents.weekday;
    return weeks;
    
}
-(void)Success:(id)source
{
    
}
-(void)Fail:(id)source
{
    NSLog(@"%@",source);
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


-(void)clientButtonLayout
{
    [clientButton removeFromSuperview];
    clientButton=[[UIButton alloc]initWithFrame:FRAME(0, 64+13/2, WIDTH, 34)];
    //    [clientButton setTitle:@"客户" forState:UIControlStateNormal];
    [clientButton addTarget:self action:@selector(clientAction:) forControlEvents:UIControlEventTouchUpInside];
    clientButton.backgroundColor=[UIColor whiteColor];//colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    //    clientButton.layer.cornerRadius=5;
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
    [clientButton addSubview:whoLabel];
    
    if (clientID==1) {
        clientButton.hidden=NO;
    }else{
        clientButton.hidden=YES;
    }

}

-(void)clientAction:(UIButton *)sender
{
    customerVC=[[CustomerViewController alloc]init];
    customerVC.index=_index;
    [self.navigationController pushViewController:customerVC animated:YES];
}


-(void)loopLayout:(NSString *)loopStr
{
    if ([loopStr isEqualToString:@"一次性提醒"]) {
        loopUpStr=@"0";
    }else if ([loopStr isEqualToString:@"每天"]){
        loopUpStr=@"1";
    }else if ([loopStr isEqualToString:@"工作日(周一至周五)"]){
        loopUpStr=@"2";
    }else if ([loopStr isEqualToString:@"每周"]){
        loopUpStr=@"3";
    }else if ([loopStr isEqualToString:@"每月"]){
        loopUpStr=@"4";
    }else if ([loopStr isEqualToString:@"每年"]){
        loopUpStr=@"5";
    }


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
