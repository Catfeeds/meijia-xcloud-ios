//
//  CollectCategoryViewController.m
//  yxz
//
//  Created by 白玉林 on 16/4/1.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "CollectCategoryViewController.h"
#import "CollectCategoryTableViewCell.h"
@interface CollectCategoryViewController ()
{
    UITableView *_rightTableView;
    UITableView *_leftTableView;
    NSMutableArray *_leftTableSource;
    NSArray *_rightTableSource;
    NSDictionary *dataDic;
    int  numbar;
    int cellids;
    
    UILabel *numLabel;
//    MJRefreshHeaderView *_refreshHeader;
//    MJRefreshFooterView *_moreFooter;
//    BOOL _needRefresh;
//    BOOL _hasMore;
//    NSInteger   page;
    
}
@end

@implementation CollectCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _leftTableSource=[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view, typically from a nib.
//    _leftTableSource =@[@"11",@"22",@"33",@"44",@"55",@"66"];
    _collectData=[[NSMutableArray alloc]init];
    _dataArray=[[NSMutableArray alloc]init];
    self.navlabel.text=@"资产类别";
    self.backlable.backgroundColor=HEX_TO_UICOLOR(0x11cd6e, 1.0);
    _navlabel.textColor = [UIColor whiteColor];
    self.img.hidden=YES;
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 20, 20)];
    img.image = [UIImage imageNamed:@"iconfont-p-back"];
    [_backBtn addSubview:img];
    
    

    
