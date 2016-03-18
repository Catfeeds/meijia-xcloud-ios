//
//  DropDown.m
//  yxz
//
//  Created by 白玉林 on 16/3/14.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "DropDown.h"
#import "DefaultCompanyViewController.h"
@implementation DropDown
@synthesize tv,tableArray,textField;
-(id)initWithFrame:(CGRect)frame
{
    if ((frame.size.height=200)) {
        frameHeight = 200;
    }else{
        frameHeight = frame.size.height;
    }
    tabheight = frameHeight-30;
    
    frame.size.height = 30.0f;
    
    self=[super initWithFrame:frame];
    
    if(self){
        
        UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 10)];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME(60, 0, 20, 10)];
        imageView.image=[UIImage imageNamed:@"iconfont-sanjiao"];
        [view addSubview:imageView];
        showList = NO; //默认不显示下拉框
        
        tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
        tv.delegate = self;
        tv.dataSource = self;
        tv.tableHeaderView=view;
        tv.backgroundColor =[UIColor clearColor];
        tv.hidden = YES;
        [self addSubview:tv];
        UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
        v.backgroundColor=HEX_TO_UICOLOR(0x4e5256, 1.0);
        [tv setTableFooterView:v];
        
    }
    return self;
}
-(void)dropdown{
    [textField resignFirstResponder];
    if (showList) {//如果下拉框已显示，什么都不做
        showList = NO;
        tv.hidden = YES;
        CGRect frame = tv.frame;
        frame.size.height = 0;
        tv.frame = frame;
        return;
    }else {//如果下拉框尚未显示，则进行显示
        CGRect sf = self.frame;
        sf.size.height = frameHeight;
        //把dropdownList放到前面，防止下拉框被别的控件遮住
        [self.superview bringSubviewToFront:self];
        tv.hidden = NO;
        showList = YES;//显示下拉框
        
        CGRect frame = tv.frame;
        frame.size.height = 0;
        tv.frame = frame;
        frame.size.height = tabheight;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.frame = sf;
        tv.frame = frame;
        [UIView commitAnimations];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [tableArray objectAtIndex:[indexPath row]];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor=HEX_TO_UICOLOR(0x4e5256, 1.0);
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    textField.text = [tableArray objectAtIndex:[indexPath row]];
    [tv deselectRowAtIndexPath:indexPath animated:NO];
    int indeID=(int)indexPath.row;
    [_delegate pullDownAnimated:indeID];
    showList = NO;
    tv.hidden = YES;
    
    CGRect sf = self.frame;
    sf.size.height = 30;
    self.frame = sf;
    CGRect frame = tv.frame;
    frame.size.height = 0;
    tv.frame = frame;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
