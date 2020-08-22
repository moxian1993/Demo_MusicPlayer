//
//  MOMusicPanelSongView.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/21.
//  Copyright © 2020 Mo. All rights reserved.
//

#define kAnimationKey   @"Rotation"

#import "MOMusicPanelSongView.h"
#import "CALayer+AnimationPause.h"

@interface MOMusicPanelSongView ()

@property (nonatomic, weak) UIImageView *coverImgView;
@property (nonatomic, weak) UILabel *titleLab;
@property (nonatomic, weak) UILabel *singerLab;
//@property (nonatomic, weak) UILabel *lrcLab;
@property (nonatomic, weak) UIButton *playBtn;

@property (nonatomic, weak) UILabel *currentTimeLab;
@property (nonatomic, weak) UILabel *totalTimeLab;
@property (nonatomic, weak) UISlider *slider;

@end

@implementation MOMusicPanelSongView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UIImageView *coverImgView = ImageView.fixWH(250, 250).img(@"white").borderRadius(125);
    self.coverImgView = coverImgView;
    
    UILabel *titleLab = Label.color(@"white").fnt(20);
    self.titleLab = titleLab;
    
    UILabel *singerLab = Label.color(@"white").fnt(15);
    self.singerLab = singerLab;
    
    UISlider *slider = [[UISlider alloc] init];
    [slider setMinimumTrackTintColor:Theme_ButtonColor];
    [slider setThumbImage:Img(IMAGE(@"slider-block")) forState:UIControlStateNormal];
    [slider addTarget:self action:@selector(sliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.slider = slider;
    
    CGSize size = [@"00:00" sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    UILabel *currentTimeLab = Label.fnt(14).str(@"00:00").fixWidth(size.width).color(@"white");
    UILabel *totalTimeLab = Label.fnt(14).str(@"00:00").fixWidth(size.width).color(@"white");
    self.currentTimeLab = currentTimeLab;
    self.totalTimeLab = totalTimeLab;
    
    NERStack *sliderStack = HorStack(currentTimeLab, @(10), slider, @(10), totalTimeLab);
    
    UIButton *preBtn = Button.img(IMAGE(@"btn_pre_normal")).onClick(^{
        if (self.preBtnDidClickedBlock) {
            self.preBtnDidClickedBlock();
        }
    });
    
    UIButton *playBtn = Button.img(IMAGE(@"btn_play_normal")).selectedImg(IMAGE(@"btn_pause_normal")).onClick(^{
        if (self.playBtnDidClickedBlock) {
            self.playBtnDidClickedBlock();
        }
    });
    self.playBtn = playBtn;
    
    UIButton *nextBtn = Button.img(IMAGE(@"btn_next_normal")).onClick(^{
        if (self.nextBtnDidClickedBlock) {
            self.nextBtnDidClickedBlock();
        }
    });
    
    NERStack *bottomStack = HorStack(NERSpring, preBtn, @(30), playBtn, @(30), nextBtn, NERSpring);
    
    CGFloat width = Screen.width -40;
    NERStack *coverStack = HorStack(NERSpring,coverImgView,NERSpring).fixWH(width, width);
    VerStack(coverStack,
             NERSpring,
             titleLab, @(15), singerLab,@(20),
             sliderStack, @(20),
             bottomStack).embedIn(self, 0, 20, 40, 20);
}


#pragma mark - target
- (void)sliderValueDidChanged:(UISlider *)slider {
    if (self.sliderValueChangedBlock) {
        self.sliderValueChangedBlock(slider.value);
    }
}

- (void)refreshUIWithPlayerStatus:(MOMusicPlayerStatus)status {
    self.playBtn.selected = status == MOMusicPlayerStatusPlaying;
    if (status == MOMusicPlayerStatusPlaying) {
        // 若歌曲已经在播放，进入控制器立即 startRotation 是无效的
        // 原因：vc modal方式的动画 与 核心动画 内部有冲突
        [self startRotation];
    } else {
        [self stopRotation];
    }
}

- (void)refreshUIWithSong:(MOSong *)song {
    UIImage *coverImage = [UIImage imageWithContentsOfFile:song.coverPath];
    _coverImgView.image = coverImage;
    _titleLab.text = song.name;
    _singerLab.text = song.singer;
}

- (void)refreshUIWithCurrentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    NSDateFormatter *formatter = NSDateFormatter.new;
    formatter.dateFormat = @"mm:ss";
    
    self.currentTimeLab.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:currentTime]];
    self.totalTimeLab.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:totalTime]];
    self.slider.value = currentTime / totalTime;
}





#pragma mark - animation
- (void)startRotation {
    CALayer *layer = self.coverImgView.layer;
    CABasicAnimation *animation = [layer animationForKey:kAnimationKey];
    
    // pasue
    if (animation && layer.speed == 0) {
        [layer resumeAnimation];
        return;
    }
    
    //new、pre、next
    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(M_PI *2);
    animation.duration = 20;
    animation.repeatCount = CGFLOAT_MAX;
    [layer addAnimation:animation forKey:kAnimationKey];
}

- (void)stopRotation {
    CAAnimation *animation = [self.coverImgView.layer animationForKey:kAnimationKey];
    if (animation) {
        [self.coverImgView.layer pauseAnimation];
    }
}

- (void)dealloc {
    [self.coverImgView.layer removeAllAnimations];
}

@end
