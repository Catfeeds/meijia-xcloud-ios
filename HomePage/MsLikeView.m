//
//  MsLikeView.m
//  yxz
//
//  Created by apple on 2017/4/25.
//  Copyright © 2017年 zhirunjia.com. All rights reserved.
//

#import "MsLikeView.h"
#import "HomePageTableViewCell.h"
@interface MsLikeView()<UITableViewDelegate,UITableViewDataSource>


@end
@implementation MsLikeView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
        [self setTableFooterView:v];
        self.tableHeaderView = [self returnHeaderView];
    }
    return self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic=self.dataArr[indexPath.row];
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    HomePageTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[HomePageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"thumbnail"]];
    [cell.headeImageVIew setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:nil];
    cell.titleLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    [cell.titleLabel setNumberOfLines:2];
    [cell.titleLabel sizeToFit];
    NSArray *viewsArray=[[dic objectForKey:@"custom_fields"]objectForKey:@"views"];
    cell.subTitleLabel.text=[NSString stringWithFormat:@"%@人已看过",viewsArray[0]];
    
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;
}
-(UIView * )returnHeaderView{
    
    //定义headerView
    UIView * headerView = [[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 32)];
    headerView.backgroundColor = [UIColor colorForHex:@"#f7f7f7"];
    UILabel * headerTitle = [[UILabel alloc]initWithFrame:FRAME((WIDTH - 81) /2 , 6, 81, 20)];
    headerTitle.text = @"猜你喜欢";
    headerTitle.textColor = [UIColor colorForHex:@"333333"];
    headerTitle.textAlignment = NSTextAlignmentCenter;
    headerTitle.font =[UIFont systemFontOfSize:12];
    [headerView addSubview:headerTitle];
    //两根分割线
    UIView *  leftView = [[UIView alloc]initWithFrame:FRAME((WIDTH - 81) /2 - 12 - 87, 15.5, 87, 0.5)];
    leftView.backgroundColor = [UIColor redColor];
    [headerView addSubview:leftView];
    UIView * rightView = [[UIView alloc]initWithFrame:FRAME((WIDTH + 81) /2 + 12 , 15.5, 87, 0.5)];
    rightView.backgroundColor = [UIColor redColor];
    [headerView addSubview:rightView];
    

    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectLikeBook(self.dataArr[indexPath.row]);

}
@end
