//
//  RITLPhotosConfiguration.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/5/17.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosConfiguration.h"


@implementation RITLPhotosConfiguration

- (instancetype)init
{
    if (self = [super init]) {

        self.maxCount = 9;
        self.containVideo = true;
        self.hiddenGroupWhenNoPhotos = false;
    }
    
    return self;
}


+ (instancetype)defaultConfiguration
{
    static __weak RITLPhotosConfiguration *instance;
    RITLPhotosConfiguration *strongInstance = instance;
    @synchronized(self){
        if (strongInstance == nil) {
            strongInstance = self.new;
            instance = strongInstance;
        }
    }
    return strongInstance;
}


- (NSInteger)maxCount
{
    return MAX(0,_maxCount);
}

- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    if (imageArray.count > 0) {
        if (imageArray.count < 9) {
            self.maxCount = 9 - imageArray.count;
        }
    }
    
}

- (void)dealloc
{
    NSLog(@"[%@] is dealloc",NSStringFromClass(self.class));
}

@end
