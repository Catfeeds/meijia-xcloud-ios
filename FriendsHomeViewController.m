//
//  FriendsHomeViewController.m
//  yxz
//
//  Created by 白玉林 on 15/11/30.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "FriendsHomeViewController.h"
#import "FXBlurView.h"
#import "ISLoginManager.h"
#import "DownloadManager.h"
#import "ChatViewController.h"
#import "RootViewController.h"
#import "DynamicViewController.h"
#import "ShopViewController.h"
@interface FriendsHomeViewController ()
{
    FXBlurView *fxBlurView;
    UIImageView *headView;
    UIImageView *headeImageView;
    NSDictionary *homeDic;
    UIView *lineView;
    UIView *mainView;
    UIViewController *currentViewController;
}
@end
DynamicViewController *dynamicViewController;
ShopViewController *shopViewController;
@implementation FriendsHomeViewController

- (void)viewDidLoad {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [super viewDidLoad];
    self.navlabel.text=@"好友主页";
    self.view.backgroundColor=[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dic = @{@"user_id":_manager.telephone,@"view_user_id":_view_user_id};
    [_download requestWithUrl:USER_GRZY dict:_dic view:self.view delegate:self finishedSEL:@selector(HomeSuccess:) isPost:NO failedSEL:@selector(HomeFailure:)];
    mainView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT*0.43+116,SELF_VIEW_WIDTH, HEIGHT-(HEIGHT*0.43+116))];
    mainView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:mainView];
    
    shopViewController=[[ShopViewController alloc]init];
    [self addChildViewController:shopViewController];
    
    dynamicViewController=[[DynamicViewController alloc]init];
    dynamicViewController.vcLayoutID=100;
    dynamicViewController.friendID=_view_user_id;
    [self addChildViewController:dynamicViewController];
    
    [mainView addSubview:shopViewController.view];
    currentViewController = shopViewController;

        // Do any additional setup after loading the view.
}
#pragma mark 获取好友个人主页成功接口返回数据
-(void)HomeSuccess:(id)sender
{
    NSLog(@"好友主页数据--%@",sender);
    homeDic=[sender objectForKey:@"data"];
    [self headViewLayout];
    
}
#pragma mark 获取好友个人主页失败接口返回数据
-(void)HomeFailure:(id)sender
{
    
}
-(void)headViewLayout
{
    [headView removeFromSuperview];
    [fxBlurView removeFromSuperview];
    [headeImageView removeFromSuperview];
    NSString *imageStr=[NSString stringWithFormat:@"%@",[homeDic objectForKey:@"head_img"]];
    headView=[[UIImageView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT*0.43)];
//    if ([imageStr length]==0||[imageStr length]==1) {
//        headView.image=[UIImage imageNamed:@"家-我_默认头像"];
//    }else{
//        headView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[homeDic objectForKey:@"head_img"]]]];
//    }
    headView.backgroundColor=HEX_TO_UICOLOR(0xe8374a, 1.0);
    NSString *imageUrl=@"http://123.57.173.36/simi-h5/img/friend_bg_update.jpg";
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    headView.image=[UIImage imageWithData:data];
    [self.view addSubview:headView];
    
    fxBlurView=[FXBlurView new];
    fxBlurView.frame=FRAME(0, 64, WIDTH, HEIGHT*0.43);
    fxBlurView.backgroundColor=[UIColor brownColor];
    [fxBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin];
    [self.view addSubview:fxBlurView];
    
    headeImageView=[[UIImageView alloc]initWithFrame:FRAME((WIDTH-HEIGHT*0.14)/2, 20, HEIGHT*0.14, HEIGHT*0.14)];
    if ([imageStr length]==0||[imageStr length]==1) {
        headeImageView.image=[UIImage imageNamed:@"家-我_默认头像"];
    }else{
        headeImageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[homeDic objectForKey:@"head_img"]]]];
    }
    [headeImageView.layer setCornerRadius:CGRectGetHeight([headeImageView bounds]) / 2];
    headeImageView.layer.masksToBounds = YES;
    headeImageView.layer.borderWidth = 2;
    headeImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [fxBlurView addSubview:headeImageView];
    NSString *nameString;
    NSString *nameStr=[NSString stringWithFormat:@"%@",[homeDic objectForKey:@"name"]];
    UILabel *nameLabel=[[UILabel alloc]init];
    if (nameStr==nil||nameStr==NULL||[nameStr isEqualToString:@""]) {
        nameString=[NSString stringWithFormat:@"%@",[homeDic objectForKey:@"mobile"]];
    }else{
        nameString=[NSString stringWithFormat:@"%@",[homeDic objectForKey:@"name"]];
    }
    nameLabel.text=nameString;
    nameLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [nameLabel setNumberOfLines:1];
    [nameLabel sizeToFit];
    nameLabel.adjustsFontSizeToFitWidth=YES;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font=[UIFont systemFontOfSize:18];
    nameLabel.frame=FRAME((WIDTH-nameLabel.frame.size.width)/2, headeImageView.frame.origin.y+headeImageView.frame.size.height+30, nameLabel.frame.size.width, 20);
    nameLabel.textColor=[UIColor whiteColor];
    [fxBlurView addSubview:nameLabel];
    
    NSString *sexString=[NSString stringWithFormat:@"%@",[homeDic objectForKey:@"sex"]];
    UIImageView *sexImageView=[[UIImageView alloc]initWithFrame:FRAME(nameLabel.frame.origin.x+nameLabel.frame.size.width+5, nameLabel.frame.origin.y, 10, 20)];
    if (sexString==nil||sexString==NULL||[sexString isEqualToString:@" "]) {
        sexImageView.image=[UIImage imageNamed:@"WD_XB_ ♀_TB"];
    }else{
        if ([sexString isEqualToString:@"0"]) {
            sexImageView.image=[UIImage imageNamed:@"WD_XB_ ♀_TB"];
        }else{
            sexImageView.image=[UIImage imageNamed:@"WD_XB_ ♂_TB_@2x"];
        }
    }
