 //
//  HttpTool.m
//
//  Created by Mr Lai on 2017/1/31.
//  Copyright © 2017年 赖同学. All rights reserved.
//

#import "HttpTool.h"
#import <AFNetworking.h>
#import "LoginVC.h"

#define NetworkActivity     [UIApplication sharedApplication].networkActivityIndicatorVisible
#define NetworkUnavailable  [MBProgressHUD showError:@"网络异常"];
#define NetworkLoadding     [SVProgressHUD showBeginAnimation];
#define NetworkLoaded       [SVProgressHUD dismiss];

@implementation HttpTool

static AFHTTPSessionManager *_mgr;

+ (AFHTTPSessionManager *)mgr
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mgr = [AFHTTPSessionManager manager];
        [_mgr.requestSerializer setTimeoutInterval:30];
        _mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain", nil];
    });
    return _mgr;
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    NetworkLoaded
    NetworkActivity = YES;
    NetworkLoadding
    // 2.发送请求
    [self.mgr POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NetworkLoaded
        NetworkActivity = NO;
        Log(@"%@", responseObject);
        if ([[responseObject[Code] description] isEqualToString:Code200]) {
            if (success) {
                success(responseObject);
            }
        } else if ([[responseObject[Code] description] isEqualToString:Code201]) {
            LoginVC *logniVc = [[LoginVC alloc] init];
            logniVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [LaiMethod alertControllerWithTitle:@"离线提示" message:@"检测到您已掉线，请重新登录！" defaultActionTitle:@"知道了" style:UIAlertActionStyleCancel  handler:^{
                [CurrentWindow.rootViewController presentViewController:logniVc animated:YES completion:nil];
            }];
        } else if ([[responseObject[Code] description] isEqualToString:Code202]) {
            [MBProgressHUD showError:responseObject[Message]];
            [[NSNotificationCenter defaultCenter] postNotificationName:Code202WithDataInnerCodeNotification object:nil];
        } else if ([[responseObject[Code] description] isEqualToString:Code301]) {
            [MBProgressHUD showError:responseObject[Message]];
            [[NSNotificationCenter defaultCenter] postNotificationName:Code301WithDataInnerCodeNotification object:nil];
        } else if ([[responseObject[Code] description] isEqualToString:Code500]) {
            [MBProgressHUD showError:responseObject[Message]];
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            userInfo[Message] = responseObject[Message];
            userInfo[Data] = responseObject[Data];
            [[NSNotificationCenter defaultCenter] postNotificationName:Code500WithDataInnerCodeNotification object:nil userInfo:userInfo];
        } else {
            [MBProgressHUD showError:responseObject[Message]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            NetworkLoaded
            NetworkActivity = NO;
            NetworkUnavailable
            failure(error);
            Log(@"%@", error);
        }
    }];
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params progress:(void (^)(double uploadFileProgress))uploadFileProgress formDataArray:(NSArray *)formDataArray success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    NetworkLoaded
    NetworkActivity = YES;
    
    // 2.发送请求
    [self.mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (FormData *data in formDataArray)
        {
            [formData appendPartWithFileData:data.data name:data.name fileName:data.filename mimeType:data.mimeType];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            double progress = (double)uploadProgress.completedUnitCount /uploadProgress.totalUnitCount;
            [SVProgressHUD showProgress:progress status:[NSString stringWithFormat:@"已上传:%.0f%%", progress * 100]];
            if (progress == 1.0f) {
                [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD showBeginAnimation];
                });
            }
            if (uploadFileProgress) {
                uploadFileProgress(progress);
            }
        });
        
    }  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NetworkActivity = NO;
        NetworkLoaded
        if ([[responseObject[Code] description] isEqualToString:Code200]) {
            if (success) {
                success(responseObject);
            }
        } else if ([[responseObject[Code] description] isEqualToString:Code201]) {
            LoginVC *logniVc = [[LoginVC alloc] init];
            logniVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [CurrentWindow.rootViewController presentViewController:logniVc animated:YES completion:nil];
        } else if ([[responseObject[Code] description] isEqualToString:Code202]) {
            [MBProgressHUD showError:responseObject[Message]];
            [[NSNotificationCenter defaultCenter] postNotificationName:Code202WithDataInnerCodeNotification object:nil];
        } else if ([[responseObject[Code] description] isEqualToString:Code301]) {
            [MBProgressHUD showError:responseObject[Message]];
            [[NSNotificationCenter defaultCenter] postNotificationName:Code301WithDataInnerCodeNotification object:nil];
        } else if ([[responseObject[Code] description] isEqualToString:Code500]) {
            [MBProgressHUD showError:responseObject[Message]];
        } else {
            [MBProgressHUD showError:responseObject[Message]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            NetworkLoaded
            NetworkActivity = NO;
            NetworkUnavailable
            failure(error);
            Log(@"%@", error);
        }
    }];
}

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params progress:(void (^)(double downloadProgress))downLoadProgress success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    NetworkLoaded
    NetworkActivity = YES;
    NetworkLoadding
    // 2.发送请求
    [self.mgr GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NetworkLoaded
            double progress = (double)downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            if (downLoadProgress) {
                downLoadProgress(progress);
            }
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NetworkActivity = NO;
        NetworkLoaded
        Log(@"%@", responseObject);
        if ([[responseObject[Code] description] isEqualToString:Code200]) {
            if (success) {
                success(responseObject);
            }
        } else if ([[responseObject[Code] description] isEqualToString:Code201]) {
            LoginVC *logniVc = [[LoginVC alloc] init];
            logniVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [LaiMethod alertControllerWithTitle:@"离线提示" message:@"检测到您已掉线请重新登录！" defaultActionTitle:@"知道了" style:UIAlertActionStyleCancel handler:^{
                [CurrentWindow.rootViewController presentViewController:logniVc animated:YES completion:nil];
            }];
        } else if ([[responseObject[Code] description] isEqualToString:Code202]) {
            [MBProgressHUD showError:responseObject[Message]];
            [[NSNotificationCenter defaultCenter] postNotificationName:Code202WithDataInnerCodeNotification object:nil];
        } else if ([[responseObject[Code] description] isEqualToString:Code301]) {
            [MBProgressHUD showError:responseObject[Message]];
            [[NSNotificationCenter defaultCenter] postNotificationName:Code301WithDataInnerCodeNotification object:nil];
        } else if ([[responseObject[Code] description] isEqualToString:Code500]) {
            [MBProgressHUD showError:responseObject[Message]];
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            userInfo[Message] = responseObject[Message];
            userInfo[Data] = responseObject[Data];
            [[NSNotificationCenter defaultCenter] postNotificationName:Code500WithDataInnerCodeNotification object:nil userInfo:userInfo];
        } else {
            [MBProgressHUD showError:responseObject[Message]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            NetworkActivity = NO;
            NetworkLoaded
            NetworkUnavailable
            failure(error);
            Log(@"%@", error);
        }
    }];
}

