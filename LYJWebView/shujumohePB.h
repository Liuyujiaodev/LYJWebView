//
//  shujumohePB.h
//  shujumohePB
// 1.3.1
//  Created by 数据魔盒 on 2017/7/27.
//  Copyright © 2017年 数据魔盒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    DeletCookieALL,
    DeletCookieForDomin,
}DeletCookieType;


@interface PBBaseReq : NSObject
/** 渠道编码*/
@property (nonatomic, strong) NSString *channel_code;
/** 渠道类型*/
@property (nonatomic, strong) NSString *channel_type;

/** 身份核验 - 身份证姓名*/
@property (nonatomic, strong) NSString *real_name;
/** 身份核验 - 身份证号码*/
@property (nonatomic, strong) NSString *identity_code;
/** 身份核验 - 常用手机号码*/
@property (nonatomic, strong) NSString *user_mobile;
/** 拓传参数 - 用于数据回调时使用*/
@property (nonatomic,strong)NSString *passback_params;

@end

@interface PBBaseSet : NSObject
/** SDK导航栏栏背景色 - 默认白色*/
@property (nonatomic, strong) UIColor *navBGColor;
/** SDK导航标题颜色 - 默认黑色*/
@property (nonatomic, strong) UIColor *navTitleColor;
/** SDK导航标题字体 - 默认16号字体*/
@property (nonatomic, strong) UIFont *navTitleFont;
/** SDK导航返回图片 - 默认三角图返回*/
@property (nonatomic, strong) UIImage *backBtnImage;
/** SDK导航返回按钮是否提示 - 默认为NO有alert提示，YES:没有提示*/
@property (nonatomic,assign) BOOL isCancelBackAlert;
/** SDK清除cookie方式，一般默认为DeletCookieALL ,针对部分特殊说明的用户设置为DeletCookieForDomin */
@property (nonatomic) DeletCookieType deletCookieType;
@end



@protocol shujumoheDelegate <NSObject>
@optional
//@required
/*
 *@name thePBMissionWithCode:withMessage: - 任务成功或者失败的回调
 *@code code为当前SDK任务结果，message为TaskID或时间戳，仅在code = 0 时，taskID可查询认证数据，code !=0 时 taskID用来查询日志
 */
- (void)thePBMissionWithCode:(NSString *)code withMessage:(NSString *)message;

@end

@interface shujumohePB : NSObject
//vc:当前视图控制器，delegate:协议，req（必传）:需要channel_code，partnerCode，partnerKey模型。set（可传空）:客户需要的基础设置
+ (void)openPBPluginAtViewController:(UIViewController *)VC
                        withDelegate:(id<shujumoheDelegate>)delegate
                             withReq:(PBBaseReq *)req
                         withBaseSet:(PBBaseSet *)set;

@end


@interface SJMagicBox : NSObject

/**
 单例方法

 @return SJMagicBox
 */
+ (SJMagicBox *)shared;

/**
 SDK 初始化方法

 @param code partnerCode
 @param key partnerKey
 */
- (void)initWithPartnerCode:(NSString *)code andPartnerKey:(NSString *)key;

/**
 app 进入后台调用的方法
 */
- (void)appDidEnterBackground;

/**
 app 恢复活跃调用的方法
 */
- (void)applicationWillEnterForeground;

@end
