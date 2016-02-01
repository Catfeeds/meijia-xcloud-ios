//
//  SetRemindViewController.m
//  simi
//
//  Created by zrj on 14-11-26.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "SetRemindViewController.h"
#import "RemindView.h"
#import "ChoiceDefine.h"
#import "SetRemindCell.h"
#import "SelectCityView.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "BeiZhuViewController.h"
#import "TimePicker.h"
#import "DatePicker.h"
#import "MBProgressHUD+Add.h"
#import "AppDelegate.h"
#import "RepeatCycle.h"
#import "TiXingModel.h"
#import "RemindViewController.h"
#import "MBProgressHUD+Add.h"
//#import "APService.h"
#import "DownloadManager.h"
#import "ISLoginManager.h"
//#import "MyLogInViewController.h"
#import "BaiduMobStat.h"
#import "TixingTimePicker.h"
//#import "MyLogInViewController.h"
#import "LoginViewController.h"
#import "ChatViewController.h"
@interface SetRemindViewController ()<SelectCityDelegate,UITextFieldDelegate,timePickerDelegate,datePicDelegate,BeiZhuDelegate,repeartDelegate,SetRemDelegate,CallDelegate,TixingTimePic,appDelegate>
{
    UITableView *_mytableview;
    NSArray *titleArray;
    UIButton *namebtn;
    SelectCityView *listView;
    BOOL open;
    BOOL white;
    NSMutableArray *resultArray;
    UITextField *titileTextField;
    UITextField *userTextfield; //通讯录textfield

    TimePicker *pickerView;
    DatePicker *datePicker;
    RepeatCycle *repeartView;
    TixingTimePicker *timepic;
    
    UIButton *sectionBtn;
    
    UIView *zhezhao;
    
    TiXingModel *_mymodel;
    
    NSMutableArray *remindArray;
    
    NSMutableArray *userArray;
    BOOL userResingFirst;
    ISLoginManager *logmanager;
    
}
@end

@implementation SetRemindViewController{
//    UILocalNotification *_notification;
}
@synthesize delegate = _delegate,superior,arrIndex,week;

