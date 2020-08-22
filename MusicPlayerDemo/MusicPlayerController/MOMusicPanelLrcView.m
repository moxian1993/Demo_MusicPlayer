//
//  MOMusicPanelLrcView.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/21.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOMusicPanelLrcView.h"
#import "MOLrcBlendLabel.h"
#import "MOLrcBlendLabel+LineModel.h"

@interface MOMusicPanelLrcView () <UIScrollViewDelegate>

@property (nonatomic, weak) UILabel *titleLab;
@property (nonatomic, weak) UILabel *singerLab;
@property (nonatomic, weak) UIButton *playBtn;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *containerView;

@property (nonatomic, weak) MOLrcBlendLabel *currentLabel;

@end

@implementation MOMusicPanelLrcView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    UILabel *titleLab = Label.color(@"white").fnt(22);
    self.titleLab = titleLab;
    
    UILabel *singerLab = Label.color(@"white").fnt(15);
    self.singerLab = singerLab;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.alwaysBounceVertical = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    self.scrollView = scrollView;
    
    UIButton *playBtn = Button.img(IMAGE(@"btn_play_normal")).selectedImg(IMAGE(@"btn_pause_normal")).onClick(^{
        if (self.playBtnDidClickedBlock) {
            self.playBtnDidClickedBlock();
        }
    }).touchInsets(-10,-10,-10,-10).fixWH(30,30);
    self.playBtn = playBtn;
    
    VerStack(titleLab, @(10),
             singerLab, @(10),
             HorStack(scrollView).lowHugging,
             @(15),
             HorStack(NERSpring, playBtn)
             ).embedIn(self, 0,25,20, 25);
    
    UIView *containerView = View.embedIn(scrollView).makeCons(^{
        make.width.equal.superview.constants(0);
    });
    self.containerView = containerView;
}

- (void)refreshUIWithPlayerStatus:(MOMusicPlayerStatus)status {
    self.playBtn.selected = status == MOMusicPlayerStatusPlaying;
}


- (void)refreshUIWithSong:(MOSong *)song {
    _titleLab.text = song.name;
    _singerLab.text = song.singer;
    [self createLrcPanelWithSong:song];
}


- (void)refreshUIWithCurrentTime:(NSTimeInterval)currentTime {
    // 由当前时间取得对应 label
    MOLrcBlendLabel *label = [self locateLabelWithCurrentTime:currentTime];
    if (!label) return;
    
    // 刚结束的上句
    if (self.currentLabel && label != self.currentLabel) {
        // 重置 label 状态
        self.currentLabel.font = [UIFont systemFontOfSize:15];
        [self.currentLabel canTint:NO];
        // 移至下句
        [_scrollView setContentOffset:CGPointMake(0, label.frame.origin.y - _scrollView.contentInset.top) animated:YES];
    }
    
    // 歌词行字体放大并标识可以进行着色
    label.font = [UIFont systemFontOfSize:20];
    [label canTint:YES];
    
    // 歌词着色
    CGFloat lineDuration = label.line.duration;  // 整行时长
    CGFloat lapsed = currentTime - label.beginTime; // 在行内流逝的时间
    CGFloat percent = 0; // 着色百分比
    for (MOLrcPart *part in label.line.parts) {
        if (lapsed - part.duration >= 0) {
            // 整字部分
            percent += part.duration  / lineDuration;
            lapsed -= part.duration;
        } else {
            // 剩余部分
            percent += lapsed / lineDuration;
            break;
        };
    }
    [label tintPercent:percent];
    self.currentLabel = label;
}

/** 由当前时间定为到对应label */
- (MOLrcBlendLabel *)locateLabelWithCurrentTime:(NSTimeInterval)currentTime {
    for (MOLrcBlendLabel *label in self.containerView.subviews) {
        if (![label isKindOfClass:MOLrcBlendLabel.class]) continue;
        if (currentTime >= label.beginTime && currentTime <= label.endTime) {
            return label;
        };
    }
    return nil;
}


- (void)createLrcPanelWithSong:(MOSong *)song {
    [self.containerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    NSMutableArray <MOLrcBlendLabel *> *labels = NSMutableArray.array;
    for (MOLrcLine *line in song.lrc.lines) {
        MOLrcBlendLabel *label = MOLrcBlendLabel.new;
        label.text  = line.lineText;
        label.textColor = UIColor.whiteColor;
        label.highlightedColor = WheatColor;
        label.font = [UIFont systemFontOfSize:15];
        label.line = line;
        
        [self.containerView addSubview: label];
        [labels addObject:label];
    }
    
    CGFloat labelHeight = 30.0;
    [labels enumerateObjectsUsingBlock:^(MOLrcBlendLabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            obj.makeCons(^{
                make.top.left.equal.superview.constants(0);
                make.height.equal.constants(labelHeight);
            });
        } else {
            UILabel *prevLab = labels[idx-1];
            obj.makeCons(^{
                make.left.equal.superview.constants(0);
                make.top.equal.view(prevLab).bottom.constants(10);
                make.height.equal.constants(labelHeight);
            });
        }
    }];
    
    self.containerView.makeCons(^{
        make.bottom.equal.view(labels.lastObject).constants(0);
    });
    
    [self layoutIfNeeded];
    
    CGFloat topOffset = 50;
    CGFloat bottomOffset = _scrollView.h - topOffset - labelHeight;
    _scrollView.contentInset = UIEdgeInsetsMake(topOffset , 0, bottomOffset, 0);
    [_scrollView setContentOffset:CGPointMake(0, -_scrollView.contentInset.top)];

#ifdef Auxiliary
    // 歌词辅助线
    CGFloat auxiliaryLineOffset = topOffset + labelHeight/2;
    View.bgColor(@"red").addTo(self).makeCons(^{
        make.height.equal.constants(2);
        make.left.right.equal.superview.constants(0);
        make.centerY.equal.view(self->_scrollView).top.constants(auxiliaryLineOffset);
    });
#endif
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"-----%@", NSStringFromCGPoint(scrollView.contentOffset));
}

@end
