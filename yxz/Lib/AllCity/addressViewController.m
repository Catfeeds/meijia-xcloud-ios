//
//  addressViewController.m
//  simi
//
//  Created by zrj on 14-11-12.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "addressViewController.h"
#import "ChoiceDefine.h"
#import "AppDelegate.h"
#import "AllCityCell.h"
#import "MBProgressHUD+Add.h"
#import "DownloadManager.h"
#import "ISLoginManager.h"
#import "CUSTOMDRESSData.h"
#import "SelectCityView.h"
@interface addressViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,SelectCityDelegate>
{
    UITextField *CommunityFiled;
    UITextField *menpaiField;
  
    NSMutableArray *dataArray;
    
    NSArray *sourceArray;

    UIButton *addBtn;
    UITableView * _mytableView;
    ALLCITYBaseClass *_selectdress;
    ISLoginManager *_manager;
    
    SelectCityView *listView;
    UIButton *citybtn;
}
@end

@implementation addressViewController
@synthesize delegate = _delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _manager = [ISLoginManager shareManager];
    
    
    self.navlabel.text = @"添加地址";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    dataArray = [[NSMutableArray alloc] init];
    
    UIView *view = [[UIView alloc]initWithFrame:FRAME(0, NAV_HEIGHT+9, SELF_VIEW_WIDTH, 108+1.5)];
    view.backgroundColor = HEX_TO_UICOLOR(CHOICE_BACK_VIEW_COLOR, 1.0);
    [self.view addSubview:view];

    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:FRAME(0, 0.5+((108/2+0.5)*i), SELF_VIEW_WIDTH, 108/2)];
        btn.backgroundColor = [UIColor whiteColor];
        [view addSubview:btn];
        
    }

    citybtn = [[UIButton alloc]initWithFrame:FRAME(12, 108/4-25/2, 40, 25)];
    [citybtn setTitle:@"北京" forState:UIControlStateNormal];
    citybtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [citybtn setBackgroundColor:DEFAULT_COLOR];
    [citybtn addTarget:self action:@selector(selectCityto:) forControlEvents:UIControlEventTouchUpInside];
    [citybtn setTitleColor:HEX_TO_UICOLOR(LABLE_COLOR, 1.0) forState:UIControlStateNormal];
    [view addSubview:citybtn];
    
    NSArray *dressArr = @[@"北京",@"天津"];
    
    listView = [[SelectCityView alloc]initWithFrame:FRAME(0, 64+20, 60, 0) titleArray:dressArr];
    listView.hidden = YES;
    listView.delegate = self;
    [self.view addSubview:listView];
    
    
    CommunityFiled =[[UITextField alloc]initWithFrame:FRAME(15+26+15, 0, SELF_VIEW_WIDTH-50, 108/2)];
    CommunityFiled.placeholder = @"请输入小区名称";
    CommunityFiled.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
    CommunityFiled.delegate = self;
    CommunityFiled.font = [UIFont systemFontOfSize:13];
    [view addSubview:CommunityFiled];
    
    
    menpaiField =[[UITextField alloc]initWithFrame:FRAME(16, 109/2, SELF_VIEW_WIDTH-50, 108/2)];
    menpaiField.placeholder = @"请输入具体门牌号";
    menpaiField.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
    menpaiField.delegate = self;
//    menpaiField.keyboardType = UIKeyboardTypeNumberPad;
    menpaiField.font = [UIFont systemFontOfSize:13];
    [view addSubview:menpaiField];
    
    UIButton *bttn = [UIButton buttonWithType:UIButtonTypeCustom];
    bttn.frame = FRAME(14, NAV_HEIGHT+9+14+108+1.5, 584/2, 108/2);
    [bttn setBackgroundColor:HEX_TO_UICOLOR(ROUND_COLOR, 1.0)];
    [bttn setTitle:@"确认" forState:UIControlStateNormal];
    [bttn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bttn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [bttn.layer setCornerRadius:5.0];//设置矩形四个圆角半径
    [self.view addSubview:bttn];
    
    [self makeTableview];
    // Do any additional setup after loading the view.
}
#define XSPACE 16
#define YSPACE 64
#pragma mark 点击城市按钮
- (void)selectCityto:(UIButton *)sender
{
    [citybtn setTitle:@"" forState:UIControlStateNormal];
    if (listView.frame.size.height < 10) {
        listView.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^void{
            listView.frame = FRAME(0, YSPACE+20, 60, 72);
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^void{
            listView.hidden = YES;
            listView.frame = FRAME(0, YSPACE+20, 60, 0);
        }];
    }
}
- (void)SelectCtiyDelegate:(NSString *)btntitle
{
    [UIView animateWithDuration:0.25 animations:^void{
        listView.hidden = YES;
        listView.frame = FRAME(0, YSPACE+20, 60, 0);
    }];
    [citybtn setTitle:btntitle forState:UIControlStateNormal];
}

- (void)makeTableview
{

    _mytableView = [[UITableView alloc]initWithFrame:FRAME(0, NAV_HEIGHT+120/2+6, SELF_VIEW_WIDTH, SELF_VIEW_HEIGHT-NAV_HEIGHT-120/2-6)];
    _mytableView.delegate = self;
    _mytableView.dataSource = self;
    _mytableView.hidden = YES;
    [_mytableView setSeparatorInset:UIEdgeInsetsZero];

    [self.view addSubview:_mytableView];
}

