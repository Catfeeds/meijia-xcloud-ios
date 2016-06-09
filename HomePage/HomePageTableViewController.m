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
#import "SearchVoiceViewController.h"
#import "ArticleWEBViewController.h"
#import <objc/message.h>
#import "AddLabelCollectionViewCell.h"
#import "Workplace_askViewController.h"
#import "ToolListViewController.h"
#import "FountWebViewController.h"
static CGFloat const imageBGHeight = 373; // 背景图片的高度
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
    UIView  *navView;
    UIView  *csView;
    
    UIScrollView *rootView;
    NSMutableArray *W;
    NSArray *arraY;
    UIImageView *lineImageView;
    CGFloat maximumOffset;
    CGFloat currentOffset;
    int scrollID;
    int buttID;
    int widths;
    
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    int   page;
    UIButton *mySearchBar;
    
    UIView *addView;
    UICollectionViewFlowLayout *flowView;
    NSArray *addArray;
    NSArray *subscribeAry;
    NSMutableArray *textArray;
}
@end

@implementation HomePageTableViewController
#pragma mark 获取默认订阅文章标签
-(void)user_default
{
    DownloadManager *_download = [[DownloadManager alloc]init];
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",SUBSCRIBE_DEFAULT] dict:nil view:self.view delegate:self finishedSEL:@selector(DefaultSuccess:) isPost:YES failedSEL:@selector(DefaultFail:)];
}
#pragma mark 获取默认订阅文章标签成功返回
-(void)DefaultSuccess:(id)sender
{
    NSLog(@"获取默认订阅文章标签成功返回%@",sender);
    NSString *string=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    addArray= [string componentsSeparatedByString:@","];
    [_collectionView reloadData];
}
#pragma mark 获取默认订阅文章标签失败返回
-(void)DefaultFail:(id)sender
{
    NSLog(@"获取默认订阅文章标签失败返回%@",sender);
}
#pragma mark获取用户订阅的文章标签接口
-(void)subscribe
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *dict=@{@"user_id":_manager.telephone};
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",SUBSCRIBE_USER] dict:dict view:self.view delegate:self finishedSEL:@selector(SubscribeSuccess:) isPost:NO failedSEL:@selector(subscribeFail:)];
}
#pragma mark获取用户订阅的文章标签接口成功返回
-(void)SubscribeSuccess:(id)sender
{
    NSLog(@"获取用户订阅的文章标签接口成功返回%@",sender);
    NSString *string=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    subscribeAry =[string componentsSeparatedByString:@","];
    [self getLayout];
    [_collectionView reloadData];
}
#pragma mark获取用户订阅的文章标签接口失败返回
-(void)subscribeFail:(id)sender
{
    NSLog(@"获取用户订阅的文章标签接口失败返回%@",sender);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    textArray=[[NSMutableArray alloc]init];
    [self user_default];
    W=[[NSMutableArray alloc]init];
    page=1;
    arraY=@[@"精选",@"职场",@"案例",@"招聘",@"薪资",@"行政",@"培训",@"绩效",@"员工关系",@"人资规划",@"行业"];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SignFication:) name:@"SIGNSS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLayout) name:@"HOMERefresh" object:nil];
    fatherVc=[[FatherViewController alloc]init];
    selectedID=NO;
    selectedPage=1;
    sourceArray=[[NSMutableArray alloc]init];
    expData=[[NSMutableData alloc]init];
    headeView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 373)];
    headeView.backgroundColor=[UIColor whiteColor];
//    NSArray *butImageArray=@[@"index-tonghangreliao.jpg",@"index-jingpinkecheng.jpg",@"index-zhishixueyuan.jpg",@"index-qiandaoyouli.jpg",@"index-shangjinlieren.jpg",@"index-jianlijiaohuan.jpg",@"index-fuwudating.jpg",@"index-fulishangcheng.jpg"];
    NSArray *butImageArray=@[@"index-fulishangcheng.jpg",@"index-tonghangreliao.jpg",@"index-zhishixueyuan.jpg",@"index-fuwudating.jpg"];
