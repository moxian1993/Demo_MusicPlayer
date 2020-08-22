//
//  MOLrcBlendLabel+LineModel.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/24.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOLrcBlendLabel+LineModel.h"

const void *key = @"line";

@implementation MOLrcBlendLabel (LineModel)

- (void)setLine:(MOLrcLine *)line {
    objc_setAssociatedObject(self, key, line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MOLrcLine *)line {
    return objc_getAssociatedObject(self, key);
}

- (CGFloat)beginTime {
    return self.line.beginTime;
}

- (CGFloat)endTime {
    return (self.line.beginTime + self.line.duration);
}

@end