//    _rightTableSource =@[@{@"header":@"11",@"title":@[@"aa",@"bb",@"cc",@"dd",@"ee",@"ff"]},
//                         @{@"header":@"22",@"title":@[@"gg",@"mm",@"nn",@"oo",@"pp",@"qq"]},
//                         @{@"header":@"33",@"title":@[@"rr",@"ss",@"jj",@"xx",@"yy",@"zz"]},
//                         @{@"header":@"44",@"title":@[@"aa",@"bb",@"cc",@"dd",@"ee",@"ff"]},
//                         @{@"header":@"55",@"title":@[@"gg",@"mm",@"nn",@"oo",@"pp",@"qq"]},
//                         @{@"header":@"66",@"title":@[@"rr",@"ss",@"jj",@"xx",@"yy",@"zz"]}];
    [self collectCategory];
    [self setupSomeParamars];
    UIView *view=[[UIView alloc]initWithFrame:FRAME(0, HEIGHT-44, WIDTH, 44)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME(26/2, 0, 44, 44)];
    imageView.image=[UIImage imageNamed:@"物品领用申请"];
    [view addSubview:imageView];
    
    UIView *lineView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 1)];
    lineView.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    [view addSubview:lineView];
    
    UILabel *label1=[[UILabel alloc]init];
    label1.text=@"您已选择";
    label1.font=[UIFont fontWithName:@"Heiti SC" size:13];
    [label1 setNumberOfLines:1];
    [label1 sizeToFit];
    label1.frame=FRAME(70, 3, label1.frame.size.width, 20);
    [view addSubview:label1];
    
    numLabel=[[UILabel alloc]initWithFrame:FRAME(70, 24, 20, 20)];
    numLabel.font=[UIFont fontWithName:@"Heiti SC" size:17];
    numLabel.text=@"0";
    [view addSubview:numLabel];
    
    UILabel *label2=[[UILabel alloc]init];
    label2.text=@"件物品";
    label2.font=[UIFont fontWithName:@"Heiti SC" size:13];
    [label2 setNumberOfLines:1];
    [label2 sizeToFit];
    label2.frame=FRAME(numLabel.frame.size.width+numLabel.frame.origin.x, 24, label2.frame.size.width, 20);
    [view addSubview:label2];
    
    UIButton *buttonLY=[[UIButton alloc]initWithFrame:FRAME(WIDTH-93, 0, 93, 44)];
    buttonLY.backgroundColor=self.backlable.backgroundColor;
    [buttonLY setTitle:@"去领用" forState:UIControlStateNormal];
    [buttonLY addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonLY];
    // Do any additional setup after loading the view.
}
-(void)buttonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)collectCategory
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *company_ID=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"company_id"]];
    NSDictionary *_dict = @{@"user_id":_manager.telephone,@"company_id":company_ID};
    DownloadManager *_download = [[DownloadManager alloc]init];
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",COMPANY_COLLECT_CATEGORY] dict:_dict view:self.view delegate:self finishedSEL:@selector(CollectSuccess:) isPost:NO failedSEL:@selector(CollectFail:)];
}
-(void)CollectSuccess:(id)source
{
    NSLog(@"%@",source);
    int status=[[source objectForKey:@"status"]intValue];
    if (status==0) {
        NSMutableArray *dicarray=[[NSMutableArray alloc]init];
        dataDic=[source objectForKey:@"data"];
        NSString *string=[NSString stringWithFormat:@"%@",[source objectForKey:@"data"]];
        if (string==nil||string==NULL||[string isEqualToString:@""]) {
            NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *path = [NSString stringWithFormat:@"%@/simi.db", pathDocuments];
            sqlite3_open([path UTF8String], &xcompany_setting);
            
            sqlite3_stmt *statement;
            NSString *sql = @"SELECT * FROM xcompany_setting";
            
            if (sqlite3_prepare_v2(xcompany_setting, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
                
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    char *_id = (char *)sqlite3_column_text(statement, 0);
                    NSString *idStr = [[NSString alloc] initWithUTF8String:_id];
                    
                    char *company_id = (char *)sqlite3_column_text(statement, 1);
                    NSString *company_idStr = [[NSString alloc] initWithUTF8String:company_id];
                    
                    char *name = (char *)sqlite3_column_text(statement, 2);
                    NSString *nameStr = [[NSString alloc] initWithUTF8String:name];
                    
                    char *setting_type = (char *)sqlite3_column_text(statement, 3);
                    NSString *setting_typeStr = [[NSString alloc] initWithUTF8String:setting_type];
                    
                    char *is_enable = (char *)sqlite3_column_text(statement, 5);
                    NSString *is_enableStr = [[NSString alloc] initWithUTF8String:is_enable];
                    
                    char *add_time = (char *)sqlite3_column_text(statement, 6);
                    NSString *add_timeStr = [[NSString alloc] initWithUTF8String:add_time];
                    
                    char *update_time = (char *)sqlite3_column_text(statement, 7);
                    NSString *update_timeStr = [[NSString alloc] initWithUTF8String:update_time];
                    
                    NSDictionary *dic=@{@"id":idStr,@"company_id":company_idStr,@"name":nameStr,@"setting_type":setting_typeStr,@"is_enable":is_enableStr,@"add_time":add_timeStr,@"update_time":update_timeStr};
                    if ([_leftTableSource containsObject:dic]) {
                        
                    }else{
                        [_leftTableSource addObject:dic];
                    }
                    
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(xcompany_setting);
        }else{
            NSArray *ar=dataDic.allKeys;
            NSComparator cmptr = ^(id obj1, id obj2){
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            };
            //排序后
            NSArray *arrays = [ar sortedArrayUsingComparator:cmptr];
            for (int i=0; i<arrays.count; i++) {
                NSDictionary *dic=@{@"id":arrays[i],@"fiel":[dataDic objectForKey:arrays[i]]};
                [dicarray addObject:dic];
            }
            
            _rightTableSource=dicarray;
            for (int i=0; i<_rightTableSource.count; i++) {
                NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *path = [NSString stringWithFormat:@"%@/simi.db", pathDocuments];
                sqlite3_open([path UTF8String], &xcompany_setting);
                
                sqlite3_stmt *statement;
                NSString *sql = [NSString stringWithFormat:@"SELECT * FROM xcompany_setting where id=%@",[_rightTableSource[i]objectForKey:@"id"]];
                
                if (sqlite3_prepare_v2(xcompany_setting, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
                    
                    while (sqlite3_step(statement) == SQLITE_ROW) {
                        char *_id = (char *)sqlite3_column_text(statement, 0);
                        NSString *idStr = [[NSString alloc] initWithUTF8String:_id];
                        
                        char *company_id = (char *)sqlite3_column_text(statement, 1);
                        NSString *company_idStr = [[NSString alloc] initWithUTF8String:company_id];
                        
                        char *name = (char *)sqlite3_column_text(statement, 2);
                        NSString *nameStr = [[NSString alloc] initWithUTF8String:name];
                        
                        char *setting_type = (char *)sqlite3_column_text(statement, 3);
                        NSString *setting_typeStr = [[NSString alloc] initWithUTF8String:setting_type];
                        
                        char *is_enable = (char *)sqlite3_column_text(statement, 5);
                        NSString *is_enableStr = [[NSString alloc] initWithUTF8String:is_enable];
                        
                        char *add_time = (char *)sqlite3_column_text(statement, 6);
                        NSString *add_timeStr = [[NSString alloc] initWithUTF8String:add_time];
                        
                        char *update_time = (char *)sqlite3_column_text(statement, 7);
                        NSString *update_timeStr = [[NSString alloc] initWithUTF8String:update_time];
                        
                        NSDictionary *dic=@{@"id":idStr,@"company_id":company_idStr,@"name":nameStr,@"setting_type":setting_typeStr,@"is_enable":is_enableStr,@"add_time":add_timeStr,@"update_time":update_timeStr};
                        if ([_leftTableSource containsObject:dic]) {
                            
                        }else{
                            [_leftTableSource addObject:dic];
                        }
                        
                    }
                    sqlite3_finalize(statement);
                }
                sqlite3_close(xcompany_setting);
            }

        }
        
        NSLog(@"%@",_leftTableSource);
        [_rightTableView reloadData];
        [_leftTableView reloadData];
    }
    
}
-(void)CollectFail:(id)source
{
    NSLog(@"%@",source);
}
//创建两个tableview
- (void)setupSomeParamars
{
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(100,64, self.view.frame.size.width - 100, HEIGHT-108)];
    _rightTableView.dataSource =self;
    _rightTableView.delegate =self;
    [self.view addSubview:_rightTableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_rightTableView setTableFooterView:v];
    
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, 100,HEIGHT-108)];
    _leftTableView.dataSource =self;
    _leftTableView.delegate =self;
    [self.view addSubview:_leftTableView];
    UIView *vs = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_leftTableView setTableFooterView:vs];
    
    
}

