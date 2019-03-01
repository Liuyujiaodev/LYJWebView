//
//  NSString+Base.h
//  YiMeiBusiness
//
//  Created by 刘玉娇 on 15/12/8.
//  Copyright © 2015年 Xiaolinxiaoli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface NSString (Base)

/**
 *  判断是否为空字符串
 *
 *  @return YES(空字符串) NO(非空字符串)
 */
-(BOOL)isEmptyStr;

- (NSString*)stringAddStr:str;

/**
 *  截取字符串
 *
 *  @param startStr(从哪个字符开始) endString(到哪个字符结束)
 *  @return YES(空字符串) NO(非空字符串)
 */
-(NSString*)getStrFromString:(NSString*)startStr toString:(NSString*)endString;

- (CGSize)sizeWithFont:(UIFont *)font andSize:(CGSize)size;

- (CGSize)sizeWithFont:(UIFont *)font;
@end
