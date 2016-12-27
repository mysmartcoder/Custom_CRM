//
//  BaseApplication.h
//  CustomCRM
//
//  Created by Pinal Panchani on 13/09/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BaseApplication : NSObject 

+(void)executeRequestwithService:(NSString *)service arrPerameter:(NSArray *)tArray withBlock:(void (^)(NSData *dictresponce,NSError *error))block;
+(NSString *)getEncryptedKey;
+(void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)message;
+(CLLocationCoordinate2D) getLocationFromAddressString:(NSString*) addressStr;

@end
