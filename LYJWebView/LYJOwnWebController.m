//
//  YWSignController.m
//  YWManage
//
//  Created by 刘玉娇 on 2018/11/30.
//  Copyright © 2018年 yunli. All rights reserved.
//

#import "LYJOwnWebController.h"
#import "shujumohePB.h"
#import "DemoMGFaceIDNetwork.h"
#import <MGFaceIDLiveDetect/MGFaceIDLiveDetect.h>
#import <UserNotifications/UserNotifications.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/PHPhotoLibrary.h>
//#import <HealthKit/HealthKit.h>
//#import "HealthKitManage.h"
#import <CoreMotion/CoreMotion.h>
#import "Common.h"
#import "YWAuthUtil.h"
#import <CoreLocation/CoreLocation.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import "CommonCategory.h"
#import "SVGKImage.h"
#import "Util.h"
#import "UMMobClick/MobClick.h"
#import "CommonUtil.h"

@interface LYJOwnWebController () <shujumoheDelegate, WKUIDelegate, WKNavigationDelegate, CLLocationManagerDelegate, BMKLocationManagerDelegate, WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView* webView;
@property (nonatomic, strong) UIView* settingView;//拒绝后的浮层提示
@property (nonatomic, strong) BMKLocationManager* locationManager;//百度地图定位
@property (nonatomic, strong) CLLocationManager* locationMag;
@property (nonatomic, strong) UIButton* backBtn;
@property (nonatomic, strong) UIButton* closeBtn;
@property (nonatomic, strong) UIButton* shareBtn;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIView* navView;

@property (nonatomic, copy) NSString* currentUrl;
@property (nonatomic, copy) NSString* lastUrl;

@property (nonatomic, copy) NSString* locationResultMethod;
@property (nonatomic, copy) NSString* sjmhTaoBaoResultMethod;
@property (nonatomic, copy) NSString* autoSetpResultMethod;

@property (nonatomic, strong) NSMutableArray* yw_urls;
@property (nonatomic, strong) UIImageView* imgView;
@property(nonatomic,strong) CMPedometer *yw_pedometer;

@end

@implementation LYJOwnWebController

- (instancetype)initWithUrl:(NSString*)url {
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle];
    [self initWebView];
}

- (void)initWebView {
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userController = [[WKUserContentController alloc] init];
    
    [userController addScriptMessageHandler:self name:@"startSJMHTaobao"];
    [userController addScriptMessageHandler:self name:@"uploadLocation"];
    [userController addScriptMessageHandler:self name:@"uploadContact"];
    [userController addScriptMessageHandler:self name:@"faceAuth"];
    [userController addScriptMessageHandler:self name:@"setContactAuth"];
    [userController addScriptMessageHandler:self name:@"setLocationAuth"];
    [userController addScriptMessageHandler:self name:@"setAuthPhoto"];
    [userController addScriptMessageHandler:self name:@"showSettingView"];
    [userController addScriptMessageHandler:self name:@"clearUrlCache"];
    [userController addScriptMessageHandler:self name:@"clearCookie"];
    [userController addScriptMessageHandler:self name:@"showLeftBackBtn"];
    [userController addScriptMessageHandler:self name:@"stopLocation"];
    [userController addScriptMessageHandler:self name:@"checkAudioStatus"];
    [userController addScriptMessageHandler:self name:@"uploadStep"];
    [userController addScriptMessageHandler:self name:@"cmPedomerStep"];
    [userController addScriptMessageHandler:self name:@"autoStep"];
    [userController addScriptMessageHandler:self name:@"stopAutoStep"];
    [userController addScriptMessageHandler:self name:@"popController"];
    
    configuration.userContentController = userController;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, APP_STATUS_NAVBAR_HEIGHT, APPWidth, APPHeight - APP_STATUS_NAVBAR_HEIGHT) configuration:configuration];
    
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    
    [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [self.webView loadRequest:request];
    [self setDefaultParams];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connect) name:@"net-connect" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noConnect) name:@"no-connect" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setDefaultParams];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connect) name:@"net-connect" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noConnect) name:@"no-connect" object:nil];
}


#pragma mark - 网络连接UI变化

- (void)connect {
    NSString* title = self.titleLabel.text;
    if ([title containsString:@"(未连接)"]) {
        self.titleLabel.text = [title stringByReplacingOccurrencesOfString:@"(未连接)" withString:@""];
    }
    self.titleLabel.textColor = RGBColor(3, 3, 3);
}

- (void)noConnect {
    NSString* title = self.titleLabel.text;
    self.titleLabel.text = [title stringByAppendingString:@"(未连接)"];
    self.titleLabel.textColor = RGBColor(102, 102, 102);
}


#pragma mark - NAV UI

