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
    teacherlabel.text = [NSString stringWithFormat:@"%@: %@",@"讲师", model.teacher, @"没有"];
    totalPersonLabel.text = [NSString stringWithFormat:@"%@%@", model.total_view, @"人已看过"];
    priceLabel.text = [NSString stringWithFormat:@"￥%0.2f", model.price];
    dis_priceLabel.text = [NSString stringWithFormat:@"￥%0.2f", model. dis_price];
    
    myTextView.contentOffset = CGPointZero;
    myTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    NSString * htmlString = [NSString stringWithFormat:@"%@",model.content];
    //    NSString *str1 = [htmlString substringFromIndex:1];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    NSString * str = [NSString stringWithFormat:@"%@",attrStr];
    NSLog(@"%@------%@",attrStr,str);
    
    if (!(htmlString.length == str.length)) {
//        
//        CGFloat threeLabelh = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}  context:nil].size.width;
//        hight.constant = threeLabelh+40;
//        viewbottom.constant = 109-77+threeLabelh+40;
        myTextView.attributedText = attrStr;
        //        myTextView.bounds.size.width = threeLabelh;
        
        
    }else{
//        CGFloat threeLabelw = [htmlString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}  context:nil].size.width;
//        hight.constant = threeLabelw+1;
//        viewbottom.constant = 109-77+threeLabelw+10;
        
        myTextView.text = htmlString;
        
    }

    myTextView.textColor = RGBACOLOR(153, 153, 153, 1.0);
//    [self.mediaPlayBtn addTarget:self action:@selector(mediaPlayBtnClicks:) forControlEvents:UIControlEventTouchDown];
//    self.mediaPlayBtn.backgroundColor = [UIColor redColor];
    
}
//-(void)mediaPlayBtnClicks:(UIButton *)sender{
//    if ([self.delegate respondsToSelector:@selector(mediaPlayBtnClick:)]) {
//        
//        [self.delegate mediaPlayBtnClick:self];
//        
//    }
//
//}
@end
