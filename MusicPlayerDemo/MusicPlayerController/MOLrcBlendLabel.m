//
//  MOLrcBlendLabel.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/23.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOLrcBlendLabel.h"

@interface MOLrcBlendLabel ()

@property (nonatomic, assign) BOOL canTint;
@property (nonatomic, assign) CGFloat tintPercent;
@end


@implementation MOLrcBlendLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _canTint = NO;
        _tintPercent = 0.0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // 保留原始工作不变
    [super drawRect:rect];

    // 设置默认颜色
    UIColor *originalColor = self.textColor ?: UIColor.whiteColor;
    UIColor *tintColor = _highlightedColor ?: UIColor.blackColor;
    
    UIColor *color = _canTint? tintColor: originalColor;
    CGFloat width = _canTint? self.bounds.size.width *_tintPercent : 0;
    
    CGRect tintRect = CGRectMake(0, 0, width, self.bounds.size.height);
    // 注意先设置颜色再渲染
    [color set];
    UIRectFillUsingBlendMode(tintRect, kCGBlendModeSourceIn);
}

- (void)tintPercent:(CGFloat)percent {
    _tintPercent = percent;
    [self setNeedsDisplay];
}

- (void)canTint:(BOOL)canTint {
    _canTint = canTint;
    [self setNeedsDisplay];
}

@end