- (void)setBackImg:(UIImage*)backImg closeImg:(UIImage*)closeImg shareImg:(UIImage*)shareImg {
    [self.backBtn setImage:backImg forState:UIControlStateNormal];
    self.backBtn.frame = CGRectMake(20, APP_STATUS_HEIGHT + (APP_NAV_BAR_HEIGHT - backImg.size.height) / 2, backImg.size.width, backImg.size.height);
    [self.closeBtn setImage:closeImg forState:UIControlStateNormal];
    self.closeBtn.frame = CGRectMake(self.backBtn.right + 20, APP_STATUS_HEIGHT + (APP_NAV_BAR_HEIGHT - closeImg.size.height) / 2, closeImg.size.width, closeImg.size.height);
    [self.shareBtn setImage:shareImg forState:UIControlStateNormal];
}

- (void)setNavTitle {
    self.view.userInteractionEnabled = YES;
    
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPWidth, APP_STATUS_NAVBAR_HEIGHT)];
    self.navView.backgroundColor = [UIColor whiteColor];
    self.navView.userInteractionEnabled = YES;
    [self.view addSubview:self.navView];
    
    self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, (APP_STATUS_NAVBAR_HEIGHT - 24)/2 + APP_STATUS_HEIGHT/2, 50, 24)];
    [self.backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:self.backBtn];
    
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((APPWidth - 200)/2, (APP_STATUS_NAVBAR_HEIGHT - 30)/2  + APP_STATUS_HEIGHT/2, 200, 30)];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.userInteractionEnabled = YES;
    self.titleLabel.textColor = RGBColor(3, 3, 3);
    [self.navView addSubview:self.titleLabel];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelAction)];
    [self.titleLabel addGestureRecognizer:tap];
    
    self.closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.backBtn.right + 15, (APP_STATUS_NAVBAR_HEIGHT - 24)/2 + APP_STATUS_HEIGHT/2, 24, 24)];
    [self.closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.closeBtn.hidden = YES;
    self.closeBtn.enabled = NO;
    [self.navView addSubview:self.closeBtn];
    
    
    self.shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(APPWidth - 50 - 20, (APP_STATUS_NAVBAR_HEIGHT - 24)/2 + APP_STATUS_HEIGHT/2, 35, 24)];
    [self.shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:self.shareBtn];
    
    //是否使用默认的Nav
}


#pragma mark - btn action

- (void)titleLabelAction {
    int tapCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"titleCount"] intValue];
    if (tapCount >= 3) {
        tapCount = 0;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:tapCount] forKey:@"titleCount"];
        [self.webView reload];
    } else {
        tapCount ++;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:tapCount] forKey:@"titleCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (void)backBtnAction {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        if (self.type != LYJWebViewTypeZDGJ) {
            self.backBtn.hidden = YES;
            self.backBtn.enabled = NO;
            self.closeBtn.hidden = YES;
            self.closeBtn.enabled = NO;
        } else {
            [self clearWbCache];
            [self popOutController];
            if (self.toRootVC) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

- (void)closeBtnAction {
    [self clearWbCache];
    
    if (self.lastUrl) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_lastUrl]]];
    } else {
        [self popOutController];
        if (self.toRootVC) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

- (void)shareBtnAction {
    
    NSArray *postItems=@[self.currentUrl];
    
    UIActivityViewController *avc = [[UIActivityViewController alloc]initWithActivityItems:postItems applicationActivities:nil];
    
    [self presentViewController:avc animated:YES completion:nil];
    
}

#pragma mark - 注册方法

- (void)setUrl:(NSString *)url {
    [self.imgView removeFromSuperview];
    _url = url;
    _currentUrl = _url;
}

#pragma mark - WKNavigationDelegate
#pragma mark - 截取当前加载的URL 为每一个请求添加token

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self setToken];
    [self setDefaultParams];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self finishLoad];
    if (self.type != LYJWebViewTypeZDGJ) {
        self.titleLabel.text =  webView.title;//获取当前页面的title
    }
    NSString *currentURL = webView.URL.absoluteString;
    if (![currentURL isEqualToString:_url]) {
        _currentUrl = currentURL;
        if (self.type != LYJWebViewTypeZDGJ) {
            self.backBtn.hidden = NO;
            self.backBtn.enabled = YES;
        }
        
        
        self.closeBtn.hidden = NO;
        self.closeBtn.enabled = YES;
    }
    
    NSString *currentHostUrl = [NSString stringWithFormat:@"%@://%@", [NSURL URLWithString:currentURL].scheme, [NSURL URLWithString:currentURL].host];
    NSString *originHostUrl = [NSString stringWithFormat:@"%@://%@", [NSURL URLWithString:_url].scheme, [NSURL URLWithString:_url].host];
    
    if (![originHostUrl isEqualToString:currentHostUrl]) {
        self.lastUrl = [_yw_urls lastObject];
    } else {
        [_yw_urls addObject:currentURL];
    }
}

