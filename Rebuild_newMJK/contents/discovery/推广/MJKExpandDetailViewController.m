//
//  MJKExpandDetailViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/18.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKExpandDetailViewController.h"
#import "MJKExpandPictureViewController.h"

#import "CGCExpandModel.h"

#import "MJKExpandDetailView.h"

#import "XMGTopicVideoView.h"

#import "CLPlayerView.h"
@interface MJKExpandDetailViewController ()
@end

@implementation MJKExpandDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"素材详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
}

- (void)configUI {
    if ([self.model.type isEqualToString:@"0"] || [self.model.type isEqualToString:@"2"]) {
//        NSInteger number = self.model.images.count;
//        CGFloat x=10;
//
//        CGFloat w=(WIDE-70 - 60)/3;
//        CGFloat h=w;
//        CGFloat height = (h + x) * (number % 3 == 0 ? number / 3 : (number / 3 + 1));
//
//        self.model.cellHeight += height;
       
    } else {
        MJKExpandDetailView *detailView = [[MJKExpandDetailView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, self.model.cellHeight) andDetailModel:self.model];
        [self.view addSubview:detailView];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[MJKExpandDetailView class]]) {
            MJKExpandDetailView *detailView = (MJKExpandDetailView *)subView;
            [detailView.videoView removeFromSuperview];
            for (UIView *subsubView in detailView.subviews) {
                if ([subsubView isKindOfClass:[CLPlayerView class]]) {
                    CLPlayerView *playView = (CLPlayerView *)subsubView;
                    [playView pausePlay];
                    [playView destroyPlayer];
                }
            }
        }
    }
    
}


@end
