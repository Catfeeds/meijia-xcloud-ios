//
//  VideoArticleHeaderView.h
//  yxz
//
//  Created by xiaotao on 16/9/11.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class VideoArticleHeaderView;
//@protocol VideoArticleHeaderViewDelegate <NSObject>
//@optional
//-(void)mediaPlayBtnClick:(VideoArticleHeaderView *)HeaderView;
//
//
//@end

@interface VideoArticleHeaderView : UIView
//@property (weak, nonatomic) id <VideoArticleHeaderViewDelegate> delegate;

//@property (weak, nonatomic) IBOutlet UIButton * mediaPlayBtn;


@property (nonatomic, strong) NSString *cid;

@property (nonatomic, strong) NSString *appKey;

@property (nonatomic, strong) NSString *appSecret;

@property (nonatomic, strong) NSString *vid;

- (void)setData:(NSObject *)data;
@end
