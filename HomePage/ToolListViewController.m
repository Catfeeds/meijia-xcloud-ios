//
//  ToolListViewController.m
//  yxz
//
//  Created by 白玉林 on 16/6/7.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "ToolListViewController.h"

@interface ToolListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *myTableView;
    NSArray *dataArray;
}
@end

@implementation ToolListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navlabel.text=@"常用工具";
    myTableView =[[UITableView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    myTableView.dataSource=self;
    myTableView.delegate=self;
    myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
//    dataArray=@[@"社保基金计算器",@"个人所得税计算器",@"税前税后工资计算器",@"最新社保基数查询"];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self lodLayout];
}
-(void)lodLayout
{
//    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *dic=@{@"setting_type":@"common-tools"};
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",TOOL_ROMM] dict:dic view:self.view delegate:self finishedSEL:@selector(ToolSuccess:) isPost:NO failedSEL:@selector(ToolFail:)];
}
-(void)ToolSuccess:(id)source
{
    dataArray=[source objectForKey:@"data"];
    [myTableView reloadData];
}
-(void)ToolFail:(id)source
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic=dataArray[indexPath.row];
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    cell.textLabel.font=[UIFont fontWithName:@"" size:15];
    UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 40, WIDTH, 1)];
    view.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    [cell addSubview:view];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-30, 10, 20, 20)];
    imageView.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
    [cell addSubview:imageView];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 41;
}
#pragma mark 列表点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=dataArray[indexPath.row];
    [myTableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row==0) {
        
        WebPageViewController *webPageVC=[[WebPageViewController alloc]init];
        webPageVC.barIDS=100;
        webPageVC.webURL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"setting_json"]];
        [self.navigationController pushViewController:webPageVC animated:YES];
    }
 
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
