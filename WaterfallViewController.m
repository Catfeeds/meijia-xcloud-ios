//
//  WaterfallViewController.m
//  yxz
//
//  Created by 白玉林 on 15/12/4.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "WaterfallViewController.h"
#import "WaterfallCollectionViewCell.h"
#import "MyWalletViewController.h"
#import "MineJifenViewController.h"
#import "Order_ListViewController.h"
#import "CreditWebViewController.h"
#import "AttendanceViewController.h"
@interface WaterfallViewController ()
{
//    UIView *_headerView;
    NSArray *titleNameArray;
//    NSArray *toolImageArray;
//    NSArray *growImageArray;
    NSArray *toolNameArray;
    NSArray *growNameArray;
    NSMutableArray *nameArray;
    NSMutableArray *imageArray;
    
    NSString *urlString;
    UIWebView *toolWebView;
    UIView *layoutView;
    UIActivityIndicatorView *webActivityView;
    UILabel *webTitleLabel;
    UIWebView *myWebView;
    
    NSMutableArray *toolArray;
    NSMutableArray *growArray;
    NSMutableArray *toolImageArray;
    NSMutableArray *growImageArray;
    UICollectionViewFlowLayout *flowView;
    
    UIActivityIndicatorView *meView;
}
@end

@implementation WaterfallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    meView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    meView.center = CGPointMake(WIDTH/2, HEIGHT/2);
    meView.color = [UIColor redColor];
    [self.view addSubview:meView];
    [meView startAnimating];
    
    toolArray =[[NSMutableArray alloc]init];
    growArray =[[NSMutableArray alloc]init];
    toolImageArray =[[NSMutableArray alloc]init];
    growImageArray =[[NSMutableArray alloc]init];
    self.navlabel.text=@"应用中心";
    titleNameArray=@[@"工具与服务",@"成长与赚钱"];
    
    flowView=[[UICollectionViewFlowLayout alloc]init];
    [flowView setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowView.headerReferenceSize=CGSizeMake(WIDTH, 80);
    
    //    [_collectionView removeFromSuperview];
    _collectionView=[[UICollectionView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)collectionViewLayout:flowView];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[WaterfallCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    // Do any additional setup after loading the view.
}
#pragma mark应用中心数据获取接口
-(void)viewWillAppear:(BOOL)animated
{
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dic = @{@"false":@"xcloud"};
    [_download requestWithUrl:WATER_CELL dict:_dic view:self.view delegate:self finishedSEL:@selector(waterSuccess:) isPost:NO failedSEL:@selector(waterFailure:)];
}
#pragma mark应用中心数据获取成功
-(void)waterSuccess:(id)data
{
    [toolArray removeAllObjects];
    [growArray removeAllObjects];
    [toolImageArray removeAllObjects];
    [growImageArray removeAllObjects];
    NSLog(@"获取应用中心数据成功:%@",data);
    NSArray *dataArray=[data objectForKey:@"data"];
    for (int i=0; i<dataArray.count; i++) {
        NSDictionary *dic=dataArray[i];
        NSString *dataString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"menu_type"]];
        if ([dataString isEqualToString:@"t"]) {
            [toolArray addObject:dic];
        }else{
            [growArray addObject:dic];
        }
    }
    NSLog(@"数组个数:%lu,%lu",(unsigned long)toolArray.count,(unsigned long)growArray.count);
    [_collectionView reloadData];
    
}
#pragma mark应用中心数据获取失败
-(void)waterFailure:(id)data
{
    NSLog(@"获取应用中心数据失败:%@",data);
}
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
{
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section==0) {
        return toolArray.count;
    }else{
        return growArray.count;
    }
   // return 9;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return titleNameArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify=@"cell";//[NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    NSDictionary *dataDic;
    if (indexPath.section==0) {
        dataDic=toolArray[indexPath.row];
    }else{
        dataDic=growArray[indexPath.row];
    }
    WaterfallCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义cell就不可能进来了");
    }
    NSString *nameStr=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"name"]];
    if (indexPath.section==0) {
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"logo"]];
        [cell.lconImageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
    }else{
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"logo"]];
        [cell.lconImageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
    }
    cell.lconImageView.frame=FRAME((WIDTH/4-30)/2, 20, 30, 30);
    cell.nameLabel.text=nameStr;
    cell.nameLabel.font=[UIFont fontWithName:@"Arial" size:13];
    cell.nameLabel.textColor=[UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1];
    cell.nameLabel.textAlignment=NSTextAlignmentCenter;
    cell.backgroundColor=[UIColor whiteColor];
    cell.layer.borderColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1].CGColor;
    cell.layer.borderWidth=0.5;
    
    if([indexPath row] == ((NSIndexPath*)[[collectionView indexPathsForVisibleItems] lastObject]).row){
        dispatch_async(dispatch_get_main_queue(),^{
            [meView stopAnimating]; // 结束旋转
            [meView setHidesWhenStopped:YES]; //当旋转结束时隐藏
        });
    }

    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(WIDTH/4, WIDTH/4);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(WIDTH, 40);
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return YES;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    
    UICollectionReusableView *headerView;
    headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
    NSString *title = [NSString stringWithFormat:@"%@",titleNameArray[indexPath.section]];
    UIView *_headerView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 40)];
    UILabel *label=[[UILabel alloc]initWithFrame:FRAME(0, 10, WIDTH, 20)];
    label.text=title;
    label.font=[UIFont fontWithName:@"Arial" size:16];
    label.textColor=[UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1];
    [_headerView addSubview:label];
    _headerView.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    [headerView addSubview:_headerView];
    return headerView;
    
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    NSDictionary *dataDic;
    if (indexPath.section==0) {
        dataDic=toolArray[indexPath.row];
        NSString *open_typeStr=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"open_type"]];
        if ([open_typeStr isEqualToString:@"app"]) {
            if (indexPath.row==0) {
                MyWalletViewController *mywalletVC=[[MyWalletViewController alloc]init];
                [self.navigationController pushViewController:mywalletVC animated:YES];
            }else if (indexPath.row==1){
                MineJifenViewController *mineVc=[[MineJifenViewController alloc]init];
                [self.navigationController pushViewController:mineVc animated:YES];
            }else if (indexPath.row==2){
                Order_ListViewController *orderVc=[[Order_ListViewController alloc]init];
                [self.navigationController pushViewController:orderVc animated:YES];
            }else if (indexPath.row==3){
                ISLoginManager *_manager = [ISLoginManager shareManager];
                NSString *url=[NSString stringWithFormat:@"http://123.57.173.36/simi/app/user/score_shop.json?user_id=%@",_manager.telephone];
                CreditWebViewController *web=[[CreditWebViewController alloc]initWithUrl:url];//实际中需要改为带签名的地址
                //如果已经有UINavigationContoller了，就 创建出一个 CreditWebViewController 然后 push 进去
                [self.navigationController pushViewController:web animated:YES];
            }else{
                AttendanceViewController *userVC=[[AttendanceViewController alloc]init];
                [self.navigationController pushViewController:userVC animated:YES];
            }
        }else if(indexPath.row==4){
            AttendanceViewController *userVC=[[AttendanceViewController alloc]init];
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
            NSString *has_company=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"has_company"]];
            int has=[has_company intValue];
            if (has==0) {
                userVC.webID=0;
            }else{
                userVC.webID=1;
            }

            [self.navigationController pushViewController:userVC animated:YES];
        }else{
            urlString=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"url"]];
            [self webLayout];
        }
    }else{
        dataDic=growArray[indexPath.row];
        NSString *open_typeStr=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"open_type"]];
        if ([open_typeStr isEqualToString:@"app"]) {
            
        }else{
            ISLoginManager *_manager = [ISLoginManager shareManager];
            urlString=[NSString stringWithFormat:@"%@?user_id=%@",[dataDic objectForKey:@"url"],_manager.telephone];
            [self webLayout];
        }
    }
    
}
-(void)webLayout
{
    [layoutView removeFromSuperview];
    layoutView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
    layoutView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:layoutView];
    
    [myWebView removeFromSuperview];
    myWebView= [[UIWebView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    myWebView.delegate=self;
    //self.meWebView.hidden=YES;
    myWebView.scrollView.delegate=self;
    [layoutView addSubview:myWebView];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]];
    //NSLog(@"gourl  =  %@",_imgurl);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:request];
    
    UIButton *liftButton=[[UIButton alloc]initWithFrame:FRAME(10, 20, 50, 30)];
    //liftButton.backgroundColor=[UIColor blackColor];
    [liftButton addTarget:self action:@selector(liftWebButAction) forControlEvents:UIControlEventTouchUpInside];
    [layoutView addSubview:liftButton];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:FRAME(18, 5, 10, 20)];
    image.image = [UIImage imageNamed:@"title_left_back"];
    [liftButton addSubview:image];
    
    webTitleLabel=[[UILabel alloc]initWithFrame:FRAME(60, 20, WIDTH-120, 30)];
    webTitleLabel.textAlignment=NSTextAlignmentCenter;
    webTitleLabel.font=[UIFont fontWithName:@"Arial" size:15];
    [layoutView addSubview:webTitleLabel];
    
    UIButton *rightButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-60, 20, 50, 30)];
    //rightButton.backgroundColor=[UIColor blackColor];
    [rightButton addTarget:self action:@selector(rightButAction) forControlEvents:UIControlEventTouchUpInside];
    [layoutView addSubview:rightButton];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(10, 0, 30, 30)];
    img.image = [UIImage imageNamed:@"WEB_QX"];
    [rightButton addSubview:img];
}
-(void)rightButAction
{
    [layoutView removeFromSuperview];
}
-(void)liftWebButAction
{
    if([myWebView canGoBack])
    {
        [myWebView goBack];
    }else{
        [layoutView removeFromSuperview];
    }
    
}
-(void)webViewLayout
{
    [layoutView removeFromSuperview];
    layoutView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
    layoutView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:layoutView];
    
    [toolWebView removeFromSuperview];
    toolWebView= [[UIWebView alloc]initWithFrame:FRAME(0, 50, WIDTH, HEIGHT-50)];
    toolWebView.delegate=self;
    //self.meWebView.hidden=YES;
    toolWebView.scrollView.delegate=self;
    [layoutView addSubview:toolWebView];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]];
    //NSLog(@"gourl  =  %@",_imgurl);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [toolWebView loadRequest:request];
    
    UIButton *liftButton=[[UIButton alloc]initWithFrame:FRAME(10, 20, 50, 30)];
    //liftButton.backgroundColor=[UIColor blackColor];
    [liftButton addTarget:self action:@selector(liftButAction) forControlEvents:UIControlEventTouchUpInside];
    [layoutView addSubview:liftButton];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:FRAME(18, 5, 10, 20)];
    image.image = [UIImage imageNamed:@"title_left_back"];
    [liftButton addSubview:image];
}
-(void)liftButAction
{
    [layoutView removeFromSuperview];
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [webActivityView removeFromSuperview];
    webActivityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    webActivityView.center = CGPointMake(WIDTH/2, HEIGHT/2);
    webActivityView.color = [UIColor redColor];
    [webActivityView startAnimating];
    [toolWebView addSubview:webActivityView];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webActivityView stopAnimating]; // 结束旋转
    [webActivityView setHidesWhenStopped:YES]; //当旋转结束时隐藏
    webTitleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
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
