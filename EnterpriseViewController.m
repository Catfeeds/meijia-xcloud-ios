//
//  EnterpriseViewController.m
//  yxz
//
//  Created by 白玉林 on 15/12/1.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "EnterpriseViewController.h"
#import "CompanyViewController.h"
#import "DefaultCompanyViewController.h"
@interface EnterpriseViewController ()
{
    UIActivityIndicatorView *view;
    UITableView *myTableView;
    NSArray *companyArray;
    CompanyViewController *companyVC;
    int djID;
    
    UIView *setupView;
    int  setupID;
    DropDown *dd1;
}
@end

@implementation EnterpriseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_webId==0) {
        self.navlabel.text=@"创建企业通讯录";
        [self webViewLayout];
    }else if (_webId==1){
        self.navlabel.text=@"企业通讯录";
        ISLoginManager *_manager = [ISLoginManager shareManager];
        NSLog(@"有值么%@",_manager.telephone);
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *_dict=@{@"user_id":_manager.telephone};
        [_download requestWithUrl:USER_ENTERPRISE dict:_dict view:self.view delegate:self finishedSEL:@selector(CompanySuccess:) isPost:NO failedSEL:@selector(CompanyFailure:)];
        [self tableViewLayout];
        UIButton *addBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH-60, 24, 50, 40)];
        [addBut setTitle:@"设置" forState:UIControlStateNormal];
        [addBut setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
        [addBut addTarget:self action:@selector(addButAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addBut];
    }
    
    dd1 = [[DropDown alloc] initWithFrame:CGRectMake(WIDTH-110, 54, 100, 100)];
    dd1.delegate=self;
    NSArray* arr=[[NSArray alloc]initWithObjects:@"创建公司",@"设置默认",nil];
    dd1.tableArray = arr;
    [self.view addSubview:dd1];
    
    // Do any additional setup after loading the view.
}
-(void)addButAction:(UIButton *)button
{

    [dd1 dropdown];
}
-(void)viewWillAppear:(BOOL)animated
{
    if (djID==100) {
        _mutableArrat=companyVC.mutableArray;
        _nameArray=companyVC.nameArray;
        _mobileArray=companyVC.mobileArray;
        _idArray=companyVC.idArray;
    }
}
-(void)pullDownAnimated:(int)open
{
    if (open==0) {
        WebPageViewController *webVC=[[WebPageViewController alloc]init];
        webVC.webURL=@"http://123.57.173.36/simi-h5/show/company-reg.html";
        [self.navigationController pushViewController:webVC animated:YES];
    }else{
        DefaultCompanyViewController *defVC=[[DefaultCompanyViewController alloc]init];
        [self.navigationController pushViewController:defVC animated:YES];
    }
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
-(void)webViewLayout
{
    UIWebView *meWebView= [[UIWebView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    meWebView.delegate=self;
    //self.meWebView.hidden=YES;
    meWebView.scrollView.delegate=self;
    [self.view addSubview:meWebView];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://123.57.173.36/simi-h5/show/company-reg.html"]];//http://123.57.173.36/simi-h5/show/company-reg.html
    //NSLog(@"gourl  =  %@",_imgurl);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [meWebView loadRequest:request];
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    view=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    view.center = CGPointMake(WIDTH/2, HEIGHT/2);
    [self.view addSubview:view];
    [view startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [view stopAnimating]; // 结束旋转
    [view setHidesWhenStopped:YES]; //当旋转结束时隐藏
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
    UIImageView *arrowImageView=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-30, 15, 20, 20)];
    arrowImageView.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
    [cell addSubview:arrowImageView];
    return cell;
}
//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    djID=100;
    NSDictionary *dic=companyArray[indexPath.row];
    _company_idStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"company_id"]];
    companyVC=[[CompanyViewController alloc]init];
    companyVC.vcIDs=_vcIDs;
    companyVC.companyDic=dic;
    companyVC.theNumber=_theNumber;
    companyVC.companyVcId=_enterVcID;
    companyVC.dataMutableArray=_mutableArrat;
    companyVC.dataNameArray=_nameArray;
    companyVC.dataMobileArray=_mobileArray;
    companyVC.dataIdArray=_idArray;
    companyVC.nameString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"company_name"]];
    [self.navigationController pushViewController:companyVC animated:YES];
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
