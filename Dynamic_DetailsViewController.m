//
//  Dynamic_DetailsViewController.m
//  yxz
//
//  Created by 白玉林 on 15/12/28.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "Dynamic_DetailsViewController.h"
#import "DynamicImageViewController.h"
@interface Dynamic_DetailsViewController ()
{
    UIScrollView *_scrollView;
    UIView *layoutVied;
    NSDictionary *dataDic;
    UITextView *textView;
    UIView *underView;
    UILabel *textViewLabel;
    UIButton *commentButton;
    UILabel *alertLabel;
    int cellNum;
    UITableView *_tableView;
    NSArray *commArray;
}
@end

@implementation Dynamic_DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGesture.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:tapGesture];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    self.navlabel.text=@"动态详情";
    _scrollView=[[UIScrollView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-113)];
    _scrollView.bounces=NO;
    _scrollView.delegate=self;
    _scrollView.showsVerticalScrollIndicator = FALSE;
    _scrollView.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:_scrollView];
    [self Request_data];
    [self commentLayout];
    [self commwntLayout];
    
    
    // Do any additional setup after loading the view.
}
-(void)Request_data
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *dic=@{@"user_id":_manager.telephone,@"fid":_dyNamicID};
    [_download requestWithUrl:DYNAMIC_DETAILS dict:dic view:self.view delegate:self finishedSEL:@selector(dataSuccess:) isPost:NO failedSEL:@selector(dataFailure:)];
}
-(void)tableViewLayout
{
    NSLog(@"能不能成功");
    [_tableView removeFromSuperview];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, layoutVied.frame.size.height, WIDTH, 200)];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_scrollView addSubview:_tableView];
    
}
#pragma mark评论列表接口调用
-(void)commentLayout
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *dic=@{@"user_id":_manager.telephone,@"fid":_dyNamicID};
    [_download requestWithUrl:DYNAMIC_COM_CARD dict:dic view:self.view delegate:self finishedSEL:@selector(CommentSuccess:) isPost:NO failedSEL:@selector(CommentFailure:)];
}
#pragma mark获取评论列表数据成功
-(void)CommentSuccess:(id)commentSource
{
    NSLog(@"成功获取数据:%@",commentSource);
    commArray=[commentSource objectForKey:@"data"];
    NSString *string=[NSString stringWithFormat:@"%@",[commentSource objectForKey:@"data"]];
    if (string==nil||string==NULL||[string isEqualToString:@""]) {
        cellNum=0;
    }else{
        cellNum=(int)commArray.count;
    }
    NSLog(@"%@",commArray);
    [_tableView reloadData];
    
    
}
#pragma mark获取评论列表数据失败
-(void)CommentFailure:(id)commentSource
{
    NSLog(@"获取数据失败:%@",commentSource);
}
-(void)viewLayout
{
    [layoutVied removeFromSuperview];
    layoutVied=[[UIView alloc]init];
    layoutVied.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:layoutVied];
    
    UIImageView *headeImageView=[[UIImageView alloc]initWithFrame:FRAME(18, 10, 40, 40)];
    NSString *headeImageUrl=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"head_img"]];
    [headeImageView setImageWithURL:[NSURL URLWithString:headeImageUrl]placeholderImage:nil];
    headeImageView.layer.cornerRadius=headeImageView.frame.size.width/2;
    headeImageView.layer.masksToBounds=YES;
    [layoutVied addSubview:headeImageView];
    
    UILabel *nameLabe=[[UILabel alloc]init];
    nameLabe.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"name"]];
    nameLabe.font=[UIFont fontWithName:@"Heiti SC" size:17];
    [nameLabe setNumberOfLines:1];
    [nameLabe sizeToFit];
    nameLabe.frame=FRAME(headeImageView.frame.size.width+headeImageView.frame.origin.x+10, headeImageView.frame.origin.y, nameLabe.frame.size.width, 20);
    [layoutVied addSubview:nameLabe];
    
    UILabel *timeLabel=[[UILabel alloc]init];
    timeLabel.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"add_time_str"]];
    timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    [timeLabel setNumberOfLines:1];
    [timeLabel sizeToFit];
    timeLabel.frame=FRAME(nameLabe.frame.origin.x, nameLabe.frame.size.height+nameLabe.frame.origin.y, timeLabel.frame.size.width, 20);
    [layoutVied addSubview:timeLabel];
    
    UIView *lineView=[[UIView alloc]initWithFrame:FRAME(0, timeLabel.frame.size.height+timeLabel.frame.origin.y+10, WIDTH, 1)];
    lineView.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    [layoutVied addSubview:lineView];
    
    UILabel *textLabel=[[UILabel alloc]init];
    textLabel.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"title"]];
    UIFont *font=[UIFont fontWithName:@"Heiti SC" size:18];
    textLabel.font=font;
    [textLabel setNumberOfLines:0];
    [textLabel sizeToFit];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize size = [textLabel.text boundingRectWithSize:CGSizeMake(WIDTH-40, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    textLabel.frame=FRAME(20, lineView.frame.size.height+lineView.frame.origin.y+10, WIDTH-40, size.height);
    [layoutVied addSubview:textLabel];
    
    int Hed=textLabel.frame.size.height+textLabel.frame.origin.y+10;
    NSArray *imageArray=[dataDic objectForKey:@"feed_imgs"];
    if (imageArray.count==0) {
        Hed=textLabel.frame.size.height+textLabel.frame.origin.y+10;
    }else if(imageArray.count==1){
        UIButton *imageButton=[[UIButton alloc]initWithFrame:FRAME(20, textLabel.frame.size.height+textLabel.frame.origin.y+10, (WIDTH-50)/3*2+5, (WIDTH-50)/3)];
        imageButton.tag=0;
        [imageButton addTarget:self action:@selector(imageButAction:) forControlEvents:UIControlEventTouchUpInside];
        [layoutVied addSubview:imageButton];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME(0, 0, imageButton.frame.size.width, imageButton.frame.size.height)];
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[imageArray[0] objectForKey:@"img_middle"]];
        [imageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
        [imageButton addSubview:imageView];
        
        Hed=Hed+(WIDTH-50)/3;
    }else if (imageArray.count==4){
        int X=0;
        int Y=Hed;
        for (int i=0; i<imageArray.count; i++) {
            if (i==2) {
                X=0;
                Y=Y+(WIDTH-50)/3+5;
            }
            UIButton *imageButton=[[UIButton alloc]initWithFrame:FRAME(20+((WIDTH-50)/3+5)*X, Y, (WIDTH-50)/3, (WIDTH-50)/3)];
            imageButton.tag=i;
            [imageButton addTarget:self action:@selector(imageButAction:) forControlEvents:UIControlEventTouchUpInside];
            [layoutVied addSubview:imageButton];
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME(0, 0, imageButton.frame.size.width, imageButton.frame.size.height)];
            NSString *imageUrl=[NSString stringWithFormat:@"%@",[imageArray[i] objectForKey:@"img_small"]];
            [imageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
            [imageButton addSubview:imageView];
            X++;
        }
        Hed=Hed+(WIDTH-50)/3*2+5;
    }else{
        int X=0;
        int Y=Hed;
        for (int i=0; i<imageArray.count; i++) {
            if (i%3==0&&i!=0) {
                X=0;
                Y=Y+(WIDTH-50)/3+5;
            }
            UIButton *imageButton=[[UIButton alloc]initWithFrame:FRAME(20+((WIDTH-50)/3+5)*X, Y, (WIDTH-50)/3, (WIDTH-50)/3)];
            imageButton.tag=i;
            [imageButton addTarget:self action:@selector(imageButAction:) forControlEvents:UIControlEventTouchUpInside];
            [layoutVied addSubview:imageButton];
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME(0, 0, imageButton.frame.size.width, imageButton.frame.size.height)];
            NSString *imageUrl=[NSString stringWithFormat:@"%@",[imageArray[i] objectForKey:@"img_small"]];
            [imageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
            [imageButton addSubview:imageView];
            X++;
        }
        if (imageArray.count<4){
            Hed=Hed+(WIDTH-50)/3;
        }else if (imageArray.count>4&&imageArray.count<7){
            Hed=Hed+(WIDTH-50)/3*2+5;
        }else if (imageArray.count==7||imageArray.count>7){
            Hed=Hed+(WIDTH-50)/3*3+10;
        }
        
    }
    UIButton * shareButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-50, Hed+10, 30, 30)];
