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
    EjectAlertView *pushEjectView;

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
             [self SignPolite];
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

-(void)SignPolite
{
    [pushEjectView removeFromSuperview];
    pushEjectView = [EjectAlertView new];
    pushEjectView.frame=FRAME(0, 0, WIDTH, HEIGHT);
    pushEjectView.backgroundColor = [UIColor blueColor];
    [pushEjectView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin];
    [self.view addSubview:pushEjectView];
    UIView *grayView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
    grayView.backgroundColor=[UIColor blackColor];
    grayView.alpha=0.4;
    [pushEjectView addSubview:grayView];
    
    UIView *view=[[UIView alloc]initWithFrame:FRAME((WIDTH-WIDTH*0.72)/2, (HEIGHT-356)/2, WIDTH*0.72, WIDTH*0.72*0.70+168)];
    view.backgroundColor=[UIColor whiteColor];
    view.layer.cornerRadius=10;
    view.clipsToBounds=YES;
    [pushEjectView addSubview:view];
    
    UIImageView *headeImageView=[[UIImageView alloc]initWithFrame:FRAME(0, 0, WIDTH*0.72, WIDTH*0.72*0.70)];
    //    headeImageView.backgroundColor=[UIColor whiteColor];
    headeImageView.image=[UIImage imageNamed:@"banner"];
    [view addSubview:headeImageView];
    
    UIImageView *goldImage=[[UIImageView alloc]initWithFrame:FRAME((WIDTH*0.72-100)/4, WIDTH*0.72*0.70+23, 50, 50)];
    goldImage.image=[UIImage imageNamed:@"金币"];
    [view addSubview:goldImage];
    
    UIImageView *valueImage=[[UIImageView alloc]initWithFrame:FRAME((WIDTH*0.72-100)/4*3+50, WIDTH*0.72*0.70+23, 50, 50)];
    valueImage.image=[UIImage imageNamed:@"经验值"];
    [view addSubview:valueImage];
    
    UILabel *goldLabel=[[UILabel alloc]initWithFrame:FRAME(0, WIDTH*0.72*0.70+83, (WIDTH*0.72)/2, 20)];
    goldLabel.font=[UIFont fontWithName:@"Georgia-Bold" size:15];
    goldLabel.text=[NSString stringWithFormat:@"金币+%@", @"15"];
    goldLabel.textColor=[UIColor colorWithRed:255/255.0f green:157/255.0f blue:48/255.0f alpha:1];
    goldLabel.textAlignment=NSTextAlignmentCenter;
    [view addSubview:goldLabel];
    
    UILabel *valueLabel=[[UILabel alloc]initWithFrame:FRAME((WIDTH*0.72)/2, WIDTH*0.72*0.70+83, (WIDTH*0.72)/2, 20)];
    valueLabel.font=[UIFont fontWithName:@"Georgia-Bold" size:15];
    valueLabel.text=[NSString stringWithFormat:@"经验值+%@",@"20"];
    valueLabel.textColor=[UIColor colorWithRed:191/255.0f green:127/255.0f blue:127/255.0f alpha:1];
    valueLabel.textAlignment=NSTextAlignmentCenter;
    [view addSubview:valueLabel];
    
    UIView *hengView=[[UIView alloc]initWithFrame:FRAME(0, WIDTH*0.72*0.70+127, WIDTH*0.72, 1)];
    hengView.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [view addSubview:hengView];
    
    UIButton *cancelBut1=[[UIButton alloc]initWithFrame:FRAME(0, WIDTH*0.72*0.70+128, (WIDTH*0.72)/2-0.5, 40)];
    cancelBut1.backgroundColor=[UIColor whiteColor];
    cancelBut1.tag=12;
    [cancelBut1 addTarget:self action:@selector(SignAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelBut1.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    [cancelBut1 setTitle:@"了解更多" forState:UIControlStateNormal];
    [cancelBut1 setTitleColor:[UIColor colorWithRed:17/255.0f green:150/255.0f blue:219/255.0f alpha:1] forState:UIControlStateNormal];
    [view addSubview:cancelBut1];
    
    UILabel  *labble=[[UILabel alloc]initWithFrame:FRAME((WIDTH*0.72)/2-0.5, WIDTH*0.72*0.70+138, 1, 20)];
    labble.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [view addSubview:labble];
    
    UIButton *cancelBut=[[UIButton alloc]initWithFrame:FRAME((WIDTH*0.72)/2+0.5, WIDTH*0.72*0.70+128, (WIDTH*0.72)/2-0.5, 40)];
    cancelBut.backgroundColor=[UIColor whiteColor];
    cancelBut.tag=14;
    [cancelBut addTarget:self action:@selector(SignAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelBut.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    [cancelBut setTitle:@"我知道了" forState:UIControlStateNormal];
    [cancelBut setTitleColor:[UIColor colorWithRed:17/255.0f green:150/255.0f blue:219/255.0f alpha:1] forState:UIControlStateNormal];
    [view addSubview:cancelBut];
}

-(void)SignAction:(UIButton *)button
{
    pushEjectView.hidden = YES;
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