- (void) textFieldDidChanged:(NSNotification *)notification
{
    if ([CommunityFiled isFirstResponder]) {
        NSArray *searchResult = (NSArray *)[self searchForMatchedStockList];
        NSLog(@"* * * * * * * * *searchResult = %@",searchResult);
        [dataArray removeAllObjects];
        if (searchResult && [searchResult count] > 0)
        {
            [dataArray addObjectsFromArray:searchResult];
        }
                
        [_mytableView reloadData];
        if ([dataArray count] > 0)
        {
            _mytableView.hidden = NO;
        } else
        {
            _mytableView.hidden = YES;
        }
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [CommunityFiled resignFirstResponder];
}


#pragma mark 输入文字改变的时候
- (NSMutableArray *) searchForMatchedStockList
{
    _mytableView.hidden = NO;
    NSString *conditionStr = CommunityFiled.text;
    NSMutableArray *result = [NSMutableArray array];
    
    if (conditionStr && ![conditionStr isEqualToString:@""])
    {
        sourceArray = nil;
        

        if ([citybtn.titleLabel.text isEqualToString:@"北京"]) {
            sourceArray = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).stockDataArray;
        }else{
            sourceArray = APPLIACTION.tianjinArray;
        }
        

        
        for (int i = 0; i < [sourceArray count]; i ++)
        {
            NSDictionary *dict = [sourceArray objectAtIndex:i];
            NSString *pinyinStr = [dict objectForKey:CITY_NAME];
            if (pinyinStr && ![pinyinStr isEqualToString:@""])
            {
                NSRange range = [pinyinStr rangeOfString:conditionStr];
                if (range.location != NSNotFound && range.length > 0)
                {
                    ALLCITYBaseClass *_base = [[ALLCITYBaseClass alloc]initWithDictionary:[sourceArray objectAtIndex:i]];
                    [result addObject:_base];
                    continue;
                }
            }
            
        }
    }
    NSLog(@"result = %@",result);
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footview = [[UIView alloc]initWithFrame:FRAME(0, 0, 320-72, 20)];
    
    footview.backgroundColor = [UIColor yellowColor];
    //
    
    UILabel *marklabel = [[UILabel alloc]initWithFrame:FRAME(0, 0, SELF_VIEW_WIDTH, 20)];
    marklabel.backgroundColor = [UIColor grayColor];
    marklabel.font = [UIFont boldSystemFontOfSize:12];
    marklabel.text = @"请在出现的列表中选择您所在的小区";
    marklabel.textColor = [UIColor whiteColor];
    [footview addSubview:marklabel];
    marklabel = nil;
    
    return footview;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108/2;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"TableViewCellId";
    AllCityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[AllCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }

    ALLCITYBaseClass *_mybase = (ALLCITYBaseClass *)[dataArray objectAtIndex:indexPath.row];
    cell.base = _mybase;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ALLCITYBaseClass *_mybase = (ALLCITYBaseClass *)[dataArray objectAtIndex:indexPath.row];

    CommunityFiled.text = _mybase.cITYName;
    _selectdress = _mybase;
    
    
    _mytableView.hidden = YES;
    
}

- (void)doBack
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [CommunityFiled resignFirstResponder];
    [menpaiField resignFirstResponder];
}



- (void)OkBtnpressed:(NSInteger)tag
{
    _mytableView.userInteractionEnabled = YES;

    addBtn.userInteractionEnabled = YES;
    
}
- (void)sureAction:(UIButton *)sender
{
    if (CommunityFiled.text.length >0 && menpaiField.text.length>0) {

        NSString *menpai =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil, (CFStringRef)menpaiField.text, nil, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
        
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *_dict = @{@"user_id":_manager.telephone,@"addr_id":@"0",@"city_id":[NSString stringWithFormat:@"%.f",_selectdress.cITYId],@"cell_id":[NSString stringWithFormat:@"%.f",_selectdress.cId],@"addr":menpai,@"is_default":@"0"};
        
        
        NSLog(@"dict is %@",_dict);
        
        [_download requestWithUrl:ADDRESS_ADDCHANGE dict:_dict view:self.view delegate:self finishedSEL:@selector(AddFinished:) isPost:YES failedSEL:@selector(ADDFail:)];
        
    }
    else if([dataArray count] <= 0)
    {
        [MBProgressHUD showError:@"请输入正确的小区名称" toView:self.view];
    }
    else
    {
        [MBProgressHUD showSuccess:@"请输入门牌号" toView:self.view ];
    }
}



#pragma mark
- (void)AddFinished:(id)responsobject
{
    NSLog(@"responsobject is %@",responsobject);
    int status = [[responsobject objectForKey:@"status"] intValue];
    NSString *dressID = [[responsobject objectForKey:@"data"]objectForKey:@"id"];
    if (status == 0) {
        [self.delegate xiaoqu:CommunityFiled.text menpai:menpaiField.text dressId:[NSString stringWithFormat:@"%@",dressID]];
        [self.navigationController popViewControllerAnimated:YES];

    }
    

    CUSTOMDRESSData *_dressdata = [[CUSTOMDRESSData alloc]initWithDictionary:[responsobject objectForKey:@"data"]];
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADDDRESS_SUCCESS" object:_dressdata];
}


- (void)ADDFail:(id)error
{
    NSLog(@"responsobject is %@",error);

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
