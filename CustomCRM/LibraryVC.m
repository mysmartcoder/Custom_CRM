//
//  LibraryVC.m
//  CustomCRM
//
//  Created by NLS44-PC on 11/3/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import "LibraryVC.h"
#import "SlideNavigationController.h"
#import "AppDelegate.h"
#import "BaseApplication.h"
#import "SMXMLDocument.h"
#import "CustomIOSAlertView.h"
#import "Static.h"
#import "UIView+Toast.h"
#import <MessageUI/MessageUI.h>

@implementation LibraryCell

@end

@interface LibraryVC (){
    NSMutableArray *arrFileId,*arrFileName,*arrFilePath,*arrFile,*arrBoolValue;
    BOOL isWeb,isTableview;
}

@end

@implementation LibraryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    isTableview = false;
}

- (void)viewWillAppear:(BOOL)animated{
    if (isTableview) {
        self.viewLibraryDetail.hidden = NO;
        self.viewLibrary.hidden = YES;
        _tblLibraryData.hidden=NO;
        _webview.hidden = YES;
    }
    else
    {
        self.viewLibraryDetail.hidden = YES;
        self.viewLibrary.hidden = NO;
        
    }
    isWeb = true;
    [self setFonts_Background];
}

//call for wepage redirection

-(void)callService{
    SHOWLOADING(@"Please wait...")
    NSString *urlString = [NSString stringWithFormat:
                           @"%@/mobile_auth.asp?key=%@&topage=LibraryV2/mobile_FileList.asp" ,MAIN_URL,[BaseApplication getEncryptedKey]];
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:webStringURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [self.webview loadRequest:urlRequest];
    
}

//call for download library files list

-(void)callForDownloadFiles
{
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"logon_id":LOGIN_ID},@{@"companyid":WORKGROUP}]];
    SHOWLOADING(@"Wait...")
    _tblLibraryData.hidden = true;
    [BaseApplication executeRequestwithService:DOWNLOAD_LIBRARY_LIST arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        
        arrFileId = [[NSMutableArray alloc]init];
        arrFileName = [[NSMutableArray alloc]init];
        arrFilePath = [[NSMutableArray alloc]init];
        arrFile = [[NSMutableArray alloc]init];
        arrBoolValue = [[NSMutableArray alloc]init];
        
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        if (!rootDoctument)
        {
//            _tblLibraryData.hidden = true;
        }
        else
        {
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeLibraryDocument"])
            {
                _tblLibraryData.hidden = false;
                if([doc valueWithPath:@"FileID"])
                {
                    if (![[doc valueWithPath:@"FileID"] isEqualToString:@"0"]) {
                        [arrFileId addObject:[doc valueWithPath:@"FileID"]];
                    }
                }
                
                if([doc valueWithPath:@"FileName"])
                {
                    [arrFileName addObject:[doc valueWithPath:@"FileName"]];
               
                    NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                    NSString* filepath = [documentsPath stringByAppendingPathComponent:[doc valueWithPath:@"FileName"]];
                    
                    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filepath];

                    if(fileExists)
                    {
                        [arrFile addObject:@"true.png"];
                        [arrBoolValue addObject:@"yes"];
                    }
                    else
                    {
                        [arrBoolValue addObject:@"no"];
                        [arrFile addObject:@"downloadblack.png"];
                    }
                
                }
                if([doc valueWithPath:@"FilePath"])
                    [arrFilePath addObject:[doc valueWithPath:@"FilePath"]];
                            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [_tblLibraryData reloadData];
                STOPLOADING();
            });
            
        }
        
    }];
 
}

//call when tap on download button or didselect
-(void)callToSaveFiles:(int)index
{
    SHOWLOADING(@"downloading..")
    NSString* stringURL = [NSString stringWithFormat:@"http://files.crmtool.net/LibraryV2/LibraryDownloadQueue%@", [arrFilePath objectAtIndex:index]];
    NSString* webStringURL = [stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:webStringURL];
    NSString* value = [arrBoolValue objectAtIndex:index];
    if ([value isEqualToString:@"yes"]) {
        
       [[UIApplication sharedApplication] openURL:url];
        
    } else {
        
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        if ( urlData )
        {
            NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            NSString *fileName= [arrFileName objectAtIndex:index];//[NSString stringWithFormat:@"WorkOrder_%@.doc",@"1"];
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,fileName];
            NSLog(@"%@", filePath);
            [urlData writeToFile:filePath atomically:YES];
            
            STOPLOADING()
         
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                
                [self callForDownloadFiles];
                
            });

        }
    }
    STOPLOADING()
    
}

