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
#import "CommentListTableViewCell.h"
#import "UMSocialWechatHandler.h"

static NSString *cellIdentifier = @"cell";

@interface VideoArticleDetailsController () <UITableViewDelegate,UITableViewDataSource, UITextViewDelegate, MJRefreshBaseViewDelegate, UMSocialUIDelegate, VideoArticleToolBarDelegate>
{
    VideoArticleHeaderView *headerView;
    EjectAlertView *pushEjectView;
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    FatherViewController *fatherVc;
    VideoArticleToolBar *toolBar;
    
    IBOutlet UITableView *tbView;
    UITableView *myListTableView;
    UIView *keypadView;
    UIButton *blackBut;
    UITextView *myTextView;
    UILabel *viewLabel;
    UIButton *publishButton;
    

    NSMutableArray *articleListArr;
    NSMutableArray *videoDetailArr;
    NSMutableArray *listArray;
    VideoDetailModel *detailModel;
    NSString *clickStr;
    NSString *webURL;
    
    int  keypadHight;
    BOOL _hasMore;
    BOOL isDisPlayCommentList;
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
    
    fatherVc=[[FatherViewController alloc]init];
    isDisPlayCommentList = YES;
    
    [self registerObserVer];
    [self initArray];
    [self setupPullRequest];
    [self setupBackButton];
    [self setupToolBar];
    [self loadHeaderView];
    [self requstVideoDetail];
    [self requestArticelList];
    [self setupTbView];
    [self setupCommentListTableView];
    [self requestCommentList];
    [self diazanLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- RequestData Methods

- (void)initArray
{
    videoDetailArr = [NSMutableArray arrayWithCapacity:0];
    articleListArr = [NSMutableArray arrayWithCapacity:0];
    listArray = [NSMutableArray arrayWithCapacity:0];
}

- (void)registerObserVer
{
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
}

- (void)setupPullRequest
{
    _refreshHeader = [[MJRefreshHeaderView alloc] init];
    _refreshHeader.delegate = self;
    _refreshHeader.scrollView = myListTableView;
    
    _moreFooter = [[MJRefreshFooterView alloc] init];
    _moreFooter.delegate = self;
    _moreFooter.scrollView = myListTableView;
}

- (void)setupTbView
{
    [tbView registerNib:[UINib nibWithNibName:@"VideoArticleTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    tbView.tableHeaderView = headerView;
}

- (void)setupCommentListTableView
{
    myListTableView=[[UITableView alloc]initWithFrame:FRAME(0, HEIGHT, WIDTH, HEIGHT-50)style:UITableViewStyleGrouped];
    myListTableView.delegate=self;
    myListTableView.dataSource=self;
    myListTableView.backgroundColor=[UIColor colorWithRed:247/255.0f green:248/255.0f blue:249/255.0f alpha:1];
    myListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myListTableView];
}

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

#pragma mark -- 弹出框口

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


#pragma mark -- 设置底栏

- (void)setupToolBar
{
    toolBar = [[VideoArticleToolBar alloc]initWithFrame:FRAME(0, HEIGHT-50, WIDTH, 50)];
    toolBar.delegate = self;
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

#pragma mark -- VideoArticleToolBarDelegate

- (void)textFieldButtonClick
{
    [self addPublishView];
    [myTextView becomeFirstResponder];
}

- (void)otherButtonsClick:(UIButton *)button
{
    [self ButAction:button];
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
    myTextView.text = nil;
}

-(void)publishSuccess:(id)source
{
    [self requestCommentList];
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

#pragma mark获取当前动态是否点赞接口

-(void)diazanLayout
{
    DownloadManager *_download = [[DownloadManager alloc]init];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSString *article_id = [NSString stringWithFormat:@"%ld", (long)self.article_id];
    NSDictionary *_dict=@{@"fid":article_id,@"user_id":_manager.telephone};
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",ARTICLE_CLICK_BOOL] dict:_dict view:self.view delegate:self finishedSEL:@selector(ClickBoolSuccess:) isPost:NO failedSEL:@selector(ClickBoolFail:)];
}

-(void)ClickBoolSuccess:(id)source
{
    clickStr=[NSString stringWithFormat:@"%@",[source objectForKey:@"data"]];
    if (clickStr==nil||clickStr==NULL||[clickStr isEqualToString:@""]) {
        toolBar.clickImageView.image=[UIImage imageNamed:@"赞-点击前"];
    }else{
        toolBar.clickImageView.image=[UIImage imageNamed:@"赞-点击后"];
    }
}

-(void)ClickBoolFail:(id)source
{
    NSLog(@"获取当前动态是否点赞失败:%@",source);
}

#pragma mark -- 底栏右侧按钮点击方法

-(void)ButAction:(UIButton *)button
{
    if(fatherVc.loginYesOrNo!=YES)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            MyLogInViewController *loginViewController = [[MyLogInViewController alloc] init];
            loginViewController.vCYMID=100;
            UMComNavigationController *navigationController = [[UMComNavigationController alloc] initWithRootViewController:loginViewController];
            [self presentViewController:navigationController animated:YES completion:^{
            }];
        });
    }else{
        switch (button.tag) {
            case 0:
            {
                if (isDisPlayCommentList) {
                    [UIView beginAnimations: @"Animation" context:nil];
                    [UIView setAnimationDuration:0.3];
                    myListTableView.frame=FRAME(0, 64, WIDTH, HEIGHT-114);
                    [self.view addSubview:myListTableView];
                    [UIView commitAnimations];
                    
                }else{
                    [UIView beginAnimations: @"Animation" context:nil];
                    [UIView setAnimationDuration:0.3];
                    myListTableView.frame=FRAME(0, HEIGHT, WIDTH, HEIGHT-114);
                    [UIView commitAnimations];
                }
                
                isDisPlayCommentList = !isDisPlayCommentList;
            }
                break;
            case 1:
            {
                DownloadManager *_download = [[DownloadManager alloc]init];
                ISLoginManager *_manager = [ISLoginManager shareManager];
                NSString *actionStr;
                if (clickStr==nil||clickStr==NULL||[clickStr isEqualToString:@""]) {
                    actionStr=@"add";
                }else{
                    actionStr=@"del";
                }
                NSString *article_id = [NSString stringWithFormat:@"%ld", (long)self.article_id];
                NSDictionary *_dict=@{@"fid":article_id,@"user_id":_manager.telephone,@"action":actionStr};
                [_download requestWithUrl:[NSString stringWithFormat:@"%@",DYNAMIC_SHARE] dict:_dict view:self.view delegate:self finishedSEL:@selector(ClickSuccess:) isPost:YES failedSEL:@selector(ClickFail:)];
            }
                break;
            case 2:
            {
                [UMSocialWechatHandler setWXAppId:@"wx93aa45d30bf6cba3" appSecret:@"7a4ec42a0c548c6e39ce9ed25cbc6bd7" url:detailModel.video_url];
                [UMSocialQQHandler setQQWithAppId:@"1104934408" appKey:@"bRW2glhUCR6aJYIZ" url:detailModel.video_url];
                [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"247547429" RedirectURL:detailModel.video_url];
                [UMSocialSnsService presentSnsIconSheetView:self appKey:YMAPPKEY shareText:detailModel.title shareImage:[UIImage imageNamed:@"bolohr-logo512.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina,nil] delegate:self];
            }
                break;
            default:
                break;
        }
        
    }
}

#pragma mark 点赞成功

-(void)ClickSuccess:(id)source
{
    NSLog(@"点赞成功数据 :%@",source);
    [self diazanLayout];
}
#pragma mark 点赞失败

-(void)ClickFail:(id)source
{
    NSLog(@"点赞失败数据 :%@",source);
}

#pragma mark -- request CommentList

- (void)requestCommentList
{
    DownloadManager *_download = [[DownloadManager alloc]init];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSString *article_id = [NSString stringWithFormat:@"%ld", (long)self.article_id];
    NSDictionary *_dict=@{@"fid":article_id,@"user_id":_manager.telephone};
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",DYNAMIC_COM_CARD] dict:_dict view:self.view delegate:self finishedSEL:@selector(ListSuccess:) isPost:NO failedSEL:@selector(ListFail:)];
}

-(void)ListSuccess:(id)source
{
    NSLog(@"评论列表数据成功:%@",source);
    NSString *string=[NSString stringWithFormat:@"%@",[source objectForKey:@"data"]];
    if (string==nil||string==NULL||[string isEqualToString:@""]) {
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }else{
        [listArray removeAllObjects];
        
        NSArray *array=[source objectForKey:@"data"];
        if (array.count<10) {
            _hasMore = YES;
        }else{
            _hasMore = NO;
        }
        
        for (int i=0; i<array.count; i++) {
            NSDictionary *dict=array[i];
            [listArray addObject:dict];
        }
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [myListTableView reloadData];
        
    }
}

-(void)ListFail:(id)source
{
    NSLog(@"评论列表数据失败:%@",source);
}

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
    if (tableView == tbView)
        return articleListArr.count;
    else
        return listArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == tbView)
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
    else
    {
        UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 43)];
        UILabel *nameLabel=[[UILabel alloc]init];
        nameLabel.text=@"评论";
        nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        nameLabel.textColor=[UIColor colorWithRed:50/255.0f green:51/255.0f blue:52/255.0f alpha:1];
        [nameLabel setNumberOfLines:1];
        [nameLabel sizeToFit];
        nameLabel.frame=FRAME(10, 20, nameLabel.frame.size.width, 15);
        [view addSubview:nameLabel];
        
        UIView *labelView=[[UIView alloc]initWithFrame:FRAME(10, 42, nameLabel.frame.size.width, 1)];
        labelView.backgroundColor=[UIColor colorWithRed:255/255.0f green:123/255.0f blue:129/255.0f alpha:1];
        [view addSubview:labelView];
        
        UIView *lineView=[[UIView alloc]initWithFrame:FRAME(10+nameLabel.frame.size.width, 42, WIDTH-20-nameLabel.frame.size.width, 1)];
        lineView.backgroundColor=[UIColor colorWithRed:226/255.0f green:227/255.0f blue:228/255.0f alpha:1];
        [view addSubview:lineView];
        return view;

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tbView)
        return 100;
    else
    {
        CommentListTableViewCell *cell=[[CommentListTableViewCell alloc]init];
        NSDictionary *dic=listArray[indexPath.row];
        cell.texLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"comment"]];
        UIFont *font=[UIFont fontWithName:@"Heiti SC" size:15];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        CGSize size = [cell.texLabel.text boundingRectWithSize:CGSizeMake(WIDTH-60, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        return size.height+71;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == tbView)
        return 50;
    else
        return 43;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tbView) {
        VideoArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        VideoArticleModel *model = [articleListArr objectAtIndex:indexPath.row];
        [cell setData:model];
        return cell;
    }
    else
    {
        NSDictionary *dic=listArray[indexPath.row];
        NSString *identifier = [NSString stringWithFormat:@"Cell%ld,%ld",(long)indexPath.row,(long)indexPath.section];
        CommentListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[CommentListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"head_img"]];
        [cell.headImageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
        cell.nameLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        cell.nameLabel.textColor=[UIColor colorWithRed:146/255.0f green:146/255.0f blue:146/255.0f alpha:1];
        cell.timeLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"add_time_str"]];
        cell.timeLabel.textColor=[UIColor colorWithRed:209/255.0f green:209/255.0f blue:209/255.0f alpha:1];
        cell.texLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"comment"]];
        UIFont *font=[UIFont fontWithName:@"Heiti SC" size:15];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        CGSize size = [cell.texLabel.text boundingRectWithSize:CGSizeMake(WIDTH-60, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        [cell.texLabel setNumberOfLines:0];
        [cell.texLabel sizeToFit];
        cell.texLabel.frame=FRAME(50, 60, WIDTH-60, size.height);
        UIView  *lineView=[[UIView alloc]initWithFrame:FRAME(10, 70+size.height, WIDTH-20, 1)];
        lineView.backgroundColor=[UIColor colorWithRed:226/255.0f green:227/255.0f blue:228/255.0f alpha:1];
        [cell addSubview:lineView];
        cell.backgroundColor=[UIColor colorWithRed:247/255.0f green:248/255.0f blue:249/255.0f alpha:1];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
@end
