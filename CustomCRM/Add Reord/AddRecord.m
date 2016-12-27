//
//  AddRecord.m
//  CustomCRM
//
//  Created by Pinal Panchani on 13/12/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import "AddRecord.h"

@interface AddRecord (){
    NSMutableArray *allData, *arrSectionTitle, *arrTblData, *arrSearch;
    UIButton *btnSelect;
    UITextView *txtView;
    UITextField *txtField;
    BOOL flag;
    float width;
}

@end

@implementation AddRecord
@synthesize lblTitle,strRecord;

- (void)viewDidLoad {
    [super viewDidLoad];
    allData = [[NSMutableArray alloc] init];
    arrSectionTitle = [[NSMutableArray alloc] init];
    arrTblData = [[NSMutableArray alloc] init];
    arrSearch = [[NSMutableArray alloc] init];
    
    width = [UIScreen mainScreen].bounds.size.width - 32;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // Do any additional setup after loading the view.
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    sclView.contentInset = contentInsets;
    sclView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (flag) {
        if (!CGRectContainsPoint(aRect, txtField.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, txtField.frame.origin.y-kbSize.height);
            [sclView setContentOffset:scrollPoint animated:YES];
        }
    }
    else{
        if (!CGRectContainsPoint(aRect, txtView.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, txtView.frame.origin.y-kbSize.height);
            [sclView setContentOffset:scrollPoint animated:YES];
        }
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    sclView.contentInset = contentInsets;
    sclView.scrollIndicatorInsets = contentInsets;
}


- (void)viewWillAppear:(BOOL)animated{
    viewSearch.hidden = YES;
    [self viewPickerHidden:YES];
    [self setFonts_Background];
    lblScreenTitle.font = [SET_FONTS_REGULAR fontWithSize:22];
    lblScreenTitle.text = lblTitle;
    [self GetMobileInsertDataField];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrSearch.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [arrSearch objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.font = [SET_FONTS_REGULAR fontWithSize:14];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    txtField.text = [arrSearch objectAtIndex:indexPath.row];
    viewSearch.hidden = YES;
}


- (void)GetMobileInsertDataField{
    
//    NSMutableArray *tArray=[[NSMutableArray alloc] initWithArray:@[@{@"CompanyID":WORKGROUP},@{@"PageName":@"addlead"}]];
    NSMutableArray *tArray=[[NSMutableArray alloc] initWithArray:@[@{@"CompanyID":@"7639"},@{@"PageName":strRecord}]];
    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:GET_MOBILE_INSERT_DATA_FIELDS arrPerameter:tArray withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        if (!rootDoctument)
        {
            //  _tblEvents.hidden = true;
        }
        else
        {
            [allData removeAllObjects];
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeInsertFieldData"])
            {
                NSMutableDictionary *tmpDataDic=[[NSMutableDictionary alloc]init];
                if([doc valueWithPath:@"FieldID"])
                    [tmpDataDic setValue:[doc valueWithPath:@"FieldID"] forKey:@"FieldID"];
                if([doc valueWithPath:@"FieldName"])
                    [tmpDataDic setValue:[doc valueWithPath:@"FieldName"] forKey:@"FieldName"];
                if([doc valueWithPath:@"FieldValue"])
                    [tmpDataDic setValue:[doc valueWithPath:@"FieldValue"] forKey:@"FieldValue"];
                if([doc valueWithPath:@"FieldDataType"])
                    [tmpDataDic setValue:[doc valueWithPath:@"FieldDataType"] forKey:@"FieldDataType"];
                if([doc valueWithPath:@"FieldRequired"])
                    [tmpDataDic setValue:[doc valueWithPath:@"FieldRequired"] forKey:@"FieldRequired"];
                [allData addObject:tmpDataDic];
            }
            [self getTotalSection];
        }
    }];
}

- (void)getTotalSection{
    [arrSectionTitle removeAllObjects];
    for (int i = 0; i < allData.count; i++) {
        NSDictionary *dic = [allData objectAtIndex:i];
        if (![arrSectionTitle containsObject:[[[dic objectForKey:@"FieldValue"] componentsSeparatedByString:@":"] objectAtIndex:0]]) {
            [arrSectionTitle addObject:[[[dic objectForKey:@"FieldValue"] componentsSeparatedByString:@":"] objectAtIndex:0]];
        }
    }
    [self setDynmicDesign];
}

