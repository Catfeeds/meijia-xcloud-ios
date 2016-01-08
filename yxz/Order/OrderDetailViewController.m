//
//  OrderDetailViewController.m
//  simi
//
//  Created by 赵中杰 on 14/12/5.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "DownloadManager.h"
#import "CancelOrderView.h"
#import "AddOrderDiscussViewController.h"
#import "MBProgressHUD+Add.h"

#import "ISLoginManager.h"
#import "BaiduMobStat.h"
#import "PayViewController.h"
@interface OrderDetailViewController()
<
    OEDERDETAILDELEGATE,
    UIAlertViewDelegate
>
{
    CancelOrderView *_myview;
    ISLoginManager *_manager;
}
@end

@implementation OrderDetailViewController

@synthesize listdata = _listdata;

-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"订单详情", nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"订单详情", nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.navlabel.text = @"订 单 详 情";
    

    
}
- (void)viewWillAppear:(BOOL)animated{
    _manager = [ISLoginManager shareManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChanGeOrderStatus:) name:@"CHANGE_ORDERSTATUS" object:nil];
    
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSMutableDictionary *_parm = [[NSMutableDictionary alloc]initWithObjectsAndKeys:_manager.telephone,@"mobile",self.listdata.orderNo,@"order_no", nil];
    [_download requestWithUrl:ORDER_DETAIL dict:_parm view:self.view delegate:self finishedSEL:@selector(DownLoadFinish:) isPost:NO failedSEL:@selector(DownLoadFail:)];
    
    _myview = [[CancelOrderView alloc]initWithFrame:FRAME(0, 64+9, _WIDTH, _HEIGHT-64-9) ordelListData:self.listdata];
    _myview.delegate = self;
    [self.view addSubview:_myview];
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 获取订单详情接口
- (void)DownLoadFinish:(id)responsobject
{
    NSLog(@"object is %@",responsobject);
    ORDERDETAILBaseClass *_baseclass = [[ORDERDETAILBaseClass alloc]initWithDictionary:responsobject];
    _myview.mydata = _baseclass.data;
    
}

#pragma mark 订单详情失败
- (void)DownLoadFail:(id)responsobject
{
    
}


#pragma mark 取消订单成功
- (void)CancelSuccess:(id)responsobject
{
    NSInteger _status = [[responsobject objectForKey:@"status"] integerValue];
    
    
    if (_status == 0) {
        [MBProgressHUD showSuccess:@"取消订单成功" toView:self.view];
        
        self.listdata.orderStatus = 0;
        
//        if (_myview != nil) {
//            _myview = nil;
//            [_myview removeFromSuperview];
//        }
        [_myview removeFromSuperview];
        
        _myview = [[CancelOrderView alloc]initWithFrame:FRAME(0, 64+9, _WIDTH, _HEIGHT-64-9) ordelListData:self.listdata];
        _myview.delegate = self;
        
        [self.view addSubview:_myview];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_ORDERSTATUS" object:@"cancel"];
        
    }
}

#pragma mark 评价完成
- (void)ChanGeOrderStatus:(NSNotification *)noti
{
    
    if ([noti.object isEqualToString:@"cancel"]) {
    }else if ([noti.object isEqualToString:@"discuss"]){
        self.listdata.orderStatus = 6;
        if (_myview != nil) {
            _myview = nil;
            [_myview removeFromSuperview];
            
        }
        
//        _myview = [[CancelOrderView alloc]initWithFrame:FRAME(0, 64+9, _WIDTH, _HEIGHT-64-9) ordelListData:self.listdata];
//        _myview.delegate = self;
//        [self.view addSubview:_myview];
 

    }
    
}



- (void)OrderBtnPressed:(NSString *)typestr
{
    
    if ([typestr isEqualToString:@"取消"]) {
        NSMutableDictionary *_parm = [[NSMutableDictionary alloc]initWithObjectsAndKeys:_manager.telephone,@"mobile",self.listdata.orderNo,@"order_no", nil];

        DownloadManager *_download = [[DownloadManager alloc]init];
        [_download requestWithUrl:ORDER_CANCLE dict:_parm view:self.view delegate:self finishedSEL:@selector(orderCancle:) isPost:YES failedSEL:@selector(DownLoadFail:)];
        
    } else if ([typestr isEqualToString:@"支付"]){
        PayViewController *pay = [[PayViewController alloc]init];
        pay.orderID = [NSString stringWithFormat:@"%.f", _myview.mydata.orderId];
        pay.orderNum = [NSString stringWithFormat:@"%@",_myview.mydata.orderNo];
        pay.price = [NSString stringWithFormat:@"%.1f",_myview.mydata.orderMoney];
        pay.juanLX = [NSString stringWithFormat:@"%.f",self.listdata.serviceType];
        pay.time = [NSString stringWithFormat:@"周%@ %@",[self zhouji],[self getTimeWithstring:_listdata.startTime]];
        
        [self.navigationController pushViewController:pay animated:YES];
    }
    else{
        AddOrderDiscussViewController *_controller = [[AddOrderDiscussViewController alloc]init];
        _controller.ordernumber = _listdata.orderNo;
        _controller.startTime = [self getTimeWithstring:_listdata.startTime];
        NSString *city;
        if (_listdata.cityId == 2) {
            city = @"北京";
        }else{
            city = @"天津";
        }
       _controller.address =[NSString stringWithFormat:@"%@%@%@",city,_listdata.name,_listdata.addstr] ;
       _controller.ServiceType = [NSString stringWithFormat:@"%.f",_listdata.serviceType];
        [self.navigationController pushViewController:_controller animated:YES];

    }
}
-(void)orderCancle:(id)responsobject
{
    NSInteger _status = [[responsobject objectForKey:@"status"] integerValue];
    
    
    if (_status == 0) {  //订单可以取消
        NSString *msg = [responsobject objectForKey:@"msg"];
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"返回", nil];
        [alert show];
    }else if (_status == 999){ //订单不能取消
        NSString *msg = [responsobject objectForKey:@"msg"];
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{ //订单已经取消
        NSString *msg = [responsobject objectForKey:@"msg"];
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self orderCancle];
    }else{
        NSLog(@"2");
    }
}
-(void)orderCancle
{
    NSMutableDictionary *_parm = [[NSMutableDictionary alloc]initWithObjectsAndKeys:_manager.telephone,@"mobile",self.listdata.orderNo,@"order_no", nil];
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    [_download requestWithUrl:CANCEL_ORDER dict:_parm view:self.view delegate:self finishedSEL:@selector(CancelSuccess:) isPost:YES failedSEL:@selector(DownLoadFail:)];
}
- (NSString *)getTimeWithstring:(NSTimeInterval)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *theday = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *day = [dateFormatter stringFromDate:theday];
    
    return day;
}
- (NSString *)zhouji
{
    //判断星期几
    NSString *day = [[self getTimeWithstring:_listdata.startTime] substringWithRange:NSMakeRange(8, 2)];
    NSString *month = [[self getTimeWithstring:_listdata.startTime] substringWithRange:NSMakeRange(5, 2)];
    NSString *year = [[self getTimeWithstring:_listdata.startTime] substringWithRange:NSMakeRange(0, 4)];
    NSLog(@"year: %@   day:%@    month:%@",year,day,month);
    
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:[day intValue]];
    [_comps setMonth:[month intValue]];
    [_comps setYear:[[NSString stringWithFormat:@"%@",year] intValue]];
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
    NSLog(@"%@",str);
    return str;
}
@end
