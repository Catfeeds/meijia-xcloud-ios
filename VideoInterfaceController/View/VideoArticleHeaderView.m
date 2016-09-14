//
//  VideoArticleHeaderView.m
//  yxz
//
//  Created by xiaotao on 16/9/11.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "VideoArticleHeaderView.h"
#import "VideoDetailModel.h"
#import "UIImageView+WebCache.h"

@interface VideoArticleHeaderView ()
{
    IBOutlet UIImageView *detailImgView;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *teacherlabel;
    IBOutlet UILabel *totalPersonLabel;
    IBOutlet UILabel *priceLabel;
    IBOutlet UILabel *dis_priceLabel;
    IBOutlet UITextView *myTextView;
}

@end

@implementation VideoArticleHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setData:(NSObject *)data
{
    VideoDetailModel *model = (VideoDetailModel *)data;
    [detailImgView setImageWithURL:[NSURL URLWithString:model.img_url]];
    titleLabel.text = model.title;
    teacherlabel.text = [NSString stringWithFormat:@"%@: %@",@"讲师", @"没有"];
    totalPersonLabel.text = [NSString stringWithFormat:@"%@%@", model.total_view, @"人已看过"];
    priceLabel.text = [NSString stringWithFormat:@"￥%0.2f", model.price];
    dis_priceLabel.text = [NSString stringWithFormat:@"￥%0.2f", model. dis_price];
    
    myTextView.contentOffset = CGPointZero;
    myTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    myTextView.text = @"据重庆大学建筑城规学院有关负责人介绍，“楼纳国际高校建造设计大赛”是“楼纳国际山地建筑艺术节”的首要组成部分，落址于中国贵州黔西南州楼纳国际建筑师公社。竞赛由贵州省黔西南州义龙试验区管理委员会主办，中国建筑中心(CBC)与贵州省楼纳建筑师公社文化发展有限公司承办，吸引了来自国内外17所高校的师生团队，包括清华大学、同济大学、东南大学、湖南大";
    myTextView.textColor = RGBACOLOR(153, 153, 153, 1.0);
}
@end
