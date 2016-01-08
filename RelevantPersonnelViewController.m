//
//  RelevantPersonnelViewController.m
//  yxz
//
//  Created by 白玉林 on 15/11/26.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "RelevantPersonnelViewController.h"
#import "MeetTableViewCell.h"
#import "MailListViewController.h"
#import "EnterpriseViewController.h"
@interface RelevantPersonnelViewController ()
{
    NSArray *titleArray;
    NSArray *sectionArray;
    NSDictionary *zjDic;
    NSArray *dataListArray;
    int theNumber;
    UIScrollView *titleView;
    UILabel *titleLabel;
    MailListViewController *mailListVC;
    EnterpriseViewController *enterVc;
    
    UIButton *barButton;
//    NSMutableArray *imageArray;
    
    int dataID;
}

@end

@implementation RelevantPersonnelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    imageArray=[[NSMutableArray alloc]init];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *has_company=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"has_company"]];
    int has=[has_company intValue];
    //_passDic=@{@"relevantNameArray":_nameArray,@"relevantMobileArray":_mobileArray,@"relevantUserArray":_mutableArray,@"mailNameArray":mailNameArray,@"mailMobileArray":mailMobileArray,@"mailIdArray":
    titleArray=@[@"",@"我的好友",@""];
    if (has==0) {
        sectionArray=@[@"手机通讯录"];//@"企业通讯录",
    }else{
        sectionArray=@[@"企业通讯录",@"手机通讯录"];//@"企业通讯录",
    }
    _mutableArray=[[NSMutableArray alloc]init];
    [_mutableArray addObjectsFromArray:_dataMutableArray];
    _nameArray=[[NSMutableArray alloc]init];
    [_nameArray addObjectsFromArray:_dataNameArray];
    _mobileArray=[[NSMutableArray alloc]init];
    [_mobileArray addObjectsFromArray:_dataMobileArray];
    _idArray=[[NSMutableArray alloc]init];
    [_idArray addObjectsFromArray:_dataIdArray];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSString *mobli=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"mobile"]];
    zjDic=@{@"name":@"自己",@"mobil":mobli,@"user_id":_manager.telephone};
    [self titleViewLayout];
    
    _relevantTableview=[[UITableView alloc]initWithFrame:FRAME(0, 114, WIDTH, HEIGHT-114)];
    _relevantTableview.dataSource=self;
    _relevantTableview.delegate=self;
    [_relevantTableview registerNib:[UINib nibWithNibName:@"MeetTableViewCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
    //[self.view insertSubview:_relevantTableview belowSubview:self.view];
    
    [self.view addSubview:_relevantTableview];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    if (dataID==100) {
        [_mutableArray removeAllObjects];
        [_nameArray removeAllObjects];
        [_mobileArray removeAllObjects];
        [_idArray removeAllObjects];
        [_mutableArray addObjectsFromArray:mailListVC.selectedContacts];;
        [_nameArray addObjectsFromArray:mailListVC.nameArray];
        [_mobileArray addObjectsFromArray:mailListVC.mobileArray];
        [_idArray addObjectsFromArray:mailListVC.idArray];
    }else if (dataID==101){
        [_mutableArray removeAllObjects];
        [_nameArray removeAllObjects];
        [_mobileArray removeAllObjects];
        [_idArray removeAllObjects];
        [_mutableArray addObjectsFromArray:enterVc.mutableArrat];;
        [_nameArray addObjectsFromArray:enterVc.nameArray];
        [_mobileArray addObjectsFromArray:enterVc.mobileArray];
        [_idArray addObjectsFromArray:enterVc.idArray];
    }
    
    
    theNumber=(int)_nameArray.count;
    [self titleViewLayout];
}
-(void)titleViewLayout
{
    
    if (_nameArray.count==0) {
        self.selectString=@"";
    }else{
        NSString *relevantNameStr=[_nameArray componentsJoinedByString:@","];
        self.selectString=relevantNameStr;
       
    }
    
    NSLog(@"有人没？%@",self.selectString);
    self.numberString=[NSString stringWithFormat:@"共%lu人",(unsigned long)_nameArray.count];
    int theTime=(int)_nameArray.count;
    [barButton removeFromSuperview];
    barButton= [[UIButton alloc] initWithFrame:FRAME(WIDTH-70, 27, 60, 30)];
    barButton.enabled = FALSE;
    [barButton setTitle:@"确定" forState:UIControlStateNormal];
    [barButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    barButton.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    //barButton.hidden=YES;
    if(theTime > 0) {
        barButton.enabled = TRUE;
        barButton.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    }
    else
    {
        barButton.enabled = FALSE;
        barButton.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    }
    barButton.layer.cornerRadius=8;
    [self.view addSubview:barButton];
    
    
    
    [titleLabel removeFromSuperview];
    [titleView removeFromSuperview];
    titleView=[[UIScrollView alloc]initWithFrame:FRAME(0, 64, WIDTH, 50)];
    titleView.delegate=self;
    [self.view addSubview:titleView];
    
    UIFont *font=[UIFont fontWithName:@"Arial" size:18];
    CGSize constraint = CGSizeMake(WIDTH-20, 200.0f);
    titleLabel=[[UILabel alloc]init];
    titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    [titleLabel setNumberOfLines:0];
    titleLabel.text=[NSString stringWithFormat:@"已选择:%@",_selectString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size = [titleLabel.text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    titleLabel.frame=FRAME(10, 5, WIDTH-20, size.height);
    titleLabel.font=font;
    [titleView addSubview:titleLabel];
    titleView.contentSize=CGSizeMake(WIDTH, titleLabel.frame.size.height+10);
}
-(void)viewDidAppear:(BOOL)animated
{
    [self dataLayout];
}
-(void)dataLayout
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    //user_ID=_manager.telephone;
    NSDictionary *_dict = @{@"user_id":_manager.telephone};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:USER_HYLB dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
}
-(void)logDowLoadFinish:(id)sender
{
    NSLog(@"数据信息－－%@",sender);
    dataListArray=[sender objectForKey:@"data"];
//    for (int i=0; i<dataListArray.count; i++) {
//        NSDictionary *dic=dataListArray[i];
//        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"head_img"]]]];
//        CGSize newSize=CGSizeMake(40, 40);
//        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
//        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//        image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        [imageArray addObject:image];
//    }

    [_relevantTableview reloadData];
    
}
-(void)DownFail:(id)sender
{
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
}
//制定个性标题，这里通过UIview来设计标题，功能上丰富，变化多。
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    
    [view setBackgroundColor:[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1]];//改变标题的颜色，也可用图片
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, WIDTH, 20)];
    
    //label.textColor = [UIColor redColor];
    
    label.backgroundColor = [UIColor clearColor];
    
    label.text = [titleArray objectAtIndex:section];
    
    [view addSubview:label];
    
    return view;
    
}

