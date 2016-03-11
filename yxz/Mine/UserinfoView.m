//
//  UserinfoView.m
//  simi
//
//  Created by 赵中杰 on 14/12/23.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "UserinfoView.h"

@interface UserinfoView ()
{
    UITextField *_rightlabel;
    int user_type;
}
@end
@implementation UserinfoView
@synthesize delegate = _delegate,headImg;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UILabel *_backlabel = [[UILabel alloc]initWithFrame:FRAME(0, 9, _CELL_WIDTH, 54*5+15)];
        _backlabel.backgroundColor = COLOR_VAULE(255.0);
        [self addSubview:_backlabel];
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString *type=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"user_type"]];
        user_type=[type intValue];
        NSArray *_nameArr;
        if (user_type==1) {
            _nameArr= @[@"头像",@"昵称：",@"手机：",@"性别：",@"封面相册："];
        }else{
            _nameArr= @[@"头像",@"昵称：",@"手机：",@"性别：",@"封面相册："];
        }
        
        
        for (int i = 0; i < 5; i ++) {
            
            UILabel *_leftlabel = [[UILabel alloc]init];
                        [self addSubview:_leftlabel];
            if (i==4) {
                _leftlabel.text = [_nameArr objectAtIndex:i];
                 _leftlabel.textColor = COLOR_VAULE(102.0);
                 _leftlabel.font = MYFONT(13.5);
                [_leftlabel setNumberOfLines:1];
                [_leftlabel sizeToFit];
                _leftlabel.frame=FRAME(18, 24+54*i, _leftlabel.frame.size.width, 54);
            }else{
                _leftlabel.frame=FRAME(18, 24+54*i, 60, 54);
                _leftlabel.textColor = COLOR_VAULE(102.0);
                _leftlabel.font = MYFONT(13.5);
                _leftlabel.text = [_nameArr objectAtIndex:i];

            }
            
            _rightlabel = [[UITextField alloc]initWithFrame:FRAME(70, 24+54*i, _CELL_WIDTH-70-25, 54)];
            _rightlabel.textColor = [self getColor:@"E8374A"];
            _rightlabel.delegate = self;
            _rightlabel.textAlignment = NSTextAlignmentRight;
            _rightlabel.returnKeyType = UIReturnKeyDone;
            _rightlabel.font = MYFONT(13.5);
            [_rightlabel setTag:(1000+i)];
            [self addSubview:_rightlabel];
            if (i == 0 || i == 3||i ==4) {
                _rightlabel.userInteractionEnabled = NO;
            }
            
            UIImageView *rightImgView = [[UIImageView alloc]initWithFrame:FRAME(self_Width-24.5-10, 0, 24.5, 24.5)];
            rightImgView.top = i == 0? (69-24.5)/2+10 : 40+54*i;
            rightImgView.hidden = i == 2? YES : NO;
            rightImgView.image = [UIImage imageNamed:@"s-right-arrow@2x"];
            rightImgView.hidden = YES;
            [self addSubview:rightImgView];
            
            
            UIButton *btn = [[UIButton alloc]initWithFrame:FRAME(0, 0, self_Width, 54)];
            btn.top = i == 0? 19 : 69+54*(i-1);
//            btn.backgroundColor = [UIColor redColor];
            btn.tag = i;
            [btn addTarget:self action:@selector(BtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
        }
        
        for (int i = 0; i < 6; i ++) {
            UIImageView *_lineview = [[UIImageView alloc]initWithFrame:FRAME(0, 24+54*i, _CELL_WIDTH, 0.5)];
            _lineview.backgroundColor = COLOR_VAULE(211.0);
            _lineview.hidden = i == 0? YES : NO;
            [self addSubview:_lineview];
        }
        
        //头像
        //UIImage *image = [GetPhoto getPhotoFromName:@"image.png"];
        
        headImg = [[UIImageView alloc]init];

        [headImg.layer setCornerRadius:45/2];
        headImg.layer.masksToBounds = YES;
        headImg.tag=100001;
//        if (image) {
//            headImg.image = image;
//        }else{
//            headImg.image = [UIImage imageNamed:@"chatListCellHead@2x"];
//        }
        
        headImg.frame = FRAME(self_Width-34.5-45, 22, 45, 45);
        
        [self addSubview:headImg];
        
    }
    
    return self;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    for (int i = 0; i < 5; i++) {
        UITextField *_label = (UITextField *)[self viewWithTag:(1000+i)];

        switch (i) {
            case 0:
                [_label resignFirstResponder];
                break;
            case 1:
                [_label resignFirstResponder];
                break;
            case 2:
                [_label resignFirstResponder];
                break;
            case 3:
                [_label resignFirstResponder];
                break;
            case 4:
                [_label resignFirstResponder];
                break;
                
            default:
                break;
        }
    }
    return YES;
}

- (void)BtnAction:(UIButton *)sender
{
    [self.delegate selectBrnPressedWithTag:sender.tag];
    UITextField *textfield = (UITextField *)[self viewWithTag:(1000+sender.tag)];
    [textfield becomeFirstResponder];
}

- (void)setMydata:(USERINFOData *)mydata
{
    for (int i = 0; i < 5; i ++) {
        UITextField *_label = (UITextField *)[self viewWithTag:(1000+i)];
        switch (i) {
            case 0:
//                _label.text = mydata.mobile;
                break;
                
            case 1:
//                _label.text = [NSString stringWithFormat:@"%0.1f元",mydata.restMoney];
                _label.text = mydata.userName;
                break;

            case 2:
                _label.text = [NSString stringWithFormat:@"%@",mydata.mobile];
                break;

            case 3:
                _label.text = [NSString stringWithFormat:@"%@",mydata.gender];
                break;
                
            case 4:
                if (user_type==1) {
                    _label.hidden=YES;
                    UIImageView *image=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-40, 41+54*4+5/2, 15, 15)];
                    image.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
                    [self addSubview:image];
                }else{
                    _label.hidden=YES;
                    UIImageView *image=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-40, 41+54*4+5/2, 15, 15)];
                    image.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
                    [self addSubview:image];
                    if (mydata.seniorRange.length) {
                        _label.text = mydata.seniorRange;
                    }else{
                        _label.text = mydata.seniorRange;
                        
                    }

                }
                
                break;

            default:
                break;
        }
    }
}
-(void)setHeadeImage:(UIImage *)headeImage
{
    _headeImage=headeImage;
    headImg=[(UIImageView *)self viewWithTag:100001];
    headImg.image=headeImage;
}
- (UIImage *)headeImage
{
    return _headeImage;
}
- (USERINFOData *)mydata
{
    return _mydata;
}


@end
