//
//  Work_or_ToolViewController.m
//  yxz
//
//  Created by 白玉林 on 16/2/24.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "Work_or_ToolViewController.h"

@interface Work_or_ToolViewController ()
{
    UITableView *myTableView;
    NSMutableArray *dataArray;
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    NSInteger   page;
    NSString *senderStr;
    int buttobID;
}
@end

@implementation Work_or_ToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _navlabel.textColor = [UIColor whiteColor];
    self.backlable.backgroundColor=HEX_TO_UICOLOR(0xbfbfbf, 1.0);
    self.img.hidden=YES;
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 20, 20)];
    img.image = [UIImage imageNamed:@"iconfont-p-back"];
    [_backBtn addSubview:img];
    self.navlabel.text=@"应用中心";
    dataArray =[[NSMutableArray alloc]init];
    page=1;
    myTableView=[[UITableView alloc]initWithFrame:FRAME(0, 108, WIDTH, HEIGHT-108)];
    myTableView.dataSource=self;
    myTableView.delegate=self;
//    myTableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [self.view addSubview:myTableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor=[UIColor whiteColor];
    [myTableView setTableFooterView:v];
    _refreshHeader = [[MJRefreshHeaderView alloc] init];
    _refreshHeader.delegate = self;
    _refreshHeader.scrollView = myTableView;
    
    _moreFooter = [[MJRefreshFooterView alloc] init];
    _moreFooter.delegate = self;
    _moreFooter.scrollView = myTableView;
    [self PLJKLayout];
    // Do any additional setup after loading the view.
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
//        page++;
        
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
#pragma mark 表格刷新相关
-(void)PLJKLayout
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager*_download = [[DownloadManager alloc]init];
//    NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary*_dict =@{@"app_type":@"xcloud",@"user_id":_manager.telephone};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:WATER_CELL dict:_dict view:self.view  delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];

