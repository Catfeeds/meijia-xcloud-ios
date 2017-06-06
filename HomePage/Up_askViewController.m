//
//  Up_askViewController.m
//  yxz
//
//  Created by 白玉林 on 16/6/4.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "Up_askViewController.h"
#import "ask_tabViewController.h"
#import "askPicker.h"
@interface Up_askViewController ()<UITextViewDelegate,askPickerDelegate>
{
    UITextView *myTextView;
    int textViewNum;
    UILabel *textLable;
    NSString *_textString;
    UILabel *defaultLabel;
    NSArray *labelArray;
    UILabel *tabLabel;
    UILabel *goldLabel;
    NSString *goldStr;
    NSString *tabStr;
    askPicker *askPic;
    ask_tabViewController *tabVC;
    UIView *topView;
}
@end

@implementation Up_askViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    textViewNum=512;
    self.navlabel.text=@"描述问题";
    goldStr=@"";
    UIButton *addUpBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH-60, 20, 60, 44)];
    [addUpBut setTitle:@"提交" forState:UIControlStateNormal];
    [addUpBut setTitleColor:[UIColor colorWithRed:42/255.0f green:142/255.0f blue:241/255.0f alpha:1] forState:UIControlStateNormal];
    [addUpBut addTarget:self action:@selector(addupAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addUpBut];
    
    myTextView=[[UITextView alloc]initWithFrame:FRAME(0, 64, WIDTH, 150)];
    myTextView.font=[UIFont fontWithName:@"Heiti SC" size:15];
    myTextView.delegate=self;
    [self.view addSubview:myTextView];
    
    defaultLabel=[[UILabel alloc]init];
    defaultLabel.text=@"请在此处填写您的问题，为了得到更好的解答与帮助，请尽可能清晰详尽的描述您的问题";
    defaultLabel.textColor=[UIColor colorWithRed:157/255.0f green:157/255.0f blue:157/255.0f alpha:1];
    UIFont *font=[UIFont fontWithName:@"Heiti SC" size:15];
    defaultLabel.font=font;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize size = [defaultLabel.text boundingRectWithSize:CGSizeMake(WIDTH-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    [defaultLabel setNumberOfLines:0];
    [defaultLabel sizeToFit];
    defaultLabel.frame=FRAME(10, 3, WIDTH-20, size.height);
    [myTextView addSubview:defaultLabel];
    
//    UILabel *label=[[UILabel alloc]initWithFrame:FRAME(0, myTextView.frame.size.height+64, WIDTH, 14)];
//    label.backgroundColor=[UIColor whiteColor];
//    [self.view addSubview:label];
    textLable=[[UILabel alloc]init];
    textLable.backgroundColor=myTextView.backgroundColor;
    textLable.textAlignment=NSTextAlignmentRight;
    [self.view addSubview:textLable];
    [self stringLayout];
    
    UIButton *goldButton=[[UIButton alloc]initWithFrame:FRAME(0, myTextView.frame.size.height+88, WIDTH, 50)];
    [goldButton addTarget:self action:@selector(goldButtonButAction) forControlEvents:UIControlEventTouchUpInside];
    goldButton.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:goldButton];
    UILabel *namelabel=[[UILabel alloc]init];
    namelabel.text=@"我要悬赏";
    namelabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    [namelabel setNumberOfLines:1];
    [namelabel sizeToFit];
    namelabel.frame=FRAME(10, 15, namelabel.frame.size.width, 20);
    [goldButton addSubview:namelabel];
    goldLabel=[[UILabel alloc]init];
    tabLabel=[[UILabel alloc]init];
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    goldLabel.text = [NSString stringWithFormat:@"您有%@金币,有赏有效果哦",delegate.globalDic[@"score"]];
    
//    if (goldStr==nil||goldStr==NULL||[goldStr isEqualToString:@""]) {
//        goldLabel.text=@"设置悬赏可能提高回答者的答案质量";
//    }else{
//        goldLabel.text=tabStr;
//    }
    goldLabel.font=[UIFont fontWithName:@"Heiti SC" size:10];
    [goldLabel setNumberOfLines:1];
    [goldLabel sizeToFit];
    goldLabel.frame=FRAME(namelabel.frame.size.width+30, 15, WIDTH-namelabel.frame.size.width-60, 20);
    goldLabel.textColor=[UIColor colorWithRed:157/255.0f green:157/255.0f  blue:157/255.0f  alpha:1];
    goldLabel.textAlignment=NSTextAlignmentRight;
    [goldButton addSubview:goldLabel];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-30, 15, 20, 20)];
    imageView.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
    [goldButton addSubview:imageView];
    
    

    
    UIButton *tabButton=[[UIButton alloc]initWithFrame:FRAME(0, myTextView.frame.size.height+148, WIDTH, 50)];
    [tabButton addTarget:self action:@selector(tabButAction) forControlEvents:UIControlEventTouchUpInside];
    tabButton.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:tabButton];
    
    UILabel *textlabel=[[UILabel alloc]init];
    textlabel.text=@"问题标签";
    textlabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    [textlabel setNumberOfLines:1];
    [textlabel sizeToFit];
    textlabel.frame=FRAME(10, 15, textlabel.frame.size.width, 20);
    [tabButton addSubview:textlabel];
    tabLabel=[[UILabel alloc]init];
    if (tabStr==nil||tabStr==NULL||[tabStr isEqualToString:@""]) {
        tabLabel.text=@"给提问贴个合适的标签";
    }else{
        tabLabel.text=tabStr;
    }
    
    tabLabel.font=[UIFont fontWithName:@"Heiti SC" size:10];
    tabLabel.textColor=[UIColor colorWithRed:157/255.0f green:157/255.0f  blue:157/255.0f  alpha:1];
    [tabLabel setNumberOfLines:1];
    [tabLabel sizeToFit];
    tabLabel.frame=FRAME(textlabel.frame.size.width+30, 15, WIDTH-textlabel.frame.size.width-60, 20);
    tabLabel.textAlignment=NSTextAlignmentRight;
    [tabButton addSubview:tabLabel];
    UIImageView *imageViews=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-30, 15, 20, 20)];
    imageViews.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
    [tabButton addSubview:imageViews];

    [askPic removeFromSuperview];
    askPic = [[askPicker alloc]initWithFrame:FRAME(0, HEIGHT, WIDTH, 220)];
    askPic.delegate = self;
    [self.view addSubview:askPic];
    topView =[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 25)];
    topView.backgroundColor=[UIColor whiteColor];
    [myTextView setInputAccessoryView:topView];
    UIButton *topBUt=[[UIButton alloc]initWithFrame:FRAME(WIDTH-80, 0, 80, 25)];
    [topBUt addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:topBUt];
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:FRAME(40, 5, 20, 15)];
//    image.backgroundColor=[UIColor redColor];
    image.image=[UIImage imageNamed:@"arrow_xiangxia"];
    [topBUt addSubview:image];
    
    // Do any additional setup after loading the view.

}
-(void)viewWillAppear:(BOOL)animated
{
    if (tabVC.textArray.count>0) {
        labelArray=tabVC.textArray;
        NSMutableArray *array=[[NSMutableArray alloc]init];
        for (int i=0; i<tabVC.textArray.count; i++) {
            NSString *string=[NSString stringWithFormat:@"%@",[tabVC.textArray[i] objectForKey:@"tag_name"]];
            [array addObject:string];
        }
        tabStr=[array componentsJoinedByString:@","];
        tabLabel.text=tabStr;
        
    }
}

