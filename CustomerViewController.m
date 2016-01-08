//
//  CustomerViewController.m
//  yxz
//
//  Created by 白玉林 on 15/10/15.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "CustomerViewController.h"
#import "ISLoginManager.h"
#import "DownloadManager.h"
@interface CustomerViewController ()
{
    UITableView *clientView;
    NSArray *clientArray;
    NSDictionary *diction;
    
}
@end

@implementation CustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"是多少啊？？？？%ld",(long)_index);
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSLog(@"有值么%@",_manager.telephone);
    DownloadManager *_download = [[DownloadManager alloc]init];
    
    NSDictionary *_dict = @{@"sec_id":_manager.telephone};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:SEEK_YHLB dict:_dict view:self.view delegate:self finishedSEL:@selector(MSyhgm:) isPost:NO failedSEL:@selector(Doyhwnmsgm:)];
    
    NSDictionary *dict = @{@"user_id":_manager.telephone};
    NSLog(@"字典数据%@",dict);
    [_download requestWithUrl:USER_INFO dict:dict view:self.view delegate:self finishedSEL:@selector(msgm:) isPost:NO failedSEL:@selector(Downmsgm:)];
    // Do any additional setup after loading the view.
}
-(void)msgm:(id)sender
{
    NSLog(@"用户数据:%@",sender);
    diction=[sender objectForKey:@"data"];
    
}
-(void)Downmsgm:(id)sender
{
    
}

//秘书获取客户列表成功方法
-(void)MSyhgm:(id)sender
{
    NSLog(@"秘书客户列表%@",sender);
    clientArray=[sender objectForKey:@"data"];
    [clientView removeFromSuperview];
    clientView=[[UITableView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    clientView.backgroundColor=[UIColor whiteColor];
    clientView.dataSource=self;
    clientView.delegate=self;
    clientView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:clientView];
    
}
//秘书获取客户列表失败方法
-(void)Doyhwnmsgm:(id)sender
{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    
    return clientArray.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic;
    if (indexPath.row==0){
    }else{
       dic=clientArray[indexPath.row-1];
    }
    
    static NSString *identifier = @"cell";
    UILabel *cellLabel=[[UILabel alloc]init];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
        cellLabel.frame=FRAME(10, 10, WIDTH*0.45-30, 20);
        [cell addSubview:cellLabel];
    }
    if (indexPath.row==0) {
        cellLabel.text=@"自己";
    }else{
        cellLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    }
    
    cellLabel.font=[UIFont fontWithName:@"Arial" size:14];
    if (indexPath.row==_index) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}
// 选中操作
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        _clientString=[NSString stringWithFormat:@"%@",[diction objectForKey:@"user_id"]];
        _nameString=@"自己";
    }else{
        NSDictionary *dic=clientArray[indexPath.row-1];
        _clientString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"user_id"]];
        _nameString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 取消前一个选中的，就是单选啦
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_cellIndex inSection:0];
    UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:lastIndex];
    lastCell.accessoryType = UITableViewCellAccessoryNone;
    
    // 选中操作
    UITableViewCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    // 保存选中的
    _cellIndex = indexPath.row;
    [clientView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath afterDelay:.5];
    //[self.navigationController popViewControllerAnimated:YES];
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
