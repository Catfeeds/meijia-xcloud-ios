//
//  ToolListViewController.m
//  yxz
//
//  Created by 白玉林 on 16/6/7.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "ToolListViewController.h"
#import "CreditWebViewController.h"
#import "HairTableViewCell.h"
#import "ClerkViewController.h"
#import "FountWebViewController.h"
@interface ToolListViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>
{
    UIActivityIndicatorView *actView;
    UITableView *myTableView;
    NSMutableArray *arrayImage;;
    UILabel *alertLabel;
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    NSInteger   page;
}
@end

@implementation ToolListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navlabel.text=@"工具资料";
    self.navlabel.textColor = [UIColor whiteColor];
    self.backlable.backgroundColor = [UIColor colorForHex:@"#e8374a"];
    self.img.image = [UIImage imageNamed:@"iconfont-p-back"];
    self.img.frame = FRAME(18, (40-20)/2, 20, 20);
    
    page=1;
    arrayImage=[[NSMutableArray alloc]init];
    actView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    actView.center = CGPointMake(WIDTH/2, HEIGHT/2);
    actView.color = [UIColor blackColor];
    [actView startAnimating];
    [self.view addSubview:actView];
    [self PLJKLayout];
    [self tableViewLayout];
//    myTableView =[[UITableView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
//    myTableView.dataSource=self;
//    myTableView.delegate=self;
//    myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:myTableView];
   
    
//    dataArray=@[@"社保基金计算器",@"个人所得税计算器",@"税前税后工资计算器",@"最新社保基数查询"];
    // Do any additional setup after loading the view.
}

#pragma mark 表格刷新相关

