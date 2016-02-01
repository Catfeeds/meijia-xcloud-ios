//
//  ZuoFanViewController.m
//  simi
//
//  Created by zrj on 14-11-4.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "ZuoFanViewController.h"
#import "ChoiceDefine.h"
#import "ChoiceView.h"
#import "FourBtnView.h"
#import "RemindView.h"
#import "PickerView.h"
#import "BeiZhuViewController.h"
#import "addressViewController.h"
#import "PayViewController.h"
#import "SERVICEDatas.h"
#import "MBProgressHUD+Add.h"
#import "DatabaseManager.h"
#import "DownloadManager.h"
#import "OrderModel.h"
#import "UsedDressViewController.h"
#import "ISLoginManager.h"
//#import "MyLogInViewController.h"
#import "AppDelegate.h"
#import "BaiduMobStat.h"
#import "TimeManager.h"
#import "ZuofanPicView.h"
#import "LoginViewController.h"
#import "ChatViewController.h"
#import "CUSTOMDRESSBaseClass.h"
#import "CUSTOMDRESSData.h"
@interface ZuoFanViewController ()<ChoiceDelegate,FourbtnDelegate,zuofanPic,BeiZhuDelegate,userDressDelegate,CallDelegate,appDelegate>
{
    ChoiceView *choiceView;
    FourBtnView *FourBtn;
    RemindView *remindView;
    ZuofanPicView *pickerView;
    BOOL hid ;
    NSString *picDate;
    NSString *pichours;
    NSString *picMinutes;
    UILabel *xiaoquLab;
    UILabel *beijing;
    UILabel * beizhulab;
    UILabel *description;
    NSString *_price;
    NSString *_time;
    
    DatabaseManager *dataMangger;
    ISLoginManager *logManager;
    
    NSInteger hour;
    float _height;
    UIScrollView *_myscroll;
}
@end

@implementation ZuoFanViewController
@synthesize model,yuyinTime,yuyinDate;

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}
- (void)getUSerDress
{
    if (logManager.isLogin ) {
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *_dict = @{@"mobile":logManager.telephone};
        
        [_download requestWithUrl:MY_DRESSLIST dict:_dict view:self.view delegate:self finishedSEL:@selector(GetDressListSucess:) isPost:NO failedSEL:@selector(DownloadFail:)];
    }

}
#pragma mark 获得地址列表成功
- (void)GetDressListSucess:(id)responsobject
{
    
    NSLog(@"object is %@",responsobject);
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    CUSTOMDRESSBaseClass *_base = [[CUSTOMDRESSBaseClass alloc]initWithDictionary:responsobject];
    
    for (int i = 0; i < _base.data.count; i ++) {
        
        [dataArray addObject:[_base.data objectAtIndex:i]];
        
    }
    for (int i = 0; i < dataArray.count; i++) {
        CUSTOMDRESSData *mydata = (CUSTOMDRESSData *)[dataArray objectAtIndex:i];
        if (mydata.isDefault == 1) {
            NSLog(@"cellName: %@.cellID: %f.celladdr: %@",mydata.cellname,mydata.cellId,mydata.addr);
            [self GetDressCellname:mydata.cellname menapi:mydata.addr DressId:mydata.dataIdentifier cityID:mydata.cityId];
        }
    }
    
    
}



