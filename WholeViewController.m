//
//  WholeViewController.m
//  yxz
//
//  Created by 白玉林 on 16/1/11.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "WholeViewController.h"
#import "WaterfallCollectionViewCell.h"
#import "ClerkViewController.h"
#import "FountWebViewController.h"
#import "SearchVoiceViewController.h"
@interface WholeViewController ()
{
    UICollectionViewFlowLayout *flowView;
    UIActivityIndicatorView *meView;
    NSMutableArray *dataSourceArray;
    UILabel *alertLabel;
    NSString *createPath;
}
@end

@implementation WholeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataSourceArray =[[NSMutableArray alloc]init];
    meView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    meView.center = CGPointMake(WIDTH/2, HEIGHT/2);
    meView.color = [UIColor redColor];
    [self.view addSubview:meView];
    [meView startAnimating];
    
    flowView=[[UICollectionViewFlowLayout alloc]init];
    [flowView setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowView.headerReferenceSize=CGSizeMake(WIDTH, 80);
    
    //    [_collectionView removeFromSuperview];
    if (_whoVCID==101) {
        self.navlabel.text=@"找服务商";
        _collectionView=[[UICollectionView alloc]initWithFrame:FRAME(0, 104, WIDTH, HEIGHT-104)collectionViewLayout:flowView];
        UIButton *searchButton=[[UIButton alloc]initWithFrame:FRAME(20, 64+15/2, WIDTH-40, 25)];
        searchButton.backgroundColor=[UIColor whiteColor];//colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
        [searchButton addTarget:self action:@selector(searchButAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:searchButton];
        UIImageView *searchImage=[[UIImageView alloc]initWithFrame:FRAME(5, 5, 15, 15)];
        searchImage.image=[UIImage imageNamed:@"search_@2x"];
        [searchButton addSubview:searchImage];
        UIImageView *voiceImage=[[UIImageView alloc]initWithFrame:FRAME(searchButton.frame.size.width-20, 5, 15, 15)];
        voiceImage.image=[UIImage imageNamed:@"iconfont-yuyin-copy"];
        [searchButton addSubview:voiceImage];
        UILabel *searchLabel=[[UILabel alloc]initWithFrame:FRAME(45, 5, searchButton.frame.size.width-90, 15)];
        searchLabel.text=@"点击搜索相关信息";
    }else{
        _collectionView=[[UICollectionView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT-115)collectionViewLayout:flowView];
    }
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[WaterfallCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    // Do any additional setup after loading the view.
    [self dataSourceLayout];
}
-(void)viewWillAppear:(BOOL)animated
{
    if (_whoVCID==101) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
}
#pragma mark 搜索按钮点击方法
-(void)searchButAction
{
    SearchVoiceViewController *searchVC=[[SearchVoiceViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
-(void)dataSourceLayout
{
//    DownloadManager *_download = [[DownloadManager alloc]init];
//    NSDictionary *dict=@{@"channel_id":_channel_id};
//    [_download requestWithUrl:CHANNEL_CARD dict:dict view:self.view delegate:self finishedSEL:@selector(ChannelSuccess:) isPost:NO failedSEL:@selector(ChannelFailure:)];
    
    
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/simi.db", pathDocuments];
    sqlite3_open([path UTF8String], &simi);
    
    sqlite3_stmt *statement;
    NSString *sql =[NSString stringWithFormat:@"SELECT * FROM op_ad where ad_type like '%%99%%' order by id"];
    
    if (sqlite3_prepare_v2(simi, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *op_id = (char *)sqlite3_column_text(statement, 0);
            NSString *op_idStr = [[NSString alloc] initWithUTF8String:op_id];
            
            char *title = (char *)sqlite3_column_text(statement, 2);
            NSString *titleStr = [[NSString alloc] initWithUTF8String:title];
            
            char *ad_type = (char *)sqlite3_column_text(statement, 3);
            NSString *add_typeStr = [[NSString alloc] initWithUTF8String:ad_type];
            
            char *add_time = (char *)sqlite3_column_text(statement, 8);
            NSString *add_timeStr = [[NSString alloc] initWithUTF8String:add_time];
            
            char *enable = (char *)sqlite3_column_text(statement, 10);
            NSString *enableStr = [[NSString alloc] initWithUTF8String:enable];
            
            char *goto_type = (char *)sqlite3_column_text(statement, 6);
            NSString *goto_typeStr = [[NSString alloc] initWithUTF8String:goto_type];
            
            char *goto_url = (char *)sqlite3_column_text(statement, 7);
            NSString *goto_urlStr = [[NSString alloc] initWithUTF8String:goto_url];
            
            char *img_url = (char *)sqlite3_column_text(statement, 5);
            NSString *img_urlStr = [[NSString alloc] initWithUTF8String:img_url];
            
            char *no = (char *)sqlite3_column_text(statement, 1);
            NSString *nolStr = [[NSString alloc] initWithUTF8String:no];
            
            char *service_type_ids = (char *)sqlite3_column_text(statement, 4);
            NSString *service_type_idsStr = [[NSString alloc] initWithUTF8String:service_type_ids];
            
            char *update_time = (char *)sqlite3_column_text(statement, 9);
            NSString *update_timeStr = [[NSString alloc] initWithUTF8String:update_time];
            
            NSDictionary *dic=@{@"ad_type":add_typeStr,@"add_time":add_timeStr,@"enable":enableStr,@"goto_type":goto_typeStr,@"goto_url":goto_urlStr,@"id":op_idStr,@"img_url":img_urlStr,@"no":nolStr,@"service_type_ids":service_type_idsStr,@"title":titleStr,@"update_time":update_timeStr};
            NSLog(@"字典数据:::::%@",dic);
            if ([dataSourceArray containsObject:dic]) {
                
            }else{
                [dataSourceArray addObject:dic];
            }
        }
        sqlite3_finalize(statement);
    }
    
}
#pragma mark 获取频道列表成功返回方法
-(void)ChannelSuccess:(id)sender
{
    NSLog(@"获取频道列表成功数据1112%@",sender);
    dataSourceArray=[sender objectForKey:@"data"];
    NSString *dataString=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    if (dataString==nil||dataString==NULL||dataString.length==0||[dataString isEqualToString:@""]) {
               [alertLabel removeFromSuperview];
        alertLabel=[[UILabel alloc]initWithFrame:FRAME((WIDTH-260)/2,HEIGHT-200, 260, 40)];
        alertLabel.backgroundColor=[UIColor blackColor];
        alertLabel.alpha=0.4;
        alertLabel.text=[NSString stringWithFormat:@"没有数据%@",[sender objectForKey:@"msg"]];//@"还没有输入评论内容哦～";
        alertLabel.textColor=[UIColor whiteColor];
        alertLabel.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:alertLabel];
        
        [NSTimer scheduledTimerWithTimeInterval:2.0f
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:alertLabel
                                        repeats:NO];
        
    }else{
        [_collectionView reloadData];
    }
}
- (void)timerFireMethod:(NSTimer*)theTimer
{
    alertLabel.hidden=YES;
}
#pragma mark 获取频道列表失败返回方法
-(void)ChannelFailure:(id)sender
{
    NSLog(@"获取频道列表失败数据%@",sender);
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
{
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return dataSourceArray.count;
        // return 9;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark - 获取图像路径
- (NSString *)imageFilePath:(NSString *)imageUrl
{
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    createPath = [NSString stringWithFormat:@"%@/Op_ad_hallImage", pathDocuments];
    //    NSArray *file = [[[NSFileManager alloc] init] subpathsAtPath:createPath];
    //    //NSLog(@"%d",[file count]);
    //    NSLog(@"%@",file);
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:createPath]) {
        
        
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
#pragma mark 拼接图像文件在沙盒中的路径,因为图像URL有"/",要在存入前替换掉,随意用"_"代替
    //    NSString * imageName = [imageUrl stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString * imageFilePath = [createPath stringByAppendingPathComponent:imageUrl];
    
    
    return imageFilePath;
}
#pragma mark - 加载本地图像
- (UIImage *)loadLocalImage:(NSString *)imageUrl
{
    
    // 获取图像路径
    NSString * filePath = [self imageFilePath:imageUrl];
    
    
    UIImage * image = [UIImage imageWithContentsOfFile:filePath];
    
    
    if (image != nil) {
        return image;
    }
    
    return nil;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify=@"cell";//[NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    NSDictionary *dataDic=dataSourceArray[indexPath.row];
    WaterfallCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义cell就不可能进来了");
    }
    NSString *nameStr=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"title"]];
   
   
    NSString *imageUrl=[NSString stringWithFormat:@"opad_%@_%@",[dataDic objectForKey:@"id"],[dataDic objectForKey:@"update_time"]];
    UIImage * image =[self loadLocalImage:imageUrl];
    if (image==nil) {
//         NSString *imageUrls=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"img_url"]];
//        [cell.lconImageView setImageWithURL:[NSURL URLWithString:imageUrls]placeholderImage:nil];
        NSString *imageUrls=[NSString stringWithFormat:@"opad_%@",[dataDic objectForKey:@"id"]];
        cell.lconImageView.image=[UIImage imageNamed:imageUrls];
    }else{
        cell.lconImageView.image=image;
    }
    
    cell.lconImageView.frame=FRAME((WIDTH/4-30)/2, 20, 30, 30);
    cell.nameLabel.text=nameStr;
    cell.nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
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
    return CGSizeMake(WIDTH, 0);
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=dataSourceArray[indexPath.row];
    NSString *string=[NSString stringWithFormat:@"%@",[dic objectForKey:@"goto_type"]];
    if ([string isEqualToString:@"app"]) {
        ClerkViewController *clerkVC=[[ClerkViewController alloc]init];
        clerkVC.service_type_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_type_ids"]];
        [self.navigationController pushViewController:clerkVC animated:YES];
    }else{
        FountWebViewController *fountVC=[[FountWebViewController alloc]init];
        fountVC.goto_type=[NSString stringWithFormat:@"%@",[dic objectForKey:@"goto_type"]];
        fountVC.imgurl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"goto_url"]];
        fountVC.service_type_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_type_ids"]];
        fountVC.titleName=[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
        [self.navigationController pushViewController:fountVC animated:YES];
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