//指定标题的高度

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }else if(section==1){
        return 30;
    }else{
        return 0;
    }
}
//指定有多少个分区(Section)，默认为1

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [titleArray count];
    
}



//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return sectionArray.count;
    }else if (section==1){
        return 1;
    }else{
        return dataListArray.count;
    }
}



//绘制Cell

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSString *identifier = [NSString stringWithFormat:@"（%ld,%ld)",(long)indexPath.row,(long)indexPath.section];
    
    
    NSString *cellIdentifier = @"ContactCell";

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UILabel *contactNameLabel = (UILabel *)[cell viewWithTag:101];
    UIImageView *contactImage = (UIImageView *)[cell viewWithTag:103];
    UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
        if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    
   
    contactNameLabel.frame=FRAME(70, 20, WIDTH-110, 20);
    
    contactImage.clipsToBounds=YES;
    contactImage.layer.cornerRadius=20;
    
    checkboxImageView.frame=FRAME(WIDTH-40, 20, 20, 20);
    checkboxImageView.image=NULL;
    UIImage *image;
    if (indexPath.section==0) {
        [contactNameLabel setText:[NSString stringWithFormat:@"%@",[sectionArray objectAtIndex:indexPath.row]]];
        if (indexPath.row==0) {
            contactImage.image=[UIImage imageNamed:@"iconfont-gcompany"];
        }else{
            contactImage.image=[UIImage imageNamed:@"iconfont-tongxunbu"];
        }
        
        image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
    }else if(indexPath.section==1){
        [contactNameLabel setText:[NSString stringWithFormat:@"%@",[zjDic objectForKey:@"name"]]];
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"head_img"]];
        [contactImage setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
//        contactImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[delegate.globalDic objectForKey:@"head_img"]]]];
        NSLog(@"第一%@ 第二%@",self.mutableArray,zjDic);
        if ([self.mutableArray containsObject:[zjDic objectForKey:@"mobil"]]||[_idArray containsObject:[zjDic objectForKey:@"user_id"]]){
            
            image = [UIImage imageNamed:@"icon-checkbox-selected-green-25x25"];
        } else {
            image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
        }
    }else if(indexPath.section==2){
       NSDictionary *dic=dataListArray[indexPath.row];
        NSString *imageString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"head_img"]];
        [contactNameLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]]];
        NSLog(@"1%@2",imageString);
        if ([imageString length]==0||[imageString length]==1) {
            contactImage.image=[UIImage imageNamed:@"家-我_默认头像"];
        }else{
            NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"head_img"]];
            [contactImage setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
//            contactImage.image=imageArray[indexPath.row];//[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"head_img"]]]];
        }
        if ([self.mutableArray containsObject:[dic objectForKey:@"mobile"]]||[_idArray containsObject:[dic objectForKey:@"friend_id"]]){
           
            image = [UIImage imageNamed:@"icon-checkbox-selected-green-25x25"];
        } else {
           
            image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
        }

    }
    checkboxImageView.image = image;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
    UIImage *image;

    if (theNumber<10) {
        if (indexPath.section==0) {
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
            NSString *has_company=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"has_company"]];
            int has=[has_company intValue];
            if (indexPath.row==0) {
                if (has==0) {
                    dataID=100;
                    mailListVC=[[MailListViewController alloc]init];
                    mailListVC.theNumber=theNumber;
                    mailListVC.seleArray=self.mutableArray;
                    mailListVC.passNameArray=_nameArray;
                    mailListVC.passMobielArray=_mobileArray;
                    mailListVC.passIdArray=_idArray;
                    [self.navigationController pushViewController:mailListVC animated:YES];
                }else{
                    dataID=101;
                    enterVc=[[EnterpriseViewController alloc]init];
                    enterVc.webId=1;
                    enterVc.enterVcID=10;
                    enterVc.theNumber=theNumber;
                    enterVc.mutableArrat=_mutableArray;
                    enterVc.nameArray=_nameArray;
                    enterVc.mobileArray=_mobileArray;
                    enterVc.idArray=_idArray;
                    [self.navigationController pushViewController:enterVc animated:YES];
                }
            }else{
                dataID=100;
                mailListVC=[[MailListViewController alloc]init];
                mailListVC.theNumber=theNumber;
                mailListVC.seleArray=self.mutableArray;
                mailListVC.passNameArray=_nameArray;
                mailListVC.passMobielArray=_mobileArray;
                mailListVC.passIdArray=_idArray;
                [self.navigationController pushViewController:mailListVC animated:YES];
            }
            // image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
        }else if(indexPath.section==1){
            if ([self.mutableArray containsObject:[zjDic objectForKey:@"mobil"]]||[_idArray containsObject:[zjDic objectForKey:@"user_id"]]){ // contact is already selected so remove it from ContactPickerView
                [self.mutableArray removeObject:[zjDic objectForKey:@"mobil"]];
                [_nameArray removeObject:[zjDic objectForKey:@"name"]];
                [_mobileArray removeObject:[zjDic objectForKey:@"mobil"]];
                [_idArray removeObject:[zjDic objectForKey:@"user_id"]];
                image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
                theNumber-=1;
            } else {
                [self.mutableArray addObject:[zjDic objectForKey:@"mobil"]];
                NSLog(@"没有值么？%@",self.mutableArray);
                [_nameArray addObject:[zjDic objectForKey:@"name"]];
                [_mobileArray addObject:[zjDic objectForKey:@"mobil"]];
                [_idArray addObject:[zjDic objectForKey:@"user_id"]];
                image = [UIImage imageNamed:@"icon-checkbox-selected-green-25x25"];
                theNumber++;
            }
            
        }else{
            NSDictionary *dic=dataListArray[indexPath.row];
            if ([self.mutableArray containsObject:[dic objectForKey:@"mobile"]]||[_idArray containsObject:[dic objectForKey:@"friend_id"]]){ // contact is already selected so remove it from ContactPickerView
                [_mutableArray removeObject:[dic objectForKey:@"mobile"]];
                [_nameArray removeObject:[dic objectForKey:@"name"]];
                [_mobileArray removeObject:[dic objectForKey:@"mobile"]];
                [_idArray removeObject:[dic objectForKey:@"friend_id"]];
                image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
                theNumber-=1;
            } else {
                [_mutableArray addObject:[dic objectForKey:@"mobile"]];
                
                [_nameArray addObject:[dic objectForKey:@"name"]];
                [_mobileArray addObject:[dic objectForKey:@"mobile"]];
                [_idArray addObject:[dic objectForKey:@"friend_id"]];
                image = [UIImage imageNamed:@"icon-checkbox-selected-green-25x25"];
                theNumber++;
                
            }
        }

    }else{
        if (indexPath.section==0) {
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
            NSString *has_company=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"has_company"]];
            int has=[has_company intValue];
            if (indexPath.row==0) {
                if (has==0) {
                    dataID=100;
                    mailListVC=[[MailListViewController alloc]init];
                    mailListVC.theNumber=theNumber;
                    mailListVC.seleArray=self.mutableArray;
                    mailListVC.passNameArray=_nameArray;
                    mailListVC.passMobielArray=_mobileArray;
                    mailListVC.passIdArray=_idArray;
                    [self.navigationController pushViewController:mailListVC animated:YES];
                }else{
                    dataID=101;
                    enterVc=[[EnterpriseViewController alloc]init];
                    enterVc.webId=1;
                    enterVc.enterVcID=10;
                    enterVc.mutableArrat=_mutableArray;
                    enterVc.nameArray=_nameArray;
                    enterVc.mobileArray=_mobileArray;
                    enterVc.idArray=_idArray;
                    [self.navigationController pushViewController:enterVc animated:YES];
                }
            }else{
                dataID=100;
                mailListVC=[[MailListViewController alloc]init];
                mailListVC.theNumber=theNumber;
                mailListVC.seleArray=self.mutableArray;
                mailListVC.passNameArray=_nameArray;
                mailListVC.passMobielArray=_mobileArray;
                mailListVC.passIdArray=_idArray;
                [self.navigationController pushViewController:mailListVC animated:YES];
            }
            // image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
        }else if(indexPath.section==1){
            if ([self.mutableArray containsObject:[zjDic objectForKey:@"mobil"]]||[_idArray containsObject:[zjDic objectForKey:@"user_id"]]){ // contact is already selected so remove it from ContactPickerView
                [self.mutableArray removeObject:[zjDic objectForKey:@"mobil"]];
                [_nameArray removeObject:[zjDic objectForKey:@"name"]];
                [_mobileArray removeObject:[zjDic objectForKey:@"mobil"]];
                [_idArray removeObject:[zjDic objectForKey:@"user_id"]];
                image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
                theNumber-=1;
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Done!"
                                                                    message:@"最多可选择10人！！"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
            
        }else{
            NSDictionary *dic=dataListArray[indexPath.row];
            if ([self.mutableArray containsObject:[dic objectForKey:@"mobile"]]||[_idArray containsObject:[dic objectForKey:@"friend_id"]]){ // contact is already selected so remove it from ContactPickerView
                [_mutableArray removeObject:[dic objectForKey:@"mobile"]];
                [_nameArray removeObject:[dic objectForKey:@"name"]];
                [_mobileArray removeObject:[dic objectForKey:@"mobile"]];
                [_idArray removeObject:[dic objectForKey:@"friend_id"]];
                image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
                theNumber-=1;
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Done!"
                                                                    message:@"最多可选择10人！！"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
                
            }
        }

    }
    
    checkboxImageView.image = image;
    [_relevantTableview reloadData];
    [self titleViewLayout];
}
-(void)backAction
{
//    _passDic= [NSDictionary dictionaryWithObjectsAndKeys:_nameArray,@"relevantNameArray",_mobileArray,@"relevantMobileArray",_mutableArray,@"relevantUserArray",mailNameArray,@"mailNameArray",mailMobileArray,@"mailMobileArray",mailMutableArray,@"mailIdArray",nil];
  //@{@"relevantNameArray":_nameArray,@"relevantMobileArray":_mobileArray,@"relevantUserArray":_mutableArray,@"mailNameArray":mailNameArray,@"mailMobileArray":mailMobileArray,@"mailIdArray":mailMutableArray};
    [self.navigationController popViewControllerAnimated:YES];
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
