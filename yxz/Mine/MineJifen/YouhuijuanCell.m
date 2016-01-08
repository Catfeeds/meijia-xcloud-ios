//
//  YouhuijuanCell.m
//  simi
//
//  Created by 赵中杰 on 14/12/23.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "YouhuijuanCell.h"

@implementation YouhuijuanCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UILabel *_backlabel = [[UILabel alloc]initWithFrame:FRAME(18.5, 20, _CELL_WIDTH-37, 107)];
        [_backlabel setTag:100];
        _backlabel.backgroundColor = COLOR_VAULE(255.0);
        _backlabel.layer.cornerRadius = 5;
        _backlabel.layer.borderWidth = 0.5;
        _backlabel.layer.borderColor = COLOR_VAULE(211.0).CGColor;
        _backlabel.layer.masksToBounds = YES;
        //_backlabel.backgroundColor=[UIColor redColor];
        [self addSubview:_backlabel];
        
        UIImageView *_headimageview = [[UIImageView alloc]initWithFrame:FRAME(18, 10, _CELL_WIDTH-36, 86)];
        [_headimageview setImage:[IMAGE_NAMED(@"purple-card_") stretchableImageWithLeftCapWidth:20 topCapHeight:7]];
        [self addSubview:_headimageview];
        
        UIImageView *_leftview = [[UIImageView alloc]initWithFrame:FRAME(18+14, 15, 55, 55)];
        [_leftview setImage:IMAGE_NAMED(@"logo_")];
        [self addSubview:_leftview];
        
        for (int i = 0; i < 3; i ++) {
            UILabel *_contentlabel = [[UILabel alloc]init];
            [_contentlabel setTag:(101+i)];
            switch (i) {
                case 0:
                    _contentlabel.frame = FRAME(28+65, 10+27, _CELL_WIDTH-28-65-28, 22);
                    _contentlabel.text = @"￥";
                    _contentlabel.font = MYBOLD(20);
                    _contentlabel.textAlignment = NSTextAlignmentRight;
                    _contentlabel.textColor = COLOR_VAULE(255.0);
                    break;
                    
                case 1:
                    _contentlabel.frame = FRAME(28+65, 10+54, _CELL_WIDTH-28-65-28, 22);
                    _contentlabel.text = @"名字";
                    _contentlabel.font = MYFONT(10);
                    _contentlabel.textAlignment = NSTextAlignmentRight;
                    _contentlabel.textColor = COLOR_VAULE(255.0);
                    break;

                case 2:
                    _contentlabel.frame = FRAME(28+65, 10, _CELL_WIDTH-28-65-28, 22);
                    _contentlabel.text = @"过期时间";
                    _contentlabel.font = MYFONT(17);
                    _contentlabel.textAlignment = NSTextAlignmentRight;
                    _contentlabel.textColor = COLOR_VAULE(255.0);
                    break;
                default:
                    break;
            }
            
            [self addSubview:_contentlabel];
        }
        
        
        UILabel *_describtionlabel = [[UILabel alloc]initWithFrame:FRAME(30, 20+75, _CELL_WIDTH-60, 60)];
        _describtionlabel.font = MYFONT(10);
        [_describtionlabel setTextColor:[self getColor:@"b1b1b1"]];
        _describtionlabel.numberOfLines = 0;
        _describtionlabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_describtionlabel setTag:104];
        [self addSubview:_describtionlabel];
        
    }
    
    return self;
}



- (void)setMydata:(YOUHUIData *)mydata
{
    _mydata = mydata;
    
    //NSDictionary *dic = [NSDictionary ]
    NSLog(@"优惠劵数据 查看%@",_mydata);

    CGSize _dessize = [self returnMysizeWithCgsize:CGSizeMake(_CELL_WIDTH-60, WIDTH) text:mydata.dataDescription font:MYFONT(10)];
    UILabel *_backlabel = (UILabel *)[self viewWithTag:100];
    _backlabel.frame = FRAME(18.5, 20, _CELL_WIDTH-37, 65+10+_dessize.height + 16);
    
    UILabel *_moneylabel = (UILabel *)[self viewWithTag:101];
    _moneylabel.text = [NSString stringWithFormat:@"￥ %.f",mydata.value];
    
    UILabel *_namelabel = (UILabel *)[self viewWithTag:102];
    _namelabel.frame=FRAME(28+65, 10+54, _CELL_WIDTH-28-65-28, 22);
    _namelabel.text = mydata.introduction;
    [_namelabel setNumberOfLines:2];
    [_namelabel sizeToFit];
    
    
    
    UILabel *_deslabel = (UILabel *)[self viewWithTag:104];
    NSString *str = [NSString stringWithFormat:@"%@",mydata.dataDescription];
    NSString *str2 = [str stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
    _deslabel.text = str2;
    NSLog(@"%@",_deslabel.text);
    _deslabel.frame = FRAME(30, 20+75, _CELL_WIDTH-60, _dessize.height+20);
    
}
- (void)setDic:(NSString *)dic{
    _dic=dic;
    UILabel *_timelabel = (UILabel *)[self viewWithTag:103];
    _timelabel.text =[NSString stringWithFormat:@"到期时间%@",dic];

}

- (YOUHUIData *)mydata
{
    return _mydata;
}


@end
