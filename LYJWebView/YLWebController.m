//
//  YLWebController.m
//  YLClient
//
//  Created by 刘玉娇 on 2018/11/14.
//  Copyright © 2018年 yunli. All rights reserved.
//

#import "YLWebController.h"

#define kUSER_AGENT    @"rxzny_ios_rxzny_"
@implementation YLWebController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.type = LYJWebViewTypeZDGJ;
    self.color = @"0xF46C28";
    self.userAgent = [[kUSER_AGENT stringByAppendingString:@"2.6.0"] stringByAppendingString:@"_version"];
    self.useCustomNav = YES;
    [self setBackImg:[UIImage imageNamed:@"nav_back"] closeImg:[UIImage imageNamed:@"close_white"] shareImg:[UIImage imageNamed:@""]];
    self.titleColor = @"0xffffff";
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest: (NSURLRequest *)request navigationType: (UIWebViewNavigationType)navigationType {//webview是否加载链接
    //拦截加载的链接
    NSString *currentUrl = [NSString stringWithFormat:@"%@",request.URL.absoluteString];
    /* 包含对应APP协议链接的string，拦截，在主线程打开对应APP，如果没有就放过 */
    if (([currentUrl containsString:@"://"])&&(![currentUrl containsString: @"https://"])&&(![currentUrl containsString:@"http://"]))
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[[UIDevice currentDevice] systemVersion] integerValue]>=10) {
                //iOS系统版本大于10
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:currentUrl] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:^(BOOL success) {
                    if (success) { NSLog(@"打开了");
                    }else{ NSLog(@"没打开,无法跳转到APP，请检查是否安装了对应的APP");
                    } }];
            }
            else
            {
                BOOL isOpen = NO;
                isOpen = [[UIApplication sharedApplication]openURL:[NSURL URLWithString:currentUrl]]; if (isOpen) {
                    NSLog(@"打开了"); }else{
                        NSLog(@"没打开,无法跳转到APP，请检查是否安装了对应的APP"); }
            } });
        return NO; }
    return YES;
}


////允许跳转 decisionHandler(WKNavigationActionPolicyAllow);
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    AppJSObject *jsObject = [AppJSObject new];
//    jsObject.delegate = self;
//    context[@"app"] = jsObject;
//    context[@"appConfig"] = [Util getJsonWith:[CommonUtil Commondata]];
//
//}

//- (void)startSJMHTaobao {
//    DLog(@"================");
//    SJMagicBox *box = [SJMagicBox shared];
//    [box initWithPartnerCode:@"yunbeifq_mohe" andPartnerKey:@"1b2007c8ae0d490e9e2f089a1195adf2"];
//    
//    PBBaseReq *br = [PBBaseReq new];
//    br.channel_code=SJMH_CODE;//
////    br.channel_type = SJMH_KEY;//合作方key
//    br.channel_code = @"005003";//客户端渠道码，例如京东是 005011
//    PBBaseSet *set = [PBBaseSet new];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [shujumohePB openPBPluginAtViewController:self withDelegate:self withReq:br withBaseSet:set];
//    });
//    DLog(@"================1");
//}
//
//- (void)popController {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)thePBMissionWithCode:(NSString *)code withMessage:(NSString *)message {
//    
//    if (code.integerValue == 0) {
//        NSMutableDictionary* params = [NSMutableDictionary dictionary];
//        [params setObject:message forKey:@"taskId"];
//        [params setObject:[YLUserDataManager getCuid] forKey:@"cuid"];
//        [params setObject:[NSNumber numberWithInteger:1] forKey:@"type"];
//        if (self.applyId) {
//            [params setObject:self.applyId forKey:@"applyId"];
//        }
//        [[YLHttpRequest sharedInstance] sendRequest:YL_API_UPLOAD_SJMH_DATA params:params success:^(NSDictionary *dic) {
//            JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//            NSString *alertJS= [NSString stringWithFormat:@"%@(%@)", @"webJS.reload", @"1"];//准备执行的js代码
//            [context evaluateScript:alertJS];
//        } requestFailure:^(NSDictionary *dic) {
//            JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//            NSString *alertJS= [NSString stringWithFormat:@"%@(%@)", @"webJS.reload", @"1"];//准备执行的js代码
//            [context evaluateScript:alertJS];
//            [Util showAlertView:self title:nil message:[dic stringWithKey:@"msg"] okAction:nil cancelAction:@"我知道了" okHandler:nil cancelHandler:nil];
//        } failure:^(NSError *error) {
//            JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//            NSString *alertJS= [NSString stringWithFormat:@"%@(%@)", @"webJS.reload", @"1"];//准备执行的js代码
//            [context evaluateScript:alertJS];
//            [Util showAlertView:self title:nil message:@"网络错误" okAction:nil cancelAction:@"我知道了" okHandler:nil cancelHandler:nil];
//
//        }];
//        //成功
//    } else if (code.integerValue == 1) {
//        JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//        NSString *alertJS= [NSString stringWithFormat:@"%@(%@)", @"webJS.reload", @"1"];//准备执行的js代码
//        [context evaluateScript:alertJS];
//        [SVProgressHUD showErrorWithStatus:@"授权失败"];
//        //失败
//    } else {
//        JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//        NSString *alertJS= [NSString stringWithFormat:@"%@(%@)", @"webJS.reload", @"1"];//准备执行的js代码
//        [context evaluateScript:alertJS];
//        [SVProgressHUD showErrorWithStatus:@"授权失败"];
//    }
//}

@end
