//
//  XYCrawlerSDK.h
//  Xinyan-SDK-Dev
//
//  Created by iOS on 2018/4/19.
//  Copyright © 2018年 xinyan. All rights reserved.
//


#import <UIKit/UIKit.h>

/*
 * 功能模块
 */
typedef enum {
    XYCrawlerSDKFunctionTaobao = 0,      // 淘宝
    XYCrawlerSDKFunctionAlipay,          // 支付宝
    XYCrawlerSDKFunctionTaobaopay,       // 支付宝淘宝聚合
    XYCrawlerSDKFunctionCarrier,         // 运营商
    XYCrawlerSDKFunctionJD,              // 京东
    XYCrawlerSDKFunctionJinjiedao,       // 今借到
    XYCrawlerSDKFunctionMifang,          // 米房
    XYCrawlerSDKFunctionWuyoujietiao,    // 无忧借条
    XYCrawlerSDKFunctionJiedaibao,       // 借贷宝
    XYCrawlerSDKFunctionCardProgess,     // 信用卡办卡进度
    XYCrawlerSDKFunctionEducation,       // 学信网
    XYCrawlerSDKFunctionSocialInsurance, // 社保
    XYCrawlerSDKFunctionHousingfund,     // 公积金
    XYCrawlerSDKFunctionCreditBillMail,  // 邮箱账单
    XYCrawlerSDKFunctionEle,             // 饿了么
    XYCrawlerSDKFunctionAutoInsurance    // 车险保单
}XYCrawlerSDKFunction;

/*
 * 状态栏状态枚举
 */
typedef enum  {
    XinYanStatusBarStyleDefault = 0,
    XinYanStatusBarStyleLightContent ,
} XinYanStatusBarStyle;

/*
 * 淘宝支付宝聚合登录方式
 */
typedef enum  {
    XinYanTaobaoPayLoginTypeOneKey = 0,   // 一键登录
    XinYanTaobaoPayLoginTypeAcount ,      // 账号登录
    XinYanTaobaoPayLoginTypeQR            // 扫码登录
} XinYanTaobaoPayLoginType;

/*
 * 淘宝登录方式
 */
typedef enum  {
    XinYanTaobaoLoginTypeSM = 0,        // 短信验证码登录
    XinYanTaobaoLoginTypeAcount ,      // 账号密码登录
    XinYanTaobaoLoginTypeOneKey       // 一键登录
} XinYanTaobaoLoginType;

/*
 1: 成功
 0：创建任务失败
 -1：认证过程失败
 -2：网络连接异常
 -3：用户中断（1”您取消了认证”、2.您取消了验证码输入; 3未授权退出，没有token）《统一退出SDK》
 -4: 等待任务超时
 -5: 用户未授权协议
 */

/**
 SDK 查询回调

 @param function 查询类型
 @param code 状态值
 @param token SDK任务token
 @param message 回调信息
 */
typedef void(^XinYanResultBlock)(XYCrawlerSDKFunction function, int code, NSString *token, NSString *message);


@interface XYCrawlerSDK : NSObject

/**
 商户号，开放平台->用户中心->商户信息
 */
@property (copy,nonatomic) NSString *xyUser;
/**
 终端号，开放平台->用户中心->商户信息
 */
@property (copy,nonatomic) NSString *xyTerminalId;

/**
 秘钥，前往授权服务->个人中心Access Key值
 */
@property (copy,nonatomic) NSString *xyKey;


/**
 报告通知地址
 */
@property (nonatomic,strong) NSString *xyReportNotifyUrl;

/**
 原始数据通知地址
 */
@property (nonatomic,strong) NSString *xyDataNotifyUrl;

/****************************** SDK 任务属性设置 *******************************/
/**
 启动任务类型
 */
@property (assign,nonatomic,readonly) XYCrawlerSDKFunction xyFunction;


/**
 YES(默认)：查询成功自动退出SDK
 NO：      登录成功自动退出SDK
 */
@property (nonatomic,assign) BOOL xyQuitOnSuccess;

/**
 YES：    失败后退出SDK
 NO(默认)：失败后返回SDK查询页面
 */
@property (nonatomic,assign) BOOL xyQuitOnFail;

/**
 查询结果回调
 */
@property (nonatomic,strong) XinYanResultBlock xyResultBlock;

/**
 淘宝登录默认二维码登录在首页（默认：YES）
 */
@property (nonatomic,assign) BOOL xyDefaultQrcodeCheck;
/**
 淘宝支付宝登录方式选择(默认：一键登录)
 */
