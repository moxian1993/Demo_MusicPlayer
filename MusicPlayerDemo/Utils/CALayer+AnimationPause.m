//
//  CALayer+AnimationPause.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/21.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "CALayer+AnimationPause.h"

@implementation CALayer (AnimationPause)

- (void)pauseAnimation {
    /**
     取出当前时间,转成动画暂停的时间
     设置动画运行速度为0
     设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
     */
    CFTimeInterval pasuedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed = 0.0;
    self.timeOffset = pasuedTime;
}


- (void)resumeAnimation {
    /**
     获取暂停的时间差
     用现在的时间减去时间差,就是之前暂停的时间,从之前暂停的时间开始动画
     */
    CFTimeInterval pausedTime = self.timeOffset;
    self.speed = 1.0;
    self.timeOffset = 0.0;
    self.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.beginTime = timeSincePause;
}

@end