//    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"simi.db"];
//    sqlite3_open([path UTF8String], &app_toolsdb);
//    
//    sqlite3_stmt *statement;
//    NSString *sql = @"SELECT * FROM app_tools order by no";
//    
//    if (sqlite3_prepare_v2(app_toolsdb, [sql UTF8String], -1, &statement, nil) == SQLITE_OK)
//    {
//        while (sqlite3_step(statement) == SQLITE_ROW) {
//            char *t_id = (char *)sqlite3_column_text(statement, 0);
//            NSString *t_idStr = [[NSString alloc] initWithUTF8String:t_id];
//            
//            char *name = (char *)sqlite3_column_text(statement, 2);
//            NSString *nameStr = [[NSString alloc] initWithUTF8String:name];
//            
//            char *logo = (char *)sqlite3_column_text(statement, 3);
//            NSString *logo_Str = [[NSString alloc] initWithUTF8String:logo];
//            
//            char *app_type = (char *)sqlite3_column_text(statement, 4);
//            NSString *app_typeStr = [[NSString alloc] initWithUTF8String:app_type];
//            
//            char *menu_type = (char *)sqlite3_column_text(statement, 5);
//            NSString *menu_typeeStr = [[NSString alloc] initWithUTF8String:menu_type];
//            
//            char *open_type = (char *)sqlite3_column_text(statement, 6);
//            NSString *open_typeStr = [[NSString alloc] initWithUTF8String:open_type];
//            
//            char *url = (char *)sqlite3_column_text(statement, 7);
//            NSString *urlStr = [[NSString alloc] initWithUTF8String:url];
//            
//            char *action = (char *)sqlite3_column_text(statement, 8);
//            NSString *actionStr = [[NSString alloc] initWithUTF8String:action];
//            
//            char *params = (char *)sqlite3_column_text(statement, 9);
//            NSString *paramsStr = [[NSString alloc] initWithUTF8String:params];
//            
//            char *is_default = (char *)sqlite3_column_text(statement, 10);
//            NSString *is_defaultStr = [[NSString alloc] initWithUTF8String:is_default];
//            
//            char *is_del = (char *)sqlite3_column_text(statement, 11);
//            NSString *is_delStr = [[NSString alloc] initWithUTF8String:is_del];
//            
//            char *is_partner = (char *)sqlite3_column_text(statement, 12);
//            NSString *is_partnerStr = [[NSString alloc] initWithUTF8String:is_partner];
//            
//            char *is_online = (char *)sqlite3_column_text(statement, 13);
//            NSString *is_onlineStr = [[NSString alloc] initWithUTF8String:is_online];
//            
//            char *app_provider = (char *)sqlite3_column_text(statement, 14);
//            NSString *app_providerStr = [[NSString alloc] initWithUTF8String:app_provider];
//            
//            char *app_describe = (char *)sqlite3_column_text(statement, 15);
//            NSString *app_describeStr = [[NSString alloc] initWithUTF8String:app_describe];
//            
//            char *auth_url = (char *)sqlite3_column_text(statement, 16);
//            NSString *auth_urlStr = [[NSString alloc] initWithUTF8String:auth_url];
//        
//            NSDictionary *dic=@{@"t_id":t_idStr,@"name":nameStr,@"logo":logo_Str,@"app_type":app_typeStr,@"menu_type":menu_typeeStr,@"open_type":open_typeStr,@"url":urlStr,@"action":actionStr,@"params":paramsStr,@"is_default":is_defaultStr,@"is_del":is_delStr,@"is_partner":is_partnerStr,@"is_online":is_onlineStr,@"app_provider":app_providerStr,@"app_describe":app_describeStr,@"auth_url":auth_urlStr};
//            if ([dataArray containsObject:dic]) {
//                
//            }else{
//                [dataArray addObject:dic];
//            }
//            
//        }
//        sqlite3_finalize(statement);
//    }
}
-(void)logDowLoadFinish:(id)sender
{
    
    senderStr=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    if (senderStr==nil||senderStr==NULL||[senderStr isEqualToString:@"(\n)"]||[senderStr length]==0) {
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        
    }else{
        NSArray *array=[sender objectForKey:@"data"];
        if (array.count<10*page) {
            _hasMore=YES;
        }else{
            _hasMore=NO;
        }
        if (page==1) {
            [dataArray removeAllObjects];
            for (int i=0; i<array.count; i++) {
                NSDictionary *dic=array[i];
                NSString *menu_type=[NSString stringWithFormat:@"%@",[dic objectForKey:@"menu_type"]];
                if ([menu_type isEqualToString:@"t"]) {
                    [dataArray addObject:array[i]];
                }
            }
            
        }else{
            for (int i=0; i<array.count; i++) {
                NSDictionary *dic=array[i];
                NSString *menu_type=[NSString stringWithFormat:@"%@",[dic objectForKey:@"menu_type"]];
                if ([menu_type isEqualToString:@"t"]) {
                    if ([dataArray containsObject:array[i]]) {
                        
                    }else{
                        
                        [dataArray addObject:array[i]];
                    }
                }
                
                
            }
        }
        
    }
    if (dataArray.count==0) {
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }
    [myTableView reloadData];
}
-(void)DownFail:(id)sender
{
    NSLog(@"erroe is %@",sender);
    [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}



//绘制Cell

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary*dataDic=dataArray[indexPath.row];
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell%ld,%ld",(long)indexPath.row,(long)indexPath.section];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        dispatch_async(dispatch_get_main_queue(),^{
            [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        });
    }
    UIImageView *headeImageView=[[UIImageView alloc]initWithFrame:FRAME(10, 20, 40, 40)];
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"logo"]];
    [headeImageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
    headeImageView.layer.cornerRadius=headeImageView.frame.size.width/2;
    headeImageView.clipsToBounds=YES;
    [cell addSubview:headeImageView];
    UILabel *nameLabel=[[UILabel alloc]init];
    nameLabel.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"name"]];
    nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    [nameLabel setNumberOfLines:1];
    [nameLabel sizeToFit];
    nameLabel.frame=FRAME(headeImageView.frame.size.width+20, 14, nameLabel.frame.size.width, 16);
    [cell addSubview:nameLabel];
    UILabel *app_describeLab=[[UILabel alloc]initWithFrame:FRAME(headeImageView.frame.size.width+20, nameLabel.frame.size.height+nameLabel.frame.origin.y+5, WIDTH-headeImageView.frame.size.width-75, 13)];
    app_describeLab.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"app_describe"]];
    app_describeLab.font=[UIFont fontWithName:@"Heiti SC" size:12];
    app_describeLab.textColor=[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1];
//    [app_describeLab setNumberOfLines:1];
//    [app_describeLab sizeToFit];
    [cell addSubview:app_describeLab];
    
    UILabel *app_providerLab=[[UILabel alloc]initWithFrame:FRAME(headeImageView.frame.size.width+20, app_describeLab.frame.size.height+app_describeLab.frame.origin.y+5, app_describeLab.frame.size.width, 13)];
    app_providerLab.text=[NSString stringWithFormat:@"提供者:%@",[dataDic objectForKey:@"app_provider"]];
    app_providerLab.font=[UIFont fontWithName:@"Heiti SC" size:12];
    app_providerLab.textColor=[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1];
