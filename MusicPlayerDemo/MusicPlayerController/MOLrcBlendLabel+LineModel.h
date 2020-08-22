//
//  MOLrcBlendLabel+LineModel.h
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/24.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOLrcBlendLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOLrcBlendLabel (LineModel)

@property (nonatomic, strong) MOLrcLine *line;

@property (nonatomic, assign, readonly) CGFloat beginTime;
@property (nonatomic, assign, readonly) CGFloat endTime;

@end

NS_ASSUME_NONNULL_END
