//
//  MOMusicPlayer.h
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/8.
//  Copyright © 2020 Mo. All rights reserved.
//

#define MusicPlayer ([MOMusicPlayer sharedInstance])

#import <Foundation/Foundation.h>
#import "MOSong.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MOMusicPlayerStatus) {
    MOMusicPlayerStatusPlaying,
    MOMusicPlayerStatusPause,
};

@interface MOMusicPlayer : NSObject

INTERFACE_SINGLETON(MOMusicPlayer)

@property (nonatomic, copy) NSArray <MOSong *> *songs;
@property (nonatomic, strong, readonly) MOSong *currentSong;
@property (nonatomic, assign) MOMusicPlayerStatus status;

@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign, readonly) NSTimeInterval totalTime;

- (void)play;
- (void)pause;
- (void)previous;
- (void)next;

@end

NS_ASSUME_NONNULL_END
