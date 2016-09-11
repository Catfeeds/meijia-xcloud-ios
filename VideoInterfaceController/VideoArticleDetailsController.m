//
//  VideoArticleDetailsController.m
//  yxz
//
//  Created by xiaotao on 16/9/11.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "VideoArticleDetailsController.h"
#import "VideoArticleHeaderView.h"

static NSString *cellIdentifier = @"cell";

@interface VideoArticleDetailsController () <UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tbView;
    NSMutableArray *arrList;
}
@end

@implementation VideoArticleDetailsController

#pragma mark -- UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackButton];
    [self loadHeaderView];
    
    [tbView registerNib:[UINib nibWithNibName:@"VideoArticleTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Private Methods

- (void)setupBackButton
{
    UIView  *liftView=[[UIView alloc]initWithFrame:FRAME(0, 0, 80, 44)];
    UIButton *liftButton=[[UIButton alloc]initWithFrame:FRAME(0, 0, 40, 44)];
    [liftButton addTarget:self action:@selector(liftButAction) forControlEvents:UIControlEventTouchUpInside];
    [liftView addSubview:liftButton];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:FRAME(15, 11, 10, 20)];
    image.image = [UIImage imageNamed:@"title_left_back"];
    [liftButton addSubview:image];
    
    UIBarButtonItem *lifebar = [[UIBarButtonItem alloc] initWithCustomView:liftView];
    self.navigationItem.leftBarButtonItem = lifebar;
    self.title = @"课程详情";
}

- (void)liftButAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadHeaderView
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"VideoArticleHeaderView" owner:self options:nil];
    VideoArticleHeaderView *headerView = (VideoArticleHeaderView *)[array objectAtIndex:0];
    tbView.tableHeaderView = headerView;
}

- (NSMutableArray *)arrList
{
    if (!arrList) {
        arrList = [NSMutableArray arrayWithCapacity:0];
    }
    return arrList;
}

#pragma mark -- UITableView --

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 19, 100, 21)];
    label.textColor = RGBACOLOR(51, 51, 51, 1.0);
    label.font = [UIFont fontWithName:@"Heiti SC" size:14];
    [sectionView addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, WIDTH, 1)];
    line.backgroundColor = RGBACOLOR(230, 230, 230, 1.0f);
    [sectionView addSubview:line];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
