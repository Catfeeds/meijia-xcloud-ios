//
//  VideoArticleDetailsController.m
//  yxz
//
//  Created by xiaotao on 16/9/11.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "VideoArticleDetailsController.h"
#import "VideoArticleHeaderView.h"
#import "AFHTTPRequestOperationManager.h"
#import "VideoDetailModel.h"
#import "VideoDetailParser.h"
#import "VideoArticleModel.h"
#import "VideoArticleParser.h"
#import "VideoArticleToolBar.h"
#import "VideoArticleTableViewCell.h"

static NSString *cellIdentifier = @"cell";

@interface VideoArticleDetailsController () <UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tbView;
    VideoArticleHeaderView *headerView;
    NSMutableArray *articleListArr;
    NSMutableArray *videoDetailArr;
    VideoDetailModel *detailModel;
}
@end

@implementation VideoArticleDetailsController

#pragma mark -- UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    videoDetailArr = [NSMutableArray arrayWithCapacity:0];
    articleListArr = [NSMutableArray arrayWithCapacity:0];
    
    [self setupBackButton];
    [self setupToolBar];
    [self loadHeaderView];
    [self requstVideoDetail];
    [self requestArticelList];
    
    [tbView registerNib:[UINib nibWithNibName:@"VideoArticleTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    tbView.tableHeaderView = headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- RequestData Methods

- (void)requstVideoDetail
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSMutableDictionary *sourceDic = [[NSMutableDictionary alloc]init];
    [sourceDic setObject:_manager.telephone  forKey:@"user_id"];
    [sourceDic setObject:[NSNumber numberWithInteger:self.article_id] forKey:@"article_id"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:VIDEODETAIL parameters:sourceDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         VideoDetailParser *parser = [[VideoDetailParser alloc] init];
         parser.idCollection = videoDetailArr;
         if (RC_OK == [parser parserResponseDataFrom:responseObject])
         {
             detailModel = [videoDetailArr objectAtIndex:0];
             [headerView setData:detailModel];
             NSLog(@"数据%@",detailModel);
         }
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];
}

- (void)requestArticelList
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"article_id"] = [NSString stringWithFormat:@"%ld",(long)self.article_id];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:VIDEORELATE parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         VideoArticleParser *parser = [[VideoArticleParser alloc] init];
         parser.idCollection = articleListArr;
         if (RC_OK == [parser parserResponseDataFrom:responseObject])
         {
             [tbView reloadData];
         }
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];
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
    headerView = [array objectAtIndex:0];
}

- (NSMutableArray *)articleListArr
{
    if (!articleListArr) {
        articleListArr = [NSMutableArray arrayWithCapacity:0];
    }
    return articleListArr;
}

- (void)setupToolBar
{
    VideoArticleToolBar *toolBar = [[VideoArticleToolBar alloc]initWithFrame:FRAME(0, HEIGHT-50, WIDTH, 50)];
    toolBar.backgroundColor=[UIColor colorWithRed:244/255.0f green:245/255.0f blue:246/255.0f alpha:1];
    [self.view addSubview:toolBar];
}

#pragma mark -- UITableView --

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return articleListArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 21)];
    label.textColor = RGBACOLOR(51, 51, 51, 1.0);
    label.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    label.text = @"相关课程";
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
    VideoArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    VideoArticleModel *model = [articleListArr objectAtIndex:indexPath.row];
    [cell setData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
