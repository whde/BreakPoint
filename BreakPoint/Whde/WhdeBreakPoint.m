//
//  WhdeBreakPoint.m
//  BreakPoint
//
//  Created by whde on 16/3/25.
//  Copyright © 2016年 whde. All rights reserved.
//

#import "WhdeBreakPoint.h"
static NSMutableArray *sessionArray; // [struct Request,struct Request]
@implementation WhdeBreakPoint
+ (void)load {
    sessionArray = [NSMutableArray arrayWithCapacity:50];
}
/*异步下载*/
+ (WhdeSession *)asynDownloadWithUrl:(NSString *)urlStr progressBlock:(ProgressBlock)progress successBlock:(SuccessBlock) success failureBlock:(FailureBlock)failure {
    for (WhdeSession *session in sessionArray) {
        if ([session.url.absoluteString isEqual:urlStr] == true) {
            return session;
        }
    }
    WhdeSession *session = [WhdeSession asynDownloadWithUrl:urlStr progressBlock:progress successBlock:success failureBlock:failure callCancelBlock:^(BOOL cancel) {
        /*WhdeSession取消请求,数组中将移除对应的请求*/
        for (WhdeSession *session in sessionArray) {
            if ([session.url.absoluteString isEqual:urlStr] == true) {
                [sessionArray removeObject:session];
                break;
            }
        }
    }];
    /*添加到数组*/
    [sessionArray addObject:session];
    return session;
}
/*取消*/
+ (void)cancel:(NSString *)urlStr {
    /*查找数组中对应的请求*/
    for (WhdeSession *session in sessionArray) {
        if ([session.url.absoluteString isEqual:urlStr] == true) {
            [session cancel];
            break;
        }
    }
}
/*暂停*/
+ (void)pause:(NSString *)urlStr {
    /*查找数组中对应的请求*/
    for (WhdeSession *session in sessionArray) {
        if ([session.url.absoluteString isEqual:urlStr] == true) {
            [session cancel];
            break;
        }
    }
}
@end
