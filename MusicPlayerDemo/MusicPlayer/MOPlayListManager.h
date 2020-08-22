//
//  MOPlayListManager.h
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/8.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MOPlayList;

NS_ASSUME_NONNULL_BEGIN

@interface MOPlayListManager : NSObject

INTERFACE_SINGLETON(MOPlayListManager)

@property (nonatomic, copy, readonly) NSArray <MOPlayList *> *allPlayLists;

- (void)addPlayList:(MOPlayList *)playList;

- (void)removePlayListWithIndex:(NSInteger)index;
- (void)updatePlayListWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