//call for download file status change

-(void)callForStatusChange:(NSString *)fileId
{
    isTableview = true;
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"file_id":fileId}]];
    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:DOWNLOAD_LIBRARY_FILE_STATUS arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        
        SMXMLElement *rootDoctument = [document firstChild];
            
            if (!rootDoctument)
            {
                //            _tblEvents.hidden = true;
            }
            else
            {
                for (SMXMLElement *doc in [rootDoctument childrenNamed:@"LibraryDownloadQueueStatusChangeResponse"])
                {
                    if([doc valueWithPath:@"LibraryDownloadQueueStatusChangeResult"])
                    {
                    }
                }
            }
         STOPLOADING();
    }];

 }

//Call for send mail

-(void)callForMail:(UIButton *)btn
{
    NSString *emailTitle = @"CustomCRM";
    // Email Content
    
    
    NSString *messageBody = [NSString stringWithFormat:@"File download link : \n" "http://files.crmtool.net/LibraryV2/LibraryDownloadQueue%@",btn.accessibilityLabel]; // Change the message body to HTML
    // To address
    NSArray *toRecipents = [[NSArray alloc]init];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail])
    {
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:YES];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }
    
}

-(void)callToDownload:(UIButton *)btn
{
     [self callToSaveFiles:(int)btn.tag];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [self.view makeToast:@"Mail Cancelled"
                        duration:3.0
                        position:CSToastPositionCenter];
            break;
        case MFMailComposeResultSaved:
            [self.view makeToast:@"Mail Saved"
                        duration:3.0
                        position:CSToastPositionCenter];;
            break;
        case MFMailComposeResultSent:
            [self.view makeToast:@"Mail sent sucessfully"
                        duration:3.0
                        position:CSToastPositionCenter];
            break;
        case MFMailComposeResultFailed:
            [self.view makeToast:@"Mail sent Failer"
                        duration:3.0
                        position:CSToastPositionCenter];
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
//    SHOWLOADING(@"Wait...");
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    self.viewLibrary.hidden = YES;
    self.viewLibraryDetail.hidden = NO;
    self.webview.hidden = NO;
    self.tblLibraryData.hidden = YES;
    STOPLOADING();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Tableview Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  arrFileId.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LibraryCell *cell = (LibraryCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell==nil)
    {
        cell = [[LibraryCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lblItem.text = [arrFileName objectAtIndex:indexPath.row];
    
    //Email button
    cell.btnDownload.accessibilityLabel = [arrFilePath objectAtIndex:indexPath.row];
    [cell.btnDownload addTarget:self action:@selector(callForMail:) forControlEvents:UIControlEventTouchUpInside];
    

   
    //Download button
    [cell.btndownload setImage:[UIImage imageNamed:[arrFile objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
    [cell.btndownload setTitle:@"" forState:UIControlStateNormal];
    cell.btndownload.tag = indexPath.row;
    [cell.btndownload addTarget:self action:@selector(callToDownload:) forControlEvents:UIControlEventTouchUpInside];
    cell.lblItem.font = SET_FONTS_REGULAR;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    "http://files.crmtool.net/LibraryV2/LibraryDownloadQueue" + FilePath;
    [self callToSaveFiles:(int)indexPath.row];
   
}



- (IBAction)slideMenu:(id)sender {
    
    if (isWeb)
    {
        [[SlideNavigationController sharedInstance]toggleLeftMenu];
        
    }
    else
    {
        self.viewLibrary.hidden = NO;
        self.viewLibraryDetail.hidden = YES;
        isWeb = true;
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
}

- (IBAction)btnLibrary:(id)sender {
    if (isWeb) {
                [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
            } else {
                [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
            }
            isWeb = false;
    _webview.hidden = NO;
    
    [self callService];
}

- (IBAction)btnLibraryDown:(id)sender {
    
    self.viewLibrary.hidden = YES;
    self.viewLibraryDetail.hidden = NO;
    self.tblLibraryData.hidden = NO;
    self.webview.hidden = YES;
    [self callForDownloadFiles];
//    _lblTitle.text = @"Library Files";
    
}

- (IBAction)historyTapped:(id)sender {
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
        btn.titleLabel.font = SET_FONTS_REGULAR;
    }
}

@end
