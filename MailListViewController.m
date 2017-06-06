//
//  MailListViewController.m
//  simi
//
//  Created by 白玉林 on 15/9/22.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "MailListViewController.h"
#import "THContact.h"
@interface MailListViewController ()
{
    UIButton *barButton;
    NSDictionary *zjDic;
    int iDs;
}

@property (nonatomic, assign) ABAddressBookRef addressBookRef;
@end
#define kKeyboardHeight 0.0
@implementation MailListViewController
@synthesize theNumber;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        CFErrorRef error;
        _addressBookRef = ABAddressBookCreateWithOptions(NULL, &error);
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameArray=[[NSMutableArray alloc]init];
    self.mobileArray=[[NSMutableArray alloc]init];
    self.idArray=[[NSMutableArray alloc]init];
    [self.nameArray addObjectsFromArray:_passNameArray];
    [self.mobileArray addObjectsFromArray:_passMobielArray];
    [self.idArray addObjectsFromArray:_passIdArray];
//    mailNumber=choiceNumber;
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *mobli=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"mobile"]];
    zjDic=@{@"name":@"自己",@"mobil":mobli};
    [self tableViewLayout];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshContacts];
    });
}
#pragma mark 通讯录相关的初始化方法
-(void)tableViewLayout
{
    
    //[self.mobileArray addObjectsFromArray:_seleArray];
    self.contactPickerView=[[THContactPickerView alloc]initWithFrame:CGRectMake(0, 44, WIDTH, 100)];
    //self.contactPickerView.backgroundColor=[UIColor redColor];
    self.contactPickerView.delegate=self;
    [self.contactPickerView setPlaceholderString:@"联系人姓名"];
    //self.contactPickerView.hidden=YES;
    [self.view addSubview:self.contactPickerView];
    
    barButton= [[UIButton alloc] initWithFrame:FRAME(WIDTH-70, 27, 60, 30)];
    barButton.enabled = FALSE;
    [barButton setTitle:@"确定" forState:UIControlStateNormal];
    [barButton addTarget:self action:@selector(barButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    barButton.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    //barButton.hidden=YES;
    if(self.mobileArray.count > 0) {
        barButton.enabled = TRUE;
        barButton.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    }
    else
    {
        barButton.enabled = FALSE;
        barButton.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    }
    barButton.layer.cornerRadius=8;
    [self.view addSubview:barButton];
    
    self.mailTableview=[[UITableView alloc]initWithFrame:FRAME(0, self.contactPickerView.frame.size.height, WIDTH, HEIGHT - self.contactPickerView.frame.size.height - kKeyboardHeight)];
    self.mailTableview.dataSource=self;
    self.mailTableview.delegate=self;
    //self.mailTableview.hidden=YES;
    self.mailTableview.tag=100001;
    [self.mailTableview registerNib:[UINib nibWithNibName:@"THContactPickerTableViewCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
    [self.view insertSubview:self.mailTableview belowSubview:self.contactPickerView];
    //[self.view addSubview:self.mailTableview];
    ABAddressBookRequestAccessWithCompletion(self.addressBookRef, ^(bool granted, CFErrorRef error) {
        NSLog(@"%i",granted);
        iDs=granted;
        if (granted) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getContactsFromAddressBook];
            });
        }
    });
    
}
#pragma mark 确定按钮点击方法
-(void)barButtonAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 通讯录的相关方法
-(void)getContactsFromAddressBook
{
    CFErrorRef error=NULL;
    self.contacts=[[NSMutableArray alloc]init];
    ABAddressBookRef addressBOok=ABAddressBookCreateWithOptions(NULL, &error);
    if (addressBOok) {
        NSArray *allContacts=(__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBOok);
        NSMutableArray *mutableContacts=[NSMutableArray arrayWithCapacity:allContacts.count];
        NSUInteger i=0;
        for (i=0; i<allContacts.count; i++) {
            THContact *contact=[[THContact alloc]init];
            ABRecordRef contactPerson=(__bridge ABRecordRef)allContacts[i];
            contact.recordId=ABRecordGetRecordID(contactPerson);
            NSString *firstName=(__bridge_transfer NSString *)ABRecordCopyValue(contactPerson,kABPersonFirstNameProperty);
            NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            
            contact.firstName=firstName;
            contact.lastName=lastName;
            ABMultiValueRef phonesRef=ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            contact.phone=[self getMobilePhoneProperty:phonesRef];
            if (phonesRef) {
                CFRelease(phonesRef);
            }
            NSData  *imgData = (__bridge_transfer NSData *)ABPersonCopyImageData(contactPerson);
            contact.image = [UIImage imageWithData:imgData];
            if (!contact.image) {
                contact.image = [UIImage imageNamed:@"icon-avatar-60x60"];
            }            [mutableContacts addObject:contact];
            
        }
        
        if(addressBOok) {
            CFRelease(addressBOok);
        }
        
        self.contacts = [NSArray arrayWithArray:mutableContacts];
        self.selectedContacts = [NSMutableArray array];
        [self.selectedContacts addObjectsFromArray:_seleArray];
        self.filteredContacts = self.contacts;
        
        [self.mailTableview reloadData];
    }
    else
    {
        NSLog(@"Error");
        
    }
}