- (void)showLeftBackBtn {
    self.backBtn.hidden = NO;
    self.backBtn.enabled = YES;
}

#pragma mark - JS调用的OC回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"startSJMHTaobao"]) {
        [self startSJMHTaobao:message.body];
    } else if ([message.name isEqualToString:@"uploadLocation"]) {
        [self uploadLocation:message.body];
    } else if ([message.name isEqualToString:@"uploadContact"]) {
        [self uploadContact:message.body];
    } else if ([message.name isEqualToString:@"faceAuth"]) {
        NSDictionary* dic = message.body;
        [self face:[dic stringWithKey:@"name"] Number:[dic stringWithKey:@"cardNumber"] Method:[dic stringWithKey:@"method"]];
    } else if ([message.name isEqualToString:@"setContactAuth"]) {
        [self setContactAuth];
    } else if ([message.name isEqualToString:@"setLocationAuth"]) {
        [self setLocationAuth];
    } else if ([message.name isEqualToString:@"setAuthPhoto"]) {
        [self setAuthPhoto];
    } else if ([message.name isEqualToString:@"showSettingView"]) {
        [self showSettingView:message.body];
    } else if ([message.name isEqualToString:@"clearUrlCache"]) {
        [self clearUrlCache];
    } else if ([message.name isEqualToString:@"clearCookie"]) {
        [self clearCookie];
    } else if ([message.name isEqualToString:@"showLeftBackBtn"]) {
        [self showLeftBackBtn];
    } else if ([message.name isEqualToString:@"stopLocation"]) {
        [self stopLocation];
    } else if ([message.name isEqualToString:@"checkAudioStatus"]) {
        [self checkAudioStatus:message.body];
    } else if ([message.name isEqualToString:@"uploadStep"]) {
        [self uploadStep:message.body];
    } else if ([message.name isEqualToString:@"cmPedomerStep"]) {
        [self cmPedomerSetp:message.body];
    } else if ([message.name isEqualToString:@"autoStep"]) {
        [self startAutoStep:message.body];
    } else if ([message.name isEqualToString:@"stopAutoStep"]) {
        [self stopAutoStep];
    } else if ([message.name isEqualToString:@"popController"]) {
        [self popController];
    }
}

- (void)popController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 停止计步

- (void)stopAutoStep {
    if (_yw_pedometer) {
        [_yw_pedometer stopPedometerUpdates];
    }
}


#pragma mark - 开始计步

- (void)startAutoStep:(NSDictionary*)dic {
    NSString* resultMethod = [dic stringWithKey:@"method"];
    double startTime = [dic stringWithKey:@"startTime"].doubleValue;
    NSDate* startDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    
    if (!resultMethod || [resultMethod isEmptyStr]) {
        resultMethod = @"uploadAutoSetpResult";
    }
    self.autoSetpResultMethod = resultMethod;
    if(![CMPedometer isStepCountingAvailable])
    {
        [self failuerWithMethod:resultMethod code:[NSNumber numberWithInteger:1002]];//不可用
        return;
    }
    self.yw_pedometer = [[CMPedometer alloc]init];
    
    [self.yw_pedometer startPedometerUpdatesFromDate:startDate withHandler:^(CMPedometerData * _Nullable pedometerData,
                                                                             NSError * _Nullable error) {
        
        
        if(error)
        {
            [self failuerWithMethod:resultMethod code:[NSNumber numberWithInteger:1001]];//不可用
            return;
        }
        NSNumber * number = pedometerData.numberOfSteps;
        
        [self performSelectorOnMainThread:@selector(changeStep:) withObject:number waitUntilDone:YES];
        
    }];
    
}


-(void)changeStep:(NSNumber *)number
{
    [NSThread sleepForTimeInterval:1];
    [self successWithMethod:self.autoSetpResultMethod dic:[NSDictionary dictionaryWithObject:number forKey:@"stepCount"]];
}

#pragma mark -
#pragma mark - 上传步数

