//
//  DefaultCompanyViewController.m
//  yxz
//
//  Created by 白玉林 on 16/3/14.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "DefaultCompanyViewController.h"

@interface DefaultCompanyViewController ()
{
    UITableView *myTableView;
    NSArray *companyArray;
    int cellID;
    NSString *company_id;
    UIAlertView *tsView;
}
@end

@implementation DefaultCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    cellID=-1;
    self.navlabel.text=@"企业通讯录";
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSLog(@"有值么%@",_manager.telephone);
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict=@{@"user_id":_manager.telephone};
    [_download requestWithUrl:USER_ENTERPRISE dict:_dict view:self.view delegate:self finishedSEL:@selector(CompanySuccess:) isPost:NO failedSEL:@selector(CompanyFailure:)];
    [self tableViewLayout];
    UIButton *defaultBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH-60, 20, 60, 44)];
    [defaultBut setTitle:@"保存" forState:UIControlStateNormal];
    [defaultBut setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
    [defaultBut addTarget:self action:@selector(defaultButAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:defaultBut];
    [self tableViewLayout];
    // Do any additional setup after loading the view.
}
-(void)defaultButAction:(UIButton *)button
{
    if (company_id==nil||company_id==NULL||[company_id isEqualToString:@""]) {
        tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"您还没有设置默认企业！" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [tsView show];
        [NSTimer scheduledTimerWithTimeInterval:2.0f
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:nil
                                        repeats:NO];
    }else{
        ISLoginManager *_manager = [ISLoginManager shareManager];
        NSLog(@"有值么%@",_manager.telephone);
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *_dict=@{@"user_id":_manager.telephone,@"company_id":company_id};
        [_download requestWithUrl:USER_DEFAULTCOMPANT dict:_dict view:self.view delegate:self finishedSEL:@selector(DefaultSuccess:) isPost:NO failedSEL:@selector(CompanyFailure:)];
    }
    
    
}
- (void)timerFireMethod:(NSTimer*)theTimer
{
    [tsView dismissWithClickedButtonIndex:[tsView cancelButtonIndex] animated:YES];
}
#pragma mark用户设置默认企业成功返回
-(void)DefaultSuccess:(id)source
{
    [self.navigationController popViewControllerAnimated:YES];
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
- (void)backAction
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSLog(@"有值么%@",_manager.telephone);
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict=@{@"user_id":_manager.telephone};
    [_download requestWithUrl:USER_INFO dict:_dict view:self.view delegate:self finishedSEL:@selector(QJDowLoadFinish:) isPost:NO failedSEL:@selector(QJDownFail:)];
}
#pragma mark用户信息详情获取成功方法
-(void)QJDowLoadFinish:(id)sender
{
    NSLog(@"数据详情%@",sender);
    NSDictionary *dic=[sender objectForKey:@"data"];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.globalDic=@{@"user_id":[dic objectForKey:@"id"],@"sec_id":[dic objectForKey:@"sec_id"],@"is_senior":[dic objectForKey:@"is_senior"],@"senior_range":[dic objectForKey:@"senior_range"],@"mobile":[dic objectForKey:@"mobile"],@"user_type":[dic objectForKey:@"user_type"],@"name":[dic objectForKey:@"name"],@"has_company":[dic objectForKey:@"has_company"],@"head_img":[dic objectForKey:@"head_img"],@"company_id":[dic objectForKey:@"company_id"],@"company_name":[dic objectForKey:@"company_name"]};
    NSLog(@"看看是什么啊%@",delegate.globalDic);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark用户信息详情获取失败方法
-(void)QJDownFail:(id)sender
{
}
#pragma mark 表格初始化方法
-(void)tableViewLayout
{
    [myTableView removeFromSuperview];
    myTableView =[[UITableView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    myTableView.dataSource=self;
    myTableView.delegate=self;
    [self.view addSubview:myTableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [myTableView setTableFooterView:v];
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
    //    NSString *string=[array objectAtIndex:indexPath.row];
    NSDictionary *dic=companyArray[indexPath.row];
    NSString *identifier = [NSString stringWithFormat:@"（%ld,%ld)",(long)indexPath.row,(long)indexPath.section];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"company_name"]];
    cell.textLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
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
    cellID=(int)indexPath.row;
    NSDictionary *dic=companyArray[indexPath.row];
    company_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"company_id"]];
    [myTableView reloadData];
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
