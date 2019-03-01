//
//  UIButton+Base.m
//  XMShop
//
//  Created by 刘玉娇 on 16/3/4.
//  Copyright © 2016年 刘玉娇. All rights reserved.
//

#import "UIButton+Base.h"

@implementation UIButton (Base)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[self getImage:backgroundColor] forState:state];
}

- (UIImage *)getImage:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
