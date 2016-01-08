//
//  Order_ListViewController.m
//  yxz
//
//  Created by 白玉林 on 15/11/14.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "Order_ListViewController.h"
#import "Order_DetailsViewController.h"
#import "OrderPayViewController.h"
@interface Order_ListViewController ()
{
    NSArray *orderArray;
    NSMutableArray *imageArray;
    UIActivityIndicatorView *indicatorView;
}

@end

@implementation Order_ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imageArray=[[NSMutableArray alloc]init];
    self.view.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    self.navlabel.text=@"订单";
    ISLoginManager *_manager = [ISLoginManager shareManager];
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *dic=@{@"user_id":_manager.telephone,@"page":@"1"};
    [_download requestWithUrl:ORDER_DDLB dict:dic view:self.view delegate:self finishedSEL:@selector(ORder_GetUserInfo:) isPost:NO failedSEL:@selector(ORder_FailDownload:)];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    indicatorView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.center = CGPointMake(WIDTH/2, HEIGHT/2);
    //indicatorView.color = [UIColor redColor];
    [self.view addSubview:indicatorView];
    [indicatorView startAnimating];

}
-(void)viewDidAppear:(BOOL)animated
{
    [indicatorView stopAnimating]; // 结束旋转
    [indicatorView setHidesWhenStopped:YES]; //当旋转结束时隐藏

}
#pragma mark 订单列表获取数据成功返回方法
-(void)ORder_GetUserInfo:(id)sender
{
    NSLog(@"订单列表数据%@",sender);
    orderArray=[sender objectForKey:@"data"];
    [imageArray removeLastObject];
    for (int i=0; i<orderArray.count; i++) {
        NSDictionary *dic=orderArray[i];
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"partner_user_head_img"]]]];
        CGSize newSize=CGSizeMake(40, 40);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [imageArray addObject:image];
    }
    _orderTableView=[[UITableView alloc]initWithFrame:FRAME(0, 80, WIDTH, HEIGHT-80)];
    _orderTableView.dataSource=self;
    _orderTableView.delegate=self;
    [self.view addSubview:_orderTableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_orderTableView setTableFooterView:v];
}
#pragma mark 订单列表获取数据失败返回方法
-(void)ORder_FailDownload:(id)sender
{
    NSLog(@"获取订单列表失败%@",sender);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return orderArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *orderDic=orderArray[indexPath.row];
    static NSString *identifier = @"cell";
    UIImageView *heagImageView=[[UIImageView alloc]init];
    UILabel *cateGroyLabel=[[UILabel alloc]init];
    UIImageView *timeImageView=[[UIImageView alloc]init];
    UILabel *timeLabel=[[UILabel alloc]init];
    UIImageView *addressImageView=[[UIImageView alloc]init];
    UILabel *addressLabel=[[UILabel alloc]init];
    UIButton *stateButton=[[UIButton alloc]init];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
        
        
        heagImageView.frame=FRAME(10, 10, 40, 40);
        heagImageView.layer.cornerRadius=heagImageView.frame.size.width/2;
        heagImageView.clipsToBounds = YES;
        //heagImageView.backgroundColor=[UIColor redColor];
        [cell addSubview:heagImageView];
        
        cateGroyLabel.frame=FRAME(heagImageView.frame.size.width+heagImageView.frame.origin.x+5, 10, WIDTH-125, 16);
        //cateGroyLabel.backgroundColor=[UIColor redColor];
        [cell addSubview:cateGroyLabel];
        
        timeImageView.frame=FRAME(10+25/2, heagImageView.frame.origin.y+heagImageView.frame.size.height+5, 15, 15);
        timeImageView.image=[UIImage imageNamed:@"iconfont-time"];
        [cell addSubview:timeImageView];
        
        timeLabel.frame=FRAME(timeImageView.frame.size.width+timeImageView.frame.origin.x+10, timeImageView.frame.origin.y, WIDTH-55, 15);
        //timeLabel.backgroundColor=[UIColor redColor];
        [cell addSubview:timeLabel];
        
        addressImageView.frame=FRAME(timeImageView.frame.origin.x, timeImageView.frame.origin.y+20, 15, 15);
        addressImageView.image=[UIImage imageNamed:@"iconfont-jikediancanicon28"];
        [cell addSubview:addressImageView];
        
        addressLabel.frame=FRAME(addressImageView.frame.origin.x+addressImageView.frame.size
                                 .width+10, addressImageView.frame.origin.y, WIDTH-55, 15);
        //addressLabel.backgroundColor=[UIColor redColor];
        [cell addSubview:addressLabel];
        
        stateButton.frame=FRAME(WIDTH-70, 10+15/2, 60, 25);
        //stateButton.backgroundColor=[UIColor redColor];
        [stateButton.layer setMasksToBounds:YES];
        
        [stateButton.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
        
        [stateButton.layer setBorderWidth:1.0];   //边框宽度
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
        stateButton.tag=indexPath.row;
        [stateButton addTarget:self action:@selector(stateButAction:) forControlEvents:UIControlEventTouchUpInside];
        [stateButton.layer setBorderColor:colorref];//边框颜色
        [cell addSubview:stateButton];
        
    }else{
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    
    heagImageView.image=imageArray[indexPath.row];
    NSString *service_type_name=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"service_type_name"]];
    NSString *order_money=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"order_pay"]];
    cateGroyLabel.text=[NSString stringWithFormat:@"%@:%@",service_type_name,order_money];
    cateGroyLabel.font=[UIFont fontWithName:@"Arial" size:16];
    
    timeLabel.text=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"add_time_str"]];
    timeLabel.font=[UIFont fontWithName:@"Arial" size:12];
    
    addressLabel.text=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"addr_name"]];
    addressLabel.font=[UIFont fontWithName:@"Arial" size:12];
    
