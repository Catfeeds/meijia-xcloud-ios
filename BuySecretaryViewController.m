//
//  BuySecretaryViewController.m
//  simi
//
//  Created by 白玉林 on 15/9/15.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "BuySecretaryViewController.h"
#import "PaymentViewController.h"
#import "DownloadManager.h"
#import "VIPLISTBaseClass.h"
#import "BaiduMobStat.h"
#import "ISLoginManager.h"
#import "ImageViewController.h"
#import "WebViewController.h"
#import "ZeroViewController.h"
#import "HomePageTableViewCell.h"
#import "foundWebViewController.h"
#import "DisplayStarView.h"
@interface BuySecretaryViewController ()
{
    VIPLISTBaseClass *_base;
    
    NSArray *timelimitArray;
    NSArray *moneyArray;
    UIView *buyView;
    
    UIView *payView;
    UIScrollView *scrollView;
    NSArray *imageArray;
    UIActivityIndicatorView *actiView;
    int Y;
    NSString *_sec_ID;
    NSDictionary *detailsDic;
    int y_head;
    UITableView *myTableView;
    NSMutableArray *listArray;
    
    
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    int   page;
}

@end

@implementation BuySecretaryViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    actiView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    actiView.center=CGPointMake(WIDTH/2,HEIGHT/2);
    [self.view addSubview:actiView];
    [actiView startAnimating];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void) viewDidAppear:(BOOL)animated
{
    [actiView stopAnimating]; // 结束旋转
    [actiView setHidesWhenStopped:YES]; //当旋转结束时隐藏
//    NSString* cName = [NSString stringWithFormat:@"会员购买", nil];
//    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    
//    NSString* cName = [NSString stringWithFormat:@"会员购买", nil];
//    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    page=1;
    listArray=[[NSMutableArray alloc]init];
    self.navlabel.text=@"详情";
    myTableView =[[UITableView alloc]init];
    myTableView.frame=FRAME(0, 64, WIDTH, HEIGHT-64);
    myTableView.delegate=self;
    myTableView.dataSource=self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [myTableView setTableFooterView:v];
    [self.view addSubview:myTableView];
//    _myview.nameString=_nameString;
//    _myview.textString=_textString;
    NSLog(@"%@",_dic);
    
    _sec_ID=[NSString stringWithFormat:@"%@",[_dic objectForKey:@"user_id"]];
    _service_type_id=[NSString stringWithFormat:@"%@",[_dic objectForKey:@"service_type_id"]];
    NSLog(@"%@",_service_type_id);
    DownloadManager *imageDownload = [[DownloadManager alloc]init];
    NSDictionary *dic=@{@"service_type_id":_service_type_id,@"partner_user_id":_sec_ID};
    [imageDownload requestWithUrl:USER_FWXQ dict:dic view:self.view delegate:self finishedSEL:@selector(imageDown:) isPost:NO failedSEL:@selector(imageFailDown:)];
    // Do any additional setup after loading the view.
    [self listSource];
    
   
}
#pragma mark 服务商-服务人员评价列表接口
-(void)listSource
{
    NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
    DownloadManager *imageDownload = [[DownloadManager alloc]init];
    NSDictionary *dic=@{@"rate_type":@"1",@"link_id":_sec_ID,@"page":pageStr};
    [imageDownload requestWithUrl:FWXQ_RATES dict:dic view:self.view delegate:self finishedSEL:@selector(listDown:) isPost:NO failedSEL:@selector(listFailDown:)];
}
#pragma mark 服务商-服务人员评价列表接口成功
-(void)listDown:(id)source
{
    NSString *senderStr=[NSString stringWithFormat:@"%@",[source objectForKey:@"data"]];
    NSLog(@"%lu",(unsigned long)[senderStr length]);
    
    if (senderStr==nil||senderStr==NULL||[senderStr isEqualToString:@"(\n)"]||[senderStr length]==0) {
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }else{
        if(page==1){
            [listArray removeAllObjects];
        }
        NSLog(@"获取问答列表成功数据%@",source);
        NSArray *array=[source objectForKey:@"data"];
        if (array.count<10) {
            _hasMore=YES;
        }else{
            _hasMore=NO;
        }
        
        for (int i=0; i<array.count; i++) {
            NSDictionary *dict=array[i];
            if ([listArray containsObject:dict]) {
                [listArray removeObject:dict];
                [listArray addObject:dict];
            }else{
                [listArray addObject:dict];
            }
        }
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        
        [myTableView reloadData];
    }

}
#pragma mark 服务商-服务人员评价列表接口失败
-(void)listFailDown:(id)source
{
    NSLog(@"服务商-服务人员评价列表接口失败%@",source);
}
#pragma mark 获取图片成功接口返回方法
-(void)imageDown:(id)sender
{
    NSLog(@"图片数据%@",sender);
    detailsDic=[sender objectForKey:@"data"];
    imageArray=[detailsDic objectForKey:@"user_imgs"];
    timelimitArray=[detailsDic objectForKey:@"service_prices"];

    [self viewLayout];
}
#pragma mark 获取图片失败接口返回方法
-(void)imageFailDown:(id)sender
{
    NSLog(@"%@",sender);
}
#pragma mark 获取成功
- (void)FinishDown:(id)responsobject
{
    NSLog(@"购买的数据%@",responsobject);
    //timelimitArray=[responsobject objectForKey:@"data"];
    //float _height = (_HEIGHT == 480) ? 568 : _HEIGHT;
   
    
}

