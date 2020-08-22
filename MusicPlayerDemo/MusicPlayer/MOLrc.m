//
//  MOLrc.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/21.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOLrc.h"
#import "NSString+Substring.h"

@implementation MOLrcPart

- (instancetype)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        self.unknown = [[string substringWithinBoundsLeft:@"(" right:@","] floatValue];
        self.duration = [[string substringWithinBoundsLeft:@"," right:@")"] floatValue];
        NSRange range = [string rangeOfString:@")"];
        self.text = [string substringFromIndex:range.location +1];
    }
    return self;
}

- (NSString *)description {
    NSMutableString *desc = NSMutableString.string;
    [desc appendFormat:@"\"%@\" 耗时:%f", self.text, self.duration];
    return desc.copy;
}

@end


@interface MOLrcLine ()

@property (nonatomic, copy) NSArray <MOLrcPart *> *parts;
@property (nonatomic, copy) NSString *lineText;
@end

@implementation MOLrcLine

- (instancetype)initWithLineString:(NSString *)lineString {
    if (self = [super init]) {
        /** [410,2755](0,350)庄(0,250)心(0,300)妍(0,250)-(0,355)后(0,300)来(0,350)才(0,250)发(0,350)现 */
        NSString *frontPart = [lineString substringWithinBoundsLeft:@"[" right:@"]"];
        NSRange range = [frontPart rangeOfString:@","];
        self.beginTime = [[frontPart substringToIndex:range.location] floatValue];
        self.duration = [[frontPart substringFromIndex:range.location +1] floatValue];
        
        NSString *pattern = @"\\([\\d]+,[\\d]+\\)[\\w\\-\\s]+";
        NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
        
        NSArray <NSTextCheckingResult *>*matchs = [exp matchesInString:lineString options:NSMatchingReportProgress range:NSMakeRange(0, lineString.length)];
        
        NSMutableArray *parts = NSMutableArray.array;
        for (NSTextCheckingResult *result in matchs) {
            NSString *string = [lineString substringWithRange:result.range];
            MOLrcPart *part = [[MOLrcPart alloc] initWithString:string];
            [parts addObject:part];
        }
        self.parts = parts.copy;
    }
    return self;
}

- (NSString *)lineText {
    if (!_lineText) {
        NSMutableString *text = NSMutableString.string;
        for (MOLrcPart *part in self.parts) {
            [text appendString: part.text];
        }
        _lineText = text.copy;
    }
    return _lineText;
}

- (NSString *)description {
    NSMutableString *desc = NSMutableString.string;
    [desc appendString:[super description]];
    [desc appendFormat:@"\n行开始时间：%f\n行耗时：%f\n", self.beginTime, self.duration];
    for (MOLrcPart *part in self.parts) {
        [desc appendFormat:@"%@\n", part];
    }
    return desc.copy;
}

@end


@interface MOLrc ()

@property (nonatomic, copy) NSArray <MOLrcLine *> *lines;
@end

@implementation MOLrc

- (instancetype)initWithLrc:(NSString *)lrc {
    if (self = [super init]) {
        NSArray *components = [lrc componentsSeparatedByString:@"\n"];
        
        NSMutableArray *lines = NSMutableArray.array;
        for (NSString *string in components) {
            
            MOLrcLine *line = [[MOLrcLine alloc] initWithLineString:string];
            [lines addObject:line];
        }
        self.lines = lines.copy;
    }
//    NSLog(@"%@", self);
    return self;
}

- (MOLrcLine *)findLineWithCurrentTime:(NSTimeInterval)currentTime {
    for (MOLrcLine *line in self.lines) {
        CGFloat beginTime = line.beginTime;
        CGFloat endTime = line.beginTime + line.duration;
        if (currentTime >= beginTime && currentTime <= endTime) {
            return line;
        }
    }
    return nil;
}


- (NSString *)description {
    NSMutableString *desc = NSMutableString.string;
    [desc appendFormat:@"\n%@\n",[super description]];
    for (MOLrcLine *line in self.lines) {
        [desc appendFormat:@"%@\n\n\n", line];
    }
    return desc.copy;
}
@end
