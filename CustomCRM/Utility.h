//
//  Utility.h
//  Kinderopvang
//
//  Created by NLS17 on 18/07/14.
//  Copyright (c) 2014 NexusLinkServices. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Static.h"
#import <UIKit/UIKit.h>


@interface Utility : NSObject

+(UIColor*)colorWithHexString:(NSString*)hex;
+(NSArray *)colorWithRGB:(NSString*)hex;
@end
