//
//  UsedDressViewController.m
//  simi
//
//  Created by zrj on 14-11-13.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "UsedDressViewController.h"
#import "ChoiceDefine.h"
#import "DressCell.h"
#import "addressViewController.h"
#import "DownloadManager.h"
#import "MBProgressHUD+Add.h"
#import "ISLoginManager.h"
#import "BaiduMobStat.h"
#import "UserDressMapViewController.h"
@interface UsedDressViewController ()<UITableViewDelegate,UITableViewDataSource,DressDelegate>
{
    UITableView *_mytableView;
    NSMutableArray *dataArray;
    UIButton *editButon;
    NSString *cyDress;         // 常用地址
    ISLoginManager *islog;
    NSInteger addrsssID;
}
@end

@implementation UsedDressViewController
@synthesize delegate = _delegate,Cname;
-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"地址管理", nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
    [_mytableView setEditing:NO animated:YES];
    [editButon setTitle:@"编辑" forState:UIControlStateNormal];
    
    NSArray *visiblecells = [_mytableView visibleCells];
    for(UITableViewCell *cell in visiblecells)
    {
        for (UIView *view in cell.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                if(view.tag == 500)
                {
                    UILabel *lab = (UILabel *)view;
                    
                    lab.frame  = FRAME(16, 5, 320-82, 50);
                    
                }
                
            }
        }
    }
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [self GetDataDress];
}
-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"地址管理", nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navlabel.text = @"地址管理";
    islog = [[ISLoginManager alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddDressWithData:) name:@"ADDDRESS_SUCCESS" object:nil];
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    UIButton *bttn = [UIButton buttonWithType:UIButtonTypeCustom];
    bttn.frame = FRAME(14, SELF_VIEW_HEIGHT-14-41, WIDTH-28, 41);
    bttn.layer.cornerRadius=5;
    [bttn setBackgroundColor:HEX_TO_UICOLOR(TEXT_COLOR, 1.0)];
    [bttn setTitle:@"添加一个新地址" forState:UIControlStateNormal];
    [bttn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bttn addTarget:self action:@selector(dressAction) forControlEvents:UIControlEventTouchUpInside];
//    [bttn.layer setCornerRadius:5.0];//设置矩形四个圆角半径
    [self.view addSubview:bttn];
    
    [self makeMytableview];
    
    [self getMyDresslist];
    
    
}
- (void)makeMytableview
{
    _mytableView = [[UITableView alloc]initWithFrame:FRAME(0, 64+10, SELF_VIEW_WIDTH, _HEIGHT-64-10-54-24) style:UITableViewStylePlain];
    _mytableView.delegate = self;
    _mytableView.dataSource = self;
    _mytableView.backgroundColor = DEFAULT_COLOR;
    _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_mytableView setEditing:NO];

    [self.view addSubview:_mytableView];
}

#pragma mark 获取地址
- (void)getMyDresslist
{
    [self performSelectorInBackground:@selector(GetDataDress) withObject:nil];
}
- (void)xiaoqu:(NSString *)xiaoqu menpai:(NSString *)menpaihao dressId:(NSString *)C_id
{
    [self GetDataDress];
    [_mytableView reloadData];
}
- (void)GetDataDress
{
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict = @{@"user_id":islog.telephone};
    
    [_download requestWithUrl:MY_DRESSLIST dict:_dict view:self.view delegate:self finishedSEL:@selector(GetDressListSucess:) isPost:NO failedSEL:@selector(DownloadFail:)];

}

#pragma mark 获得地址列表成功
- (void)GetDressListSucess:(id)responsobject
{
    [dataArray removeAllObjects];
    NSLog(@"object is %@",responsobject);
    CUSTOMDRESSBaseClass *_base = [[CUSTOMDRESSBaseClass alloc]initWithDictionary:responsobject];
    for (int i = 0; i < _base.data.count; i ++) {

    [dataArray addObject:[_base.data objectAtIndex:i]];
        
    }
    [_mytableView reloadData];
}

