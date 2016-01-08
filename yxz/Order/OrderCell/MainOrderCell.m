//
//  MainOrderCell.m
//  simi
//
//  Created by 赵中杰 on 14/11/28.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "MainOrderCell.h"
#import "OrderTime.h"
@implementation MainOrderCell
@synthesize cityArray = _cityArray;

#define CELL_HEIGHT 82        //  cell高度
#define IMAGE_XY 46             //头像宽度
#define X_S 18                //  头像距离屏幕左边距
#define Y_S 18                //  头像距离屏幕上边距
#define TEXT_X 14             //  文字距离头像右边距
#define TEXT_Y 18             //  文字距离屏幕上边距
#define DTEXT_U 9             //  第二行文字距离第一行文字边距

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = COLOR_VAULE(255.0);
        
        //   头像
        UIImageView *_headimageView = [[UIImageView alloc]initWithFrame:FRAME(X_S, Y_S, CELL_HEIGHT-Y_S*2, CELL_HEIGHT-Y_S*2)];
        [_headimageView setTag:100];
        [_headimageView setImage:IMAGE_NAMED(@"index-guandaoshutong")];
        [self addSubview:_headimageView];
        
        
        //   三个label
        for (int i = 0; i < 3; i ++) {
            
            UILabel *_label = [[UILabel alloc]init];
            _label.backgroundColor = DEFAULT_COLOR;
            [_label setTag:101+i];
            
            switch (i) {
                case 0:
                    _label.textColor = [self getColor:@"E8374A"];
                    _label.font = MYFONT(13.5);
                    _label.adjustsFontSizeToFitWidth = YES;
                    _label.frame = FRAME(X_S+IMAGE_XY+TEXT_X, TEXT_Y, 120, 14);
                    break;
                    
                case 1:
                    _label.textColor = [self getColor:@"666666"];
                    _label.font = MYFONT(13.5);
                    _label.adjustsFontSizeToFitWidth = YES;
                    _label.frame = FRAME(X_S+IMAGE_XY+TEXT_X, TEXT_Y+31, 160, 12);
                    break;
                    
                case 2:
                    _label.textColor = [self getColor:@"b1b1b1"];
                    _label.font = MYFONT(10);
                    _label.frame = FRAME(X_S+IMAGE_XY+TEXT_X, TEXT_Y+14+26, _CELL_WIDTH-X_S+IMAGE_XY+TEXT_X-65, 10);
                    break;
                    
                    
                default:
                    break;
            }
            
            [self addSubview:_label];
        }
        
        
        //    订单状态按钮
        UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = FRAME(_CELL_WIDTH-18-56, 34, 56, 14);
        _button.backgroundColor = DEFAULT_COLOR;
        _button.titleLabel.font = [UIFont systemFontOfSize:13.5];
        //        [_button setTitle:@"已接单" forState:UIControlStateNormal];
        [_button setTitleColor:[self getColor:@"E8374A"] forState:UIControlStateNormal];
        [_button setTag:104];
        [self addSubview:_button];
        
        
        UIImageView *_lineView = [[UIImageView alloc]initWithFrame:FRAME(0, 81.5, _CELL_WIDTH, 0.5)];
        _lineView.backgroundColor = COLOR_VAULE(209.0);
        [self addSubview:_lineView];
        
        
    }
    return self;
}