//    [fxBlurView addSubview:sexImageView];
    
    UIImageView *gradeImageView=[[UIImageView alloc]initWithFrame:FRAME(sexImageView.frame.origin.x+15, sexImageView.frame.origin.y, 30, 20)];
    gradeImageView.image=[UIImage imageNamed:@"WD_DJ_TB_@2x"];
//    [fxBlurView addSubview:gradeImageView];
    UILabel *gradeLabel=[[UILabel alloc]initWithFrame:FRAME(0, 0, 30, 20)];
    gradeLabel.text=@"LV1";
    gradeLabel.font=[UIFont fontWithName:@"Heiti SC" size:10];
    gradeLabel.textAlignment=NSTextAlignmentCenter;
    gradeLabel.textColor=[UIColor whiteColor];
    [gradeImageView addSubview:gradeLabel];
    
    
    //添加好友按钮
    UIButton *addButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH/2-204/2, nameLabel.frame.size.height+nameLabel.frame.origin.y+50, 204/2, 30)];
    addButton.backgroundColor=[UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1];
    UILabel *addLabel=[[UILabel alloc]init];
    addLabel.textColor=[UIColor whiteColor];
    addLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    
//    
//    for (int i=0; i<_array.count; i++) {
//        NSDictionary *dic=_array[i];
//        NSString *user_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"friend_id"]];
//        int usID=[user_id intValue];
        int viewUserId=[[homeDic objectForKey:@"is_friend"] intValue];

        if (viewUserId==1) {
            addLabel.text=@"已是好友";
            addButton.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
            addButton.enabled=FALSE;
            addLabel.lineBreakMode=NSLineBreakByTruncatingTail;
            [addLabel setNumberOfLines:1];
            [addLabel sizeToFit];
            addLabel.frame=FRAME((addButton.frame.size.width-addLabel.frame.size.width)/2, (addButton.frame.size.height-addLabel.frame.size.height)/2, addLabel.frame.size.width, addLabel.frame.size.height);
//            break;
        }else{
            addLabel.text=@"添加好友";
            addButton.backgroundColor=[UIColor colorWithRed:231/255.0f green:55/255.0f blue:74/255.0f alpha:1];
            addButton.enabled=TRUE;
            addLabel.lineBreakMode=NSLineBreakByTruncatingTail;
            [addLabel setNumberOfLines:1];
            [addLabel sizeToFit];
            addLabel.frame=FRAME((addButton.frame.size.width-addLabel.frame.size.width)/2, (addButton.frame.size.height-addLabel.frame.size.height)/2, addLabel.frame.size.width, addLabel.frame.size.height);
        }
