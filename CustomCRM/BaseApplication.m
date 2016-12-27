//
//  BaseApplication.m
//  CustomCRM
//
//  Created by Pinal Panchani on 13/09/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import "BaseApplication.h"
#import "AppDelegate.h"
#import "Static.h"
#import "XMLReader.h"
#import "SMXMLDocument.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@implementation BaseApplication


+ (void)executeRequestwithUrl:(NSString *)urlStr  withBlock:(void (^)(NSMutableDictionary *dictresponce,NSError *error))block {
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSError *error1;
                               if(data==nil){
                                   STOPLOADING()
                                   // NSLog(@"Error Responce : %@",error);
                                   block(nil,error);
                               }else{
                                   
                                   NSMutableDictionary * innerJson = [NSJSONSerialization                                                JSONObjectWithData:data options:kNilOptions error:&error1];
                                   block(innerJson,error); // Call back the block passed into your method
                               }
                           }];
    
}


+(void)executeRequestwithService:(NSString *)service arrPerameter:(NSArray *)tArray withBlock:(void (^)(NSData *, NSError *))block
{
       
    //@"chirag.aspdeveloper@gmail.com"
    //@"testchirag"
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,service];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    //set headers
    NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //create the body
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                           "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<soap:Body>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<%@ xmlns=\"LMServiceNamespace\">",service] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postBody appendData:[[NSString stringWithFormat:@"<%@Result\">",service] dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (NSDictionary *tmpDictionary in tArray) {
        
        NSString *keyFld=[NSString stringWithFormat:@"%@",[[tmpDictionary allKeys] firstObject]];
        if([[tmpDictionary objectForKey:keyFld] isKindOfClass:[NSArray class]]){
            //Is array
            NSString *fulldata = @"";
            for (NSDictionary *tmpSubDictionary in [tmpDictionary objectForKey:keyFld]) {
                NSString *keyFld1=[NSString stringWithFormat:@"%@",[[tmpSubDictionary allKeys] firstObject]];
                NSArray *arr = [[tmpSubDictionary objectForKey:keyFld1] allKeys];
                NSString *data = @"";
                for (int i = 0; i < arr.count; i++) {
                    data = [NSString stringWithFormat:@"%@<%@>%@</%@>",data,[arr objectAtIndex:i],[[tmpSubDictionary objectForKey:keyFld1] objectForKey:[arr objectAtIndex:i]],[arr objectAtIndex:i]];
                }
                fulldata = [NSString stringWithFormat:@"%@<%@>%@</%@>",fulldata,keyFld1,data,keyFld1];
            }
            [postBody appendData:[[NSString stringWithFormat:@"<%@>%@</%@>",keyFld,fulldata,keyFld] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else{
            NSString *valueFld=[NSString stringWithFormat:@"%@",[[tmpDictionary allValues] firstObject]];
            [postBody appendData:[[NSString stringWithFormat:@"<%@>%@</%@>",keyFld,valueFld,keyFld] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    
    [postBody appendData:[[NSString stringWithFormat:@"</%@>",service] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postBody appendData:[[NSString stringWithFormat:@"</%@Result>",service] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</soap:Body>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</soap:Envelope>"] dataUsingEncoding:NSUTF8StringEncoding]];
    
//    NSString *strBody = [[NSString alloc]initWithData:postBody encoding:NSUTF8StringEncoding];
    
    //post
    [request setHTTPBody:postBody];
    
    //get response
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//                               NSError *error1;
                               if(data==nil)
                               {
                                   NSLog(@"Error Responce : %@",error);
                                   block(nil,error);
                               }
                               else
                               {
//                                   NSString *strBody = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

                                    STOPLOADING()
                                   block(data,error); // Call back the block passed into your method
                               }
                           }];
    
//    NSHTTPURLResponse* urlResponse = nil;
//    NSError *error = [[NSError alloc] init];
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
//    NSLog(@"BaseApplication: %@",responseData);
}

+(NSString *)getEncryptedKey
{
    NSData *userNameData = [UID dataUsingEncoding:NSUTF8StringEncoding];
    NSString *unameEncode = [userNameData base64EncodedStringWithOptions:0];
    
    NSData *pwdData = [PWD dataUsingEncoding:NSUTF8StringEncoding];
    NSString *pwdEncode = [pwdData base64EncodedStringWithOptions:0];
    
    NSData *dbIDData = [[[NSUserDefaults standardUserDefaults]objectForKey:@"DatabaseID"]
                        dataUsingEncoding:NSUTF8StringEncoding];
    NSString *dbIDEncode = [dbIDData base64EncodedStringWithOptions:0];
    
    NSData *wgIDData = [[[NSUserDefaults standardUserDefaults]objectForKey:WG_ID]dataUsingEncoding:NSUTF8StringEncoding];
    NSString *wgIDEncode = [wgIDData base64EncodedStringWithOptions:0];
    
    NSString *str = [NSString stringWithFormat:@"%@^%@^%@^%@",unameEncode,pwdEncode,wgIDEncode,dbIDEncode];
    NSString *strKey = [str stringByReplacingOccurrencesOfString:@"==" withString:@"@"];
    NSString *strFinal = [strKey stringByReplacingOccurrencesOfString:@"=" withString:@"$"];
    
    return strFinal;
    
}


+(void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)message
{
    [[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
}



+(CLLocationCoordinate2D) getLocationFromAddressString:(NSString*) addressStr {
    
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
    
}

@end
