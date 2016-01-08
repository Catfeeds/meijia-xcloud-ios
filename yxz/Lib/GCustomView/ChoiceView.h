//
//  ChoiceView.h
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChoiceDelegate <NSObject>

- (void)choiceDelegate:(NSInteger )btnTag;

@end

@interface ChoiceView : UIView
{
    __weak id <ChoiceDelegate> _delegate;
    
    UILabel *lables;
    
    UIButton *btnRight;
}

@property (nonatomic , weak) __weak id <ChoiceDelegate> delegate;

@property (nonatomic , retain) UILabel *lables;

@property (nonatomic, retain) UIImageView *images;

@property (nonatomic, retain) UIButton *btnRight;

- (id)initWithFrame:(CGRect)frame imagesArray:(NSArray *)imagesArray lableTextArray:(NSArray *)lableTextArray;

@end
