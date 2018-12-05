//
//  WhdeNetworkService.m
//  BreakPoint
//
//  Created by OS on 2018/12/4.
//  Copyright © 2018 whde. All rights reserved.
//

#import "WhdeNetworkService.h"
@implementation WhdeNetworkService
+ (NSString *)format:(long long int)rate {
    NSString *s;
    if (rate <1024) {
        s = [NSString stringWithFormat:@"%lldB", rate];
    } else if (rate >=1024&& rate <1024*1024) {
        s = [NSString stringWithFormat:@"%.1fKB", (double)rate /1024];
    } else if (rate >=1024*1024&& rate <1024*1024*1024) {
        s = [NSString stringWithFormat:@"%.2fMB", (double)rate / (1024*1024)];
    } else {
        s = [NSString stringWithFormat:@"%.1fGB", (double)rate / (1024 * 1024 * 1024)];
    }
    return s;
}
@end
