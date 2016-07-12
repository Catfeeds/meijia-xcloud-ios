//
//  Create_Enterprise_Address_BookViewController.m
//  yxz
//
//  Created by 白玉林 on 16/7/5.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "Create_Enterprise_Address_BookViewController.h"
#import "CityViewController.h"
#import "ScaleListPicker.h"
#import "BindMobileViewController.h"
@interface Create_Enterprise_Address_BookViewController ()<ScaleListPickerDelegate,UITextFieldDelegate>
{
    NSString *nameString;
    NSString *shortNameStr;
    NSString *regionLabel;
    NSString *scaleLabel;
    NSString* cityName;
    CityViewController *citVC;
    ScaleListPicker *scaleVC;
    NSMutableArray *dicArray;
    UIButton *addBut;
}
@end

@implementation Create_Enterprise_Address_BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    nameString=@"";
    shortNameStr=@"";
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *moile=[delegate.globalDic objectForKey:@"mobile"];
    // NSLog(@"手机号： %@",textfield.text);
    if (moile==nil||moile==NULL) {
        
        UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有绑定手机号，请绑定手机号！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
        BindMobileViewController *bindVC=[[BindMobileViewController alloc]init];
        [self.navigationController pushViewController:bindVC animated:YES];
        
    }

    dicArray=[[NSMutableArray alloc]init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/simi.db", pathDocuments];
    sqlite3_open([path UTF8String], &citydb);
    
    sqlite3_stmt *statement;
    NSString *sql = @"SELECT * FROM city";
    
    if (sqlite3_prepare_v2(citydb, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *city_id = (char *)sqlite3_column_text(statement, 0);
            NSString *city_idStr = [[NSString alloc] initWithUTF8String:city_id];
            
            char *name = (char *)sqlite3_column_text(statement, 1);
            NSString *nameStr = [[NSString alloc] initWithUTF8String:name];
            
            char *add_time = (char *)sqlite3_column_text(statement, 2);
            NSString *add_timeStr = [[NSString alloc] initWithUTF8String:add_time];
            
            char *province_id = (char *)sqlite3_column_text(statement, 3);
            NSString *province_idStr = [[NSString alloc] initWithUTF8String:province_id];
            
            char *is_enable = (char *)sqlite3_column_text(statement, 4);
            NSString *is_enableStr = [[NSString alloc] initWithUTF8String:is_enable];
            
            char *zip_code = (char *)sqlite3_column_text(statement, 5);
            NSString *zip_codeStr = [[NSString alloc] initWithUTF8String:zip_code];
            
            NSDictionary *dic=@{@"city_id":city_idStr,@"name":nameStr,@"add_time":add_timeStr,@"province_id":province_idStr,@"is_enable":is_enableStr,@"zip_code":zip_codeStr};
            if ([dicArray containsObject:dic]) {
                
            }else{
                [dicArray addObject:dic];
            }
            
        }
        sqlite3_finalize(statement);
    }

    self.navlabel.text=@"创建企业通讯录";
    UIView *lineView=[[UIView alloc]initWithFrame:FRAME(0, 84, WIDTH, 0.5)];
    lineView.backgroundColor=[UIColor colorWithRed:178/255.0f green:178/255.0f blue:178/255.0f alpha:1];
    [self.view addSubview:lineView];
    NSArray *nameArray=@[@"名称",@"简称",@"地区",@"规模"];
    for (int i=0; i<nameArray.count; i++) {
        if (i<2) {
            UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 84.5+43*i, WIDTH, 43)];
            view.backgroundColor=[UIColor whiteColor];
            [self.view addSubview:view];
            UILabel *nameLabel=[[UILabel alloc]init];
            nameLabel.text=[NSString stringWithFormat:@"%@",nameArray[i]];
            nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:17];
            [nameLabel setNumberOfLines:1];
            [nameLabel sizeToFit];
            nameLabel.frame=FRAME(10, (43-20.5)/2, nameLabel.frame.size.width, 20);
            [view addSubview:nameLabel];
            UIView *labelLineView=[[UIView alloc]initWithFrame:FRAME(10, 42.5, WIDTH-10, 0.5)];
            labelLineView.backgroundColor=[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1];
            [view addSubview:labelLineView];
            
            UITextField *textField=[[UITextField alloc]initWithFrame:FRAME(10+nameLabel.frame.size.width, nameLabel.frame.origin.y, WIDTH-nameLabel.frame.size.width-20, 20)];
            textField.returnKeyType=UIReturnKeyDone;
            textField.tag=100+i;
            textField.delegate=self;
            if (i==0) {
                textField.placeholder=@"请输入企业/团队名称";
            }else{
                textField.placeholder=@"请输入企业/团队简称";
            }
            textField.font=[UIFont fontWithName:@"Heiti SC" size:17];
            textField.textAlignment=NSTextAlignmentRight;
            textField.textColor=[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
            [view addSubview:textField];
            
            
            
        }else{
            UIButton *button=[[UIButton alloc]initWithFrame:FRAME(0, 84.5+43*i, WIDTH, 43)];
            button.backgroundColor=[UIColor whiteColor];
            button.tag=1100+i;
            [button addTarget:self action:@selector(ButAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
            UILabel *nameLabel=[[UILabel alloc]init];
            nameLabel.text=[NSString stringWithFormat:@"%@",nameArray[i]];
            nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:17];
            [nameLabel setNumberOfLines:1];
            [nameLabel sizeToFit];
            nameLabel.frame=FRAME(10, (43-20.5)/2, nameLabel.frame.size.width, 20);
            [button addSubview:nameLabel];
            UIView *labelLineView=[[UIView alloc]initWithFrame:FRAME(10, 42.5, WIDTH-10, 0.5)];
            labelLineView.backgroundColor=[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1];
            [button addSubview:labelLineView];
            UILabel *textLabel=[[UILabel alloc]initWithFrame:FRAME(10+nameLabel.frame.size.width, nameLabel.frame.origin.y, WIDTH-nameLabel.frame.size.width-30, 20)];
            textLabel.tag=100+i;
            textLabel.font=[UIFont fontWithName:@"Heiti SC" size:17];
            [self textLayout];
            textLabel.textColor=[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
            textLabel.textAlignment=NSTextAlignmentRight;
            [button addSubview:textLabel];
            UIImageView *arrowImage=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-20, 28/2, 15, 15)];
            arrowImage.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
            [button addSubview:arrowImage];
        }
    }
    
    UILabel *textLb1=[[UILabel alloc]initWithFrame:FRAME(10, 114+43*4, WIDTH-20, 20)];
    textLb1.text=@"1.创建企业后，积分和经验值加倍，还可邀请同事加入。";
    textLb1.font=[UIFont fontWithName:@"Heiti SC" size:11];
    textLb1.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    [self.view addSubview:textLb1];
    UILabel *textLb2=[[UILabel alloc]init];//]WithFrame:FRAME(10, 134+43*4, WIDTH-20, 20)];
    textLb2.text=@"2.批量导入通讯录，可登录yun.bolohr.com，体验更多人事行政服务。";
    textLb2.font=[UIFont fontWithName:@"Heiti SC" size:11];
    UIFont *font=[UIFont fontWithName:@"Heiti SC" size:11];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize size = [textLb2.text boundingRectWithSize:CGSizeMake(WIDTH-20, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    [textLb2 setNumberOfLines:0];
    [textLb2 sizeToFit];
    textLb2.frame=FRAME(10, 134+43*4, WIDTH-20, size.height);
    textLb2.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    [self.view addSubview:textLb2];

    scaleVC = [[ScaleListPicker alloc]initWithFrame:FRAME(0, HEIGHT, WIDTH, 220)];
    scaleVC.delegate = self;
    [self.view addSubview:scaleVC];

    [self locate];
    
    addBut=[[UIButton alloc]initWithFrame:FRAME(14, HEIGHT-45, WIDTH-28, 41)];
    [addBut setTitle:@"创建公司" forState:UIControlStateNormal];
    addBut.backgroundColor=[UIColor colorWithRed:86/255.0f green:171/255.0f blue:228/255.0f alpha:1];
    [addBut addTarget:self action:@selector(addButAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBut];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    if (citVC.setout==nil||citVC.setout==NULL||[citVC.setout isEqualToString:@""]) {
        
    }else{
        regionLabel=citVC.setout;
        [self textLayout];
    }
    
}
-(void)textLayout
{
    UILabel *label=(UILabel *)[self.view viewWithTag:102];
    UILabel *label1=(UILabel *)[self.view viewWithTag:103];
    label.text=regionLabel;
    label1.text=scaleLabel;
}
- (void)locate

{
    
    // 判断定位操作是否被允许
    
    if([CLLocationManager locationServicesEnabled]) {
        
        self.locationManager = [[CLLocationManager alloc] init] ;
        
        self.locationManager.delegate = self;
        
    }else {
        
        //提示用户无法进行定位操作
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  
                                  @"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alertView show];
        
    }
    
    // 开始定位
    
    [self.locationManager startUpdatingLocation];
    
}


//5.实现定位协议回调方法
#pragma mark - CoreLocation Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    
    CLLocation *currentLocation = [locations lastObject];
    
    // 获取当前所在的城市名
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //根据经纬度反向地理编译出地址信息
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     
    {
        
        if (array.count > 0)
            
        {
            
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            //将获得的所有信息显示到label上
            
            NSLog(@"%@",placemark.name);
            
            //获取城市
            
            NSString *city = placemark.locality;
            
            if (!city) {
                
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                
                city = placemark.administrativeArea;
                
            }
            
            regionLabel = city;
            [self textLayout];
            
        }
        
        else if (error == nil && [array count] == 0)
            
        {
            
            NSLog(@"No results were returned.");
            
        }
        
        else if (error != nil)
            
        {
            
            NSLog(@"An error occurred = %@", error);
            
        }
        
    }];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    
    [manager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager

       didFailWithError:(NSError *)error {
    
    if (error.code == kCLErrorDenied) {
        
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
        
    }
    
}



-(void)ButAction:(UIButton *)button
{
    if (button.tag==1102) {
        citVC=[[CityViewController alloc]init];
        citVC.cityID=20001;
        [self.navigationController pushViewController:citVC animated:YES];
    }else{
        UITextField *label=(UITextField *)[self.view viewWithTag:100];
        UITextField *label1=(UITextField *)[self.view viewWithTag:101];
        [label resignFirstResponder];
        [label1 resignFirstResponder];
        [UIView beginAnimations: @"Animation" context:nil];
        [UIView setAnimationDuration:0.3];
        scaleVC.frame = CGRectMake(0, HEIGHT-220, WIDTH, 220);
        [UIView commitAnimations];
        addBut.hidden=YES;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    scaleVC.frame = CGRectMake(0, HEIGHT, WIDTH, 220);
    [UIView commitAnimations];
    addBut.hidden=NO;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 100:
            if (textField.text==nil) {
                nameString=@"";
            }else{
                nameString=textField.text;
            }
            
            break;
        case 101:
            if (textField.text==nil) {
                shortNameStr=@"";
            }else{
                shortNameStr=textField.text;
            }
        default:
            break;
    }

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)closePicker
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    scaleVC.frame = CGRectMake(0, HEIGHT, WIDTH, 220);
    [UIView commitAnimations];
    addBut.hidden=NO;
}
- (void)loopHours:(NSString *)hours
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    scaleVC.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
    scaleLabel=[NSString stringWithFormat:@"%@",hours];
    addBut.hidden=NO;
    [self textLayout];

}
-(void)addButAction
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *moile=[delegate.globalDic objectForKey:@"mobile"];
    // NSLog(@"手机号： %@",textfield.text);
    if (moile==nil||moile==NULL) {
        
        UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有绑定手机号，请绑定手机号！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
        BindMobileViewController *bindVC=[[BindMobileViewController alloc]init];
        [self.navigationController pushViewController:bindVC animated:YES];
        
    }else{
        if (nameString==nil||nameString==NULL||[nameString isEqualToString:@""]) {
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"名称不可以为空，请填写名称！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if (shortNameStr==nil||shortNameStr==NULL||[shortNameStr isEqualToString:@""]){
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"公司简称不可以为空，请填写公司简称！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if (regionLabel==nil||regionLabel==NULL||[regionLabel isEqualToString:@""]){
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"地区不可以为空，请选择地区！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else if (scaleLabel==nil||scaleLabel==NULL||[scaleLabel isEqualToString:@""]){
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"公司规模不可以为空，请选择公司规模！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
            
        }else{
            NSString *city_id;
            if (citVC.fromCityID==nil || citVC.fromCityID==NULL) {
                for (int i=0; i<dicArray.count; i++) {
                    NSDictionary *dic=dicArray[i];
                    NSString *string=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
                    if ([regionLabel isEqualToString:string]) {
                        city_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"city_id"]];
                        break;
                    }
                }
            }else{
                city_id=[NSString stringWithFormat:@"%@",citVC.fromCityID];
            }
            NSString *company_size;
            if ([scaleLabel isEqualToString:@"49人及以下"]) {
                company_size=@"0";
            }else if ([scaleLabel isEqualToString:@"50-99人"]){
                company_size=@"1";
            }else if ([scaleLabel isEqualToString:@"100-499人"]){
                company_size=@"2";
            }else if ([scaleLabel isEqualToString:@"500-999人"]){
                company_size=@"3";
            }else if ([scaleLabel isEqualToString:@"1000人以上"]){
                company_size=@"4";
            }
            ISLoginManager *_manager = [ISLoginManager shareManager];
            DownloadManager *_download = [[DownloadManager alloc]init];
            NSDictionary *dict=@{@"user_id":_manager.telephone,@"city_id":city_id,@"company_name":nameString,@"short_name":shortNameStr,@"company_size":company_size};
            [_download requestWithUrl:[NSString stringWithFormat:@"%@",REG_APP] dict:dict view:self.view delegate:self finishedSEL:@selector(SubscribeSuccess:) isPost:YES failedSEL:@selector(subscribeFail:)];
        }

    }
    
}
-(void)SubscribeSuccess:(id)source
{
    NSLog(@"成功信息返回--%@",source);
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSLog(@"有值么%@",_manager.telephone);
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict=@{@"user_id":_manager.telephone};
    [_download requestWithUrl:USER_INFO dict:_dict view:self.view delegate:self finishedSEL:@selector(QJDowLoadFinish:) isPost:NO failedSEL:@selector(QJDownFail:)];

    
}
#pragma mark判断数据库是否存在某张表
-(BOOL)checkName:(NSString *)name{
    
    char *err;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM simi.db where type='table' and name='%@';",name];
    
    const char *sql_stmt = [sql UTF8String];
    
    if(sqlite3_exec(simi, sql_stmt, NULL, NULL, &err) == 1){
        
        return YES;
        
    }else{
        
        return NO;
        
    }
    
}
-(void)QJDownFail:(id)sender
{
    
}
#pragma mark用户信息详情获取成功方法
-(void)QJDowLoadFinish:(id)sender
{
    NSLog(@"数据详情%@",sender);
    NSDictionary *dic=[sender objectForKey:@"data"];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.globalDic=@{@"user_id":[dic objectForKey:@"id"],@"sec_id":[dic objectForKey:@"sec_id"],@"is_senior":[dic objectForKey:@"is_senior"],@"senior_range":[dic objectForKey:@"senior_range"],@"mobile":[dic objectForKey:@"mobile"],@"user_type":[dic objectForKey:@"user_type"],@"name":[dic objectForKey:@"name"],@"has_company":[dic objectForKey:@"has_company"],@"head_img":[dic objectForKey:@"head_img"],@"company_id":[dic objectForKey:@"company_id"],@"company_name":[dic objectForKey:@"company_name"]};
    NSLog(@"看看是什么啊%@",delegate.globalDic);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL find = [fileManager fileExistsAtPath:delegate.defaultDBPath];
    if (find) {
        if(sqlite3_open([delegate.defaultDBPath UTF8String], &simi) != SQLITE_OK) {
            sqlite3_close(simi);
            NSLog(@"open database fail");
        }
    }
    sqlite3_open([delegate.defaultDBPath UTF8String], &simi);
    //    if (sqlReturns) {
    //        NSLog(@"chenggong");
    //    }else{
    //        NSLog(@"shibai ");
    //    }
    sqlite3_stmt *dbps ;
    if ([self checkName:@"User"]) {
        
    }else{
        char *sqlCreateTable = "CREATE TABLE User (id INTEGER PRIMARY KEY AUTOINCREMENT, mobile TEXT,third_type TEXT,openid TEXT,name TEXT,id_card TEXT,sex TEXT,head_img TEXT,qr_code TEXT,rest_money REAL,score INTEGER)";
        NSInteger sqlReturn = sqlite3_prepare_v2(simi, sqlCreateTable, -1, &dbps, nil);
        //如果SQL语句解析出错的话程序返回
        if(sqlReturn != SQLITE_OK) {
            NSLog(@"Error: failed to prepare statement:create test table");
        }
        
        //执行SQL语句
        int success = sqlite3_step(dbps);
        //释放sqlite3_stmt
        sqlite3_finalize(dbps);
        
        //执行SQL语句失败
        if ( success != SQLITE_DONE) {
            NSLog(@"Error: failed to dehydrate:create table test");
        }
        
    }
    
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO User(id,score,client_id,real_name,mobile,third_type,app_id,id_card,birth_day,update_time,openid,head_img,add_from,add_time ,open_id,rest_money,major,degree_id,user_type,province_name,name,channel_id,app_user_id,sex,is_approval,is_new_user)VALUES(%d,%d,'%@','%@','%@','%@','%@','%@','%@',%@,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[[dic objectForKey:@"id"] intValue],[[dic objectForKey:@"score"]intValue],[dic objectForKey:@"client_id"],[dic objectForKey:@"real_name"],[dic objectForKey:@"mobile"],[dic objectForKey:@"third_type"],[dic objectForKey:@"app_id"],[dic objectForKey:@"id_card"],[dic objectForKey:@"birth_day"],[dic objectForKey:@"update_time"],[dic objectForKey:@"openid"],[dic objectForKey:@"head_img"],[dic objectForKey:@"add_from"],[dic objectForKey:@"add_time"],[dic objectForKey:@"open_id"],[dic objectForKey:@"rest_money"],[dic objectForKey:@"major"],[dic objectForKey:@"degree_id"],[dic objectForKey:@"user_type"],[dic objectForKey:@"province_name"],[dic objectForKey:@"name"],[dic objectForKey:@"channel_id"],[dic objectForKey:@"app_user_id"],[dic objectForKey:@"sex"],[dic objectForKey:@"is_approval"],[dic objectForKey:@"is_new_user"]];
    //上边的update也可以这样写：
    //NSString *insert = [NSString stringWithFormat:@"INSERT OR REPLACE INTO PERSIONINFO('%@','%@','%@','%@','%@')VALUES(?,?,?,?,?)",NAME,AGE,SEX,WEIGHT,ADDRESS];
    
    //    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO cell (C_ID, C_CITY_ID, C_NAME, C_ADDRESS, C_STORE_ID, C_ADDR_LNG, C_ADDR_LAT, C_OPER_TIME) VALUES (%@, %i, '%@', '%@', 17, '%@', '%@', '%@')",model.cellID,model.city_id,model.cell_name,model.cell_addr,model.addr_lng,model.addr_lat,oper_time];
    //
    const char *insertUTF8 = [insertSQL UTF8String];
    
    int result = sqlite3_prepare_v2(simi, insertUTF8, -1, &dbps, NULL);
    
    if(result == SQLITE_OK){
        NSLog(@"插入成功");
        
        if (sqlite3_step(dbps) == SQLITE_DONE) {
            sqlite3_finalize(dbps);
            NSLog(@"成功");
        }
    }else{
        NSLog(@"插入失败");
    }
    
    sqlite3_close(simi);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)subscribeFail:(id)source
{
     NSLog(@"失败信息返回--%@",source);
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