-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"%@",model.name, nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"%@",model.name, nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    hid = NO;
    self.navlabel.text = model.name;
    self.navigationController.navigationBarHidden = YES;
    hour = 2;
    SERVICEDatas *datas = [model.datas objectAtIndex:0];
    dataMangger = [[DatabaseManager alloc]init];
    logManager = [[ISLoginManager alloc]init];
    NSArray *imagesArr = @[@"order-time",@"order-addr",@"order-person"];
    NSArray *lableArr = @[@"服务时间",@"服务地址",@"用餐人数"];

    _height = (_HEIGHT == 480) ? 64 : 64;
    
    _myscroll = [[UIScrollView alloc]initWithFrame:FRAME(0, 64, _WIDTH, _HEIGHT-64)];
    if (_HEIGHT == 480) {
        _myscroll.frame = FRAME(0, 64, _WIDTH, _HEIGHT);
        [_myscroll setContentSize:CGSizeMake(_WIDTH, 568)];
    }
    [self.view addSubview:_myscroll];
    
    choiceView = [[ChoiceView alloc]initWithFrame:FRAME(0, 25+296/2+74/2-_height, SELF_VIEW_WIDTH, 106/2*3+0.5*4) imagesArray:imagesArr lableTextArray:lableArr];
    choiceView.delegate = self;
    [_myscroll addSubview:choiceView];
    
    NSArray *titleArr = @[@"1-3人",@"4-6人",@"7-9人"];
    
    FourBtn = [[FourBtnView alloc]initWithFrame:FRAME(SELF_VIEW_WIDTH - 60*3-18, 111, 300, 106) nameArray:titleArr];
    FourBtn.delegate = self;
    [choiceView addSubview:FourBtn];
    
    remindView = [[RemindView alloc]initWithFrame:FRAME(0, NAV_HEIGHT-_height, SELF_VIEW_WIDTH, (196+46)/2) labletext:model.tips];
    remindView.delegate =self;
    [_myscroll addSubview:remindView];
    
    //备注
    UIView *view = [[UIView alloc]initWithFrame:FRAME(0, 20+296/2+74/2+106/2*3+0.5*4+34-_height, SELF_VIEW_WIDTH, 106/2)];
    view.backgroundColor = HEX_TO_UICOLOR(CHOICE_BACK_VIEW_COLOR, 1.0);
    [_myscroll addSubview:view];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = FRAME(0, 0.5, SELF_VIEW_WIDTH, 106/2-1);
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(beizhuAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    UIImageView *images = [[UIImageView alloc]initWithFrame:FRAME(18, 20, 17, 17)];
    images.backgroundColor = DEFAULT_COLOR;
    images.image = [UIImage imageNamed:@"order-other"];
    [view addSubview:images];
    
    UILabel *lables = [[UILabel alloc]initWithFrame:FRAME(36+17, 20, 100, 17)];
    lables.text = @"备注";
    lables.textAlignment = NSTextAlignmentLeft;
    lables.textColor = HEX_TO_UICOLOR(LABLE_COLOR, 1.0);
    lables.font = [UIFont boldSystemFontOfSize:14];
    [view addSubview:lables];
    
    UIButton *butn = [UIButton buttonWithType:UIButtonTypeCustom];
    butn.frame = FRAME(SELF_VIEW_WIDTH-18-18, (106-16)/2-25-3, 40/2, 40/2);
    [butn setBackgroundImage:[UIImage imageNamed:@"s-right-arrow"] forState:UIControlStateNormal];
    [view addSubview:butn];
    
    
    float hig = (_HEIGHT == 480) ? 64 : 0;
    UIButton *bttn = [UIButton buttonWithType:UIButtonTypeCustom];
    bttn.frame = FRAME(14, SELF_VIEW_HEIGHT-14-108/2+hig-_height, 584/2, 108/2);
    [bttn setBackgroundColor:HEX_TO_UICOLOR(ROUND_COLOR, 1.0)];
    [bttn setTitle:@"提 交 订 单" forState:UIControlStateNormal];
    [bttn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bttn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [bttn.layer setCornerRadius:5.0];//设置矩形四个圆角半径
    [_myscroll addSubview:bttn];
    
    beijing = [[UILabel alloc]initWithFrame:FRAME(36+17, 108/2, 150+35, 108/2)];
    beijing.tag = 11;
    beijing.textAlignment = NSTextAlignmentLeft;
    beijing.textColor = HEX_TO_UICOLOR(LABLE_COLOR, 1.0);
    beijing.font = [UIFont boldSystemFontOfSize:13];
    beijing.numberOfLines = 0;
    [choiceView addSubview:beijing];
    
    xiaoquLab = [[UILabel alloc]initWithFrame:FRAME(36+17+30, 108/2, 150+35, 108/2)];
    xiaoquLab.tag = 10;
    //    xiaoquLab.backgroundColor = [UIColor greenColor];
    xiaoquLab.textAlignment = NSTextAlignmentLeft;
    xiaoquLab.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
    xiaoquLab.font = [UIFont boldSystemFontOfSize:13];
    xiaoquLab.numberOfLines = 0;
    [choiceView addSubview:xiaoquLab];
    
    beizhulab = [[UILabel alloc]initWithFrame:FRAME(36+17+30+2, 18, 200, 17)];
    beizhulab.tag = 12;
    beizhulab.textAlignment = NSTextAlignmentLeft;
    beizhulab.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
    beizhulab.font = [UIFont boldSystemFontOfSize:14];
    beizhulab.numberOfLines = 0;
    [btn addSubview:beizhulab];
    
    description = [[UILabel alloc]initWithFrame:FRAME(36+17, 20+296/2+74/2+106/2*3+0.5*4-_height, SELF_VIEW_WIDTH-55, 34)];
    description.backgroundColor = [UIColor clearColor];
    description.font = [UIFont systemFontOfSize:10];
    description.textColor = HEX_TO_UICOLOR(LABLE_COLOR, 1.0);
    description.text = datas.datasDescription;
    [_myscroll addSubview:description];
    
    [self getUSerDress];

    
    //时间和日期lable
    if(yuyinDate == nil && yuyinTime == nil ){
        return;
    }
    for(UIView *view in choiceView.subviews ) {
        if ([view isKindOfClass:[UILabel class]]) {
            if (view.tag == 0) {
                [(UILabel *)view setHidden:YES];
            }
        }
    }
    UILabel *timeLable = [[UILabel alloc]initWithFrame:FRAME(36+17+50+5, 15, 60, 15)];
    timeLable.text = [yuyinTime substringToIndex:5];
    timeLable.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
    timeLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    
    [choiceView addSubview:timeLable];
    
    UILabel *dateLal = [[UILabel alloc]initWithFrame:FRAME(55+36+17, 28, 80, 15)];
    dateLal.text = yuyinDate;
    dateLal.font = [UIFont systemFontOfSize: 11];
    dateLal.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
    [choiceView addSubview:dateLal];
    
    UILabel *lale = [[UILabel alloc]initWithFrame:FRAME(36+17, 8, 53, 40)];
    lale.text = [NSString stringWithFormat:@"周%@",[self weekday:yuyinDate]];
    lale.textColor = HEX_TO_UICOLOR(LABLE_COLOR, 1.0);
    lale.font = [UIFont systemFontOfSize:25];
    [choiceView addSubview:lale];
    _time = [NSString stringWithFormat:@"%@ %@ %@",lale.text,dateLal.text,timeLable.text];
    
    start_date = dateLal.text;
    start_time = [NSString stringWithFormat:@"%@ %@",start_date,timeLable.text];

    
    // Do any additional setup after loading the view.
    
    
}

- (NSString *)weekday:(NSString *)date
{
    NSString *day = [date substringWithRange:NSMakeRange(8, 2)];
    NSString *month = [date substringWithRange:NSMakeRange(5, 2)];
    NSString *year = [date substringWithRange:NSMakeRange(0, 4)];
    NSLog(@"year: %@   day:%@    month:%@",year,day,month);
    
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:[day intValue]];
    [_comps setMonth:[month intValue]];
    [_comps setYear:[[NSString stringWithFormat:@"20%@",year] intValue]];
    //NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:GregorianCalendar];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSCalendarUnitWeekday fromDate:_date];
    NSInteger _weekday = [weekdayComponents weekday];
    
    NSLog(@"_weekday:%ld",(long)_weekday);
    
    NSString *str = [NSString stringWithFormat:@"%ld",(long)_weekday];
    str =[str stringByReplacingOccurrencesOfString:@"1" withString:@"日"];
    str =[str stringByReplacingOccurrencesOfString:@"2" withString:@"一"];
    str =[str stringByReplacingOccurrencesOfString:@"3" withString:@"二"];
    str =[str stringByReplacingOccurrencesOfString:@"4" withString:@"三"];
    str =[str stringByReplacingOccurrencesOfString:@"5" withString:@"四"];
    str =[str stringByReplacingOccurrencesOfString:@"6" withString:@"五"];
    str =[str stringByReplacingOccurrencesOfString:@"7" withString:@"六"];
    
    
    return str;
}
- (void)choiceDelegate:(NSInteger)btnTag
{
    if (btnTag == 30) {
        NSLog(@"1");

        if (hid == NO) {
            pickerView = [[ZuofanPicView alloc]initWithFrame:FRAME(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220)hours:hour];
            pickerView.delegate = self;
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            pickerView.frame = FRAME(0, SELF_VIEW_HEIGHT-220, SELF_VIEW_WIDTH, 220);
            [UIView commitAnimations];
            [self.view addSubview:pickerView];
            hid = YES;
            FourBtn.userInteractionEnabled = NO;
        }else
        {
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            pickerView.frame = FRAME(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
            [UIView commitAnimations];
            hid = NO;
            FourBtn.userInteractionEnabled = YES;
        }
        
    }
    if (btnTag == 31) {
        NSLog(@"2");
        if (logManager.isLogin) {
            UsedDressViewController *dress = [[UsedDressViewController alloc]init];
            dress.Cname = @"服务项";
            dress.delegate = self;
            [self.navigationController pushViewController:dress animated:YES];
        }else{
//            MyLogInViewController *log = [[MyLogInViewController alloc]init];
//            log.vCLID=0;
//            [self.navigationController presentViewController:log animated:YES completion:nil];
        }
        
        

    }
    if (btnTag == 32) {
        NSLog(@"3");
    }
    
}
- (void)FourBtnDelegate:(NSInteger)btnTag
{
    if (btnTag == 40) {
        NSLog(@"11");
        hour = 2;
        SERVICEDatas *datas = [model.datas objectAtIndex:0];
        _price = [NSString stringWithFormat:@"%0.2f",datas.disPrice];
        description.text = datas.datasDescription;
        type = [NSString stringWithFormat:@"%.f",datas.selectType];
        value = datas.itemNum;
    }
    if (btnTag == 41) {
        NSLog(@"12");
        hour = 3;
        SERVICEDatas *datas = [model.datas objectAtIndex:1];
        _price = [NSString stringWithFormat:@"%0.2f",datas.disPrice];
        description.text = datas.datasDescription;
        type = [NSString stringWithFormat:@"%.f",datas.selectType];
        value = datas.itemNum;
    }
    if (btnTag == 42) {
        NSLog(@"13");
        hour = 4;
        SERVICEDatas *datas = [model.datas objectAtIndex:2];
        _price = [NSString stringWithFormat:@"%0.2f",datas.disPrice];
        description.text = datas.datasDescription;
        type = [NSString stringWithFormat:@"%.f",datas.selectType];
        value = datas.itemNum;
    }
    if (btnTag == 43) {
        NSLog(@"14");
        SERVICEDatas *datas = [model.datas objectAtIndex:3];
        _price = [NSString stringWithFormat:@"%0.2f",datas.disPrice];
        description.text = datas.datasDescription;
        type = [NSString stringWithFormat:@"%.f",datas.selectType];
        value = datas.itemNum;
    }
}
- (void)quxiao
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    pickerView.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
    hid = NO;
    FourBtn.userInteractionEnabled = YES;
}
-(void)queding:(NSString *)date hours:(NSString *)hours minutes:(NSString *)minutes
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    pickerView.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
    hid = NO;
    
    picDate = date;
    pichours = hours;
    picMinutes = minutes;
    NSLog(@"date:%@hours:%@minutes:%@",picDate,pichours,picMinutes);
    
    for(UIView *view in choiceView.subviews ) {
        if ([view isKindOfClass:[UILabel class]]) {
            if (view.tag == 0) {
                [(UILabel *)view setHidden:YES];
            }
        }
    }
    FourBtn.userInteractionEnabled = YES;
    [self CreateLable];
}
- (void)CreateLable
{
    //判断星期几
    NSString *day = [picDate substringWithRange:NSMakeRange(6, 2)];
    NSString *month = [picDate substringWithRange:NSMakeRange(3, 2)];
    NSString *year = [picDate substringWithRange:NSMakeRange(0, 2)];
    NSLog(@"year: %@   day:%@    month:%@",year,day,month);
    
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:[day intValue]];
    [_comps setMonth:[month intValue]];
    [_comps setYear:[[NSString stringWithFormat:@"20%@",year] intValue]];

    //NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:GregorianCalendar];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSCalendarUnitWeekday fromDate:_date];
    NSInteger _weekday = [weekdayComponents weekday];
    
    NSLog(@"_weekday:%ld",(long)_weekday);
    
    NSString *str = [NSString stringWithFormat:@"%ld",(long)_weekday];
    str =[str stringByReplacingOccurrencesOfString:@"1" withString:@"日"];
    str =[str stringByReplacingOccurrencesOfString:@"2" withString:@"一"];
    str =[str stringByReplacingOccurrencesOfString:@"3" withString:@"二"];
    str =[str stringByReplacingOccurrencesOfString:@"4" withString:@"三"];
    str =[str stringByReplacingOccurrencesOfString:@"5" withString:@"四"];
    str =[str stringByReplacingOccurrencesOfString:@"6" withString:@"五"];
    str =[str stringByReplacingOccurrencesOfString:@"7" withString:@"六"];
    
    UILabel *lale = [[UILabel alloc]initWithFrame:FRAME(36+17, 8, 53, 40)];
    lale.text = [NSString stringWithFormat:@"周%@",str];
    lale.textColor = HEX_TO_UICOLOR(LABLE_COLOR, 1.0);
    lale.font = [UIFont systemFontOfSize:25];
    [choiceView addSubview:lale];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:FRAME(36+17+50+5, 15, 60, 15)];
    lable.text = [NSString stringWithFormat:@"%@:%@",[pichours substringWithRange:NSMakeRange(0, 2)],[picMinutes substringWithRange:NSMakeRange(0, 2)]];
    lable.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
    lable.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [choiceView addSubview:lable];
    
    UILabel *lal = [[UILabel alloc]initWithFrame:FRAME(55+36+17, 28, 80, 15)];
    lal.text = [NSString stringWithFormat:@"20%@-%@-%@",year,month,day];
    lal.font = [UIFont systemFontOfSize: 11];
    lal.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
    [choiceView addSubview:lal];
    _time = [NSString stringWithFormat:@"%@ %@ %@",lale.text,lal.text,lable.text];
    start_date = [NSString stringWithFormat:@"%@",lal.text];
    start_time = [NSString stringWithFormat:@"%@ %@",start_date,lable.text];
    NSLog(@"开始日期 %@  开始时间 %@",start_date,start_time);
}
- (void)beizhuAction
{
    BeiZhuViewController *beizhu = [[BeiZhuViewController alloc]init];
    beizhu.delegate = self;
    beizhu.beizhu = beizhulab.text;
    [self.navigationController pushViewController:beizhu animated:YES];
}
- (void)BeiZhuDelegateLable:(NSString *)textViewtext
{
    NSLog(@"textViewtext:%@",textViewtext);

    beizhulab.text = textViewtext;

}
- (void)GetDressCellname:(NSString *)cellname menapi:(NSString *)menpai DressId:(int)dressID cityID:(double)cityId
{
        for(UIView *view in choiceView.subviews ) {
            if ([view isKindOfClass:[UILabel class]]) {
                if (view.tag == 1) {
                    [(UILabel *)view setHidden:YES];
                }
            }
        }
    
        addr_id = [NSString stringWithFormat:@"%i",dressID];
    
    if (cityId == 2) {
        beijing.text = [NSString stringWithFormat:@"北京"];
    }else{
        beijing.text = [NSString stringWithFormat:@"天津"];
    }
    
        xiaoquLab.text = [NSString stringWithFormat:@"%@ %@",cellname,menpai];
}
//- (void)xiaoqu:(NSString *)xiaoqu menpai:(NSString *)menpaihao dressId:(NSString *)C_id
//{
//    NSLog(@"xiaoqu = %@  menpai = %@",xiaoqu,menpaihao);
//    
//    for(UIView *view in choiceView.subviews ) {
//        if ([view isKindOfClass:[UILabel class]]) {
//            if (view.tag == 1) {
//                [(UILabel *)view setHidden:YES];
//            }
//        }
//    }
//    
//    addr_id = C_id;
//    
//    beijing.text = [NSString stringWithFormat:@"北京"];
//
//    xiaoquLab.text = [NSString stringWithFormat:@"%@ %@",xiaoqu,menpaihao];
//
//}
- (BOOL )compareFirstStr:(NSString *)FirstStr secondStr:(NSString *)secondStr
{

    NSDate *firstDate = [self stringToDate:FirstStr];
    
    NSDate *secondDate = [self stringToDate:secondStr];
    
    NSComparisonResult result = [firstDate compare:secondDate];
    
    if (result == 1) {
        return YES;
    }else{
        return NO;
    }
    
}
- (NSDate *) stringToDate:string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:string];
    
    return date;
}
-(void)nextAction
{
    if (_price == nil) {
        SERVICEDatas *datas = [model.datas objectAtIndex:0];
        _price = [NSString stringWithFormat:@"%0.2f",datas.disPrice];
    }
    if (_time == nil) {
        [MBProgressHUD showError:@"请选择服务时间" toView:self.view];
        return;
    }
    if (xiaoquLab.text == nil) {
        [MBProgressHUD showError:@"请选择服务地址" toView:self.view];
        return;
    }
    
    if (logManager.isLogin == NO) {
//        MyLogInViewController *logview = [[MyLogInViewController alloc]init];
//        logview.vCLID=0;
//        [self.navigationController presentViewController:logview animated:YES completion:nil];
        return;
    }
    
    //获取时间
    
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YY.MM.dd"];
    
    NSString *today=[dateformatter stringFromDate:senddate];
    
    NSLog(@"今天:%@",today);
    
    NSString *day = [picDate substringWithRange:NSMakeRange(6, 2)];
    NSString *month = [picDate substringWithRange:NSMakeRange(3, 2)];
    NSString *year = [picDate substringWithRange:NSMakeRange(0, 2)];
    
    if ([today isEqualToString:[NSString stringWithFormat:@"%@.%@.%@",year,month,day]]) {
        //表示选择的是今天的日期
//        TimeManager *manager = [[TimeManager alloc]init];
//        [manager TimeOutWith:[NSString stringWithFormat:@"%@:%@:00",[pichours substringWithRange:NSMakeRange(0, 2)],[picMinutes substringWithRange:NSMakeRange(0, 2)]]];
//        if (manager.KtimeOut == YES) {
//            [MBProgressHUD showError:@"服务来不及了" toView:self.view];
//            return;
//        }
        
        if (hour == 3) {
          BOOL timeOut = [self compareFirstStr:[NSString stringWithFormat:@"%@:%@:00",[pichours substringWithRange:NSMakeRange(0, 2)],[picMinutes substringWithRange:NSMakeRange(0, 2)]] secondStr:@"19:00:00"];
            
            if (timeOut == YES) {
                NSLog(@"超时了");
                [MBProgressHUD showError:@"服务来不及了" toView:self.view];
                return;
            }
        }
        if (hour == 4) {
            BOOL timeOut = [self compareFirstStr:[NSString stringWithFormat:@"%@:%@:00",[pichours substringWithRange:NSMakeRange(0, 2)],[picMinutes substringWithRange:NSMakeRange(0, 2)]] secondStr:@"18:00:00"];
            
            if (timeOut == YES) {
                NSLog(@"超时了");
                [MBProgressHUD showError:@"服务来不及了" toView:self.view];
                return;
            }
        }
    }
    
    
    if (_time != nil && xiaoquLab.text != nil && logManager.isLogin == YES) {
 
        if (type == nil || value == nil) {
            NSLog(@"baojieModel.datas = :%@",model.datas);
            SERVICEDatas *datas = [model.datas objectAtIndex:0];
            type = [NSString stringWithFormat:@"%.f",datas.selectType];
            value = datas.itemNum;

        }
        NSDictionary *_dict1 = @{@"type":type,@"value":value};
        NSArray *_delArray = @[_dict1];
        NSData * data = [NSJSONSerialization dataWithJSONObject:_delArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString * jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"jsonString :%@",jsonString);
        
        
        //时间戳
        NSString *timeChu = [dataMangger getTimeWithstring:start_time Format:@"yyy.MM.dd HH:mm"];
        NSString *dateChuo = [dataMangger getTimeWithstring:start_date Format:@"yyy.MM.dd"];
        
        //
        NSString *nowTime = [dataMangger gettimeForNow];
        
        if(beizhulab.text == nil){
            NSString *str = @"";
            beizhulab.text = str;
        }
        
        NSMutableDictionary *sourceDic = [[NSMutableDictionary alloc]init];
        [sourceDic setObject:logManager.telephone  forKey:@"mobile"];
//        [sourceDic setObject:@"2"  forKey:@"city_id"];
        [sourceDic setObject:@"1"  forKey:@"service_type"];
        [sourceDic setObject:jsonString  forKey:@"send_datas"];
        [sourceDic setObject:dateChuo  forKey:@"service_date"];
        [sourceDic setObject:timeChu  forKey:@"start_time"];
        [sourceDic setObject:value  forKey:@"service_hour"];
        [sourceDic setObject:addr_id  forKey:@"addr_id"];
        [sourceDic setObject:beizhulab.text  forKey:@"remarks"];
        [sourceDic setObject:nowTime  forKey:@"add_time"];
        [sourceDic setObject:@"0" forKey:@"order_from"];
        NSLog(@"请求dic = %@",sourceDic);
        
        DownloadManager *_download = [[DownloadManager alloc]init];
        [_download requestWithUrl:[NSString stringWithFormat:@"%@",ORDER_TIJIAO] dict:sourceDic view:self.view delegate:self finishedSEL:@selector(DownlLoadFinish:) isPost:YES failedSEL:@selector(DownloadFail:)];

    }

}
- (void)DownlLoadFinish:(id)dict
{
    NSLog(@"dict: %@",dict);
    NSString *msg = [dict objectForKey:@"msg"];
    int status = [[dict objectForKey:@"status"] intValue];
    NSLog(@"msg = %@",msg);
    
    NSDictionary *dict2 = [dict objectForKey:@"data"];
    OrderModel *orderModel = [[OrderModel alloc]initWithDictionary:dict2];
    NSLog(@"model.mobile : %@",orderModel.mobile);
    if (status == 0) {
        PayViewController *pay = [[PayViewController alloc]init];
        pay.price = [NSString stringWithFormat:@"%0.1f",orderModel.order_money];
        pay.time = _time;
        pay.orderID = [NSString stringWithFormat:@"%i",orderModel.order_id];
        pay.orderNum = orderModel.order_no;
        pay.juanLX = @"1";
        [self.navigationController pushViewController:pay animated:YES];
    }
}

