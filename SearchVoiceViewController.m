//
//  SearchVoiceViewController.m
//  yxz
//
//  Created by 白玉林 on 15/12/5.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "SearchVoiceViewController.h"
#import "BuySecretaryViewController.h"
@interface SearchVoiceViewController ()
{
    UISearchBar *mySearchBar;
    UITableView *myTableView;
    NSMutableArray *seekArray;
    int Y;
    int height;
//    NSMutableArray *imageArray;
    NSString *sec_Id;
    NSString *secID;
    int is_senior;
    UIView *hotView;
    NSArray *arr;
    UILabel *alertLabel;
    NSString *searchStr;
    
    NSString *senderString;
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    NSInteger   page;
}
@end

@implementation SearchVoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page=1;
   seekArray=[[NSMutableArray alloc]init];
//    imageArray=[[NSMutableArray alloc]init];
    mySearchBar=[[UISearchBar alloc]initWithFrame:FRAME(60, 25, WIDTH-100, 30)];
    mySearchBar.placeholder=@"搜索";
    mySearchBar.delegate=self;
    //mySearchBar.backgroundColor = color;
    //mySearchBar.layer.cornerRadius = 18;
    mySearchBar.layer.masksToBounds = YES;
    [mySearchBar.layer setBorderWidth:8];
    [mySearchBar.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.view addSubview:mySearchBar];
    
    
    
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    [topView setBarStyle:UIBarStyleBlackTranslucent];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 5, 50, 25);
    [btn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"shouqi"] forState:UIControlStateNormal];
    [btn setTitle:@"隐藏" forState:UIControlStateNormal];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    [mySearchBar setInputAccessoryView:topView];
    
    UITapGestureRecognizer *tapSelf=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tapSelf.delegate=self;
    [self.view addGestureRecognizer:tapSelf];
    [myTableView removeFromSuperview];
    myTableView =[[UITableView alloc]initWithFrame:FRAME(0, hotView.frame.size.height+74, WIDTH, HEIGHT-hotView.frame.size.height-74)];
    myTableView.dataSource=self;
    myTableView.delegate=self;
    [self.view addSubview:myTableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [myTableView setTableFooterView:v];
    _refreshHeader = [[MJRefreshHeaderView alloc] init];
    _refreshHeader.delegate = self;
    _refreshHeader.scrollView = myTableView;
    
    _moreFooter = [[MJRefreshFooterView alloc] init];
    _moreFooter.delegate = self;
    _moreFooter.scrollView = myTableView;
    
    // Do any additional setup after loading the view.
}

#pragma mark 表格刷新相关
#pragma mark 刷新
-(void)refresh
{
    [_refreshHeader beginRefreshing];
}


#pragma mark - MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        //头 -》 刷新
        if (_moreFooter.isRefreshing) {
            //正在加载更多，取消本次请求
            [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            return;
        }
        page = 1;
        //刷新
        [self loadData];
        
    }else if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
        //尾 -》 更多
        if (_refreshHeader.isRefreshing) {
            //正在刷新，取消本次请求
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            
            return;
        }
        
        if (_hasMore==YES) {
            //没有更多了
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            //            [_tableView reloadData];
            return;
        }
        page++;
        
        //加载更多
        
        [self loadData];
    }
}

-(void)loadData
{
    //    if (_service == nil) {
    //        _service = [[zzProjectListService alloc] init];
    //        _service.delegate = self;
    //    }
    
    //通过控制page控制更多 网路数据
    //    [_service reqwithPageSize:INVESTPAGESIZE page:page];
    //    [self loadImg];
    
    //本底数据
    //    [_arrData addObjectsFromArray:[UIFont familyNames]];
    if (searchStr==nil||searchStr==NULL||[searchStr isEqualToString:@""]) {
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }else{
       [self handleSearchForTerm:searchStr];
    }
    
    
    
    
}

