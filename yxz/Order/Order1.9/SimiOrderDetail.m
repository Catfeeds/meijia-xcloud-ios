//
//  SimiOrderDetail.m
//  simi
//
//  Created by 高鸿鹏 on 15/6/22.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "SimiOrderDetail.h"

@interface SimiOrderDetail ()
{
    UIImageView *_backImage;
}
@end

@implementation SimiOrderDetail
@synthesize delegate = _delegate;
- (instancetype)initWithFrame:(CGRect)frame withModel:(SimiOrderDetailModel *)orderModel
{
        
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UILabel *orderNoLab = [[UILabel alloc]init];
        orderNoLab.frame = FRAME(10, 0, self_Width, 40);
        orderNoLab.backgroundColor = [UIColor clearColor];
        orderNoLab.font = [UIFont systemFontOfSize:12];
        orderNoLab.text = [NSString stringWithFormat:@"订单号: %@",orderModel.order_no];
        orderNoLab.textColor = [UIColor grayColor];
        [self addSubview:orderNoLab];
        
        
        //图标
        
        UIImageView *logImg = [[UIImageView alloc]init];
        logImg.tag = 333;
        logImg.image = [UIImage imageNamed:@"洗衣"];

        //服务类型
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.textColor = HEX_TO_UICOLOR(TEXT_COLOR, 1.0);
        titleLab.font = [UIFont systemFontOfSize:15];
        
        //支付类型
        UILabel *zhifuLab = [[UILabel alloc]init];
        zhifuLab.tag = 999;
        zhifuLab.textColor = HEX_TO_UICOLOR(TEXT_COLOR, 1.0);
        zhifuLab.font = [UIFont systemFontOfSize:15];
        zhifuLab.textAlignment = NSTextAlignmentRight;
        zhifuLab.userInteractionEnabled = YES;
        
        for (int i = 0; i < 5; i++) {
            
            CGFloat height = i == 0? 80 : 50;
            if (i == 1) {
                height = [self heightForString:[NSString stringWithFormat:@"%@",orderModel.service_content] fontSize:12 andWidth:self_Width-90];
                height = height >= 50? height : 50;
            }else if(i == 4)
            {
                height = [self heightForString:orderModel.remarks fontSize:12 andWidth:self_Width-90];
                height = height >= 50? height : 50;
            }
            
            _backImage = [[UIImageView alloc]init];
            _backImage.tag = 10+i;
            _backImage.frame = FRAME(0, 40, self_Width, height);
            _backImage.backgroundColor = i == 0 ? [UIColor whiteColor] : [UIColor whiteColor];
            [self addSubview:_backImage];
            if (i > 0) {
                UIImageView *image = (UIImageView *)[self viewWithTag:9+i];
                _backImage.frame = FRAME(0, image.bottom, self_Width, height);

            }
            
            UILabel *leftLab = [[UILabel alloc]init];
            leftLab.frame = _backImage.frame;
            leftLab.left = 20;
            leftLab.width = self_Width -110;
            leftLab.textAlignment = NSTextAlignmentLeft;
            leftLab.textColor = [UIColor grayColor];
            leftLab.font = [UIFont systemFontOfSize:12];
            [self addSubview:leftLab];
            
            UILabel *lable = [[UILabel alloc]init];
            lable.tag = 200+i;
            lable.frame = _backImage.frame;
            lable.width = i == 0 ? self_Width-90:self_Width-90;
            lable.right = self_Width-20;
            lable.textColor = [UIColor blackColor];
            lable.textAlignment = NSTextAlignmentRight;
            lable.font = [UIFont systemFontOfSize:12];
            lable.numberOfLines = 0;
            [self addSubview:lable];
            
            switch (i) {
                case 0:
                {
                    titleLab.frame = FRAME(70, _backImage.top+10, self_Width-70, 25);
                    titleLab.text = orderModel.service_type_name;
                    [self addSubview:titleLab];
                    
                    zhifuLab.frame = FRAME(self_Width-100, _backImage.top+15, 80, 25);
                    [self addSubview:zhifuLab];
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(StatusAction:)];
                    [zhifuLab addGestureRecognizer:tap];
                    
                    lable.frame = FRAME(70, _backImage.bottom-35, self_Width-70, 25);
                    lable.textAlignment = NSTextAlignmentLeft;
                    lable.textColor = [UIColor grayColor];
                    lable.text = [NSString stringWithFormat:@"%@",[self getTimeWithstring:orderModel.service_date]];
                    
                    logImg.frame = FRAME(10, (_backImage.height-40)/2, 40, 40);
                    [_backImage addSubview:logImg];
                }
                    break;
                case 1:
                    leftLab.text = @"内容:";
                    
                    lable.text =[NSString stringWithFormat:@"%@", orderModel.service_content];
                    break;
                case 2:
                    leftLab.text = @"金额:";

                    lable.text = [NSString stringWithFormat:@"%@",orderModel.order_money];
                    break;
                case 3:
                    leftLab.text = @"支付方式:";

                    break;
                case 4:
                    leftLab.text = @"备注:";

                    lable.text = orderModel.remarks;
                    break;

                    
                default:
                    break;
            }
            
            
            //分割线
            for (int i =0 ; i < 4; i++) {
                UILabel *henxian = [[UILabel alloc]init];
                henxian.tag = 100+i;
                henxian.frame = FRAME(5, _backImage.bottom-1, self_Width-10, 1);
                henxian.backgroundColor = HEX_TO_UICOLOR(BAC_VIEW_COLOR, 1.0);
                if (henxian.tag-100 == _backImage.tag-10) {
                    [self addSubview:henxian];
                }
                
            }

        }



        
        
    }
    return self;
}
- (void)StatusAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"touch status");
    
    UILabel *lable = (UILabel *)[self viewWithTag:999];
    
    [self.delegate PressDownWithTitle:lable.text];
    
}

