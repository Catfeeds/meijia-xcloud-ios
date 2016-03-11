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
    
}

@end

@implementation BuySecretaryViewController
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    actiView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    actiView.center=CGPointMake(WIDTH/2,HEIGHT/2);
    [self.view addSubview:actiView];
    [actiView startAnimating];
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
    self.navlabel.text=@"详情";
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
    nameLabel.font=[UIFont fontWithName:@"Arial" size:16];
    [buyView addSubview:nameLabel];
    
    UILabel *occupationLabel=[[UILabel alloc]initWithFrame:FRAME(nameLabel.frame.size.width+nameLabel.frame.origin.x, nameLabel.frame.origin.y+2, WIDTH-210, 16)];
    occupationLabel.font=[UIFont fontWithName:@"Arial" size:12];
    occupationLabel.textColor=[UIColor colorWithRed:232 / 255.0 green:55 / 255.0 blue:74 / 255.0 alpha:1];
    occupationLabel.text=[NSString stringWithFormat:@"%@",[detailsDic objectForKey:@"service_type_name"]];
    [buyView addSubview:occupationLabel];
    
    UIImageView *addressIamge=[[UIImageView alloc]initWithFrame:FRAME(headView.frame.size.width+headView.frame.origin.x+10, nameLabel.frame.size.height+nameLabel.frame.origin.y+5, 16, 16)];
    addressIamge.image=[UIImage imageNamed:@"icon_sec_addr"];
    [buyView addSubview:addressIamge];
    UILabel *addresslabel=[[UILabel alloc]init];
    addresslabel.font=[UIFont fontWithName:@"Arial" size:12];
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
    timeLabel.font=[UIFont fontWithName:@"Arial" size:12];
    timeLabel.textColor=[UIColor colorWithRed:100 / 255.0 green:100 / 255.0 blue:100 / 255.0 alpha:1];
    timeLabel.text=[NSString stringWithFormat:@"%@",[_dic objectForKey:@"response_time_name"]];
    timeLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [timeLabel setNumberOfLines:1];
    [timeLabel sizeToFit];
    timeLabel.frame=FRAME(timeImage.frame.size.width+timeImage.frame.origin.x, timeImage.frame.origin.y, timeLabel.frame.size.width, 16);
    [buyView addSubview:timeLabel];
    Y=addressIamge.frame.size.height+addressIamge.frame.origin.y+5;
    NSArray *labelArray=[detailsDic objectForKey:@"user_tags"];
    int s=0;
    for (int i=0; i<labelArray.count; i++) {
        if (i%3==0&&i!=0) {
            Y=Y+21;
            s=0;
        }
        NSDictionary *dict=labelArray[i];
        UILabel *typeLabel=[[UILabel alloc]initWithFrame:FRAME(headView.frame.size.width+headView.frame.origin.x+10+((WIDTH-70-4)/3+2)*s, Y, (WIDTH-70-4)/3, 16)];
        typeLabel.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"tag_name"]];
        typeLabel.font=[UIFont fontWithName:@"Arial" size:12];
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
    UIFont *font=[UIFont fontWithName:@"Arial" size:12];
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
    
    buyView.frame=FRAME(0, 6, WIDTH, textLabel.frame.origin.y+textLabel.frame.size.height+17);
    headView.frame=FRAME(10, (buyView.frame.size.height-50)/2, 50, 50);
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, buyView.frame.size.height+buyView.frame.origin.y, WIDTH, (WIDTH-10)/3)];
    scrollView.contentSize=CGSizeMake(WIDTH/3*imageArray.count, (WIDTH-10)/3);
    scrollView.delegate=self;
    y_head=scrollView.frame.origin.y+scrollView.frame.size.height;
    if (imageArray.count!=0) {
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

    for (int i=0; i<timelimitArray.count; i++) {
        NSDictionary *dic=timelimitArray[i];
        NSString *dayString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        int H;
        if (imageArray.count==0) {
            H=0;
        }else{
            H=(WIDTH-5)/3;
        }
        UIButton *view=[[UIButton alloc]initWithFrame:FRAME(0, buyView.frame.size.height+buyView.frame.origin.y+10+H+51*i, WIDTH, 50)];
        view.backgroundColor=[UIColor whiteColor];
        [payView addSubview:view];
        UILabel *timeLabel=[[UILabel alloc]init];
        timeLabel.text=[NSString stringWithFormat:@"%@:%@.0元",dayString,[dic objectForKey:@"dis_price"]];
        timeLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        [timeLabel setNumberOfLines:1];
        [timeLabel sizeToFit];
        //timeLabel.backgroundColor=[UIColor redColor];
        timeLabel.frame=FRAME(10, 15, timeLabel.frame.size.width, 20);
        timeLabel.font=[UIFont fontWithName:@"Arial" size:15];
        //timeLabel.backgroundColor=[UIColor brownColor];
        [view addSubview:timeLabel];
        
        UIButton *buyButton=[[UIButton alloc]init];
        buyButton.frame=FRAME(WIDTH-70, 10, 60, 30);
        [buyButton setTitle:@"购买" forState:UIControlStateNormal];
        buyButton.tag=i;
        buyButton.layer.cornerRadius=6;
        [buyButton addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
        [buyButton setTitleColor:[UIColor colorWithRed:232 / 255.0 green:55 / 255.0 blue:74 / 255.0 alpha:1] forState:UIControlStateNormal];
        buyButton.layer.masksToBounds=YES;
        buyButton.layer.borderColor = [[UIColor colorWithRed:232 / 255.0 green:55 / 255.0 blue:74 / 255.0 alpha:1] CGColor];
        buyButton.layer.borderWidth= 1.0f;
        [view addSubview:buyButton];
        
        view.tag=10+i;
        if (i==timelimitArray.count-1) {
            y_head=view.frame.size.height+view.frame.origin.y;
        }
        [view addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:button];
        
        
    }
    payView.frame=FRAME(0, 64, _WIDTH, y_head);
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
