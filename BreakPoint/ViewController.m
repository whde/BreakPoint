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
#import "WhdeNetworkService.h"
@interface ViewController () {
    NSString *urlStr;
    NSString *urlStr1;
}
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel1;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView1;
- (IBAction)start:(id)sender;
- (IBAction)pause:(id)sender;
- (IBAction)delete:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    urlStr = @"https://central.github.com/deployments/desktop/desktop/latest/darwin";
    urlStr1 = @"http://mac.yxdownload.com/bmc/VMwareFusionpro1012.dmg";
    self.progressView.progress = 0;
    self.progressView1.progress = 0;
    self.progressLabel.text = @"0%";
    self.progressLabel1.text = @"0%";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)start:(id)sender {
    __weak __typeof(self)weakSelf = self;
    [WhdeBreakPoint asynDownloadWithUrl:urlStr progressBlock:^(float progress, long long receiveByte, long long allByte, long long rate) {
        weakSelf.progressView.progress = progress;
        weakSelf.progressLabel.text = [NSString stringWithFormat:@"%d%%  %@/%@ %@ ", (int)(progress*100), [WhdeNetworkService format:receiveByte], [WhdeNetworkService format:allByte], [WhdeNetworkService format:rate]];
    } successBlock:^(NSString *filePath) {
        NSLog(@"%@", filePath);
    } failureBlock:^(NSString *filePath, NSError *error) {
        NSLog(@"%@\n%@", filePath, error);
    }];
    [WhdeBreakPoint asynDownloadWithUrl:urlStr1 progressBlock:^(float progress, long long receiveByte, long long allByte, long long rate) {
        weakSelf.progressView1.progress = progress;
        weakSelf.progressLabel1.text = [NSString stringWithFormat:@"%d%%  %@/%@ %@ ", (int)(progress*100), [WhdeNetworkService format:receiveByte], [WhdeNetworkService format:allByte], [WhdeNetworkService format:rate]];
    } successBlock:^(NSString *filePath) {
        NSLog(@"%@", filePath);
    } failureBlock:^(NSString *filePath, NSError *error) {
        NSLog(@"%@\n%@", filePath, error);
    }];
}

- (IBAction)pause:(id)sender {
    [WhdeBreakPoint pause:urlStr];
    [WhdeBreakPoint pause:urlStr1];
}

- (IBAction)delete:(id)sender {
    [WhdeFileManager deleteFile:[NSURL URLWithString:urlStr]];
    [WhdeFileManager deleteFile:[NSURL URLWithString:urlStr1]];
    self.progressView.progress = 0;
    self.progressView1.progress = 0;
    self.progressLabel.text = @"0%";
    self.progressLabel1.text = @"0%";
}
@end
