//
//  ListViewController.m
//  simi
//
//  Created by 白玉林 on 15/9/4.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "ListViewController.h"
#import "ISLoginManager.h"
#import "DownloadManager.h"
@interface ListViewController ()
{
    NSMutableArray *dataSoureArray;
}

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog( @"数组数据%@",_hyArray);
    self.navlabel.text=@"通讯录";
    dataSoureArray=[[NSMutableArray alloc]init];
        NSLog( @"数组数据%@",dataSoureArray);
    [self tableViewLayout];
    // Do any additional setup after loading the view.
}
-(void)tableViewLayout
{
    [dataSoureArray reverseObjectEnumerator];
    [_tableView removeFromSuperview];
    NSString *arrayString=[NSString stringWithFormat:@"%@",_hyArray];
    if ([arrayString isEqualToString:@""]) {
        
    }else{
        for (int i=0; i<_hyArray.count; i++) {
            NSDictionary *dic=_hyArray[i];
            NSString *name=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
            [dataSoureArray addObject:name];
        }
    }
    

    _tableView=[[UITableView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic=_dataArray[indexPath.row];
    //    NSString *string=[array objectAtIndex:indexPath.row];
    UIImageView *headImage=[[UIImageView alloc]init];
    UILabel *textLabel=[[UILabel alloc]init];
    UIButton *addButton=[[UIButton alloc]init];
    NSString *identifier = [NSString stringWithFormat:@"（%ld,%ld)",(long)indexPath.row,(long)indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        headImage.frame=FRAME(10, 10, 40, 40);
        headImage.layer.cornerRadius=headImage.frame.size.width/2;
        headImage.clipsToBounds = YES;
        [cell addSubview:headImage];
        textLabel.frame=FRAME(60, 20, WIDTH-140, 20);
        [cell addSubview:textLabel];
        addButton.frame=FRAME(WIDTH-80, 10, 60, 30);
        addButton.tag=indexPath.row;
//        [addButton setTitle:@"加好友" forState:UIControlStateNormal];
        UILabel *label=[[UILabel alloc]initWithFrame:FRAME(0, 5, 60, 20)];
        label.font=[UIFont fontWithName:@"Arial" size:15];
        label.textColor=[UIColor whiteColor];
        label.text=@"加好友";
        label.textAlignment=NSTextAlignmentCenter;
        [addButton addSubview:label];
        addButton.layer.cornerRadius=8;
        [addButton addTarget:self action:@selector(addButtonActiob:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:addButton];
    }
    if([dic objectForKey:@"image"]) {
        headImage.image = [dic objectForKey:@"image"];
    }
    textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    NSString *nameString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
//    NSLog(@"%@",dataSoureArray);
//    int judag=0;
//    for (int i=0; i<dataSoureArray.count; i++) {
//        NSString *string=[NSString stringWithFormat:@"%@",dataSoureArray[i]];
//        NSLog(@"两个字符串的值%@,%@",nameString,string);
//        if ([nameString isEqualToString:string]) {
//            judag=1;
//            break;
//        }else
//        {
//            judag=0;
//        }
//    }
    if ([dataSoureArray containsObject:nameString]) {
        addButton.enabled = FALSE;
        addButton.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    }else{
        addButton.enabled = TRUE;
        addButton.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}
-(void)addButtonActiob:(UIButton *)sender
{
    NSDictionary *dic=_dataArray[sender.tag];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *user_ID=_manager.telephone;
    NSString *name=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    NSString *mobile=[NSString stringWithFormat:@"%@",[dic objectForKey:@"phone"]];
    NSDictionary *_dict = @{@"user_id":user_ID,@"name":name,@"mobile":mobile};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:USER_TJHY dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:YES failedSEL:@selector(DownFail:)];
}
-(void)logDowLoadFinish:(id)sender
{
    NSLog(@"添加成功");
    ISLoginManager *_manager = [ISLoginManager shareManager];
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *user_ID=_manager.telephone;
    NSDictionary *_dict = @{@"user_id":user_ID};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:USER_HYLB dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadFhaoyou:) isPost:NO failedSEL:@selector(haoyouDownFail:)];
}
-(void)DownFail:(id)sender
{
    NSLog(@"添加失败");
}

-(void)logDowLoadFhaoyou:(id)sender
{
    NSLog(@"获取成功%@",sender);
    
    [_hyArray reverseObjectEnumerator];
    _hyArray=[sender objectForKey:@"data"];
    [self tableViewLayout];
    
}
-(void)haoyouDownFail:(id)sender
{
    NSLog(@"获取失败");
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
