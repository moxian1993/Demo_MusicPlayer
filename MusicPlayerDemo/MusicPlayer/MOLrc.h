//
//  MOLrc.h
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/21.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MOLrcPart : NSObject

@property (nonatomic, assign) CGFloat unknown;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, copy) NSString *text;

@end


@interface MOLrcLine : NSObject

@property (nonatomic, assign) CGFloat beginTime;
@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, copy, readonly) NSArray <MOLrcPart *> *parts;
@property (nonatomic, copy, readonly) NSString *lineText;

@end


@interface MOLrc : NSObject

@property (nonatomic, copy, readonly) NSArray <MOLrcLine *> *lines;

- (instancetype)initWithLrc:(NSString *)lrc;

- (MOLrcLine *)findLineWithCurrentTime:(NSTimeInterval)currentTime;
@end

NS_ASSUME_NONNULL_END
