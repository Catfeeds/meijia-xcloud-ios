//
//  AttendCompViewController.m
//  yxz
//
//  Created by 白玉林 on 16/1/14.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "AttendCompViewController.h"

@interface AttendCompViewController ()
{
    UITableView *myTableView;
    NSArray *companyArray;
    int  cellID;
}
@end

@implementation AttendCompViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    cellID=-1;
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSLog(@"有值么%@",_manager.telephone);
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict=@{@"user_id":_manager.telephone};
    [_download requestWithUrl:USER_ENTERPRISE dict:_dict view:self.view delegate:self finishedSEL:@selector(CompanySuccess:) isPost:NO failedSEL:@selector(CompanyFailure:)];
    
    [myTableView removeFromSuperview];
    myTableView =[[UITableView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    myTableView.dataSource=self;
    myTableView.delegate=self;
    [self.view addSubview:myTableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [myTableView setTableFooterView:v];
    // Do any additional setup after loading the view.
}
#pragma mark 用户所属企业列表成功返回
-(void)CompanySuccess:(id)sender
{
    NSLog(@"用户所属企业列表数据%@",sender);
    companyArray=[sender objectForKey:@"data"];
    [myTableView reloadData];
}
#pragma mark 用户所属企业列表失败返回
-(void)CompanyFailure:(id)sender
{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}



//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return companyArray.count;
}



//绘制Cell

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic=companyArray[indexPath.row];
    NSString *identifier = [NSString stringWithFormat:@"（%ld,%ld)",(long)indexPath.row,(long)indexPath.section];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    
    cell.textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"company_name"]];
    cell.textLabel.font=[UIFont fontWithName:@"Arial" size:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (cellID==indexPath.row) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    return cell;
}
//改变行的高度

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=companyArray[indexPath.row];
    cellID=(int)indexPath.row;
    [myTableView reloadData];
    _compNameString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"company_name"]];
    _compID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"company_id"]];
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