+ (void)checkNetWork
{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态发生改变的时候就调用
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
//                [MBProgressHUD showSuccess:@"已连接WIFI"];
                [[NSNotificationCenter defaultCenter] postNotificationName:ReloadDataNotification object:nil];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
//                [MBProgressHUD showSuccess:@"已连接蜂窝网络"];
                [[NSNotificationCenter defaultCenter] postNotificationName:ReloadDataNotification object:nil];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [[NSNotificationCenter defaultCenter] postNotificationName:NetworkInterruptionNotification object:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD showError:@"网络似乎出现问题"];
                });
                break;
            case AFNetworkReachabilityStatusUnknown:
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD showError:@"未知网络"];
                });
                break;
        }
    }];
    
    [mgr startMonitoring];
    
}

- (void)dealloc
{
    [[AFNetworkReachabilityManager sharedManager]  stopMonitoring];
}

@end

/**
 *  用来封装文件数据的模型
 */
@implementation FormData
+ (instancetype)setData:(NSData *)data name:(NSString *)name mimeType:(NSString *)mimeType fileName:(NSString *)fileName {
    FormData *formData = [[FormData alloc] init];
    formData.data = data;
    formData.name = name;
    formData.mimeType = mimeType;
    formData.filename = fileName;
    return formData;
}
@end