- (void)setMyModel:(SimiOrderDetailModel *)myModel
{
    _myModel = myModel;
    UILabel *zfLab = (UILabel *)[self viewWithTag:999];
    
    switch (myModel.order_status) {
        case 0:
            zfLab.text = @"已关闭";
            break;
        case 1:
            zfLab.text = @"待确认";
            break;
        case 2:
            zfLab.text = @"已确认";
            break;
        case 3:
            zfLab.text = @"待支付";
            break;
        case 4:
            zfLab.text = @"已支付";
            break;
        case 9:
            zfLab.text = @"已完成";
            break;

        
        default:
            break;
    }
    
    UILabel *pay_Type_lab = (UILabel *)[self viewWithTag:203];
    switch ([myModel.order_pay_type intValue]) {
        case 0:
            pay_Type_lab.text = @"无需支付";
            break;
            
        case 1:
            pay_Type_lab.text = @"线上支付";
            break;
            
            
        default:
            break;
    }
    //图标
    UIImageView *logimg = (UIImageView *)[self viewWithTag:333];
    switch ([myModel.service_type intValue]) {
        case 1:
            logimg.image = [UIImage imageNamed:@"通用订单"];
            break;
        case 2:
            logimg.image = [UIImage imageNamed:@"快递"];
            break;
        case 3:
            logimg.image = [UIImage imageNamed:@"手机充值"];
            break;
        case 4:
            logimg.image = [UIImage imageNamed:@"餐厅"];
            break;
        case 5:
            logimg.image = [UIImage imageNamed:@"火车"];
            break;
        case 6:
            logimg.image = [UIImage imageNamed:@"飞机"];
            break;

            
        default:
            break;
    }
    
}

//时间戳转字符串
- (NSString *)getTimeWithstring:(NSTimeInterval)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *theday = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *day = [dateFormatter stringFromDate:theday];
    
    return day;
}
//返回字符串的高度
- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize]
                         constrainedToSize:CGSizeMake(width -16.0, CGFLOAT_MAX)
                             lineBreakMode:NSLineBreakByWordWrapping];
    //此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height + 16.0;
}

@end
