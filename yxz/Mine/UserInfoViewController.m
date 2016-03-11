//
//  UserInfoViewController.m
//  simi
//
//  Created by zrj on 14-11-13.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserinfoView.h"
#import "DownloadManager.h"
#import "ISLoginManager.h"
#import "USERINFOBaseClass.h"
#import "BaiduMobStat.h"
#import "ISLoginManager.h"
#import "SettingsViewController.h"
#import "MyAccountController.h"
#import "MineViewController.h"

#import "MyLogInViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "UpLoadViewController.h"
#import "LoginViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface UserInfoViewController ()<userInfoDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
    UserinfoView *_userview;
    NSString *filePath;//图片的沙盒路径
    UIImage* image;
    NSData *data;
    NSDictionary *headeDic;
    int headeImageID;
}

@end

@implementation UserInfoViewController
-(void)viewWillAppear:(BOOL)animated
{
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"账号信息", nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"账号信息", nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    headeImageID=0;
    self.navlabel.text = @"账号信息";
    
    _userview = [[UserinfoView alloc]initWithFrame:FRAME(0, 64, _WIDTH, 54*5+10)];
    _userview.delegate = self;
    _userview.userInteractionEnabled = NO;
    [self.view addSubview:_userview];
    
    UIButton *bttn = [UIButton buttonWithType:UIButtonTypeCustom];
    bttn.frame = FRAME(14, SELF_VIEW_HEIGHT-14-41, WIDTH-28, 41);
    bttn.layer.cornerRadius=5;
    [bttn setBackgroundColor:HEX_TO_UICOLOR(NAV_COLOR, 1.0)];
    [bttn setTitle:@"退出登录" forState:UIControlStateNormal];
    [bttn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[bttn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
//    [bttn.layer setCornerRadius:5.0];//设置矩形四个圆角半径
    [bttn addTarget:self action:@selector(takeout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bttn];
    
    UIButton *disBtn = [[UIButton alloc]initWithFrame:FRAME(SELF_VIEW_WIDTH-50, 20, 50, 44)];
    [disBtn setTitle:@" " forState:UIControlStateNormal];
    [disBtn setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
    [disBtn setImageEdgeInsets:UIEdgeInsetsMake(13, 13, 13, 13)];
    [disBtn setTitleColor:HEX_TO_UICOLOR(TEXT_COLOR, 1.0) forState:UIControlStateNormal];
    [disBtn setBackgroundColor:[UIColor clearColor]];
    disBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [disBtn addTarget:self action:@selector(UserInfoEdit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:disBtn];

    
    ISLoginManager *_manager = [ISLoginManager shareManager];
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict = @{@"user_id":_manager.telephone};
    [_download requestWithUrl:USER_INFO dict:_dict view:self.view delegate:self finishedSEL:@selector(DownloadFinish2:) isPost:NO failedSEL:@selector(FailDownload:)];
}
- (void)UserInfoEdit:(UIButton *)btn
{
    if ([btn.titleLabel.text isEqualToString:@" "]) {
        [btn setTitle:@"保存" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

        _userview.userInteractionEnabled = YES;
    }else{
        
        [btn setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];

        NSString *name;
        NSString *phone;
        NSString *sex;
        for (int i = 0; i < 5; i++) {
            UITextField *textfield = (UITextField *)[_userview viewWithTag:1000+i];
            
            switch (i) {
                case 0:
                    
                    break;
                case 1:
                    name = textfield.text;
                    break;
                case 2:
                    phone = textfield.text;
                    break;
                case 3:
                    sex = textfield.text;
                    break;
                case 4:
                    
                    break;
                    
                    
                default:
                    break;
            }
        }
        
        NSLog(@"name:%@  phone:%@   sex:%@",name,phone,sex);
        
        if ([phone isEqualToString:@""]) {
            [self showHint:@"手机号不能为空哦"];
            return;
        }
        ISLoginManager *_manager = [ISLoginManager shareManager];
        
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *_dict = @{@"user_id":_manager.telephone,@"name":name,@"mobile":phone,@"sex":sex};
        [_download requestWithUrl:USERINFO_EDIT dict:_dict view:self.view delegate:self finishedSEL:@selector(ModifySuccess:) isPost:YES failedSEL:@selector(ModifyFailure:)];
        if (headeImageID!=0) {
            [self upload];
        }
        
    }

    
}


- (void)upload
{
    NSString *urlStr = @"http://123.57.173.36/simi/app/user/post_user_head_img.json";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:0 timeoutInterval:5.0f];
    
    [self setRequest:request];
    
    NSLog(@"开始上传...");
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *datas, NSError *connectionError) {
        
        NSLog(@"Result--%@", [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding]);
        
    }];
}
- (void)setRequest:(NSMutableURLRequest *)request
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSString *user=_manager.telephone;
    
    NSString *boundary = [NSString stringWithFormat:@"Boundary+%08X%08X", arc4random(), arc4random()];
    NSMutableData *body = [NSMutableData data];
    
    // 表单数据
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:user forKey:@"user_id"];
    //[param setValue:data forKey:@"file"];
    NSLog(@"biao suju %@",param);
    /** 遍历字典将字典中的键值对转换成请求格式:
     --Boundary+72D4CD655314C423
     Content-Disposition: form-data; name="empId"
     
     254
     --Boundary+72D4CD655314C423
     Content-Disposition: form-data; name="shopId"
     
     18718
     */
    [param enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSMutableString *fieldStr = [NSMutableString string];
        [fieldStr appendString:[NSString stringWithFormat:@"--%@\r\n", boundary]];
        [fieldStr appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key]];
        [fieldStr appendString:[NSString stringWithFormat:@"%@", obj]];
        [body appendData:[fieldStr dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    
    /// 图片数据部分
    NSMutableString *topStr = [NSMutableString string];
    NSString *imaStr=[NSString stringWithFormat:@"%@",image];
    NSLog(@"image%@",imaStr);
    [topStr appendString:[NSString stringWithFormat:@"--%@\r\n", boundary]];
    [topStr appendString:@"Content-Disposition: form-data; name=\"file\"; filename=\"head.png\"\r\n"];
    [topStr appendString:@"Content-Type:image/png\r\n"];
    [topStr appendString:@"Content-Transfer-Encoding: binary\r\n\r\n"];
    [body appendData:[topStr dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:data];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 结束部分
    NSString *bottomStr = [NSString stringWithFormat:@"--%@--", boundary];
    /**拼装成格式：
     --Boundary+72D4CD655314C423--
     */
    [body appendData:[bottomStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 设置请求类型为post请求
    request.HTTPMethod = @"post";
    // 设置request的请求体
    request.HTTPBody = body;
    // 设置头部数据，标明上传数据总大小，用于服务器接收校验
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)body.length] forHTTPHeaderField:@"Content-Length"];
    // 设置头部数据，指定了http post请求的编码方式为multipart/form-data（上传文件必须用这个）。
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary] forHTTPHeaderField:@"Content-Type"];
}

#pragma mark 上床头像成功返回方法
-(void)TXEditFinish:(id)sender
{
    NSLog(@"上传头像成功%@",sender);
}
#pragma mark 上床头像失败返回方法
-(void)YXFailDownload:(id)sender
{
    NSLog(@"上传头像失败%@",sender);
}
- (void)EditFinish:(id)dict
{
    int status = [[dict objectForKey:@"status"] intValue];
    if (status ==0){
        
        [self dismissViewControllerAnimated:YES completion:nil];

    }

}
#pragma mark 下载成功
- (void)DownloadFinish2:(id)responsobject
{
    NSLog(@"Responsobject%@",responsobject);
    headeDic=[responsobject objectForKey:@"data"];
    NSString *imageStr=[NSString stringWithFormat:@"%@",[headeDic objectForKey:@"head_img"]];
    UIImage *images;
    if (imageStr==nil||imageStr==NULL||imageStr.length==1) {
        images=[UIImage imageNamed:@"家-我_默认头像"];
    }else {
        images=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[headeDic objectForKey:@"head_img"]]]];
    }
    _userview.headeImage=images;
    USERINFOBaseClass *_base = [[USERINFOBaseClass alloc]initWithDictionary:responsobject];
    
    if (_base.status == 0) {
        _userview.mydata = _base.data;
    }
}
#pragma mark 修改成功
-(void)ModifySuccess:(id)sender
{
    [self showAlertViewWithTitle:@"修改成功" message:nil];
}
#pragma mark 下载失败
- (void)ModifyFailure:(id)error
{
    [self showAlertViewWithTitle:@"修改失败" message:nil];
}

