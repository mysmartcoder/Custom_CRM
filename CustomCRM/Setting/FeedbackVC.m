//
//  FeedbackVC.m
//  CustomCRM
//
//  Created by Pinal Panchani on 10/12/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import "FeedbackVC.h"

@interface FeedbackVC (){
    NSString *feedbackType;
    NSString *ratingStar;
}

@end

@implementation FeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self setFonts_Background];
    ratingStar = @"0";
    feedbackType = @"Bug";
    txtViewDesc.text = @"Description";
    [txtViewDesc setTextColor:[UIColor lightGrayColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([txtViewDesc.text isEqualToString:@"Description"]) {
        textView.text = @"";
    }
    textView.textColor = [UIColor blackColor];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length > 0) {
        txtViewDesc.textColor = [UIColor blackColor];
    }
    else{
        txtViewDesc.text=@"Description";
        txtViewDesc.textColor = [UIColor lightGrayColor];
    }
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
//    if ([MFMailComposeViewController canSendMail]) {
//        NSString *emailTitle = txtTitle.text;//[NSString stringWithFormat:@"Feedback Type : %@",feedbackType];
//        // Email Content
//        NSString *messageBody = [NSString stringWithFormat:@"Feedback Type: %@ \n\n Description: %@ \n\n Rate our Work : %@",feedbackType,txtViewDesc.text,ratingStar];
//        // To address
//        NSArray *toRecipents = [NSArray arrayWithObject:MailID];
//        
//        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
//        mc.mailComposeDelegate = self;
//        [mc setSubject:emailTitle];
//        [mc setMessageBody:messageBody isHTML:NO];
//        [mc setToRecipients:toRecipents];
//        
//        // Present mail view controller on screen
//        [self presentViewController:mc animated:YES completion:NULL];
//    }
}

- (IBAction)btnOptionBug:(id)sender {
    imgBug.image = [UIImage imageNamed:@"radio_off"];
    imgFeature.image = [UIImage imageNamed:@"radio_off"];
    imgOther.image = [UIImage imageNamed:@"radio_off"];
    if ([sender tag] == 0) {
        imgBug.image = [UIImage imageNamed:@"radio_on"];
        feedbackType = @"Bug";
    }
    else if ([sender tag] == 1) {
        imgFeature.image = [UIImage imageNamed:@"radio_on"];
        feedbackType = @"Feature";
    }
    else{
        imgOther.image = [UIImage imageNamed:@"radio_on"];
        feedbackType = @"Other";
    }
}

- (IBAction)btnFeedback:(id)sender {
    if ([txtTitle.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please, Enter the title." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([txtViewDesc.text isEqualToString:@""] || [txtViewDesc.text isEqualToString:@"Description"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please, Enter the description." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        if ([MFMailComposeViewController canSendMail]) {
            NSString *emailTitle = txtTitle.text;//[NSString stringWithFormat:@"Feedback Type : %@",feedbackType];
            // Email Content
            NSString *messageBody = [NSString stringWithFormat:@"Feedback Type: %@ \n\n Description: %@ \n\n Rate our Work : %@",feedbackType,txtViewDesc.text,ratingStar];
            // To address
            NSArray *toRecipents = [NSArray arrayWithObject:MailID];
            
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
            mc.mailComposeDelegate = self;
            [mc setSubject:emailTitle];
            [mc setMessageBody:messageBody isHTML:NO];
            [mc setToRecipients:toRecipents];
            
            // Present mail view controller on screen
            [self presentViewController:mc animated:YES completion:NULL];
        }
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [txtTitle resignFirstResponder];
    [txtViewDesc resignFirstResponder];
}

-(void)setFonts_Background
{
    for (int i = 0 ; i < self.btn.count; i++) {
        UIButton *btn = [self.btn objectAtIndex:i];
        btn.titleLabel.font = SET_FONTS_BUTTON;
    }
    for (int i = 0 ; i < self.lable.count; i++) {
        UILabel *lbl = [self.lable objectAtIndex:i];
        lbl.font = SET_FONTS_REGULAR;
    }
    for (int i = 0 ; i < self.viewBG.count; i++) {
        UIView *view = [self.viewBG objectAtIndex:i];
        view.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
    }
}

- (IBAction)btnRate:(HCSStarRatingView *)sender {
    ratingStar = [NSString stringWithFormat:@"%f", sender.value];
}
@end