- (void)cmPedomerSetp:(NSDictionary*)dic {
    double startTime = [dic stringWithKey:@"startTime"].doubleValue;
    double endTime = [dic stringWithKey:@"endTime"].doubleValue;
    NSString* resultMethod = [dic stringWithKey:@"method"];
    
    NSDate* startDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSDate* endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    if (!resultMethod || [resultMethod isEmptyStr]) {
        resultMethod = @"uploadPedomSetpResult";
    }
    self.yw_pedometer = [[CMPedometer alloc]init];
    //判断记步功能
    if ([CMPedometer isStepCountingAvailable]) {
        [self.yw_pedometer queryPedometerDataFromDate:startDate toDate:endDate withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            if (error) {
                [self failuerWithMethod:resultMethod code:[NSNumber numberWithInteger:1001]];
            }else {
                [self successWithMethod:resultMethod dic:[NSDictionary dictionaryWithObject:pedometerData.numberOfSteps forKey:@"stepCount"]];
            }
        }];
    }else{
        [self failuerWithMethod:resultMethod code:[NSNumber numberWithInteger:1002]];//不可用
    }
    
}
#pragma mark - 上传步数
- (void)uploadStep:(NSDictionary*)dic {
    //    double startTime = [dic stringWithKey:@"startTime"].doubleValue;
    //    double endTime = [dic stringWithKey:@"endTime"].doubleValue;
    //    NSString* resultMethod = [dic stringWithKey:@"resultMethod"];
    //
    //    NSDate* startDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    //    NSDate* endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    //    if (!resultMethod || [resultMethod isEmptyStr]) {
    //        resultMethod = @"uploadSetpResult";
    //    }
    //
    //
    //    [[HealthKitManage shareInstance] authorizeHealthKit:^(BOOL success, NSError * _Nonnull error) {
    //        [[HealthKitManage shareInstance] requestStepCountWithStartTime:startDate endTime:endDate completion:^(double stepCount, NSError *error) {
    //            if (!error) {
    //                [self successWithMethod:resultMethod dic:[NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:stepCount] forKey:@"stepCount"]];
    //            } else {
    //                [self failuerWithMethod:resultMethod code:[NSNumber numberWithInteger:1001]];
    //            }
    //        }];
    //    }];
    //
}


#pragma mark - 设置默认参数

- (void)setToken {
    NSString* token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token) {
        
        NSString* tokenValue = [NSString stringWithFormat:@"var app = %@", [Util getJsonWith:[NSDictionary dictionaryWithObject:token forKey:@"token"]]];
        NSString* tokenJS = [NSString stringWithFormat:@"%@", tokenValue];
        [self.webView evaluateJavaScript:tokenJS completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        }];
    }
}

- (void)setDefaultParams {
    
    NSString* str = [Util getJsonWith:[self addFixedArgumentsWithDictionary:[CommonUtil Commondata]]];
    NSString* value = [NSString stringWithFormat:@"var appConfig = %@", str];
    
    NSString* alertJS = [NSString stringWithFormat:@"%@", value];
    
    [self.webView evaluateJavaScript:alertJS completionHandler:^(id _Nullable item, NSError * _Nullable error) {
    }];
    
    
}

#pragma mark - clear cookie

- (void)clearCookie {
    NSHTTPCookie *cookie;NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
}

#pragma mark - 清除缓存

- (void)clearUrlCache {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

#pragma mark - 通讯录

- (void)uploadContact:(NSString*)resultMethod {
    if (!resultMethod || [resultMethod isEmptyStr]) {
        resultMethod = @"uploadContactResult";
    }
    if ([YWAuthUtil getContactStatus] == YLAuthUtilStatusAuthed) {
        [YWAuthUtil sendContactSuccess:^(NSArray *contacts) {
            [self successWithMethod:resultMethod dic:[NSDictionary dictionaryWithObject:contacts forKey:@"contacts"]];
        } failure:^{
            [self failuerWithMethod:resultMethod code:[NSNumber numberWithInteger:1001]];
        }];
    } else if ([YWAuthUtil getContactStatus] == YLAuthUtilStatusDefined){
        [self failuerWithMethod:resultMethod code:[NSNumber numberWithInteger:1000]];
    } else {
        [YWAuthUtil reqeustAuth:^(BOOL granted) {
            if (granted) {
                [YWAuthUtil sendContactSuccess:^(NSArray *contacts) {
                    [self successWithMethod:resultMethod dic:[NSDictionary dictionaryWithObject:contacts forKey:@"contacts"]];
                } failure:^{
                    [self failuerWithMethod:resultMethod code:[NSNumber numberWithInteger:1001]];
                }];
            } else {
                [self failuerWithMethod:resultMethod code:[NSNumber numberWithInteger:1000]];
            }
            
        }];
    }
}
//检查麦克风权限
- (void) checkAudioStatus:(NSString*)resultMethod {
    if (!resultMethod || [resultMethod isEmptyStr]) {
        resultMethod = @"audioResult";
    }
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted) {
                [self successWithMethod:resultMethod dic:[NSDictionary dictionary]];
            } else {
                [self failuerWithMethod:resultMethod code:[NSNumber numberWithInteger:1000]];
            }
        }];
    } else if (authStatus == AVAuthorizationStatusAuthorized) {
        [self successWithMethod:resultMethod dic:[NSDictionary dictionary]];
    } else {
        [self failuerWithMethod:resultMethod code:[NSNumber numberWithInteger:1000]];
    }
}


#pragma mark - 定位

