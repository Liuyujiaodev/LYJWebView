//
//  YLWebController.m
//  YLClient
//
//  Created by 刘玉娇 on 2018/11/14.
//  Copyright © 2018年 yunli. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

#pragma mark - 生命周期

#define kFACE_API_KEY    @"ERBerfwi9xq1DTeOotOjZlYMVscSN9i4"
#define kFACE_API_SECRET @"v9vr4l2MHPQ9ONMPL9Zur98iPZlf_E67"

-(instancetype)initWithUrl:(NSString *)url {
    //Todo 需要删除
//    url = @"https://ylxd.yunlibeauty.com/saas/apply/home?productId=2287&channelId=1380&cid=1116";
    url =  [[NSBundle mainBundle] pathForResource:@"scan" ofType:@"html"];
    if (self = [super initWithUrl:url]) {
        self.type = LYJWebViewTypeKZ;
        self.yw_sjmh_key = @"1b2007c8ae0d490e9e2f089a1195adf2";
        self.yw_sjmh_code = @"yunbeifq_mohe";
//        self.yw_baidu_key = [YLCompanySettingUtil getBaiduMap];
        self.yw_face_key = kFACE_API_KEY;
        self.yw_face_secret = kFACE_API_SECRET;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [SVProgressHUD showWithStatus:@"数据加载中，请稍后..."];
    
    self.titleColor = @"0xffffff";
    self.color = @"0xF46C28";
    self.useCustomNav = NO;
//    self.titleStr = APP_Name;
//    [self setBackImg:[UIImage imageNamed:@"nav_back"] closeImg:[UIImage imageNamed:@"close_white"] shareImg:[UIImage imageNamed:@""]];
}

@end