//    [app_providerLab setNumberOfLines:1];
//    [app_providerLab sizeToFit];
    [cell addSubview:app_providerLab];
    
    NSString *statusStr=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"status"]];
    UIButton *addButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-55, (80-25)/2, 45, 25)];
    if (statusStr==nil||statusStr==NULL||[statusStr isEqualToString:@"<null>"]) {
        int is_defaultInt=[[dataDic objectForKey:@"is_default"]intValue];
        if (is_defaultInt==0) {
            addButton.enabled=TRUE;
            [addButton.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
            [addButton.layer setCornerRadius:5];
            [addButton.layer setBorderWidth:1];//设置边界的宽度
            //设置按钮的边界颜色
            CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
            CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){1,0,0,1});
            [addButton.layer setBorderColor:color];
            [addButton setTitle:@"添加" forState:UIControlStateNormal];
            [addButton setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
        }else{
            int is_delInt=[[dataDic objectForKey:@"is_del"]intValue];
            if (is_delInt==0) {
                [addButton.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
                [addButton.layer setCornerRadius:5];
                [addButton.layer setBorderWidth:1];//设置边界的宽度
                //设置按钮的边界颜色
                CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
                CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0.6,0.6,0.6,1});
                [addButton.layer setBorderColor:color];

                [addButton setTitle:@"取消" forState:UIControlStateNormal];
                [addButton setTitleColor:[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1] forState:UIControlStateNormal];
                addButton.enabled=TRUE;
            }else{
                [addButton setTitle:@"已添加" forState:UIControlStateNormal];
                [addButton setTitleColor:[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1] forState:UIControlStateNormal];
                addButton.enabled=FALSE;
            }
            
        }
    }else{
        int statusID=[[dataDic objectForKey:@"status"]intValue];
        if (statusID==0) {
            addButton.enabled=TRUE;
            [addButton.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
            [addButton.layer setCornerRadius:5];
            [addButton.layer setBorderWidth:1];//设置边界的宽度
            //设置按钮的边界颜色
            CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
            CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){1,0,0,1});
            [addButton.layer setBorderColor:color];
            [addButton setTitle:@"添加" forState:UIControlStateNormal];
            [addButton setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
        }else{
            int is_delInt=[[dataDic objectForKey:@"is_del"]intValue];
            if (is_delInt==0) {
                [addButton.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
                [addButton.layer setCornerRadius:5];
                [addButton.layer setBorderWidth:1];//设置边界的宽度
                //设置按钮的边界颜色
                CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
                CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0.6,0.6,0.6,1});
                [addButton.layer setBorderColor:color];

                [addButton setTitle:@"取消" forState:UIControlStateNormal];
                [addButton setTitleColor:[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1] forState:UIControlStateNormal];
                addButton.enabled=TRUE;
            }else{
                [addButton setTitle:@"已添加" forState:UIControlStateNormal];
                [addButton setTitleColor:[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1] forState:UIControlStateNormal];
                addButton.enabled=FALSE;
            }

        }
    }
    
    addButton.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
    addButton.tag=indexPath.row;
    [addButton addTarget:self action:@selector(addButAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:addButton];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [myTableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(void)addButAction:(UIButton *)button
{
    NSDictionary *dic=dataArray[button.tag];
    NSString *t_idStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"t_id"]];
    
    NSString *statusStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
    if (statusStr==nil||statusStr==NULL||[statusStr isEqualToString:@"<null>"]) {
        int is_defaultInt=[[dic objectForKey:@"is_default"]intValue];
        if (is_defaultInt==0) {
            ISLoginManager *_manager = [ISLoginManager shareManager];
            DownloadManager*_download = [[DownloadManager alloc]init];
            //    NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
            NSDictionary*_dict =@{@"user_id":_manager.telephone,@"t_id":t_idStr,@"status":@"1"};
            NSLog(@"字典数据%@",_dict);
            [_download requestWithUrl:USER_NEWLY_ADDED dict:_dict view:self.view  delegate:self finishedSEL:@selector(AddedSuccess:) isPost:YES failedSEL:@selector(AddedFail:)];
        }else{
            int is_delInt=[[dic objectForKey:@"is_del"]intValue];
            if (is_delInt==0) {
                ISLoginManager *_manager = [ISLoginManager shareManager];
                DownloadManager*_download = [[DownloadManager alloc]init];
                //    NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
                NSDictionary*_dict =@{@"user_id":_manager.telephone,@"t_id":t_idStr,@"status":@"0"};
                NSLog(@"字典数据%@",_dict);
                [_download requestWithUrl:USER_NEWLY_ADDED dict:_dict view:self.view  delegate:self finishedSEL:@selector(AddedSuccess:) isPost:YES failedSEL:@selector(AddedFail:)];
            }
        }
        

    }else{
        int statusID=[[dic objectForKey:@"status"]intValue];
        if (statusID==0) {
            ISLoginManager *_manager = [ISLoginManager shareManager];
            DownloadManager*_download = [[DownloadManager alloc]init];
            //    NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
            NSDictionary*_dict =@{@"user_id":_manager.telephone,@"t_id":t_idStr,@"status":@"1"};
            NSLog(@"字典数据%@",_dict);
            [_download requestWithUrl:USER_NEWLY_ADDED dict:_dict view:self.view  delegate:self finishedSEL:@selector(AddedSuccess:) isPost:YES failedSEL:@selector(AddedFail:)];
        }else{
            ISLoginManager *_manager = [ISLoginManager shareManager];
            DownloadManager*_download = [[DownloadManager alloc]init];
            //    NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
            NSDictionary*_dict =@{@"user_id":_manager.telephone,@"t_id":t_idStr,@"status":@"0"};
            NSLog(@"字典数据%@",_dict);
            [_download requestWithUrl:USER_NEWLY_ADDED dict:_dict view:self.view  delegate:self finishedSEL:@selector(AddedSuccess:) isPost:YES failedSEL:@selector(AddedFail:)];
        }

    }
}
-(void)AddedSuccess:(id)sourceData
{
    [self PLJKLayout];
}
-(void)AddedFail:(id)sourceData
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
