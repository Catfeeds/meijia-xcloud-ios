//
//  AddOrderDiscussView.h
//  simi
//
//  Created by 赵中杰 on 14/12/15.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherView.h"

@protocol ADDDISCUSSDELEGATE <NSObject>

- (void)adddiscussWithContent:(NSString *)content status:(NSInteger)selectstatus;

@end

@interface AddOrderDiscussView : FatherView
<UITextViewDelegate>
{
    UILabel *_placehodel;
    UITextView *_myfiled;
    
    
}
- (id)initWithFrame:(CGRect)frame serviceType:(NSString *)type startTime:(NSString *)startTime adress:(NSString *)adr;

@property (nonatomic, weak) __weak id <ADDDISCUSSDELEGATE> delegate;

@property (nonatomic, assign) NSInteger discussstatus;

@property (nonatomic, strong) UITextView *_myfiled;

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *ServiceType;

@end