- (void)uploadLocation:(NSString*)resultMethod {
    if (!resultMethod || [resultMethod isEmptyStr]) {
        self.locationResultMethod = @"uploadLocationResult";
    } else {
        self.locationResultMethod = resultMethod;
    }
    if ([YWAuthUtil getLocationStatus] == YLAuthLocationStatusAuthed) {
        [self sendLocation];
    } else if ([YWAuthUtil getLocationStatus] == YLAuthLocationStatusNotDetermined) {
        [self.locationMag requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
    } else {
        [self failuerWithMethod:self.locationResultMethod code:[NSNumber numberWithInteger:1000]];
    }
}

-(CLLocationManager*)locationMag {
    if (!_locationMag) {
        _locationMag = [[CLLocationManager alloc] init];
        _locationMag.delegate = self;
    }
    return _locationMag;
}

- (void)sendLocation {
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:self.yw_baidu_key authDelegate:self];
    //初始化实例
    _locationManager = [[BMKLocationManager alloc] init];
    //设置delegate
    _locationManager.delegate = self;
    //设置返回位置的坐标系类型
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    //设置距离过滤参数
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置应用位置类型
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    //设置是否自动停止位置更新
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    //设置是否允许后台定位
    _locationManager.allowsBackgroundLocationUpdates = NO;
    //设置位置获取超时时间
    _locationManager.locationTimeout = 10;
    //设置获取地址信息超时时间
    _locationManager.reGeocodeTimeout = 10;
    [_locationManager startUpdatingLocation];
    
}

- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error {
    if (error == nil) {
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        NSString* address = @"";
        if (location.rgcData.province) {
            address = location.rgcData.province;
        }
        if (![address isEqualToString:location.rgcData.city]) {
            address = [address stringAddStr:location.rgcData.city];
        }
        address = [[[address stringAddStr:location.rgcData.district] stringAddStr:location.rgcData.street] stringAddStr:location.rgcData.streetNumber];
        NSString* longitude = [NSString stringWithFormat:@"%lf",location.location.coordinate.longitude];
        NSString* latitude = [NSString stringWithFormat:@"%lf",location.location.coordinate.latitude];
        
        [params setObject:address forKey:@"address"];
        [params setObject:longitude forKey:@"longitude"];
        [params setObject:latitude forKey:@"latitude"];
        [self successWithMethod:self.locationResultMethod dic:params];
    } else {
        [self failuerWithMethod:self.locationResultMethod code:[NSNumber numberWithInteger:1001]];
    }
}

- (void)stopLocation {
    if (_locationManager) {
        [_locationManager stopUpdatingLocation];
    }
}


#pragma mark - 防止定位弹窗一闪就消失

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            [self.locationMag requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            [self sendLocation];
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self sendLocation];
            break;
        default:
            break;
            
    }
}


#pragma mark - face++人脸识别

