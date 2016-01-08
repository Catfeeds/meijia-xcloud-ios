//
//  JifenViewController.m
//  simi
//
//  Created by 赵中杰 on 14/12/11.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "JifenViewController.h"
#import "JifenView.h"
#import "DownloadManager.h"

#import "HowGetViewController.h"
#import "JIFENBaseClass.h"
#import "JIFENData.h"
#import "DuiHuanTableViewCell.h"
#import "MingxiTableViewCell.h"
#import "ISLoginManager.h"
#import "LoadMoreCell.h"

@interface JifenViewController ()
<
UITableViewDataSource,UITableViewDelegate,JIFENDELEGATE,DUIHUANDELEGATE,LOADMOREDELAGATE
>
{
    UITableView *_mytableview;
    BOOL isMingxi;
    JIFENBaseClass *_base;
    JifenView *_jifenview;
    NSMutableArray *_listArray;
    DownloadManager *_download;
    ISLoginManager *_manager;
    
    NSString *_pagenum;
}

@end

@implementation JifenViewController
@synthesize jifenstring = _jifenstring;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isMingxi = NO;
    
    _pagenum = @"1";
    
    self.navlabel.text = @"我的积分";
    
    _listArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    _jifenview = [[JifenView alloc]initWithFrame:FRAME(0, 64, _WIDTH, 126)];
    _jifenview.delegate = self;
    [self.view addSubview:_jifenview];
    
    
    
    _mytableview = [[UITableView alloc]initWithFrame:FRAME(0, 64+126, _WIDTH, _HEIGHT-64-126)];
    _mytableview.delegate = self;
    _mytableview.dataSource = self;
    _mytableview.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_mytableview];
    
    _manager = [ISLoginManager shareManager];
    
    _download = [[DownloadManager alloc]init];
    
    [self downloadWithPage:@"1"];
    
     _jifenview.jifennum = self.jifenstring;
}

#pragma mark 加载更多
- (void)loadMoreOrder
{
    
    if (_base.status == 999) {
        [self showAlertViewWithTitle:@"提示" message:@"没有更多数据了"];
    }else{
        _pagenum = [NSString stringWithFormat:@"%d",[_pagenum intValue]+1];
        [self downloadWithPage:_pagenum];
    }
    
}

- (void)downloadWithPage:(NSString *)pagestr
{
    NSDictionary *_dict = @{@"user_id":_manager.telephone,@"page":pagestr};
    [_download requestWithUrl:JIFEN_MINGXI dict:_dict view:self.view delegate:self finishedSEL:@selector(DoenloadFinish:) isPost:NO failedSEL:@selector(DownloadFail:)];
    
}


#pragma mark 下载成功
- (void)DoenloadFinish:(id)responsobject
{
    _base = [[JIFENBaseClass alloc]initWithDictionary:responsobject];
    
    if (_base.status == 0) {
        
        for (int i = 0; i < _base.data.count; i ++) {
            [_listArray addObject:[_base.data objectAtIndex:i]];
        }
        
    }else{
        
    }
    
   
    
    if (isMingxi) {
        [_mytableview reloadData];
        
    }
}

- (void)DownloadFail:(id)error
{


}


#pragma mark 积分兑换明晰切换
- (void)JifenMingxiOrDuihuan:(NSString *)name
{
    if ([name isEqualToString:@"mingxi"]) {
        isMingxi = YES;
    }else{
        isMingxi = NO;
    }
    
    [_mytableview reloadData];
    
}


- (void)GetJifenBtn
{
    HowGetViewController *_controller = [[HowGetViewController alloc]init];
    [self.navigationController pushViewController:_controller animated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isMingxi) {
        return _listArray.count+1;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (isMingxi) {
        return 54;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (isMingxi) {
        
        UIView *_headerview = [[UIView alloc]initWithFrame:FRAME(0, 0, _WIDTH, 54)];
        _headerview.backgroundColor = COLOR_VAULE(255.0);
        
        NSArray *_headdArr = @[@"详情",@"积分",@"时间"];
        for (int i = 0; i < 3; i ++) {
            UILabel *_label = [[UILabel alloc]initWithFrame:FRAME(18+(_WIDTH-120+56)*0.5*i, 0, 28, 54)];
            _label.font = MYFONT(13.5);
            _label.textColor = COLOR_VAULE(187.0);
            _label.text = [_headdArr objectAtIndex:i];
            [_headerview addSubview:_label];
            
        }
        
        return _headerview;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isMingxi) {
        
        if (indexPath.row == _listArray.count) {
            static NSString *CellIdentifier = @"MoreTableViewCellId";
            LoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell){
                cell = [[LoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.delegate = self;
            cell.orderCount = _base.status;
            return cell;
            
        }else{
            
            NSString *cellId = @"MingxiCellid";
            MingxiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil)
            {
                cell = [[MingxiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            cell.mydata = [_listArray objectAtIndex:indexPath.row];
            return cell;
            
            
        }
        
        
    }else{
        
        NSString *cellId = @"DuihuanCellid";
        
        DuiHuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (cell == nil)
        {
            cell = [[DuiHuanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.delegate = self;
        
        return cell;
    }
}






#pragma mark 兑换按钮点击
- (void)duihuananniuDIanji
{
    NSString *_cellphone = [[NSUserDefaults standardUserDefaults] objectForKey:@"telephone"];
    
    NSDictionary *_dict = @{@"user_id":_cellphone,@"exchange_id":@"0"};
    [_download requestWithUrl:JIFEN_DUIHUAN dict:_dict view:self.view delegate:self finishedSEL:@selector(DuihuanSuccess:) isPost:YES failedSEL:@selector(DownloadFail:)];
}

- (void)DuihuanSuccess:(id)object
{
    
    NSInteger _status = [[object objectForKey:@"status"] integerValue];
    
    if (_status == 0) {
        _jifenview.jifennum = [NSString stringWithFormat:@"%d",[self.jifenstring integerValue] - 100];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JIFEN_DUIHUAN100" object:@"100"];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"积分兑换成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
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
