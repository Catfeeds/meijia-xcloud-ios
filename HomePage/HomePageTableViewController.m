//
//  HomePageTableViewController.m
//  yxz
//
//  Created by 白玉林 on 16/4/5.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "HomePageTableViewController.h"
#import "CycleScrollView.h"
#import "HomePageTableViewCell.h"
#import "WholeViewController.h"
#import "CreditWebViewController.h"
#import "QRcodeViewController.h"
#import "LBXScanViewStyle.h"
#import "LBXScanViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SchoolViewController.h"
#import <objc/message.h>
@interface HomePageTableViewController ()
{
    CycleScrollView *adView;
    UITableView *myTableView;
    UIView *headeView;
    NSTimer *timer;
    BOOL isDragging;
    NSArray *imageArray;
    NSMutableData *expData;
    NSMutableArray *sourceArray;
    int selectedPage;
    BOOL selectedID;
    EjectAlertView *pushEjectView;
    NSDictionary *signDic;
    FatherViewController *fatherVc;
    UIButton *qrCodeBut;
    
}
@end

@implementation HomePageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SignFication:) name:@"SIGNSS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestLayout) name:@"HOMERefresh" object:nil];
    fatherVc=[[FatherViewController alloc]init];
    selectedID=NO;
    selectedPage=1;
    sourceArray=[[NSMutableArray alloc]init];
    expData=[[NSMutableData alloc]init];
    headeView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 363)];
    headeView.backgroundColor=[UIColor whiteColor];
    NSArray *butImageArray=@[@"index-tonghangreliao.jpg",@"index-jingpinkecheng.jpg",@"index-zhishixueyuan.jpg",@"index-qiandaoyouli.jpg",@"index-shangjinlieren.jpg",@"index-jianlijiaohuan.jpg",@"index-fuwudating.jpg",@"index-fulishangcheng.jpg"];