- (void)face:(NSString*)name Number:(NSString*)number Method:(nonnull NSString *)resultMethod {
    if (!resultMethod || [resultMethod isEmptyStr]) {
        resultMethod = @"faceAuthResult";
    }
    NSMutableDictionary* liveInfoDict = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    [liveInfoDict setObject:@"meglive" forKey:@"liveness_type"];
    [liveInfoDict setObject:[NSNumber numberWithInt:1] forKey:@"comparison_type"];
    [liveInfoDict setObject:name forKey:@"idcard_name"];
    [liveInfoDict setObject:number forKey:@"idcard_number"];
    [liveInfoDict setObject:[NSNumber numberWithInt:1] forKey:@"verbose"];
    
    [[DemoMGFaceIDNetwork singleton] queryDemoMGFaceIDAntiSpoofingBizTokenLiveConfig:liveInfoDict
                                                                                 key:self.yw_face_key
                                                                              secret:self.yw_face_secret
                                                                             success:^(NSInteger statusCode, NSDictionary *responseObject) {
                                                                                 if (statusCode == 200 && responseObject && [[responseObject allKeys] containsObject:@"biz_token"] && [responseObject objectForKey:@"biz_token"]) {
                                                                                     MGFaceIDLiveDetectError* error;
                                                                                     MGFaceIDLiveDetectManager* liveDetectManager = [[MGFaceIDLiveDetectManager alloc] initMGFaceIDLiveDetectManagerWithBizToken:[responseObject objectForKey:@"biz_token"] language:MGFaceIDLiveDetectLanguageCh networkHost:@"https://api.megvii.com" extraData:@{} error:&error];
                                                                                     
                                                                                     
                                                                                     if (error || !liveDetectManager) {
                                                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                                                             [self failuerWithMethod:resultMethod code:[NSNumber numberWithInt:1000]];//初始化失败
                                                                                             return;
                                                                                         });
                                                                                     }
                                                                                     
                                                                                     [liveDetectManager startMGFaceIDLiveDetectWithCurrentController:self
                                                                                                                                            callback:^(MGFaceIDLiveDetectError *error, NSData *deltaData, NSString *bizTokenStr, NSDictionary *extraOutDataDict) {
                                                                                                                                                AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                                                                                                                                                if (authStatus == AVAuthorizationStatusDenied) {
                                                                                                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                                                                        [self failuerWithMethod:resultMethod code:[NSNumber numberWithInt:1001]];//没有相机权限
                                                                                                                                                        
                                                                                                                                                    });
                                                                                                                                                }
                                                                                                                                                if (error.errorType != MGFaceIDLiveDetectErrorNone) {
                                                                                                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                                                                        [self failuerWithMethod:resultMethod code:[NSNumber numberWithInt:1002]];//没有相机权限
                                                                                                                                                        
                                                                                                                                                    });
                                                                                                                                                } else  if(deltaData) {
                                                                                                                                                    //上传数据
                                                                                                                                                    [[DemoMGFaceIDNetwork singleton] queryDemoMGFaceIDAntiSpoofingVerifyWithBizToken:[responseObject objectForKey:@"biz_token"]
                                                                                                                                                                                                                                 key:self.yw_face_key
                                                                                                                                                                                                                              secret:self.yw_face_secret                                                                                                                                      verify:deltaData
                                                                                                                                                                                                                             success:^(NSInteger statusCode, NSDictionary *responseObject) {
                                                                                                                                                                                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                                                                                                                                                     [self successWithMethod:resultMethod dic:[NSDictionary dictionaryWithObject:[Util getJsonWith:responseObject] forKey:@"faceLiving"]];
                                                                                                                                                                                                                                 });                                                                                                                                           }failure:^(NSInteger statusCode, NSError *error) {
                                                                                                                                                                                                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                                                                                                                                                         [self failuerWithMethod:resultMethod code:[NSNumber numberWithInt:1002]];//face++验证失败
                                                                                                                                                                                                                                     });
                                                                                                                                                                                                                                 }];
                                                                                                                                                } else {
                                                                                                                                                    [self failuerWithMethod:resultMethod code:[NSNumber numberWithInt:error.errorType]];//没有相机权限
                                                                                                                                                }
                                                                                                                                            }];
                                                                                 } else {
                                                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                                                         [self failuerWithMethod:resultMethod code:[NSNumber numberWithInt:1000]];//初始化失败
                                                                                     });
                                                                                 }
                                                                             } failure:^(NSInteger statusCode, NSError *error) {
                                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                                     
                                                                                     [self failuerWithMethod:resultMethod code:[NSNumber numberWithInteger:statusCode]];//初始化失败
                                                                                 });
                                                                             }];
    
    
}

#pragma mark - 数据磨合接口

- (void)startSJMHTaobao:(NSString*)resultMethod {
    if (!resultMethod || [resultMethod isEmptyStr]) {
        self.sjmhTaoBaoResultMethod = @"taobaoResult";
    } else {
        self.sjmhTaoBaoResultMethod = resultMethod;
    }
    DLog(@"================");
    SJMagicBox *box = [SJMagicBox shared];
    [box initWithPartnerCode:self.yw_sjmh_code andPartnerKey:self.yw_sjmh_key];
    
    PBBaseReq *br = [PBBaseReq new];
    br.channel_code=self.yw_sjmh_code;//
    //    br.channel_type = SJMH_KEY;//合作方key
    br.channel_code = @"005003";//客户端渠道码，例如京东是 005011
    PBBaseSet *set = [PBBaseSet new];
    dispatch_async(dispatch_get_main_queue(), ^{
        [shujumohePB openPBPluginAtViewController:self withDelegate:self withReq:br withBaseSet:set];
    });
    DLog(@"================1");
    
}

#pragma mark - 淘宝D

- (void)thePBMissionWithCode:(NSString *)code withMessage:(NSString *)message {
    
    if (code.integerValue == 0) {
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        [params setObject:message forKey:@"taskId"];
        [self successWithMethod:self.sjmhTaoBaoResultMethod dic:params];
        //成功
    } else if (code.integerValue == 1) {
        [self failuerWithMethod:self.sjmhTaoBaoResultMethod code:[NSNumber numberWithInt:1000]];
        //失败
    } else {
        [self failuerWithMethod:self.sjmhTaoBaoResultMethod code:[NSNumber numberWithInt:1000]];
    }
}

#pragma mark - 公共成功方法
- (void)successWithMethod:(NSString*)method dic:(NSDictionary*)dic {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:dic];
        [params setObject:[NSNumber numberWithInt:1] forKey:@"status"];
        NSString* str = [Util getJsonWith:params];
        //        webJS.uploadLocationResult(1);
        NSString *alertJS= [NSString stringWithFormat:@"webJS.%@(%@)", method, str];//准备执行的js代码
        [self.webView evaluateJavaScript:alertJS completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        }];
    });
    
}

