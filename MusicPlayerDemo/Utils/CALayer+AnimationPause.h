//
//  CALayer+AnimationPause.h
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/21.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (AnimationPause)

/** 暂停动画 */
- (void)pauseAnimation;

/** 恢复动画 */
- (void)resumeAnimation;

@end

NS_ASSUME_NONNULL_END
