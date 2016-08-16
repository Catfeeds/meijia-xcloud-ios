//
//  Publish_DynamicViewController.m
//  yxz
//
//  Created by 白玉林 on 15/12/25.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "Publish_DynamicViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "CorePhotoPickerVCManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "ISLoginManager.h"
#define W 23.5
@interface Publish_DynamicViewController ()<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    UIScrollView *scrollView;
    UIView *imageview;
    int S;
    int tG,imgID,butID,remID,tpID;
    
    UIView *scrollImView;
    UIImageView *labelView;
    UIButton *upButton;
    UIImage *image;
    NSData *data;
   
    
}

@end

@implementation Publish_DynamicViewController

@synthesize upView,addImageView,imgArray,images,titleField,descriptionView,timaLabel,labelField,priceField,fieldView;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navlabel.text=@"上传";
    butID=0;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden=YES;
    imgArray=[[NSMutableArray alloc]init];
    [self makeUI];
    [self pictureSort];
    imageview=[[UIView alloc]initWithFrame:FRAME(WIDTH, 20, WIDTH, HEIGHT-20)];
    imageview.backgroundColor=[UIColor blackColor];
    [self.view addSubview:imageview];
    scrollImView=[[UIView alloc]initWithFrame:FRAME(0, 20, WIDTH, 40)];
    // scrollImView.hidden=YES;
    [imageview addSubview:scrollImView];
    
    UIButton *fhBut=[[UIButton alloc]initWithFrame:FRAME(10, 5, 50, 30)];
//    fhBut.backgroundColor=[UIColor redColor];
    [fhBut addTarget:self action:@selector(fhAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollImView addSubview:fhBut];
    UIImageView *fhImageView=[[UIImageView alloc]initWithFrame:FRAME(8, 5, 20, 20)];
    fhImageView.image=[UIImage imageNamed:@"title_left_back_white_black"];
    [fhBut addSubview:fhImageView];
    
    UIButton *remBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH-40, 5, 30, 30)];
//    remBut.backgroundColor=[UIColor redColor];
    [remBut addTarget:self action:@selector(remAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollImView addSubview:remBut];
    UIImageView *remImageView=[[UIImageView alloc]initWithFrame:FRAME(0, 0, 30, 30)];
    remImageView.image=[UIImage imageNamed:@"iconfont-lajitong"];
    [remBut addSubview:remImageView];
    
}

