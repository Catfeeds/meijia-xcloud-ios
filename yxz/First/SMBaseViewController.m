//
//  SMBaseViewController.m
//  simi
//
//  Created by 高鸿鹏 on 15/6/30.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "SMBaseViewController.h"
#import "ImgWebViewController.h"
#import "ISLoginManager.h"
#import "AppDelegate.h"
#import "DPAPI.h"
#import "DPRequest.h"
#import "BaseModel.h"
#import "DaZhongCell.h"
#import "ImgWebViewController.h"
#import "DownloadManager.h"
#import "LoadMoreCell.h"
@interface SMBaseViewController ()<DPRequestDelegate,NSURLConnectionDelegate,UITableViewDelegate,UITableViewDataSource,LOADMOREDELAGATE>
{
    UIButton *rightbtn;
    NSURLConnection *_connection;
    NSMutableDictionary *dataDic;
    UITableView *_myTableView;
    NSMutableArray *_dataArray;
    int pages;
    NSArray *dataArray;
}
@end

@implementation SMBaseViewController
- (void)viewWillAppear:(BOOL)animated
{
//    [self.view removeFromSuperview];
    APPLIACTION.leiName = @"66";
    //[self viewDidLoad];
    
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    APPLIACTION.leiName = @"";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backBtn.hidden = YES;
    self.navlabel.text = @"私秘";
    
    
    pages = 1;
    _dataArray = [[NSMutableArray alloc]init];

    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];

    
    [self MakeRightBtn];
    [self MaketwoImage];
    [self RequestDazhong];
    [self getUserInfo];
    
//    RootViewController *rot = [[RootViewController alloc]init];
//    [rot tabbarhiddenNO];

    
//    [self MakeTable];
    
    // Do any additional setup after loading the view.
}
- (void)getUserInfo
{
    ISLoginManager *logManager = [[ISLoginManager alloc]init];
    NSDictionary *mobelDic = [[NSDictionary alloc]initWithObjectsAndKeys:logManager.telephone,@"user_id", nil];
    DownloadManager *_download = [[DownloadManager alloc]init];

    [_download requestWithUrl:[NSString stringWithFormat:@"%@",USERINFO_API]  dict:mobelDic view:self.view delegate:self finishedSEL:@selector(getUserInfoSuccess:) isPost:NO failedSEL:@selector(getUserInfoFail:)];
    [self hideHud];
    
}
- (void)getUserInfoSuccess:(id)dic
{
    NSDictionary *dict = [dic objectForKey:@"data"];
    NSLog(@"自动登录的时候湖区的数据%@",dict);
    int status = [dict[@"status"] intValue];
    if (status == 0) {
        
        //        UserData  = [[HuanxinBase alloc]initWithDictionary:dict];
        //        APPLIACTION.huanxinBase = UserData;
        //        NSLog(@"环信账号：%@环信密码：%@",UserData.imUsername,UserData.imUserPassword);
        self.hxUserName = [dict objectForKey:@"im_username"];
        self.hxPassword = [dict objectForKey:@"im_password"];
        NSLog(@"环信账号：%@环信密码：%@",self.hxUserName,self.hxPassword);
        
        self.imToUserID = [dict objectForKey:@"im_sec_username"];
        self.imToUserName = [dict objectForKey:@"im_sec_nickname"];
        self.ID =[dict objectForKey:@"id"];
        NSLog(@"%@",self.imToUserName);
        NSLog(@"%@",[dic objectForKey:@"im_sec_nickname"]);
        
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.imToUserID forKey:@"TOHXUSERID"];
        [userDefaults setObject:self.imToUserName forKey:@"TOHXUSERNAME"];
        [userDefaults synchronize];
        
        
#warning 1.8版本 首页主要改动
        ISLoginManager *logManager = [[ISLoginManager alloc]init];
        
        if (logManager.isLogin == YES) {
//            [self CallTelephone];
        }
        
    }
    if(status){
        NSLog(@"1");
    }
}

- (void)getUserInfoFail:(id)error
{
    NSLog(@"%@",error);
}

