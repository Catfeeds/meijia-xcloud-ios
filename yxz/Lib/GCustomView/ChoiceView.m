//
//  ChoiceView.m
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "ChoiceView.h"
#import "ChoiceDefine.h"
@implementation ChoiceView
@synthesize delegate = _delegate;
@synthesize lables,images,btnRight;

- (id)initWithFrame:(CGRect)frame imagesArray:(NSArray *)imagesArray lableTextArray:(NSArray *)lableTextArray
{
    self = [super initWithFrame:frame];
    if (self) {
  
        float btnHeight = 106/2;
//        self.backgroundColor = [UIColor redColor];
        self.backgroundColor = HEX_TO_UICOLOR(CHOICE_BACK_VIEW_COLOR, 1.0);
        for (int i = 0; i < 3; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = FRAME(0, 0.5+(i*(btnHeight+0.5)), self.bounds.size.width, btnHeight);
            [btn setBackgroundColor:[UIColor whiteColor]];
            btn.tag = 30+i;
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(tiaozhuan:) forControlEvents:UIControlEventTouchUpInside];

            [self addSubview:btn];
            
            for (int i = 0; i < 3; i ++) {
                images = [[UIImageView alloc]initWithFrame:FRAME(18, 20+(52*i), 17, 17)];
                images.backgroundColor = DEFAULT_COLOR;
                images.image = [UIImage imageNamed:[imagesArray objectAtIndex:i]];
                [self addSubview:images];
                
                lables = [[UILabel alloc]initWithFrame:FRAME(36+17, 20+(52*i), 100, 17)];
                lables.text = [lableTextArray objectAtIndex:i];
                lables.textAlignment = NSTextAlignmentLeft;
                lables.textColor = HEX_TO_UICOLOR(LABLE_COLOR, 1.0);
                lables.tag = +i;
                lables.font = [UIFont boldSystemFontOfSize:14];
                [self addSubview:lables];
                
            }
            
            for (int i = 0; i < 2; i ++) {
                btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
                btnRight.tag = i+100;
                btnRight.frame = FRAME(self_Width-18-18, (btnHeight-13)/2+(i*btnHeight), 40/2, 40/2);
                [btnRight setBackgroundImage:[UIImage imageNamed:@"s-right-arrow"] forState:UIControlStateNormal];
                [self addSubview:btnRight];
            }
            
        }
    }
    return self;
}
- (void)tiaozhuan:(UIButton *)sender
{
    [self.delegate choiceDelegate:sender.tag];
}
@end
