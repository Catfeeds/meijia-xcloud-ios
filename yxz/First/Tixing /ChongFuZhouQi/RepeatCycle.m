//
//  RepeatCycle.m
//  simi
//
//  Created by zrj on 14-11-28.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "RepeatCycle.h"
#import "ChoiceDefine.h"
#import "AppDelegate.h"
#import "RepeatCell.h"

@implementation RepeatCycle
@synthesize delegate = _delegate;
- (id)initWithFrame:(CGRect)frame numbenr:(NSInteger )nmb
{
    self = [super initWithFrame:frame];
    if (self) {
        
        number = nmb;
        
        UILabel *title = [[UILabel alloc]initWithFrame:FRAME(0, 0, self_Width, 40)];
        title.textColor = [UIColor blackColor];
        title.font = [UIFont systemFontOfSize:14];
        title.textAlignment = NSTextAlignmentCenter;
        title.text = @"重复";
        [self addSubview:title];
        
        self.backgroundColor = [UIColor whiteColor];
        
        _mytableView = [[UITableView alloc]initWithFrame:FRAME(0, 50, self_Width, self_height)];
        
        _mytableView.delegate = self;
        
        _mytableView.dataSource = self;
        
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self addSubview:_mytableView];
        
        
    }
    return self;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return APPLIACTION.repartArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    RepeatCell *Cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (Cell == nil) {
        Cell = [[RepeatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    
    Cell.backgroundView = nil;
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    Cell.tag = indexPath.row;
    Cell.titleLab.tag = indexPath.row+200;
    
    Cell.titleLab.text = [APPLIACTION.repartArray objectAtIndex:indexPath.row];

    if(indexPath.row == 0){
        Cell.titleLab.textColor = HEX_TO_UICOLOR(LABLE_COLOR, 1.0);
    }else{
        Cell.titleLab.textColor = HEX_TO_UICOLOR(0x666666, 1.0);
    }
    
   //此处是为了记录他点了那行了

    NSInteger a = number;
    NSLog(@"celltg == %ld",(long)a);
    if (a > 0) {
        if(indexPath.row == a)
        {
            Cell.titleLab.textColor = HEX_TO_UICOLOR(LABLE_COLOR, 1.0);
        }else{
            Cell.titleLab.textColor = HEX_TO_UICOLOR(0x666666, 1.0);
        }
        
    }

    if(APPLIACTION.repartArray.count < a){

        if(indexPath.row == 0){
            Cell.titleLab.textColor = HEX_TO_UICOLOR(LABLE_COLOR, 1.0);
        }else{
            Cell.titleLab.textColor = HEX_TO_UICOLOR(0x666666, 1.0);
        }
        
            
    }
    
    return Cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str;
    NSArray *visiblecells = [_mytableView visibleCells];
    for(UITableViewCell *cell in visiblecells)
    {
        for (UIView *view in cell.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                if (view.tag == indexPath.row+200) {
                   
                    UILabel *lable = (UILabel *)view;
                    str = lable.text;
                    lable.textColor = HEX_TO_UICOLOR(LABLE_COLOR, 1.0);
                }
                else
                {
                    
                    UILabel *lable = (UILabel *)view;
                    lable.textColor = HEX_TO_UICOLOR(0x666666, 1.0);
                }
            }
        }
    }


    
    [self.delegate repeartdelegate:str Celltag:indexPath.row];
    
}
@end
