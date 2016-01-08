//
//  ConTentViewController.m
//  simi
//
//  Created by 白玉林 on 15/9/9.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "ConTentViewController.h"

@interface ConTentViewController ()
{
    UIView *view;
    int textViewNum;
    UILabel *textLable;
   // NSString *textString;
}
@end

@implementation ConTentViewController
-(void)viewWillAppear:(BOOL)animated
{
    int   existTextNum=[_textString length];
    
    textViewNum=200-existTextNum;
    [self stringLayout];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    textViewNum=200;
    [self textViewLayout];
    
    // Do any additional setup after loading the view.
}
-(void)textViewLayout
{
    view =[[UIView alloc]init];
    view.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    _textView=[[UITextView alloc]initWithFrame:FRAME(10, 32/2, WIDTH-20, 150)];
    _textView.layer.borderColor = [[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1]CGColor];
    _textView.text=_textString;
    _textView.layer.cornerRadius=8;
    _textView.layer.borderWidth = 2;
    _textView.delegate=self;
    [view addSubview:_textView];
    
    textLable=[[UILabel alloc]init];
    [_textView addSubview:textLable];
    [self stringLayout];
    
    UIButton *submitButton=[[UIButton alloc]initWithFrame:FRAME(14, _textView.frame.size.height+_textView.frame.origin.y+41, WIDTH-28, 41)];
    submitButton.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    submitButton.layer.cornerRadius=5;
    [submitButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:submitButton];
    view.frame=FRAME(0, 64, WIDTH, submitButton.frame.size.height+submitButton.frame.origin.y+10);
    [self.view addSubview:view];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (range.location>=200)
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                        message:@"超过最大字数不能输入了"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"Ok"
//                                              otherButtonTitles:nil, nil];
//        [alert show];
        //[self.view endEditing:YES];
        textViewNum=0;
        return  NO;
    }
    else
    {
        return YES;
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    _textString=_textView.text;
    int   existTextNum=[_textString length];
    
    textViewNum=200-existTextNum;
    [self stringLayout];
}
-(void)stringLayout
{
    NSString *str=[NSString stringWithFormat:@"可输入%d字",textViewNum];
    textLable.text=str;
    textLable.font=[UIFont fontWithName:@"Arial" size:12];
    textLable.lineBreakMode=NSLineBreakByTruncatingTail;
    [textLable setNumberOfLines:1];
    [textLable sizeToFit];
    textLable.frame=FRAME(_textView.frame.size.width-textLable.frame.size.width-3, _textView.frame.size.height-18, textLable.frame.size.width, 15);
}
-(void)buttonAction:(UIButton *)sender
{
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    [_textView resignFirstResponder];
    [UIView commitAnimations];
    _textString=_textView.text;
    NSLog( @"%@",_textString);
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backAction
{
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    [_textView resignFirstResponder];
    [UIView commitAnimations];
    [self.navigationController popViewControllerAnimated:YES];
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