#pragma mark 表格刷新相关

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    DownloadManager *_download = [[DownloadManager alloc]init];
    [_download requestWithUrl:SERVICE_RSLB dict:nil view:self.view delegate:self finishedSEL:@selector(HotSearchSuccess:) isPost:NO failedSEL:@selector(HotSearchFailure:)];
}
-(void)tapAction:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    [mySearchBar resignFirstResponder];
    [UIView commitAnimations];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UITextField class]])
    {
        return NO;
    }
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
#pragma mark 热搜关键词列表成功返回
-(void)HotSearchSuccess:(id)sender
{
    NSLog(@"%@",sender);
    [hotView removeFromSuperview];
    hotView=[[UIView alloc]init];
    hotView.backgroundColor=[UIColor whiteColor];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:FRAME(10, 10, 40, 30)];
    titleLabel.text=@"热搜";
    [hotView addSubview:titleLabel];
    
     arr= [sender objectForKey:@"data"];
    CGFloat w = 40;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 10;//用来控制button距离父视图的高
    for (int i = 0; i < arr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag =i;
        button.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
        button.layer.cornerRadius=5;
        [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //根据计算文字的大小
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
        CGFloat length = [arr[i] boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        //为button赋值
        [button setTitle:arr[i] forState:UIControlStateNormal];
        //设置button的frame
        button.frame = CGRectMake(10 + w, h, length + 15 , 30);
        button.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
        [button setTitleColor:[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1] forState:UIControlStateNormal];
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(10 + w + length + 15 > 320){
            w = 0; //换行时将w置为0
            h = h + button.frame.size.height + 10;//距离父视图也变化
            button.frame = CGRectMake(10 + w, h, length + 15, 30);//重设button的frame
        }
        w = button.frame.size.width + button.frame.origin.x;
        [hotView addSubview:button];
    }
    
    hotView.frame=FRAME(0, 64, WIDTH, h+50);
    [self.view addSubview:hotView];
    myTableView.frame =FRAME(0, hotView.frame.size.height+74, WIDTH, HEIGHT-hotView.frame.size.height-74);

}
#pragma mark 热搜关键词列表失败返回
-(void)HotSearchFailure:(id)sender
{
    
}
#pragma mark 热搜关键字点击时间
-(void)handleClick:(UIButton *)but
{
    searchStr=[NSString stringWithFormat:@"%@",arr[but.tag]];
    mySearchBar.text=searchStr;
    if(self.loginYesOrNo!=YES)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            MyLogInViewController *loginViewController = [[MyLogInViewController alloc] init];
            loginViewController.vCYMID=100;
            UMComNavigationController *navigationController = [[UMComNavigationController alloc] initWithRootViewController:loginViewController];
            [self presentViewController:navigationController animated:YES completion:^{
            }];
        });
    }else{
        [self handleSearchForTerm:searchStr];
    }
    
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar

