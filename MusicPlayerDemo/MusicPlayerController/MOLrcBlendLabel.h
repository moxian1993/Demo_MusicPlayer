//
//  MOLrcBlendLabel.h
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/23.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MOLrcBlendLabel : UILabel

/** 着色颜色 */
@property (nonatomic, strong) UIColor *highlightedColor;

/// 是否进行着色
/// @param canTint yes:着色 no：还原
- (void)canTint:(BOOL)canTint;

/// 着色区域百分比
/// @param percent 着色区域占整个label宽度的百分比
- (void)tintPercent:(CGFloat)percent;

@end

NS_ASSUME_NONNULL_END
