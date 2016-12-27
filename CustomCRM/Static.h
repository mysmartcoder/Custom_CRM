//
//  Static.h
//  CustomCRM
//
//  Created by Pinal Panchani on 13/09/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#ifndef Static_h
#define Static_h

#define BACKCOLOR [UIColor colorWithRed:0.035 green:0.275 blue:0.604 alpha:1.000]

#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

//Fonts
#define FONT_Size_Header 22.0f
#define FONT_BOLD [[NSUserDefaults standardUserDefaults] valueForKey:@"font_bold"]
#define FONT_REGULAR [[NSUserDefaults standardUserDefaults] valueForKey:@"font"]
#define FONT_Size_LABEL 17.0f
#define FONT_Size_BBUTTON 18.0f
#define FONT_Size_BIG 20.0f
#define SET_FONTS_BIG [UIFont fontWithName:FONT_BOLD size:FONT_Size_BIG]
#define SET_FONTS_REGULAR [UIFont fontWithName:FONT_REGULAR size:FONT_Size_LABEL]
#define SET_FONTS_BOLD [UIFont fontWithName:FONT_BOLD size:FONT_Size_LABEL]
#define SET_FONTS_BUTTON [UIFont fontWithName:FONT_REGULAR size:FONT_Size_BBUTTON]
#define FONT_LABEL [[NSUserDefaults standardUserDefaults] valueForKey:key_Font_Llb]

// Background Color
#define VIEW_BACKGROUND [[NSUserDefaults standardUserDefaults] valueForKey:key_View_BG]


// Dynamic Title
#define setHeaderTitle @"HeaderTitle"
#define getHeaderTitle [[NSUserDefaults standardUserDefaults] valueForKey:setHeaderTitle];

//Screen size
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width

//URL
//#define WEBSERVICE_URL @"http://api.CustomCRM.com/lmservice/lmservice_mobile.asmx?"
#define WEBSERVICE_URL @"http://api.CustomCRM.com/lmservice/lmservice_mobile_beta.asmx?"
//#define MAIN_URL @"{Dev_URL}"
#define MAIN_URL [[NSUserDefaults standardUserDefaults] valueForKey:key_Main_URL]


// Feedback Mail id:
//#define MailID @"jignesh.qa@CustomCRM.com"
#define MailID @"andy.brownell@CustomCRM.com"
//Apis



#define LOGIN @"APIValidateLogonData"
#define GETDB @"GetDatabase"
#define GETWGROUP @"GetWorkgroups"
#define GETACTIVITY @"GetRecordActivityData"
#define TODAYEVENTS @"TodaysCallBackEvent"
#define LOGONPRIV @"GetLogonPrivileges"
#define GETCUSTLABELS @"GetCustomLabel"
#define SEARCHACCDATA @"SearchAccountData"
#define SEARCHACCOUNT_COUNT @"SearchAccountCount"
#define SEARCHSHORTCUT_COUNT @"GetSavedSearchDataCount"
#define SEARCHSHORTCUTDATA @"GetSavedSearchData"
#define DELETE_RECORD @"DeleteRecord"
#define DELETE_RECORDS @"DeleteRecords"
#define DELETE_CASE @"DeleteCase"
#define CASE_COUNT @"SearchCasesCount"
#define CONTACT_COUNT @"SearchContactCount"
#define OPP_COUNT @"SearchOpportunityCount"
#define QUOTE_COUNT @"SearchQuoteCount"
#define SEARCH_CONTACT_DATA @"SearchContactData"
#define RECENT_ITEMS @"RecentItems"
#define SEARCHCASEDATA @"SearchCasesData"
#define CHANGE_PASSWORD @"ChangePassword"
#define ADD_LEAD @"AddLead"

////////// Add New Record
#define GET_MOBILE_INSERT_DATA_FIELDS @"GetMobileInsertDataFields"
#define GET_REFERENCE_TABLEDATA @"GetReferenceTableData"

#define SEARCH_OPPORTUNITY_DATA @"SearchOpportunityData"
#define DELETE_OPP @"DeleteOpp"
#define CALLBACK_COUNT @"SearchCallBackCount"
#define SEARCH_CALLBACK_DATA @"SearchCallBackEvent"
#define GET_GROUP_CALENDAR_USER_DETAIL @"GetGroupCalendarUserDetail"
#define GET_GROUP_CALENDAR_CALL_BACK_EVENT @"GetGroupCalendarCallBackEvent"
#define DELETE_CALLBACK @"DeleteCallBacks"
#define QUICK_SEARCH @"SearchLeadData"
#define MATCH_COUNT @"CheckForMatchCount"
#define MATCH_DATA @"CheckForMatch"
#define GET_GEOLOCATION @"GetGeoLocation"
#define OPEN_CLOSE_CALLBACK @"LMUpdateCallBackEvents"
#define SEARCH_QUOTE_DATA @"SearchQuoteData"
#define DELETE_QUOTES @"DeleteQuotes"
#define MY_SEARCH @"MySearches"
#define MY_SHORTCUT @"MyShortcut"
#define DOWNLOAD_LIBRARY_LIST @"GetLibraryDownloadQueueFileList"
#define DOWNLOAD_LIBRARY_FILE_STATUS @"LibraryDownloadQueueStatusChange"

//Key
//#define LOGIN_ID @"loginID"
#define DB_ID @"DatabaseID"
#define WG_ID @"WorkgroupID"
#define WG_NAME @"WorkgroupName"
#define Key_LoginStatus @"LoginStatus"
#define Key_PASSWORD @"Password"
#define Key_UserID @"UserId"
#define Key_Acc_count @"Acc_Count"
#define Key_Short_count @"Short_Count"
#define Key_callback_count @"callback_Count"
#define key_Notification @"RemoveWebview"
#define key_DPage @"DefaultPage"
#define key_ISO_CODE @"ISO_CODE"
#define key_LOGIN_ID @"Logon"
#define key_Main_URL @"MainURL"
#define key_Font_Llb @"Font_Label"
#define key_View_BG @"viewBG"

//User
#define LOGIN_ID [[NSUserDefaults standardUserDefaults] valueForKey:key_LOGIN_ID]
#define USERNAME [[NSUserDefaults standardUserDefaults] valueForKey:@"username"]
#define PWD [[NSUserDefaults standardUserDefaults] valueForKey:Key_PASSWORD]
#define UID [[NSUserDefaults standardUserDefaults] valueForKey:Key_UserID]
#define LoginStatus [[NSUserDefaults standardUserDefaults] valueForKey:Key_LoginStatus]

#define DATABASE [[NSUserDefaults standardUserDefaults] valueForKey:DB_ID]
#define WORKGROUP [[NSUserDefaults standardUserDefaults] valueForKey:WG_ID]
#define DPAGE [[NSUserDefaults standardUserDefaults] valueForKey:key_DPage]
#define ICODE [[NSUserDefaults standardUserDefaults] valueForKey:key_ISO_CODE]




#define ACC_COUNT [[[NSUserDefaults standardUserDefaults] valueForKey:Key_Acc_count]intValue]
#endif
