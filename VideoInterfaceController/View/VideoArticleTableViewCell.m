//
//  VideoArticleTableViewCell.m
//  yxz
//
//  Created by xiaotao on 16/9/11.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "VideoArticleTableViewCell.h"

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
    
    self.imageView.layer.cornerRadius = 6;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSObject *)data
{
    
}
@end
