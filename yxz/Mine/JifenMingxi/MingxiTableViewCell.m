//
//  MingxiTableViewCell.m
//  simi
//
//  Created by 赵中杰 on 14/12/11.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "MingxiTableViewCell.h"

@implementation MingxiTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIImageView *_lineview = [[UIImageView alloc]initWithFrame:FRAME(0, 0, _CELL_WIDTH, 7.5)];
        [_lineview setImage:IMAGE_NAMED(@"line_")];
        [self addSubview:_lineview];
        
        for (int i = 0; i < 3; i ++) {
            UILabel *_mingxilabel = [[UILabel alloc]init];
            _mingxilabel.font = MYFONT(13.5);
            [_mingxilabel setTag:(1000+i)];
            
            switch (i) {
                case 0:
                    _mingxilabel.frame = FRAME(18, 0, (_CELL_WIDTH-108)/3, 54);
                    _mingxilabel.textColor = COLOR_VAULE(187.0);
                    _mingxilabel.text = @"发布预约";
                    break;
                    
                case 1:
                    _mingxilabel.frame = FRAME(18+(_CELL_WIDTH-120+56)*0.5, 0, (_CELL_WIDTH-108)/3, 54);
                    _mingxilabel.textColor = COLOR_VAULE(187.0);
                    _mingxilabel.text = @"+5";
                    _mingxilabel.textColor = HEX_TO_UICOLOR(TEXT_COLOR, 1.0);
                    break;
                    
                case 2:
                    _mingxilabel.frame = FRAME(_CELL_WIDTH-18-(_CELL_WIDTH-108)/3, 0, (_CELL_WIDTH-108)/3, 54);
                    _mingxilabel.textColor = COLOR_VAULE(187.0);
                    _mingxilabel.text = @"2014-08-09";
                    _mingxilabel.font = MYFONT(13);
                    _mingxilabel.textAlignment = NSTextAlignmentRight;
                    break;

                default:
                    break;
            }
            
            [self addSubview:_mingxilabel];

        }
        
    }
    
    return self;
}


- (void)setMydata:(JIFENData *)mydata
{
    _mydata = mydata;

    NSLog(@"action is %f  score is %f  iscon is %f  time is %f",mydata.actionId,mydata.isConsume,mydata.score,mydata.addTime);
    
    UILabel *_namelabel = (UILabel *)[self viewWithTag:1000];
    if (mydata.actionId == 1) {
        _namelabel.text = @"订单获得积分";
    }else if (mydata.actionId == 2){
        _namelabel.text = @"订单使用积分";
    }else if(mydata.actionId == 3){
        _namelabel.text = @"分享获得积分";
    }
    
    UILabel *_scorelabel = (UILabel *)[self viewWithTag:1001];
    if (mydata.isConsume == 0) {
        _scorelabel.text = [NSString stringWithFormat:@"+%.f",mydata.score];
    }else{
        _scorelabel.text = [NSString stringWithFormat:@"-%.f",mydata.score];
    }
    
    NSString *_timestr = [self getTimeWithstring:mydata.addTime];
    UILabel *_timelabel = (UILabel *)[self viewWithTag:1002];
    _timelabel.text = _timestr;
}

- (JIFENData *)mydata
{
    return _mydata;
}


- (NSString *)getTimeWithstring:(NSTimeInterval)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *theday = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *day = [dateFormatter stringFromDate:theday];
    
    return day;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