{
    searchStr = searchBar.text;
    [mySearchBar resignFirstResponder];
    [self handleSearchForTerm:searchStr];
}
-(void)handleSearchForTerm:(NSString *)string
{
    if (self.loginYesOrNo) {
        ISLoginManager *_manager = [ISLoginManager shareManager];
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSString *user_ID=_manager.telephone;
        NSDictionary *_dict = @{@"user_id":user_ID,@"keyword":string,@"page":@"1"};
        NSLog(@"字典数据%@",_dict);
        [_download requestWithUrl:SERVICE_SEARCH dict:_dict view:self.view delegate:self finishedSEL:@selector(SearchSuccess:) isPost:NO failedSEL:@selector(SearchFailure:)];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            MyLogInViewController *loginViewController = [[MyLogInViewController alloc] init];
            loginViewController.vCYMID=100;
            UMComNavigationController *navigationController = [[UMComNavigationController alloc] initWithRootViewController:loginViewController];
            [self presentViewController:navigationController animated:YES completion:^{
            }];
        });

    }
    
}
#pragma mark  获取关键字搜索结果成功
-(void)SearchSuccess:(id)sender
{
    NSLog(@"获取关键字搜索结果成功数据%@",sender);
    senderString=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    NSString *arrayString=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    if(arrayString==nil||arrayString==NULL||[arrayString isEqualToString:@""]){
        [alertLabel removeFromSuperview];
        alertLabel=[[UILabel alloc]initWithFrame:FRAME((WIDTH-260)/2,HEIGHT-100, 260, 40)];
        alertLabel.backgroundColor=[UIColor blackColor];
        alertLabel.alpha=0.4;
        alertLabel.text=[NSString stringWithFormat:@"没有结果！"];//@"还没有输入评论内容哦～";
        alertLabel.textColor=[UIColor whiteColor];
        alertLabel.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:alertLabel];
        
        [NSTimer scheduledTimerWithTimeInterval:2.0f
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:alertLabel
                                        repeats:NO];
    }else{
        if ([senderString isEqualToString:@""]) {
            seekArray=nil;
        }else{
            NSArray *array=[sender objectForKey:@"data"];
            if (array.count<10) {
                _hasMore=YES;
                [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
                [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            }else{
                _hasMore=NO;
            }
            if (page==1) {
                [seekArray removeAllObjects];
                [seekArray addObjectsFromArray:array];
            }else{
                for (int i=0; i<array.count; i++) {
                    if ([seekArray containsObject:array[i]]) {
                        
                    }else{
                        [seekArray addObject:array[i]];
                    }
                }
                
            }
        }
        [myTableView reloadData];
    }
}

- (void)timerFireMethod:(NSTimer*)theTimer
{
    alertLabel.hidden=YES;
}

#pragma mark  获取关键字搜索结果失败
-(void)SearchFailure:(id)sender
{
    NSLog(@"获取关键字搜索结果失败%@",sender);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return seekArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic=seekArray[indexPath.row];
    NSArray *labelArray=[dic objectForKey:@"user_tags"];
    NSString *identifier = [NSString stringWithFormat:@"cell%ld,%ld",(long)indexPath.row,(long)indexPath.section];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *headImageView=[[UIImageView alloc]init];
    UILabel *nameLabel=[[UILabel alloc]init];
    UILabel *textLabel=[[UILabel alloc]init];
    UILabel *buyLabel=[[UILabel alloc]init];
    UILabel *occupationLabel=[[UILabel alloc]init];
    UILabel *addresslabel=[[UILabel alloc]init];
    UIImageView *addressIamge=[[UIImageView alloc]init];
    UILabel *timeLabel=[[UILabel alloc]init];
    UIImageView *timeImage=[[UIImageView alloc]init];
    UIView *lineView=[[UIView alloc]init];
    
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    [cell addSubview:lineView];
    
    headImageView.frame=FRAME(10, 10, 50, 50);
    headImageView.layer.cornerRadius=headImageView.frame.size.width/2;
    headImageView.clipsToBounds = YES;
    [cell addSubview:headImageView];
    
    nameLabel.frame=FRAME(headImageView.frame.origin.x+headImageView.frame.size.width+10, 12, 60, 18);
    //nameLabel.backgroundColor=[UIColor redColor];
    nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    [cell  addSubview:nameLabel];
    
    occupationLabel.frame=FRAME(nameLabel.frame.size.width+nameLabel.frame.origin.x, nameLabel.frame.origin.y+2, WIDTH-210, 16);
    occupationLabel.textColor=[UIColor colorWithRed:100 / 255.0 green:100 / 255.0 blue:100 / 255.0 alpha:1];
    occupationLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    [cell addSubview:occupationLabel];
    
    
    textLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    textLabel.textColor=[UIColor colorWithRed:100 / 255.0 green:100 / 255.0 blue:100 / 255.0 alpha:1];
    [cell  addSubview:textLabel];
    
    buyLabel.frame=FRAME(WIDTH-70, 12, 60, 18);
    buyLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    buyLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    buyLabel.hidden=YES;
    [cell addSubview:buyLabel];
    
    addressIamge.frame=FRAME(headImageView.frame.size.width+headImageView.frame.origin.x+10, nameLabel.frame.size.height+nameLabel.frame.origin.y+5, 16, 16);
    addressIamge.image=[UIImage imageNamed:@"icon_sec_addr"];
    [cell addSubview:addressIamge];
    addresslabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    addresslabel.textColor=[UIColor colorWithRed:100 / 255.0 green:100 / 255.0 blue:100 / 255.0 alpha:1];
    [cell addSubview:addresslabel];
    
    timeImage.image=[UIImage imageNamed:@"icon_sec_time"];
    [cell addSubview:timeImage];
    
    timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    timeLabel.textColor=[UIColor colorWithRed:100 / 255.0 green:100 / 255.0 blue:100 / 255.0 alpha:1];
    [cell addSubview:timeLabel];
    Y=addressIamge.frame.size.height+addressIamge.frame.origin.y+5;
    int x=0;
    for (int i=0; i<labelArray.count; i++) {
        NSDictionary *dict=labelArray[i];
        if (i%3==0&&i!=0) {
            Y=Y+21;
            x=0;
        }
        UILabel *typeLabel=[[UILabel alloc]initWithFrame:FRAME(headImageView.frame.size.width+headImageView.frame.origin.x+10+((WIDTH-70-4)/3+2)*x, Y, (WIDTH-70-4)/3, 16)];
        typeLabel.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"tag_name"]];
        typeLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
        typeLabel.textColor=[UIColor colorWithRed:100 / 255.0 green:100 / 255.0 blue:100 / 255.0 alpha:1];
        typeLabel.layer.cornerRadius=8;
        typeLabel.clipsToBounds=YES;
        typeLabel.textAlignment=NSTextAlignmentCenter;
        typeLabel.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
        [cell addSubview:typeLabel];
        x++;
    }

    occupationLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_type_name"]];