//    NSArray *butArray=@[@"知识学院",@"服务大厅",@"微社区",@"签到有礼"];
//    NSArray *butArray=@[@"同行热聊",@"精品课程",@"知识学院",@"签到有礼",@"内推悬赏",@"简历交换",@"找服务商",@"福利商城"];
    NSArray *butArray=@[@"内推悬赏",@"同行热聊",@"常用工具",@"找服务商"/*@"知识学院",@"签到有礼",@"简历交换",@"找服务商",@"福利商城"*/];
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
    UIView *lineViews=[[UIView alloc]initWithFrame:FRAME(0, 288, WIDTH, 0.5)];
    lineViews.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    [headeView addSubview:lineViews];
    
    UIView *view=[[UIView alloc]initWithFrame:FRAME(0, headeView.frame.size.height-10, WIDTH, 10)];
    view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    [headeView addSubview:view];
    
    UIButton *headLiftBut=[[UIButton alloc]initWithFrame:FRAME(0, 289, WIDTH/2-0.5, 74)];
    [headLiftBut addTarget:self action:@selector(ButAction:) forControlEvents:UIControlEventTouchUpInside];
    headLiftBut.tag=4;
    [headeView addSubview:headLiftBut];
    
    UILabel *liftNameLabel=[[UILabel alloc]initWithFrame:FRAME((WIDTH-240)/4/2, 15, WIDTH/2-0.5-64, 20)];
    liftNameLabel.text=@"问答互助";
    liftNameLabel.textColor=[UIColor colorWithRed:70/255.0f green:144/255.0f blue:255/255.0f alpha:1];
    liftNameLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
    [headLiftBut addSubview:liftNameLabel];
    UILabel *liftTextLabel=[[UILabel alloc]initWithFrame:FRAME((WIDTH-240)/4/2, 45, WIDTH/2-0.5-64, 14)];
    liftTextLabel.text=@"最专业的解答都在这";
    liftTextLabel.font=[UIFont fontWithName:@"Heiti SC" size:10];
    [headLiftBut addSubview:liftTextLabel];
    UIImageView *liftImage=[[UIImageView alloc]initWithFrame:FRAME(WIDTH/2-0.5-((WIDTH-240)/4/2+30), 15, 34, 34)];
    liftImage.image=[UIImage imageNamed:@"index_wenda"];
    [headLiftBut addSubview:liftImage];
    
    UIView *verticalView=[[UIView alloc]initWithFrame:FRAME(WIDTH/2-0.5, 294, 0.5, 64)];
    verticalView.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    [headeView addSubview:verticalView];
    
    UIButton *headrightBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH/2+0.5, 289, WIDTH/2-0.5, 74)];
    [headrightBut addTarget:self action:@selector(ButAction:) forControlEvents:UIControlEventTouchUpInside];
    headrightBut.tag=5;
    [headeView addSubview:headrightBut];
    
    
    
    UILabel *rightNameLabel=[[UILabel alloc]initWithFrame:FRAME((WIDTH-240)/4/2, 15, WIDTH/2-0.5-64, 20)];
    rightNameLabel.text=@"签到惊喜";
    rightNameLabel.textColor=[UIColor colorWithRed:243/255.0f green:128/255.0f blue:16/255.0f alpha:1];
    rightNameLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
    [headrightBut addSubview:rightNameLabel];
    UILabel *rightTextLabel=[[UILabel alloc]initWithFrame:FRAME((WIDTH-240)/4/2, 45, WIDTH/2-0.5-64, 14)];
    rightTextLabel.text=@"送完金币还送经验值";
    rightTextLabel.font=[UIFont fontWithName:@"Heiti SC" size:10];
    [headrightBut addSubview:rightTextLabel];
    
    UIImageView *rightImage=[[UIImageView alloc]initWithFrame:FRAME(WIDTH/2-0.5-((WIDTH-240)/4/2+30), 15, 34, 34)];
    rightImage.image=[UIImage imageNamed:@"index_qiandao"];
    [headrightBut addSubview:rightImage];
    
    myTableView=[[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT-49)];
    myTableView.delegate=self;
    myTableView.dataSource=self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.tableHeaderView=headeView;
    myTableView.tag=10000;
    [self.view addSubview:myTableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [myTableView setTableFooterView:v];
    
    
    _refreshHeader = [[MJRefreshHeaderView alloc] init];
    _refreshHeader.delegate = self;
    _refreshHeader.scrollView = myTableView;
    
    _moreFooter = [[MJRefreshFooterView alloc] init];
    _moreFooter.delegate = self;
    _moreFooter.scrollView = myTableView;
    
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
    
    navView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 64)];
    navView.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    navView.alpha=0;
    [self.view addSubview:navView];//bringSubviewToFront
    
    mySearchBar=[[UIButton alloc]initWithFrame:FRAME(-WIDTH, 30, WIDTH-40, 25)];
    mySearchBar.backgroundColor=[UIColor whiteColor];//colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [mySearchBar addTarget:self action:@selector(searchButAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:mySearchBar];
    UIImageView *searchImage=[[UIImageView alloc]initWithFrame:FRAME(5, 5, 15, 15)];
    searchImage.image=[UIImage imageNamed:@"search_@2x"];
    [mySearchBar addSubview:searchImage];
    
    csView=[[UIView alloc]initWithFrame:FRAME(0, 373, WIDTH, 38)];