-(void)tableViewLayout
{
    [myTableView removeFromSuperview];
    myTableView=[[UITableView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    myTableView.dataSource=self;
    myTableView.delegate=self;
    myTableView.separatorStyle=UITableViewCellSelectionStyleNone;
    myTableView.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    [self.view addSubview:myTableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [myTableView setTableFooterView:v];
    _refreshHeader = [[MJRefreshHeaderView alloc] init];
    _refreshHeader.delegate = self;
    _refreshHeader.scrollView = myTableView;
    
    _moreFooter = [[MJRefreshFooterView alloc] init];
    _moreFooter.delegate = self;
    _moreFooter.scrollView = myTableView;
    myTableView.tableHeaderView = [self addTableHeaderView];
}
-(void)PLJKLayout
{
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *pageStr=[NSString stringWithFormat:@"%ld",page];
    NSDictionary *dict=@{@"channel_id":@"1",@"page":pageStr};
    
    [_download requestWithUrl:CHANNEL_CARD dict:dict view:self.view delegate:self finishedSEL:@selector(ChannelSuccess:) isPost:NO failedSEL:@selector(ChannelFailure:)];
    
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
    
    [self PLJKLayout];
    
    
    
}
#pragma mark 获取频道列表成功返回方法
-(void)ChannelSuccess:(id)sender
{
    NSLog(@"获取频道列表成功数据%@",sender);
    //    arrayImage=[sender objectForKey:@"data"];
    NSString *dataString=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    if (dataString==nil||dataString==NULL||dataString.length==0||[dataString isEqualToString:@""]) {
        [actView stopAnimating]; // 结束旋转
        [actView setHidesWhenStopped:YES]; //当旋转结束时隐藏
        [alertLabel removeFromSuperview];
        alertLabel=[[UILabel alloc]initWithFrame:FRAME((WIDTH-260)/2,HEIGHT-200, 260, 40)];
        alertLabel.backgroundColor=[UIColor blackColor];
        alertLabel.alpha=0.4;
        alertLabel.text=[NSString stringWithFormat:@"没有数据%@",[sender objectForKey:@"msg"]];//@"还没有输入评论内容哦～";
        alertLabel.textColor=[UIColor whiteColor];
        alertLabel.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:alertLabel];
        
        [NSTimer scheduledTimerWithTimeInterval:2.0f
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:alertLabel
                                        repeats:NO];
        
    }else{
        NSArray *array=[sender objectForKey:@"data"];
        if (array.count<10) {
            _hasMore=YES;
        }else{
            _hasMore=NO;
        }
        if (page==1) {
            [arrayImage removeAllObjects];
            [arrayImage addObjectsFromArray:array];
        }else{
            for (int i=0; i<array.count; i++) {
                if ([arrayImage containsObject:array[i]]) {
                    
                }else{
                    [arrayImage addObject:array[i]];
                }
            }
            
        }
        
        [myTableView reloadData];
    }
    
    
}
- (void)timerFireMethod:(NSTimer*)theTimer
{
    alertLabel.hidden=YES;
}
#pragma mark 获取频道列表失败返回方法
-(void)ChannelFailure:(id)sender
{
    NSLog(@"获取频道列表失败数据%@",sender);
}

//添加headerView,里面有4个可点击的按钮
-(UIView *)addTableHeaderView{
    UIView * headerView = [[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 191)];
    headerView.backgroundColor = [UIColor whiteColor];
    NSArray * imageNameArr = @[@"tools_pen",@"tools_calculator",@"tools_bear",@"tools_book"];
    NSArray * titleArr = @[@"免费资料",@"计算器大全",@"人才评测",@"政策与法规"];
    NSArray * bagroundArr = @[@"#e3eafa",@"#ffe3e2",@"#f6edee",@"#efeff1"];
//创建按钮
    CGFloat buttonX;
    CGFloat buttonY;
    for (NSInteger i = 0 ; i < 4; i++) {
        if (i % 2 == 0) {
            buttonX = 15;
        }else{
            buttonX = (WIDTH - 40) / 2 + 25;
        }
        if (i < 2) {
            buttonY = 15;
        }else{
            buttonY = 80;
        }
        UIButton * actionButton = [[UIButton alloc]initWithFrame:FRAME(buttonX, buttonY, (WIDTH - 40) / 2, 55)];
        [actionButton setBackgroundImage:[self imageWithColor:[UIColor colorForHex:bagroundArr[i]]] forState:UIControlStateNormal];
        [actionButton setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        actionButton.layer.cornerRadius = 8;
        actionButton.layer.masksToBounds = YES;
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:FRAME(0, 35 / 2, (WIDTH - 40) / 2 - 53, 20)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor colorForHex:@"333333"];
        titleLabel.text = titleArr[i];
        [actionButton addSubview:titleLabel];
        
        UIImageView * buttonImage = [[UIImageView alloc]initWithFrame:FRAME((WIDTH - 40) / 2 - 53, 13, 30, 30)];
        buttonImage.image = [UIImage imageNamed:imageNameArr[i]];
        [actionButton addSubview:buttonImage];
        
        actionButton.tag = i;
        //添加按钮的点击事件
        [actionButton addTarget:self action:@selector(clickToolsButton:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:actionButton];
        
    }
    
    //定义headerView
    UIView * sectionView = [[UIView alloc]initWithFrame:FRAME(0, 150, WIDTH, 32)];
    sectionView.backgroundColor = [UIColor colorForHex:@"#f7f7f7"];
    UILabel * headerTitle = [[UILabel alloc]initWithFrame:FRAME((WIDTH - 81) /2 , 6, 81, 20)];
    headerTitle.text = @"大家都在看";
    headerTitle.textColor = [UIColor colorForHex:@"333333"];
    headerTitle.textAlignment = NSTextAlignmentCenter;
    headerTitle.font =[UIFont systemFontOfSize:12];
    [sectionView addSubview:headerTitle];
    //两根分割线
    UIView *  leftView = [[UIView alloc]initWithFrame:FRAME((WIDTH - 81) /2 - 12 - 87, 15.5, 87, 0.5)];
    leftView.backgroundColor = [UIColor redColor];
    [sectionView addSubview:leftView];
    UIView * rightView = [[UIView alloc]initWithFrame:FRAME((WIDTH + 81) /2 + 12 , 15.5, 87, 0.5)];
    rightView.backgroundColor = [UIColor redColor];
    [sectionView addSubview:rightView];
    [headerView addSubview:sectionView];
    
    UIView * whiteView = [[UIView alloc]initWithFrame:FRAME(0, 182, WIDTH, 9)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:whiteView];
    return headerView;
}
//headerView上的按钮点击事件
-(void)clickToolsButton:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
        {
            //免费资料
            NSString *url=[NSString stringWithFormat:@"http://bolohr.com/doc"];
            WebPageViewController *webPageVC=[[WebPageViewController alloc]init];
            webPageVC.barIDS=100;
            webPageVC.qdIDl=1000;
            webPageVC.webURL=url;
            [self.navigationController pushViewController:webPageVC animated:YES];
        }
            break;
        case 1:
        {
            //计算机大全
            NSString *url=[NSString stringWithFormat:@"http://app.bolohr.com/simi-h5/show/tools-list.html"];
            WebPageViewController *webPageVC=[[WebPageViewController alloc]init];
            webPageVC.barIDS=100;
            webPageVC.qdIDl=1000;
            webPageVC.webURL=url;
            [self.navigationController pushViewController:webPageVC animated:YES];
        }
            break;
        case 2:
        {
            //人才评测
            NSString *url=[NSString stringWithFormat:@"http://bolohr.com/hrtest"];
            WebPageViewController *webPageVC=[[WebPageViewController alloc]init];
            webPageVC.barIDS=100;
            webPageVC.qdIDl=1000;
            webPageVC.webURL=url;
            [self.navigationController pushViewController:webPageVC animated:YES];
        }
            break;
        case 3:
        {
            //政策与法规
            NSString *url=[NSString stringWithFormat:@"http://bolohr.com/hrpolicy"];
            WebPageViewController *webPageVC=[[WebPageViewController alloc]init];
            webPageVC.barIDS=100;
            webPageVC.qdIDl=1000;
            webPageVC.webURL=url;
            [self.navigationController pushViewController:webPageVC animated:YES];
        }
            break;
            
        default:
            break;
    }



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
//    [self lodLayout];
}
-(void)lodLayout
{
//    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *dic=@{@"setting_type":@"common-tools"};
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",TOOL_ROMM] dict:dic view:self.view delegate:self finishedSEL:@selector(ToolSuccess:) isPost:NO failedSEL:@selector(ToolFail:)];
}
-(void)ToolSuccess:(id)source
{
//    dataArray=[source objectForKey:@"data"];
//    [myTableView reloadData];
}
-(void)ToolFail:(id)source
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayImage.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=arrayImage[indexPath.row];
    NSString *identifier =[NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    UILabel *textLabel=[[UILabel alloc]init];
    HairTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[HairTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
        textLabel.frame=FRAME(20, 10, WIDTH-30, 20);
        [cell.labelView addSubview:textLabel];
        
    }
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        dispatch_async(dispatch_get_main_queue(),^{
            [actView stopAnimating]; // 结束旋转
            [actView setHidesWhenStopped:YES]; //当旋转结束时隐藏
            [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        });
    }
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"img_url"]];
    UIImage * image =[self loadLocalImage:imageUrl];
    if (image==nil) {
        [cell.pictureImageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
    }else{
        cell.pictureImageView.image=image;
    }
    
    
    textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    textLabel.textColor=[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1];
    textLabel.textAlignment=NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 208;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=arrayImage[indexPath.row];
    NSString *string=[NSString stringWithFormat:@"%@",[dic objectForKey:@"goto_type"]];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([string isEqualToString:@"app"]) {
        ClerkViewController *clerkVC=[[ClerkViewController alloc]init];
        clerkVC.service_type_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_type_ids"]];
        [self.navigationController pushViewController:clerkVC animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        FountWebViewController *fountVC=[[FountWebViewController alloc]init];
        fountVC.goto_type=[NSString stringWithFormat:@"%@",[dic objectForKey:@"goto_type"]];
        fountVC.imgurl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"goto_url"]];
        fountVC.service_type_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_type_ids"]];
        fountVC.titleName=[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
        [self.navigationController pushViewController:fountVC animated:YES];
    }
    
    
}


#pragma mark - 加载本地图像
- (UIImage *)loadLocalImage:(NSString *)imageUrl
{
    
    // 获取图像路径
    NSString * filePath = [self imageFilePath:imageUrl];
    
    
    UIImage * image = [UIImage imageWithContentsOfFile:filePath];
    
    
    if (image != nil) {
        return image;
    }
    
    return nil;
}
#pragma mark - 获取图像路径
- (NSString *)imageFilePath:(NSString *)imageUrl
{
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/PreLoadingImage", pathDocuments];
    //    NSArray *file = [[[NSFileManager alloc] init] subpathsAtPath:createPath];
    //    //NSLog(@"%d",[file count]);
    //    NSLog(@"%@",file);
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:createPath]) {
        
        
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    int a=arc4random()%100;
#pragma mark 拼接图像文件在沙盒中的路径,因为图像URL有"/",要在存入前替换掉,随意用"_"代替
    NSString * imageName = [imageUrl stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString * imageFilePath = [createPath stringByAppendingPathComponent:imageName];
    
    
    return imageFilePath;
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
