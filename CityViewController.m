//
//  CityViewController.m
//  simi
//
//  Created by 白玉林 on 15/8/31.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "CityViewController.h"
#import "DownloadManager.h"
#import "BookingViewController.h"
@interface CityViewController ()
{
    NSMutableArray *dicArray;
    NSString *databasePath;
    int a;
}
@end

@implementation CityViewController
-(void)viewWillAppear:(BOOL)animated
{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    dicArray=[[NSMutableArray alloc]init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/simi.db", pathDocuments];
    sqlite3_open([path UTF8String], &citydb);

    sqlite3_stmt *statement;
    NSString *sql = @"SELECT * FROM city";
    
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
            
            char *is_enable = (char *)sqlite3_column_text(statement, 4);
            NSString *is_enableStr = [[NSString alloc] initWithUTF8String:is_enable];
            
            char *zip_code = (char *)sqlite3_column_text(statement, 5);
            NSString *zip_codeStr = [[NSString alloc] initWithUTF8String:zip_code];
            
            NSDictionary *dic=@{@"city_id":city_idStr,@"name":nameStr,@"add_time":add_timeStr,@"province_id":province_idStr,@"is_enable":is_enableStr,@"zip_code":zip_codeStr};
            if ([dicArray containsObject:dic]) {
                
            }else{
                [dicArray addObject:dic];
            }
            
        }
        sqlite3_finalize(statement);
    }

    a=0;
    [self cityLayout];
   
   // [self ck];
    // Do any additional setup after loading the view.
}
-(void)cityLayout
{
    _cityTableView=[[UITableView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    _cityTableView.dataSource=self;
    _cityTableView.delegate=self;
    [self.view addSubview:_cityTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dicArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic=dicArray[indexPath.row];
    a+=1;
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
        cell.textLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_cityID==20001) {
        _setout=[dicArray[indexPath.row] objectForKey:@"name"];
        _fromCityID=[dicArray[indexPath.row]objectForKey:@"city_id"];
    }else if(_cityID==20002)
    {
        _destination=[dicArray[indexPath.row] objectForKey:@"name"];
        _toCityId=[dicArray[indexPath.row]objectForKey:@"city_id"];
    }
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