- (void)setDynmicDesign{
    float y = 12.0f;
    
    for (int i = 0 ; i < arrSectionTitle.count ; i++){
        
        // Section Header
        NSString *title = @"";
        y += 4;
        if ([[arrSectionTitle objectAtIndex:i] isEqualToString:@"sales_comment"]) {
            title = @"Sales Rep Comments/Notes";
        }
        else{
            NSArray *arr = [[arrSectionTitle objectAtIndex:i] componentsSeparatedByString:@"_"];
            for (int j = 0; j < arr.count; j++) {
                title = [NSString stringWithFormat:@"%@ %@",title,[[arr objectAtIndex:j] capitalizedString]];
            }
        }
        [sclView addSubview:[self lblHeader:y title:title]];
        y += 43;
        
        // Add sub data (textfield & dropdown)
        for ( int j = 0; j < allData.count; j++) {
            NSDictionary *dic = [allData objectAtIndex:j];
            if ([[arrSectionTitle objectAtIndex:i] isEqualToString:[[[dic objectForKey:@"FieldValue"] componentsSeparatedByString:@":"] objectAtIndex:0]]) {
                // compare textfield or dropdown
                if ([[[[dic objectForKey:@"FieldValue"] componentsSeparatedByString:@":"] objectAtIndex:2] isEqualToString:@"none"] || [[[[dic objectForKey:@"FieldValue"] componentsSeparatedByString:@":"] objectAtIndex:2] isEqualToString:@"NONE"]) {
                    if ([[arrSectionTitle objectAtIndex:i] isEqualToString:@"sales_comment"]) {
                        [sclView addSubview:[self txtView:y title:[dic objectForKey:@"FieldName"] tag:j]];
                        y += 125;
                    }
                    else{
                        [sclView addSubview:[self txtField:y title:[dic objectForKey:@"FieldName"] tag:j]];
                        y += 35;
                    }
                }
                else{
                    [sclView addSubview:[self btnDropDown:y title:[dic objectForKey:@"FieldName"] tag:j]];
                    y += 35;
                }
            }
        }
    }
    y += 12;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(16, y, width-4, 30)];
    btn.layer.cornerRadius = 3.0f;
    btn.clipsToBounds = YES;
    btn.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
    [btn setTitle:@"Update" forState:UIControlStateNormal];
    btn.titleLabel.font = [SET_FONTS_REGULAR fontWithSize:16];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnSubmit:) forControlEvents:UIControlEventTouchUpInside];
    y += 30;
    [sclView addSubview:btn];
    [sclView setContentSize:CGSizeMake(width+32, y + 32)];
}

- (UILabel *)lblHeader:(float)y title:(NSString *)title{
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(16, y, width, 35)];
    lblHeader.font = [SET_FONTS_REGULAR fontWithSize:20];
    lblHeader.textColor = [UIColor whiteColor];
    lblHeader.backgroundColor = [UIColor darkGrayColor];
    lblHeader.text = title;
    lblHeader.layer.cornerRadius = 3.0;
    lblHeader.clipsToBounds = YES;
    return lblHeader;
}

- (UITextField *)txtField:(float)y title:(NSString *)title tag:(NSInteger)tag{
    txtField = [[UITextField alloc] initWithFrame:CGRectMake(18, y, width-4, 30)];
    txtField.delegate = self;
    txtField.borderStyle = UITextBorderStyleRoundedRect;
    txtField.textColor = [UIColor blackColor];
    txtField.font = [SET_FONTS_REGULAR fontWithSize:16];
    txtField.placeholder = title;
    txtField.backgroundColor = [UIColor whiteColor];
    txtField.tag = tag;
    return txtField;
}

