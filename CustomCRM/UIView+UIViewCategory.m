//
//  UIView+UIViewCategory.m
//  iBoks
//
//  Created by NLS42-MAC on 28/06/16.
//  Copyright © 2016 Kalpit Gajera. All rights reserved.
//

#import "UIView+UIViewCategory.h"

@implementation UIView (UIViewCategory)
@dynamic borderColor,borderWidth,cornerRadius,shadowRadius,shadowColor,shadowOffset,shadowOpacity;

-(void)setBorderColor:(UIColor *)borderColor{
    [self.layer setBorderColor:borderColor.CGColor];
    self.layer.masksToBounds=true;
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    [self.layer setBorderWidth:borderWidth];
    self.layer.masksToBounds=true;
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    [self.layer setCornerRadius:cornerRadius];
    self.layer.masksToBounds=true;

}

- (void)setShadowColor:(UIColor *)shadowColor{
    self.layer.masksToBounds = false;
    [self.layer setShadowColor:shadowColor.CGColor];

}

-(void)setShadowRadius:(CGFloat)shadowRadius{
    self.layer.masksToBounds = false;
    [self.layer setShadowRadius:shadowRadius];
//    self.layer.masksToBounds=true;    
}

-(void)setShadowOffset:(CGSize)shadowOffset{
    self.layer.masksToBounds = false;
    [self.layer setShadowOffset:shadowOffset];
//    self.layer.masksToBounds=true;
}

-(void)setShadowOpacity:(CGFloat)shadowOpacity{
    self.layer.masksToBounds = false;
    [self.layer setShadowOpacity:shadowOpacity];
//    self.layer.masksToBounds=true;
}


@end