-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"提醒设置", nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"提醒设置", nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navlabel.text = @"提醒设置";
    userResingFirst = YES;
    open = NO;
    
    logmanager = [[ISLoginManager alloc]init];
    _mymodel = [[TiXingModel alloc]init];
    resultArray = [[NSMutableArray alloc]init];

    userArray = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    if([self.superior isEqualToString:@"提醒详情"]){
        
        _mymodel.listTitle = [[[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"]objectAtIndex:arrIndex]objectForKey:@"user"];
        NSLog(@"user  =   %@",_mymodel.duixiang);
        _mymodel.biaoti = [[[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"]objectAtIndex:arrIndex]objectForKey:@"biaoti"];
        _mymodel.time = [[[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"]objectAtIndex:arrIndex]objectForKey:@"time"];
        _mymodel.date = [[[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"]objectAtIndex:arrIndex]objectForKey:@"date"];
        _mymodel.zhouqi = [[[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"]objectAtIndex:arrIndex]objectForKey:@"zhouqi"];
        _mymodel.beizhu = [[[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"]objectAtIndex:arrIndex]objectForKey:@"beizhu"];
        
        if([_mymodel.listTitle isEqualToString:@"他人"]){
            open = NO;
            white = YES;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
            phoneArray = [[[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"]objectAtIndex:arrIndex]objectForKey:@"othernumber"];
            NSString *othername = [[[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"]objectAtIndex:arrIndex]objectForKey:@"othername"];
            [dic setValue:phoneArray forKey:@"phone"];
            [dic setValue:othername forKey:@"name"];
            [resultArray addObject:dic];
            NSLog(@"resultArray = %@",resultArray);
        }
        
    }else{
        white = NO;
        _mymodel.duixiang = @"我";
        _mymodel.biaoti = @"未输入";
        _mymodel.time = @"未选择";
        _mymodel.date = @"未选择";
        _mymodel.zhouqi = @"一次性活动";
        _mymodel.beizhu = @"编辑备忘";
        
    }
    
    remindArray = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"TIXING"]];
    
    RemindView *remindView = [[RemindView alloc]initWithFrame:FRAME(0, NAV_HEIGHT, SELF_VIEW_WIDTH, (196+46)/2) labletext:@"在此吩咐您的具体要求吧！"];
    remindView.delegate = self;
    [self.view addSubview:remindView];
    
    _mytableview = [[UITableView alloc]initWithFrame:FRAME(0, 25+296/2+74/2, SELF_VIEW_WIDTH, SELF_VIEW_HEIGHT-(20+296/2+74/2)-28-59)];
    _mytableview.delegate = self;
    _mytableview.dataSource = self;
    _mytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_mytableview setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:_mytableview];
    
    
    titleArray = [NSArray arrayWithObjects:@"提醒对象",@"提醒标题",@"提醒时间",@"提醒日期",@"重复周期",@"备忘内容", nil];

    UIButton *bttn = [UIButton buttonWithType:UIButtonTypeCustom];
    bttn.frame = FRAME(14, SELF_VIEW_HEIGHT-14-108/2, 584/2, 108/2);
    [bttn setBackgroundColor:HEX_TO_UICOLOR(ROUND_COLOR, 1.0)];
    [bttn setTitle:@"添加提醒" forState:UIControlStateNormal];
    if([self.superior isEqualToString:@"提醒详情"]){
        [bttn setTitle:@"确定" forState:UIControlStateNormal];
    }
    [bttn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bttn addTarget:self action:@selector(addRemind) forControlEvents:UIControlEventTouchUpInside];
    [bttn.layer setCornerRadius:5.0];//设置矩形四个圆角半径
    [self.view addSubview:bttn];

//    pickerView = [[TimePicker alloc]initWithFrame:FRAME(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220)];
//    pickerView.delegate = self;
    
    timepic = [[TixingTimePicker alloc]initWithFrame:FRAME(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220)];
    timepic.delegate = self;
    // Do any additional setup after loading the view.
}
- (void)selectUser:(UIButton *)sender
{
    [namebtn setTitle:@"" forState:UIControlStateNormal];
    [namebtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    if (listView.hidden == YES) {
//        listView.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^void{
            listView.frame = FRAME(SELF_VIEW_WIDTH-18-30-20, 20+296/2+74/2+15, 55, 72);
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^void{
            listView.hidden = YES;
            listView.frame = FRAME(SELF_VIEW_WIDTH-18-30-20, 20+296/2+74/2+15, 55, 0);
        }];
    }
    if(listView.hidden == YES){
        listView.hidden = NO;
    }
}
- (void)SelectCtiyDelegate:(NSString *)btntitle
{
    [UIView animateWithDuration:0.25 animations:^void{
        listView.hidden = YES;
        [namebtn setImage:[UIImage imageNamed:@"drop-down-list_03@2x"] forState:UIControlStateNormal];
        listView.frame = FRAME(SELF_VIEW_WIDTH-18-30-20, 20+296/2+74/2+15, 55, 0);
    }];
    [namebtn setTitle:btntitle forState:UIControlStateNormal];
    
    _mymodel.listTitle = [NSString stringWithFormat:@"%@",btntitle];
    
    if ([namebtn.titleLabel.text isEqualToString:@"他人"]) {
        [self collapseOrExpand];
        
        //刷新tableview
        open = YES;
        white = NO;
        [_mytableview reloadData];
    }
    if ([namebtn.titleLabel.text isEqualToString:@"我"]) {
        [self closeTable];
        
        //刷新tableview
        
        open = NO;
        [_mytableview reloadData];
    }

    listView.hidden = YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [titleArray count];
    
}
#pragma mark HeaderInsection
- (UIView *) tableView: (UITableView *) tableView viewForHeaderInSection: (NSInteger) section

{

    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 44.0)];
    
    footerView.backgroundColor = [UIColor whiteColor];
    
    footerView.autoresizesSubviews = YES;     //重载子视图的位置
    
    footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth; //控件的宽度随着父视图的宽度按比例改变；
    
    footerView.userInteractionEnabled = YES;
    
    footerView.hidden = NO;
    
    footerView.multipleTouchEnabled = YES;
    
    footerView.opaque = NO;  //不透明
    
    footerView.contentMode = UIViewContentModeScaleToFill;
    
    footerView.tag = section;


    //当选择他人时 section变色
    if (open == YES && [_mymodel.listTitle isEqualToString:@"他人"]) {
        footerView.backgroundColor = HEX_TO_UICOLOR(BAC_VIEW_COLOR, 1.0);
        if (footerView.tag == 0) {
            UIView *xian = [[UIView alloc]initWithFrame:FRAME(0, 88, SELF_VIEW_WIDTH, 0.5)];
            xian.backgroundColor = HEX_TO_UICOLOR(CHOICE_BACK_VIEW_COLOR, 1.0);
            [footerView addSubview:xian];
            
            UIButton *btn = [[UIButton alloc]initWithFrame:FRAME(0, 54, SELF_VIEW_WIDTH, 34)];
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [btn setTitle:@"请选择通讯录好友：" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(heqilai) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:10];
            [btn setTitleColor:HEX_TO_UICOLOR(0xb1b1b1, 1.0) forState:UIControlStateNormal];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];
            [btn setImage:[UIImage imageNamed:@"drop-up-list_03@2x"] forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake((34-17/2)/2, 18, (34-17/2)/2, SELF_VIEW_WIDTH-18-31/2)];
            [footerView addSubview:btn];
            
            userTextfield = [[UITextField alloc]initWithFrame:FRAME(150, 0, SELF_VIEW_WIDTH-150, 34)];
            userTextfield.font = [UIFont systemFontOfSize:10];
            userTextfield.delegate = self;
            userTextfield.text = _mymodel.userTextFieldText;
            [userTextfield setReturnKeyType:UIReturnKeySearch];
//            [userTextfield setKeyboardType:UIKeyboardTypeDefault];
//            if (userResingFirst == YES) {
////                [userTextfield resignFirstResponder];
//            }else{
//                [userTextfield becomeFirstResponder];
//            }
            [btn addSubview:userTextfield];
            
            UIButton *searchBtn = [[UIButton alloc]initWithFrame:FRAME(SELF_VIEW_WIDTH-37/2-18, (34-38/2)/2, 37/2, 38/2)];
            [searchBtn setImage:[UIImage imageNamed:@"search_@2x"] forState:UIControlStateNormal];
            [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
            [btn addSubview:searchBtn];
        }

    }
    
    if (open == NO && [_mymodel.listTitle isEqualToString:@"他人"]) {
        footerView.backgroundColor = [UIColor whiteColor];
    }
    if (open == YES && white == YES &&[_mymodel.listTitle isEqualToString:@"他人"] ) {
        footerView.backgroundColor = [UIColor whiteColor];
    }
    
    //给section 加线
    for (int i = 0 ;  i < 2; i++) {
        UIView *xian = [[UIView alloc]initWithFrame:FRAME(0, 0+i*54, SELF_VIEW_WIDTH, 0.5)];
        xian.backgroundColor = COLOR_VAULE(209.0);
        [footerView addSubview:xian];
    }

    // Add the label
    
    UILabel * footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 5, 120.0, 45.0)];
    
    footerLabel.backgroundColor = [UIColor clearColor];
    
    footerLabel.opaque = NO;
    
    footerLabel.text = [titleArray objectAtIndex:section];
    
    footerLabel.textColor = HEX_TO_UICOLOR(0x666666, 0.8);
    
    footerLabel.highlightedTextColor = [UIColor blueColor];
    
    footerLabel.font = [UIFont systemFontOfSize:13];
    
    footerLabel.shadowColor = [UIColor clearColor];
    
    footerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    
    [footerView addSubview: footerLabel];

    
    UILabel* detailLab = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 160.0, 108/2)];
    
    detailLab.tag = section+800;
    
    detailLab.backgroundColor = [UIColor clearColor];
    
    detailLab.textAlignment = NSTextAlignmentRight;
    
    detailLab.opaque = NO;
    
//    detailLab.text = [detailArray objectAtIndex:section];
    
    detailLab.textColor = HEX_TO_UICOLOR(0xb1b1b1, 1.0);
    
    detailLab.highlightedTextColor = [UIColor blueColor];
    
    detailLab.font = [UIFont systemFontOfSize:13];
    
    detailLab.shadowColor = [UIColor clearColor];
    
    detailLab.shadowOffset = CGSizeMake(0.0, 1.0);
    
    [footerView addSubview: detailLab];
    
    
    if (detailLab.tag == 801) {
        detailLab.text = @"";
    }
    if(detailLab.tag == 802){
        detailLab.text = _mymodel.time;
    }
    if(detailLab.tag == 803){
        detailLab.text = _mymodel.date;
    }
    if(detailLab.tag == 804){
        detailLab.text = _mymodel.zhouqi;
    }
    if(detailLab.tag == 805){
        detailLab.text = _mymodel.beizhu;
    }

    //给每个section一个按钮
    sectionBtn = [[UIButton alloc]initWithFrame:FRAME(0, 0, SELF_VIEW_WIDTH, 108/2)];
    
    [sectionBtn setBackgroundColor:DEFAULT_COLOR];
    
    sectionBtn.tag = section+300;
    
    [sectionBtn addTarget:self action:@selector(sectionTuch:) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:sectionBtn];
    //提醒标题textfield
    if (sectionBtn.tag == 301) {
        
        titileTextField = [[UITextField alloc]initWithFrame:FRAME(100, 2, 212, 100/2)];
        
        titileTextField.delegate = self;
        
        titileTextField.font = [UIFont systemFontOfSize:13];
        
        titileTextField.placeholder = @"未输入";
        
        
        if(![_mymodel.biaoti isEqualToString:@"未输入"]){
        titileTextField.text = _mymodel.biaoti;
        }
        
        titileTextField.textColor = HEX_TO_UICOLOR(0xb1b1b1, 1.0);
        
        titileTextField.textAlignment = NSTextAlignmentRight;
        
        [sectionBtn addSubview:titileTextField];
        
//        if (titileTextField.text.length != 0) {
//            titileTextField.backgroundColor = [UIColor whiteColor];
//        }
        
    }

    if (sectionBtn.tag == 300) {
        
        namebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        namebtn.frame = CGRectMake(SELF_VIEW_WIDTH-58-10, 0, 60, 108/2);
        [namebtn setTitle:_mymodel.listTitle forState:UIControlStateNormal];
        [namebtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [namebtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [namebtn setImage:[UIImage imageNamed:@"drop-down-list_03@2x"] forState:UIControlStateNormal];
        [namebtn setImageEdgeInsets:UIEdgeInsetsMake((54-17/2)/2, 60-31/2, (54-17/2)/2, 0)];
        if (namebtn.titleLabel.text == nil) {
            [namebtn setTitle:@"我" forState:UIControlStateNormal];
            
        }
        //            namebtn.backgroundColor = [UIColor grayColor];
        [namebtn setTitleColor:HEX_TO_UICOLOR(0xb1b1b1, 1.0) forState:UIControlStateNormal];
        namebtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [namebtn addTarget:self action:@selector(selectUser:) forControlEvents:UIControlEventTouchUpInside];
        [sectionBtn addSubview:namebtn];
        
        NSArray *dressArr = @[@"我",@"他人"];
        
        listView = [[SelectCityView alloc]initWithFrame:FRAME(SELF_VIEW_WIDTH-18-30-20, 20+296/2+74/2+15, 55, 0) titleArray:dressArr];
        listView.backgroundColor = HEX_TO_UICOLOR(0xE8374A, 1.0);
        listView.hidden = YES;
        listView.delegate = self;
        [self.view addSubview:listView];
    }
    
    return footerView;
    
}
#pragma mark 展开cell
- (void)collapseOrExpand
{
//    [_mytableview reloadData];
    [self readAllPeoples];
    
}
#pragma mark 关闭cell
- (void)closeTable
{
    resultArray = nil;
}
#pragma mark 读取通讯录
-(void)readAllPeoples

{
    resultArray = [[NSMutableArray alloc]init];
    ABAddressBookRef addressBook = nil;
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 6.0)
    {
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else
    {
        addressBook = ABAddressBookCreate();
    }
    
    NSArray *temPeoples = (__bridge NSArray *) ABAddressBookCopyArrayOfAllPeople(addressBook);
    for(id temPerson in temPeoples)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
        NSMutableArray *phoneArray = [[NSMutableArray alloc] initWithCapacity:3];
        
        NSString *tmpFirstName = (__bridge NSString *) ABRecordCopyValue((__bridge ABRecordRef)(temPerson), kABPersonFirstNameProperty);
        NSString *tmpLastName = (__bridge NSString *) ABRecordCopyValue((__bridge ABRecordRef)(temPerson), kABPersonLastNameProperty);
        if(tmpLastName == nil)
        {
            tmpLastName = @"";
        }
        if (tmpFirstName == nil) {
            tmpFirstName = @"";
        }
        [dic setValue:[NSString stringWithFormat:@"%@ %@", tmpFirstName, tmpLastName] forKey:@"name"];
//        [dic setValue:[NSString stringWithFormat:@"%@", tmpFirstName] forKey:@"name"];
        ABMultiValueRef phone = ABRecordCopyValue((__bridge ABRecordRef)(temPerson), kABPersonPhoneProperty);
        
        for(int k = 0; k < ABMultiValueGetCount(phone); k++)
        {
            NSString *personPhone = (__bridge NSString *) ABMultiValueCopyValueAtIndex(phone, k);
            [phoneArray addObject:personPhone];
        }
        
        [dic setValue:phoneArray forKey:@"phone"];
        [resultArray addObject:dic];
        [userArray addObject:dic];
        NSLog(@"resultarr = : %@",resultArray);
    }

}

#pragma mark cell
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    int height = 54;
    if ([_mymodel.listTitle isEqualToString:@"他人"]) {
        if (section == 0) {
            height = 88;
        }
    }else{
        height = 54;
    }
    if (open == NO && [_mymodel.listTitle isEqualToString:@"他人"]) {
        if (section == 0) {
            height = 54;
        }
    }
    return height;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108/2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return resultArray.count;
    }else{
        return 0;
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    SetRemindCell *Cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (Cell == nil) {
        Cell = [[SetRemindCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    
    Cell.backgroundView = nil;
    Cell.selectionStyle = UITableViewCellSelectionStyleGray;

    Cell.title.text = [[resultArray objectAtIndex:indexPath.row]objectForKey:@"name"];
    Cell.detailTitle.text = [[[resultArray objectAtIndex:indexPath.row]objectForKey:@"phone"] objectAtIndex:0];//手机号为空就崩溃 待解决

    Cell.tag = indexPath.row+600;
    
    return Cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    open = NO;
    
    NSString *name = [[resultArray objectAtIndex:indexPath.row]objectForKey:@"name"];
    NSString *phone = [[resultArray objectAtIndex:indexPath.row]objectForKey:@"phone"];
    
    [resultArray removeAllObjects];
    
    NSLog(@"name = %@   phone = %@",name,phone);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];

    [dic setValue:name forKey:@"name"];
    [dic setValue:phone forKey:@"phone"];
    
    NSLog(@"dic = %@",dic);
    
    [resultArray addObject:dic];
    
    NSLog(@"restArray = %@",resultArray);
    
    [_mytableview reloadData];
    
}
#pragma mark 滚动的时候
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    listView.hidden = YES;
    if (resultArray.count > 0)
    {
        [namebtn setTitle:@"他人" forState:UIControlStateNormal];
    }
    else{
        [namebtn setTitle:@"我" forState:UIControlStateNormal];
    }
}
#pragma mark section　点击事件
- (void)sectionTuch:(UIButton *)btn
{
    listView.hidden = YES;
    
    if (btn.tag == 301) {
        NSLog(@"提醒标题");
    }
    if (btn.tag == 302) {
        NSLog(@"提醒时间");
        
        [self zhezhao];
        
        [UIView beginAnimations: @"Animation" context:nil];
        [UIView setAnimationDuration:0.3];
        timepic.frame = FRAME(0, SELF_VIEW_HEIGHT-220, SELF_VIEW_WIDTH, 220);
        [UIView commitAnimations];
        [self.view addSubview:timepic];
        [titileTextField resignFirstResponder];

    }
    if (btn.tag == 303) {
        [self zhezhao];
        NSLog(@"日期");
        datePicker = [[DatePicker alloc]initWithFrame:FRAME(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 250)];
        datePicker.delegate = self;
//        datePicker.backgroundColor = [UIColor grayColor];
        [UIView beginAnimations: @"Animation" context:nil];
        [UIView setAnimationDuration:0.3];
        datePicker.frame = FRAME(0, SELF_VIEW_HEIGHT-250, SELF_VIEW_WIDTH, 250);
        [UIView commitAnimations];
        [self.view addSubview:datePicker];
    }
    if (btn.tag == 304) {
        [self zhezhao];

        if (APPLIACTION.repartArray.count > 0) {
            
        }
        else
        {
            [APPLIACTION.repartArray addObject:[NSString stringWithFormat:@"一次性活动"]];
            [APPLIACTION.repartArray addObject:[NSString stringWithFormat:@"每天"]];
            //            [MBProgressHUD showError:@"请选择提醒时间" toView:self.view];
        }
        
        NSInteger i = APPLIACTION.repartArray.count;
        NSInteger repart_height = 50+i*40;
        
        NSLog(@"repartarray = %@",APPLIACTION.repartArray);
        repeartView = [[RepeatCycle alloc]initWithFrame:FRAME(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, repart_height) numbenr:_mymodel.number];
        repeartView.delegate =self;
        
        [UIView beginAnimations: @"Animation" context:nil];
        [UIView setAnimationDuration:0.3];
        repeartView.frame = FRAME(0, SELF_VIEW_HEIGHT-repart_height, SELF_VIEW_WIDTH, repart_height);
        [UIView commitAnimations];

        [self.view addSubview:repeartView];
        
    }
    if (btn.tag == 305) {
        
        BeiZhuViewController *beizhu = [[BeiZhuViewController alloc]init];
        beizhu.delegate = self;
        [self.navigationController pushViewController:beizhu animated:YES];
        
    }

}
#pragma mark 移除键盘
//通过委托方法实现隐藏键盘
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    
    [titileTextField resignFirstResponder];
    [userTextfield resignFirstResponder];

    [_mytableview reloadData];
    return YES;
    
}
#pragma mark textField
//textField开始编辑时触发
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
//    _mymodel.biaoti = titileTextField.text;
}

//textField编辑结束时
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    _mymodel.biaoti = titileTextField.text;
    _mymodel.userTextFieldText = userTextfield.text;

    
    return YES;
}


#pragma mark 搜索联系人
- (void) textFieldDidChanged:(NSNotification *)notification
{
    
    if ([userTextfield isFirstResponder]) {
        NSArray *searchResult = (NSArray *)[self searchForMatchedStockList];
        NSLog(@"* * * * * * * * *searchResult = %@",searchResult);
        
        [resultArray removeAllObjects];
        
        if (searchResult && [searchResult count] > 0)
        {
            [resultArray removeAllObjects];
            [resultArray addObjectsFromArray:searchResult];
        }else{
            [resultArray removeAllObjects];
            [resultArray addObjectsFromArray:userArray];
        }   

    }
    

}
#pragma mark 输入文字改变的时候
- (NSMutableArray *) searchForMatchedStockList{
    NSString *conditionStr = userTextfield.text;
    NSMutableArray *result = [NSMutableArray array];
    
    if (conditionStr && ![conditionStr isEqualToString:@""])
    {

        NSLog(@"userArray ******** %@",userArray);
  
        for (int i = 0; i < [userArray count]; i ++)
        {
            NSDictionary *dict = [userArray objectAtIndex:i];
            NSString *pinyinStr = [dict objectForKey:@"name"];
    
            if (pinyinStr && ![pinyinStr isEqualToString:@""])
            {
                NSRange range = [pinyinStr rangeOfString:conditionStr];
                if (range.location != NSNotFound && range.length > 0)
                {

                    [result addObject:dict];
                    
                    continue;
                }
            }
        }
    }
    NSLog(@"result = %@",result);
    return result;
}
#pragma mark tixingTimepic 代理
- (void)timepicCanle
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    timepic.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
    
    [zhezhao removeFromSuperview];

}
- (void)TimePicSure:(NSString *)timeStr
{
    NSLog(@"time %@",timeStr);
    _mymodel.time = [NSString stringWithFormat:@"%@",timeStr];
    [_mytableview reloadData];
    
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    timepic.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
    
    [zhezhao removeFromSuperview];
}

#pragma mark datePicker 代理
- (void)dateQuxiao
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    datePicker.frame = FRAME(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 250);
    [UIView commitAnimations];
    
    [zhezhao removeFromSuperview];
}
-(void)dateQueding:(NSString *)date
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    datePicker.frame = FRAME(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 250);
    [UIView commitAnimations];
    
    _mymodel.date = [NSString stringWithFormat:@"%@",date];
    [_mytableview reloadData];
    
    [zhezhao removeFromSuperview];
    //判断星期几
    
    //判断星期几
    NSString *year = [date substringWithRange:NSMakeRange(0, 4)];
    NSString *day = [date substringWithRange:NSMakeRange(8, 2)];
    NSString *month = [date substringWithRange:NSMakeRange(5, 2)];
    NSLog(@"day:%@month:%@",day,month);
    
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:[day intValue]];
    [_comps setMonth:[month intValue]];
    [_comps setYear:[year intValue]];
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

    
   
    [APPLIACTION.repartArray removeAllObjects];

    
    if ([str isEqualToString:@"六"] || [str isEqualToString:@"日"])  {
        [APPLIACTION.repartArray addObject:[NSString stringWithFormat:@"一次性活动"]];
        [APPLIACTION.repartArray addObject:[NSString stringWithFormat:@"每天"]];
        [APPLIACTION.repartArray addObject:[NSString stringWithFormat:@"每周(每月的星期%@)",str]];
        [APPLIACTION.repartArray addObject:[NSString stringWithFormat:@"每月(%@日)",day]];
        [APPLIACTION.repartArray addObject:[NSString stringWithFormat:@"每年(%@月%@日)",month,day]];
        
    }
    else
    {
        [APPLIACTION.repartArray addObject:[NSString stringWithFormat:@"一次性活动"]];
        [APPLIACTION.repartArray addObject:[NSString stringWithFormat:@"每天"]];
        [APPLIACTION.repartArray addObject:[NSString stringWithFormat:@"每个工作日（周一至周五）"]];
        [APPLIACTION.repartArray addObject:[NSString stringWithFormat:@"每周（每周的星期%@）",str]];
        [APPLIACTION.repartArray addObject:[NSString stringWithFormat:@"每月（%@日）",day]];
        [APPLIACTION.repartArray addObject:[NSString stringWithFormat:@"每年（%@月%@日）",month,day]];
    }

    _mymodel.week = [NSString stringWithFormat:@"%@",str];
    
    NSLog(@"APPLIACTION.repartArray = %@",APPLIACTION.repartArray);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 备注 － 代理
- (void)BeiZhuDelegateLable:(NSString *)textViewtext
{
    _mymodel.beizhu = textViewtext;
    [_mytableview reloadData];
}
#pragma mark 重复周期  代理
- (void)repeartdelegate:(NSString *)str Celltag:(NSInteger)tag
{
    
    NSLog(@"选了什么周期了？ ＝ ＝ %@",str);
    NSLog(@"选了第 %ld 行",(long)tag);
    _mymodel.zhouqi = str;
    _mymodel.number = tag;
    [_mytableview reloadData];
    
    NSInteger i = APPLIACTION.repartArray.count;
    NSInteger repart_height = 50+i*40;
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    repeartView.frame = FRAME(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, repart_height);
    [UIView commitAnimations];
    
    [zhezhao removeFromSuperview];
}
#pragma mark 遮罩试图
- (void)zhezhao
{
    zhezhao = [[UIView alloc]initWithFrame:FRAME(0, 0, SELF_VIEW_WIDTH, SELF_VIEW_HEIGHT)];
    zhezhao.backgroundColor = [UIColor blackColor];
    zhezhao.alpha = 0.5;
    [self.view addSubview:zhezhao];
}
#pragma mark 请选择通讯录好友按钮
- (void)heqilai
{
    resultArray = nil;
//    [namebtn setTitle:@"我" forState:UIControlStateNormal];
    _mymodel.listTitle = @"我";

    open = NO;
    
    [_mytableview reloadData];
}
#pragma mark 搜索联系人  
- (void)searchAction
{
//    [self textFieldDidChanged:];
    [userTextfield resignFirstResponder];
}
- (void)addRemind
{
    
    if ([_mymodel.listTitle isEqualToString:@"他人"]) {
        if (open == YES) {
            [MBProgressHUD showError:@"请选择联系人" toView:self.view];
            return;
        }
    }
    if ([_mymodel.time isEqualToString:@"未选择"]){
        
        [MBProgressHUD showError:@"请选择时间" toView:self.view];
        return;
    }else if ([_mymodel.date isEqualToString:[NSNull null]] || [_mymodel.date isEqualToString:@"未选择"]){
        [MBProgressHUD showError:@"请选择日期" toView:self.view];
        return;
    }

    if ([namebtn.titleLabel.text isEqualToString:@"我"]) {    //当添加或修改一个本地提醒的时候
        [self naozhong];
    }
    if([namebtn.titleLabel.text isEqualToString:@"他人"] ){    //当添加或修改一个他人提醒的时候
        [self remindOther];
    }
    

}
- (void)remindOther
{

    if (logmanager.isLogin == NO) {
//        MyLogInViewController *log = [[MyLogInViewController alloc]init];
//        log.vCLID=0;
//        [self.navigationController presentViewController:log animated:YES completion:nil];
        return;
    }

    if ([superior isEqualToString:@"提醒详情"]) { //当修改一个闹钟的时候
        
    }else{
        
    }
    int cycle = [self GetCycleType];
//他人手机号码
    NSString *str = [NSString stringWithFormat:@"%@",[[[resultArray objectAtIndex:0] objectForKey:@"phone"] objectAtIndex:0]];
    NSString *otherMobile = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
//    NSArray *userArr = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"TIXING"]];
//    NSLog(@"userArr :%@",userArr);
    
    NSMutableDictionary *sourceDic = [[NSMutableDictionary alloc]init];
    [sourceDic setObject:logmanager.telephone  forKey:@"user_id"];
    [sourceDic setObject:[NSString stringWithFormat:@"0"]  forKey:@"remind_id"];
    [sourceDic setObject:_mymodel.biaoti  forKey:@"remind_title"];
    [sourceDic setObject:_mymodel.date  forKey:@"start_date"];
    [sourceDic setObject:_mymodel.time  forKey:@"start_time"];
    [sourceDic setObject:[NSString stringWithFormat:@"%i",cycle]  forKey:@"cycle_type"];
    [sourceDic setObject:[[resultArray objectAtIndex:0] objectForKey:@"name"]  forKey:@"remind_to_name"];
    [sourceDic setObject:otherMobile  forKey:@"remind_to_mobile"];
    [sourceDic setObject:_mymodel.beizhu  forKey:@"remarks"];
    [sourceDic setObject:@"0,1,0"  forKey:@"remind_type"];

    NSLog(@"请求dic = %@",sourceDic);
    DownloadManager *_download = [[DownloadManager alloc]init];
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",REMIND_SAVE] dict:sourceDic view:self.view delegate:self finishedSEL:@selector(RemindDownlLoadFinish:) isPost:YES failedSEL:@selector(RemindDownloadFail:)];
    
}
- (int)GetCycleType{
    //周期设置
    int cycle = 0;
    if ([_mymodel.week isEqualToString:@"六"]||[_mymodel.week isEqualToString:@"日"]) {
        if(_mymodel.number == 0){
            //一次性
            cycle = 0;
        }
        if(_mymodel.number == 1)
        {
            //每天
            cycle  = 1;
        }
        if(_mymodel.number == 2)
        {
            //每周（每月的星期几）
            cycle = 3;
        }
        if(_mymodel.number == 3)
        {
            //每月＊日
            cycle = 4;
        }
        if(_mymodel.number == 4)
        {
            //每年（几月几日）
            cycle = 5;
        }
    }else{
        if(_mymodel.number == 0){
            //一次性
            cycle = 0;
        }
        if(_mymodel.number == 1)
        {
            //每天
            cycle = 1;
        }
        if(_mymodel.number == 2)
        {
            //每个工作日
            cycle = 2;
        }
        if(_mymodel.number == 3)
        {
            //每周（每月的星期几）
            cycle = 3;
        }
        if(_mymodel.number == 4)
        {
            //每月＊日
            cycle = 4;
        }
        if(_mymodel.number == 5)
        {
            //每年（几月几日）
            cycle = 5;
        }
    }
        return cycle;
}
- (void)RemindDownlLoadFinish:(id)dict
{
 
    NSLog(@"remdic = %@",dict);
    
    int status = [[dict objectForKey:@"status"] intValue];
    NSString *remindID = [[dict objectForKey:@"data"] objectForKey:@"remind_id"];
    if (status == 0) {
        
        if ([superior isEqualToString:@"提醒详情"]) {
            [self ChangeUserdefaults:remindID];
        }else{
            [self AddUserDefaults:remindID];
        }

        [self.delegate SetRemDelegate];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}
- (void)RemindDownloadFail:(id)error
{
    NSLog(@"%@",error);
}
#pragma mark 当修改闹钟的时候 修改本地存储的数据
- (void)ChangeUserdefaults:(NSString *)remindID
{
    NSString *title;
    
    if (_mymodel.biaoti == nil ||[_mymodel.biaoti isEqualToString:@"未输入"]) {
        
        title = @"";
        
    }else{
        
        title = _mymodel.biaoti;
        
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:_mymodel.beizhu forKey:@"beizhu"];
    [dic setValue:title forKey:@"biaoti"];
    [dic setValue:_mymodel.date forKey:@"date"];
    [dic setValue:_mymodel.time forKey:@"time"];
    [dic setValue:namebtn.titleLabel.text forKey:@"user"];
    [dic setValue:remindID forKey:@"remindId"];
    if (_mymodel.week == nil) {
        [dic setValue:week forKey:@"week"];
    }else{
        [dic setValue:_mymodel.week forKey:@"week"];
    }
    
    [dic setValue:_mymodel.zhouqi forKey:@"zhouqi"];
 
    if ([namebtn.titleLabel.text isEqualToString:@"他人"]) {
        if (resultArray != nil) {
            [dic setValue:[[resultArray objectAtIndex:0] objectForKey:@"name"] forKey:@"othername"];
            [dic setValue:[[resultArray objectAtIndex:0] objectForKey:@"phone"] forKey:@"othernumber"];
        }else{
            [dic setValue:[[[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"] objectAtIndex:arrIndex] objectForKey:@"othername"] forKey:@"othername"];
            [dic setValue:[[[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"] objectAtIndex:arrIndex] objectForKey:@"othernumber"] forKey:@"othernumber"];
        }
        
    }
    [remindArray setObject:dic atIndexedSubscript:arrIndex];
    [self removeNotifation];//把要修改的闹钟删除
    NSLog(@"remindArray = %@",remindArray);

    NSUserDefaults *mydefaults = [NSUserDefaults standardUserDefaults];
    
    [mydefaults setValue:remindArray forKey:@"TIXING"];
    
    [mydefaults synchronize];
}
#pragma mark 添加新闹钟的时候存到本地
- (void)AddUserDefaults:(NSString *)remindID
{
    NSString *title;
    
    if (_mymodel.biaoti == nil ||[_mymodel.biaoti isEqualToString:@"未输入"]) {
        
        title = @"";
        
    }else{
        
        title = _mymodel.biaoti;
        
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:namebtn.titleLabel.text forKey:@"user"];
    
    [dic setValue:_mymodel.time forKey:@"time"];
    
    [dic setValue:title forKey:@"biaoti"];
    
    [dic setValue:_mymodel.date forKey:@"date"];
    
    [dic setValue:_mymodel.zhouqi forKey:@"zhouqi"];
    
    [dic setValue:_mymodel.beizhu forKey:@"beizhu"];
    
    [dic setValue:_mymodel.week forKey:@"week"];
    
    [dic setValue:remindID forKey:@"remindId"];
    
    if ([namebtn.titleLabel.text isEqualToString:@"他人"]) {
        [dic setValue:[[resultArray objectAtIndex:0] objectForKey:@"name"] forKey:@"othername"];
        [dic setValue:[[resultArray objectAtIndex:0] objectForKey:@"phone"] forKey:@"othernumber"];
    }
    
    [remindArray addObject:dic];
    
    NSLog(@"remindArray = %@",remindArray);
    
    NSUserDefaults *mydefaults = [NSUserDefaults standardUserDefaults];
    
    [mydefaults setValue:remindArray forKey:@"TIXING"];
    
    [mydefaults synchronize];
}
#pragma mark 闹钟
- (void)naozhong{
    
    //_notification=[[UILocalNotification alloc]init];
    NSLog(@"时间%@ %@",_mymodel.date,_mymodel.time);
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date=[df dateFromString:[NSString stringWithFormat:@"%@ %@",_mymodel.date,_mymodel.time]];
    
    //移除通知时用
    NSDictionary *infoDic = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ %@",_mymodel.date,_mymodel.time] forKey:@"biaoshi"];
    NSLog(@"%@",infoDic);
//    _notification.userInfo = infoDic;
    

    int badge = -1;
//    _notification = [APService
//                     setLocalNotification:date
//                     alertBody:[NSString stringWithFormat:@"私秘提醒您：\n%@ %@\n%@",_mymodel.date,_mymodel.time,_mymodel.biaoti]
//                     badge:badge
//                     alertAction:nil
//                     identifierKey:@"确定"
//                     userInfo:infoDic
//                     soundName:@"sound.caf"];
    //周期设置
    if ([_mymodel.week isEqualToString:@"六"]||[_mymodel.week isEqualToString:@"日"]) {
        if(_mymodel.number == 0){
            //一次性
//            _notification.repeatInterval= 0;
        }
        if(_mymodel.number == 1)
        {
            //每天
//            _notification.repeatInterval=NSDayCalendarUnit;
        }
        if(_mymodel.number == 2)
        {
            //每周（每月的星期几）
//            _notification.repeatInterval=NSCalendarUnitWeekday;
        }
        if(_mymodel.number == 3)
        {
            //每月＊日
//            _notification.repeatInterval=NSCalendarUnitMonth;
        }
        if(_mymodel.number == 4)
        {
            //每年（几月几日）
//            _notification.repeatInterval=NSCalendarUnitYear;
        }
    }else{
        if(_mymodel.number == 0){
            //一次性
//            _notification.repeatInterval= 0;
        }
        if(_mymodel.number == 1)
        {
            //每天
//            _notification.repeatInterval= NSDayCalendarUnit;
        }
        if(_mymodel.number == 2)
        {
            //每个工作日
//            _notification.repeatInterval= NSCalendarUnitWeekday;
        }
        if(_mymodel.number == 3)
        {
            //每周（每月的星期几）
//            _notification.repeatInterval= NSCalendarUnitWeekdayOrdinal;
        }
        if(_mymodel.number == 4)
        {
            //每月＊日
//            _notification.repeatInterval= NSCalendarUnitMonth;
        }
        if(_mymodel.number == 5)
        {
            //每年（几月几日）
//            _notification.repeatInterval= NSCalendarUnitYear;
        }
    }

//    _notification.soundName = UILocalNotificationDefaultSoundName;
    
    NSString *result;
//    if (_notification) {
//        
//        result = @"设置闹钟成功";
//        
//        [[UIApplication sharedApplication] scheduleLocalNotification:_notification];
//        
//        if ([superior isEqualToString:@"提醒详情"]) {
//            [self ChangeUserdefaults:nil];
//        }else{
//            [self AddUserDefaults:nil];
//        }
//        
//        [self.delegate SetRemDelegate];
//        
//        [self.navigationController popViewControllerAnimated:YES];
//        
//        
//    } else {
//        result = @"设置闹钟失败";
//    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"设置"
                                                    message:result
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];

}
- (void)removeNotifation
{
    NSArray *narry=[[UIApplication sharedApplication] scheduledLocalNotifications];
    NSUInteger acount=[narry count];
    //    UILocalNotification *notificationtag;
    if (acount>0){
        // 遍历找到对应nfkey和notificationtag的通知
        for (int i=0; i<acount; i++){
            UILocalNotification *myUILocalNotification = [narry objectAtIndex:i];
            NSDictionary *userInfo = myUILocalNotification.userInfo;
            NSNumber *obj = [userInfo objectForKey:@"arrCount"];
            int mytag=[obj intValue];
            
            if (mytag==arrIndex+1)
            {
                // 删除本地通知
                [[UIApplication sharedApplication] cancelLocalNotification:myUILocalNotification];
                break;
            }
        }
    }
}
#pragma mark 打电话
- (void)CallAction
{
    BOOL login = [self loginYesOrNo];
    if (login == YES) {
        //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"联系我们的客服专线" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        //        alert.tag = 30;
        //        [alert show];
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
    BOOL login = [self loginYesOrNo];
    if (login == YES) {
        AppDelegate *app = [[AppDelegate alloc]init];
        app.deletate = self;
        [app huanxin];
    }
    else{
        //        [self showAlertViewWithTitle:@"提示" message:@"请先登陆"];
        UIAlertView *LogalertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        LogalertView.tag = 10;
        [LogalertView show];
    }
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
/*
#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
