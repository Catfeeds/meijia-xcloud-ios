//
//  AssetsCategoryViewController.m
//  yxz
//
//  Created by 白玉林 on 16/3/31.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "AssetsCategoryViewController.h"

@interface AssetsCategoryViewController ()
{
    NSMutableArray *dicArray;
    UITableView *myTableView;
    int cellID;
}
@end

@implementation AssetsCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navlabel.text=@"资产类别";
    self.backlable.backgroundColor=HEX_TO_UICOLOR(0x11cd6e, 1.0);
    _navlabel.textColor = [UIColor whiteColor];
    self.img.hidden=YES;
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 20, 20)];
    img.image = [UIImage imageNamed:@"iconfont-p-back"];
    [_backBtn addSubview:img];

    dicArray=[[NSMutableArray alloc]init];
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
            if ([dicArray containsObject:dic]) {
                
            }else{
                [dicArray addObject:dic];
            }
            
        }
        sqlite3_finalize(statement);
    }
    NSLog(@"%@",dicArray);
    cellID=-1;
    [self tableViewLayout];

    // Do any additional setup after loading the view.
}
-(void)tableViewLayout
{
    myTableView=[[UITableView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    myTableView.dataSource=self;
    myTableView.delegate=self;
    [self.view addSubview:myTableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [myTableView setTableFooterView:v];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dicArray.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=dicArray[indexPath.row];
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    UITableViewCell *Cell = [tableView cellForRowAtIndexPath:indexPath];
    if (Cell == nil) {
        Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:FRAME(30, 15, WIDTH-60, 20)];
    moneyLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    moneyLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    [Cell addSubview:moneyLabel];
    if (cellID==indexPath.row) {
        [Cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    return Cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=dicArray[indexPath.row];
    [myTableView deselectRowAtIndexPath:indexPath animated:NO];
    cellID=(int)indexPath.row;
    _nameStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    _idsStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [myTableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
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
