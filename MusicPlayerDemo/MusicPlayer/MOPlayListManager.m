//
//  MOPlayListManager.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/8.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOPlayListManager.h"
#import "MOPlayList.h"

@interface MOPlayListManager ()

@property (nonatomic, copy) NSArray <MOPlayList *> *allPlayLists;
@end

@implementation MOPlayListManager

IMPLEMENTATION_SINGLETON(MOPlayListManager)

- (instancetype)init {
    if (self = [super init]) {
        [self loadData];
    }
    return self;
}

- (void)loadData {
    
    NSURL *mainBundleURL = NSBundle.mainBundle.bundleURL;
    NSBundle *musicBundle = [NSBundle bundleWithURL: [mainBundleURL URLByAppendingPathComponent:@"music.bundle"]];
    
    NSURL *url = [musicBundle URLForResource:@"playlists" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSArray <MOPlayList *> *array = [NSArray yy_modelArrayWithClass:MOPlayList.class json:jsonArray];
    
    self.allPlayLists = array;
}



@end
