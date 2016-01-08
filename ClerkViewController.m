//
//  ClerkViewController.m
//  yxz
//
//  Created by 白玉林 on 15/11/12.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "ClerkViewController.h"
#import "BuySecretaryViewController.h"

#import "ISLoginManager.h"
#import "DownloadManager.h"
#import "AppDelegate.h"
@interface ClerkViewController ()
{
    UIActivityIndicatorView *meView;
    int  GAO;
}
@end

@implementation ClerkViewController

@synthesize _tableView,seekArray,sec_Id,secID,is_senior,height,Y,service_type_id;
- (void)viewDidLoad {
    [super viewDidLoad];
    meView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    meView.center = CGPointMake(WIDTH/2, HEIGHT/2);
    meView.color = [UIColor redColor];
    [self.view addSubview:meView];
    [meView startAnimating];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    sec_Id=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"sec_id"]];
    is_senior=[[delegate.globalDic objectForKey:@"is_senior"]intValue];
    NSLog(@"秘书ID %@, 是否有秘书 %d",sec_Id,is_senior);
    [self tableViewSource];
    [self tableViewLayout];
}
-(void)tableViewSource
{
    
    ISLoginManager *_manager = [ISLoginManager shareManager];
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    //NSString *str=[NSString stringWithFormat:@"%ld",(long)service_type_id];
    NSDictionary *_dict = @{@"service_type_ids":service_type_id,@"user_id":_manager.telephone,@"page":@"1"};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:SEEK_FWS dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
}
-(void)logDowLoadFinish:(id)sender
{
    NSLog(@"秘书列表数据%@",sender);
    seekArray=[sender objectForKey:@"data"];
    self.navlabel.text=[NSString stringWithFormat:@"%@",[seekArray[0] objectForKey:@"service_type_name"]];
    NSString *dataString=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    if ([dataString length]==0) {
    }else{
        [_tableView reloadData];
    }
}

-(void)DownFail:(id)sender
{
    NSLog(@"获取秘书列表失败!%@",sender);
}
-(void)tableViewLayout
{
    [_tableView removeFromSuperview];
    _tableView=[[UITableView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    if ([self._tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self._tableView setSeparatorInset:UIEdgeInsetsZero];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
    }
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_tableView setTableFooterView:v];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
        [cell addSubview:lineView];
        
        headImageView.frame=FRAME(10, (GAO-50)/2, 50, 50);
        headImageView.layer.cornerRadius=headImageView.frame.size.width/2;
        headImageView.clipsToBounds = YES;
        [cell addSubview:headImageView];
        
        nameLabel.frame=FRAME(headImageView.frame.origin.x+headImageView.frame.size.width+10, 12, 60, 18);
        nameLabel.font=[UIFont fontWithName:@"Arial" size:16];
        [cell  addSubview:nameLabel];
        
        occupationLabel.frame=FRAME(nameLabel.frame.size.width+nameLabel.frame.origin.x, nameLabel.frame.origin.y+2, WIDTH-210, 16);
        occupationLabel.textColor=[UIColor colorWithRed:100 / 255.0 green:100 / 255.0 blue:100 / 255.0 alpha:1];
        occupationLabel.font=[UIFont fontWithName:@"Arial" size:12];
        [cell addSubview:occupationLabel];
        
        
        textLabel.font=[UIFont fontWithName:@"Arial" size:12];
        textLabel.textColor=[UIColor colorWithRed:100 / 255.0 green:100 / 255.0 blue:100 / 255.0 alpha:1];
        [cell  addSubview:textLabel];
        
        buyLabel.frame=FRAME(WIDTH-70, 12, 60, 18);
        buyLabel.font=[UIFont fontWithName:@"Arial" size:12];
        buyLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
        buyLabel.hidden=YES;
        [cell addSubview:buyLabel];
        
        addressIamge.frame=FRAME(headImageView.frame.size.width+headImageView.frame.origin.x+10, nameLabel.frame.size.height+nameLabel.frame.origin.y+5, 16, 16);
        addressIamge.image=[UIImage imageNamed:@"icon_sec_addr"];
        [cell addSubview:addressIamge];
        addresslabel.font=[UIFont fontWithName:@"Arial" size:12];
        addresslabel.textColor=[UIColor colorWithRed:100 / 255.0 green:100 / 255.0 blue:100 / 255.0 alpha:1];
        [cell addSubview:addresslabel];
        
        timeImage.image=[UIImage imageNamed:@"icon_sec_time"];
        [cell addSubview:timeImage];
        
        timeLabel.font=[UIFont fontWithName:@"Arial" size:12];
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
            typeLabel.font=[UIFont fontWithName:@"Arial" size:12];
            typeLabel.textColor=[UIColor colorWithRed:100 / 255.0 green:100 / 255.0 blue:100 / 255.0 alpha:1];
            typeLabel.layer.cornerRadius=8;
            typeLabel.clipsToBounds=YES;
            typeLabel.textAlignment=NSTextAlignmentCenter;
            typeLabel.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
            [cell addSubview:typeLabel];
            x++;
        }
        
    }
    
    occupationLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_type_name"]];
    occupationLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    buyLabel.text=@"以购买";
    NSLog(@"service_type_id%@",service_type_id);
    if ([service_type_id isEqualToString:@"75"]) {
        if (is_senior==1) {
            secID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"sec_id"]];
            int sec_id=[sec_Id intValue];
            int secid=[secID intValue];
            if (sec_id==secid) {
                buyLabel.hidden=NO;
            }else{
                buyLabel.hidden=YES;
            }
        }

    }
        NSString *headString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"head_img"]];
    if ([headString length]==1||[headString length]==0) {
        headImageView.image =[UIImage imageNamed:@"家-我_默认头像"];
    }else
    {
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"head_img"]];
        [headImageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
    }
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
    
    
    UIFont *font=[UIFont fontWithName:@"Arial" size:12];
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
    NSString *labelString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"weight_type"]];
    UILabel *label=[[UILabel alloc]initWithFrame:FRAME(-18, 5, 60, 15)];
    label.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"weight_type_name"]];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont fontWithName:@"Arial" size:8];
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor redColor];
    label.transform=CGAffineTransformMakeRotation(-M_PI/4);
    if ([labelString isEqualToString:@"1"]) {
        label.hidden=NO;
    }else{
        label.hidden=YES;
    }
    [cell addSubview:label];
    
    cell.clipsToBounds=YES;
    
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        dispatch_async(dispatch_get_main_queue(),^{
            [meView stopAnimating]; // 结束旋转
            [meView setHidesWhenStopped:YES]; //当旋转结束时隐藏
        });
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *plDic=seekArray[indexPath.row];
    NSArray *array=[plDic objectForKey:@"user_tags"];
    UIFont *font=[UIFont fontWithName:@"Arial" size:15];
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
    GAO=size.height+heit;
    return size.height+heit;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic=seekArray[indexPath.row];
    BuySecretaryViewController *vc=[[BuySecretaryViewController alloc]init];
    vc.dic=dic;
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