- (void)takeout
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGOUT" object:nil];
  [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error)
    {
        if (error && error.errorCode != EMErrorServerNotLogin)
        {
            
        }else{
            SettingsViewController *set = [[SettingsViewController alloc]init];
            [set logoutAction];
            NSUserDefaults *_default = [NSUserDefaults standardUserDefaults];
            [_default removeObjectForKey:@"telephone"];
            [_default removeObjectForKey:@"islogin"];
            [_default synchronize];
            MyLogInViewController *vc=[[MyLogInViewController alloc]init];
            vc.vCLID=100;
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];

        }
    } onQueue:nil];
//    ISLoginManager *manager = [ISLoginManager shareManager]
//    manager.isLogin = NO;
    
}
- (void)selectBrnPressedWithTag:(NSInteger)btntag
{
    switch (btntag) {
        case 0:
        {
            NSLog(@"头像");
//            MyAccountController *account = [[MyAccountController alloc]init];
//            [self.navigationController pushViewController:account animated:YES];
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"拍照",@"我的相册", nil];
            sheet.tag = 1;
            [sheet showInView:self.view];
            break;
        }

        case 1:
            NSLog(@"昵称");

            break;

        case 3:
            NSLog(@"性别");
        {
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"男",@"女", nil];
            sheet.tag = 2;
            [sheet showInView:self.view];

            break;
        }
        case 4:
        {
            NSLog(@"私秘卡");
//            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
//            NSString *type=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"user_type"]];
//            int user_type=[type intValue];
//            if (user_type==1) {
            UpLoadViewController *vc=[[UpLoadViewController alloc]init];
            vc.vcIDS=100;
            [self presentViewController:vc animated:YES completion:nil];
//            }
            
        }
            

            break;

            
        default:
            break;
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        switch (buttonIndex) {
            case 0:
                NSLog(@"拍照");
                headeImageID=100;
                [self takePhoto];
                break;
            case 1:
                NSLog(@"我的相册");
                headeImageID=100;
                [self LocalPhoto];
                break;
                
                
            default:
                break;
        }

    }
    else if (actionSheet.tag == 2)
    {
        switch (buttonIndex) {
            case 0:
            {
                NSLog(@"男");
                UITextField *textField = (UITextField *)[_userview viewWithTag:1003];
                textField.text = @"男";
            }
                break;
            case 1:
            {
                NSLog(@"女");
                UITextField *textField = (UITextField *)[_userview viewWithTag:1003];
                textField.text = @"女";
            }
                break;
                
                
            default:
                break;
        }

    }
}
#pragma mark - 从相机获取
-(void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType =UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing =YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"无法拍照" message:@"此设备拍照功能不可用" delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
        [alerView show];
    }
}
#pragma mark - 本地照片库
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;  //类型
    picker.delegate = self;  //协议
    picker.allowsEditing =YES;
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - UIImagePickerCont≥rollerDelegate
/*当选择一张图片后进入*/
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        
        NSLog(@"有问题%@",image);
        
        __block NSString* imageFileName;
        NSURL *imageURL ;//= [info valueForKey:UIImagePickerControllerReferenceURL];
        if ([info objectForKey:UIImagePickerControllerReferenceURL]){
            imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        }
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        
        {
            
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            
            imageFileName = [representation filename];
            
        };
        
        
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        
        [assetslibrary assetForURL:imageURL
         
                       resultBlock:resultblock
         
         
                      failureBlock:nil];
        
        
        
        [picker dismissViewControllerAnimated:true completion:nil];
        NSLog(@"iamge%@",imageFileName);
    }
    
    
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        

        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];

        NSLog(@"filePath:%@",filePath);
        //关闭相册界面
        [picker dismissModalViewControllerAnimated:YES];
        
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        UIImageView *smallimage = [[UIImageView alloc] init];
        smallimage.frame = _userview.headImg.frame;
        smallimage.top  = smallimage.top +64;
        smallimage.image = [GetPhoto fixOrientation:image];
//        smallimage.image = [GetPhoto thumbnailWithImageWithoutScale:image size:CGSizeMake(40, 40)];
        
        //加在视图中
        [self.view addSubview:smallimage];
        
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)uploadUserHeadPicture:(UIImage *)image
{
    
}
- (void)backAction
{
    _backBtn.enabled = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
    _backBtn.enabled = YES;
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
