//
//  WhdeFileManager.h
//  BreakPoint
//
//  Created by whde on 16/3/25.
//  Copyright © 2016年 whde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WhdeFileManager : NSObject
/*根据NSURL获取存储的路径,文件不一定存在*/
+ (NSString *)filePath:(NSURL *)url;
/*获取对应文件的大小*/
+ (long long)fileSize:(NSURL *)url;
/*根据url删除对应的文件*/
+ (BOOL)deleteFile:(NSURL *)url;
@end