- (void)FailDown:(id)responsobject
{
    
}
-(void)viewLayout
{
    [payView removeFromSuperview];
    payView=[[UIView alloc]initWithFrame:FRAME(0, 64, _WIDTH, 300+(WIDTH-5)/3)];
    payView.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    //payView.backgroundColor=[UIColor redColor];
    [self.view addSubview:payView];
    
    buyView=[[UIView alloc]initWithFrame:FRAME(0, 6, WIDTH, 70)];
    buyView.backgroundColor=[UIColor whiteColor];
    [payView addSubview:buyView];
    
    UIImageView *headView=[[UIImageView alloc]initWithFrame:FRAME(10, (buyView.frame.size.height-50)/2, 50, 50)];
    NSString *headString=[NSString stringWithFormat:@"%@",[detailsDic objectForKey:@"head_img"]];
    if ([headString length]==1||[headString length]==0) {
        headView.image =[UIImage imageNamed:@"家-我_默认头像"];
        //            headeView.backgroundColor=[UIColor redColor];
    }else
    {
        headView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[detailsDic objectForKey:@"head_img"]]]];
    }

   // headView.image=[UIImage imageNamed:@"家-我_默认头像"];
    headView.layer.cornerRadius=headView.frame.size.width/2;
    headView.clipsToBounds = YES;
    [buyView addSubview:headView];
    
    UILabel *nameLabel=[[UILabel alloc]init];
    nameLabel.text=[NSString stringWithFormat:@"%@",[detailsDic objectForKey:@"name"]];
    nameLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [nameLabel setNumberOfLines:1];
    [nameLabel sizeToFit];
    nameLabel.frame=FRAME(headView.frame.size.width+headView.frame.origin.x+10, 12, 60, 18);
    nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
    [buyView addSubview:nameLabel];
    
    UILabel *occupationLabel=[[UILabel alloc]initWithFrame:FRAME(nameLabel.frame.size.width+nameLabel.frame.origin.x, nameLabel.frame.origin.y+2, WIDTH-210, 16)];
    occupationLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    occupationLabel.textColor=[UIColor colorWithRed:232 / 255.0 green:55 / 255.0 blue:74 / 255.0 alpha:1];
    occupationLabel.text=[NSString stringWithFormat:@"%@",[detailsDic objectForKey:@"service_type_name"]];
    [buyView addSubview:occupationLabel];
    
    UIImageView *addressIamge=[[UIImageView alloc]initWithFrame:FRAME(headView.frame.size.width+headView.frame.origin.x+10, nameLabel.frame.size.height+nameLabel.frame.origin.y+5, 16, 16)];
    addressIamge.image=[UIImage imageNamed:@"icon_sec_addr"];
    [buyView addSubview:addressIamge];
    UILabel *addresslabel=[[UILabel alloc]init];
    addresslabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    addresslabel.textColor=[UIColor colorWithRed:100 / 255.0 green:100 / 255.0 blue:100 / 255.0 alpha:1];
    addresslabel.text=[NSString stringWithFormat:@"%@",[detailsDic objectForKey:@"city_and_region"]];
    addresslabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [addresslabel setNumberOfLines:1];
    [addresslabel sizeToFit];
    addresslabel.frame=FRAME(addressIamge.frame.size.width+addressIamge.frame.origin.x, addressIamge.frame.origin.y, addresslabel.frame.size.width, 16);
    [buyView addSubview:addresslabel];
    UIImageView *timeImage=[[UIImageView alloc]initWithFrame:FRAME(addresslabel.frame.size.width+addresslabel.frame.origin.x+5, addresslabel.frame.origin.y, 16, 16)];
    timeImage.image=[UIImage imageNamed:@"icon_sec_time"];
    [buyView addSubview:timeImage];
    UILabel *timeLabel=[[UILabel alloc]init];
    timeLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    timeLabel.textColor=[UIColor colorWithRed:100 / 255.0 green:100 / 255.0 blue:100 / 255.0 alpha:1];
    timeLabel.text=[NSString stringWithFormat:@"%@",[_dic objectForKey:@"response_time_name"]];
    timeLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [timeLabel setNumberOfLines:1];
    [timeLabel sizeToFit];
    timeLabel.frame=FRAME(timeImage.frame.size.width+timeImage.frame.origin.x, timeImage.frame.origin.y, timeLabel.frame.size.width, 16);
    [buyView addSubview:timeLabel];
    Y=addressIamge.frame.size.height+addressIamge.frame.origin.y+5;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME(headView.frame.size.width+headView.frame.origin.x+10, Y, 16, 16)];
    imageView.image=[UIImage imageNamed:@"iconfont-jinengbiaoqian"];
    [buyView addSubview:imageView];
    NSArray *labelArray=[detailsDic objectForKey:@"user_tags"];
    int s=0;
    for (int i=0; i<labelArray.count; i++) {
        if (i%3==0&&i!=0) {
            Y=Y+21;
            s=0;
        }
        NSDictionary *dict=labelArray[i];
        UILabel *typeLabel=[[UILabel alloc]initWithFrame:FRAME(headView.frame.size.width+headView.frame.origin.x+26+((WIDTH-70-4)/3+2)*s, Y, (WIDTH-70-4)/3, 16)];
        typeLabel.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"tag_name"]];
        typeLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
        typeLabel.textColor=[UIColor colorWithRed:100 / 255.0 green:100 / 255.0 blue:100 / 255.0 alpha:1];
        typeLabel.layer.cornerRadius=8;
        typeLabel.clipsToBounds=YES;
        typeLabel.textAlignment=NSTextAlignmentCenter;
        typeLabel.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
        [buyView addSubview:typeLabel];
        s++;
        
    }

    
    UILabel *textLabel=[[UILabel alloc]init];
    textLabel.text=[NSString stringWithFormat:@"%@",[detailsDic objectForKey:@"introduction"]];
    textLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [textLabel setNumberOfLines:0];
    textLabel.textColor=[UIColor colorWithRed:100 / 255.0 green:100 / 255.0 blue:100 / 255.0 alpha:1];
