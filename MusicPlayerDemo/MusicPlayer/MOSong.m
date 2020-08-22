//
//  MOSong.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/8.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOSong.h"

@implementation MOSong


- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    NSString *bundlePath = NSBundle.mainBundle.resourcePath;
    
    self.coverPath = bundlePath.ap([self convertCorrectPath:dic[@"cover"]]);
    self.mp3Path = bundlePath.ap([self convertCorrectPath:dic[@"mp3"]]);
    self.lrcPath = bundlePath.ap([self convertCorrectPath:dic[@"lrc"]]);
    
    NSString *lrc = [NSString stringWithContentsOfFile:self.lrcPath encoding:NSUTF8StringEncoding error:nil];
    self.lrc = [MOLrc.alloc initWithLrc:lrc];
    
    return YES;
}

- (NSString *)convertCorrectPath:(NSString *)path {
    return path.subReplace(@"music", @"music.bundle");
}

@end