- (void)MakeTable
{
    _myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 198, SELF_VIEW_WIDTH, SELF_VIEW_HEIGHT-190-49-8)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;

    [self.view addSubview:_myTableView];

}
- (void)MakeRightBtn
{
    rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbtn.frame = FRAME(SELF_VIEW_WIDTH-18-20-10, (40-60/2)/2+20+2, 60/2, 60/2);
    [rightbtn setTitle:@"" forState:UIControlStateNormal];
    [rightbtn setImage:[UIImage imageNamed:@"index-cellphone"] forState:UIControlStateNormal];
    [rightbtn setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    [rightbtn addTarget:self action:@selector(readMessage:) forControlEvents:UIControlEventTouchUpInside];
    rightbtn.tag =100;
    [self.view addSubview:rightbtn];
    
    UIButton *dian = [[UIButton alloc]initWithFrame:FRAME(25, 3, 8, 8)];
    dian.tag = 321;
    dian.hidden = YES;
    [dian setBackgroundImage:[UIImage imageNamed:@"dot_@2x"] forState:UIControlStateNormal];
    [rightbtn addSubview:dian];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *unRead = [user objectForKey:@"UNREADMESSAGES"];
    if ([unRead isEqualToString:@"66"]) {
        dian.hidden = NO;
    }else{
        dian.hidden = YES;
    }
    [user synchronize];
}
- (void)MaketwoImage
{
    NSError *error;
    NSURL *url=[NSURL URLWithString:@"http://123.57.173.36/simi/app/dict/get_ads.json"];
    NSData *data=[NSData dataWithContentsOfURL:url];
    NSLog( @"能否接收到数据？？%@",data);
    NSStringEncoding enc=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *str=[[NSString alloc]initWithData:data encoding:enc];
    NSData *rootData=[str dataUsingEncoding:enc];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:rootData options:NSJSONReadingMutableLeaves error:&error];
    dataArray=[dic objectForKey:@"data"];
    
    //NSString *string=[dataDic objectForKey:@""];
    
    CGFloat imgWidth = (SELF_VIEW_WIDTH-20)/2;
    
    NSArray *imgarr = [NSArray arrayWithObjects:@"SM_base_banner1",@"SM_base_Banner2", nil];
    
    for (int i = 0; i < dataArray.count; i++) {
        NSDictionary *daDic=dataArray[i];
        NSString *url=[daDic objectForKey:@"img_url"];
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSLog(@"是否转化成字典？？？%@",daDic);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:FRAME(10+(i*(imgWidth+5)), _navlabel.bottom+5, imgWidth-5, 122)];
        
        imageView.backgroundColor = i == 0? [UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1]:[UIColor greenColor];
        
        imageView.layer.masksToBounds = YES;
        
        [imageView.layer setCornerRadius:3];
        UIImage *image=[UIImage imageWithData:data];
        imageView.image = image;
        [imageView setTag:(100+i)];
        imageView.userInteractionEnabled = YES;
        [self.view addSubview:imageView];
        UITapGestureRecognizer *tapImage=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
        [imageView addGestureRecognizer:tapImage];

    }

}
-(void)imageViewTap:(UITapGestureRecognizer *)sender
{
    long i=(sender.view.tag-100);
    NSDictionary *dic=dataArray[i];
    NSString *url=[dic objectForKey:@"goto_url"];
    ImgWebViewController *web = [[ImgWebViewController alloc]init];
    web.imgurl = url;
    NSLog( @"URL%@",url);
    [self.navigationController pushViewController:web animated:YES];
    
}
- (void)readMessage:(UIButton *)sender
{
    UIButton *btn = (UIButton *)[rightbtn viewWithTag:321];
    btn.hidden = YES;

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"55" forKey:@"UNREADMESSAGES"];
    [user synchronize];
    
    ISLoginManager *manager = [[ISLoginManager alloc]init];
    NSString *url = [NSString stringWithFormat:@"http://123.57.173.36/simi-wwz/wx-news-list.html?user_id=%@&page=1",manager.telephone];
    ImgWebViewController *img = [[ImgWebViewController alloc]init];
    img.imgurl =url;
    img.title = @"消息列表";
    [self.navigationController pushViewController:img animated:YES];
    
}
- (void)RequestDazhong
{
    NSString *url = @"v1/business/find_businesses";
    NSString *params = [NSString stringWithFormat:@"city=北京&region=东城区&category=美食&has_coupon=0&sort=1&limit=20&page=%d",pages];
    DPAPI *dp = [[DPAPI alloc]init];
    [dp requestWithURL:url paramsString:params delegate:self];
}
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    NSMutableDictionary *dic = (NSMutableDictionary *)result;
    dataDic = [[NSMutableDictionary alloc]init];
    dataDic = dic;
    
    [_dataArray addObjectsFromArray:[dataDic objectForKey:@"businesses"]];
    
    [self MakeTable];
    
}
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 00.0;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _dataArray.count) {
        return 80;
    }
    else{
        return 80;

    }
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.row == _dataArray.count){
//        static NSString *CellIdentifier = @"MoreTableViewCellId";
//        LoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        cell.delegate = self;
//        if (!cell){
//            cell = [[LoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        }
//        
//        return cell;

        
//    }else{
        
        NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
        DaZhongCell *Cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
        if (Cell == nil) {
            Cell = [[DaZhongCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
        }
        
        BaseModel *base = [[BaseModel alloc]initWithDictionary:[[dataDic objectForKey:@"businesses"] objectAtIndex:indexPath.row]];
        
        Cell.baseModel = base;

        return Cell;

//    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 40)];
    
    footerView.backgroundColor = HEX_TO_UICOLOR(BAC_VIEW_COLOR, 1.0);
    
    footerView.autoresizesSubviews = YES;     //重载子视图的位置
    
    footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth; //控件的宽度随着父视图的宽度按比例改变；
    
    footerView.userInteractionEnabled = YES;
    
    footerView.hidden = NO;
    
    footerView.multipleTouchEnabled = YES;
    
    footerView.opaque = NO;  //不透明
    
    footerView.contentMode = UIViewContentModeScaleToFill;
    
    footerView.tag = section;
    
    
    UILabel *lable = [[UILabel alloc]initWithFrame:FRAME(10, 0, footerView.width-20, footerView.height)];
    lable.text = @"猜你喜欢";
    lable.textColor = [UIColor blackColor];
    lable.font = [UIFont systemFontOfSize:12];
    [footerView addSubview:lable];
    
    return footerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _dataArray.count) {
        return;
    }
    ImgWebViewController *web = [[ImgWebViewController alloc]init];
    BaseModel *base = [[BaseModel alloc]initWithDictionary:[[dataDic objectForKey:@"businesses"] objectAtIndex:indexPath.row]];
    web.title = base.name;
    web.imgurl = base.online_reservation_url;
    [self.navigationController pushViewController:web animated:YES];
    //取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)loadMoreOrder
{
    pages++;
    [self RequestDazhong];
    [_myTableView reloadData];
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
