//
//  ApplyForLeaveViewController.m
//  yxz
//
//  Created by 白玉林 on 16/1/27.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "ApplyForLeaveViewController.h"
#import "LeaveTypeViewController.h"
#import "DatePicker.h"
#import "ConTentViewController.h"
#import "EnterpriseViewController.h"
@interface ApplyForLeaveViewController ()<datePicDelegate>
{
    UILabel *typeLabel;
    UILabel *daysLabel;
    UILabel *contentLabel;
    UILabel *poepleLabel;
    UILabel *poepleNumberLabel;
    UILabel *startLabel;
    UILabel *endLabel;
    LeaveTypeViewController *leavrVC;
    
    NSString *typeString;
    NSString *daysString;
    NSString *contentString;
    NSString *poepleString;
    NSString *poepleNumberString;
    NSString *startString;
    NSString *endString;
    
    DatePicker *pickerView;
    ConTentViewController *viewController;
    EnterpriseViewController *enterVc;
    int pickerID;
    
    int W,K;
    int currentDate;
    
    NSArray *_mobileArray;
    NSArray *nameArray;
    NSArray *mutableArray;
    NSArray *idArray;
    
    NSString *company_idStr;
}
@end

@implementation ApplyForLeaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navlabel.text=_titleName;
    startString=@"请点击选择时间";
    endString=@"请点击选择时间";
    if (_colorid==100) {
        self.backlable.backgroundColor=HEX_TO_UICOLOR(0x11cd6e, 1.0);
        _navlabel.textColor = [UIColor whiteColor];
        self.img.hidden=YES;
        UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 20, 20)];
        img.image = [UIImage imageNamed:@"iconfont-p-back"];
        [_backBtn addSubview:img];
    }
    
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    NSLog(@"locationString:%@",locationString);
    NSDateFormatter *formatte = [[NSDateFormatter alloc] init];
    [formatte setDateStyle:NSDateFormatterMediumStyle];
    [formatte setTimeStyle:NSDateFormatterShortStyle];
    [formatte setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [formatte dateFromString:locationString];
    currentDate = [date timeIntervalSince1970]*1;
    
    self.view.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    UIView *layoutVIew=[[UIView alloc]initWithFrame:FRAME(0, 74, WIDTH, 290)];
    layoutVIew.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:layoutVIew];
    for (int i=0; i<5; i++) {
        UIButton *layoutBut=[[UIButton alloc]init];
        layoutBut.tag=i;
        [layoutBut addTarget:self action:@selector(layoutBut:) forControlEvents:UIControlEventTouchUpInside];
        [layoutVIew addSubview:layoutBut];
        if (i!=1) {
            UIView *lineVIew=[[UIView alloc]init];
            lineVIew.backgroundColor=[UIColor colorWithRed:222/255.0f green:222/255.0f blue:222/255.0f alpha:1];
            [layoutVIew addSubview:lineVIew];
           
            
            switch (i) {
                case 0:
                {
                    layoutBut.frame=FRAME(0, 0, WIDTH, 70);
                    UIImageView *lconImageView=[[UIImageView alloc]initWithFrame:FRAME(15, (70-16)/2, 20, 16)];
                    lconImageView.image=[UIImage imageNamed:@"CLGH_NR_TB_@2x"];
                    [layoutBut addSubview:lconImageView];
                    
                    UILabel *label=[[UILabel alloc]init];
                    label.text=@"请假类型";
                    label.font=[UIFont fontWithName:@"Heiti SC" size:14];
                    [label setNumberOfLines:1];
                    [label sizeToFit];
                    label.frame=FRAME(lconImageView.frame.size.width+lconImageView.frame.origin.x+10, (70-20)/2, label.frame.size.width, 20);
                    [layoutBut addSubview:label];
                    
                    typeLabel=[[UILabel alloc]init];
                    [layoutBut addSubview:typeLabel];
                    
                    UIImageView *arrowImageView=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-25, 55/2, 15, 15)];
                    arrowImageView.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
                    [layoutBut addSubview:arrowImageView];
                    
                    lineVIew.frame=FRAME(10, 69, WIDTH-20, 1);
                }
                    break;
                case 2:
                {
                    layoutBut.frame=FRAME(10, 140, WIDTH-20, 40);
                    [layoutBut.layer setMasksToBounds:YES];
                    [layoutBut.layer setCornerRadius:8.0]; //设置矩圆角半径
                    [layoutBut.layer setBorderWidth:1.0];//边框宽度
                    layoutBut.layer.backgroundColor=[[UIColor colorWithRed:241.0 / 255.0 green:241.0 / 255.0 blue:241.0 / 255.0 alpha:1] CGColor];
                    layoutBut.layer.cornerRadius=8.0f;
                    layoutBut.layer.masksToBounds=YES;
                    layoutBut.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
                    layoutBut.layer.borderWidth= 1.0f;
                    
                    UILabel *timeLabel=[[UILabel alloc]init];
                    timeLabel.text=@"结束时间";
                    timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
                    [timeLabel setNumberOfLines:1];
                    [timeLabel sizeToFit];
                    timeLabel.frame=FRAME(10, 10, timeLabel.frame.size.width, 20);
                    [layoutBut addSubview:timeLabel];
                    W=timeLabel.frame.size.width;
                    
                    endLabel =[[UILabel alloc]init];
                    [self endLayout];
                    [layoutBut addSubview:endLabel];
                    
                    UIImageView *dateImg=[[UIImageView alloc]initWithFrame:FRAME(layoutBut.frame.size.width-20, (40-15)/2, 15, 15)];
                    dateImg.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
                    [layoutBut addSubview:dateImg];
                    lineVIew.frame=FRAME(10, 189, WIDTH-20, 1);
                }
                    break;
                case 3:
                {
                    layoutBut.frame=FRAME(0, 190, WIDTH, 50);
                    UIImageView *lconImageView=[[UIImageView alloc]initWithFrame:FRAME(15, (50-16)/2, 20, 16)];
                    lconImageView.image=[UIImage imageNamed:@"CLGH_JP_TB_@2x"];
                    [layoutBut addSubview:lconImageView];
                    
                    UILabel *label=[[UILabel alloc]init];
                    label.text=@"请假天数";
                    label.font=[UIFont fontWithName:@"Heiti SC" size:14];
                    [label setNumberOfLines:1];
                    [label sizeToFit];
                    label.frame=FRAME(lconImageView.frame.size.width+lconImageView.frame.origin.x+10, (50-20)/2, label.frame.size.width, 20);
                    [layoutBut addSubview:label];
                    
                    daysLabel=[[UILabel alloc]init];
                    [layoutBut addSubview:daysLabel];
                    
                    UIImageView *arrowImageView=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-25, 35/2, 15, 15)];
                    arrowImageView.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
                    [layoutBut addSubview:arrowImageView];
                    lineVIew.frame=FRAME(10, 239, WIDTH-20, 1);
                }
                    break;
                case 4:
                {
                    layoutBut.frame=FRAME(0, 240, WIDTH, 50);
                    UIImageView *lconImageView=[[UIImageView alloc]initWithFrame:FRAME(15, (50-16)/2, 20, 16)];
                    lconImageView.image=[UIImage imageNamed:@"HYAP_TX_TB_@2x"];
                    [layoutBut addSubview:lconImageView];
                    
                    UILabel *label=[[UILabel alloc]init];
                    label.text=@"请假内容";
                    label.font=[UIFont fontWithName:@"Heiti SC" size:14];
                    [label setNumberOfLines:1];
                    [label sizeToFit];
                    label.frame=FRAME(lconImageView.frame.size.width+lconImageView.frame.origin.x+10, (50-20)/2, label.frame.size.width, 20);
                    [layoutBut addSubview:label];
                    
                    contentLabel=[[UILabel alloc]init];
                    [layoutBut addSubview:contentLabel];
                    
                    UIImageView *arrowImageView=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-25, 35/2, 15, 15)];
                    arrowImageView.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
                    [layoutBut addSubview:arrowImageView];
                }
                    break;
                default:
                    break;
            }
        }else{
            layoutBut.frame=FRAME(10, 80, WIDTH-20, 40);
            [layoutBut.layer setMasksToBounds:YES];
            [layoutBut.layer setCornerRadius:8.0]; //设置矩圆角半径
            [layoutBut.layer setBorderWidth:1.0];//边框宽度
            layoutBut.layer.backgroundColor=[[UIColor colorWithRed:241.0 / 255.0 green:241.0 / 255.0 blue:241.0 / 255.0 alpha:1] CGColor];
            layoutBut.layer.cornerRadius=8.0f;
            layoutBut.layer.masksToBounds=YES;
            layoutBut.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
            layoutBut.layer.borderWidth= 1.0f;
            
            UILabel *timeLabel=[[UILabel alloc]init];
            timeLabel.text=@"开始时间";
            timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
            [timeLabel setNumberOfLines:1];
            [timeLabel sizeToFit];
            timeLabel.frame=FRAME(10, 10, timeLabel.frame.size.width, 20);
            [layoutBut addSubview:timeLabel];
            W=timeLabel.frame.size.width;
            startLabel =[[UILabel alloc]init];
            [self startLayout];
            [layoutBut addSubview:startLabel];
            
            UIImageView *dateImg=[[UIImageView alloc]initWithFrame:FRAME(layoutBut.frame.size.width-20, (40-15)/2, 15, 15)];
            dateImg.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
            [layoutBut addSubview:dateImg];
            
        }
    }
    UIButton *poepleBut=[[UIButton alloc]initWithFrame:FRAME(0, 374, WIDTH, 70)];
    poepleBut.backgroundColor=[UIColor whiteColor];
    [poepleBut addTarget:self action:@selector(poepleBut:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:poepleBut];
    
    UILabel *popleLabel=[[UILabel alloc]init];
    popleLabel.text=@"审批人";
    popleLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    [popleLabel setNumberOfLines:1];
    [popleLabel sizeToFit];
    popleLabel.frame=FRAME(10, 15, popleLabel.frame.size.width, 20);
    [poepleBut addSubview:popleLabel];
    
    UILabel *choiceLabel=[[UILabel alloc]init];
    choiceLabel.text=@"已选择:";
    choiceLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    choiceLabel.textColor=[UIColor colorWithRed:164/255.0f green:164/255.0f blue:164/255.0f alpha:1];
    [choiceLabel setNumberOfLines:1];
    [choiceLabel sizeToFit];
    choiceLabel.frame=FRAME(10, 35, choiceLabel.frame.size.width, 20);
    [poepleBut addSubview:choiceLabel];
    K=choiceLabel.frame.size.width+10;
    
    UIImageView *dateImg=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-25, (70-15)/2, 15, 15)];
    dateImg.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
    [poepleBut addSubview:dateImg];
    
    poepleLabel=[[UILabel alloc]init];
    [poepleBut addSubview:poepleLabel];
    
    poepleNumberLabel=[[UILabel alloc]init];
    [poepleBut addSubview:poepleNumberLabel];
    
    UIButton *submitBut=[[UIButton alloc]initWithFrame:FRAME(14, HEIGHT-45, WIDTH-28, 41)];
    [submitBut setTitle:@"申请" forState:UIControlStateNormal];
    submitBut.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [submitBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBut.layer.cornerRadius=5;
    submitBut.clipsToBounds=YES;
    submitBut.backgroundColor=self.backlable.backgroundColor;
    [submitBut addTarget:self action:@selector(submitBut:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBut];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.navlabel.text];
    pickerView=[[DatePicker alloc]initWithFrame:FRAME(0, HEIGHT, WIDTH, 250)];
    pickerView.delegate=self;
    [self.view addSubview:pickerView];
    if ([leavrVC.typeStr isEqualToString:@""]) {
        
    }else{
        typeString=leavrVC.typeStr;
        [self typeLayout];
    }
    
    if ([viewController.textString isEqualToString:@""]) {
        
    }else{
        contentString=viewController.textString;
        [self contentLayout];
    }
    poepleString=[enterVc.nameArray componentsJoinedByString:@","];
    if (poepleString !=nil||poepleString !=NULL) {
        poepleString=[enterVc.nameArray componentsJoinedByString:@","];
        poepleNumberString=[NSString stringWithFormat:@"%lu人",(unsigned long)enterVc.nameArray.count];
        nameArray=enterVc.nameArray;
        _mobileArray=enterVc.mobileArray;
        mutableArray=enterVc.mutableArrat;
        idArray=enterVc.idArray;
        [self poepleLayout];
    }
    company_idStr=enterVc.company_idStr;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.navlabel.text];
}
-(void)layoutBut:(UIButton *)button
{
    if (button.tag==0) {
        [self dateQuxiao];
        leavrVC=[[LeaveTypeViewController alloc]init];
        [self.navigationController pushViewController:leavrVC animated:YES];
    }else if (button.tag==1){
        [self dateQuxiao];
        pickerID=1;
        [UIView beginAnimations:@"Animation" context:nil];
        [UIView setAnimationDuration:0.3];
        pickerView.frame=FRAME(0, HEIGHT-250, WIDTH, 250);
        [UIView commitAnimations];
    }else if (button.tag==2){
        [self dateQuxiao];
        pickerID=2;
        [UIView beginAnimations:@"Animation" context:nil];
        [UIView setAnimationDuration:0.3];
        pickerView.frame=FRAME(0, HEIGHT-250, WIDTH, 250);
        [UIView commitAnimations];
    }else if (button.tag==3){
        [self dateQuxiao];
    }else if (button.tag==4){
        [self dateQuxiao];
        viewController=[[ConTentViewController alloc]init];
        viewController.textString=contentString;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
-(void)poepleBut:(UIButton *)button
{
//    dataID=101;
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *has_company=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"has_company"]];
    int has=[has_company intValue];
    if (has==0) {
        Create_Enterprise_Address_BookViewController *webVC=[[Create_Enterprise_Address_BookViewController alloc]init];
        [self.navigationController pushViewController:webVC animated:YES];
    }else{
        enterVc=[[EnterpriseViewController alloc]init];
        enterVc.webId=1;
        enterVc.enterVcID=10;
        enterVc.theNumber=0;
        enterVc.mutableArrat=mutableArray;
        enterVc.nameArray=nameArray;
        enterVc.mobileArray=_mobileArray;
        enterVc.idArray=idArray;
        enterVc.poepleID=10000;
        [self.navigationController pushViewController:enterVc animated:YES];
    }
   
}
-(void)typeLayout
{
    typeLabel.text=typeString;
    typeLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    [typeLabel setNumberOfLines:1];
    [typeLabel sizeToFit];
    typeLabel.frame=FRAME(WIDTH-25-typeLabel.frame.size.width, (70-15)/2, typeLabel.frame.size.width, 15);
}
-(void)startLayout
{
    startLabel.text=startString;
    startLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    [startLabel setNumberOfLines:1];
    [startLabel sizeToFit];
    startLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    startLabel.frame=FRAME(W+15, 10, startLabel.frame.size.width, 20);
}
-(void)endLayout
{
    endLabel.text=endString;
    endLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    [endLabel setNumberOfLines:1];
    [endLabel sizeToFit];
    endLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    endLabel.frame=FRAME(W+15, 10, endLabel.frame.size.width, 20);
}
#pragma mark 会议时间选择器代理方法
#pragma mark datePicker代理方法
- (void)dateQuxiao
{
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    pickerView.frame=FRAME(0, HEIGHT, WIDTH, 250);
    [UIView commitAnimations];
    
}
-(void)dateQueding:(NSString *)date
{
    NSString *alertDateString=[date substringWithRange:NSMakeRange(0,10)];
    NSDateFormatter *alertDateformatte = [[NSDateFormatter alloc] init];
    [alertDateformatte setDateStyle:NSDateFormatterMediumStyle];
    [alertDateformatte setTimeStyle:NSDateFormatterShortStyle];
    [alertDateformatte setDateFormat:@"yyyy-MM-dd"];
    NSDate* alertDate = [alertDateformatte dateFromString:alertDateString];
    int alertDateint = [alertDate timeIntervalSince1970]*1;
    
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    if (pickerID==1) {
        if (alertDateint<currentDate) {
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"提示：开始时间不可小于当前时间，请重新选择！" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [tsView show];
        }else{
            startString=date;
            pickerView.frame=FRAME(0, HEIGHT, WIDTH, 250);
            [self startLayout];
        }
    }else if (pickerID==2){
        NSString *alertThreeTime2=[startString substringWithRange:NSMakeRange(0,10)];
        NSDateFormatter *alertThreeformatte2 = [[NSDateFormatter alloc] init];
        [alertThreeformatte2 setDateStyle:NSDateFormatterMediumStyle];
        [alertThreeformatte2 setTimeStyle:NSDateFormatterShortStyle];
        [alertThreeformatte2 setDateFormat:@"yyyy-MM-dd"];
        NSDate* alertThreedate2 = [alertThreeformatte2 dateFromString:alertThreeTime2];
        NSTimeInterval alertThree2 = [alertThreedate2 timeIntervalSince1970]*1;
        if (alertThree2>alertDateint) {
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"提示：结束时间不可小于开始时间，请重新选择！" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [tsView show];
        }else{
            endString=date;
            pickerView.frame=FRAME(0, HEIGHT, WIDTH, 250);
            [self endLayout];
            [self days];
        }
    }
    [UIView commitAnimations];
}
-(void)contentLayout
{
    contentLabel.text=contentString;
    contentLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    contentLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [contentLabel setNumberOfLines:1];
    [contentLabel sizeToFit];
    contentLabel.frame=FRAME(60+W, 35/2, WIDTH-(60+W+30), 15);
}
-(void)daysLayout
{
    daysLabel.text=daysString;
    daysLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    [daysLabel setNumberOfLines:1];
    [daysLabel sizeToFit];
    daysLabel.frame=FRAME(WIDTH-30-daysLabel.frame.size.width, 35/2, daysLabel.frame.size.width, 15);
}
-(void)days
{
//    NSString *alertDateString=[startString substringWithRange:NSMakeRange(0,10)];
    NSDateFormatter *alertDateformatte = [[NSDateFormatter alloc] init];
    [alertDateformatte setDateStyle:NSDateFormatterMediumStyle];
    [alertDateformatte setTimeStyle:NSDateFormatterShortStyle];
    [alertDateformatte setDateFormat:@"yyyy-MM-dd"];
    NSDate* alertDate = [alertDateformatte dateFromString:startString];
    int alertDateint = [alertDate timeIntervalSince1970]*1;
    
    NSDateFormatter *alertThreeformatte2 = [[NSDateFormatter alloc] init];
    [alertThreeformatte2 setDateStyle:NSDateFormatterMediumStyle];
    [alertThreeformatte2 setTimeStyle:NSDateFormatterShortStyle];
    [alertThreeformatte2 setDateFormat:@"yyyy-MM-dd"];
    NSDate* alertThreedate2 = [alertThreeformatte2 dateFromString:endString];
    NSTimeInterval alertThree2 = [alertThreedate2 timeIntervalSince1970]*1;
    int time=alertThree2-alertDateint;
    if (time%86400==0) {
        int day=time/86400;
        daysString=[NSString stringWithFormat:@"%d天",day+1];
        [self daysLayout];
    }
    [self daysLayout];
}
-(void)poepleLayout
{
    poepleLabel.text=poepleString;
    poepleLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    poepleLabel.textColor=[UIColor colorWithRed:164/255.0f green:164/255.0f blue:164/255.0f alpha:1];
    poepleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [poepleLabel setNumberOfLines:1];
    [poepleLabel sizeToFit];
    poepleLabel.frame=FRAME(K+5, 35, WIDTH-K-25, 20);
    
    poepleNumberLabel.text=poepleNumberString;
    poepleNumberLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    poepleNumberLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [poepleNumberLabel setNumberOfLines:1];
    [poepleNumberLabel sizeToFit];
    poepleNumberLabel.frame=FRAME(WIDTH-25-poepleNumberLabel.frame.size.width, (70-15)/2, poepleNumberLabel.frame.size.width, 15);
}
-(void)submitBut:(UIButton *)button
{
    if (typeString==nil||typeString==NULL) {
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请假类型不能为空！" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [tsView show];
        
    }else if (startString==nil||startString==NULL||[startString isEqualToString:@"请点击选择时间"]) {
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择开始时间！" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [tsView show];
        
    }else if (endString==nil||endString==NULL||[endString isEqualToString:@"请点击选择时间"]) {
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择结束时间" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [tsView show];
        
    }else if (daysString==nil||daysString==NULL){
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择开始时间和结束时间" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [tsView show];
        
    }else if (contentString==nil||contentString==NULL){
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请填写请假内容" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [tsView show];
        
    }else if (poepleString==nil||poepleString==NULL){
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择审批人" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [tsView show];
        
    }else{
        ISLoginManager *manager = [[ISLoginManager alloc]init];
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSString *leave_type;
        if ([typeString isEqualToString:@"病假"]) {
            leave_type=@"0";
        }else if ([typeString isEqualToString:@"事假"]){
            leave_type=@"1";
        }else if ([typeString isEqualToString:@"婚假"]){
            leave_type=@"2";
        }else if ([typeString isEqualToString:@"丧假"]){
            leave_type=@"3";
        }else if ([typeString isEqualToString:@"产假"]){
            leave_type=@"4";
        }else if ([typeString isEqualToString:@"年休假"]){
            leave_type=@"5";
        }else if ([typeString isEqualToString:@"其他"]){
            leave_type=@"6";
        }
        NSMutableArray *dicArray=[[NSMutableArray alloc]init];
        for (int i=0; i<nameArray.count; i++) {
            NSDictionary *dict=@{@"mobile":_mobileArray[i],@"name":nameArray[i],@"user_id":idArray[i]};
            [dicArray addObject:dict];
        }
        NSArray *infor=[NSArray arrayWithArray:dicArray];
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infor options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary *_dict=@{@"company_id":company_idStr,@"user_id":manager.telephone,@"leave_type":leave_type,@"start_date":startString,@"end_date":endString,@"total_days":daysString,@"remarks":contentString,@"pass_users":jsonString};
        [_download requestWithUrl:SUER_LEAVE_APPLY dict:_dict view:self.view delegate:self finishedSEL:@selector(LeaveSuccess:) isPost:YES failedSEL:@selector(LeaveFail:)];
    }
}
#pragma mark请假申请发送成功
-(void)LeaveSuccess:(id)Sourcedata
{
    NSLog(@"请假申请发送成功返回数据：%@",Sourcedata);
    int status=[[Sourcedata objectForKey:@"status"]intValue];
    if(status==999){
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:[Sourcedata objectForKey:@"msg"] delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [tsView show];
    }else if (status==0){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark请假申请发送失败
-(void)LeaveFail:(id)Sourcedata
{
    NSLog(@"请假申请发送失败返回数据：%@",Sourcedata);
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