#pragma mark - 公共失败方法
- (void)failuerWithMethod:(NSString*)method code:(NSNumber*)code {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        [params setObject:[NSNumber numberWithInt:0] forKey:@"status"];
        [params setObject:code forKey:@"code"];
        NSString* str = [Util getJsonWith:params];
        
        NSString *alertJS= [NSString stringWithFormat:@"webJS.%@(%@)",method, str];//准备执行的js代码
        [self.webView evaluateJavaScript:alertJS completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        }];
    });
    
    
}

#pragma mark - private
- (void)setContactAuth {
    [self showSettingView:@"请允许访问通讯录"];
}

- (void)setLocationAuth {
    [self showSettingView:@"请允许访问定位"];
}

- (void)setAuthPhoto {
    [self showSettingView:@"请允许访问相册"];
}

- (void)showSettingView:(NSString*)str {
    self.settingView = [[UIView alloc] initWithFrame:CGRectMake((APPWidth - 280)/2, (self.view.height - 247)/2, 280, 247)];
    self.settingView.backgroundColor = RGBColor(249, 250, 252);
    self.settingView.layer.cornerRadius = 10;
    self.settingView.layer.masksToBounds = YES;
    [self.view addSubview:self.settingView];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.settingView.width, 48)];
    titleLabel.text = str;
    titleLabel.textColor = RGBColor(63, 63, 63);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [self.settingView addSubview:titleLabel];
    
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(16, titleLabel.bottom, 248, 144)];
    imgView.image = [UIImage imageNamed:@"tips"];
    [self.settingView addSubview:imgView];
    
    UIView* bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.settingView.height - 50, self.settingView.width, 1)];
    bottomLine.backgroundColor = RGBColor(226, 226, 226);
    [self.settingView addSubview:bottomLine];
    
    UIButton* cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, bottomLine.bottom , 140, 49)];
    [cancelBtn setTitle:@"放弃" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGBColor(155, 155, 155) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.settingView addSubview:cancelBtn];
    
    UIView* centerLine = [[UIView alloc] initWithFrame:CGRectMake(cancelBtn.right, bottomLine.bottom, 1, 49)];
    centerLine.backgroundColor = RGBColor(226, 226, 226);
    [self.settingView addSubview:centerLine];
    
    UIButton* jumpBtn = [[UIButton alloc] initWithFrame:CGRectMake(cancelBtn.right, cancelBtn.top, cancelBtn.width, cancelBtn.height)];
    [jumpBtn setTitle:@"去设置" forState:UIControlStateNormal];
    [jumpBtn setTitleColor:RGBColor(80, 140, 238) forState:UIControlStateNormal];
    [jumpBtn addTarget:self action:@selector(jumpToSettingPage) forControlEvents:UIControlEventTouchUpInside];
    [self.settingView addSubview:jumpBtn];
}

- (void)cancelBtnAction {
    [self.settingView removeFromSuperview];
}

- (void)jumpToSettingPage {
    [self.settingView removeFromSuperview];
    
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}


#pragma mark - 默认参数

- (NSDictionary *)addFixedArgumentsWithDictionary:(NSDictionary *)parameters
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dic setObject:YMBCURRENT_DEVICE_ID forKey:@"device_id"];
    [dic setObject:[NSNumber numberWithInt:1] forKey:@"os_type"];
    [dic setObject:[NSNumber numberWithFloat:CURRENT_SYSTEM_VERSION] forKey:@"os_version"];
    [dic setObject:[YWAuthUtil getDeviceType] forKey:@"device_type"];
    [dic setObject:APP_VERSION forKey:@"version"];
    
    NSInteger location = 0;
    if ([YWAuthUtil getLocationStatus] == YLAuthLocationStatusAuthed) {
        location = 1;
    } else if ([YWAuthUtil getLocationStatus] == YLAuthLocationStatusNotDetermined) {
        location = 2;
    } else {
        location = 0;
    }
    [dic setObject:[NSNumber numberWithInteger:location] forKey:@"locationAuth"];
    
    NSInteger contact = 0;
    if ([YWAuthUtil getContactStatus] == YLAuthUtilStatusAuthed) {
        contact = 1;
    } else if ([YWAuthUtil getContactStatus] == YLAuthUtilStatusNotDetermined){
        contact = 2;
    } else {
        contact = 0;
    }
    [dic setObject:[NSNumber numberWithInteger:contact] forKey:@"contactAuth"];
    
    NSString* pushToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"pushToken"];
    if (pushToken) {
        [dic setObject:pushToken forKey:@"pushToken"];
    }
    
    NSInteger camera = 0;
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    //    AVAuthorizationStatusNotDetermined = 0 判断是否启用相册权限
    //    AVAuthorizationStatusRestricted,  受限制
    //    AVAuthorizationStatusDenied,       不允许
    //    AVAuthorizationStatusAuthorized  允许
    if(authStatus == AVAuthorizationStatusNotDetermined){
        camera = 2;
    }
    else if (authStatus == AVAuthorizationStatusAuthorized){
        camera = 1;
    }
    else if (authStatus == AVAuthorizationStatusDenied){
        camera = 0;
    }
    else if (authStatus == AVAuthorizationStatusRestricted){
        camera = 0;
    }
    [dic setObject:[NSNumber numberWithInteger:camera] forKey:@"cameraAuth"];
    
    NSInteger photoLibrary = 0;
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
    {
        photoLibrary = 0;
    } else if (status == PHAuthorizationStatusAuthorized) {
        photoLibrary = 1;
    } else {
        photoLibrary = 2;
    }
    [dic setObject:[NSNumber numberWithInteger:photoLibrary] forKey:@"photoLibraryAuth"];
    
    NSInteger audioStatusAuth = 0;
    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (audioStatus) {
        case AVAuthorizationStatusNotDetermined:
            audioStatusAuth = 2;
            break;
        case AVAuthorizationStatusRestricted:
            audioStatusAuth = 0;
            break;
        case AVAuthorizationStatusDenied:
            audioStatusAuth = 0;
            break;
        case AVAuthorizationStatusAuthorized:
            audioStatusAuth = 1;
            break;
        default:
            break;
    }
    [dic setObject:[NSNumber numberWithInteger:audioStatusAuth] forKey:@"audioAuth"];
    return dic;
}


