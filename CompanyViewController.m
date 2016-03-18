//
//  CompanyViewController.m
//  yxz
//
//  Created by 白玉林 on 15/12/7.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "CompanyViewController.h"
#import "MeetTableViewCell.h"
#import "FriendsHomeViewController.h"
@interface CompanyViewController ()
{
    NSArray *companyArray;
    UITableView *myTableView;
    NSMutableArray *imageArray;
    UIView *qrCodeView;
}
@end
@implementation CompanyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navlabel.text=_nameString;
    imageArray=[[NSMutableArray alloc]init];
    _mutableArray=[[NSMutableArray alloc]init];
    [_mutableArray addObjectsFromArray:_dataMutableArray];
    _nameArray=[[NSMutableArray alloc]init];
    [_nameArray addObjectsFromArray:_dataNameArray];
    _mobileArray=[[NSMutableArray alloc]init];
    [_mobileArray addObjectsFromArray:_dataMobileArray];
    _idArray=[[NSMutableArray alloc]init];
    [_idArray addObjectsFromArray:_dataIdArray];
    _theNumber=(int)_nameArray.count;
    
    UIButton *reBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH-50, 20, 50, 44)];
    [reBut addTarget:self action:@selector(reButAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reBut];
    UIImageView *butImage=[[UIImageView alloc]initWithFrame:FRAME(13, 10, 24, 24)];
    butImage.image=[UIImage imageNamed:@"company_rqi"];
    [reBut addSubview:butImage];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSLog(@"有值么%@",_manager.telephone);
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *companyString=[NSString stringWithFormat:@"%@",[_companyDic objectForKey:@"company_id"]];
    NSDictionary *_dict=@{@"user_id":_manager.telephone,@"company_id":companyString};
    [_download requestWithUrl:ENTERPRISE_STAFF dict:_dict view:self.view delegate:self finishedSEL:@selector(CompanySuccess:) isPost:NO failedSEL:@selector(CompanyFailure:)];
    DownloadManager *download = [[DownloadManager alloc]init];
    [download requestWithUrl:WAGE_ORCODE dict:_dict view:self.view delegate:self finishedSEL:@selector(DetailsSuccess:) isPost:NO failedSEL:@selector(DetailsFailure:)];
    // Do any additional setup after loading the view.
}
-(void)DetailsSuccess:(id)sender
{
    NSLog(@"就看看哈说的话%@",sender);
    [qrCodeView removeFromSuperview];
    qrCodeView=[[UIView alloc]initWithFrame:FRAME(WIDTH, 0, WIDTH, HEIGHT-50)];
    qrCodeView.backgroundColor=[UIColor whiteColor];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapQRActiion)];
    tap.delegate=self;
    tap.cancelsTouchesInView=YES;
    [qrCodeView addGestureRecognizer:tap];
    UIButton *returnBut=[[UIButton alloc]initWithFrame:FRAME(0, 20, 70, 40)];
    [returnBut addTarget:self action:@selector(tapQRActiion) forControlEvents:UIControlEventTouchUpInside];
    [qrCodeView addSubview:returnBut];
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 10, 20)];
    img.image = [UIImage imageNamed:@"title_left_back"];
    [returnBut addSubview:img];
    UILabel *textLabel=[[UILabel alloc]initWithFrame:FRAME(10, (qrCodeView.frame.size.height-(WIDTH-60))/2-28, WIDTH-20, 18)];
    textLabel.text=@"企业二维码名片";
    textLabel.textAlignment=NSTextAlignmentCenter;
    textLabel.font=[UIFont fontWithName:@"Arial" size:16];
    [qrCodeView addSubview:textLabel];
    UIImageView *qrImageView=[[UIImageView alloc]initWithFrame:FRAME(30, (qrCodeView.frame.size.height-(WIDTH-60))/2, WIDTH-60, WIDTH-60)];
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[[sender objectForKey:@"data"] objectForKey:@"qrCode"]];
    [qrImageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
    [qrCodeView addSubview:qrImageView];
    UILabel *explainLabel=[[UILabel alloc]initWithFrame:FRAME(10, qrImageView.frame.size.height+qrImageView.frame.origin.y+30, WIDTH-20, 20)];
    explainLabel.text=@"点击任意处可退出";
    explainLabel.textAlignment=NSTextAlignmentCenter;
    explainLabel.font=[UIFont fontWithName:@"Arial" size:18];
    explainLabel.textColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    [qrCodeView addSubview:explainLabel];
    [self.view addSubview:qrCodeView];
}
-(void)DetailsFailure:(id)sender
{
}
-(void)tapQRActiion
{
    qrCodeView.frame=FRAME(WIDTH, 0, WIDTH, HEIGHT);
}
-(void)reButAction
{
    qrCodeView.frame=FRAME(0, 0, WIDTH, HEIGHT);
    [self.view addSubview:qrCodeView];
}
#pragma mark 用户企业员工列表成功返回
-(void)CompanySuccess:(id)sender
{
    NSLog(@"用户所属企业列表数据%@",sender);
    companyArray=[sender objectForKey:@"data"];
    [self tableViewLayout];
}
#pragma mark 用户企业员工列表失败返回
-(void)CompanyFailure:(id)sender
{
}
-(void)tableViewLayout
{
    [myTableView removeFromSuperview];
    myTableView =[[UITableView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    myTableView.dataSource=self;
    myTableView.delegate=self;
    if (_companyVcId==10) {
        [myTableView registerNib:[UINib nibWithNibName:@"MeetTableViewCell" bundle:nil] forCellReuseIdentifier:@"MeetTableViewCell"];
    }
    [self.view addSubview:myTableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [myTableView setTableFooterView:v];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//指定每个分区中有多少行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return companyArray.count;
}
//绘制Cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    if (_companyVcId==10) {
        identifier =@"MeetTableViewCell";
    }else{
        identifier = [NSString stringWithFormat:@"（%ld,%ld)",(long)indexPath.row,(long)indexPath.section];
    }
    if (_companyVcId==10) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        UILabel *contactNameLabel = (UILabel *)[cell viewWithTag:101];
        UIImageView *contactImage = (UIImageView *)[cell viewWithTag:103];
        UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        contactNameLabel.frame=FRAME(70, 20, WIDTH-110, 20);
        contactImage.clipsToBounds=YES;   
        contactImage.layer.cornerRadius=20;
        checkboxImageView.frame=FRAME(WIDTH-40, 20, 20, 20);
        checkboxImageView.image=NULL;
        UIImage *image;
        NSDictionary *dic=companyArray[indexPath.row];
        NSString *imageString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"head_img"]];
        [contactNameLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]]];
        NSLog(@"1%@2",imageString);
        if ([imageString length]==0||[imageString length]==1) {
            contactImage.image=[UIImage imageNamed:@"家-我_默认头像"];
        }else{
            NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"head_img"]];
            [contactImage setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
//            contactImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"head_img"]]]];
        }
        if ([self.mutableArray containsObject:[dic objectForKey:@"mobile"]]||[_idArray containsObject:[dic objectForKey:@"friend_id"]]){
            image = [UIImage imageNamed:@"icon-checkbox-selected-green-25x25"];
        } else {
            image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
        }
        checkboxImageView.image = image;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
         UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *headImage=[[UIImageView alloc]init];
        UILabel *textLabel=[[UILabel alloc]init];
        //    UIImageView *arrowImage=[[UIImageView alloc]init];
        //    NSString *string=[array objectAtIndex:indexPath.row];
        NSDictionary *dic=companyArray[indexPath.row];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            headImage.frame=FRAME(10, 10, 40, 40);
            //headImage.backgroundColor=[UIColor blackColor];
            headImage.layer.cornerRadius=headImage.frame.size.width/2;
            headImage.clipsToBounds = YES;
            [cell addSubview:headImage];
            textLabel.frame=FRAME(60, 20, WIDTH-80, 20);
            textLabel.font=[UIFont fontWithName:@"Arial" size:17];
            [cell addSubview:textLabel];
        }
        [textLabel setText:[dic objectForKey:@"name"]];
        textLabel.font=[UIFont fontWithName:@"Arial" size:15];
        NSString *imageString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"head_img"]];
        NSLog(@"1%@2",imageString);
        if ([imageString length]==0||[imageString length]==1) {
            headImage.image=[UIImage imageNamed:@"家-我_默认头像"];
        }else
        {
            NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"head_img"]];
            [headImage setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
//            headImage.image=imageArray[indexPath.row];//[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"head_img"]]]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
//改变行的高度

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=companyArray[indexPath.row];
    if (_vcIDs==100) {
        NSString *view_userid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"friend_id"]];
        FriendsHomeViewController *vc=[[FriendsHomeViewController alloc]init];
        vc.view_user_id=view_userid;
        vc.array=companyArray;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        int idString=[[dic objectForKey:@"friend_id"]intValue];
        ISLoginManager *manager = [[ISLoginManager alloc]init];
        int userID=[[NSString stringWithFormat:@"%@",manager.telephone]intValue];
        if (userID==idString) {
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"审批人不可以选择自己，请重新选择！" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [tsView show];
            return;
        }
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
        UIImage *image;
        if (_theNumber<10) {
            NSDictionary *dic=companyArray[indexPath.row];
            if ([self.mutableArray containsObject:[dic objectForKey:@"mobile"]]||[_idArray containsObject:[dic objectForKey:@"friend_id"]]){ // contact is already selected so remove it from ContactPickerView
                [_mutableArray removeObject:[dic objectForKey:@"mobile"]];
                [_nameArray removeObject:[dic objectForKey:@"name"]];
                [_mobileArray removeObject:[dic objectForKey:@"mobile"]];
                [_idArray removeObject:[dic objectForKey:@"friend_id"]];
                image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
                _theNumber-=1;
            } else {
                [_mutableArray addObject:[dic objectForKey:@"mobile"]];
                
                [_nameArray addObject:[dic objectForKey:@"name"]];
                [_mobileArray addObject:[dic objectForKey:@"mobile"]];
                [_idArray addObject:[dic objectForKey:@"friend_id"]];
                image = [UIImage imageNamed:@"icon-checkbox-selected-green-25x25"];
                _theNumber++;
            }
        }else{
            NSDictionary *dic=companyArray[indexPath.row];
            if ([self.mutableArray containsObject:[dic objectForKey:@"mobile"]]||[_idArray containsObject:[dic objectForKey:@"friend_id"]]){ // contact is already selected so remove it from ContactPickerView
                [_mutableArray removeObject:[dic objectForKey:@"mobile"]];
                [_nameArray removeObject:[dic objectForKey:@"name"]];
                [_mobileArray removeObject:[dic objectForKey:@"mobile"]];
                [_idArray removeObject:[dic objectForKey:@"friend_id"]];
                image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
                _theNumber-=1;
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Done!"
                                                                    message:@"最多可选择10人！！"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
        }
        checkboxImageView.image = image;
        [myTableView reloadData];
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
