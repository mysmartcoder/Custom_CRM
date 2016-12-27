//
//  UIView+UIViewCategory.h
//  iBoks
//
//  Created by NLS42-MAC on 28/06/16.
//  Copyright © 2016 Kalpit Gajera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIViewCategory)
@property (nonatomic) IBInspectable UIColor *borderColor;

@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable UIColor *shadowColor;
@property (nonatomic) IBInspectable CGFloat shadowRadius;
@property (nonatomic) IBInspectable CGFloat shadowOpacity;
@property (nonatomic) IBInspectable CGSize shadowOffset;


@end
