//
//  MOSong.h
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/8.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOLrc.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOSong : NSObject <YYModel>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *singer;
@property (nonatomic, copy) NSString *coverPath;
@property (nonatomic, copy) NSString *mp3Path;
@property (nonatomic, copy) NSString *lrcPath;

@property (nonatomic, strong) MOLrc *lrc;


@end

NS_ASSUME_NONNULL_END
