//
//  JiaDianViewController.m
//  simi
//
//  Created by zrj on 14-11-11.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "JiaDianViewController.h"
#import "RemindView.h"
#import "JiaDianCell.h"
#import "ChoiceDefine.h"
#import "DetailCell.h"
#import "jiadianDetailViewController.h"

#import "SERVICEDatas.h"
#import "AppDelegate.h"
#import "BaiduMobStat.h"
#import "MBProgressHUD+Add.h"
#import "ChatViewController.h"
#import "LoginViewController.h"
#import "MyLogInViewController.h"
@interface JiaDianViewController ()<CallDelegate,appDelegate,JiadianDelegate>
{
    RemindView *remindView;
    NSMutableArray *titleArray;
    NSMutableArray *detailArray;
    NSMutableArray *array;
    NSMutableArray *dispriceArray;
}
@end

@implementation JiaDianViewController
@synthesize _mytableView,model;

-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"%@",model.name, nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"%@",model.name, nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navlabel.text = model.name;
    self.navigationController.navigationBarHidden = YES;
    SERVICEDatas *datas = [[SERVICEDatas alloc]init];
    
    titleArray = [[NSMutableArray alloc]init];
    detailArray = [[NSMutableArray alloc]init];
    dispriceArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<model.datas.count; i++) {
        datas = [model.datas objectAtIndex:i];
        
        [titleArray addObject:datas.name];
        [detailArray addObject:[NSString stringWithFormat:@"%.f",datas.disPrice]];
        [dispriceArray addObject:[NSString stringWithFormat:@"%.f",datas.disPrice]];
        
        
    }

    NSLog(@"detailArray = %@",detailArray);
    
    
    array = [[NSMutableArray alloc]init];
    
    remindView = [[RemindView alloc]initWithFrame:FRAME(0, NAV_HEIGHT, SELF_VIEW_WIDTH, (196+46)/2) labletext:model.tips];
    remindView.delegate = self;
    [self.view addSubview:remindView];

    _mytableView = [[UITableView alloc]initWithFrame:FRAME(0, 25+296/2+74/2, SELF_VIEW_WIDTH, SELF_VIEW_HEIGHT-(20+296/2+74/2)-28-59)];
    _mytableView.delegate = self;
    _mytableView.dataSource = self;
    _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_mytableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:_mytableView];
    
    UIButton *bttn = [UIButton buttonWithType:UIButtonTypeCustom];
    bttn.frame = FRAME(14, SELF_VIEW_HEIGHT-14-108/2, 584/2, 108/2);
    [bttn setBackgroundColor:HEX_TO_UICOLOR(ROUND_COLOR, 1.0)];
    [bttn setTitle:@"下一步" forState:UIControlStateNormal];
    [bttn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bttn addTarget:self action:@selector(NextAction) forControlEvents:UIControlEventTouchUpInside];
    [bttn.layer setCornerRadius:5.0];//设置矩形四个圆角半径
    [self.view addSubview:bttn];
    

    // Do any additional setup after loading the view.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108/2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    JiaDianCell *Cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (Cell == nil) {
        Cell = [[JiaDianCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    
    Cell.backgroundView = nil;
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Cell.delegate = self;
    Cell.youButn.tag = indexPath.row+100;
    Cell.youBtn.tag = indexPath.row+1000;
    Cell.titleLab.tag = indexPath.row+500;
    Cell.tag = indexPath.row;
    Cell.titleLab.text = [titleArray objectAtIndex:indexPath.row];
    Cell.DetailLab.text = [NSString stringWithFormat:@"%@元/台",[detailArray objectAtIndex:indexPath.row]];
    return Cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSArray *visiblecells = [_mytableView visibleCells];
    for(UITableViewCell *cell in visiblecells)
    {
        if (cell.tag == indexPath.row) {
            UIButton *button = (UIButton *)[cell viewWithTag:indexPath.row+100];
            if (button.hidden == YES) {
                button.hidden = NO;
                
                SERVICEDatas *datas = [model.datas objectAtIndex:cell.tag];
                NSString *select_type = [NSString stringWithFormat:@"%.f",datas.selectType];
                UILabel *lable = (UILabel *)[cell viewWithTag:cell.tag+500];
                NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
                [dic setObject:[NSString stringWithFormat:@"%@",lable.text] forKey:@"title"];
                [dic setObject:[dispriceArray objectAtIndex:cell.tag] forKey:@"price"];
                [dic setObject:[NSString stringWithFormat:@"%@",select_type] forKey:@"select_type"];
                if (array.count == 0) {
                    [array addObject:dic];
                    
                }
                else
                {
                    int hava=0;
                    for (int i=0; i<array.count; i++) {
                        NSDictionary *dic2=[array objectAtIndex:i];
                        if ([dic2[@"title"] isEqualToString:[NSString stringWithFormat:@"%@",lable.text]]) {
                            //                        [dic2 setValue:[NSString stringWithFormat:@"%d",[dic2[@"count"] intValue]+1]forKey:@"count"];
                            hava+=1;
                        }else{
                            hava+=0;
                        }
                    }
                    if (hava==0) {
                        [array addObject:dic];
                    }
                    
                }
            NSLog(@"array = %@",array);
                
            }
            else
            {
                button.hidden = YES;
                
                UILabel *lable = (UILabel *)[cell viewWithTag:cell.tag+500];
                NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                [dic setObject:[NSString stringWithFormat:@"%@",lable.text] forKey:@"title"];
                
                
                
                if (array.count==0) {
                    
                }else{
                    
                    for (int i=0; i<array.count; i++) {
                        NSDictionary *dic2=[array objectAtIndex:i];
                        if ([dic2[@"title"] isEqualToString:[NSString stringWithFormat:@"%@",lable.text]]) {
                            [array removeObject:dic2];
                        }
                    }
                    
                }
                
                
                NSLog(@"array = %@",array);

            }
        }


    }
    
}

- (void)duigouBtnAction:(UIButton *)sender
{
    NSArray *visiblecells = [_mytableView visibleCells];
    for(UITableViewCell *cell in visiblecells)
    {
        NSLog(@"cellTag= %ld",(long)cell.tag);
        if(sender.tag-1000 == cell.tag)
        {
            UIButton *button = (UIButton *)[cell viewWithTag:cell.tag+100];
            button.hidden = NO;
            
            SERVICEDatas *datas = [model.datas objectAtIndex:cell.tag];
            NSString *select_type = [NSString stringWithFormat:@"%.f",datas.selectType];
            UILabel *lable = (UILabel *)[cell viewWithTag:cell.tag+500];
            NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
            [dic setObject:[NSString stringWithFormat:@"%@",lable.text] forKey:@"title"];
            [dic setObject:[NSString stringWithFormat:@"%@",select_type] forKey:@"select_type"];
            [dic setObject:[dispriceArray objectAtIndex:cell.tag] forKey:@"price"];
            if (array.count == 0) {
                [array addObject:dic];
                
            }
            else
            {
                int hava=0;
                for (int i=0; i<array.count; i++) {
                    NSDictionary *dic2=[array objectAtIndex:i];
                    if ([dic2[@"title"] isEqualToString:[NSString stringWithFormat:@"%@",lable.text]]) {

                        hava+=1;
                    }else{
                        hava+=0;
                    }
                }
                if (hava==0) {
                    [array addObject:dic];
                }

            }
            
        }

        NSLog(@"array = %@",array);

    }
}
- (void)duigouHidden:(UIButton *)sender
{
    NSArray *visiblecells = [_mytableView visibleCells];
    for(UITableViewCell *cell in visiblecells)
    {
        NSLog(@"cellTag= %ld",(long)cell.tag);
        if(sender.tag-100 == cell.tag)
        {

            sender.hidden = YES;

            UILabel *lable = (UILabel *)[cell viewWithTag:cell.tag+500];
            NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
            [dic setObject:[NSString stringWithFormat:@"%@",lable.text] forKey:@"title"];
            
            
            
            if (array.count==0) {
                
            }else{
                
                for (int i=0; i<array.count; i++) {
                    NSDictionary *dic2=[array objectAtIndex:i];
                    if ([dic2[@"title"] isEqualToString:[NSString stringWithFormat:@"%@",lable.text]]) {
                        [array removeObject:dic2];
                    }
                }
                
            }

        
        NSLog(@"array = %@",array);

        }
        
        
    }
}

- (void)NextAction
{
    if(array.count == 0){
        [MBProgressHUD showError:@"请您至少添加一个要洗的家电" toView:self.view];
        return;
    }

    jiadianDetailViewController *detail = [[jiadianDetailViewController alloc]init];
    detail.qingdanArr = array;
    detail.tips = model.tips;
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark 打电话
#pragma mark 打电话
- (void)CallAction
{
    BOOL login = [self loginYesOrNo];
    if (login == YES) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"联系我们的客服专线" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        alert.tag = 30;
//        [alert show];
        [self CallTelephone];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 20;
        [alert show];
    }
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 20) {
        MyLogInViewController *log = [[MyLogInViewController alloc]init];
        log.vCLID=0;
        [self.navigationController presentViewController:log animated:YES completion:nil];
    }
}
- (void)CallTelephone
{
    
    
    BOOL login = [self loginYesOrNo];
    if (login == YES) {
        AppDelegate *app = [[AppDelegate alloc]init];
        app.deletate = self;
        [app huanxin];
    }
    else{
        //        [self showAlertViewWithTitle:@"提示" message:@"请先登陆"];
        UIAlertView *LogalertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        LogalertView.tag = 10;
        [LogalertView show];
    }
    
    
}
- (void)LoginFailNavpush
{
//    LoginViewController *log = [[LoginViewController alloc]init];
//    log.userName = APPLIACTION.huanxinBase.imUsername;;
//    log.password = APPLIACTION.huanxinBase.imUserPassword;
//    [self.navigationController pushViewController:log animated:YES];
//    [log loginWithUsername:APPLIACTION.huanxinBase.imUsername password:APPLIACTION.huanxinBase.imUserPassword];
    
}
- (void)LoginSuccessNavPush
{
    
    
    //判断是否真人聊天
    int senior = APPLIACTION.huanxinBase.is_senior;
    
    NSString *imToUserID;
    NSString *imToUsreName;
    
    if (senior == 1) {
        imToUserID = APPLIACTION.huanxinBase.im_senior_username;
        imToUsreName = APPLIACTION.huanxinBase.im_senior_nickname;
    }else{
        imToUserID = APPLIACTION.huanxinBase.im_robot_username;
        imToUsreName = APPLIACTION.huanxinBase.im_robot_nickname;
    }
    
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:imToUserID isGroup:NO];
    chatVC.title = imToUsreName;
    chatVC._baojie = APPLIACTION._baseSource.data.serviceTypes.baojie;
    chatVC._zuofan = APPLIACTION._baseSource.data.serviceTypes.zuofan;
    chatVC._xiyi = APPLIACTION._baseSource.data.serviceTypes.xiyi;
    chatVC._jiadian = APPLIACTION._baseSource.data.serviceTypes.jiadian;
    chatVC._caboli = APPLIACTION._baseSource.data.serviceTypes.caboli;
    chatVC._guandao = APPLIACTION._baseSource.data.serviceTypes.guandao;
    chatVC._xinju = APPLIACTION._baseSource.data.serviceTypes.xinju;
    chatVC.baseData = APPLIACTION.huanxinBase;
    [chatVC.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:chatVC animated:YES];
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