//    NSArray *butArray=@[@"知识学院",@"服务大厅",@"微社区",@"签到有礼"];
    NSArray *butArray=@[@"同城热聊",@"精品课程",@"知识学院",@"签到有礼",@"赏金猎人",@"简历交换",@"服务大厅",@"福利商城"];
    int x=0;
    for (int i=0; i<butArray.count; i++) {
        if (i<4) {
            UIButton *button=[[UIButton alloc]initWithFrame:FRAME((WIDTH-160)/4/2+(40+(WIDTH-160)/4)*i, 213, 40, 40)];
            [button setImage:[UIImage imageNamed:butImageArray[i]] forState:UIControlStateNormal];
            button.tag=i;
            [button addTarget:self action:@selector(ButAction:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius=20;
            button.clipsToBounds=YES;
            [headeView addSubview:button];
            
            UILabel *butNameLabel=[[UILabel alloc]initWithFrame:FRAME((WIDTH-240)/4/2+(60+(WIDTH-240)/4)*i, button.frame.origin.y+button.frame.size.height+10, 60, 15)];
            butNameLabel.text=[NSString stringWithFormat:@"%@",butArray[i]];
            butNameLabel.textAlignment=NSTextAlignmentCenter;
            butNameLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
            [headeView addSubview:butNameLabel];
        }else{
            UIButton *button=[[UIButton alloc]initWithFrame:FRAME((WIDTH-160)/4/2+(40+(WIDTH-160)/4)*x, 288, 40, 40)];
            [button setImage:[UIImage imageNamed:butImageArray[i]] forState:UIControlStateNormal];
            button.tag=i;
            [button addTarget:self action:@selector(ButAction:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius=20;
            button.clipsToBounds=YES;
            [headeView addSubview:button];
            
            UILabel *butNameLabel=[[UILabel alloc]initWithFrame:FRAME((WIDTH-240)/4/2+(60+(WIDTH-240)/4)*x, button.frame.origin.y+button.frame.size.height+10, 60, 15)];
            butNameLabel.text=[NSString stringWithFormat:@"%@",butArray[i]];
            butNameLabel.textAlignment=NSTextAlignmentCenter;
            butNameLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
            [headeView addSubview:butNameLabel];
            x++;
        }
        
    }
    
    myTableView=[[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT-29)style:UITableViewStyleGrouped];
    myTableView.delegate=self;
    myTableView.dataSource=self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.tableHeaderView=headeView;
    myTableView.tag=1000;
    [self.view addSubview:myTableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [myTableView setTableFooterView:v];
    
    qrCodeBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH-40, 25, 30, 30)];
    [qrCodeBut addTarget:self action:@selector(qrCodeButAction:) forControlEvents:UIControlEventTouchUpInside];
    qrCodeBut.backgroundColor=[UIColor whiteColor];
    qrCodeBut.layer.cornerRadius=qrCodeBut.frame.size.width/2;
    qrCodeBut.clipsToBounds=YES;
   
    UIImageView *barCodeImage=[[UIImageView alloc]initWithFrame:FRAME(5, 5, 20, 20)];
    barCodeImage.image=[UIImage imageNamed:@"iconfont-saotiaoma"];
    [qrCodeBut addSubview:barCodeImage];

    CALayer *layer=[qrCodeBut layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [layer setCornerRadius:qrCodeBut.frame.size.width/2];
    //设置边框线的宽
    [layer setBorderWidth:2];
    //设置边框线的颜色
    [layer setBorderColor:[[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1] CGColor]];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self imageLayout];
    [self requestLayout];
}
-(void)qrCodeButAction:(UIButton *)button
{
    NSArray *arrayItems = @[@[@"模拟qq扫码界面",@"qqStyle"]];
    NSArray* array = arrayItems[0];
    NSString *methodName = [array lastObject];
    
    SEL normalSelector = NSSelectorFromString(methodName);
    if ([self respondsToSelector:normalSelector]) {
        
        ((void (*)(id, SEL))objc_msgSend)(self, normalSelector);
    }
}
-(void)SignPolite
{
    [pushEjectView removeFromSuperview];
    pushEjectView = [EjectAlertView new];
    pushEjectView.frame=FRAME(0, 0, WIDTH, HEIGHT);
    pushEjectView.backgroundColor = [UIColor redColor];
    [pushEjectView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin];
    [self.view addSubview:pushEjectView];
    UIView *grayView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
    grayView.backgroundColor=[UIColor blackColor];
    grayView.alpha=0.4;
    [pushEjectView addSubview:grayView];
    
    UIView *view=[[UIView alloc]initWithFrame:FRAME((WIDTH-WIDTH*0.72)/2, (HEIGHT-356)/2, WIDTH*0.72, WIDTH*0.72*0.70+168)];
    view.backgroundColor=[UIColor whiteColor];
    view.layer.cornerRadius=10;
    view.clipsToBounds=YES;
    [pushEjectView addSubview:view];
    
    UIImageView *headeImageView=[[UIImageView alloc]initWithFrame:FRAME(0, 0, WIDTH*0.72, WIDTH*0.72*0.70)];
    headeImageView.backgroundColor=[UIColor whiteColor];
    [view addSubview:headeImageView];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME((headeImageView.frame.size.width-100)/2, (headeImageView.frame.size.height-100)/2+20, 100, 100)];
    imageView.image=[UIImage imageNamed:@"iconfont-qiandao"];
    [headeImageView addSubview:imageView];
    
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.text=[NSString stringWithFormat:@"%@!",[signDic objectForKey:@"msg"]];
    titleLabel.textColor=[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
    titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:28];
    [titleLabel setNumberOfLines:1];
    [titleLabel sizeToFit];
    titleLabel.frame=FRAME((WIDTH*0.72-titleLabel.frame.size.width)/2, WIDTH*0.72*0.70+10, titleLabel.frame.size.width, 30);
    [view addSubview:titleLabel];
    
    UILabel *textLabel=[[UILabel alloc]init];
    textLabel.text=[NSString stringWithFormat:@"%@",[signDic objectForKey:@"data"]];
    UIFont *font=[UIFont fontWithName:@"Georgia-Bold" size:30];
    textLabel.textColor=[UIColor colorWithRed:247/255.0f green:202/255.0f blue:44/255.0f alpha:1];
    textLabel.font=font;
    [textLabel setNumberOfLines:1];
    [textLabel sizeToFit];
    [view addSubview:textLabel];
    
    UILabel *liftLabel=[[UILabel alloc]init];
    liftLabel.text=@"恭喜获得";
    liftLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    [liftLabel setNumberOfLines:1];
    [liftLabel sizeToFit];
    liftLabel.textColor=[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
    [view addSubview:liftLabel];
    
    UILabel *rightLabel=[[UILabel alloc]init];
    rightLabel.text=@"积分";
    rightLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    [rightLabel setNumberOfLines:1];
    [rightLabel sizeToFit];
    rightLabel.textColor=[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
    [view addSubview:rightLabel];
    
    liftLabel.frame=FRAME((WIDTH*0.72-liftLabel.frame.size.width-rightLabel.frame.size.width-textLabel.frame.size.width-10)/2, WIDTH*0.72*0.70+75, liftLabel.frame.size.width, 15);
    textLabel.frame=FRAME(liftLabel.frame.size.width+liftLabel.frame.origin.x+5, WIDTH*0.72*0.70+60, textLabel.frame.size.width, 30);
    rightLabel.frame=FRAME(textLabel.frame.size.width+textLabel.frame.origin.x+5, WIDTH*0.72*0.70+75, rightLabel.frame.size.width, 15);
    
    UIView *hengView=[[UIView alloc]initWithFrame:FRAME(0, WIDTH*0.72*0.70+127, WIDTH*0.72, 1)];
    hengView.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [view addSubview:hengView];
    
    UIButton *cancelBut=[[UIButton alloc]initWithFrame:FRAME(0, WIDTH*0.72*0.70+128, WIDTH*0.72, 40)];
    cancelBut.backgroundColor=[UIColor whiteColor];
    cancelBut.tag=12;
    [cancelBut addTarget:self action:@selector(SignAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelBut.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    [cancelBut setTitle:@"我知道了" forState:UIControlStateNormal];
    [cancelBut setTitleColor:[UIColor colorWithRed:17/255.0f green:150/255.0f blue:219/255.0f alpha:1] forState:UIControlStateNormal];
    [view addSubview:cancelBut];
}
-(void)SignAction:(UIButton *)button
{
    pushEjectView.hidden=YES;
}
#pragma mark -模仿qq界面
- (void)qqStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    style.photoframeLineW = 6;
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //qq里面的线条图片
    UIImage *imgLine = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    style.animationImage = imgLine;
    
    LBXScanViewController *lBvc = [LBXScanViewController new];
    lBvc.style = style;
    lBvc.isQQSimulator = YES;
    [self.navigationController pushViewController:lBvc animated:YES];
}

#pragma mark头部四个按钮点击方法
-(void)ButAction:(UIButton *)button
{
    //    NSArray *butArray=@[@"知识学院",@"服务大厅",@"微社区",@"签到有礼"];
    switch (button.tag) {
        case 0:
        {
//            WebPageViewController *webPageVC=[[WebPageViewController alloc]init];
//            webPageVC.barIDS=100;
//            webPageVC.webURL=[NSString stringWithFormat:@"http://51xingzheng.cn"];
//            [self.navigationController pushViewController:webPageVC animated:YES];
            UINavigationController *communityViewController = [UMCommunity getFeedsModalViewController];
            [self presentViewController:communityViewController animated:YES completion:nil];
            
        }
            break;
        case 1:
        {
            
            WebPageViewController *webPageVC=[[WebPageViewController alloc]init];
            webPageVC.barIDS=100;
            webPageVC.webURL=[NSString stringWithFormat:@"http://edu.51xingzheng.cn"];
            [self.navigationController pushViewController:webPageVC animated:YES];
            
        }
            break;
        case 2:
        {
            
            SchoolViewController *schoolVC=[[SchoolViewController alloc]init];
            [self.navigationController pushViewController:schoolVC animated:YES];
           
            
        }
            break;
        case 3:
        {
//            ISLoginManager *_manager = [ISLoginManager shareManager];
//            NSString *url=[NSString stringWithFormat:@"http://123.57.173.36/simi/app/user/score_shop.json?user_id=%@",_manager.telephone];
//            CreditWebViewController *web=[[CreditWebViewController alloc]initWithUrl:url];//实际中需要改为带签名的地址
//            //如果已经有UINavigationContoller了，就 创建出一个 CreditWebViewController 然后 push 进去
//            [self.navigationController pushViewController:web animated:YES];
            if(fatherVc.loginYesOrNo){
                [self SignLayout];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MyLogInViewController *loginViewController = [[MyLogInViewController alloc] init];
                    loginViewController.vCYMID=100;
                    UMComNavigationController *navigationController = [[UMComNavigationController alloc] initWithRootViewController:loginViewController];
                    [self presentViewController:navigationController animated:YES completion:^{
                    }];
                });
            }
            
        }
            break;
        case 4:
        {
            ISLoginManager *_manager = [ISLoginManager shareManager];
            WebPageViewController *webPageVC=[[WebPageViewController alloc]init];
            webPageVC.barIDS=100;
            webPageVC.webURL=[NSString stringWithFormat:@"http://123.57.173.36/simi-h5/show/job-reward-list.html?user_id=%@",_manager.telephone];
            [self.navigationController pushViewController:webPageVC animated:YES];
        }
            break;
        case 5:
        {
            ISLoginManager *_manager = [ISLoginManager shareManager];
            WebPageViewController *webPageVC=[[WebPageViewController alloc]init];
            webPageVC.barIDS=100;
            webPageVC.webURL=[NSString stringWithFormat:@"http://123.57.173.36/simi-h5/show/cv-switch-list.html?user_id=%@",_manager.telephone];
            [self.navigationController pushViewController:webPageVC animated:YES];
            
        }
            break;
        case 6:
        {
            WholeViewController *wholeViewController=[[WholeViewController alloc]init];
            wholeViewController.channel_id=[NSString stringWithFormat:@"99"];
            wholeViewController.whoVCID=101;
            [self.navigationController pushViewController:wholeViewController animated:YES];
        }
            break;
        case 7:
        {
            ISLoginManager *_manager = [ISLoginManager shareManager];
            NSString *url=[NSString stringWithFormat:@"http://123.57.173.36/simi/app/user/score_shop.json?user_id=%@",_manager.telephone];
            CreditWebViewController *web=[[CreditWebViewController alloc]initWithUrl:url];//实际中需要改为带签名的地址
            //如果已经有UINavigationContoller了，就 创建出一个 CreditWebViewController 然后 push 进去
            [self.navigationController pushViewController:web animated:YES];
        }
            break;
        default:
            break;
    }
}
-(void)SignFication:(NSNotification *)obj
{
    [self SignLayout];
}
-(void)SignLayout
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSDictionary *_dict = @{@"user_id":_manager.telephone};
    DownloadManager *_download = [[DownloadManager alloc]init];
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",HOMEPAHE_SIGN] dict:_dict view:self.view delegate:self finishedSEL:@selector(SignSuccess:) isPost:YES failedSEL:@selector(SignFail:)];
}
#pragma mark 签到成功返回
-(void)SignSuccess:(id)Source
{
    int status=[[Source objectForKey:@"status"]intValue];
    if (status==0) {
        signDic=Source;
        [self SignPolite];
        
    }
    
}
#pragma mark 签到失败返回
-(void)SignFail:(id)Source
{
    NSLog(@"签到失败返回:%@",Source);
}
#pragma mark  广告数据请求
-(void)requestLayout
{
    NSString *urlStr=@"http://51xingzheng.cn/?json=get_tag_posts&count=5&order=DESC&slug=%E9%A6%96%E9%A1%B5%E7%B2%BE%E9%80%89&include=id,title,modified,url,thumbnail,custom_fields";
    NSString *urlString = [NSString stringWithFormat:@"%@&page=%d",urlStr,selectedPage];
    AFHTTPRequestOperationManager *mymanager = [AFHTTPRequestOperationManager manager];
    
    [mymanager GET:[NSString stringWithFormat:@"%@",urlString] parameters:nil success:^(AFHTTPRequestOperation *opretion, id responseObject){
        
        if(selectedPage==1){
            [sourceArray removeAllObjects];
        }
        NSLog(@"数据%@",responseObject);
        NSArray *array=[responseObject objectForKey:@"posts"];
        for (int i=0; i<array.count; i++) {
            NSDictionary *dict=array[i];
            if ([sourceArray containsObject:dict]) {
                
            }else{
                [sourceArray addObject:dict];
            }
        }
        if (array.count<5) {
            selectedID=YES;
        }
        [myTableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *opration, NSError *error){
        
         NSLog(@"失败数据%@",error);
        
    }];

}
#pragma mark  列表数据请求
-(void)imageLayout
{
    NSDictionary *_dict = @{@"ad_type":@"0"};
    DownloadManager *_download = [[DownloadManager alloc]init];
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",BASICE_GENERAL_ADVERTISING] dict:_dict view:self.view delegate:self finishedSEL:@selector(AdvertisingSuccess:) isPost:NO failedSEL:@selector(AdvertisingFail:)];
}
-(void)AdvertisingSuccess:(id)source
{
    NSLog( @"首页广告数据:%@",source);
    imageArray=[source objectForKey:@"data"];
    [self scrollviewLayout];
}
-(void)AdvertisingFail:(id)source
{
    NSLog( @"首页广告数据失败:%@",source);
}
#pragma mark 轮播图
-(void)scrollviewLayout
{
     NSMutableArray *viewsArray = [@[] mutableCopy];
    for (int i=0; i<imageArray.count; i++) {
        NSDictionary *dic=imageArray[i];
        UIButton *viewImage=[[UIButton alloc]initWithFrame:FRAME(WIDTH*i, 0, WIDTH, 200)];
        viewImage.backgroundColor=[UIColor whiteColor];
        viewImage.tag=i;
        [viewsArray addObject:viewImage];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME(0, 0, WIDTH, 200)];
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"img_url"]];
        [imageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
        [viewImage addSubview:imageView];
        UILabel *textLabel=[[UILabel alloc]initWithFrame:FRAME(20, WIDTH*0.42, WIDTH-30, 40)];
        textLabel.textAlignment=NSTextAlignmentCenter;
        textLabel.textColor=[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1];
    
        [viewImage addSubview:textLabel];
    }
    if (adView==nil) {
        adView= [[CycleScrollView alloc]initWithFrame:FRAME(0, 0, WIDTH, 200) animationDuration:5];
        adView.pageID=(int)viewsArray.count;
        adView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
        adView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            return viewsArray[pageIndex];
        };
        int totaID=(int)imageArray.count;
        adView.totalPagesCount = ^NSInteger(void){
            return totaID;
        };
        adView.TapActionBlock = ^(NSInteger pageIndex){
            NSLog(@"点击了第%ld个",(long)pageIndex);
            [self imageButAction:(int)pageIndex];
        };
        [headeView addSubview:adView];
        [headeView addSubview:qrCodeBut];
    }
    
}
#pragma mark  广告图片点击方法
-(void)imageButAction:(int)button
{
    NSDictionary *dic=imageArray[button];
    WebPageViewController *webPageVC=[[WebPageViewController alloc]init];
    webPageVC.barIDS=100;
    webPageVC.webURL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"goto_url"]];
    [self.navigationController pushViewController:webPageVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 列表组头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 34;
    
}
#pragma mark  列表组头view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, WIDTH, 14)];
    sectionView.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    UILabel *label=[[UILabel alloc]init];
    switch (section) {
        case 0:
            label.text=@"每日新知";
            break;
        case 1:
            label.text=@"猜你喜欢";
            break;
        default:
            break;
    }
    
    label.lineBreakMode=NSLineBreakByTruncatingTail;
    [label setNumberOfLines:1];
    [label sizeToFit];
    label.textColor=[UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1];
    label.font=[UIFont fontWithName:@"Heiti SC" size:14];
    label.frame=FRAME(10, 4, label.frame.size.width, 20);
    [sectionView addSubview:label];
    return sectionView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int  secId;
    switch (section) {
        case 0:
            secId=(int)sourceArray.count;
            break;
        case 1:
            secId=0;
            break;
        default:
            break;
    }
    return secId;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic=sourceArray[indexPath.row];
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    HomePageTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[HomePageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"thumbnail"]];
    [cell.headeImageVIew setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
    cell.titleLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    [cell.titleLabel setNumberOfLines:2];
    [cell.titleLabel sizeToFit];
    NSArray *viewsArray=[[dic objectForKey:@"custom_fields"]objectForKey:@"views"];
    cell.subTitleLabel.text=[NSString stringWithFormat:@"%@人已看过",viewsArray[0]];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
#pragma mark  列表组尾部高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    int h=0;
    switch (section) {
        case 0:
            h=50;
            break;
        case 1:
            h=0;
            break;
   
        default:
            break;
    }
    return h;
}
#pragma mark  列表尾部view
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionView;
    switch (section) {
        case 0:
        {
            sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
            sectionView.backgroundColor=[UIColor whiteColor];
            if (selectedID==YES) {
                UIButton *button=[[UIButton alloc]initWithFrame:FRAME(0, 0, WIDTH, 50)];
                [button setTitle:@"没有更多了！" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1] forState:UIControlStateNormal];
                [sectionView addSubview:button];
            }else{
                UIButton *button=[[UIButton alloc]initWithFrame:FRAME(0, 0, WIDTH, 50)];
                [button setTitle:@"加载更多" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(LoadAction:) forControlEvents:UIControlEventTouchUpInside];
                [sectionView addSubview:button];
            }

        }
            break;
        case 1:
        {
            sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 10)];
            sectionView.backgroundColor=[UIColor whiteColor];
        }
            break;
            
        default:
            break;
    }
    
    return sectionView;
}

#pragma mark 列表点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [myTableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic=sourceArray[indexPath.row];
    WebPageViewController *webPageVC=[[WebPageViewController alloc]init];
    webPageVC.barIDS=100;
    webPageVC.webURL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]];
    [self.navigationController pushViewController:webPageVC animated:YES];
}
#pragma mark 加载更多点击事件
-(void)LoadAction:(UIButton *)button
{
    NSLog(@"正在加载");
    selectedPage++;
    [self requestLayout];
}



@end
