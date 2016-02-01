//
//  XiYiViewController.m
//  simi
//
//  Created by zrj on 14-11-4.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "XiYiViewController.h"
#import "ChoiceDefine.h"
#import "RemindView.h"
#import "XiYiCell.h"
#import "XiyiDetailViewController.h"
#import "XiyiThirdViewController.h"
#import "SERVICEDatas.h"
#import "AppDelegate.h"
#import "BaiduMobStat.h"
#import "MBProgressHUD+Add.h"
//#import "MyLogInViewController.h"
#import "LoginViewController.h"
#import "ChatViewController.h"
@interface XiYiViewController () <cellDelegate,CallDelegate,appDelegate>
{
    RemindView *remindView;
    NSMutableArray *titleArray;
    NSMutableArray *secondArray;
    NSMutableArray *thirdArray;
    NSMutableArray *arr;
    
}
@end

@implementation XiYiViewController
@synthesize myTableView,model;
#pragma mark - View lifecycle

-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"%@",  model.name, nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"%@", model.name, nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.navlabel.text = model.name;
    arr =  [[NSMutableArray alloc]init];
    remindView = [[RemindView alloc]initWithFrame:FRAME(0, NAV_HEIGHT, SELF_VIEW_WIDTH, (196+46)/2) labletext:model.tips];
    remindView.delegate = self;
    [self.view addSubview:remindView];
    
    myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 20+296/2+74/2+5, SELF_VIEW_WIDTH, SELF_VIEW_HEIGHT-(20+296/2+74/2)-28-59)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:myTableView];
    
    titleArray = [[NSMutableArray alloc]init];
    secondArray = [[NSMutableArray alloc]init];
    titleArray = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < model.datas.count; i ++) {
        SERVICEDatas *datas = [model.datas objectAtIndex:i];
        [titleArray addObject:datas.name];
        [secondArray addObject:[NSString stringWithFormat:@"%0.2f",datas.price]];
        [thirdArray addObject:[NSString stringWithFormat:@"%0.2f",datas.disPrice]];
    }
    NSLog(@"titlearray  = %@",titleArray);
    
    UIButton *bttn = [UIButton buttonWithType:UIButtonTypeCustom];
    bttn.frame = FRAME(14, SELF_VIEW_HEIGHT-14-108/2, 584/2, 108/2);
    [bttn setBackgroundColor:HEX_TO_UICOLOR(ROUND_COLOR, 1.0)];
    [bttn setTitle:@"下一步" forState:UIControlStateNormal];
    [bttn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bttn addTarget:self action:@selector(NextAction) forControlEvents:UIControlEventTouchUpInside];
    [bttn.layer setCornerRadius:5.0];//设置矩形四个圆角半径
    [self.view addSubview:bttn];
    
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
    XiYiCell *Cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (Cell == nil) {
        Cell = [[XiYiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    
    Cell.backgroundView = nil;
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    Cell.titleLab.text = [titleArray objectAtIndex:indexPath.row];
    
    SERVICEDatas *datas = [model.datas objectAtIndex:indexPath.row];

    Cell.titleLab.text = datas.name;
    Cell.shichangLab.text = [NSString stringWithFormat:@"市场价：%0.2f元/件",datas.price];
    Cell.youhuiLab.text = [NSString stringWithFormat:@"优惠价：%0.2f元/件",datas.disPrice];
    
    Cell.titleLab.tag = indexPath.row+200;
    Cell.shuziLab.tag = indexPath.row+100;
    Cell.zuoBtn.tag=indexPath.row+500;
    Cell.youBtn.tag=indexPath.row+1000;
    Cell.youhuiLab.tag = indexPath.row +2000;
    Cell.tag = [indexPath row];
    
    Cell.delegate = self;
    
    return Cell;
    
}

- (void)cellDelegate:(UIButton *)supsender
{
    NSArray *visiblecells = [myTableView visibleCells];
    for(UITableViewCell *cell in visiblecells)
    {
        if(cell.tag == supsender.tag-500)
        {
            NSLog(@"22222");
            
            UILabel *lab = (UILabel *)[cell viewWithTag:supsender.tag-400];  //数量lab
            UILabel *titlelab = (UILabel *)[cell viewWithTag:supsender.tag-300];
            UILabel *jiageLab = (UILabel *)[cell viewWithTag:cell.tag+2000];  //价格lab
            NSLog(@"价格:%@",jiageLab.text);
            NSLog(@"titleLable= %@",titlelab.text);
            NSLog(@"%@",lab.text);
            NSInteger b = [[NSString stringWithFormat:@"%@",lab.text]integerValue] ;
            b --;
            lab.text = [NSString stringWithFormat:@"%ld",(long)b];
            NSLog(@"b:===%ld",(long)b);
            UIButton *button = (UIButton *)[cell viewWithTag:cell.tag+1000];
//            UILabel *jiage = (UILabel *)[cell viewWithTag:cell.tag +2000];
            if (b <= 0) {
                [supsender setBackgroundImage:[UIImage imageNamed:@"sub"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"xiyiadd"] forState:UIControlStateNormal];
                lab.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
                lab.text = @"0";
                supsender.userInteractionEnabled = NO;
                
//                NSMutableDictionary *dic2=[[NSMutableDictionary alloc]init];
//                [dic2 setObject:[NSString stringWithFormat:@"%ld",(long)b] forKey:@"count"];
//                [dic2 setObject:[titleArray objectAtIndex:supsender.tag - 500] forKey:@"name"];
//                [dic2 setObject:[thirdArray objectAtIndex:cell.tag] forKey:@"money"];
                
                if (arr.count==0) {
                    
                }else{
                    
                    for (int i=0; i<arr.count; i++) {
                        NSDictionary *dic3=[arr objectAtIndex:i];
                        if ([dic3[@"name"] isEqualToString:[titleArray objectAtIndex:supsender.tag - 500]]) {
//                           [dic3 setValue:[NSString stringWithFormat:@"%d",[dic3[@"count"] intValue]-1]forKey:@"count"];
                            [arr removeObject:dic3];
                        }
                    }
                    
                }

                
            }
            else
            {
                [supsender setBackgroundImage:[UIImage imageNamed:@"sub_one"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"add_one"] forState:UIControlStateNormal];
                lab.textColor = HEX_TO_UICOLOR(NAV_COLOR, 1.0);
                supsender.userInteractionEnabled = YES;
                
//                NSMutableDictionary *dic2=[[NSMutableDictionary alloc]init];
//                [dic2 setObject:[NSString stringWithFormat:@"%ld",(long)b] forKey:@"count"];
//                [dic2 setObject:[titleArray objectAtIndex:supsender.tag - 500] forKey:@"name"];
//                [dic2 setObject:[thirdArray objectAtIndex:cell.tag] forKey:@"money"];
                
                if (arr.count==0) {
                    
                }else{
                    
                    for (int i=0; i<arr.count; i++) {
                         NSDictionary *dic3=[arr objectAtIndex:i];
                        
                        if ([dic3[@"name"] isEqualToString:[titleArray objectAtIndex:supsender.tag - 500]]) {
                            [dic3 setValue:[NSString stringWithFormat:@"%d",[dic3[@"count"] intValue]-1]forKey:@"count"];
                        }
                    }
                }

               
            }
            
            break;
        }
    }
     NSLog(@"dic=%@",arr);
}
-(void)cellDelegateTwo:(UIButton *)addsender
{
    NSArray *visiblecells = [myTableView visibleCells];
    for(UITableViewCell *cell in visiblecells)
    {
        if(cell.tag == addsender.tag - 1000)
        {
            NSLog(@"22222");
            
            UILabel *lab = (UILabel *)[cell viewWithTag:addsender.tag-900];  //数量lab
            NSLog(@"%@",lab.text);
//            UILabel *titlelab = (UILabel *)[cell viewWithTag:addsender.tag-800];
            
            NSInteger b = [[NSString stringWithFormat:@"%@",lab.text]integerValue] ;
            b ++;
            lab.text = [NSString stringWithFormat:@"%ld",(long)b];
            NSLog(@"b:===%ld",(long)b);
            UIButton *button = (UIButton *)[cell viewWithTag:addsender.tag-500];  //减号btn
            UILabel *jiage = (UILabel *)[cell viewWithTag:cell.tag +2000];  //优惠价格
            if (b >= -1) {
                [button setBackgroundImage:[UIImage imageNamed:@"sub_one"] forState:UIControlStateNormal];
                [addsender setBackgroundImage:[UIImage imageNamed:@"add_one"] forState:UIControlStateNormal];
                lab.textColor = HEX_TO_UICOLOR(NAV_COLOR, 1.0);
                button.userInteractionEnabled = YES;

                SERVICEDatas *datas = [model.datas objectAtIndex:cell.tag];
                NSString *select_type = [NSString stringWithFormat:@"%.f",datas.selectType];
                NSMutableDictionary *dic2=[[NSMutableDictionary alloc]init];
                [dic2 setObject:[NSString stringWithFormat:@"%ld",(long)b] forKey:@"count"];
                [dic2 setObject:[titleArray objectAtIndex:addsender.tag - 1000] forKey:@"name"];
                [dic2 setObject:[NSString stringWithFormat:@"%@",jiage.text] forKey:@"money"];
                [dic2 setObject:[NSString stringWithFormat:@"%@",select_type] forKey:@"select_type"];
                if (arr.count==0) {
                    [arr addObject:dic2];
                    
                }else{
                    int hava=0;
                    for (int i=0; i<arr.count; i++) {
                        NSDictionary *dic3=[arr objectAtIndex:i];
                        if ([dic3[@"name"] isEqualToString:[titleArray objectAtIndex:addsender.tag - 1000]]) {
                            [dic3 setValue:[NSString stringWithFormat:@"%d",[dic3[@"count"] intValue]+1]forKey:@"count"];
//                            [dic3 setValue:[[NSString stringWithFormat:@"%@",[dic3]@"money"] intValue]forKey:@"money"];
                            hava+=1;
                        }else{
                            hava+=0;
                        }
                    }
                    if (hava==0) {
                        [arr addObject:dic2];
                    }
                }
                
                NSLog(@"dic=%@",arr);
            }
            else
            {
                [button setBackgroundImage:[UIImage imageNamed:@"sub"] forState:UIControlStateNormal];
                [addsender setBackgroundImage:[UIImage imageNamed:@"xiyiadd"] forState:UIControlStateNormal];
                lab.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
            }
            
            
            break;
        }
    }
    
}
- (void)NextAction
{
    if(arr.count == 0){
        [MBProgressHUD showError:@"请您至少添加一件要洗的衣服" toView:self.view];
        return;
    }
    
    XiyiDetailViewController *detail = [[XiyiDetailViewController alloc]init];
    detail.qingdanArr = arr;
    detail.tips = model.tips;

    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark 打电话
#pragma mark 打电话
- (void)CallAction
{
    BOOL login = [self loginYesOrNo];
    if (login == YES) {
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
//        MyLogInViewController *log = [[MyLogInViewController alloc]init];
//        log.vCLID=0;
//        [self.navigationController presentViewController:log animated:YES completion:nil];
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