//    buyLabel.text=@"以购买";
//    if ([service_type_id isEqualToString:@"75,180"]) {
//        if (is_senior==1) {
//            secID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"sec_id"]];
//            int sec_id=[sec_Id intValue];
//            int secid=[secID intValue];
//            if (sec_id==secid) {
//                buyLabel.hidden=NO;
//            }else{
//                buyLabel.hidden=YES;
//            }
//        }
//        
//    }
    NSString *headString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"head_img"]];
    if ([headString length]==1||[headString length]==0) {
        headImageView.image =[UIImage imageNamed:@"家-我_默认头像"];
        //            headeView.backgroundColor=[UIColor redColor];
    }else
    {
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"head_img"]];
        [headImageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
    }
    //headImageView.image=[UIImage imageNamed:@"家-我_默认头像"];
    nameLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    nameLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [nameLabel setNumberOfLines:1];
    [nameLabel sizeToFit];
    
    addresslabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"city_and_region"]];
    addresslabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [addresslabel setNumberOfLines:1];
    [addresslabel sizeToFit];
    addresslabel.frame=FRAME(addressIamge.frame.size.width+addressIamge.frame.origin.x, addressIamge.frame.origin.y, addresslabel.frame.size.width, 16);
    
    timeImage.frame=FRAME(addresslabel.frame.size.width+addresslabel.frame.origin.x+5, addresslabel.frame.origin.y, 16, 16);
    
    timeLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"response_time_name"]];
    timeLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [timeLabel setNumberOfLines:1];
    [timeLabel sizeToFit];
    timeLabel.frame=FRAME(timeImage.frame.size.width+timeImage.frame.origin.x, timeImage.frame.origin.y, timeLabel.frame.size.width, 16);
    
    
    UIFont *font=[UIFont fontWithName:@"Heiti SC" size:12];
    CGSize constraint = CGSizeMake(WIDTH-90, 200.0f);
    
    textLabel.lineBreakMode=NSLineBreakByWordWrapping;
    [textLabel setNumberOfLines:0];
    textLabel.text=[NSString stringWithFormat:@"“%@”",[dic objectForKey:@"introduction"]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size = [textLabel.text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    textLabel.frame=FRAME(headImageView.frame.origin.x+headImageView.frame.size.width+10, Y+21, WIDTH-80, size.height);
    textLabel.font=font;
    height=Y+31;
    
    UIView *lineview=[[UIView alloc]initWithFrame:FRAME(0, Y+21+size.height, WIDTH, 10)];
    lineView.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [cell addSubview:lineview];
    
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        dispatch_async(dispatch_get_main_queue(),^{
            [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        });
    }

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *plDic=seekArray[indexPath.row];
    NSArray *array=[plDic objectForKey:@"user_tags"];
    //    NSString *inforStr = [NSString stringWithFormat:@"简介:%@",[plDic objectForKey:@"introduction"]];
    //    UIFont *font = [UIFont systemFontOfSize:15];
    //    CGSize size = CGSizeMake(WIDTH-20,2000);
    //    CGSize labelsize = [inforStr sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    //    //height=labelsize.height+height;
    UIFont *font=[UIFont fontWithName:@"Heiti SC" size:15];
    CGSize constraint = CGSizeMake(WIDTH-90, 200.0f);
    
    UILabel *textLabel=[[UILabel alloc]init];
    textLabel.lineBreakMode=NSLineBreakByWordWrapping;
    [textLabel setNumberOfLines:0];
    textLabel.text=[NSString stringWithFormat:@"简介:%@",[plDic objectForKey:@"introduction"]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size = [textLabel.text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    textLabel.frame=FRAME(70, Y+21, WIDTH-80, size.height);
    textLabel.font=font;
    int heit;
    if (array.count>3) {
        heit=108;
    }else{
        heit=87;
    }
    return size.height+heit;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    [mySearchBar resignFirstResponder];
    [UIView commitAnimations];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic=seekArray[indexPath.row];
    BuySecretaryViewController *vc=[[BuySecretaryViewController alloc]init];
    vc.dic=dic;
    // vc.service_type_id=[NSString stringWithFormat:@"%ld",(long)service_type_id];
    [self.navigationController pushViewController:vc animated:YES];
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
