//
//  MONotificationName.h
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/21.
//  Copyright © 2020 Mo. All rights reserved.
//

#ifndef MONotificationName_h
#define MONotificationName_h

#define NotificationCenter                              ([NSNotificationCenter defaultCenter])

/** 播放器状态改变 播放/暂停 */
#define kMusicPlayerStatus                              @"kMusicPlayerStatus"
#define MOMusicPlayerStatusDidChangedNotification       @"MOMusicPlayerStatusDidChangedNotification"

/** 歌曲变更 */
#define kMusicPlayerCurrentSong                         @"kMusicPlayerCurrentSong"
#define MOMusicPlayerCurrentSongDidChangedNotification  @"MOMusicPlayerCurrentSongDidChangedNotification"

/** 时间进度 */
#define kCurrentTime                                    @"kCurrentTime"
#define kTotalTime                                      @"kTotalTime"
#define MOMusicPlayerCurrentTimeDidChangedNotification  @"MOMusicPlayerCurrentTimeDidChangedNotification"

/** -------------------------------------------------- */



#endif /* MONotificationName_h */