//    [shareButton setImage:[UIImage imageNamed:@"common_icon_share@2x(1)"] forState:UIControlStateNormal];
    [shareButton addTarget:self  action:@selector(shareButAction) forControlEvents:UIControlEventTouchUpInside];
    [layoutVied addSubview:shareButton];
    UIImageView *shareImage=[[UIImageView alloc]initWithFrame:FRAME(5, 5, 20, 20)];
    shareImage.image=[UIImage imageNamed:@"common_icon_share@2x(1)"];
    [shareButton addSubview:shareImage];
    
    UIButton *praiseButton=[[UIButton alloc]init];
    [praiseButton addTarget:self action:@selector(praiseButAction) forControlEvents:UIControlEventTouchUpInside];
    [layoutVied addSubview:praiseButton];
    
    UILabel *praiseLabel=[[UILabel alloc]init];
    praiseLabel.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"total_zan"]];
    praiseLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    [praiseLabel setNumberOfLines:1];
    [praiseLabel sizeToFit];
    praiseLabel.frame=FRAME(30, (30-15)/2, praiseLabel.frame.size.width, 15);
    [praiseButton addSubview:praiseLabel];
    
    praiseButton.frame=FRAME(WIDTH-80-praiseLabel.frame.size.width, shareButton.frame.origin.y, 30+praiseLabel.frame.size.width, 30);
    
    UIImageView *butImageView=[[UIImageView alloc]initWithFrame:FRAME(5, 5, 20, 20)];
    butImageView.image=[UIImage imageNamed:@"common_icon_like_c@2x(1)"];
    [praiseButton addSubview:butImageView];
    
    UIView *zanLineView=[[UIView alloc]initWithFrame:FRAME(0, praiseButton.frame.size.height+praiseButton.frame.origin.y, WIDTH, 1)];
    zanLineView.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    [layoutVied addSubview:zanLineView];
    
    UILabel *zanLabel=[[UILabel alloc]initWithFrame:FRAME(8, zanLineView.frame.origin.y+16, 30, 20)];
    zanLabel.text=@"点赞";
    zanLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    zanLabel.textColor=[UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1];
    [layoutVied addSubview:zanLabel];
    
    NSArray *headArray=[dataDic objectForKey:@"zan_top10"];
    NSLog(@"%@",dataDic);
    NSInteger num;
    NSLog(@"%@",headArray);
    NSLog( @"%lu",(unsigned long)headArray.count);
    if (headArray.count>5) {
        num=5;
    }else{
        num=headArray.count;
    }
    for (int i=0; i<num; i++) {
        NSDictionary *dict=headArray[i];
        UIImageView *headeView=[[UIImageView alloc]init];
        headeView.frame=CGRectMake(48+45*i, zanLineView.frame.origin.y+10, 30, 30);
        //headeView.backgroundColor=[UIColor brownColor];
        // headeView.layer.cornerRadius=headeView.frame.size.width/2;
        NSString *headString=[dict objectForKey:@"head_img"];
        headeView.clipsToBounds = YES;
        NSLog(@"1%@1",headString);
        if ([headString length]==0||[headString length]==1) {
            headeView.image=[UIImage imageNamed:@"家-我_默认头像"];
            headeView.layer.cornerRadius=headeView.frame.size.width/2;
        }else{
            headeView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"head_img"]]]];
            headeView.layer.cornerRadius=headeView.frame.size.width/2;
        }
        
        [layoutVied addSubview:headeView];
        if (i==num-1) {
            UILabel *label=[[UILabel alloc]init];
            label.text=[NSString stringWithFormat:@"共%lu人",(unsigned long)headArray.count];
            label.lineBreakMode=NSLineBreakByTruncatingTail;
            [label setNumberOfLines:1];
            [label sizeToFit];
            label.font=[UIFont fontWithName:@"Heiti SC" size:10];
            label.textColor=[UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1];
            label.frame=FRAME(headeView.frame.size.width+headeView.frame.origin.x+5, headeView.frame.origin.y+5, label.frame.size.width, 20);
            [layoutVied addSubview:label];
        }
    }
       layoutVied.frame=FRAME(0, 0, WIDTH, zanLineView.frame.origin.y+51);
    _scrollView.contentSize=CGSizeMake(WIDTH, layoutVied.frame.size.height+200);
    [self tableViewLayout];
}
#pragma mark详情图片点击方法
-(void)imageButAction:(UIButton *)imageButton
{
    DynamicImageViewController *dyVC=[[DynamicImageViewController alloc]init];
    dyVC.TG=(int)imageButton.tag;
    dyVC.imageArray=[dataDic objectForKey:@"feed_imgs"];
    [self.navigationController pushViewController:dyVC animated:YES];
}
#pragma mark点在按钮点击方法
-(void)praiseButAction
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *dic=@{@"user_id":_manager.telephone,@"fid":_dyNamicID};
    [_download requestWithUrl:DYNAMIC_SHARE dict:dic view:self.view delegate:self finishedSEL:@selector(praiseSuccess:) isPost:YES failedSEL:@selector(praiseFailure:)];
}
#pragma mark动态点赞成功接口返回
-(void)praiseSuccess:(id)dataSource
{
    NSLog(@"点赞成功:%@",dataSource);
    [self Request_data];
}
#pragma mark动态点在失败接口返回
-(void)praiseFailure:(id)dataSource
{
     NSLog(@"点赞失败:%@",dataSource);
}
#pragma mark分享按钮点击方法
-(void)shareButAction
{
    [UMSocialWechatHandler setWXAppId:@"wx93aa45d30bf6cba3" appSecret:@"7a4ec42a0c548c6e39ce9ed25cbc6bd7" url:Handlers];
    [UMSocialQQHandler setQQWithAppId:@"1104934408" appKey:@"bRW2glhUCR6aJYIZ" url:QQHandlerss];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"247547429" RedirectURL:SSOHandlers];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:YMAPPKEY shareText:@"菠萝HR，人事行政必备神器！我们专注“人事行政”的成长与服务！快来体验吧：http://bolohr.com/web" shareImage:[UIImage imageNamed:@"bolohr-logo512.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina,nil] delegate:self];
}
#pragma mark 请求动态详情数据成功
-(void)dataSuccess:(id)dataSource
{
    NSLog(@"动态详情数据获取成功:%@",dataSource);
    dataDic=[dataSource objectForKey:@"data"];
    [self viewLayout];
}
#pragma mark 请求动态详情数据失败
-(void)dataFailure:(id)dataSource
{
    NSLog(@"动态详情数据获取失败:%@",dataSource);
}


