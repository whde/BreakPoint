//
//  WhdeSession.m
//  BreakPoint
//
//  Created by whde on 16/3/25.
//  Copyright © 2016年 whde. All rights reserved.
//

#import "WhdeSession.h"
#import "WhdeFileManager.h"
#import "WhdeNetworkService.h"
#import <QuartzCore/QuartzCore.h>
@interface WhdeSession () <NSURLSessionDataDelegate>
@property (nonatomic, assign) long long bytesPerSec;
@property (nonatomic, assign) long long cacheBytesPerSec;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation WhdeSession
/*异步下载*/
+ (instancetype)asynDownloadWithUrl:(NSString *)urlStr progressBlock:(ProgressBlock)progress successBlock:(SuccessBlock) success failureBlock:(FailureBlock)failure callCancelBlock:(CallCancel)callCancel {
    WhdeSession *whdeSession = [[WhdeSession alloc]init];
    if (self) {
        NSURL *url = [NSURL URLWithString:urlStr];
        NSString *path = [WhdeFileManager filePath:url];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        whdeSession.startFileSize = [WhdeFileManager fileSize:url];
        if (whdeSession.startFileSize > 0) {
            /*添加本地文件大小到header,告诉服务器我们下载到哪里了*/
            NSString *requestRange = [NSString stringWithFormat:@"bytes=%llu-", whdeSession.startFileSize];
            [urlRequest addValue:requestRange forHTTPHeaderField:@"Range"];
        }
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:whdeSession delegateQueue:[NSOperationQueue currentQueue]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest];
        whdeSession.progressBlock = [progress copy];
        whdeSession.successBlock = [success copy];
        whdeSession.failureBlock = [failure copy];
        whdeSession.callCancel = [callCancel copy];
        whdeSession.url = url;
        whdeSession.path = path;
        whdeSession.task = task;
        [whdeSession.task resume];
        whdeSession.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                             target:whdeSession
                                                           selector:@selector(updateBytesPerSec)
                                                           userInfo:nil
                                                            repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:whdeSession.timer forMode:NSRunLoopCommonModes];
    }
    return whdeSession;
}
/*取消下载*/
- (void)cancel {
    [self.task cancel];
    if (self.callCancel) {
        self.callCancel(true);
    }
}
/*暂停下载即为取消下载*/
- (void)pause {
    [self cancel];
}
/*出现错误,取消请求,通知失败*/
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    [self.task cancel];
    if (self.failureBlock) {
        self.failureBlock(self.path, error);
    }
}
/*下载完成*/
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    [self.task cancel];
    if (error) {
        if (self.failureBlock) {
            self.failureBlock(self.path, error);
        }
    } else {
        if (self.successBlock) {
            self.successBlock(self.path);
        }
    }
}
/*接收到数据,将数据存储*/
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)dataTask.response;
    if (response.statusCode == 200) {
        /*无断点续传时候,一直走200*/
        if (self.progressBlock) {
            self.progressBlock(((float)dataTask.countOfBytesReceived+self.startFileSize)/((float)(dataTask.countOfBytesExpectedToReceive+self.startFileSize)), (dataTask.countOfBytesReceived+self.startFileSize), (dataTask.countOfBytesExpectedToReceive+self.startFileSize), self.bytesPerSec);
        }
        [self save:data];
    } else if (response.statusCode == 206) {
        /*断点续传后,一直走206*/
        if (self.progressBlock) {
            self.progressBlock(((float)(dataTask.countOfBytesReceived+self.startFileSize)/(float)(dataTask.countOfBytesExpectedToReceive+self.startFileSize)), (dataTask.countOfBytesReceived+self.startFileSize), (dataTask.countOfBytesExpectedToReceive+self.startFileSize), self.bytesPerSec);
        }
        [self save:data];
    }
}

- (void)updateBytesPerSec {
    self.bytesPerSec = self.cacheBytesPerSec;
    self.cacheBytesPerSec = 0;
}

/*存储数据,将offset标到文件末尾,在末尾写入数据,最后关闭文件*/
- (int64_t)save:(NSData *)data {
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.path];
    int64_t total = [fileHandle seekToEndOfFile];
    [fileHandle writeData:data];
    self.cacheBytesPerSec += data.length;
    [fileHandle closeFile];
    total += data.length;
    return total;
}

- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
@end
