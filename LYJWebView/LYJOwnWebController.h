//
//  LYJOwnWebController.h
//  YWManage
//
//  Created by 娇 on 2019/2/26.
//  Copyright © 2019年 yunli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LYJWebViewType) {
    LYJWebViewTypeKZ = 0,//壳子
    LYJWebViewTypeZDGJ = 1//账单管家
};

@interface LYJOwnWebController : UIViewController

@property (nonatomic, copy) NSString* color;
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* umeng_key;
@property (nonatomic, copy) NSString* yw_sjmh_key;
@property (nonatomic, copy) NSString* yw_sjmh_code;
@property (nonatomic, copy) NSString* yw_face_key;
@property (nonatomic, copy) NSString* yw_face_secret;

@property (nonatomic, assign) BOOL useCustomNav;
@property (nonatomic, copy) NSString* titleStr;
@property (nonatomic, copy) NSString* titleColor;
@property (nonatomic, strong) UIView* navView;

@property (nonatomic, assign) BOOL toRootVC;
@property (nonatomic, assign) BOOL hiddenBack;
@property (nonatomic, assign) LYJWebViewType type;
@property (nonatomic, assign) BOOL isNewVersion;
@property (nonatomic, assign) BOOL useWebTitle;

@property (nonatomic, strong) WKWebView* webView;

+ (void)modificationUA:(NSString*)currentUserAgent;

- (instancetype)initWithUrl:(NSString*)url;
- (void)setBackImg:(UIImage*)backImg closeImg:(UIImage*)closeImg shareImg:(UIImage*)shareImg;

- (void)finishLoad;
- (void)popOutController;
- (void)jumpToLogin;
- (void)webNav:(NSDictionary*)dic;

@end

NS_ASSUME_NONNULL_END
