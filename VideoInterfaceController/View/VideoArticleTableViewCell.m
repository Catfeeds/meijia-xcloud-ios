//
//  VideoArticleTableViewCell.m
//  yxz
//
//  Created by xiaotao on 16/9/11.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "VideoArticleTableViewCell.h"
#import "VideoArticleModel.h"
#import "UIImageView+WebCache.h"

@interface VideoArticleTableViewCell ()
{
    IBOutlet UIImageView *imgeView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *subtitleLabel;
}
@end

@implementation VideoArticleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    imgeView.layer.cornerRadius = 6;
    imgeView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSObject *)data
{
    VideoArticleModel *model = (VideoArticleModel *)data;
    [imgeView setImageWithURL:[NSURL URLWithString:model.img_url]];
    imgeView.backgroundColor = [UIColor greenColor];
     nameLabel.text = model.title;
     subtitleLabel.text = [NSString stringWithFormat:@"%@%@", model.total_view, @"人已看过"];
}
@end
