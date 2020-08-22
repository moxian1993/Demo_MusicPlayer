//
//  MOPlayList.h
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/8.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MOSong;
NS_ASSUME_NONNULL_BEGIN

@interface MOPlayList : NSObject <YYModel>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray <MOSong *> *allSongs;

- (void)addSong:(MOSong *)song;

- (void)removeSongAtIndex:(NSInteger)index;
- (void)updateSongAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
