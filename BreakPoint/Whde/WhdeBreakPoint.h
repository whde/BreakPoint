//
//  WhdeBreakPoint.h
//  BreakPoint
//
//  Created by whde on 16/3/25.
//  Copyright © 2016年 whde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WhdeSession.h"
@interface WhdeBreakPoint : NSObject
/*异步下载*/
+ (WhdeSession *)asynDownloadWithUrl:(NSString *)urlStr progressBlock:(ProgressBlock)progress successBlock:(SuccessBlock) success failureBlock:(FailureBlock)failure;
/*取消*/
+ (void)cancel:(NSString *)urlStr;
/*暂停*/
+ (void)pause:(NSString *)urlStr;

@end