- (void)setDatamodel:(ORDERLISTData *)datamodel
{
    _datamodel = datamodel;
    
    int orderstatus = (int)datamodel.serviceType;
    
//    OrderTime *timeData = [[OrderTime alloc]init];
    
//    NSArray *imageArray = [[NSArray alloc]initWithObjects:@"index-zuofan",@"index-xiyi",@"index-jiadianqingxi",@"index-baojie",@"index-caboli",@"index-guandaoshutong",@"index-xinjukaihuang", nil];
    UIImageView *logimg = (UIImageView *)[self viewWithTag:100];
//    [_avatarview setImage:[UIImage imageNamed:[imageArray objectAtIndex:orderstatus-1]]];
    
    //图标

    switch (orderstatus) {
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
    
    UILabel *namelabel = (UILabel *)[self viewWithTag:101];
//    switch (orderstatus) {
//        case 1:
//            namelabel.text = @"做饭";
//            break;
//        case 2:
//            namelabel.text = @"洗衣";
//            break;
//        case 3:
//            namelabel.text = @"家电清洗";
//            break;
//        case 4:
//            namelabel.text = @"保洁";
//            break;
//        case 5:
//            namelabel.text = @"擦玻璃";
//            break;
//        case 6:
//            namelabel.text = @"管道疏通";
//            break;
//        case 7:
//            namelabel.text = @"新居开荒";
//            break;
//            
//        default:
//            break;
//    }
    namelabel.text = datamodel.service_type_name;
    
    UILabel *timelabel = (UILabel *)[self viewWithTag:102];
    NSString *timStr = [[self getTimeWithstring:datamodel.addTime] substringToIndex:16];
    timelabel.text = timStr;
    
//    UILabel *dresslabel = (UILabel *)[self viewWithTag:103];
//    dresslabel.text = [NSString stringWithFormat:@"%@%@",datamodel.name,datamodel.addstr];
    
    UIButton *_button = (UIButton *)[self viewWithTag:104];
    int _status = (int)datamodel.orderStatus;
    switch (_status) {
        case 0:
            [_button setTitle:@"已关闭" forState:UIControlStateNormal];
            [_button setTitleColor:[self getColor:@"666666"] forState:UIControlStateNormal];
            break;
        case 1:
            [_button setTitle:@"待确认" forState:UIControlStateNormal];
            [_button setTitleColor:[self getColor:@"E8374A"] forState:UIControlStateNormal];
            break;
        case 2:
            [_button setTitle:@"已确认" forState:UIControlStateNormal];
            [_button setTitleColor:[self getColor:@"E8374A"] forState:UIControlStateNormal];
            
//
//            //判断当前时间和服务结束时间
//            BOOL time1 = [timeData TimeOutWith:[self getTimeWithstring:datamodel.startTime] hours:[[NSString stringWithFormat:@"%f",datamodel.serviceHours] integerValue]];
//            NSLog(@"%@",[self getTimeWithstring:datamodel.startTime]);
//            
//            //判断当前时间和服务开始时间
//            BOOL time2 = [timeData TimeOutWith:[self getTimeWithstring:datamodel.startTime] hours:0];
//            
//            if (time1 == NO && time2 == YES) {
//                [_button setTitle:@"即将服务" forState:UIControlStateNormal];
//            }
//            if (time1 == YES) {
//                [_button setTitle:@"待评价" forState:UIControlStateNormal];
//            }
//            if (time2 == NO){
//                [_button setTitle:@"待服务" forState:UIControlStateNormal];
//            }
            
            break;
        case 3:
            [_button setTitle:@"待支付" forState:UIControlStateNormal];
            [_button setTitleColor:[self getColor:@"E8374A"] forState:UIControlStateNormal];
            
//            //判断当前时间和服务结束时间
//            BOOL time3 = [timeData TimeOutWith:[self getTimeWithstring:datamodel.startTime] hours:[[NSString stringWithFormat:@"%f",datamodel.serviceHours] integerValue]];
//            NSLog(@"%@",[self getTimeWithstring:datamodel.startTime]);
//            
//            //判断当前时间和服务开始时间
//            BOOL time4 = [timeData TimeOutWith:[self getTimeWithstring:datamodel.startTime] hours:0];
//            
//            if (time3 == NO && time4 == YES) {
//                [_button setTitle:@"即将服务" forState:UIControlStateNormal];
//            }
//            if (time3 == YES) {
//                [_button setTitle:@"待评价" forState:UIControlStateNormal];
//            }
//            if (time4 == NO){
//                [_button setTitle:@"待服务" forState:UIControlStateNormal];
//            }
//            
            
            
            break;
        case 4:
            [_button setTitle:@"已支付 " forState:UIControlStateNormal];
            [_button setTitleColor:[self getColor:@"E8374A"] forState:UIControlStateNormal];
            
            break;
//        case 5:
//            [_button setTitle:@"待评价" forState:UIControlStateNormal];
//            [_button setTitleColor:[self getColor:@"E8374A"] forState:UIControlStateNormal];
//            break;
//            
//        case 6:
//            [_button setTitle:@"已完成" forState:UIControlStateNormal];
//            [_button setTitleColor:[self getColor:@"666666"] forState:UIControlStateNormal];
//            
//            break;
//            
//        case 7:
//            [_button setTitle:@"已关闭" forState:UIControlStateNormal];
//            [_button setTitleColor:[self getColor:@"666666"] forState:UIControlStateNormal];
            
            break;
            
            
        case 9:
            [_button setTitle:@"已完成" forState:UIControlStateNormal];
            [_button setTitleColor:[self getColor:@"E8374A"] forState:UIControlStateNormal];

            break;
            
            
        default:
            break;
    }
}

- (ORDERLISTData *)datamodel
{
    return _datamodel;
}





@end