#pragma mark  提交按钮点击事件
-(void)addupAction
{
    if(self.loginYesOrNo){
        ISLoginManager *_manager = [ISLoginManager shareManager];
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSMutableArray *array=[[NSMutableArray alloc]init];
        for (int i=0; i<labelArray.count; i++) {
            NSDictionary *dic=labelArray[i];
            NSString *string=[NSString stringWithFormat:@"%@",[dic objectForKey:@"tag_id"]];
            [array addObject:string];
        }
        NSString *tagStr=[array componentsJoinedByString:@","];
        NSString *tag_ids;
        if (tagStr==nil ||tagStr==NULL||[tagStr isEqualToString:@""]) {
            tag_ids=tagStr;
        }else{
            tag_ids=@"";
        }
        if (myTextView.text==nil ||myTextView.text==NULL ||[myTextView.text isEqualToString:@""]) {
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            
            _myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(popAlertView) userInfo:nil repeats:NO];
        }else{
            NSLog(@"%@,%@,%@",myTextView.text,goldStr,tag_ids);
            NSDictionary *dict=@{@"user_id":_manager.telephone,@"title":myTextView.text,@"feed_type":@"2",@"feed_extra":goldStr,@"tag_ids":tag_ids};
            [_download requestWithUrl:[NSString stringWithFormat:@"%@",UP_DONGTAI] dict:dict view:self.view delegate:self finishedSEL:@selector(addUpSuccess:) isPost:YES failedSEL:@selector(addUpFail:)];
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            MyLogInViewController *loginViewController = [[MyLogInViewController alloc] init];
            loginViewController.vCYMID=100;
            UMComNavigationController *navigationController = [[UMComNavigationController alloc] initWithRootViewController:loginViewController];
            [self presentViewController:navigationController animated:YES completion:^{
            }];
        });
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==50||alertView.tag==51) {
        
    }else{
        [self.myTimer invalidate];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)popAlertView{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"问题描述不可以为空，请编辑问题描述！" message:nil  delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    alert.tag=199;
    [alert show];
    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:1];
    
}
- (void) dimissAlert:(UIAlertView *)alert {
    if(alert)     {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}
#pragma mark 提交问题成功返回
-(void)addUpSuccess:(id)datasource
{
    [myTextView setText:@""];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 提交问题失败返回
-(void)addUpFail:(id)datasource
{
    NSLog(@"提交问题失败返回%@",datasource);
}
-(void)dismissKeyBoard
{
    [myTextView resignFirstResponder];
}
#pragma mark 我要悬赏按钮点击
-(void)goldButtonButAction
{
    [myTextView resignFirstResponder];
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    askPic.frame = CGRectMake(0, HEIGHT-220, WIDTH, 220);
    [UIView commitAnimations];
}
- (void)suanle
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    askPic.frame = CGRectMake(0, HEIGHT, WIDTH, 220);
    [UIView commitAnimations];
}

- (void)hours:(NSString *)hours
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    askPic.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
    goldStr=[NSString stringWithFormat:@"%@",hours];
    [self labelLayout];
}
-(void)labelLayout
{
    goldLabel.text=goldStr;
}