//    [textLabel sizeToFit];
    UIFont *font=[UIFont fontWithName:@"Heiti SC" size:12];
    CGSize constraint = CGSizeMake(WIDTH-headView.frame.size.width-headView.frame.origin.x-10, 200);
    
    //CGSize size = [_textString sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    //CGSize size=[_textString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    NSString *_textString=[NSString stringWithFormat:@"%@",[_dic objectForKey:@"introduction"]];
    CGSize size = [_textString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    //CGSize size = [textLabel sizeThatFits:CGSizeMake(textLabel.frame.size.width, 45)];
    textLabel.frame=FRAME(headView.frame.size.width+headView.frame.origin.x+10, Y+21, WIDTH-headView.frame.size.width-headView.frame.origin.x-10, size.height);
    textLabel.textColor=[UIColor colorWithRed:103 / 255.0 green:103 / 255.0 blue:103 / 255.0 alpha:1];
    textLabel.font=font;
    [buyView addSubview:textLabel];
    
    DisplayStarView *sv = [[DisplayStarView alloc]initWithFrame:CGRectMake(headView.frame.size.width+headView.frame.origin.x+10, textLabel.frame.origin.y+textLabel.frame.size.height+10, 200, 40)];
    [buyView addSubview:sv];
    float show=[[NSString stringWithFormat:@"%@",[_dic objectForKey:@"total_rate"]]floatValue];
    sv.showStar = show*20;
    
    
    buyView.frame=FRAME(0, 6, WIDTH, textLabel.frame.origin.y+textLabel.frame.size.height+37);
    headView.frame=FRAME(10, (buyView.frame.size.height-50)/2, 50, 50);
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, buyView.frame.size.height+buyView.frame.origin.y, WIDTH, (WIDTH-10)/3)];
    scrollView.contentSize=CGSizeMake(WIDTH/3*imageArray.count, (WIDTH-10)/3);
    scrollView.delegate=self;
    y_head=scrollView.frame.origin.y;
    if (imageArray.count!=0) {
        y_head=scrollView.frame.origin.y+scrollView.frame.size.height;
        [payView addSubview:scrollView];
    }
    
    for (int i=0; i<imageArray.count; i++) {
        NSDictionary *dict=imageArray[i];
        UIButton *imageButton=[[UIButton alloc]init];
        imageButton.frame=CGRectMake(i*((WIDTH-10)/3+5),0, (WIDTH-10)/3, scrollView.frame.size.height);
        imageButton.tag = i;
        [imageButton addTarget:self action:@selector(iamgeButAction:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:imageButton];
        
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:FRAME(0, 0,imageButton.frame.size.width , imageButton.frame.size.height)];
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[dict objectForKey:@"img_trumb"]];
        [imgView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
//        imgView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"img_trumb"]]]];
        [imageButton addSubview:imgView];
    }
    for (int s=0; s<timelimitArray.count; s++) {
        NSDictionary *dic=timelimitArray[s];
        UIButton *button=[[UIButton alloc]initWithFrame:FRAME(0, y_head+10+100*s, WIDTH, 100)];
        button.tag=s;
        [button addTarget:self action:@selector(listButAction:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor=[UIColor whiteColor];
        [payView addSubview:button];
        UIImageView *_headeImageVIew=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-105, 15, 95, 70)];
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"img_url"]];
        [_headeImageVIew setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
        [button addSubview:_headeImageVIew];
        _headeImageVIew.layer.shadowColor = [UIColor blackColor].CGColor;
        _headeImageVIew.layer.shadowOffset = CGSizeMake(0, 0);
        _headeImageVIew.layer.shadowOpacity = 0.3;
        //        _headeImageVIew.layer.shadowRadius = 10.0;
        NSString *dayString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        UILabel*_titleLabel=[[UILabel alloc]initWithFrame:FRAME(10, 10, WIDTH-(_headeImageVIew.frame.size.width+25), 16)];
        _titleLabel.text=[NSString stringWithFormat:@"%@",dayString];
        _titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:16];
        [button addSubview:_titleLabel];
        
        UILabel *_fTitleLabel=[[UILabel alloc]initWithFrame:FRAME(10, 30, WIDTH-(_headeImageVIew.frame.size.width+25), 30)];
        _fTitleLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_title"]];
        _fTitleLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
        _fTitleLabel.textColor=[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
        [button addSubview:_fTitleLabel];
        
        UILabel *_subTitleLabel=[[UILabel alloc]initWithFrame:FRAME(10, 70, WIDTH-(_headeImageVIew.frame.size.width+25), 20)];
        _subTitleLabel.text=[NSString stringWithFormat:@"￥%@",[dic objectForKey:@"dis_price"]];
        _subTitleLabel.font=[UIFont fontWithName:@"Heiti SC" size:20];
        _subTitleLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
        [button addSubview:_subTitleLabel];
        UIView *lineView=[[UIView alloc]initWithFrame:FRAME(0, 99, WIDTH, 1)];
        lineView.backgroundColor=[UIColor colorWithRed:215/255.0f green:215/255.0f blue:215/255.0f alpha:1];
        [button addSubview:lineView];

    }
    payView.frame=FRAME(0, 64, _WIDTH, y_head+100*timelimitArray.count+10);
    myTableView.tableHeaderView=payView;
}
-(void)listButAction:(UIButton *)button
{
    int cardTypeId;
    NSString *typeID=[NSString stringWithFormat:@"%ld",(long)button.tag];
    int cardId=[typeID intValue];
    cardTypeId=cardId+1;
    foundWebViewController *_controller = [[foundWebViewController alloc]init];
    _controller.moneystring = @"0";
    NSDictionary *dic=timelimitArray[button.tag];
    NSString *dayString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    _controller.buyString=dayString;
    _controller.moneyStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"dis_price"]];
    _controller.cardTypeID=cardTypeId;
    _controller.service_type_id=_service_type_id;
    _controller.service_price_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_price_id"]];
    _controller.sec_ID=_sec_ID;
    _controller.addssID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"is_addr"]];
    _controller.zeroDic=dic;
    _controller.imgurl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"detail_url"]];
    _controller.goto_type=@"h5+list";
    _controller.titleName=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    NSString  *str=[NSString stringWithFormat:@"%@",[dic objectForKey:@"detail_url"]];
    if (str==nil||str==NULL||[str isEqualToString:@""]) {
        
    }else{
        [self.navigationController pushViewController:_controller animated:YES];
        
    }

}
-(void)buttonAction:(UIButton *)sender
{
    NSDictionary *dic=timelimitArray[sender.tag-10];
    NSLog(@"sender%ld",(long)sender.tag);
    WebViewController *webView=[[WebViewController alloc]init];
    webView._weburl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"detail_url"]];
    [self.navigationController pushViewController:webView animated:YES];
    if (sender.tag==10) {
        NSLog(@"99元帮助");
    }else if (sender.tag==11){
        NSLog(@"399元帮助");
    }else if (sender.tag==12){
        NSLog(@"999元帮助");
    }
}

