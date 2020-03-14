//
//  WhdeSession.h
//  BreakPoint
//
//  Created by whde on 16/3/25.
//  Copyright © 2016年 whde. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^ProgressBlock)(float progress, long long receiveByte, long long allByte,  long long rate);
typedef void (^SuccessBlock)(NSString *filePath);
typedef void (^FailureBlock)(NSString *filePath, NSError *error);
typedef void (^CallCancel)(BOOL cancel);
@interface WhdeSession : NSObject
@property (nonatomic, copy) ProgressBlock progressBlock;
@property (nonatomic, copy) SuccessBlock successBlock;
@property (nonatomic, copy) FailureBlock failureBlock;
@property (nonatomic, copy) CallCancel callCancel;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, assign) long long startFileSize;

/*异步下载*/
+ (instancetype)asynDownloadWithUrl:(NSString *)urlStr progressBlock:(ProgressBlock)progress successBlock:(SuccessBlock) success failureBlock:(FailureBlock)failure callCancelBlock:(CallCancel)callCancel;
/*取消下载*/
- (void)cancel;
/*暂停下载即为取消下载*/
- (void)pause;
@end