- (UITextView *)txtView:(float)y title:(NSString *)title tag:(NSInteger)tag{
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(16, y, width, 35)];
    lblHeader.font = [SET_FONTS_REGULAR fontWithSize:20];
    lblHeader.textColor = [UIColor blackColor];
    lblHeader.text = title;
    [sclView addSubview:lblHeader];
    y += 40;
    
    txtView = [[UITextView alloc] initWithFrame:CGRectMake(18, y, width-4, 80)];
    txtView.layer.cornerRadius = 5.0f;
    txtView.layer.borderWidth = 0.5f;
    txtView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    txtView.clipsToBounds = YES;
    txtView.textColor = [UIColor blackColor];
    txtView.font = [SET_FONTS_REGULAR fontWithSize:16];
    txtView.backgroundColor = [UIColor whiteColor];
    txtView.tag = tag;
    return txtView;
}


- (UIView *)btnDropDown:(float)y title:(NSString *)title tag:(NSInteger)tag{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(18, y, width - 4, 30)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 5.0f;
    view.layer.borderWidth = 0.5f;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    view.clipsToBounds = YES;
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - 30, (view.frame.size.height - 8)/2, 15, 8)];
    img.image = [UIImage imageNamed:@"down"];
    [view addSubview:img];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width-4, 30)];
    btn.backgroundColor = [UIColor clearColor];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 38);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [SET_FONTS_REGULAR fontWithSize:16];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dropDown:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    [view addSubview:btn];
    return view;
}

- (IBAction)dropDown:(UIButton *)sender{
    [txtView resignFirstResponder];
    [txtField resignFirstResponder];
    btnSelect = sender;
    NSDictionary *dic = [allData objectAtIndex:sender.tag];
    lblPickerTitle.font = [SET_FONTS_REGULAR fontWithSize:16];
    lblPickerTitle.text = [NSString stringWithFormat:@"Select %@ :",[dic objectForKey:@"FieldName"]];
//    NSMutableArray *tArray=[[NSMutableArray alloc] initWithArray:@[@{@"LogonID":LOGIN},@{@"CompanyID":WORKGROUP},@{@"TableName":[[[dic objectForKey:@"FieldValue"] componentsSeparatedByString:@":"] objectAtIndex:2]}]];
    NSMutableArray *tArray=[[NSMutableArray alloc] initWithArray:@[@{@"LogonID":LOGIN_ID},@{@"CompanyID":@"7639"},@{@"TableName":[[[dic objectForKey:@"FieldValue"] componentsSeparatedByString:@":"] objectAtIndex:2]}]];
    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:GET_REFERENCE_TABLEDATA arrPerameter:tArray withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        if (!rootDoctument)
        {
            //  _tblEvents.hidden = true;
        }
        else
        {
            [arrTblData removeAllObjects];
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeKeyValue"])
            {
                NSMutableDictionary *tmpDataDic=[[NSMutableDictionary alloc]init];
                if([doc valueWithPath:@"Key"])
                    [tmpDataDic setValue:[doc valueWithPath:@"Key"] forKey:@"Key"];
                if([doc valueWithPath:@"Value"])
                    [tmpDataDic setValue:[doc valueWithPath:@"Value"] forKey:@"Value"];
                [arrTblData addObject:tmpDataDic];
            }
            if (arrTblData.count > 0) {
                [pickerList selectRow:0 inComponent:0 animated:YES];
                [pickerList reloadAllComponents];
                [self viewPickerHidden:NO];
            }
        }
    }];
}