-(void)commwntLayout
{
    underView=[[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-49, WIDTH, 49)];
    underView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:underView];
    textView=[[UITextView alloc]initWithFrame:CGRectMake(17/2,9, WIDTH-86, 31)];
    textView.delegate=self;
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    textView.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    textView.layer.borderWidth = 0.6f;
    textView.layer.cornerRadius = 6.0f;
    [underView addSubview:textView];
    
    textViewLabel=[[UILabel alloc]initWithFrame:FRAME(3, 8, WIDTH-39, 15)];
    textViewLabel.text=@"等你来评论...";
    textViewLabel.textColor=[UIColor colorWithRed:164/255.0f green:164/255.0f blue:164/255.0f alpha:1];
    textViewLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    textViewLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [textViewLabel setNumberOfLines:1];
    [textViewLabel sizeToFit];
    [textView addSubview:textViewLabel];
    
    commentButton=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH-60-15/2, 9, 60, 31)];
    commentButton.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [commentButton setTitle:@"评论" forState:UIControlStateNormal];
    commentButton.titleLabel.textColor=[UIColor whiteColor];
    commentButton.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    commentButton.layer.cornerRadius=7;
    //    commentButton.enabled = FALSE;
    [commentButton addTarget:self action:@selector(commentButtonAN) forControlEvents:UIControlEventTouchUpInside];
    
    [underView addSubview:commentButton];
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    int height;
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    height = keyboardRect.size.height;
    underView.frame=CGRectMake(0, HEIGHT-height-49, WIDTH, 49);
}
-(void)viewTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    [self.view endEditing:YES];
    underView.frame=CGRectMake(0, HEIGHT-49, WIDTH, 49);
    [UIView commitAnimations];
    
}

