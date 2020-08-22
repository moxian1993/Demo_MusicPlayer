//
//  MOPlayList.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/8.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOPlayList.h"
#import "MOSong.h"

@implementation MOPlayList

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"allSongs": @"songs"};
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"allSongs": MOSong.class};
}

@end