#pragma mark 通讯录的相关方法
- (NSString *)getMobilePhoneProperty:(ABMultiValueRef)phonesRef
{
    for (int i=0; i < ABMultiValueGetCount(phonesRef); i++) {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        
        if(currentPhoneLabel) {
            if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
                return (__bridge NSString *)currentPhoneValue;
            }
            
            if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
                return (__bridge NSString *)currentPhoneValue;
            }
        }
        if(currentPhoneLabel) {
            CFRelease(currentPhoneLabel);
        }
        if(currentPhoneValue) {
            CFRelease(currentPhoneValue);
        }
    }
    
    return nil;
}
#pragma mark 通讯录的相关方法

#pragma mark 通讯录的相关方法
- (void) refreshContacts
{
    
    if (iDs==0) {
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"为了能够使用好友推荐和免费电话通知等功能，请前往“设置->隐私->通讯录”中，设置本APP为“开”。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [tsView show];
    }
    for (THContact* contact in self.contacts)
    {
        [self refreshContact: contact];
    }
    [self.mailTableview reloadData];
}
#pragma mark 通讯录的相关方法
- (void) refreshContact:(THContact*)contact
{
    
    ABRecordRef contactPerson = ABAddressBookGetPersonWithRecordID(self.addressBookRef, (ABRecordID)contact.recordId);
    contact.recordId = ABRecordGetRecordID(contactPerson);
    
    // Get first and last names
    NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
    
    // Set Contact properties
    contact.firstName = firstName;
    contact.lastName = lastName;
    
    // Get mobile number
    ABMultiValueRef phonesRef = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
    contact.phone = [self getMobilePhoneProperty:phonesRef];
    if(phonesRef) {
        CFRelease(phonesRef);
    }
    
    // Get image if it exists
    NSData  *imgData = (__bridge_transfer NSData *)ABPersonCopyImageData(contactPerson);
    contact.image = [UIImage imageWithData:imgData];
    if (!contact.image) {
        contact.image = [UIImage imageNamed:@"icon-avatar-60x60"];
    }
}
#pragma mark - UITableView Delegate and Datasource functions
#pragma mark 通讯录的相关方法的 表格tableView的代理与数据协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
#pragma mark 通讯录的相关方法的 表格tableView的代理与数据协议
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int heighInt;
    if (tableView.tag==100001) {
        heighInt=68;
    }else if (tableView.tag==100002)
    {
        heighInt=40;
    }
    return heighInt;
}
#pragma mark 通讯录的相关方法的 表格tableView的代理与数据协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredContacts.count;
}
#pragma mark 通讯录的相关方法的 表格tableView的代理与数据协议
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get the desired contact from the filteredContacts array
    THContact *contact = [self.filteredContacts objectAtIndex:indexPath.row];
    
    // Initialize the table view cell
    NSString *cellIdentifier = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    UILabel *contactNameLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *mobilePhoneNumberLabel = (UILabel *)[cell viewWithTag:102];
    UIImageView *contactImage = (UIImageView *)[cell viewWithTag:103];
    UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
    checkboxImageView.frame=FRAME(WIDTH-40, 21, 20, 20);
    // Assign values to to US elements
    
    contactNameLabel.text = [contact fullName];
    mobilePhoneNumberLabel.text = contact.phone;
    if(contact.image) {
        contactImage.image = contact.image;
    }
    contactImage.layer.masksToBounds = YES;
    
    // Set the checked state for the contact selection checkbox
    UIImage *image;
    NSLog(@"%@,%ld",self.mobileArray,(long)contact.recordId);
    NSString *str=[NSString stringWithFormat:@"%ld",(long)contact.recordId];
    NSString *strUrl = [contact.phone stringByReplacingOccurrencesOfString:@"-" withString:@""];//[NSString stringWithFormat:@"%ld",(long)contact.recordId];
    if ([self.selectedContacts containsObject:strUrl]||[_idArray containsObject:str]){
        NSLog(@"什么鬼？%@",self.selectedContacts);
        [self.contactPickerView addContact:contact withName:contact.fullName];
        image = [UIImage imageNamed:@"icon-checkbox-selected-green-25x25"];
    } else {
        //cell.accessoryType = UITableViewCellAccessoryNone;
        image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
    }
    checkboxImageView.image = image;
    
    
    return cell;
}
#pragma mark 通讯录的相关方法的 表格tableView的点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Hide Keyboard
    [self.contactPickerView resignKeyboard];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // This uses the custom cellView
    // Set the custom imageView
    THContact *user = [self.filteredContacts objectAtIndex:indexPath.row];
    UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
    UIImage *image;
    NSLog(@"设么鬼啊   啊 啊 a%d",theNumber);
    if (theNumber<10) {
        NSString *strUrl = [NSString stringWithFormat:@"%ld",(long)user.recordId];//[user.phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSString *mobileString=[NSString stringWithFormat:@"%@",user.phone];
        NSString *str = [mobileString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSLog(@"%@,%@",self.selectedContacts,strUrl);
        if ([self.selectedContacts containsObject:str]||[_idArray containsObject:strUrl]){ // contact is already selected so remove it from ContactPickerView
            //cell.accessoryType = UITableViewCellAccessoryNone;
            [self.selectedContacts removeObject:str];
            [self.contactPickerView removeContact:user];
            [self.nameArray removeObject:user.fullName];
            [self.mobileArray removeObject:str];
            [self.idArray removeObject:strUrl];
            theNumber-=1;
            // Set checkbox to "unselected"
            image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
        } else {
            // Contact has not been selected, add it to THContactPickerView
            //cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.selectedContacts addObject:str];
            [self.contactPickerView addContact:user withName:user.fullName];
            // Set checkbox to "selected"
            NSLog(@"这是什么玩意:%@,%@",user.phone,user.fullName);
            [self.nameArray addObject:user.fullName];
            [self.mobileArray addObject:str];
            [self.idArray addObject:strUrl];
            image = [UIImage imageNamed:@"icon-checkbox-selected-green-25x25"];
            theNumber++;
        }

        
        // Enable Done button if total selected contacts > 0
        if(self.mobileArray.count > 0) {
            barButton.enabled = TRUE;
            barButton.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
        }
        else
        {
            barButton.enabled = FALSE;
            barButton.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
        }
        
        // Update window title
        self.title = [NSString stringWithFormat:@"Add Members (%lu)", (unsigned long)self.selectedContacts.count];
        self.selectString=[self.nameArray componentsJoinedByString:@","];
        self.numberString=[NSString stringWithFormat:@"共%lu人",(unsigned long)self.selectedContacts.count];
        
        // Set checkbox image
        checkboxImageView.image = image;
        // Reset the filtered contacts
        self.filteredContacts = self.contacts;
        // Refresh the tableview
        [self.mailTableview reloadData];
    }else{
        NSString *strUrl = [user.phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSString *str=[NSString stringWithFormat:@"%ld",(long)user.recordId];
        if ([self.mobileArray containsObject:strUrl]||[_idArray containsObject:str]) {
            [self.selectedContacts removeObject:user];
            [self.contactPickerView removeContact:user];
            [self.nameArray removeObject:user.fullName];
            [self.mobileArray removeObject:strUrl];
            [self.idArray removeObject:str];
            theNumber-=1;
            // Set checkbox to "unselected"
            image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
            [self.mailTableview reloadData];
        }else
        {
            //[self ParticipationLabelLayout];
            NSString *str=[NSString stringWithFormat:@"好友与联系人相加最多可选择10人！！"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Done!"
                                                                message:str
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }

    }
    NSLog(@"个数::%d",theNumber);
}

#pragma mark - THContactPickerTextViewDelegate
#pragma mark 通讯录的相关方法的
- (void)contactPickerTextViewDidChange:(NSString *)textViewText {
    if ([textViewText isEqualToString:@""]){
        self.filteredContacts = self.contacts;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.%@ contains[cd] %@ OR self.%@ contains[cd] %@", @"firstName", textViewText, @"lastName", textViewText];
        self.filteredContacts = [self.contacts filteredArrayUsingPredicate:predicate];
    }
    [self.mailTableview reloadData];
}
#pragma mark 通讯录的相关方法的
- (void)contactPickerDidResize:(THContactPickerView *)contactPickerView {
    [self adjustTableViewFrame:YES];
}
#pragma mark 通讯录的相关方法的
- (void)contactPickerDidRemoveContact:(id)contact {
    [self.selectedContacts removeObject:contact];
    [self.nameArray removeObject:contact];
    theNumber-=1;
    NSUInteger index = [self.contacts indexOfObject:contact];
    UITableViewCell *cell = [self.mailTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    //cell.accessoryType = UITableViewCellAccessoryNone;
    
    // Enable Done button if total selected contacts > 0
    if(self.selectedContacts.count > 0) {
        barButton.enabled = TRUE;
    }
    else
    {
        barButton.enabled = FALSE;
    }
    
    // Set unchecked image
    UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
    UIImage *image;
    image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
    checkboxImageView.image = image;
    
    // Update window title
    self.title = [NSString stringWithFormat:@"Add Members (%lu)", (unsigned long)self.selectedContacts.count];
}
#pragma mark 通讯录的相关方法的
- (void)removeAllContacts:(id)sender
{
    [self.contactPickerView removeAllContacts];
    [self.selectedContacts removeAllObjects];
    self.filteredContacts = self.contacts;
    [self.mailTableview reloadData];
}
#pragma mark ABPersonViewControllerDelegate
#pragma mark 通讯录的相关方法的
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return YES;
}
#pragma mark 通讯录的相关方法的
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat topOffset = 0;
    if ([self respondsToSelector:@selector(topLayoutGuide)]){
        topOffset = 64;
    }
    CGRect frames = self.contactPickerView.frame;
    frames.origin.y = topOffset;
    self.contactPickerView.frame = frames;
    [self adjustTableViewFrame:NO];
}
#pragma mark 通讯录的相关方法的
- (void)adjustTableViewFrame:(BOOL)animated {
    CGRect frames = self.mailTableview.frame;
    // This places the table view right under the text field
    frames.origin.y = self.contactPickerView.frame.size.height+64;
    // Calculate the remaining distance
    frames.size.height = self.view.frame.size.height - self.contactPickerView.frame.size.height - kKeyboardHeight;
    
    if(animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        self.mailTableview.frame = frames;
        
        [UIView commitAnimations];
    }
    else{
        self.mailTableview.frame = frames;
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
