//
//  ExpressCompanyViewController.m
//  yxz
//
//  Created by 白玉林 on 16/3/30.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "ExpressCompanyViewController.h"

@interface ExpressCompanyViewController ()
{
    NSMutableArray *dicArray;
    UITableView *myTableView;
    int cellID;
}
@end

@implementation ExpressCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dicArray=[[NSMutableArray alloc]init];
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"simi.db"];
    sqlite3_open([path UTF8String], &citydb);
    
    sqlite3_stmt *statement;
    NSString *sql = @"SELECT * FROM express where is_hot = 1";
    
    if (sqlite3_prepare_v2(citydb, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *city_id = (char *)sqlite3_column_text(statement, 0);
            NSString *city_idStr = [[NSString alloc] initWithUTF8String:city_id];
            
            char *name = (char *)sqlite3_column_text(statement, 1);
            NSString *nameStr = [[NSString alloc] initWithUTF8String:name];
            
            char *add_time = (char *)sqlite3_column_text(statement, 2);
            NSString *add_timeStr = [[NSString alloc] initWithUTF8String:add_time];
            
            char *province_id = (char *)sqlite3_column_text(statement, 3);
            NSString *province_idStr = [[NSString alloc] initWithUTF8String:province_id];
            
            char *is_enable = (char *)sqlite3_column_text(statement, 7);
            NSString *is_enableStr = [[NSString alloc] initWithUTF8String:is_enable];
            
            char *zip_code = (char *)sqlite3_column_text(statement, 8);
            NSString *zip_codeStr = [[NSString alloc] initWithUTF8String:zip_code];
            
            NSDictionary *dic=@{@"express_id":city_idStr,@"ecode":nameStr,@"name":add_timeStr,@"is_hot":province_idStr,@"add_time":is_enableStr,@"update_time":zip_codeStr};
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
    _expressStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    _express_idStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"express_id"]];
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
