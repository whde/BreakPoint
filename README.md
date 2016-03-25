# ResumeFromBreakPoint
<p>Objective-C实现断点续传,Demo简单易懂,没有太多复杂模块和逻辑,完整体现断点续传的原理<p>
<p>https://github.com/whde/ResumeFromBreakPoint 为对应的Swift断点续传<p>
## WhdeBreakPoint
简单的网络请求队列管理类,简单的管理,不做太多复杂处理
```objective-c
/*创建请求,添加请求到数组中
WhdeSession请求失败,取消请求等需要从数组中移除*/
+ (WhdeSession *)asynDownloadWithUrl:(NSString *)urlStr progressBlock:(ProgressBlock)progress successBlock:(SuccessBlock) success failureBlock:(FailureBlock)failure;
```
```objective-c
/*取消请求,移除数组中对应的请求*/
+ (void)cancel:(NSString *)urlStr;
```
```objective-c
/*暂停,即为取消请求*/
+ (void)pause:(NSString *)urlStr;
```

## WhdeFileManager
断点续传专用的文件管理
```objective-c
/*根据NSURL获取存储的路径,文件不一定存在
文件名为Url base64转换*/
+ (NSString *)filePath:(NSURL *)url;
```
```objective-c
/*获取对应文件的大小*/
+ (long long)fileSize:(NSURL *)url;
```
```objective-c
/*根据url删除对应的文件*/
+ (BOOL)deleteFile:(NSURL *)url;
```
## WhdeSession
网络收发
```objective-c
/*创建请求,开始下载,设置已经下载的位置*/
+ (instancetype)asynDownloadWithUrl:(NSString *)urlStr progressBlock:(ProgressBlock)progress successBlock:(SuccessBlock) success failureBlock:(FailureBlock)failure callCancelBlock:(CallCancel)callCancel;
```
```objective-c
/*取消下载*/
- (void)cancel;
```
```objective-c
/*暂停下载即为取消下载*/
- (void)pause;
```
```objective-c
/*出现错误,取消请求,通知失败*/
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error;
```
```objective-c
/*下载完成*/
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error;
```
```objective-c
/*接收到数据,将数据存储*/
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
NSHTTPURLResponse *response = (NSHTTPURLResponse *)dataTask.response;
if (response.statusCode == 200) {
/*无断点续传时候,一直走200*/
_progressBlock(((float)dataTask.countOfBytesReceived)/((float)dataTask.countOfBytesExpectedToReceive), dataTask.countOfBytesReceived, dataTask.countOfBytesExpectedToReceive);
[self save:data];
} else if (response.statusCode == 206) {
/*断点续传后,一直走206*/
_progressBlock((((float)(dataTask.countOfBytesReceived+_startFileSize)/(float)(dataTask.countOfBytesExpectedToReceive+_startFileSize))), dataTask.countOfBytesReceived, dataTask.countOfBytesExpectedToReceive);
[self save:data];
}
}
```
```objective-c
/*存储数据,将offset标到文件末尾,在末尾写入数据,最后关闭文件*/
- (void)save:(NSData *)data 
```
# 使用
```objective-c
urlStr = @"http://dlsw.baidu.com/sw-search-sp/soft/2a/25677/QQ_V4.1.1.1456905733.dmg";
/*开始下载
继续下载*/
- (IBAction)start:(id)sender {
[WhdeBreakPoint asynDownloadWithUrl:urlStr progressBlock:^(float progress, long long receiveByte, long long allByte) {
_progressView.progress = progress;
_progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(progress*100)];
} successBlock:^(NSString *filePath) {
NSLog(@"%@", filePath);
} failureBlock:^(NSString *filePath) {
NSLog(@"%@", filePath);
}];
}

- (IBAction)pause:(id)sender {
[WhdeBreakPoint pause:urlStr];
}

- (IBAction)delete:(id)sender {
[WhdeFileManager deleteFile:[NSURL URLWithString:urlStr]];
}
```