#pragma mark 下载失败
- (void)DownloadFail:(id)error
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (dataArray.count > 10) ? 10 : dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108/2;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    DressCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    
    if (cell == nil)
    {
        cell = [[DressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    
    CUSTOMDRESSData *mydata = (CUSTOMDRESSData *)[dataArray objectAtIndex:indexPath.row];
    cell.nameLabel.text =  [NSString stringWithFormat:@"%@%@",mydata.name,mydata.addr];
    cell.nameLabel.tag = 500;
    cell.textLabel.font = MYFONT(13.5);
    cell.btn.tag = indexPath.row+1000;
    cell.tag = indexPath.row;
    if(mydata.isDefault == 1){
        cell.btn.hidden = NO;
        _ctiyString=cell.nameLabel.text;
        int a=(int)mydata.dataIdentifier;
        _addCityID=[NSString stringWithFormat:@"%d",a];
    }else{
        cell.btn.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CUSTOMDRESSData *_data = (CUSTOMDRESSData *)[dataArray objectAtIndex:indexPath.row];
    addrsssID=indexPath.row;
    if ([Cname isEqualToString:@"服务项"]) {
        
        NSLog(@"data : %@",_data);
        NSLog(@"cellname ： %@  门牌：%@  id:%.f",_data.cellname,_data.addr,_data.dataIdentifier);
        [self.delegate GetDressCellname:_data.cellname menapi:_data.addr DressId:_data.dataIdentifier cityID:_data.cityId];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSLog(@"dataArray = %@",dataArray);
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *_dict = @{@"user_id":islog.telephone,
                                @"addr_id":[NSString stringWithFormat:@"%.f",_data.dataIdentifier],
                                @"poi_type":[NSString stringWithFormat:@"%i",_data.poi_type],
                                @"name":_data.name,
                                @"address":_data.address,
                                @"latitude":_data.latitude,
                                @"longitude":_data.longitude,
                                @"city":_data.city,
                                @"uid":_data.uid,
                                
                                
                                @"city_id":[NSString stringWithFormat:@"%.f",_data.cityId],
                                @"cell_id":[NSString stringWithFormat:@"0"],
                                @"addr":_data.addr,
                                @"is_default":@"1",};
        NSLog(@"_dict = %@,%@,%@",_data.name,_data.address,_data.city);
        
        [_download requestWithUrl:ADDRESS_ADDCHANGE dict:_dict view:self.view delegate:self finishedSEL:@selector(DownLoadSucess:) isPost:YES failedSEL:@selector(DownloadFail:)];

        NSArray *visiblecells = [_mytableView visibleCells];
        for(UITableViewCell *cell in visiblecells)
        {
            for (UIView *view in cell.subviews) {
                if ([view isKindOfClass:[UIButton class]]) {
                    if(view.tag == indexPath.row+1000)
                    {
                        UIButton *butn = (UIButton *)view;
                        
                        butn.hidden = NO;
                        
                    }else{
                        UIButton *butn = (UIButton *)view;
                        
                        butn.hidden = YES;
                    }

                }
            }
        }
    }


}
- (void) DownLoadSucess:(id)dict
{
    NSLog(@"%@",dict);
    int status = [[dict objectForKey:@"status"] intValue];
    if (status == 0) {
        
        [self getMyDresslist];
        NSDictionary *dic=[dict objectForKey:@"data"];
        _ctiyString=[NSString stringWithFormat:@"%@%@",[dic objectForKey:@"name"],[dic objectForKey:@"addr"]];
        _addCityID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        //[MBProgressHUD showSuccess:@"设置常用地址成功" toView:self.view];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {


    if(_mytableView.editing){
        [_mytableView setEditing:NO animated:YES];
        [editButon setTitle:@"编辑" forState:UIControlStateNormal];
        
        NSArray *visiblecells = [_mytableView visibleCells];
        for(UITableViewCell *cell in visiblecells)
        {
            for (UIView *view in cell.subviews) {
                if ([view isKindOfClass:[UILabel class]]) {
                    if(view.tag == 500)
                    {
                        UILabel *lab = (UILabel *)view;
                        
                        lab.frame  = FRAME(16, 5, 320-82, 50);
                        
                    }
                    
                }
            }
        }
        
    }
    else {
        [_mytableView setEditing:YES animated:YES];
        [editButon setTitle:@"完成" forState:UIControlStateNormal];
        
        NSArray *visiblecells = [_mytableView visibleCells];
        for(UITableViewCell *cell in visiblecells)
        {
            for (UIView *view in cell.subviews) {
                if ([view isKindOfClass:[UILabel class]]) {
                    if(view.tag == 500)
                    {
                        UILabel *lab = (UILabel *)view;
                        
                        lab.frame  = FRAME(50, 5, 320-82, 50);
                        
                    }
                    
                }
            }
        }
        
    }
    [_mytableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];


}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//单元格返回的编辑风格，包括删除 添加 和 默认  和不可编辑三种风格
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
//完成编辑的触发事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
//        [dataArray removeObjectAtIndex: indexPath.row];
        //        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
        //                         withRowAnimation:UITableViewRowAnimationFade];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                         withRowAnimation:UITableViewRowAnimationFade];
        
        
        
        CUSTOMDRESSData *_data = (CUSTOMDRESSData *)[dataArray objectAtIndex:indexPath.row];
        NSLog(@"index.row %ld",(long)indexPath.row);
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *_dict = @{@"user_id" : islog.telephone,
                                @"addr_id": [NSString stringWithFormat:@"%.f",_data.dataIdentifier]};
        
        NSLog(@"_dict = %@",_dict);
        
        [_download requestWithUrl:DELETE_ADDRESS dict:_dict view:self.view delegate:self finishedSEL:@selector(DownLoadSucessTo:) isPost:YES failedSEL:@selector(DownloadFailTo:)];
        [dataArray removeObjectAtIndex:indexPath.row];
    }
}
- (void) DownLoadSucessTo:(id)dict
{
    NSLog(@"dict   %@",dict );
    int status = [[dict objectForKey:@"status"] intValue];
    if (status == 0) {
        [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
       
        [_mytableView reloadData];
    }
    
}
- (void) DownloadFailTo:(id)error
{
    NSLog(@" erroor   %@",error);
}
- (void)dressAction
{
    UserDressMapViewController *userDress = [[UserDressMapViewController alloc]init];
    [self.navigationController pushViewController:userDress animated:YES];
//    addressViewController *dress = [[addressViewController alloc]init];
//    dress.delegate = self;
//    [self.navigationController pushViewController:dress animated:YES];
}
- (void)AddDressWithData:(NSNotification *)noti
{
    [dataArray insertObject:noti.object atIndex:0];
    [_mytableView reloadData];
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