//去掉UItableview headerview黏性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _rightTableView)
    {
        CGFloat sectionHeaderHeight = HEIGHT-64;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int  heade;
    if(tableView == _rightTableView){
        heade=90;
    }else if (tableView == _leftTableView){
        heade=40;
    }
    return heade;
}
//设置cell的显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifer =@"cell";
    NSString *tagstr=[NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    float tagID=[tagstr floatValue];
    CollectCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifer];
    cell.tag=tagID;
    if(!cell){
        cell = [[CollectCategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifer];
    }

    if(tableView == _rightTableView){
        cell.arrayss=_rightTableSource;
        cell.addBut.hidden=NO;
        cell.reduceBut.hidden=NO;
        cell.shuLabel.hidden=NO;
        cell.addBut.tag=tagID;
        cell.reduceBut.tag=tagID;
        cell.numLabel.tag=tagID;
        [cell.addBut addTarget:self action:@selector(addBut:) forControlEvents:UIControlEventTouchUpInside];
        [cell.reduceBut addTarget:self action:@selector(_reduceBut:) forControlEvents:UIControlEventTouchUpInside];
        cell.numLabel.hidden=NO;
        cell.nameLabel.text = [[_rightTableSource[indexPath.section]objectForKey:@"fiel"][indexPath.row]objectForKey:@"name"];
        cell.shuLabel.text=[NSString stringWithFormat:@"剩余:%@件",[[_rightTableSource[indexPath.section]objectForKey:@"fiel"][indexPath.row]objectForKey:@"stock"]];
        UILabel *label=[[UILabel alloc]initWithFrame:FRAME(WIDTH-180, 10, 40, 20)];
        label.tag=[[NSString stringWithFormat:@"%ld,%ld",(long)indexPath.section,(long)indexPath.row]intValue];
        label.font=[UIFont fontWithName:@"Heiti SC" size:10];
        [cell addSubview:label];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }else if (tableView == _leftTableView){
        cell.addBut.hidden=YES;
        cell.reduceBut.hidden=YES;
        cell.numLabel.hidden=YES;
        cell.shuLabel.hidden=YES;
        cell.nameLabel.text =[NSString stringWithFormat:@"%@",[_leftTableSource[indexPath.row] objectForKey:@"name"]];
        
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _rightTableView) {
        return 30;
    }else{
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _rightTableView) {
        return _rightTableSource.count;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTableView) {
        return _leftTableSource.count;
    }else{
        return [[_rightTableSource[section]objectForKey:@"fiel"]count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == _rightTableView) {
        return [_rightTableSource[section]objectForKey:@"id"];
    }else{
        return nil;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == _rightTableView){
        NSString *textstr;
        NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *path = [NSString stringWithFormat:@"%@/simi.db", pathDocuments];
        sqlite3_open([path UTF8String], &xcompany_setting);
        
        sqlite3_stmt *statement;
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM xcompany_setting where id=%@",[_rightTableSource[section]objectForKey:@"id"]];
        
        if (sqlite3_prepare_v2(xcompany_setting, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *_id = (char *)sqlite3_column_text(statement, 0);
                NSString *idStr = [[NSString alloc] initWithUTF8String:_id];
                
                char *company_id = (char *)sqlite3_column_text(statement, 1);
                NSString *company_idStr = [[NSString alloc] initWithUTF8String:company_id];
                
                char *name = (char *)sqlite3_column_text(statement, 2);
                NSString *nameStr = [[NSString alloc] initWithUTF8String:name];
                
                char *setting_type = (char *)sqlite3_column_text(statement, 3);
                NSString *setting_typeStr = [[NSString alloc] initWithUTF8String:setting_type];
                
                char *is_enable = (char *)sqlite3_column_text(statement, 5);
                NSString *is_enableStr = [[NSString alloc] initWithUTF8String:is_enable];
                
                char *add_time = (char *)sqlite3_column_text(statement, 6);
                NSString *add_timeStr = [[NSString alloc] initWithUTF8String:add_time];
                
                char *update_time = (char *)sqlite3_column_text(statement, 7);
                NSString *update_timeStr = [[NSString alloc] initWithUTF8String:update_time];
                
                NSDictionary *dic=@{@"id":idStr,@"company_id":company_idStr,@"name":nameStr,@"setting_type":setting_typeStr,@"is_enable":is_enableStr,@"add_time":add_timeStr,@"update_time":update_timeStr};
                textstr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(xcompany_setting);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width-100,30)];
        label.backgroundColor = [UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1];
        label.text = textstr;
        label.textColor = [UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1];
        return label;
    }else{
        return nil;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_leftTableView deselectRowAtIndexPath:indexPath animated:NO];
    [_rightTableView deselectRowAtIndexPath:indexPath animated:NO];
    if(tableView == _leftTableView){
        NSLog(@"%ld",(long)indexPath.row);
//        NSArray *array=[_rightTableSource[indexPath.row]objectForKey:@"fiel"];
        if((_rightTableSource.count-1)<=indexPath.row){
            
        }else{
            [_rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.row]animated:YES scrollPosition:UITableViewScrollPositionBottom];
        }
        
    }else{
        CollectCategoryTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSLog(@"%@",cell.numLabel.text);
            }

}
-(void)addBut:(UIButton *)button
{
    int  bbID = 0;
    for (CollectCategoryTableViewCell *cell1 in [_rightTableView visibleCells])
    {
        NSLog(@"%ld=====%ld",(long)cell1.numLabel.tag,(long)button.tag);
        if (cell1.numLabel.tag==button.tag) {

            NSString *string=[NSString stringWithFormat:@"%ld",(long)button.tag];
            NSString *numberString=cell1.numLabel.text;
            NSString * scaknid;
            NSString * rowID;
            if ([string isEqualToString:@"0"]||[string length]==1) {
                scaknid=@"0";
                rowID=string;
            }else if ([string isEqualToString:@"1"])
            {
                scaknid=@"1";
                rowID=@"0";
            }else{
                scaknid = [string substringToIndex:1];//截取下标7之前的字符串
                NSLog(@"截取的值为：%@",string);
                rowID=[string substringFromIndex:1];//截取下标2之后的字符串
                NSLog(@"截取的值为：%@",string);
            }
            
            int  s,n;
            s=[scaknid intValue];
            n=[rowID intValue];
            int a=[cell1.numLabel.text intValue];
            NSString *str=[NSString stringWithFormat:@"%@",[[_rightTableSource[s]objectForKey:@"fiel"][n]objectForKey:@"stock"]];
            int  sID=[str intValue];
            if (a>=sID) {
                bbID=100;
            }else{
                a++;
            }
            
            //之前在cell初始化时就将textfield的tag赋值比button大100，方便判断
            cell1.numLabel.text = [NSString stringWithFormat:@"%d",a];
            NSString *collectName=[NSString stringWithFormat:@"%@,%@",[_leftTableSource[s]objectForKey:@"name"],[[_rightTableSource[s]objectForKey:@"fiel"][n]objectForKey:@"name"]];
            NSDictionary *dateDict=@{@"name":collectName,@"number":numberString};
            if ([_collectData containsObject:dateDict]) {
                
            }else{
                for (int i=0; i<_collectData.count; i++) {
                    NSDictionary *dic=_collectData[i];
                    NSString *idStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
                    if ([collectName isEqualToString:idStr]) {
                        [_collectData removeObject:dic];
                    }
                }

                [_collectData addObject:dateDict];
            }
            NSString *asset_id=[NSString stringWithFormat:@"%@",[[_rightTableSource[s]objectForKey:@"fiel"][n]objectForKey:@"asset_id"]];
            NSString *total=cell1.numLabel.text;
            NSDictionary *dict=@{@"asset_id":asset_id,@"total":total};
            if ([_dataArray containsObject:dict]) {
                
            }else{
                for (int i=0; i<_dataArray.count; i++) {
                    NSDictionary *dic=_dataArray[i];
                    NSString *idStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"asset_id"]];
                    if ([asset_id isEqualToString:idStr]) {
                        [_dataArray removeObject:dic];
                    }
                }
                [_dataArray addObject:dict];
            }

//            return;
        }
        
    }
    cellids=(int)button.tag;
    if (bbID==100) {
        
    }else{
       numbar++;
    }
    
    numLabel.text=[NSString stringWithFormat:@"%d",numbar];
    [numLabel setNumberOfLines:1];
    [numLabel sizeToFit];
    numLabel.frame=FRAME(70, 24, numLabel.frame.size.width, 20);
