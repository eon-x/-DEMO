//
//  WSPX.h
//  WSPX
//
//  Created by lincz on 13-1-17.
//  Copyright (c) 2013年 Chinanetcenter. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WSPXDelegate <NSObject>

@required
- (void)didReceiveClientInfo;
- (void)postTmUrl:(NSString *)Url;
@end

@interface WSPX : NSObject

/*
 ** 开启服务
 ** 返回值指示了成功与否。
 **
 ** 请在启动 app 后，首先调用此 API。在整个进程的生命周期中，该函数只调用一次。
 */
+ (BOOL)start;

/*
 ** 激活服务
 ** 返回值指示了成功与否。
 ** 
 ** 请在 app 进入前台后首先调用此 API。
 */
+ (BOOL)activate;

/**
 *  更新鉴权配置。
 */
+ (void)update;

/*
 ** 关闭服务
 ** 
 ** 请在完全退出 app 时调用此 API。在整个进程的生命周期中，该函数只调用一次。
 */
+ (void)stop;


/*
 ** 设置是否走代理
 **
 ** 这是一个全局开关
 */
+ (void)setViaProxy:(BOOL)value;


/*
 ** 创建一个tcp socket
 ** 成功返回sockfd
 ** 错误返回－1
 **
 */
+ (int)tcp_connect:(const char*)ipaddr port:(int)port;

/*
 ** 视频加速接口
 ** 返回加速后的url
 **
 */
+ (NSString *)getProxifiedUrl:(NSString *)originalUrl;

/*
 ** 获取ClientInfo
 **
 ** 成功加密后的ClientInfo串
 ** 错误返回空字符串 @""
 */
+ (NSString*)getClientInfoWithAppCode:(NSString*)appCode Args:(NSDictionary*)args;

/*
 **获取token
 **
 **成功返回token串
 **无token串则返回 @""
*/
+ (NSString*)getUserToken;
/*
 ** 判断套餐流量是否用完
 **
 ** 返回YES 表示已经用完
 ** 返回NO  表示还有流量
 ** 
 */
+ (BOOL)isTrafficQuotaExceeded;

/*
 ** 读取本地代理端口
 **
 **
 */
+ (int)getProxyPort;

/*
 ** TCP连接加头引导
 ** buff 大于128长度缓存
 ** aBuffSize buff大小
 ** aIpAddr 目标服务地址
 ** aPort 目标服务端口
 ** 返回 0:失败 大于0:成功
 */
+ (int)tcpGetProxifiedHeader:(void*)buff buffSize:(int)aBuffSize remoteIpAddr:(in_addr_t)aIpAddr remotePort:(uint16_t)aPort;

/*
 ** UDP数据包添加头部引导
 ** buff 缓存
 ** aBuffSize buff大小
 ** aIpAddr 目标服务地址
 ** aPort 目标服务端口
 ** 返回 0:失败 大于0:添加的数据长度
 */
+ (int)udpGetProxifiedHeader:(void*)buff buffSize:(int)aBuffSize remoteIpAddr:(in_addr_t)aIpAddr remotePort:(uint16_t)aPort;


/*
 **设置js的超时时间
 **timeout 单位为秒
 **
 */
+ (void)setJsNSURLSessionTimeout:(NSInteger) timeout;

+ (void)setDelegate:(id<WSPXDelegate>)delegate;

@end
