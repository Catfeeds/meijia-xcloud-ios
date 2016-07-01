//
//  CollectRecordsViewController.m
//  yxz
//
//  Created by 白玉林 on 16/3/31.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "CollectRecordsViewController.h"
@interface CollectRecordsViewController ()
{
    UITableView *myTableView;
    NSMutableArray *dataSourceArray;
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    NSInteger   page;
}
@end

@implementation CollectRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navlabel.text=_titleName;
    self.tyPeStr=@"asset";
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
    CGRect tmpRect = [self.navlabel.text boundingRectWithSize:CGSizeMake(WIDTH, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil] context:nil];
    self.helpBut.hidden=NO;
    self.helpBut.frame=FRAME((WIDTH-tmpRect.size.width)/2, 20, tmpRect.size.width+20, 44);
    dataSourceArray=[[NSMutableArray alloc]init];
    UIImageView *image=[[UIImageView alloc]initWithFrame:FRAME(self.helpBut.frame.size.width-20, 12, 20, 20)];
    image.image=[UIImage imageNamed:@"iconfont_yingyongbangzhu"];
    [self.helpBut addSubview:image];
    self.backlable.backgroundColor=HEX_TO_UICOLOR(0x11cd6e, 1.0);
    _navlabel.textColor = [UIColor whiteColor];
    self.img.hidden=YES;
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 20, 20)];
    img.image = [UIImage imageNamed:@"iconfont-p-back"];
    [_backBtn addSubview:img];
    
    [self tableViewLayout];
    // Do any additional setup after loading the view.
}
-(void)tableViewLayout
{
    myTableView=[[UITableView alloc]initWithFrame:FRAME(0, 108, WIDTH, HEIGHT-164)];
    myTableView.dataSource=self;
    myTableView.delegate=self;
    [self.view addSubview:myTableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [myTableView setTableFooterView:v];
    _refreshHeader = [[MJRefreshHeaderView alloc] init];
    _refreshHeader.delegate = self;
    _refreshHeader.scrollView = myTableView;
    
    _moreFooter = [[MJRefreshFooterView alloc] init];
    _moreFooter.delegate = self;
    _moreFooter.scrollView = myTableView;
}
-(void)defaultInterfaceLayout
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *company_ID=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"company_id"]];
    NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *_dict = @{@"user_id":_manager.telephone,@"company_id":company_ID,@"page":pageStr};
    DownloadManager *_download = [[DownloadManager alloc]init];
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",COMPANY_COLLECT_LIST] dict:_dict view:self.view delegate:self finishedSEL:@selector(addDressSuccess:) isPost:NO failedSEL:@selector(addDressFail:)];
}
#pragma mark领用列表数据成功方法
-(void)addDressSuccess:(id)source
{
    NSLog(@"领用列表数据:%@",source);
    int status=[[source objectForKey:@"status"]intValue];
    if (status==0) {
        NSString *string=[NSString stringWithFormat:@"%@",[source objectForKey:@"data"]];
        if (string==nil||string==NULL||[string isEqualToString:@"(\n)"]) {
            [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        }else{
            
            NSArray *array=[source objectForKey:@"data"];
            if (array.count<10) {
                _hasMore=YES;
            }else{
                _hasMore=NO;
            }
            if (page==1) {
                [dataSourceArray removeAllObjects];
                [dataSourceArray addObjectsFromArray:array];
            }else{
                for (int i=0; i<array.count; i++) {
                    if ([dataSourceArray containsObject:array[i]]) {
                        
                    }else{
                        [dataSourceArray addObject:array[i]];
                    }
                }
                
            }
            [myTableView reloadData];
        }

    }else{
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }
}
#pragma mark领用列表数据失败方法
-(void)addDressFail:(id)source
{
    NSLog(@"领用列表数据失败:%@",source);
    [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
}
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self defaultInterfaceLayout];
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
    
    [self defaultInterfaceLayout];
    
    
    
}
#pragma mark 表格刷新相关

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSourceArray.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=dataSourceArray[indexPath.row];
    NSString *jsonstring=[NSString stringWithFormat:@"%@",[dic objectForKey:@"asset_json"]];
    NSData *data = [jsonstring   dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *cityDic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
    NSArray *nameArray =(NSArray *)cityDic;
    NSMutableArray *nameArr=[[NSMutableArray alloc]init];
    for (int i=0; i<nameArray.count; i++) {
        //        NSString *nameString=[NSString stringWithFormat:@"%@",[nameArray[i] objectForKey:@"name"]];
        NSDictionary *personDic=@{@"name":[nameArray[i] objectForKey:@"name"],@"total":[nameArray[i] objectForKey:@"total"]};
        [nameArr addObject:personDic];
    }
    int head=0;
    if (nameArr.count>3) {
        head=60;
    }else{
        head=20*(int)nameArr.count;
    }
    return 80+head;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=dataSourceArray[indexPath.row];
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    UITableViewCell *Cell = [tableView cellForRowAtIndexPath:indexPath];
    if (Cell == nil) {
        Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:FRAME(20, 10, WIDTH-40, 20)];
    nameLabel.text=[NSString stringWithFormat:@"%@领用",[dic objectForKey:@"name"]];
    nameLabel.textColor=[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1];
    nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    [Cell addSubview:nameLabel];
    
    NSString *remind_time=[NSString stringWithFormat:@"%@",[dic objectForKey:@"add_time"]];
    NSDateFormatter *formattetime = [[NSDateFormatter alloc] init];
    [formattetime setDateStyle:NSDateFormatterMediumStyle];
    [formattetime setTimeStyle:NSDateFormatterShortStyle];
    [formattetime setDateFormat:@"yyyy-MM-dd"];
    int  timeint=[remind_time intValue];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeint];
    NSLog(@"1296035591  = %@",confromTimesp);
    NSString *confromTimespStrs = [formattetime stringFromDate:confromTimesp];
    UILabel *timeLabel=[[UILabel alloc]init];
    timeLabel.text=[NSString stringWithFormat:@"%@",confromTimespStrs];
    timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    timeLabel.textAlignment=NSTextAlignmentRight;
    timeLabel.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    [timeLabel setNumberOfLines:1];
    [timeLabel sizeToFit];
    timeLabel.frame=FRAME(WIDTH-10-timeLabel.frame.size.width, 10, timeLabel.frame.size.width, 20);
    [Cell addSubview:timeLabel];
    
    NSString *jsonstring=[NSString stringWithFormat:@"%@",[dic objectForKey:@"asset_json"]];
    NSData *data = [jsonstring   dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *cityDic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
    NSArray *nameArray =(NSArray *)cityDic;
    NSMutableArray *nameArr=[[NSMutableArray alloc]init];
    for (int i=0; i<nameArray.count; i++) {
//        NSString *nameString=[NSString stringWithFormat:@"%@",[nameArray[i] objectForKey:@"name"]];
        NSDictionary *personDic=@{@"name":[nameArray[i] objectForKey:@"name"],@"total":[nameArray[i] objectForKey:@"total"]};
        [nameArr addObject:personDic];
    }
    if (nameArr.count>3) {
        for (int i=0; i<3; i++) {
            NSDictionary*dicts=nameArr[i];
            switch (i) {
                case 0:
                {
                    
                    UILabel *numBerLabel=[[UILabel alloc]initWithFrame:FRAME(20, 40+20*i, WIDTH-80, 20)];
                    numBerLabel.text=[NSString stringWithFormat:@"%@",[dicts objectForKey:@"name"]];
                    numBerLabel.textColor=[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
                    numBerLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
                    [Cell addSubview:numBerLabel];
                    UILabel *numLabel=[[UILabel alloc]initWithFrame:FRAME(WIDTH-60, 40+20*i, 50, 20)];
                    numLabel.text=[NSString stringWithFormat:@"X%@",[dicts objectForKey:@"total"]];
                    numLabel.textColor=[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
                    numLabel.textAlignment=NSTextAlignmentRight;
                    numLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
                    [Cell addSubview:numLabel];
                }
                    break;
                case 1:
                {
                    
                    UILabel *numBerLabel=[[UILabel alloc]initWithFrame:FRAME(20, 40+20*i, WIDTH-80, 20)];
                    numBerLabel.text=[NSString stringWithFormat:@"%@",[dicts objectForKey:@"name"]];
                    numBerLabel.textColor=[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
                    numBerLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
                    [Cell addSubview:numBerLabel];
                    UILabel *numLabel=[[UILabel alloc]initWithFrame:FRAME(WIDTH-60,40+20*i, 50, 20)];
                    numLabel.text=[NSString stringWithFormat:@"X%@",[dicts objectForKey:@"total"]];
                    numLabel.textColor=[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
                    numLabel.textAlignment=NSTextAlignmentRight;
                    numLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
                    [Cell addSubview:numLabel];
                }
                    break;
                case 2:
                {
                    
                    UILabel *numBerLabel=[[UILabel alloc]initWithFrame:FRAME(20, 40+20*i, WIDTH-80, 20)];
                    numBerLabel.text=[NSString stringWithFormat:@"..."];
                    numBerLabel.textColor=[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
                    numBerLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
                    [Cell addSubview:numBerLabel];
                    UILabel *numLabel=[[UILabel alloc]initWithFrame:FRAME(WIDTH-60, 40+20*i, 50, 20)];
                    numLabel.text=[NSString stringWithFormat:@"X%@",[dicts objectForKey:@"total"]];
                    numLabel.textColor=[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
                    numLabel.textAlignment=NSTextAlignmentRight;
                    numLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
                    [Cell addSubview:numLabel];
                }
                    break;
                    
                default:
                    break;
            }
        }
        
    }else{
        for (int i=0; i<nameArr.count; i++) {
            NSDictionary*dicts=nameArr[i];
            switch (i) {
                case 0:
                {
                    
                    UILabel *numBerLabel=[[UILabel alloc]initWithFrame:FRAME(20, 40+20*i, WIDTH-80, 20)];
                    numBerLabel.text=[NSString stringWithFormat:@"%@",[dicts objectForKey:@"name"]];
                    numBerLabel.textColor=[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
                    numBerLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
                    [Cell addSubview:numBerLabel];
                    UILabel *numLabel=[[UILabel alloc]initWithFrame:FRAME(WIDTH-60, 40+20*i, 50, 20)];
                    numLabel.text=[NSString stringWithFormat:@"X%@",[dicts objectForKey:@"total"]];
                    numLabel.textColor=[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
                    numLabel.textAlignment=NSTextAlignmentRight;
                    numLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
                    [Cell addSubview:numLabel];
                }
                    break;
                case 1:
                {
                    
                    UILabel *numBerLabel=[[UILabel alloc]initWithFrame:FRAME(20, 40+20*i, WIDTH-80, 20)];
                    numBerLabel.text=[NSString stringWithFormat:@"%@",[dicts objectForKey:@"name"]];
                    numBerLabel.textColor=[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
                    numBerLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
                    [Cell addSubview:numBerLabel];
                    UILabel *numLabel=[[UILabel alloc]initWithFrame:FRAME(WIDTH-60, 40+20*i, 50, 20)];
                    numLabel.text=[NSString stringWithFormat:@"X%@",[dicts objectForKey:@"total"]];
                    numLabel.textColor=[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
                    numLabel.textAlignment=NSTextAlignmentRight;
                    numLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
                    [Cell addSubview:numLabel];
                }
                    break;
                case 2:
                {
                    
                    UILabel *numBerLabel=[[UILabel alloc]initWithFrame:FRAME(20, 40+20*i, WIDTH-80, 20)];
                    numBerLabel.text=[NSString stringWithFormat:@"%@",[dicts objectForKey:@"name"]];
                    numBerLabel.textColor=[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
                    numBerLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
                    [Cell addSubview:numBerLabel];
                    UILabel *numLabel=[[UILabel alloc]initWithFrame:FRAME(WIDTH-60, 40+20*i, 50, 20)];
                    numLabel.text=[NSString stringWithFormat:@"X%@",[dicts objectForKey:@"total"]];
                    numLabel.textColor=[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
                    numLabel.textAlignment=NSTextAlignmentRight;
                    numLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
                    [Cell addSubview:numLabel];
                }
                    break;
                    
                default:
                    break;
            }
        }

    }
    int totalInt=0;
    for (int i=0; i<nameArr.count; i++) {
        NSDictionary *dict=nameArr[i];
        int  total=[[dict objectForKey:@"total"]intValue];
        totalInt+=total;
    }
    int head=0;
    if (nameArr.count>3) {
        head=60;
    }else{
        head=20*(int)nameArr.count;
    }
    UILabel *peopleName=[[UILabel alloc]initWithFrame:FRAME(20, 50+head, WIDTH-40, 20)];
    peopleName.text=[NSString stringWithFormat:@"等 %d 件",totalInt];
    peopleName.textColor=[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1];
    peopleName.font=[UIFont fontWithName:@"Heiti SC" size:12];
    [Cell addSubview:peopleName];

    [Cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        dispatch_async(dispatch_get_main_queue(),^{
            [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        });
    }
    return Cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
