//
//  TeamWorkCityViewController.m
//  yxz
//
//  Created by 白玉林 on 16/3/9.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "TeamWorkCityViewController.h"
#import "DownloadManager.h"
@interface TeamWorkCityViewController ()
{
    NSArray *dicArray;
    NSString *databasePath;
    int a;
}
@end

@implementation TeamWorkCityViewController

-(void)viewWillAppear:(BOOL)animated
{
    DownloadManager *_download = [[DownloadManager alloc]init];
    
    NSDictionary *_dict = @{@"t":@"0"};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CITY_JK dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    a=0;
    [self cityLayout];
    
    // [self ck];
    // Do any additional setup after loading the view.
}
-(void)cityLayout
{
    
}
-(void)logDowLoadFinish:(id)sender
{
    [self.cityTableView removeFromSuperview];
    [dicArray reverseObjectEnumerator];
    dicArray=[sender objectForKey:@"data"];
    _cityTableView=[[UITableView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    _cityTableView.dataSource=self;
    _cityTableView.delegate=self;
    [self.view addSubview:_cityTableView];
    for (int i = 0; i<dicArray.count; i++) {
        NSLog(@"langArray[%d]=%@", i, dicArray[i]);
    }
    NSLog(@"字典个数 %lu",(unsigned long)dicArray.count);
    //[self dismissViewControllerAnimated:YES completion:nil];
}
-(void)DownFail:(id)sender
{
    NSLog(@"erroe is %@",sender);
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
    NSLog(@"indexpath.row%ld",(long)indexPath.row);
    NSLog(@"cell数据%d",a);
    a+=1;
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
        
        //        UILabel *cityLabel=[[UILabel alloc]initWithFrame:FRAME(0, 15, WIDTH, cell.frame.size.height-30)];
        //        cityLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        //        cityLabel.font=[UIFont fontWithName:@"Heiti SC" size:20];
        //        cityLabel.textAlignment=NSTextAlignmentCenter;
        //        [cell addSubview:cityLabel];
        cell.textLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _ctiyString=[dicArray[indexPath.row] objectForKey:@"name"];
    _addCityID=[dicArray[indexPath.row]objectForKey:@"city_id"];
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
