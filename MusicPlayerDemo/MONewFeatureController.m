//
//  MONewFeatureController.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/17.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MONewFeatureController.h"
#import <AVFoundation/AVFoundation.h>

@interface MONewFeatureController ()

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, weak) UIButton *skipBtn;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MONewFeatureController

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}


- (void)setup {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"PPT90200" withExtension:@"mp4"];
    self.player = [AVPlayer playerWithURL:url];
    
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    layer.frame = self.view.bounds;
    [self.view.layer addSublayer:layer];
    [self.player play];
    
    UIButton *skipBtn = Button.str(@"5").fnt(13).bgColor(@"white").color(@"black").border(0.5,@"black").borderRadius(3).addTo(self.view).fixWH(60,30).makeCons(^{
        make.top.equal.superview.constants(15);
        make.right.equal.superview.constants(-20);
    }).onClick(^{
        [self dismissViewControllerAnimated:YES completion:^{
            self.player = nil;
        }];
    });
    skipBtn.userInteractionEnabled = NO;
    self.skipBtn = skipBtn;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    static NSInteger count = 5;
    __weak typeof(self) weak = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        count -= 1;
        if (count >= 1) {
            weak.skipBtn.str(@(count));
        } else {
            weak.skipBtn.str(@"跳过");
            weak.skipBtn.userInteractionEnabled = YES;
        }
    }];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

@end
