//
//  MOThemeManager.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/8.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOThemeManager.h"

@implementation MOThemeManager
IMPLEMENTATION_SINGLETON(MOThemeManager)

- (NSString *)localizedStringWithKey:(NSString *)key {
    return NSLocalizedStringFromTable(key, @"LocalizedFile", @"");
}

- (UIImage *)imageName:(NSString *)imageName {
    UIImage *image = [[UIImage imageNamed:imageName] imageWithTintColor:WheatColor];
    return image;
}

@end