-(void)makeUI
{
    fieldView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    //fieldView.backgroundColor=[UIColor redColor];
    fieldView.userInteractionEnabled=YES;
    //fieldView.backgroundColor=[UIColor blueColor];
    [self.view addSubview:fieldView];
    descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, WIDTH-10, 180)];
    descriptionView.font = [UIFont systemFontOfSize:13];
    descriptionView.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
    descriptionView.layer.borderColor = UIColor.grayColor.CGColor;
    descriptionView.layer.borderWidth = 1;
    descriptionView.layer.cornerRadius=8;
    descriptionView.textAlignment = NSTextAlignmentLeft;
    descriptionView.delegate=self;
    descriptionView.tag=101;
    [fieldView addSubview:descriptionView];
    
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(WIDTH*0.26, descriptionView.frame.size.height+69, WIDTH*0.48, 40);
    [btn setImage:[UIImage imageNamed:@"SC-FB@2px.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}
-(void)pictureSort//图片排序显示
{
    if (upView) {
        [upView removeFromSuperview];
    }
    
    upView =[[UIView alloc]init];
    //upView.backgroundColor=[UIColor redColor];
    [fieldView addSubview:upView];
    
    addImageView =[[UIImageView alloc]init];
    addImageView.image=[UIImage imageNamed:@"SC-ADD@2px(1)"];
    addImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer * TapGesturRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [addImageView addGestureRecognizer:TapGesturRecognizer];
    [upView addSubview:addImageView];
    int H=15;
    int Y=15;
    if (imgArray.count==0) {
        addImageView.frame=CGRectMake(W , 15, (WIDTH-75)/4, (WIDTH-75)/4);
    }
    
    NSLog(@"--------------%@",imgArray);
    self.view.backgroundColor=[UIColor whiteColor];
    
    int A=0,B=1;
    
    for (int i=0; i<imgArray.count; i++)
    {
        if ((i+1)%4==0) {
            Y=Y+(WIDTH-W*2-28)/4+15;
            B=0;
        }
        if (i%4==0&&i!=0) {
            H=H+(WIDTH-W*2-28)/4+15;
            A=0;
            
        }
        UIButton *imageView=[[UIButton alloc]initWithFrame:CGRectMake(W+(WIDTH-W*2)/4*A, H, (WIDTH-W*2-28)/4, (WIDTH-W*2-28)/4)];
        [imageView setImage:imgArray[i] forState:UIControlStateNormal];
        imageView.tag=i;
        [imageView addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
        [upView addSubview:imageView];
        
        //        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)];
        //        [imageView addGestureRecognizer:tap];
        
        addImageView.frame=CGRectMake(W+(WIDTH-W*2)/4*B, Y, (WIDTH-75)/4, (WIDTH-75)/4);
        
        if (i+1==12) {
            addImageView.hidden=YES;
        }
        A++;
        B++;
    }
    
    upView.frame=CGRectMake(0, descriptionView.frame.size.height, WIDTH,(WIDTH-75)/4+15+H);
    [upButton removeFromSuperview];
    upButton =[[UIButton alloc]initWithFrame:FRAME(14, upView.frame.size.height+upView.frame.origin.y+20, WIDTH-28, 40)];
    [upButton setTitle:@"上传" forState:UIControlStateNormal];
    upButton.backgroundColor=[UIColor redColor];
    [upButton addTarget:self action:@selector(upButAction) forControlEvents:UIControlEventTouchUpInside];
    [fieldView addSubview:upButton];
    
    
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
}
-(void)upButAction
{
    NSString *urlStr = [NSString stringWithFormat:@"http://app.bolohr.com/%@",UP_DONGTAI];//@"http://app.bolohr.com/simi/app/user/post_user_img.json";
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSString *user=_manager.telephone;
    NSDictionary *dic=@{@"user_id":user,@"title":descriptionView.text,@"lat":_lngString,@"lng":_latString,@"poi_name":_cityStr};
    // 向服务器提交图片
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 显示进度
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData)    {
        // 上传 多张图片
        for(NSInteger i = 0; i < images.count; i++){
            image=images[i];
            if (UIImagePNGRepresentation(image) == nil)
            {
                data = UIImageJPEGRepresentation(image, 1.0);
            }
            else
            {
                data = UIImagePNGRepresentation(image);
            }

            NSData * imageData =data; //[self.imageDataArray objectAtIndex: i];
            // 上传的参数名
           // NSString * Name = [NSString stringWithFormat:@"%@%zi", Image_Name, i+1];
            // 上传filename
            NSString * fileName = [NSString stringWithFormat:@"image%ld.png", (long)i];
            [formData appendPartWithFileData:imageData name:@"feed_imgs" fileName:fileName mimeType:@"image/jpeg"];
        }
//        formData appendPartWithFormData:<#(NSData *)#> name:<#(NSString *)#>
    }
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
              NSLog(@"完成 %@", result);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"错误 %@", error.localizedDescription);
          }];
    NSLog(@"地理位置信息---%@  %@  %@",_latString ,_lngString ,_cityStr);
}



#pragma mark 九宫格图片点击方法
-(void)imageAction:(UIButton *)sender
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSString *string=[NSString stringWithFormat:@"%ld",(long)sender.tag];
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:1];
    imageview.frame=FRAME(0, 0, WIDTH, HEIGHT);
    [UIView commitAnimations];
    tG=[string intValue];
    [self label];
    [self scrollerLayout];
}

