//
//  WaterOrderListViewController.m
//  yxz
//
//  Created by 白玉林 on 16/3/2.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "WaterOrderListViewController.h"

@interface WaterOrderListViewController ()
{
    UITableView *myTableView;
    NSArray *dataSourceArray;
    int cellID;
}
@end

@implementation WaterOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    cellID=-1;
    self.navlabel.text=@"选择产品";
    [self tableViewLayout];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self defaultInterfaceLayout];
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
-(void)defaultInterfaceLayout
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    
    NSDictionary *_dict = @{@"user_id":_manager.telephone,@"service_type_id":@"239"};
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",WATER_GOODS_LIST] dict:_dict view:self.view delegate:self finishedSEL:@selector(addDressSuccess:) isPost:NO failedSEL:@selector(addDressFail:)];
    
}
#pragma mark默认班次数据成功方法
-(void)addDressSuccess:(id)source
{
    NSLog(@"默认班次数据:%@",source);
    NSString *string=[NSString stringWithFormat:@"%@",[source objectForKey:@"data"]];
    if (string==nil||string==NULL||[string isEqualToString:@"\n"]) {
        
    }else{
        dataSourceArray=[source objectForKey:@"data"];
        [myTableView reloadData];
    }
    
}
#pragma mark默认班次数据失败方法
-(void)addDressFail:(id)source
{
    NSLog(@"默认班次数据失败:%@",source);
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
    return 120;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=dataSourceArray[indexPath.row];
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    UITableViewCell *Cell = [tableView cellForRowAtIndexPath:indexPath];
    if (Cell == nil) {
        Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME(20, 25, 70, 70)];
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"img_url"]];
    [imageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];;
    [Cell addSubview:imageView];
    
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:FRAME(imageView.frame.size.width+30, 30, WIDTH-(imageView.frame.size.width+50), 20)];
    moneyLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    moneyLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    [Cell addSubview:moneyLabel];
    
    UILabel *stateLabel=[[UILabel alloc]init];
    stateLabel.text=[NSString stringWithFormat:@"原价%@元/桶，折扣价%@元/桶",[dic objectForKey:@"price"],[dic objectForKey:@"dis_price"]];
    [stateLabel setNumberOfLines:0];
    stateLabel.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil];
    CGSize size = [stateLabel.text boundingRectWithSize:CGSizeMake(WIDTH-20, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    stateLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    stateLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
    stateLabel.frame =FRAME(moneyLabel.frame.origin.x, 70, moneyLabel.frame.size.width, size.height);
    [Cell addSubview:stateLabel];
    if (cellID==indexPath.row) {
        [Cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    return Cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=dataSourceArray[indexPath.row];
    [myTableView deselectRowAtIndexPath:indexPath animated:NO];
    cellID=(int)indexPath.row;
    _waterString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    _moneyString=[NSString stringWithFormat:@"原价%@元/桶，折扣价%@元/桶",[dic objectForKey:@"price"],[dic objectForKey:@"dis_price"]];
    _service_price_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_price_id"]];
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
