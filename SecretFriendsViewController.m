//
//  SecretFriendsViewController.m
//  simi
//
//  Created by 白玉林 on 15/7/31.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "SecretFriendsViewController.h"
#import <AddressBook/AddressBook.h>
#import "THContact.h"
#import "ISLoginManager.h"
#import "DownloadManager.h"
#import "ListViewController.h"
#import "FriendsHomeViewController.h"
#import "SeekViewController.h"

#import "LBXScanViewController.h"
#import <objc/message.h>
#import "EnterpriseViewController.h"
#import "ApplyFriendsListViewController.h"
@interface SecretFriendsViewController ()
{
    NSMutableArray *secretArray;
    NSArray *recommendArray;
    NSArray *secretaryArray;
    NSArray *titleArray;
    NSMutableArray *cellArray;
    NSString *user_ID;
    
    
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_moreFooter;
    BOOL _needRefresh;
    BOOL _hasMore;
    NSInteger   page;
    NSString *senderStr;

}
@property (nonatomic, assign) ABAddressBookRef addressBookRef;
@end

@implementation SecretFriendsViewController
@synthesize _tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    page=1;
    secretArray=[[NSMutableArray alloc]init];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
//    self.backBtn.hidden=YES;
//    self.navlabel.text=@"好友";
    titleArray=@[@"",@"我的好友"];
    cellArray=[[NSMutableArray alloc]init];
    ABAddressBookRequestAccessWithCompletion(self.addressBookRef, ^(bool granted, CFErrorRef error) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getContactsFromAddressBook];
            });
        }
    });
    
    recommendArray=@[@"企业通讯录",@"添加通讯录好友",@"扫一扫加好友",@"好友申请"];//,
    _tableView=[[UITableView alloc]initWithFrame:FRAME(0, 110, WIDTH, HEIGHT-110)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_tableView setTableFooterView:v];
    _refreshHeader = [[MJRefreshHeaderView alloc] init];
    _refreshHeader.delegate = self;
    _refreshHeader.scrollView = _tableView;
    
    _moreFooter = [[MJRefreshFooterView alloc] init];
    _moreFooter.delegate = self;
    _moreFooter.scrollView = _tableView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_needRefresh) {
        [_refreshHeader beginRefreshing];
        _needRefresh = NO;
    }
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
    
    [self dataLayout];
    
        
}
#pragma mark 表格刷新相关
-(void)appDeleateLayout
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSLog(@"有值么%@",_manager.telephone);
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict=@{@"user_id":_manager.telephone};
    [_download requestWithUrl:USER_INFO dict:_dict view:self.view delegate:self finishedSEL:@selector(QJDowLoadSuccess:) isPost:NO failedSEL:@selector(QJDownFailure:)];
}
#pragma mark用户信息详情获取成功方法
-(void)QJDowLoadSuccess:(id)sender
{
    NSLog(@"数据详情%@",sender);
    NSDictionary *dic=[sender objectForKey:@"data"];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.globalDic=@{@"user_id":[dic objectForKey:@"id"],@"sec_id":[dic objectForKey:@"sec_id"],@"is_senior":[dic objectForKey:@"is_senior"],@"senior_range":[dic objectForKey:@"senior_range"],@"mobile":[dic objectForKey:@"mobile"],@"user_type":[dic objectForKey:@"user_type"],@"name":[dic objectForKey:@"name"],@"has_company":[dic objectForKey:@"has_company"],@"head_img":[dic objectForKey:@"head_img"],@"company_id":[dic objectForKey:@"company_id"],@"company_name":[dic objectForKey:@"company_name"]};
    NSLog(@"看看是什么啊%@",delegate.globalDic);
}
#pragma mark用户信息详情获取失败方法
-(void)QJDownFailure:(id)sender
{
}
-(void)getContactsFromAddressBook
{
    CFErrorRef error=NULL;
    self.contacts=[[NSMutableArray alloc]init];
    ABAddressBookRef addressBOok=ABAddressBookCreateWithOptions(NULL, &error);
    if (addressBOok) {
        NSArray *allContacts=(__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBOok);
        NSMutableArray *mutableContacts=[NSMutableArray arrayWithCapacity:allContacts.count];
        NSUInteger i=0;
        for (i=0; i<allContacts.count; i++) {
            THContact *contact=[[THContact alloc]init];
            ABRecordRef contactPerson=(__bridge ABRecordRef)allContacts[i];
            contact.recordId=ABRecordGetRecordID(contactPerson);
            NSString *firstName=(__bridge_transfer NSString *)ABRecordCopyValue(contactPerson,kABPersonFirstNameProperty);
            NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            
            contact.firstName=firstName;
            contact.lastName=lastName;
            ABMultiValueRef phonesRef=ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            contact.phone=[self getMobilePhoneProperty:phonesRef];
            if (phonesRef) {
                CFRelease(phonesRef);
            }
            NSData  *imgData = (__bridge_transfer NSData *)ABPersonCopyImageData(contactPerson);
            contact.image = [UIImage imageWithData:imgData];
            if (!contact.image) {
                contact.image = [UIImage imageNamed:@"icon-avatar-60x60"];
            }            [mutableContacts addObject:contact];
        }
        if(addressBOok) {
            CFRelease(addressBOok);
        }
        self.contacts = [NSArray arrayWithArray:mutableContacts];
        self.selectedContacts = [NSMutableArray array];
        self.filteredContacts = self.contacts;
        for (int i=0; i<self.filteredContacts.count; i++) {
            THContact *contact = [self.filteredContacts objectAtIndex:i];
            UIImage *headImage=contact.image;
            NSString *nameString=[NSString stringWithFormat:@"%@",contact.fullName];
            NSString *string=[NSString stringWithFormat:@"%@",contact.phone];
            NSString *phoneString=[string stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSLog(@"通讯录数据%@,%@",nameString,phoneString);
            NSDictionary *dic=@{@"name":nameString,@"phone":phoneString,@"image":headImage};
            [cellArray addObject:dic];
        }
        NSString *jsonString=[cellArray componentsJoinedByString:@","];
        NSLog(@"%@",jsonString);
    }
    else
    {
        NSLog(@"Error");
        
    }
}
- (NSString *)getMobilePhoneProperty:(ABMultiValueRef)phonesRef
{
    for (int i=0; i < ABMultiValueGetCount(phonesRef); i++) {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        
        if(currentPhoneLabel) {
            if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
                return (__bridge NSString *)currentPhoneValue;
            }
            
            if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
                return (__bridge NSString *)currentPhoneValue;
            }
        }
        if(currentPhoneLabel) {
            CFRelease(currentPhoneLabel);
        }
        if(currentPhoneValue) {
            CFRelease(currentPhoneValue);
        }
    }
    return nil;
}
-(void)viewDidAppear:(BOOL)animated
{
    [self appDeleateLayout];
    [self dataLayout];
}
-(void)dataLayout
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    user_ID=_manager.telephone;
    NSString *pageStr=[NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *_dict = @{@"user_id":user_ID,@"page":pageStr};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:USER_HYLB dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
}
-(void)logDowLoadFinish:(id)sender
{
//    secretArray=[sender objectForKey:@"data"];
    senderStr=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    if (senderStr==nil||senderStr==NULL||[senderStr isEqualToString:@"(\n)"]||[senderStr length]==0) {
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        
    }else{
        NSArray *array=[sender objectForKey:@"data"];
        if (array.count<10*page) {
            _hasMore=YES;
        }else{
            _hasMore=NO;
        }
        if (page==1) {
            [secretArray removeAllObjects];
            [secretArray addObjectsFromArray:array];
        }else{
            for (int i=0; i<array.count; i++) {
                if ([secretArray containsObject:array[i]]) {
                    
                }else{
                    [secretArray addObject:array[i]];
                }
            }
        }

    }
    
    [_tableView reloadData];
    NSLog(@"好友列表数据%@",sender);
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
//制定个性标题，这里通过UIview来设计标题，功能上丰富，变化多。
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    [view setBackgroundColor:[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1]];//改变标题的颜色，也可用图片
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, WIDTH, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.text = [titleArray objectAtIndex:section];
    [view addSubview:label];
    return view;
}
//指定标题的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        return 30;
    }
}
//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [titleArray count];
}
//指定每个分区中有多少行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count;
    //上面的方法也是可行的，大家参考比较下
    if (section==1) {
        if ([secretArray isEqual:@""]) {
            count=0;
        }else
        {
            count=[secretArray count];
        }
    }else{
         count=[recommendArray count];  //取dataArray中的元素，并根据每个元素（数组）来判断分区中的行数。
    }
    return count;
}
//绘制Cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"（%ld,%ld)",(long)indexPath.row,(long)indexPath.section];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    UIImageView *arrowImage=[[UIImageView alloc]init];
    arrowImage.frame=FRAME(WIDTH-20, 35/2, 10, 15);
    arrowImage.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
    [cell addSubview:arrowImage];
    if (indexPath.section==1) {
        NSDictionary *dic=[secretArray objectAtIndex:indexPath.row];
        UILabel *textLabel=[[UILabel alloc]init];
        textLabel.frame=FRAME(60, 15, WIDTH-80, 20);
        textLabel.font=[UIFont fontWithName:@"Heiti SC" size:17];
        [cell addSubview:textLabel];
        [textLabel setText:[dic objectForKey:@"name"]];
        textLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        NSString *imageString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"head_img"]];
        NSLog(@"1%@2",imageString);
        UIImageView *headImage=[[UIImageView alloc]init];
        headImage.frame=FRAME(10, 5, 40, 40);
        headImage.layer.cornerRadius=headImage.frame.size.width/2;
        headImage.clipsToBounds = YES;
        [cell addSubview:headImage];

        if ([imageString length]==0||[imageString length]==1) {
            headImage.image=[UIImage imageNamed:@"家-我_默认头像"];
        }else
        {
            NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"head_img"]];
            [headImage setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
        }
    }else{
        UILabel *textLabel=[[UILabel alloc]init];
        textLabel.frame=FRAME(60, 15, WIDTH-80, 20);
        textLabel.font=[UIFont fontWithName:@"Heiti SC" size:17];
        [cell addSubview:textLabel];
        [textLabel setText:[recommendArray objectAtIndex:indexPath.row]];
        textLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        UIImageView *headImage=[[UIImageView alloc]init];
        headImage.frame=FRAME(10, 5, 40, 40);
        headImage.layer.cornerRadius=headImage.frame.size.width/2;
        headImage.clipsToBounds = YES;
        [cell addSubview:headImage];

        if (indexPath.row==0) {
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
            NSString *has_company=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"has_company"]];
            int has=[has_company intValue];
            UILabel *label=[[UILabel alloc]initWithFrame:FRAME(WIDTH-70, 15, 50, 20)];
            label.text=@"立即创建";
            label.font=[UIFont fontWithName:@"Heiti SC" size:12];
            label.textColor=[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1];
            label.textAlignment=NSTextAlignmentRight;
            if (has==0) {
                label.hidden=NO;
            }else{
                label.hidden=YES;
            }
            [cell addSubview:label];
            headImage.image=[UIImage imageNamed:@"iconfont_company_tongxunbu"];
        }else if(indexPath.row==1){
            headImage.image=[UIImage imageNamed:@"iconfont_tongxunbu"];
        }else if(indexPath.row==2){
            headImage.image=[UIImage imageNamed:@"iconfont_rq_code"];
        }else{
            headImage.image=[UIImage imageNamed:@"iconfont-haoyoushenqing"];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        dispatch_async(dispatch_get_main_queue(),^{
            [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        });
    }
        return cell;
}
//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if(indexPath.row==0){
            EnterpriseViewController *enterVc=[[EnterpriseViewController alloc]init];
            enterVc.vcIDs=100;
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
            NSString *has_company=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"has_company"]];
            int has=[has_company intValue];
            if (has==0) {
                enterVc.webId=0;
            }else{
                enterVc.webId=1;
            }
            [self.navigationController pushViewController:enterVc animated:YES];
        }else if(indexPath.row==1){
            ListViewController *vc=[[ListViewController alloc]init];
            vc.dataArray=cellArray;
            vc.hyArray=secretArray;
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row==2){
            NSArray *arrayItems = @[@[@"模拟qq扫码界面",@"qqStyle"]];
            NSArray* array = arrayItems[0];
            NSString *methodName = [array lastObject];
            SEL normalSelector = NSSelectorFromString(methodName);
            if ([self respondsToSelector:normalSelector]) {
                ((void (*)(id, SEL))objc_msgSend)(self, normalSelector);
            }
        }else{
            ApplyFriendsListViewController *applyVC=[[ApplyFriendsListViewController alloc]init];
            [self.navigationController pushViewController:applyVC animated:YES];
        }
    }else{
        NSDictionary *dic=secretArray[indexPath.row];
        NSString *view_userid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"friend_id"]];
        FriendsHomeViewController *vc=[[FriendsHomeViewController alloc]init];
        vc.view_user_id=view_userid;
        vc.array=secretArray;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -模仿qq界面
- (void)qqStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    style.photoframeLineW = 6;
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    //qq里面的线条图片
    UIImage *imgLine = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    style.animationImage = imgLine;
    LBXScanViewController *vc = [LBXScanViewController new];
    vc.style = style;
    vc.isQQSimulator = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)DownFail:(id)sender
{
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
