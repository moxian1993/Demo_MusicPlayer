//
//  MOMusicPanelSongView.h
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/21.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MOMusicPanelSongView : UIView

@property (nonatomic, copy) void(^playBtnDidClickedBlock)(void);
@property (nonatomic, copy) void(^preBtnDidClickedBlock)(void);
@property (nonatomic, copy) void(^nextBtnDidClickedBlock)(void);
@property (nonatomic, copy) void(^sliderValueChangedBlock)(CGFloat value);

- (void)refreshUIWithPlayerStatus:(MOMusicPlayerStatus)status;
- (void)refreshUIWithSong:(MOSong *)song;
- (void)refreshUIWithCurrentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime;

- (void)startRotation;
- (void)stopRotation;
@end

NS_ASSUME_NONNULL_END