//    [stateButton setTitle:[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"order_status_name"]] forState:UIControlStateNormal];
    UILabel *stateLabel=[[UILabel alloc]initWithFrame:FRAME(5, 5, 50, 15)];
    stateLabel.text=[NSString stringWithFormat:@"%@",[orderDic objectForKey:@"order_status_name"]];
    int  order_status=[[orderDic objectForKey:@"order_status"]intValue];
    if (order_status==1) {
        stateButton.enabled=TRUE;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
        [stateButton.layer setBorderColor:colorref];//边框颜色
        stateButton.backgroundColor=[UIColor whiteColor];
    }else{
        stateButton.enabled=FALSE;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 180, 180, 180, 1 });
        [stateButton.layer setBorderColor:colorref];//边框颜色

        stateButton.backgroundColor=[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
    }
    stateLabel.font=[UIFont fontWithName:@"Arial" size:14];
    stateLabel.textAlignment=NSTextAlignmentCenter;
    [stateButton addSubview:stateLabel];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic=orderArray[indexPath.row];
    Order_DetailsViewController *vc=[[Order_DetailsViewController alloc]init];
    vc.dic=dic;
    vc.details_ID=2;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)stateButAction:(UIButton *)sender
{
    NSDictionary *dic=orderArray[sender.tag];
    OrderPayViewController *payVC=[[OrderPayViewController alloc]init];
    payVC.buyString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_content"]];
    payVC.orderStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"order_no"]];
    payVC.moneyStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"order_pay"]];
    payVC.orderVCID=1;
    payVC.addssID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"is_addr"]];
    payVC.user_ID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"user_id"]];
    payVC.order_ID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"order_id"]];
    payVC.orderPayDic=dic;
    [self.navigationController pushViewController:payVC animated:YES];
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (round - indexPath.row < 10 && !updating) { updating = YES; [self update]; }
//}
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
////    if (!decelerate) { queue.maxConcurrentOperationCount = 5; } } - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView { queue.maxConcurrentOperationCount = 5; } - (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView { queue.maxConcurrentOperationCount = 2;
//}
//- (void)drawRect:(CGRect)rect {
////    if (image) { [image drawAtPoint:imagePoint]; self.image = nil; } else { [placeHolder drawAtPoint:imagePoint]; } [text drawInRect:textRect withFont:font lineBreakMode:UILineBreakModeTailTruncation];
//}
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