@property (nonatomic,assign) XinYanTaobaoPayLoginType xyTaobaoPayLoginType;

/**
 淘宝登录方式配置,可以任意方式组合
 默认为[@(XinYanTaobaoLoginTypeSM), @(XinYanTaobaoLoginTypeAcount), @(XinYanTaobaoLoginTypeOneKey)]
 */
@property (nonatomic,strong) NSArray *xyTaobaoLoginTypes;

/**
 sdkVersion
 */
@property (nonatomic,strong,readonly) NSString *xyVersion;

/****************************** SDK UI自定义 *******************************/

/**
 SDK页面背景颜色
 */
@property (nonatomic,strong) UIColor *xyPageBackgroundColor;

/**
 导航条颜色
 */
@property (nonatomic,strong) UIColor *xyThemeColor;

/**
 标题栏: 返回按钮文字\图片颜色,标题颜色,刷新按钮颜色
 */
@property (nonatomic,strong) UIColor *xyTitleColor;

/**
 进度动画颜色
 */
@property (nonatomic,strong) UIColor *xyProgressColor;

/**
 状态栏样式(默认XinYanStatusBarStyleDefault)
 */
@property (nonatomic,assign) XinYanStatusBarStyle xyStatusBarStyle;

/**
 授权协议描述文字颜色:(我已阅读并同意)
 */
@property (nonatomic,strong) UIColor *xyProtocolDesColor;

/**
 授权协议名称文字颜色:(《授权协议》)
 */
@property (nonatomic,strong) UIColor *xyProtocolNameColor;
/**
 商户协议地址
 */
@property (nonatomic,strong) NSString *xyProtocolUrl;
/**
 协议名称
 */
@property (nonatomic,strong) NSString *xyProtocolTitle;

/**
 返回按钮文字
 */
@property (nonatomic,strong) NSString *xyBackText;

/**
 提交按钮文字颜色
 */
@property (nonatomic,strong) UIColor *xySubmitTitleColor;

/**
 提交按钮normal状态颜色
 */
@property (nonatomic,strong) UIColor *xySubmitNormalColor;




/**
 SDK单例

 @return SDK单例
 */
+(XYCrawlerSDK*)sharedSDK;

/**
 初始化 SDK
 
 @param user 商户号，开放平台->用户中心->商户信息 必填参数
 @param key 系统级秘钥(由系统自动生成或管理员分配)，前往授权服务，个人中心Access Key值
 @return SDK
 */
+(XYCrawlerSDK *)xySDKUser:(NSString *)user key:(NSString *)key;

/**
 初始化 SDK
 
 @param user 商户号，开放平台->用户中心->商户信息 必填参数
 @param terminalId 终端号，开放平台->用户中心->商户信息 非必填参数
 @param key 系统级秘钥(由系统自动生成或管理员分配)，前往授权服务，个人中心Access Key值
 @return SDK
 */
+(XYCrawlerSDK *)xySDKUser:(NSString *)user terminalId:(NSString *)terminalId key:(NSString *)key;



/**
 启动 SDK运营商 功能（可携带账号、密码）
 
 @param taskId 商户任务id，用于标记商户任务的唯一性，由商户生成，限制在32位内的字符串
 @param mobile 手机号
 @param password 密码
 @param idCard 身份证号（运营商查询必填）
 @param realName 真实姓名（运营商查询必填）
 @param inputEditing 输入框是否可以编辑 （默认YES）
 @param showIdNameInput 是否显示身份证、姓名输入框（默认NO）
 @param xyResultBlock 查询结果回调
 */
-(void)startFunctionOfCarrierWithTaskId:(NSString *)taskId mobile:(NSString *)mobile password:(NSString *)password  idCard:(NSString *)idCard realName:(NSString *)realName   inputEditing:(BOOL)inputEditing showIdNameInput:(BOOL)showIdNameInput resultCallBack:(XinYanResultBlock)xyResultBlock;


/**
  启动功能

 @param function 功能模块
 @param taskId 商户任务id，用于标记商户任务的唯一性，由商户生成，限制在32位内的字符串
 @param xyResultBlock 查询结果回调
 */
-(void)startFunction:(XYCrawlerSDKFunction)function taskId:(NSString *)taskId  resultCallBack:(XinYanResultBlock)xyResultBlock;

/**
 开启 SDK 日志
 默认为关闭
 */
+ (void)unlockLog;

@end