- (void)timerFireMethod:(NSTimer*)theTimer
{
    alertLabel.hidden=YES;
}
-(void)commentButtonAN
{
    NSString *textString=textView.text;
    if(textString==nil||textString==NULL||[textString isKindOfClass:[NSNull class]]||[[textString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        [alertLabel removeFromSuperview];
        alertLabel=[[UILabel alloc]initWithFrame:FRAME((WIDTH-260)/2, underView.frame.origin.y-70, 260, 40)];
        alertLabel.backgroundColor=[UIColor blackColor];
        alertLabel.alpha=0.4;
        alertLabel.text=@"还没有输入评论内容哦～";
        alertLabel.textColor=[UIColor whiteColor];
        alertLabel.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:alertLabel];
        
        [NSTimer scheduledTimerWithTimeInterval:2.0f
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:alertLabel
                                        repeats:NO];
    }else{
        [UIView beginAnimations:nil context:nil];
        //设置动画时长
        [UIView setAnimationDuration:0.5];
        [self.view endEditing:YES];
        underView.frame=CGRectMake(0, HEIGHT-49, WIDTH, 49);
        [UIView commitAnimations];
        //[selfView addSubview:underView];
        ISLoginManager *_manager = [ISLoginManager shareManager];
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *dic=@{@"user_id":_manager.telephone,@"fid":_dyNamicID,@"comment":textView.text};
        [_download requestWithUrl:DYNAMIC_COMMENT dict:dic view:self.view delegate:self finishedSEL:@selector(CommtSuccess:) isPost:YES failedSEL:@selector(CommFailure:)];
        [textView setText:@""];
        
        NSLog(@"text%@",textView.text);
    }
}
#pragma mark评论成功返回方法
-(void)CommtSuccess:(id)commSource
{
    NSLog(@"评论成功:%@",commSource);
    [self commentLayout];
}
#pragma mark评论失败返回方法
-(void)CommFailure:(id)commSource
{
    NSLog(@"评论失败:%@",commSource);
}
- (void)textViewDidChange:(UITextView *)textview
{
    
    if ([textView.text length] == 0) {
        [textViewLabel setHidden:NO];
    }else{
        [textViewLabel setHidden:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 29;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    sectionView.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    UILabel *label=[[UILabel alloc]init];
    label.text=@"评论";
    label.lineBreakMode=NSLineBreakByTruncatingTail;
    [label setNumberOfLines:1];
    [label sizeToFit];
    label.textColor=[UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1];
    label.font=[UIFont fontWithName:@"Heiti SC" size:14];
    label.frame=FRAME(10, 4, label.frame.size.width, 20);
    [sectionView addSubview:label];
    UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 24, WIDTH, 5)];
    view.backgroundColor=[UIColor whiteColor];
    [sectionView addSubview:view];
    
    return sectionView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cellNum;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *plDic=commArray[indexPath.row];
    NSString *CellIdentifier=[NSString stringWithFormat:@"cell%ld",(long)indexPath.row];;
    
    UITableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath]; 
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }else{
        // 删除cell中的子对象,刷新覆盖问题。[color=#FF0000]注明：用这种方式没用，还是错乱[/color]
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    UILabel *nameLabel=[[UILabel alloc]init];
    nameLabel.frame=FRAME(10, 10, 200, 13);
    [cell addSubview:nameLabel];
    nameLabel.text=[NSString stringWithFormat:@"%@",[plDic objectForKey:@"name"]];
    nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
    nameLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
    
    double inTime=[[plDic objectForKey:@"add_time"] doubleValue];
    NSDateFormatter* inTimeformatter =[[NSDateFormatter alloc] init];
    inTimeformatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [inTimeformatter setDateStyle:NSDateFormatterMediumStyle];
    [inTimeformatter setTimeStyle:NSDateFormatterShortStyle];
    [inTimeformatter setDateFormat:@"HH:mm"];
    NSDate* inTimedate = [NSDate dateWithTimeIntervalSince1970:inTime];
    NSString* inTimeString = [inTimeformatter stringFromDate:inTimedate];
    
    UILabel *timeLabel=[[UILabel alloc]init];
    timeLabel.text=inTimeString;
    timeLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
    timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
    timeLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [timeLabel setNumberOfLines:1];
    [timeLabel sizeToFit];
    timeLabel.frame=FRAME(WIDTH-20-timeLabel.frame.size.width, 10, timeLabel.frame.size.width, 13);
    [cell addSubview:timeLabel];
    
    UILabel *textLabel=[[UILabel alloc]init];
    
    textLabel.text=[NSString stringWithFormat:@"%@",[plDic objectForKey:@"comment"]];
    [textLabel setNumberOfLines:0];
    textLabel.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
    CGSize size = [textLabel.text boundingRectWithSize:CGSizeMake(WIDTH-20, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    textLabel.font=[UIFont fontWithName:@"Heiti SC" size:14];
    textLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
    textLabel.frame =CGRectMake(10, nameLabel.frame.size.height+nameLabel.frame.origin.y+7, WIDTH-20, size.height);
    [cell addSubview:textLabel];
    
    UIView *lineView=[[UIView alloc]init];
    lineView.frame=FRAME(0, textLabel.frame.size.height+textLabel.frame.origin.y+9, WIDTH, 1);
    lineView.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    [cell addSubview:lineView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *plDic=commArray[indexPath.row];
    NSString *inforStr = [NSString stringWithFormat:@"%@",[plDic objectForKey:@"comment"]];
    UIFont *font = [UIFont systemFontOfSize:14];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize size = [inforStr boundingRectWithSize:CGSizeMake(WIDTH-20, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size.height+40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