- (IBAction)btnSubmit:(UIButton *)sender{
    NSMutableDictionary *passDic = [[NSMutableDictionary alloc] init];
    for ( UIView *subview in sclView.subviews){
        
        // textfield
        if ([subview isKindOfClass:[UITextField class]]) {
            NSDictionary *dic = [allData objectAtIndex:subview.tag];
            txtField = (UITextField *)subview;
            if (![[dic objectForKey:@"FieldRequired"] isEqualToString:@"false"]) {
                if ([txtField.text length] > 0) {
                    if ([[dic objectForKey:@"FieldName"] isEqualToString:@"Email"]) {
                        
                        if ([self NSStringIsValidEmail:txtField.text]) {
                            [passDic setObject:txtField.text forKey:[dic objectForKey:@"FieldID"]];
                        }
                        else{
                            [txtField becomeFirstResponder];
                            [BaseApplication showAlertWithTitle:@"CustomCRM" withMessage:@"Please enter the correct mail id"];
                            return;
                        }
                    }
                    else
                        [passDic setObject:txtField.text forKey:[dic objectForKey:@"FieldID"]];
                }
                else{
                    [txtField becomeFirstResponder];
                     [BaseApplication showAlertWithTitle:@"CustomCRM" withMessage:[NSString stringWithFormat:@"Please enter the %@",[dic objectForKey:@"FieldName"]]];
                    return;
                }
            }
            else{
                [passDic setObject:txtField.text forKey:[dic objectForKey:@"FieldID"]];
            }
        }
        
        // drop down
        if ([subview isKindOfClass:[UIView class]]) {
            for ( UIView *childview in subview.subviews){
                if ([childview isKindOfClass:[UIButton class]]) {
                    NSDictionary *dic = [allData objectAtIndex:childview.tag];
                    UIButton *btn = (UIButton *)childview;
                    if ([btn.titleLabel.text isEqualToString:[dic objectForKey:@"FieldName"]]) {
                        [passDic setObject:@"" forKey:[dic objectForKey:@"FieldID"]];
                    }
                    else{
                        if (![[dic objectForKey:@"FieldRequired"] isEqualToString:@"false"]) {
                            if ([btn.titleLabel.text length] > 0) {
                                [passDic setObject:btn.titleLabel.text forKey:[dic objectForKey:@"FieldID"]];
                            }
                            else{
                                [txtField becomeFirstResponder];
                                [BaseApplication showAlertWithTitle:@"CustomCRM" withMessage:[NSString stringWithFormat:@"Select the %@",[dic objectForKey:@"FieldName"]]];
                                
                                return;
                            }
                        }
                        else{
                            [passDic setObject:btn.titleLabel.text forKey:[dic objectForKey:@"FieldID"]];
                        }
                    }
                }
            }
        }
        
        // text view
        if ([subview isKindOfClass:[UITextView class]]) {
            NSDictionary *dic = [allData objectAtIndex:subview.tag];
            txtView = (UITextView *)subview;
            if (![[dic objectForKey:@"FieldRequired"] isEqualToString:@"false"]) {
                if ([txtView.text length] > 0) {
                    [passDic setObject:txtView.text forKey:[dic objectForKey:@"FieldID"]];
                }
                else{
                    [txtField becomeFirstResponder];
                    [BaseApplication showAlertWithTitle:@"CustomCRM" withMessage:[NSString stringWithFormat:@"Please enter the %@",[dic objectForKey:@"FieldName"]]];
                    return;
                }
            }
            else{
                [passDic setObject:txtView.text forKey:[dic objectForKey:@"FieldID"]];
            }
        }
    }
    NSLog(@"Dictiona: %@",passDic);
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:passDic,@"TypeLeadData", nil];
    
//    NSMutableArray *tArray=[[NSMutableArray alloc] initWithArray:@[@{@"logon_id":LOGIN_ID},@{@"pwd":PWD},@{@"company_id":WORKGROUP},@{@"LeadData":@[dict]}]];
    NSMutableArray *tArray=[[NSMutableArray alloc] initWithArray:@[@{@"logon_id":LOGIN_ID},@{@"pwd":PWD},@{@"company_id":@"7639"},@{@"LeadData":@[dict]}]];
    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:ADD_LEAD arrPerameter:tArray withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        if (!rootDoctument)
        {
            //  _tblEvents.hidden = true;
        }
        else
        {
            int flagResult = 0;
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeRECDNO"])
            {
                if([[doc valueWithPath:@"RECDNO"] integerValue]!=0)
                {
                    flagResult = 1;
                }
                else
                {
                    flagResult = 0;
                    
                }
            }
            if(flagResult > 0)
            {
                [BaseApplication showAlertWithTitle:@"CustomCRM" withMessage:@"Successfully add record"];
            }
        }
    }];

}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    txtField = textField;
    if (textField.tag == -1)
    {
        NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
        if ([str length] > 1) {
            if([strRecord isEqualToString:@"addcontact"])
            {
                [self serviceForAccountData:[@(0)stringValue] and:[@(10)stringValue] comp:str];
            }
            //        else if([_lblOptions.text isEqualToString:@"Contacts"])
            //        {
            //            [self serviceForContactData:[@(0)stringValue] and:[@(10)stringValue] lname:str];
            //        }
            //        else if([_lblOptions.text isEqualToString:@"Case"])
            //        {
            //            [self serviceForCaseData:[@(0)stringValue] and:[@(10)stringValue] comp:str];
            //        }
            //        else if([_lblOptions.text isEqualToString:@"Opportunity"])
            //        {
            //            [self serviceForOpportunityData:[@(0)stringValue] and:[@(10)stringValue] comp:str];
            //        }
        }
        else{
            viewSearch.hidden = YES;
        }
    }
    return  YES;
}

