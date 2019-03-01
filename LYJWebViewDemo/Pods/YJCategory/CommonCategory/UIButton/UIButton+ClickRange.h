//
//  UIButton+ClickRange.h
//  lineroad
//
//  Created by gagakj on 2017/11/29.
//  Copyright © 2017年 田宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ClickRange)

//@property(nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

- (void)setEnlargeEdge:(CGFloat) size;

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;


@end