//    }
    [addButton addSubview:addLabel];
    addButton.layer.cornerRadius=4;
    [addButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [fxBlurView addSubview:addButton];
    
    
    //私聊按钮
    UIButton *whisperButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH/2+17/2, addButton.frame.origin.y, 204/2, 30)];
    
    whisperButton.backgroundColor=[UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1];
    whisperButton.layer.cornerRadius=4;
    [whisperButton addTarget:self action:@selector(whisperAction:) forControlEvents:UIControlEventTouchUpInside];
    [fxBlurView addSubview:whisperButton];
    
    UILabel *whisperLabel=[[UILabel alloc]init];
    whisperLabel.text=@"私聊";
    whisperLabel.textColor=[UIColor whiteColor];
    whisperLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    whisperLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [whisperLabel setNumberOfLines:1];
    [whisperLabel sizeToFit];
    whisperLabel.frame=FRAME((whisperButton.frame.size.width-whisperLabel.frame.size.width)/2, (whisperButton.frame.size.height-whisperLabel.frame.size.height)/2, whisperLabel.frame.size.width, whisperLabel.frame.size.height);
    [whisperButton addSubview:whisperLabel];

    UIView *releaseView=[[UIView alloc]initWithFrame:FRAME(0, fxBlurView.frame.size.height+64, WIDTH, 42)];
    releaseView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:releaseView];
    NSArray *nameArray=@[@"店铺",@"动态"];
    for (int i=0; i<nameArray.count; i++) {
        UIButton *tabbarBut=[[UIButton alloc]initWithFrame:FRAME((WIDTH/2+0.5)*i, 0, WIDTH/2-0.5, 40)];
        [tabbarBut setTitle:nameArray[i] forState:UIControlStateNormal];
        if(i==0){
            [tabbarBut setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
        }else{
            [tabbarBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        tabbarBut.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        [tabbarBut addTarget:self action:@selector(tabBarButton:) forControlEvents:UIControlEventTouchUpInside];
        [tabbarBut setTag:(1000+i)];
        [releaseView addSubview:tabbarBut];
        
    }
    UIView *linesView=[[UIView alloc]initWithFrame:FRAME(WIDTH/2-0.5, 0, 1, 40)];
    linesView.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [releaseView addSubview:linesView];
    lineView=[[UIView alloc]initWithFrame:FRAME(0, 40, WIDTH/2, 2)];
    lineView.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [releaseView addSubview:lineView];

}
-(void)tabBarButton:(UIButton *)sender
{
    if ((currentViewController==shopViewController&&[sender tag]==1000)||(currentViewController==dynamicViewController&&[sender tag]==1001)) {
        return;
    }
    UIViewController *oldViewController=currentViewController;
    static int currentSelectButtonIndex = 0;
    static int previousSelectButtonIndex=1000;
    currentSelectButtonIndex=(int)sender.tag;
    UIButton *previousBtn=(UIButton *)[self.view viewWithTag:previousSelectButtonIndex];
    [previousBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIButton *currentBtn = (UIButton *)[self.view viewWithTag:currentSelectButtonIndex];;
    [currentBtn setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
    previousSelectButtonIndex=currentSelectButtonIndex;
    switch (sender.tag) {
        case 1000:
        {
            [self transitionFromViewController:currentViewController toViewController:shopViewController duration:0.5 options:0 animations:^{
            }  completion:^(BOOL finished) {
                if(finished){
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.5];
                    lineView.frame=FRAME(0, 40, WIDTH/2, 2);
                    [UIView commitAnimations];
                    currentViewController=shopViewController;
                    
                }else{
                    currentViewController=oldViewController;
                    
                }
                
            }];

            
            
        }
            break;
        case 1001:
        {
            
            [self transitionFromViewController:currentViewController toViewController:dynamicViewController duration:0.5 options:0 animations:^{
            }  completion:^(BOOL finished) {
                if(finished){
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.5];
                    lineView.frame=FRAME(WIDTH/2, 40, WIDTH/2, 2);
                    [UIView commitAnimations];
                    currentViewController=dynamicViewController;
                    
                }else{
                    currentViewController=oldViewController;
                    
                }
                
            }];

            
        }
            break;
            
        default:
            break;
    }
}
#pragma mark 添加好友按钮点击方法
-(void)addAction:(UIButton *)sender
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dicts = @{@"user_id":_manager.telephone,@"friend_id":_view_user_id};
    NSLog(@"字典数据%@",_dicts);
    [_download requestWithUrl:USER_QRHY dict:_dicts view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
}
-(void)logDowLoadFinish:(id)sender
{
    NSLog(@"添加成功:");
}
-(void)DownFail:(id)sender
{
    
}
#pragma mark 私聊按钮点击啊方法
-(void)whisperAction:(UIButton *)sender
{
    ChatViewController *vcr=[[ChatViewController alloc]initWithChatter:[homeDic objectForKey:@"im_user_name"] isGroup:NO];
    vcr.title=[NSString stringWithFormat:@"%@",[homeDic objectForKey:@"name"]];
    [vcr.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:vcr animated:YES];
}
- (void)backAction
{
    if (_friendsID==100) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[RootViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }else {
        _backBtn.enabled = NO;
        [self.navigationController popViewControllerAnimated:YES];
        _backBtn.enabled = YES;
    }
    
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
