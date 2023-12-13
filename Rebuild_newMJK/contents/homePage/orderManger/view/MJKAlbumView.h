//
//  MJKAlbumView.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/16.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJKAlbumViewDelegate <NSObject>
- (NSInteger)numberOfImageCount;
- (NSArray *)imageDataArrayWithIndexPath;
@end;

@interface MJKAlbumView : UIView
@property (nonatomic, weak) id<MJKAlbumViewDelegate>delegate;
@property (nonatomic, assign) NSInteger row;
- (void)reloadData;
@end
