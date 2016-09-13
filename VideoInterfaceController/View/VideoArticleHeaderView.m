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
}

@end

@implementation VideoArticleHeaderView

- (void)setData:(NSObject *)data
{
    VideoDetailModel *model = (VideoDetailModel *)data;
    [detailImgView setImageWithURL:[NSURL URLWithString:model.img_url]];
    titleLabel.text = model.title;
    teacherlabel.text = [NSString stringWithFormat:@"%@: %@",@"讲师", @"没有"];
    totalPersonLabel.text = [NSString stringWithFormat:@"%@%@", model.total_view, @"人已看过"];
    priceLabel.text = [NSString stringWithFormat:@"￥%0.2f", model.price];
    dis_priceLabel.text = [NSString stringWithFormat:@"￥%0.2f", model. dis_price];
}
@end
