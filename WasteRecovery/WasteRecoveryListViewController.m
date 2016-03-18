//
//  WasteRecoveryListViewController.m
//  yxz
//
//  Created by 白玉林 on 16/3/4.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "WasteRecoveryListViewController.h"

@interface WasteRecoveryListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
    NSArray *dataSourceArray;
    int cellID;
}
@end

@implementation WasteRecoveryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _navlabel.textColor = [UIColor whiteColor];
    self.img.hidden=YES;
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 20, 20)];
    img.image = [UIImage imageNamed:@"iconfont-p-back"];
    [_backBtn addSubview:img];
    if (_listID==100) {
        self.backlable.backgroundColor=HEX_TO_UICOLOR(0x11cd6e, 1.0);
        dataSourceArray=@[@"日常办公垃圾",@"废旧电器",@"硒鼓墨盒",@"其他"];
    }else if (_listID==101){
        dataSourceArray=@[@"定期保洁",@"深度养护",@"维修清洗",@"其他"];
        self.backlable.backgroundColor=HEX_TO_UICOLOR(0x56abe4, 1.0);
    }else if (_listID==102){
        dataSourceArray=@[@"不限",@"年会",@"拓展培训",@"聚会沙龙",@"度假休闲",@"其他"];
        self.backlable.backgroundColor=HEX_TO_UICOLOR(0xea8010, 1.0);
    }
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
    return dataSourceArray.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    UITableViewCell *Cell = [tableView cellForRowAtIndexPath:indexPath];
    if (Cell == nil) {
        Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:FRAME(30, 15, WIDTH-60, 20)];
    moneyLabel.font=[UIFont fontWithName:@"Arial" size:15];
    moneyLabel.text=[NSString stringWithFormat:@"%@",dataSourceArray[indexPath.row]];
    [Cell addSubview:moneyLabel];
    if (cellID==indexPath.row) {
        [Cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    return Cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [myTableView deselectRowAtIndexPath:indexPath animated:NO];
    cellID=(int)indexPath.row;
    _waterString=[NSString stringWithFormat:@"%@",dataSourceArray[indexPath.row]];
    _waterID=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
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