#pragma mark 大图展示滑动式图布局方法
-(void)scrollerLayout
{
    [scrollView removeFromSuperview];
    scrollView=[[UIScrollView alloc]initWithFrame:FRAME(0, 60, WIDTH, HEIGHT-60)];
    scrollView.contentSize=CGSizeMake(WIDTH*imgArray.count, HEIGHT-64);
    scrollView.pagingEnabled=YES;
    scrollView.delegate=self;
    scrollView.contentOffset=CGPointMake(WIDTH*tG, 0);
    scrollView.tag = 200;
    [imageview addSubview:scrollView];
    
    for (int i=0; i<imgArray.count; i++) {
        UIButton *imageButton=[[UIButton alloc]initWithFrame:FRAME(i*WIDTH,0, WIDTH, HEIGHT-60)];
        [imageButton addTarget:self action:@selector(imgAction:) forControlEvents:UIControlEventTouchUpInside];
        imageButton.tag=i;
        UIImageView *imageView=[[UIImageView alloc]init];
        imageView.frame=CGRectMake(0,0, WIDTH, HEIGHT-60);
        
        imageView.contentMode = UIViewContentModeRedraw;
        imageView.image=imgArray[i];
        [imageButton addSubview:imageView];
        [scrollView addSubview:imageButton];
    }
    
    if (imgArray.count==1||imgID==0) {
        [self label];
    }
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    S=1;
}
- (void) scrollViewDidScroll:(UIScrollView *)sender {
    //[scrollView removeFromSuperview];
    // 得到每页宽度
    CGFloat pageWidth = sender.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    imgID= floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self label];
}
#pragma mark 当前页数显示方法
-(void)label
{
    [labelView removeFromSuperview];
    labelView=[[UIImageView alloc]initWithFrame:CGRectMake((WIDTH-60)/2, 7.5, 60, 25)];
    labelView.image=[UIImage imageNamed:@"CKDT-YM@2px"];
    [scrollImView addSubview:labelView];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, labelView.frame.size.height/2-10, 60 , 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    [labelView addSubview:label];
    
    if (S==0) {
        int ID=tG+1;
        NSString *string=[NSString stringWithFormat:@"%d/",ID];
        NSString *string1=[NSString stringWithFormat:@"%@ %ld",string,(unsigned long)imgArray.count];
        label.text=string1;
    }else
    {
        int ID;
        if (imgArray.count==1) {
            ID=tG+1;
        }else {
            ID=imgID+1;
        }
        
        NSString *string=[NSString stringWithFormat:@"%d/",ID];
        NSString *string1=[NSString stringWithFormat:@"%@%ld",string,(unsigned long)imgArray.count];
        label.text=string1;
    }
    remID=imgID;
}

#pragma mark 大图点击方法
-(void)imgAction:(UIButton *)sender
{
    NSLog(@"sender%@",sender);
    //    UIImageView *view=(UIImageView *)sender;
    //    NSString *string=[NSString stringWithFormat:@"%ld",(long)sender.tag];
    //    int imageId=[string intValue];
    //    remID=imageId;
    if (butID%2==0) {
        [UIView beginAnimations: @"Animation" context:nil];
        [UIView setAnimationDuration:1];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        scrollImView.frame=FRAME(0, -40, WIDTH, 40);
        [UIView commitAnimations];
    }else{
        [UIView beginAnimations: @"Animation" context:nil];
        [UIView setAnimationDuration:1];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        scrollImView.frame=FRAME(0, 20, WIDTH, 40);
        [UIView commitAnimations];
        
    }
    butID++;
    
}
#pragma mark 大图返回按钮点击方法
-(void)fhAction:(id)sender
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:1];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    imageview.frame=FRAME(WIDTH, 0, WIDTH, HEIGHT);
    [UIView commitAnimations];
    
}

