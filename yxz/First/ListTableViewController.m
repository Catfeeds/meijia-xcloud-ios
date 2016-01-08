//
//  ListTableViewController.m
//  simi
//
//  Created by 高鸿鹏 on 15-5-20.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "ListTableViewController.h"
#import "ListTablecell.h"
@interface ListTableViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_mytableView;
    NSMutableArray *imgArray;
    NSMutableArray *titleArray;
    NSMutableArray *detailArray;
}
@end

@implementation ListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navlabel.text = @"私 秘";
    self.backBtn.hidden = YES;
    
    UIButton *disBtn = [[UIButton alloc]initWithFrame:FRAME(SELF_VIEW_WIDTH-50, 20, 50, 44)];
    [disBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [disBtn setTitleColor:HEX_TO_UICOLOR(TEXT_COLOR, 1.0) forState:UIControlStateNormal];
    [disBtn setBackgroundColor:[UIColor clearColor]];
    [disBtn addTarget:self action:@selector(disAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:disBtn];
    
    _mytableView = [[UITableView alloc]initWithFrame:FRAME(0, NAV_HEIGHT, SELF_VIEW_WIDTH, SELF_VIEW_HEIGHT-NAV_HEIGHT)];
    _mytableView.delegate = self;
    _mytableView.dataSource = self;
    [self.view addSubview:_mytableView];
    
    imgArray = [[NSMutableArray alloc]initWithObjects:@"餐厅",
                                                      @"飞机",
                                                      @"火车",
                                                      @"快递",
                                                      @"麦克风",
                                                      @"闹钟",
                                                      @"笤帚",
                                                      @"洗衣",
                                                      @"演唱会",
                                                      @"医院",  nil];
    
    
    titleArray = [[NSMutableArray alloc]initWithObjects:@"订餐位",
                @"机票",
                @"火车票",
                @"叫快递",
                @"预定KTV",
                @"闹钟",
                @"打扫卫生",
                @"预约干洗",
                @"演唱戏剧",
                @"医疗预约",  nil];

    
    detailArray = [[NSMutableArray alloc]initWithObjects:@"“预定今晚六点的麻辣诱惑，两个位子”",
                                                      @"“一张本月17号北京到广州的机票”",
                                                      @"“一张本月17号北京到太原的动车票”",
                                                      @"“今天下午三点来我家取快递”",
                                                      @"“预约今晚西单麦乐迪通宵”",
                                                      @"“明天早晨6点叫我起床”",
                                                      @"“明天下午两点去我老妈家保洁”",
                                                      @"“今天下午两点来我家拿干洗衣服”",
                                                      @"“一张本月17号周杰伦演唱会的内场票”",
                                                      @"“预约明天北医牙科的专家号”",  nil];
    // Do any additional setup after loading the view.
}
- (void)disAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellDefine = @"cell";
    
    ListTablecell *cell = [tableView dequeueReusableCellWithIdentifier:cellDefine];
    if (cell == nil) {
        cell = [[ListTablecell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellDefine];
    }
    cell.img.image = [UIImage imageNamed:imgArray[indexPath.row]];
    cell.titleLab.text = titleArray[indexPath.row];
    cell.detailLab.text = detailArray[indexPath.row];
    
    return cell;
    
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