#pragma mark 问答标签按钮点击方法
-(void)tabButAction
{
    tabVC=[[ask_tabViewController alloc]init];
    tabVC.askTabArray=labelArray;
    [self.navigationController pushViewController:tabVC animated:YES];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"%lu,%lu,%lu",(unsigned long)textView.text.length,(unsigned long)range.length,(unsigned long)text.length);
    if ((textView.text.length-range.length+text.length)>512)
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"问题描述最多为512字"  delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
//        alert.tag=50;
//        [alert show];
        textViewNum=0;
        return  NO;
    }
    else
    {
        return YES;
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    askPic.frame = CGRectMake(0, HEIGHT, WIDTH, 220);
    [UIView commitAnimations];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length==0) {
        defaultLabel.hidden=NO;
    }else{
        defaultLabel.hidden=YES;
    }
    if (textView.text.length >512)
    {
        textView.text = [textView.text substringToIndex:512];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"问题有点长，控制在512字内好吗亲？"  delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
        alert.tag=51;
        [alert show];
    }
    _textString=myTextView.text;
    int   existTextNum=(int)[_textString length];
    textViewNum=512-existTextNum;
//    [self textView:myTextView shouldChangeTextInRange:textView.text.length replacementText:textView.text];
    [self stringLayout];
}
-(void)stringLayout
{
    NSString *str=[NSString stringWithFormat:@"可输入%d字",textViewNum];
    textLable.text=str;
    textLable.font=[UIFont fontWithName:@"Heiti SC" size:12];
    textLable.textColor=[UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1];
    textLable.lineBreakMode=NSLineBreakByTruncatingTail;
    [textLable setNumberOfLines:1];
    [textLable sizeToFit];
    textLable.frame=FRAME(0,  myTextView.frame.size.height+64, WIDTH, 14);
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
