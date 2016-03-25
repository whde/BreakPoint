//
//  ViewController.m
//  BreakPoint
//
//  Created by whde on 16/3/25.
//  Copyright © 2016年 whde. All rights reserved.
//

#import "ViewController.h"
#import "WhdeBreakPoint.h"
#import "WhdeFileManager.h"
@interface ViewController () {
    NSString *urlStr;
}
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
- (IBAction)start:(id)sender;
- (IBAction)pause:(id)sender;
- (IBAction)delete:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    urlStr = @"http://dlsw.baidu.com/sw-search-sp/soft/2a/25677/QQ_V4.1.1.1456905733.dmg";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
@end
