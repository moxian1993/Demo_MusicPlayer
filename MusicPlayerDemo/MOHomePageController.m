//
//  MOHomePageController.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/8.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOHomePageController.h"
#import "MONewFeatureController.h"

@interface MOHomePageController ()

@property (nonatomic, assign) BOOL isShowed;

@end

@implementation MOHomePageController

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.isShowed) {
        self.isShowed = YES;
        MONewFeatureController *featureVC = MONewFeatureController.new;
        [self presentViewController:featureVC animated:NO completion:nil];
    }
}

@end
