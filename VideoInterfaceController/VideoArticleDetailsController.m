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
#import "VideoMaskView.h"

static NSString *cellIdentifier = @"cell";

@interface VideoArticleDetailsController () <UITableViewDelegate,UITableViewDataSource, UITextViewDelegate>
{
    IBOutlet UITableView *tbView;
    VideoArticleHeaderView *headerView;
    EjectAlertView *pushEjectView;
    UIView *keypadView;
    UIButton *blackBut;
    UITextView *myTextView;
    UILabel *viewLabel;
    UIButton *publishButton;

    NSMutableArray *articleListArr;
    NSMutableArray *videoDetailArr;
    VideoDetailModel *detailModel;
    
    int  keypadHight;
}
@end

@implementation VideoArticleDetailsController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -- UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

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
    weak_Self(self);
    toolBar.block = ^{
        [weakSelf addPublishView];
        [myTextView becomeFirstResponder];//弹出键盘
    };
    toolBar.backgroundColor=[UIColor colorWithRed:244/255.0f green:245/255.0f blue:246/255.0f alpha:1];
    [self.view addSubview:toolBar];
}

- (void)addPublishView
{
    keypadView=[[UIView alloc]initWithFrame:FRAME(0, HEIGHT, WIDTH, 145)];
    keypadView.backgroundColor=[UIColor colorWithRed:243/255.0f green:246/255.0f blue:246/255.0f alpha:1];
    [self.view addSubview:keypadView];
    
    myTextView=[[UITextView alloc]initWithFrame:FRAME(9, 9, WIDTH-18, 90)];
    myTextView.backgroundColor=[UIColor whiteColor];
    myTextView.layer.cornerRadius=8;
    myTextView.clipsToBounds=YES;
    myTextView.delegate=self;
    [keypadView addSubview:myTextView];
    
    viewLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, 200, 20)];
    viewLabel.enabled = NO;
    viewLabel.text = @"写下您的看法与见解...";
    viewLabel.font =  [UIFont systemFontOfSize:15];
    viewLabel.textColor = [UIColor lightGrayColor];
    [myTextView addSubview:viewLabel];
    
    publishButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-57, 108, 48, 28)];
    publishButton.backgroundColor=[UIColor colorWithRed:202/255.0f green:202/255.0f blue:202/255.0f alpha:1];
    [publishButton setTitle:@"发布" forState:UIControlStateNormal];
    publishButton.enabled=FALSE;
    [publishButton addTarget:self action:@selector(publishBut) forControlEvents:UIControlEventTouchUpInside];
    publishButton.layer.cornerRadius=5;
    publishButton.clipsToBounds=YES;
    [keypadView addSubview:publishButton];
    
    blackBut=[[UIButton alloc]initWithFrame:FRAME(0, HEIGHT, WIDTH, HEIGHT-(keypadHight+145))];
    blackBut.backgroundColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    [blackBut addTarget:self action:@selector(blackButAction) forControlEvents:UIControlEventTouchUpInside];
    blackBut.alpha=0.6;
    [self.view addSubview:blackBut];
}

- (void)blackButAction
{
    [myTextView resignFirstResponder];
}

#pragma mark 发布按钮点击方法

-(void)publishBut
{
    [myTextView resignFirstResponder];
    DownloadManager *_download = [[DownloadManager alloc]init];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSString *article_id = [NSString stringWithFormat:@"%ld", (long)self.article_id];
    NSDictionary *_dict=@{@"fid":article_id,@"user_id":_manager.telephone,@"comment":myTextView.text};
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",DYNAMIC_COMMENT] dict:_dict view:self.view delegate:self finishedSEL:@selector(publishSuccess:) isPost:YES failedSEL:@selector(publishFail:)];
}

-(void)publishSuccess:(id)source
{
//    [self listLayout];
    [self performSelector:@selector(popAlertView) withObject:nil afterDelay:1];
}

-(void)publishFail:(id)source
{
    NSLog(@"评论失败--:%@",source);
}

-(void)popAlertView{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"评论成功" message:nil  delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    alert.tag=199;
    [alert show];
    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:1];
}

- (void) dimissAlert:(UIAlertView *)alert {
    if(alert)     {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}

#pragma mark -- Refresh CommentList



#pragma mark -- Notification

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    keypadHight=height;
    keypadView.frame=FRAME(0, HEIGHT-(keypadHight+145), WIDTH, 145);
//    [self.view addSubview:keypadView];

    blackBut.frame=FRAME(0, 0, WIDTH, HEIGHT-(keypadHight+145));
//    [self.view addSubview:blackBut];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    keypadView.frame=FRAME(0, HEIGHT, WIDTH, 145);
    blackBut.frame=FRAME(0, HEIGHT, WIDTH, HEIGHT-(keypadHight+145));
}

#pragma mark -- UITextViewDelegate

- (void) textViewDidChange:(UITextView *)textView{
    if ([textView.text length] == 0) {
        [viewLabel setHidden:NO];
        publishButton.enabled=FALSE;
        publishButton.backgroundColor=[UIColor colorWithRed:202/255.0f green:202/255.0f blue:202/255.0f alpha:1];
    }else{
        [viewLabel setHidden:YES];
        publishButton.enabled=TRUE;
        publishButton.backgroundColor=[UIColor colorWithRed:0/255.0f green:142/255.0f blue:214/255.0f alpha:1];
    }
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
