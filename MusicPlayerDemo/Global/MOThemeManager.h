//
//  MOThemeManager.h
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/8.
//  Copyright © 2020 Mo. All rights reserved.
//

#define _ThemeManager ([MOThemeManager sharedInstance])

#define LANGUAGE(__KEY__)   ([_ThemeManager localizedStringWithKey:(__KEY__)])
#define IMAGE(__NAME__)     ([_ThemeManager imageName: (__NAME__)])

#define Theme_ButtonColor       WheatColor
#define Theme_TextColorString   @"0xF5DEB3"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface MOThemeManager : NSObject

INTERFACE_SINGLETON(MOThemeManager)

- (NSString *)localizedStringWithKey:(NSString *)key;
- (UIImage *)imageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