#pragma mark 删除按钮点击当法
-(void)remAction:(UIButton *)sender
{
    //    for (UIImageView *view_ in scrollView.subviews) {
    //        if (view_.tag == remID-1) {
    //            [view_ removeFromSuperview];
    //        }
    //    }
    //    NSString *string=[NSString stringWithFormat:@"%lu",(unsigned long)imgArray.count];
    //    int str=[string intValue];
    //    int x=str-1;
    if (imgID==0) {
        tG=0;
    }
    if (tG!=0) {
        if (imgArray.count!=1) {
            tG=tG-1;
        }
        
    }
    if (imgArray.count==1) {
        [UIView beginAnimations: @"Animation" context:nil];
        [UIView setAnimationDuration:1];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        imageview.frame=FRAME(WIDTH, 0, WIDTH, HEIGHT);
        [UIView commitAnimations];
        [images removeObjectAtIndex:tG];
        [imgArray removeObjectAtIndex:tG];
        
    }else{
        [images removeObjectAtIndex:imgID];
        [imgArray removeObjectAtIndex:imgID];
        [self scrollerLayout];
        
    }
    [self pictureSort];
    
    //scrollImView.hidden=YES;
}
-(void)deletePhoto:(UIButton *)tag
{
    NSLog(@"走这里  删除数组");
    UIButton *btn = (UIButton *)tag;
    // int a=btn.tag;
    [imgArray removeObjectAtIndex:btn.tag];
    [self pictureSort];
    
}
-(void)tapGestureRecognizer:(id)sender
{
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"请选取" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍摄" otherButtonTitles:@"相册", nil];
    NSLog(@"-=-=-=-=-=-=-=-=-=-=--=-");
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    CorePhotoPickerVCMangerType type=0;
    
    if (buttonIndex==0||buttonIndex==1) {
        if(buttonIndex==0)
        {
            type=CorePhotoPickerVCMangerTypeCamera;
        }
        
        if(buttonIndex==1)
        {
            type=CorePhotoPickerVCMangerTypeMultiPhoto;
        }
        
        CorePhotoPickerVCManager *manager=[CorePhotoPickerVCManager sharedCorePhotoPickerVCManager];
        
        //设置类型
        manager.pickerVCManagerType=type;
        
        //最多可选3张
        manager.maxSelectedPhotoNumber=9-imgArray.count;
        
        //错误处理
        if(manager.unavailableType!=CorePhotoPickerUnavailableTypeNone){
            NSLog(@"设备不可用");
            return;
        }
        
        UIViewController *pickerVC=manager.imagePickerController;
        
        //选取结束
        manager.finishPickingMedia=^(NSArray *medias)
        {
            
            
            if(!images){
                
                images = [NSMutableArray new];
                
            }else{
                
                //[images removeAllObjects];
                
            }
            for(CorePhoto *temp in medias){
                NSLog(@"%@",temp);
                
                
                [images addObject:[temp editedImage]];
                
                
                
            }
            //            secondaryArray=images;
            //            NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%@",secondaryArray);
            
            
        };
        
        [self presentViewController:pickerVC animated:YES completion:nil];
        
        
    }else
    {
        return;
    }
    
}



-(void)viewWillAppear:(BOOL)animated
{
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    // 开始时时定位
    [locationManager startUpdatingLocation];
    UIImage * selectImg;
    [imgArray removeAllObjects];
    for (int i=0; i<images.count; i++) {
        selectImg = images[i];
        [imgArray addObject: selectImg];
        
    }
    [self pictureSort];
    
    
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error");
    NSString *errorString;
    [manager stopUpdatingLocation];
    NSLog(@"Error: %@",[error localizedDescription]);
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"Access to Location Services denied by user";
            //Do something...
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"Location data unavailable";
            //Do something else...
            break;
        default:
            errorString = @"An unknown error has occurred";
            break;
    }
    
}

// 6.0 以上调用这个函数
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"%lu", (unsigned long)[locations count]);
    
    CLLocation *newLocation = locations[0];
    CLLocationCoordinate2D oldCoordinate= newLocation.coordinate;
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    _lngString=[NSString stringWithFormat:@"%f",oldCoordinate.longitude];
    _latString=[NSString stringWithFormat:@"%f",oldCoordinate.latitude];
    [manager stopUpdatingLocation];
    
    CLLocation *currentLocation = [locations lastObject];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     
     {
         
         if (array.count > 0)
             
         {
             
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             
             
             //将获得的所有信息显示到label上
             
             NSLog(@"%@",placemark.name);
             
             //获取城市
             
             NSString *city = placemark.locality;
             NSString *cqSte=placemark.subLocality;
             
             if (!city) {
                 
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 
                 city = placemark.administrativeArea;
                 
             }
             
             _cityStr =[NSString stringWithFormat:@"%@   %@",city  ,cqSte];
             
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
    
    [manager stopUpdatingLocation];
    
}

// 6.0 调用此函数
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"%@", @"ok");
}

-(void)leftButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)btnDown
{
    
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