-(void)serviceForAccountData:(NSString *)startIndex1 and:(NSString *)endIndex1 comp:(NSString *)company
{
    if(!company)
        company = @"";
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":[[NSUserDefaults standardUserDefaults] objectForKey:WG_ID]},@{@"company":company},@{@"startindex":startIndex1},@{@"endindex":endIndex1}]];
    
    [BaseApplication executeRequestwithService:SEARCHACCDATA arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        if (!rootDoctument)
        {
            //            _tblEvents.hidden = true;
        }
        else
            
        {
            [arrSearch removeAllObjects];
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeLeadData"])
            {
                if([doc valueWithPath:@"Company"])
                    [arrSearch addObject:[doc valueWithPath:@"Company"]];
            }
            if (arrSearch.count > 1) {
                [tblSearch reloadData];
                float height = arrSearch.count * 40;
                if (height > ([UIScreen mainScreen].bounds.size.height - viewSearch.frame.origin.y - 100)) {
                    height = ([UIScreen mainScreen].bounds.size.height - viewSearch.frame.origin.y - 100);
                }
                constSearchViewHeight.constant = height;
                viewSearch.hidden = NO;
            }
            else{
                viewSearch.hidden = YES;
            }
        }
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    flag = YES;
    txtField =textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    flag = NO;
    txtView = textView;
    return YES;
}

#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arrTblData.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [SET_FONTS_REGULAR fontWithSize:16];
    label.text = [[arrTblData objectAtIndex:row] objectForKey:@"Value"];
    label.textAlignment = NSTextAlignmentCenter;
    return label;    
}
/*
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [[arrTblData objectAtIndex:row] objectForKey:@"Value"];
    NSAttributedString *attString =
    [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
}
 
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row            forComponent:(NSInteger)component
{
    return [[arrTblData objectAtIndex:row] objectForKey:@"Value"];
}
*/

#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    [btnSelect setTitle:[[arrTblData objectAtIndex:row] objectForKey:@"Value"] forState:UIControlStateNormal];
}

- (void)viewPickerHidden:(BOOL)flag{
    if (flag) {
        viewPicker.hidden = YES;
    }
    else{
        viewPicker.hidden = NO;
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

- (IBAction)btnPickerDone:(id)sender {
    [btnSelect setTitle:[[arrTblData objectAtIndex:[pickerList selectedRowInComponent:0]] objectForKey:@"Value"] forState:UIControlStateNormal];
    [self viewPickerHidden:YES];
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setFonts_Background
{
    for (int i = 0 ; i < self.viewBG.count; i++) {
        UIView *view = [self.viewBG objectAtIndex:i];
        view.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
    }
    for (int i = 0 ; i < self.lblBG.count; i++) {
        UILabel *lbl = [self.lblBG objectAtIndex:i];
        lbl.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
    }
    for (int i = 0 ; i < self.lable.count; i++) {
        UILabel *lbl = [self.lable objectAtIndex:i];
        lbl.font = SET_FONTS_REGULAR;
    }
    for (int i = 0 ; i < self.btn.count; i++) {
        UIButton *btn = [self.btn objectAtIndex:i];
        btn.titleLabel.font = [SET_FONTS_REGULAR fontWithSize:16];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [txtView resignFirstResponder];
    [txtField resignFirstResponder];
}
@end
