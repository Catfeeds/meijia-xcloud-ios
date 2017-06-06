//
//  ask_tabViewController.m
//  yxz
//
//  Created by 白玉林 on 16/6/4.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "ask_tabViewController.h"
#import "AddLabelCollectionViewCell.h"

@interface ask_tabViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *addArray;
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *flowView;
    
}
@end

@implementation ask_tabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _textArray=[[NSMutableArray alloc]init];
    [_textArray addObjectsFromArray:_askTabArray];
    flowView=[[UICollectionViewFlowLayout alloc]init];
    [flowView setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowView.headerReferenceSize=CGSizeMake(WIDTH, 80);
    _collectionView=[[UICollectionView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)collectionViewLayout:flowView];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    
    _collectionView.backgroundColor=[UIColor colorWithRed:245/255.0f green:246/255.0f blue:248/255.0f alpha:1];
    [self.view addSubview:_collectionView];
    
    
    [_collectionView registerClass:[AddLabelCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterReusableView"];
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self ask_tabLayout];
}
-(void)ask_tabLayout
{

    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *dict=@{@"tag_type":@"3"};
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",ASK_TAB_LABEL] dict:dict view:self.view delegate:self finishedSEL:@selector(ask_tabSuccess:) isPost:NO failedSEL:@selector(ask_tabFail:)];
}
#pragma mark 获取问答标签成功返回
-(void)ask_tabSuccess:(id)dataSource
{
    addArray=[dataSource objectForKey:@"data"];
    [_collectionView reloadData];
}
#pragma mark 获取问答标签失败返回
-(void)ask_tabFail:(id)dataSource
{
    NSLog(@"获取问答标签失败返回%@",dataSource);
}
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
{
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return addArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=addArray[indexPath.row];
    NSString *identify=@"cell";//[NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    //    NSDictionary *dataDic=plusArray[indexPath.row];
    AddLabelCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义cell就不可能进来了");
    }
//    NSString *string=[NSString stringWithFormat:@"%@",addArray[indexPath.row]];
    if ([_textArray containsObject:dic]) {
        cell.nameLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
//        [_textArray addObject:dic];
    }else{
        cell.nameLabel.textColor=[UIColor blackColor];
    }
    cell.nameLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"tag_name"]];
    cell.nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    cell.nameLabel.textAlignment=NSTextAlignmentCenter;
    cell.backgroundColor=[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((WIDTH-25)/4, 40);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size={WIDTH,0};
    return size;
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
    NSDictionary *dic=addArray[indexPath.row];
    if ([_textArray containsObject:dic]) {
        [_textArray removeObject:dic];
    }else{
        [_textArray addObject:dic];
    }
    [_collectionView reloadData];
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