- (void)DownloadFail:(id)errorstr
{
    NSLog(@"errsor   :   %@",errorstr);
}
#pragma mark 打电话
#pragma mark 打电话
- (void)CallAction
{
    BOOL login = [self loginYesOrNo];
    if (login == YES) {

        [self CallTelephone];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 20;
        [alert show];
    }
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 20) {
//        MyLogInViewController *log = [[MyLogInViewController alloc]init];
//        log.vCLID=0;
//        [self.navigationController presentViewController:log animated:YES completion:nil];
    }
}
- (void)CallTelephone
{
        AppDelegate *app = [[AppDelegate alloc]init];
        app.deletate = self;
        [app huanxin];
    
}
- (void)LoginSuccessNavPush
{
    
    
    //判断是否真人聊天
    int senior = APPLIACTION.huanxinBase.is_senior;
    
    NSString *imToUserID;
    NSString *imToUsreName;
    
    if (senior == 1) {
        imToUserID = APPLIACTION.huanxinBase.im_senior_username;
        imToUsreName = APPLIACTION.huanxinBase.im_senior_nickname;
    }else{
        imToUserID = APPLIACTION.huanxinBase.im_robot_username;
        imToUsreName = APPLIACTION.huanxinBase.im_robot_nickname;
    }
    
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:imToUserID isGroup:NO];
    chatVC.title = imToUsreName;
    chatVC._baojie = APPLIACTION._baseSource.data.serviceTypes.baojie;
    chatVC._zuofan = APPLIACTION._baseSource.data.serviceTypes.zuofan;
    chatVC._xiyi = APPLIACTION._baseSource.data.serviceTypes.xiyi;
    chatVC._jiadian = APPLIACTION._baseSource.data.serviceTypes.jiadian;
    chatVC._caboli = APPLIACTION._baseSource.data.serviceTypes.caboli;
    chatVC._guandao = APPLIACTION._baseSource.data.serviceTypes.guandao;
    chatVC._xinju = APPLIACTION._baseSource.data.serviceTypes.xinju;
    chatVC.baseData = APPLIACTION.huanxinBase;
    [chatVC.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:chatVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