#pragma mark - 监听canGoBack的变化

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"canGoBack"]) {
        if (self.webView.canGoBack) {
            if (self.type != LYJWebViewTypeZDGJ) {
                self.backBtn.hidden = NO;
                self.backBtn.enabled = YES;
            }
            
            self.closeBtn.hidden = NO;
            self.closeBtn.enabled = YES;
        } else {
            if (self.type != LYJWebViewTypeZDGJ) {
                self.backBtn.hidden = YES;
                self.backBtn.enabled = NO;
            }
            
            self.closeBtn.hidden = YES;
            self.closeBtn.enabled = NO;
        }
    }
}


#pragma mark - Umeng注册

- (void)umAnalysis:(NSString*)key {
    UMConfigInstance.appKey = key;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
}


-(NSMutableArray*)yw_urls {
    if (!_yw_urls) {
        _yw_urls = [NSMutableArray array];
    }
    return _yw_urls;
}

#pragma mark - setter

- (void)setUmeng_key:(NSString *)umeng_key {
    _umeng_key = umeng_key;
    [self umAnalysis:_umeng_key];
}

- (void)setColor:(NSString *)color {
    _color = color;
    self.navView.backgroundColor = [UIColor colorWithHexString:self.color];
}

- (void)setUseCustomNav:(BOOL)useCustomNav {
    _useCustomNav = useCustomNav;
    if (!_useCustomNav) {
        [self setBackImg:[SVGKImage imageNamed:@"back"].UIImage closeImg:[SVGKImage imageNamed:@"close"].UIImage shareImg:[SVGKImage imageNamed:@"share"].UIImage];
    }
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.titleLabel.text = titleStr;
}

- (void)setTitleColor:(NSString *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = [UIColor colorWithHexString:titleColor];
}
- (void)setHiddenBack:(BOOL)hiddenBack {
    _hiddenBack = hiddenBack;
    self.backBtn.hidden = hiddenBack;
    self.backBtn.enabled = !hiddenBack;
}

+ (void)modificationUA:(NSString*)currentUserAgent {
    WKWebView *wk = [[WKWebView alloc] init];
    
    if (iSiOS9) {
        [wk evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
            NSString *oldAgent = result;
            
            if (!oldAgent) {
                oldAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
                
            }
            
            if (![oldAgent hasSuffix:currentUserAgent]) {
                NSString *customUserAgent = [NSString stringWithFormat:@"%@%@", oldAgent,currentUserAgent];
                [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":customUserAgent, @"User-Agent":customUserAgent}];
            }
        }];
    } else {//适配iOS8，下面的方法不能少
        NSString *oldAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        
        if (![oldAgent hasPrefix:currentUserAgent]) {
            NSString *customUserAgent = [NSString stringWithFormat:@"%@ %@", currentUserAgent, oldAgent];
            
            NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:customUserAgent, @"UserAgent", nil];
            [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
            
            [wk setValue:customUserAgent forKey:@"applicationNameForUserAgent"];
        }
    }
}
- (void)clearWbCache{
    //    (NSHomeDirectory)/Library/Caches/(current application name, [[NSProcessInfo processInfo] processName])
    // 清除缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    [self.webView.configuration.userContentController removeAllUserScripts];
    self.webView = nil;
    // 清除磁盘（上面两句就是已经执行好了，下面只是一个思路）  路径来源可以看上面的图（不过这里）
    /*
     NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES)[0];
     NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
     NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
     NSString *webKitFolderInCaches = [NSString stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
     NSError *error;
     [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
     [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
     */
}


- (void)finishLoad {
    
}

- (void)popOutController {
    
}

@end
