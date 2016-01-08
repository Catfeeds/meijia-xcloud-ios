//
//  SeekViewController.m
//  simi
//
//  Created by 白玉林 on 15/9/15.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "SeekViewController.h"
#import "BuySecretaryViewController.h"

#import "ISLoginManager.h"
#import "DownloadManager.h"
#import "AppDelegate.h"
@interface SeekViewController ()
{
    NSArray *seekArray;
    NSArray *textArray;
    NSString *sec_Id;
    NSString *secID;
    int is_senior;
    int height;
    int Y;
    //BuySecretaryView *buyString;
}
@end

@implementation SeekViewController
@synthesize _tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    sec_Id=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"sec_id"]];
    is_senior=[[delegate.globalDic objectForKey:@"is_senior"]intValue];
    NSLog(@"秘书ID %@, 是否有秘书 %d",sec_Id,is_senior);
    self.navlabel.text=@"秘书和助理";
    seekArray=@[@"小茶",@"安妮",@"Mary"];
    textArray=@[@"擅长Office办公软件,外语听说读写",@"擅长文案编写,外语听说读写",@"擅长协作沟通,外语听说读写"];
    //buyString=[[BuySecretaryView alloc]init];
    [self tableViewSource];
    // Do any additional setup after loading the view.
}
-(void)tableViewSource
{
    
    ISLoginManager *_manager = [ISLoginManager shareManager];
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict = @{@"service_type_ids":@"75,180",@"user_id":_manager.telephone,@"page":@"1"};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:SEEK_FWS dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
}
-(void)logDowLoadFinish:(id)sender
{
    UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    view.hidden=YES;
    UILabel *viewLabel=[[UILabel alloc]initWithFrame:FRAME(20, 30, WIDTH-40, 20)];
    viewLabel.text=@"目前还没有人注册秘书";
    viewLabel.textColor=[UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1];
    [view addSubview:viewLabel];
    [self.view addSubview:view];
    NSLog(@"秘书列表数据%@",sender);
    seekArray=[sender objectForKey:@"data"];
    NSString *dataString=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    if ([dataString length]==0) {
        view.hidden=NO;
    }else{
        view.height=YES;
        [self tableViewLayout];
    }
    
    
}
-(void)DownFail:(id)sender
{
    NSLog(@"获取秘书列表失败!%@",sender);
}
-(void)tableViewLayout
{
    _tableView=[[UITableView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
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
    NSString *identifier = [NSString stringWithFormat:@"（%ld,%ld)",(long)indexPath.row,(long)indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
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
        [cell addSubview:lineView];
        
        headImageView.frame=FRAME(10, 10, 50, 50);
        headImageView.layer.cornerRadius=headImageView.frame.size.width/2;
        headImageView.clipsToBounds = YES;
        [cell addSubview:headImageView];
        
        nameLabel.frame=FRAME(headImageView.frame.origin.x+headImageView.frame.size.width+10, 12, 60, 18);
//        nameLabel.backgroundColor=[UIColor redColor];
        nameLabel.font=[UIFont fontWithName:@"Arial" size:16];
        [cell  addSubview:nameLabel];
        
        occupationLabel.frame=FRAME(nameLabel.frame.size.width+nameLabel.frame.origin.x, nameLabel.frame.origin.y+2, WIDTH-210, 16);
        occupationLabel.font=[UIFont fontWithName:@"Arial" size:14];
        [cell addSubview:occupationLabel];
        
        
        textLabel.font=[UIFont fontWithName:@"Arial" size:14];
        textLabel.textColor=[UIColor colorWithRed:103 / 255.0 green:103 / 255.0 blue:103 / 255.0 alpha:1];
        [cell  addSubview:textLabel];
        
        buyLabel.frame=FRAME(WIDTH-70, 12, 60, 18);
        buyLabel.font=[UIFont fontWithName:@"Arial" size:14];
        buyLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
        buyLabel.hidden=YES;
        [cell addSubview:buyLabel];
        
        addressIamge.frame=FRAME(headImageView.frame.size.width+headImageView.frame.origin.x+10, nameLabel.frame.size.height+nameLabel.frame.origin.y+5, 16, 16);
        addressIamge.image=[UIImage imageNamed:@"icon_sec_addr"];
        [cell addSubview:addressIamge];
        addresslabel.font=[UIFont fontWithName:@"Arial" size:12];
        [cell addSubview:addresslabel];
        
        timeImage.image=[UIImage imageNamed:@"icon_sec_time"];
        [cell addSubview:timeImage];
        
        timeLabel.font=[UIFont fontWithName:@"Arial" size:12];
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
            typeLabel.layer.cornerRadius=8;
            typeLabel.clipsToBounds=YES;
            typeLabel.textAlignment=NSTextAlignmentCenter;
            typeLabel.backgroundColor=[UIColor colorWithRed:248/255.0f green:205/255.0f blue:102/255.0f alpha:1];
            [cell addSubview:typeLabel];
            x++;
        }

    }
    
        occupationLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_type_name"]];
    buyLabel.text=@"以购买";
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
    NSString *headString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"head_img"]];
    if ([headString length]==1||[headString length]==0) {
        headImageView.image =[UIImage imageNamed:@"家-我_默认头像"];
        //            headeView.backgroundColor=[UIColor redColor];
    }else
    {
        headImageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"head_img"]]]];
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
    
    
    UIFont *font=[UIFont fontWithName:@"Arial" size:15];
    CGSize constraint = CGSizeMake(WIDTH-90, 200.0f);
    
    textLabel.lineBreakMode=NSLineBreakByWordWrapping;
    [textLabel setNumberOfLines:0];
    textLabel.text=[NSString stringWithFormat:@"简介:%@",[dic objectForKey:@"introduction"]];
     NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size = [textLabel.text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    textLabel.frame=FRAME(headImageView.frame.origin.x+headImageView.frame.size.width+10, Y+21, WIDTH-80, size.height);
    textLabel.font=font;
    height=Y+31;
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
    return size.height+heit;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic=seekArray[indexPath.row];
    BuySecretaryViewController *vc=[[BuySecretaryViewController alloc]init];
    vc.dic=dic;
    vc.service_type_id=@"75";
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
