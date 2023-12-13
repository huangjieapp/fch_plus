//
//  KSPhotoBrowser.h
//  KSPhotoBrowser
//
//  Created by Kyle Sun on 12/25/16.
//  Copyright © 2016 Kyle Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSPhotoItem.h"
#import "KSYYImageManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MJKPhotoBrowserInteractiveDismissalStyle) {
    MJKPhotoBrowserInteractiveDismissalStyleRotation,
    MJKPhotoBrowserInteractiveDismissalStyleScale,
    MJKPhotoBrowserInteractiveDismissalStyleSlide,
    MJKPhotoBrowserInteractiveDismissalStyleNone
};

typedef NS_ENUM(NSUInteger, MJKPhotoBrowserBackgroundStyle) {
    MJKPhotoBrowserBackgroundStyleBlurPhoto,
    MJKPhotoBrowserBackgroundStyleBlur,
    MJKPhotoBrowserBackgroundStyleBlack
};

typedef NS_ENUM(NSUInteger, MJKPhotoBrowserPageIndicatorStyle) {
    MJKPhotoBrowserPageIndicatorStyleDot,
    MJKPhotoBrowserPageIndicatorStyleText
};

typedef NS_ENUM(NSUInteger, MJKPhotoBrowserImageLoadingStyle) {
    MJKPhotoBrowserImageLoadingStyleIndeterminate,
    MJKPhotoBrowserImageLoadingStyleDeterminate
};

@protocol KSPhotoBrowserDelegate, KSImageManager;
@interface MJKPhotoBrowser : UIViewController

@property (nonatomic, assign) MJKPhotoBrowserInteractiveDismissalStyle dismissalStyle;
@property (nonatomic, assign) MJKPhotoBrowserBackgroundStyle backgroundStyle;
@property (nonatomic, assign) MJKPhotoBrowserPageIndicatorStyle pageindicatorStyle;
@property (nonatomic, assign) MJKPhotoBrowserImageLoadingStyle loadingStyle;
@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, weak) id<KSPhotoBrowserDelegate> delegate;

+ (instancetype)browserWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems selectedIndex:(NSUInteger)selectedIndex;
- (instancetype)initWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems selectedIndex:(NSUInteger)selectedIndex;
- (void)showFromViewController:(UIViewController *)vc;
+ (void)setImageManagerClass:(Class<KSImageManager>)cls;

/** 上滑返回*/
@property (nonatomic, copy) void(^swipeUpActionBlock)(void);

@end

@protocol KSPhotoBrowserDelegate <NSObject>

- (void)ks_photoBrowser:(MJKPhotoBrowser *)browser didSelectItem:(KSPhotoItem *)item atIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