//    _numLabel.text=[NSString stringWithFormat:@"%d",_numbar];
}
-(void)_reduceBut:(UIButton *)button
{
    int bbID=0;
    
    for (CollectCategoryTableViewCell *cell1 in [_rightTableView visibleCells])
    {
        if (cell1.numLabel.tag==button.tag) {
            int a=[cell1.numLabel.text intValue];
            if (a>0) {
                bbID=100;
                a--;
                cell1.numLabel.text=[NSString stringWithFormat:@"%d",a];
                
                NSString *string=[NSString stringWithFormat:@"%ld",(long)button.tag];
                NSString * scaknid;
                NSString * rowID;
                if ([string isEqualToString:@"0"]||[string length]==1) {
                    scaknid=@"0";
                    rowID=string;
                }else if ([string isEqualToString:@"1"])
                {
                    scaknid=@"1";
                    rowID=@"0";
                }else{
                    scaknid = [string substringToIndex:1];//截取下标7之前的字符串
                    NSLog(@"截取的值为：%@",string);
                    rowID=[string substringFromIndex:1];//截取下标2之后的字符串
                    NSLog(@"截取的值为：%@",string);
                }
                
                int  s,n;
                s=[scaknid intValue];
                n=[rowID intValue];
                
                NSString *numberString=cell1.numLabel.text;
                
                NSString *collectName=[NSString stringWithFormat:@"%@,%@",[_leftTableSource[s]objectForKey:@"name"],[[_rightTableSource[s]objectForKey:@"fiel"][n]objectForKey:@"name"]];
                NSDictionary *dateDict=@{@"name":collectName,@"number":numberString};
                if ([_collectData containsObject:dateDict]) {
                    
                }else{
                    for (int i=0; i<_collectData.count; i++) {
                        NSDictionary *dic=_collectData[i];
                        NSString *idStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
                        if ([collectName isEqualToString:idStr]) {
                            [_collectData removeObject:dic];
                        }
                    }

                    if (a>0) {
                        [_collectData addObject:dateDict];
                    }else{
                        [_collectData removeObject:dateDict];
                    }
                    
                }
                NSString *asset_id=[NSString stringWithFormat:@"%@",[[_rightTableSource[s]objectForKey:@"fiel"][n]objectForKey:@"asset_id"]];
                NSString *total=cell1.numLabel.text;
                NSDictionary *dict=@{@"asset_id":asset_id,@"total":total};
                if ([_dataArray containsObject:dict]) {
                    
                }else{
                    for (int i=0; i<_dataArray.count; i++) {
                        NSDictionary *dic=_dataArray[i];
                        NSString *idStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"asset_id"]];
                        if ([asset_id isEqualToString:idStr]) {
                            [_dataArray removeObject:dic];
                        }
                    }
                    if (a>0) {
                        [_dataArray addObject:dict];
                    }else{
                        [_dataArray removeObject:dict];
                    }
                    
                }

//                return;
            }
        }
    }
    if (numbar>0) {
        if (bbID==0) {
            
        }else{
            numbar--;
        }
        
    }
    numLabel.text=[NSString stringWithFormat:@"%d",numbar];
    [numLabel setNumberOfLines:1];
    [numLabel sizeToFit];
    numLabel.frame=FRAME(70, 24, numLabel.frame.size.width, 20);
}

//联动效果在于这里
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if(tableView == _rightTableView){
        [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:section inSection:0]animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
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