//    csView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:csView];
    [rootView removeFromSuperview];
    
    [W removeAllObjects];
    rootView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH-40, 38)];
    rootView.backgroundColor=[UIColor whiteColor];
    //    rootView.contentSize=CGSizeMake(WIDTH/4*array.count, 37);
    rootView.showsVerticalScrollIndicator = FALSE;
    rootView.showsHorizontalScrollIndicator = FALSE;
    //rootView.pagingEnabled=YES;
    rootView.bounces=NO;
    rootView.delegate=self;
    [csView addSubview:rootView];
    
    UIButton *addButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-50, 0, 50, 38)];
    //    addButton.backgroundColor=[UIColor whiteColor];
    [addButton addTarget:self action:@selector(addButAction) forControlEvents:UIControlEventTouchUpInside];
    [csView addSubview:addButton];
    UIImageView *addImage=[[UIImageView alloc]initWithFrame:FRAME(0, 0, 50, 38)];
    addImage.image=[UIImage imageNamed:@"加号"];
    [addButton addSubview:addImage];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
    lineView1.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    [csView addSubview:lineView1];
    
    UIView *lineView=[[UIView alloc]initWithFrame:FRAME(0, 38.5, WIDTH, 0.5)];
    lineView.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    [csView addSubview:lineView];
    
    lineImageView=[[UIImageView alloc]init];
    lineImageView.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [rootView addSubview:lineImageView];
    int K=0;
    int Ks=0;
    for (int i=0; i<arraY.count; i++)
    {
        //        NSDictionary *dic=arraY[i];
        UILabel *butLabel=[[UILabel alloc]init];
        butLabel.text=[NSString stringWithFormat:@"%@",arraY[i]];
        butLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        [butLabel setNumberOfLines:1];
        [butLabel sizeToFit];
        butLabel.frame=FRAME(10, 8, butLabel.frame.size.width, 21);
        Ks=Ks+butLabel.frame.size.width;
    }
    K=Ks+20*(int)(arraY.count+1);
    int X=0;
    for (int i=0; i<arraY.count; i++) {
        //        NSDictionary *dic=arraY[i];
        UIButton *button=[[UIButton alloc]init];
        [button setTitle:[NSString stringWithFormat:@"%@",arraY[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tabbarButton:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            [button setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1]forState:UIControlStateNormal];
        }
        
        [button setTag:1000+i];
        button.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        
        UILabel *butLabel=[[UILabel alloc]init];
        butLabel.text=[NSString stringWithFormat:@"%@",arraY[i]];
        butLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        [butLabel setNumberOfLines:1];
        [butLabel sizeToFit];
        butLabel.frame=FRAME(10, 8, butLabel.frame.size.width, 21);
        //        [button addSubview:butLabel];
        //        button.titleLabel.textColor=;
        int S=0;
        if (K<WIDTH) {
            
            button.frame=CGRectMake((WIDTH-Ks)/(arraY.count+1)+X+(WIDTH-Ks)/(arraY.count+1)*i, 0, butLabel.frame.size.width, 37);
            X=X+butLabel.frame.size.width;
            if (i==0||i==arraY.count-1) {
                S=button.frame.size.width+(WIDTH-Ks)/(arraY.count+1)*3/2;
            }else{
                S=button.frame.size.width+(WIDTH-Ks)/(arraY.count+1);
            }
        }else{
            button.frame=CGRectMake(20+X+20*i, 0, butLabel.frame.size.width, 37);
            X=X+butLabel.frame.size.width;
            if (i==0||i==arraY.count-1) {
                S=button.frame.size.width+20*3/2;
            }else{
                S=button.frame.size.width+20;
            }
        }
        [rootView addSubview:button];
        
        
        NSString *stringt=[NSString stringWithFormat:@"%d",S];
        [W addObject:stringt];
    }
    int kuan=0;
    for (int i=0; i<W.count; i++) {
        int k=[[W objectAtIndex:i]intValue];
        kuan+=k;
    }
    rootView.contentSize=CGSizeMake(K, 37);
    maximumOffset = rootView.contentSize.width;
    CGRect bounds = rootView.bounds;
    UIEdgeInsets inset = rootView.contentInset;
    currentOffset = rootView.contentOffset.x+bounds.size.width - inset.bottom;
    int s=[[W objectAtIndex:0]intValue];
    lineImageView.frame=CGRectMake(0, 36, s, 2);

    
    addView =[[UIView alloc]initWithFrame:FRAME(WIDTH/2, HEIGHT/2, 0, 0)];
    addView.backgroundColor=[UIColor colorWithRed:245/255.0f green:246/255.0f blue:248/255.0f alpha:1];
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    addView.hidden=YES;
    [window addSubview:addView];
    
    
    UIButton *cancelBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH-50, 24, 40, 40)];
    [cancelBut addTarget:self action:@selector(cancelButAction) forControlEvents:UIControlEventTouchUpInside];
    [addView addSubview:cancelBut];
    UIImageView *cacelImage=[[UIImageView alloc]initWithFrame:FRAME(10, 10, 20, 20)];
    cacelImage.image=[UIImage imageNamed:@"取消"];
    [cancelBut addSubview:cacelImage];
    
    flowView=[[UICollectionViewFlowLayout alloc]init];
    [flowView setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowView.headerReferenceSize=CGSizeMake(WIDTH, 80);
    
    //    [_collectionView removeFromSuperview];
    _collectionView=[[UICollectionView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)collectionViewLayout:flowView];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    
    _collectionView.backgroundColor=[UIColor colorWithRed:245/255.0f green:246/255.0f blue:248/255.0f alpha:1];
    [addView addSubview:_collectionView];
    
    
    [_collectionView registerClass:[AddLabelCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterReusableView"];
    
}
-(void)cancelButAction
{
    
    addView.frame=FRAME(WIDTH/2, HEIGHT/2, 0, 0);
    addView.hidden=YES;
}
-(void)addButAction
{
    if(fatherVc.loginYesOrNo){
        addView.hidden=NO;
        addView.frame=FRAME(0, 0, WIDTH, HEIGHT);
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
#pragma mark 搜索按钮点击方法
-(void)searchButAction
{
    SearchVoiceViewController *searchVC=[[SearchVoiceViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [mySearchBar resignFirstResponder];
    CGFloat offsetY = myTableView.contentOffset.y;
    CGFloat alpha = offsetY / 299;
    navView.alpha=alpha;
    if (imageBGHeight-offsetY>64&&imageBGHeight-offsetY>0 ) {
        csView.frame=FRAME(0, imageBGHeight-offsetY, WIDTH, 38);
    }else{
        
        csView.frame=FRAME(0, 64, WIDTH, 38);
    }
    if (alpha>=1) {
        [UIView beginAnimations: @"Animation" context:nil];
        [UIView setAnimationDuration:0.5];
        mySearchBar.frame=FRAME(20, 24, WIDTH-40, 30);
        [UIView commitAnimations];
        
    }else if (alpha<0.7){
        [UIView beginAnimations: @"Animation" context:nil];
        [UIView setAnimationDuration:0.5];
        mySearchBar.frame=FRAME(-WIDTH, 24, WIDTH-40, 30);
        [UIView commitAnimations];
    }
    

    CGRect bounds = scrollView.bounds;
    UIEdgeInsets inset = scrollView.contentInset;
    currentOffset = scrollView.contentOffset.x+bounds.size.width - inset.bottom;
}
#pragma mark - 返回一张纯色图片
/** 返回一张纯色图片 */
- (UIImage *)imageWithColor:(UIColor *)color {
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return theImage;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"首页"];
    [self imageLayout];
    
    
    if(fatherVc.loginYesOrNo){
        [self subscribe];
    }
    [self getLayout];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"shouye"];
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
    pushEjectView.backgroundColor = [UIColor blueColor];
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
//    headeImageView.backgroundColor=[UIColor whiteColor];
     headeImageView.image=[UIImage imageNamed:@"banner"];
    [view addSubview:headeImageView];
//    UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME((headeImageView.frame.size.width-100)/2, (headeImageView.frame.size.height-100)/2+20, 100, 100)];
//    imageView.image=[UIImage imageNamed:@"banner"];
//    [headeImageView addSubview:imageView];
    
//    UILabel *titleLabel=[[UILabel alloc]init];
//    titleLabel.text=[NSString stringWithFormat:@"%@!",[signDic objectForKey:@"msg"]];
//    titleLabel.textColor=[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
//    titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:28];
//    [titleLabel setNumberOfLines:1];
//    [titleLabel sizeToFit];
//    titleLabel.frame=FRAME((WIDTH*0.72-titleLabel.frame.size.width)/2, WIDTH*0.72*0.70+10, titleLabel.frame.size.width, 30);
//    [view addSubview:titleLabel];
//    
//    UILabel *textLabel=[[UILabel alloc]init];
//    textLabel.text=[NSString stringWithFormat:@"%@",[signDic objectForKey:@"data"]];
//    UIFont *font=[UIFont fontWithName:@"Georgia-Bold" size:30];
//    textLabel.textColor=[UIColor colorWithRed:247/255.0f green:202/255.0f blue:44/255.0f alpha:1];
//    textLabel.font=font;
//    [textLabel setNumberOfLines:1];
//    [textLabel sizeToFit];
//    [view addSubview:textLabel];
//    
//    UILabel *liftLabel=[[UILabel alloc]init];
//    liftLabel.text=@"恭喜获得";
//    liftLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
//    [liftLabel setNumberOfLines:1];
//    [liftLabel sizeToFit];
//    liftLabel.textColor=[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
//    [view addSubview:liftLabel];
//    
//    UILabel *rightLabel=[[UILabel alloc]init];
//    rightLabel.text=@"金币";
//    rightLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
//    [rightLabel setNumberOfLines:1];
//    [rightLabel sizeToFit];
//    rightLabel.textColor=[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
//    [view addSubview:rightLabel];
//    
//    liftLabel.frame=FRAME((WIDTH*0.72-liftLabel.frame.size.width-rightLabel.frame.size.width-textLabel.frame.size.width-10)/2, WIDTH*0.72*0.70+75, liftLabel.frame.size.width, 15);
//    textLabel.frame=FRAME(liftLabel.frame.size.width+liftLabel.frame.origin.x+5, WIDTH*0.72*0.70+60, textLabel.frame.size.width, 30);
//    rightLabel.frame=FRAME(textLabel.frame.size.width+textLabel.frame.origin.x+5, WIDTH*0.72*0.70+75, rightLabel.frame.size.width, 15);
    
    UIImageView *goldImage=[[UIImageView alloc]initWithFrame:FRAME((WIDTH*0.72-100)/4, WIDTH*0.72*0.70+23, 50, 50)];
    goldImage.image=[UIImage imageNamed:@"金币"];
    [view addSubview:goldImage];
    
    UIImageView *valueImage=[[UIImageView alloc]initWithFrame:FRAME((WIDTH*0.72-100)/4*3+50, WIDTH*0.72*0.70+23, 50, 50)];
    valueImage.image=[UIImage imageNamed:@"经验值"];
    [view addSubview:valueImage];
    
    UILabel *goldLabel=[[UILabel alloc]initWithFrame:FRAME(0, WIDTH*0.72*0.70+83, (WIDTH*0.72)/2, 20)];
    goldLabel.font=[UIFont fontWithName:@"Georgia-Bold" size:15];
    goldLabel.text=[NSString stringWithFormat:@"金币+%@",[signDic objectForKey:@"data"]];
    goldLabel.textColor=[UIColor colorWithRed:255/255.0f green:157/255.0f blue:48/255.0f alpha:1];
    goldLabel.textAlignment=NSTextAlignmentCenter;
    [view addSubview:goldLabel];
    
    UILabel *valueLabel=[[UILabel alloc]initWithFrame:FRAME((WIDTH*0.72)/2, WIDTH*0.72*0.70+83, (WIDTH*0.72)/2, 20)];
    valueLabel.font=[UIFont fontWithName:@"Georgia-Bold" size:15];
    valueLabel.text=[NSString stringWithFormat:@"经验值+%@",[signDic objectForKey:@"data"]];
    valueLabel.textColor=[UIColor colorWithRed:191/255.0f green:127/255.0f blue:127/255.0f alpha:1];
    valueLabel.textAlignment=NSTextAlignmentCenter;
    [view addSubview:valueLabel];
    
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
           
            ISLoginManager *_manager = [ISLoginManager shareManager];
            WebPageViewController *webPageVC=[[WebPageViewController alloc]init];
            webPageVC.barIDS=100;
            
            if (fatherVc.loginYesOrNo) {
                webPageVC.webURL=[NSString stringWithFormat:@"http://123.57.173.36/simi-h5/show/job-reward-list.html?user_id=%@",_manager.telephone];
            }else{
                webPageVC.webURL=[NSString stringWithFormat:@"http://123.57.173.36/simi-h5/show/job-reward-list.html?user_id=0"];
            }
            [self.navigationController pushViewController:webPageVC animated:YES];
        }
            break;
        case 1:
        {
            
            UINavigationController *communityViewController = [UMCommunity getFeedsModalViewController];
            [self presentViewController:communityViewController animated:YES completion:nil];
//            WebPageViewController *webPageVC=[[WebPageViewController alloc]init];
//            webPageVC.barIDS=100;
//            webPageVC.webURL=[NSString stringWithFormat:@"http://edu.51xingzheng.cn"];
//            [self.navigationController pushViewController:webPageVC animated:YES];
            
        }
            break;
        case 2:
        {
            
            ToolListViewController *schoolVC=[[ToolListViewController alloc]init];
            [self.navigationController pushViewController:schoolVC animated:YES];
//            ISLoginManager *_manager = [ISLoginManager shareManager];
//            NSString *url=[NSString stringWithFormat:@"http://123.57.173.36/simi/app/user/score_shop.json?user_id=%@",_manager.telephone];
//            CreditWebViewController *web=[[CreditWebViewController alloc]initWithUrl:url];//实际中需要改为带签名的地址
//            //如果已经有UINavigationContoller了，就 创建出一个 CreditWebViewController 然后 push 进去
//            [self.navigationController pushViewController:web animated:YES];
            
        }
            break;
        case 3:
        {
            
            WholeViewController *wholeViewController=[[WholeViewController alloc]init];
            wholeViewController.channel_id=[NSString stringWithFormat:@"99"];
            wholeViewController.whoVCID=101;
            [self.navigationController pushViewController:wholeViewController animated:YES];
            
        }
            break;
        case 4:
        {
//            if (fatherVc.loginYesOrNo) {
                Workplace_askViewController *askVC=[[Workplace_askViewController alloc]init];
                [self.navigationController pushViewController:askVC animated:YES];
//            }else{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    MyLogInViewController *loginViewController = [[MyLogInViewController alloc] init];
//                    loginViewController.vCYMID=100;
//                    UMComNavigationController *navigationController = [[UMComNavigationController alloc] initWithRootViewController:loginViewController];
//                    [self presentViewController:navigationController animated:YES completion:^{
//                    }];
//                });
//            }
           
        }
            break;
        case 5:
        {
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

//            ISLoginManager *_manager = [ISLoginManager shareManager];
//            WebPageViewController *webPageVC=[[WebPageViewController alloc]init];
//            webPageVC.barIDS=100;
//            if (fatherVc.loginYesOrNo) {
//                webPageVC.webURL=[NSString stringWithFormat:@"http://123.57.173.36/simi-h5/show/cv-switch-list.html?user_id=%@",_manager.telephone];
//            }else{
//                webPageVC.webURL=[NSString stringWithFormat:@"http://123.57.173.36/simi-h5/show/cv-switch-list.html?user_id=0"];
//            }
//            [self.navigationController pushViewController:webPageVC animated:YES];
            
        }
            break;
        case 6:
        {
            
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
    NSLog(@"%@",Source);
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
//#pragma mark  广告数据请求
//-(void)requestLayout
//{
//    NSString *urlStr=@"http://51xingzheng.cn/?json=get_tag_posts&count=5&order=DESC&slug=%E9%A6%96%E9%A1%B5%E7%B2%BE%E9%80%89&include=id,title,modified,url,thumbnail,custom_fields";
//    NSString *urlString = [NSString stringWithFormat:@"%@&page=%d",urlStr,selectedPage];
//    AFHTTPRequestOperationManager *mymanager = [AFHTTPRequestOperationManager manager];
//    
//    [mymanager GET:[NSString stringWithFormat:@"%@",urlString] parameters:nil success:^(AFHTTPRequestOperation *opretion, id responseObject){
//        
//        if(selectedPage==1){
//            [sourceArray removeAllObjects];
//        }
//        NSLog(@"数据%@",responseObject);
//        NSArray *array=[responseObject objectForKey:@"posts"];
//        for (int i=0; i<array.count; i++) {
//            NSDictionary *dict=array[i];
//            if ([sourceArray containsObject:dict]) {
//                
//            }else{
//                [sourceArray addObject:dict];
//            }
//        }
//        if (array.count<5) {
//            selectedID=YES;
//        }
//        [myTableView reloadData];
//        
//        
//    } failure:^(AFHTTPRequestOperation *opration, NSError *error){
//        
//         NSLog(@"失败数据%@",error);
//        
//    }];
//
//}
#pragma mark  列表数据请求
-(void)imageLayout
{
    NSDictionary *_dict = @{@"channel_id":@"0"};
    DownloadManager *_download = [[DownloadManager alloc]init];
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",CHANNEL_CARD] dict:_dict view:self.view delegate:self finishedSEL:@selector(AdvertisingSuccess:) isPost:NO failedSEL:@selector(AdvertisingFail:)];
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
    FountWebViewController *fountVC=[[FountWebViewController alloc]init];
    fountVC.goto_type=[NSString stringWithFormat:@"%@",[dic objectForKey:@"goto_type"]];
    fountVC.imgurl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"goto_url"]];
    fountVC.service_type_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_type_ids"]];
    fountVC.titleName=[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    [self.navigationController pushViewController:fountVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 列表组头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 39;
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    int  secId;
//    switch (section) {
//        case 0:
//            secId=(int)sourceArray.count;
//            break;
//        case 1:
//            secId=0;
//            break;
//        default:
//            break;
//    }
    return sourceArray.count;
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
//#pragma mark  列表组尾部高度
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    int h=0;
//    switch (section) {
//        case 0:
//            h=50;
//            break;
//        case 1:
//            h=0;
//            break;
//   
//        default:
//            break;
//    }
//    return h;
//}
//#pragma mark  列表尾部view
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *sectionView;
//    switch (section) {
//        case 0:
//        {
//            sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
//            sectionView.backgroundColor=[UIColor whiteColor];
//            if (selectedID==YES) {
//                UIButton *button=[[UIButton alloc]initWithFrame:FRAME(0, 0, WIDTH, 50)];
//                [button setTitle:@"没有更多了！" forState:UIControlStateNormal];
//                [button setTitleColor:[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1] forState:UIControlStateNormal];
//                [sectionView addSubview:button];
//            }else{
//                UIButton *button=[[UIButton alloc]initWithFrame:FRAME(0, 0, WIDTH, 50)];
//                [button setTitle:@"加载更多" forState:UIControlStateNormal];
//                [button setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
//                [button addTarget:self action:@selector(LoadAction:) forControlEvents:UIControlEventTouchUpInside];
//                [sectionView addSubview:button];
//            }
//
//        }
//            break;
//        case 1:
//        {
//            sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 10)];
//            sectionView.backgroundColor=[UIColor whiteColor];
//        }
//            break;
//            
//        default:
//            break;
//    }
//    
//    return sectionView;
//}

#pragma mark 列表点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [myTableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic=sourceArray[indexPath.row];
    ArticleWEBViewController *webPageVC=[[ArticleWEBViewController alloc]init];
    webPageVC.barIDS=100;
    webPageVC.pushID=100;
    webPageVC.listID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    webPageVC.webURL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]];
    [self.navigationController pushViewController:webPageVC animated:YES];
}
#pragma mark 加载更多点击事件
-(void)LoadAction:(UIButton *)button
{
    NSLog(@"正在加载");
    selectedPage++;
//    [self requestLayout];
}

#pragma mark导航点击
-(void)tabbarButton:(UIButton *)sender
{
    page=1;
    int huang=0,kuan=0;
    int width=[[W objectAtIndex:(sender.tag-1000)]intValue];
    for (int i=0; i<(sender.tag-1000); i++) {
        NSString *string=W[i];
        int s=[string intValue];
        huang+=s;
    }
    for (int i=0; i<W.count; i++) {
        int t=[[W objectAtIndex:i]intValue];
        kuan+=t;
    }
    int _offSet=(int)(sender.tag-1000);
    if (kuan>WIDTH-40) {
        if (_offSet>2&&_offSet/*!=arraY.count-1*/&&_offSet>scrollID) {
            buttID=1;
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:1];
            if (currentOffset==maximumOffset||currentOffset>maximumOffset) {
                
            }else{
                if (maximumOffset-currentOffset==width) {
                    rootView.contentOffset=CGPointMake(rootView.contentOffset.x+width, 0);
                    widths=width;
                }else if (maximumOffset-currentOffset<width){
                    rootView.contentOffset=CGPointMake(rootView.contentOffset.x+maximumOffset-currentOffset, 0);
                    widths=maximumOffset-currentOffset;
                }else if(maximumOffset-currentOffset>0){
                    rootView.contentOffset=CGPointMake(rootView.contentOffset.x+width, 0);
                    widths=width;
                }else{
                    
                }
            }
            [UIView commitAnimations];
            
        }else if (buttID==1&&_offSet<scrollID){
            if (currentOffset==WIDTH-40) {
                
            }else{
                [UIView beginAnimations: @"Animation" context:nil];
                [UIView setAnimationDuration:1];
                if (currentOffset-(WIDTH-40)==width) {
                    rootView.contentOffset=CGPointMake(rootView.contentOffset.x-width, 0);
                    widths=width;
                }else if (currentOffset-(WIDTH-40)<width){
                    rootView.contentOffset=CGPointMake(rootView.contentOffset.x-(currentOffset-(WIDTH-40)), 0);
                    widths=maximumOffset-currentOffset;
                }else{
                    rootView.contentOffset=CGPointMake(rootView.contentOffset.x-width, 0);
                    widths=width;
                }
                [UIView commitAnimations];
            }
        }
    }
    static int currentSelectButtonIndex = 0;
    static int previousSelectButtonIndex=1000;
    currentSelectButtonIndex=(int)sender.tag;
    UIButton *previousBtn=(UIButton *)[self.view viewWithTag:previousSelectButtonIndex];
    [previousBtn setTitleColor:[UIColor colorWithRed:120/255.0f green:120/255.0f blue:120/255.0f alpha:1] forState:UIControlStateNormal];
    previousBtn.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    UIButton *currentBtn = (UIButton *)[self.view viewWithTag:currentSelectButtonIndex];;
    [currentBtn setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
    currentBtn.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    previousSelectButtonIndex=currentSelectButtonIndex;
    
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    
    lineImageView.frame=CGRectMake(huang, 36, width, 2);
    [UIView commitAnimations];
    scrollID=(int)(sender.tag-1000);
    [self getLayout];
}
-(void)getLayout
{
    NSString *urlStr;
    switch (scrollID) {
        case 0:
        {
            if (fatherVc.loginYesOrNo) {
                
                NSString *textStr= [subscribeAry componentsJoinedByString:@","];
                if (textStr==nil||textStr==NULL||[textStr isEqualToString:@""]) {
                     urlStr=@"http://51xingzheng.cn/?json=get_tag_posts&count=10&order=DESC&slug=%E9%A6%96%E9%A1%B5%E7%B2%BE%E9%80%89&include=id,title,modified,url,thumbnail,custom_fields";
                }else{
                    NSString *string=[NSString stringWithFormat:@"http://51xingzheng.cn/api/tags/get_tag_posts/?slug=%@&count=10&order=DESC&include=id,title,url,thumbnail,custom_fields",textStr];
                    urlStr=[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSLog(@"%@",urlStr);
                }
                

            }else{
                urlStr=@"http://51xingzheng.cn/?json=get_tag_posts&count=10&order=DESC&slug=%E9%A6%96%E9%A1%B5%E7%B2%BE%E9%80%89&include=id,title,modified,url,thumbnail,custom_fields";
            }
            
        }
            break;
        case 1:
        {
           
            urlStr=@"http://51xingzheng.cn/?json=get_category_posts&count=10&order=DESC&id=50&include=id,title,modified,url,thumbnail,custom_fields";
        }
            break;
        case 2:
        {
            
            urlStr=@"http://51xingzheng.cn/?json=get_category_posts&count=10&order=DESC&id=69&include=id,title,modified,url,thumbnail,custom_fields";
        }
            break;
        case 3:
        {
            
            urlStr=@"http://51xingzheng.cn/?json=get_category_posts&count=10&order=DESC&id=62&include=id,title,modified,url,thumbnail,custom_fields";
        }
            break;
        case 4:
        {
            
            urlStr=@"http://51xingzheng.cn/?json=get_category_posts&count=10&order=DESC&id=64&include=id,title,modified,url,thumbnail,custom_fields";
        }
            break;
        case 5:
        {
        
            urlStr=@"http://51xingzheng.cn/?json=get_category_posts&count=10&order=DESC&id=21&include=id,title,modified,url,thumbnail,custom_fields";
        }
            break;
        case 6:
        {
            urlStr=@"http://51xingzheng.cn/?json=get_category_posts&count=10&order=DESC&id=63&include=id,title,modified,url,thumbnail,custom_fields";
        }
            break;
        case 7:
        {
            urlStr=@"http://51xingzheng.cn/?json=get_category_posts&count=10&order=DESC&id=65&include=id,title,modified,url,thumbnail,custom_fields";
        }
            break;
        case 8:
        {
            urlStr=@"http://51xingzheng.cn/?json=get_category_posts&count=10&order=DESC&id=66&include=id,title,modified,url,thumbnail,custom_fields";
        }
            break;
        case 9:
        {
            urlStr=@"http://51xingzheng.cn/?json=get_category_posts&count=10&order=DESC&id=67&include=id,title,modified,url,thumbnail,custom_fields";
        }
            break;
        case 10:
        {
            urlStr=@"http://51xingzheng.cn/?json=get_category_posts&count=10&order=DESC&id=70&include=id,title,modified,url,thumbnail,custom_fields";
        }
            break;
        default:
            break;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@&page=%d",urlStr,page];
    AFHTTPRequestOperationManager *mymanager = [AFHTTPRequestOperationManager manager];
    
    [mymanager GET:[NSString stringWithFormat:@"%@",urlString] parameters:nil success:^(AFHTTPRequestOperation *opretion, id responseObject){
        
        if(page==1){
            [sourceArray removeAllObjects];
        }
        NSLog(@"数据%@",responseObject);
        NSArray *array=[responseObject objectForKey:@"posts"];
        if (array.count<10) {
            _hasMore=YES;
        }else{
            _hasMore=NO;
        }
        
        for (int i=0; i<array.count; i++) {
            NSDictionary *dict=array[i];
            if ([sourceArray containsObject:dict]) {
                
            }else{
                [sourceArray addObject:dict];
            }
        }
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        
        //        if (array.count<5) {
        //            selectedID=YES;
        //        }
        [myTableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *opration, NSError *error){
        
        NSLog(@"失败数据%@",error);
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        
        
    }];
    
    
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
    //    if (_service == nil) {
    //        _service = [[zzProjectListService alloc] init];
    //        _service.delegate = self;
    //    }
    
    //通过控制page控制更多 网路数据
    //    [_service reqwithPageSize:INVESTPAGESIZE page:page];
    //    [self loadImg];
    
    //本底数据
    //    [_arrData addObjectsFromArray:[UIFont familyNames]];
    
    [self getLayout];
    
    
    
}
#pragma mark 表格刷新相关


#pragma mark  add页面相关
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
{
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return addArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify=@"cell";//[NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
//    NSDictionary *dataDic=plusArray[indexPath.row];
    AddLabelCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义cell就不可能进来了");
    }
    NSString *string=[NSString stringWithFormat:@"%@",addArray[indexPath.row]];
    if ([subscribeAry containsObject:string]) {
        cell.nameLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
        
        if ([textArray containsObject:string]) {
            
        }else{
            [textArray addObject:string];
        }
    }else{
        cell.nameLabel.textColor=[UIColor blackColor];
    }
    cell.nameLabel.text=[NSString stringWithFormat:@"%@",addArray[indexPath.row]];
    cell.nameLabel.textAlignment=NSTextAlignmentCenter;
    cell.backgroundColor=[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
    return cell;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
//    NSString *reuseIdentifier;
    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
        UICollectionReusableView *headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterReusableView" forIndexPath:indexPath];
        UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 40)];
        [headerView addSubview:view];
        UILabel *label=[[UILabel alloc]initWithFrame:FRAME(5, 20, WIDTH-10, 20)];
        label.text=@"轻点标签，即可在首页看到自己感兴趣的内容";
        label.font=[UIFont fontWithName:@"Heiti SC" size:12];
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
        [view addSubview:label];
        return headerView;

    }else{
        UICollectionReusableView *headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
        UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 40)];
        [headerView addSubview:view];
        UILabel *label=[[UILabel alloc]initWithFrame:FRAME(5, 10, 100, 20)];
        label.text=@"我的订阅";
        label.font=[UIFont fontWithName:@"Heiti SC" size:15];
        [view addSubview:label];
        return headerView;

    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((WIDTH-25)/4, 40);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size={WIDTH,40};
    return size;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(WIDTH, 40);
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *indexStr=[NSString stringWithFormat:@"%@",addArray[indexPath.row]];
    if([textArray containsObject:indexStr]){
        [textArray removeObject:indexStr];
    }else{
        [textArray addObject:indexStr];
    }
    NSString *textStr= [textArray componentsJoinedByString:@","];
   
    NSDictionary *dict=@{@"user_id":_manager.telephone,@"subscribe_tags":textStr};
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",SUBSCRIBE_SET_UP] dict:dict view:self.view delegate:self finishedSEL:@selector(Set_UpSuccess:) isPost:YES failedSEL:@selector(Set_UpFail:)];
}
#pragma mark设置用户订阅的文章标签接口成功返回
-(void)Set_UpSuccess:(id)sender
{
    NSLog(@"设置用户订阅的文章标签接口成功返回%@",sender);
    [textArray removeAllObjects];
    [self subscribe];
}
#pragma mark设置用户订阅的文章标签接口失败返回
-(void)Set_UpFail:(id)sender
{
    NSLog(@"设置用户订阅的文章标签接口失败返回%@",sender);
}

@end
