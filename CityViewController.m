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

@interface CityViewController ()<UISearchBarDelegate>
{
    NSMutableArray *dicArray;
    NSString *databasePath;
    NSArray * cityArr;
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
    cityArr = [NSArray arrayWithArray:dicArray];
    a=0;
    [self cityLayout];
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(70, 26, WIDTH-140, 28)];
    searchBar.placeholder = @"请输入搜索内容";
//    searchBar.barStyle = UISearchBarStyleProminent;
    searchBar.delegate = self;
//    searchBar.backgroundColor = [UIColor whiteColor];
    UITextField *searchField1 = [searchBar valueForKey:@"_searchField"];
    searchField1.backgroundColor = [UIColor whiteColor];
//    searchBar.tintColor = [UIColor blackColor];
    [self.navlabel.superview addSubview:searchBar];

    UIImage* searchBarBg = [self GetImageWithColor:[UIColor clearColor] andHeight:32.0f];
    //设置背景图片
    [searchBar setBackgroundImage:searchBarBg];
    //设置背景色
    [searchBar setBackgroundColor:[UIColor clearColor]];
   
    
}

- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"%@",searchText);
    if (searchText.length == 0) {
        dicArray = [NSMutableArray arrayWithArray:cityArr];
    }else{
        [dicArray removeAllObjects];
        for (NSInteger i = 0; i < cityArr.count; i++) {
            NSLog(@"%@",cityArr[i][@"name"]);
            if ([cityArr[i][@"name"] rangeOfString:searchText].location != NSNotFound) {
                
                NSLog(@"这个字符串中有a");
                [dicArray addObject:cityArr[i]];
            }
        }
    }
     [_cityTableView reloadData];
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    [self.view endEditing:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [self.view endEditing:YES];
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
