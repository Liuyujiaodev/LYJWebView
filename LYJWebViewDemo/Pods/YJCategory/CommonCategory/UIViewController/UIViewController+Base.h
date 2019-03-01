//
//  UIViewController+Base.h
//  YLClient
//
//  Created by 刘玉娇 on 2018/11/7.
//  Copyright © 2018年 yunli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Base)

- (void)pushToVC:(NSString*)vc withParamters:(nullable NSDictionary*)params;

- (void)pushToVC:(NSString*)vc;

@end

NS_ASSUME_NONNULL_END