-(void)iamgeButAction:(UIButton *)sender
{
    
    NSString *offtag=[NSString stringWithFormat:@"%ld",(long)sender.tag];
    int off=[offtag intValue];
    ImageViewController *imgVc=[[ImageViewController alloc]init];
    imgVc.offSet=off;
    imgVc.sec_ID=_sec_ID;
    [self.navigationController pushViewController:imgVc animated:YES];
}
-(void)buyAction:(UIButton *)sender
{
    int cardTypeId;
    NSString *typeID=[NSString stringWithFormat:@"%ld",(long)sender.tag];
    int cardId=[typeID intValue];
    cardTypeId=cardId+1;
    PaymentViewController *_controller = [[PaymentViewController alloc]init];
    _controller.moneystring = @"0";
    NSDictionary *dic=timelimitArray[sender.tag];
    NSString *dayString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    _controller.buyString=dayString;
    _controller.moneyStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"dis_price"]];
    _controller.cardTypeID=cardTypeId;
    _controller.service_type_id=_service_type_id;
    _controller.service_price_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_price_id"]];
    _controller.sec_ID=_sec_ID;
    _controller.addssID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"is_addr"]];
    if ([_controller.moneyStr isEqualToString:@"0"]) {
        ZeroViewController *zerVC=[[ZeroViewController alloc]init];
        zerVC.textString=_controller.buyString;
        zerVC.zeroDic=dic;
        zerVC.service_type_id=_service_type_id;
        zerVC.sec_ID=_sec_ID;
        [self.navigationController pushViewController:zerVC animated:YES];
    }else{
        [self.navigationController pushViewController:_controller animated:YES];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic=listArray[indexPath.row];
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    UIImageView *heigheImag=[[UIImageView alloc]initWithFrame:FRAME(10, 10, 40, 40)];
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"head_img"]];
    [heigheImag setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
    heigheImag.layer.cornerRadius=heigheImag.frame.size.width/2;
    heigheImag.clipsToBounds=YES;
    [cell addSubview:heigheImag];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:FRAME(20+heigheImag.frame.size.width, 20, WIDTH-(20+heigheImag.frame.size.width), 20)];
    nameLabel.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    nameLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    [cell addSubview:nameLabel];
    
    UILabel *textLabel=[[UILabel alloc]init];
    textLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"rate_content"]];
    textLabel.textColor=[UIColor colorWithRed:53/255.0f green:53/255.0f blue:53/255.0f alpha:1];
    UIFont *font=[UIFont fontWithName:@"Heiti SC" size:15];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize size = [textLabel.text boundingRectWithSize:CGSizeMake(WIDTH-20, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    textLabel.frame=FRAME(10, heigheImag.frame.size.height+20, WIDTH-20, size.height);
    [cell addSubview:textLabel];
    
    UIView *lineView=[[UIView alloc]initWithFrame:FRAME(0, textLabel.frame.origin.y+size.height+10, WIDTH, 0.5)];
    lineView.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    [cell addSubview:lineView];
    return cell;
}
#pragma mark - 列表组头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40;
    
}
#pragma mark  列表组头view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, WIDTH, 40)];
    sectionView.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    UIView *view=[[UIView alloc]initWithFrame:FRAME(10, 10, 2, 20)];
    view.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [sectionView addSubview:view];
    UILabel *label=[[UILabel alloc]init];
    label.text=@"用户评价";
    label.lineBreakMode=NSLineBreakByTruncatingTail;
    [label setNumberOfLines:1];
    [label sizeToFit];
    label.textColor=[UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1];
    label.font=[UIFont fontWithName:@"Heiti SC" size:14];
    label.frame=FRAME(20, 10, label.frame.size.width, 20);
    [sectionView addSubview:label];
    
    return sectionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=listArray[indexPath.row];
    NSString *string=[NSString stringWithFormat:@"%@",[dic objectForKey:@"rate_content"]];
    UIFont *font=[UIFont fontWithName:@"Heiti SC" size:15];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize size = [string boundingRectWithSize:CGSizeMake(WIDTH-20, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return 71+size.height;
}
#pragma mark 列表点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [myTableView deselectRowAtIndexPath:indexPath animated:NO];
    

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
    
    [self listSource];
    
    
    
}
#pragma mark 表格刷新相关
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
