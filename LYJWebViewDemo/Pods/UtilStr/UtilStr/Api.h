//
//  Api.h
//  YLZhiNengYun
//
//  Created by 刘玉娇 on 2017/10/16.
//  Copyright © 2017年 yunli. All rights reserved.
//

////正式环境
#define YL_BASE_API_WEIXIN    @"https://ylxd.yunlibeauty.com/"
#define YL_URL_ORDER      @"https://ylxd.yunlibeauty.com/ylxd/order"
#define YL_BASE_API    @"https://apilms.yunlibeauty.com/"

//测试环境
//#define YL_BASE_API    @"https://alphaapilms.yunlibeauty.com/"
//#define YL_BASE_API_WEIXIN    @"https://ylxdalpha.yunlibeauty.com/"
//#define YL_URL_ORDER      @"https://ylxdalpha.yunlibeauty.com/ylxd/tabBar/repayment"

////beta
//#define YL_BASE_API_WEIXIN    @"https://ylxd.yunlibeauty.com/"
//#define YL_URL_ORDER      @"https://ylxd.yunlibeauty.com/ylxd/order"
//#define YL_BASE_API    @"https://ylxd.yunlibeauty.com/"


#define YL_API_GET_VERIFYCODE   @"mobileapi/account/sendVerifyCode" //1.0.0 获取验证码
#define YL_API_LOGIN   @"mobileapi/account/login" //1.0.0 登录
#define YL_API_SEND_CONTACT   @"mobileapi/apply/savePhoneContacts" //1.0.0 发送通讯录
#define YL_API_SEND_LOCATION   @"mobileapi/account/editCustomerPosition" //1.0.0 发送通讯录

#define YL_API_LOAD_LIST   @"mobileapi/apply/getProductList"//获取产品
#define YL_API_PROJECT_DETAIL_URL    @"mobileapi/apply/getsubmiturl"
#define YL_API_LOGOUT                @"logout"

#define YL_API_GET_VISION            @"mobileapi/account/getVersion"
