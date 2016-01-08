//
//  XiyiDetailViewController.m
//  simi
//
//  Created by zrj on 14-11-11.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "XiyiDetailViewController.h"
#import "ChoiceDefine.h"
#import "DetailCell.h"
#import "PayViewController.h"
#import "XiyiThirdViewController.h"
#import "BaiduMobStat.h"
@interface XiyiDetailViewController ()
{
    UITableView *_mytableView;

    NSString *_time;

    double price;
}
@end

@implementation XiyiDetailViewController
@synthesize qingdanArr,tips;
-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"洗衣二", nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"洗衣二", nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navlabel.text = @"洗衣";

    
    price = 0.0;
    int number;
    float _money;
    for (int i = 0; i < qingdanArr.count; i++)
    {
        NSDictionary *dic = qingdanArr [i];
        number = [dic[@"count"]intValue];
        _money = [[dic[@"money"] substringFromIndex:4]floatValue];
        price = price + (number * _money);
    }
    
    
    
    self.view.backgroundColor = HEX_TO_UICOLOR(XIYI_BACKVIEW_COLOR, 1.0);
    
    UILabel *qingdan = [[UILabel alloc]initWithFrame:FRAME(18, NAV_HEIGHT+13, 70, 30)];
    qingdan.text = @"洗护清单";
    qingdan.textColor = HEX_TO_UICOLOR(QINGDAN_LABLE_COLOR, 1.0);
    qingdan.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:qingdan];
    
    UILabel *wupinLab = [[UILabel alloc]initWithFrame:FRAME(18, NAV_HEIGHT+45, 50, 30)];
    wupinLab.text = @"物品";
    wupinLab.textColor = HEX_TO_UICOLOR(ROUND_COLOR, 1.0);
    wupinLab.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:wupinLab];
    
    UILabel *shuliang = [[UILabel alloc]initWithFrame:FRAME(0, NAV_HEIGHT+45, SELF_VIEW_WIDTH, 30)];
    shuliang.text = @"数量";
    shuliang.textAlignment = NSTextAlignmentCenter;
    shuliang.textColor = HEX_TO_UICOLOR(ROUND_COLOR, 1.0);
    shuliang.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:shuliang];
    
    UILabel *danjia = [[UILabel alloc]initWithFrame:FRAME(SELF_VIEW_WIDTH-18-50, NAV_HEIGHT+45, 50, 30)];
    danjia.text = @"单价";
    danjia.textAlignment = NSTextAlignmentRight;
    danjia.textColor = HEX_TO_UICOLOR(ROUND_COLOR, 1.0);
    danjia.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:danjia];
    
#define zengao 50
    
    _mytableView = [[UITableView alloc]initWithFrame:FRAME(0, NAV_HEIGHT+45+30, SELF_VIEW_WIDTH, SELF_VIEW_HEIGHT-(20+296/2+74/2)-28-54-30+zengao)];
    _mytableView.delegate = self;
    _mytableView.dataSource = self;
    _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_mytableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:_mytableView];
    
    UIView *vie = [[UIView alloc]initWithFrame:FRAME(18, NAV_HEIGHT+45+30+SELF_VIEW_HEIGHT-(20+296/2+74/2)-28-54+12-30+zengao, SELF_VIEW_WIDTH-36, 1)];
    vie.backgroundColor = HEX_TO_UICOLOR(ROUND_COLOR, 1.0);
    [self.view addSubview:vie];
    
    UILabel *feiyong = [[UILabel alloc]initWithFrame:FRAME(18, SELF_VIEW_HEIGHT-160+zengao, 70, 30)];
    feiyong.text = @"费用总计";
    feiyong.textAlignment = NSTextAlignmentLeft;
    feiyong.textColor = HEX_TO_UICOLOR(QINGDAN_LABLE_COLOR, 1.0);
    feiyong.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:feiyong];
    
    UILabel *yuan = [[UILabel alloc]initWithFrame:FRAME(SELF_VIEW_WIDTH-18-50-100, SELF_VIEW_HEIGHT-160+zengao, 150, 30)];
    yuan.text = [NSString stringWithFormat:@"%0.1f元",price];
    yuan.textAlignment = NSTextAlignmentRight;
    yuan.textColor = HEX_TO_UICOLOR(ROUND_COLOR, 1.0);
    yuan.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:yuan];
    
//    UILabel *wenxin = [[UILabel alloc]initWithFrame:FRAME(18, SELF_VIEW_HEIGHT-100-30, 100, 30)];
//    wenxin.text = @"* 温馨提示:";
//    wenxin.textAlignment = NSTextAlignmentLeft;
//    wenxin.textColor = HEX_TO_UICOLOR(ROUND_COLOR, 1.0);
//    wenxin.font = [UIFont systemFontOfSize:15];
//    [self.view addSubview:wenxin];
//    
//    UILabel *tishi = [[UILabel alloc]initWithFrame:FRAME(18+80, SELF_VIEW_HEIGHT-100-30, 200, 30)];
//    tishi.text = @"以实际洗护用品收取费用";
//    tishi.textAlignment = NSTextAlignmentLeft;
//    tishi.textColor = HEX_TO_UICOLOR(QINGDAN_LABLE_COLOR, 1.0);
//    tishi.font = [UIFont systemFontOfSize:15];
//    [self.view addSubview:tishi];

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
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return qingdanArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    DetailCell *Cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (Cell == nil) {
        Cell = [[DetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    
    Cell.backgroundView = nil;
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSLog(@"qingdanArr = %@",qingdanArr);
    NSDictionary *dic = qingdanArr [indexPath.row];
    NSLog(@"dic = %@",dic);
    Cell.numberLab.text = dic[@"count"];
    Cell.titleLab.text = dic[@"name"];
    NSString *money = dic[@"money"];
    NSString *str = [money substringFromIndex:4];
    Cell.danjiaLab.text = [NSString stringWithFormat:@"%@",str];
    
    return Cell;
    
}
- (void)NextAction
{
    XiyiThirdViewController *xiyi = [[XiyiThirdViewController alloc]init];
    xiyi._price = [NSString stringWithFormat:@"%0.2f",price];
    xiyi.tips = tips;
    xiyi.sourceArr = qingdanArr;
    [self.navigationController pushViewController:xiyi animated:YES];
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
