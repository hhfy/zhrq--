//
//  AppDelegate.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/1.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeVC.h"
#import "GeTuiSdk.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

#define kCurrentVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define kGtAppId           @"5aDu9l8rEe53VdfZL35Rl9"
#define kGtAppKey          @"jCWYnsidRC7PBTW4bseCl6"
#define kGtAppSecret       @"ZM0kstk85y6wHGsN7T6h12"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,GeTuiSdkDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:2.0f];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[NavigationController alloc] initWithRootViewController:[[HomeVC alloc] init]];
    [self.window makeKeyAndVisible];
    /// 监听网络状况
    [HttpTool checkNetWork];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    if (kCurrentVersion >= 10) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
#endif
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册APNs
    [self registerRemoteNotification];
    UIApplication *app = [UIApplication sharedApplication];
    app.applicationIconBadgeNumber = 0;
    return YES;
}

- (void)registerRemoteNotification {
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 远程通知(推送)回调
/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //个推注册 向个推服务器注册deviceToken
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    [GeTuiSdk registerDeviceToken:token];
}

#pragma mark - background fetch  唤醒
/**个推 注: iOS7.0 以后支持APP后台刷新数据，会回调 performFetchWithCompletionHandler 接口 */
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
}

/** APP已经接收到“远程”通知(推送) - 透传推送消息  后台收到，点通知进入前台*/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    completionHandler(UIBackgroundFetchResultNewData);
    NSUInteger badge = [userInfo[@"aps"][@"badge"] intValue];
    [GeTuiSdk setBadge:badge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
    //走上面SDK收到透传消息回调方法
    //    NSString *str = userInfo[@"aps"][@"alert"][@"body"];
    NSString *str = userInfo[@"payload"];
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    if (jsonData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        if(err) {
            NSLog(@"json解析失败：%@",err);
        }
        if([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"noticeId"] = dic[@"notify_id"];
            [LaiMethod runtimePushVcName:@"NoticeDetialVC" dic:params nav:CurrentViewController.navigationController];
        }
    }
}

#pragma mark －－ ios 10 －－
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    //应用在前台收到通知
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    NSString *payload = userInfo[@"payload"];
    NSData *jsonData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            NSLog(@"iOS10 前台收到远程通知:");
            completionHandler(UNNotificationPresentationOptionSound + UNNotificationPresentationOptionAlert);
        }
        else {
            // 判断为本地通知
            NSLog(@"iOS10 前台收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
        }
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler {
    //点击通知进入应用
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    NSString *payload = userInfo[@"payload"];
    NSData *jsonData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    if (jsonData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            NSLog(@"iOS10 收到远程通知:");
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"noticeId"] = dic[@"notify_id"];
            [LaiMethod runtimePushVcName:@"NoticeDetialVC" dic:params nav:CurrentViewController.navigationController];
        }
        else {
            // 判断为本地通知
            NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
        }
    }
    completionHandler();  // 系统要求执行这个方法
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //清空推送列表
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

#pragma mark - GeTuiSdkDelegate

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    NSLog(@"\n>>[GTSdk RegisterClient]:%@\n\n", clientId);
}
/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>[GTSdk error]:%@\n\n", [error localizedDescription]);
}
/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    // [ GTSdk ]：汇报个推自定义事件(反馈透传消息)
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
    // 数据转换
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    NSData *jsonData = [payloadMsg dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    if (jsonData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        if(err) {
            NSLog(@"json解析失败：%@",err);
        }
        if (offLine == NO) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            AudioServicesPlaySystemSound(1007);
            [LaiMethod alertControllerWithTitle:@"温馨提示" message:@"收到一条新公告,是否查看？"  defaultActionTitle:@"确定" style:UIAlertActionStyleDefault cancelTitle:@"取消" preferredStyle:UIAlertControllerStyleAlert handler:^{
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                params[@"noticeId"] = dic[@"notify_id"];
                [LaiMethod runtimePushVcName:@"NoticeDetialVC" dic:params nav:CurrentViewController.navigationController];
            }];
        }
    }
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // 发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    NSLog(@"\n>>[GTSdk DidSendMessage]:%@\n\n", msg);
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // 通知SDK运行状态
    NSLog(@"\n>>[GTSdk SdkState]:%u\n\n", aStatus);
}



@end
