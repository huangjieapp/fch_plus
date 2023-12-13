//
//  MJKExpandDetailView.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/18.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKExpandDetailView.h"
#import "CGCExpandModel.h"
#import "XMGTopicVideoView.h"
#import "XMGTopicPictureView.h"

#import "KSPhotoBrowser.h"
#import "KSPhotoItem.h"

#import <AVFoundation/AVFoundation.h>

#import "ZZBigView.h"

#import "CLPlayerView.h"

@interface MJKExpandDetailView ()
/** <#注释#>*/
@property (nonatomic, strong) CGCExpandModel *model;
/**CLplayer*/
@property (nonatomic, weak) CLPlayerView *playerView;
@end

@implementation MJKExpandDetailView

- (instancetype)initWithFrame:(CGRect)frame andDetailModel:(CGCExpandModel *)model {
    if (self = [super initWithFrame:frame]) {
        [self initUIWithModel:model];
        self.model = model;
    }
    return self;
}

- (void)initUIWithModel:(CGCExpandModel *)model {
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:model.salespicture] placeholderImage:[UIImage imageNamed:@"icon_default_head"]];
    [self addSubview:headImageView];
    
    
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame) + 10, CGRectGetMinY(headImageView.frame), 100, 20)];
    nameLabel.text = model.salesname;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:nameLabel];
    
    CGSize size = [model.content boundingRectWithSize:CGSizeMake(KScreenWidth - 90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame) + 10, CGRectGetMaxY(nameLabel.frame), KScreenWidth - 90, size.height + 10)];
    contentLabel.text = model.content;
    contentLabel.textColor = [UIColor darkGrayColor];
    contentLabel.font = [UIFont systemFontOfSize:14.f];
    contentLabel.numberOfLines = 0;
    [self addSubview:contentLabel];
    
    if ([model.type intValue]==0 || [model.type integerValue] == 2) {
        self.pictureView.hidden = NO;
        self.pictureView.expand = model;
        self.pictureView.frame = model.pictureF;
        self.videoView.hidden = YES;
        self.pictureView.addressLabel.text = model.addressName;
        //    self.timeLab.text=expand.time;
        self.pictureView.timeLabel.text = model.time;
    }else if ([model.type intValue]==1) {
        self.videoView.hidden = NO;
        self.videoView.expand = model;
        self.videoView.frame = model.videoF;
        self.videoView.startBtn.hidden=NO;
        
        self.pictureView.hidden = YES;
        self.videoView.addressLabel.text = model.addressName;
        self.videoView.timeLabel.text = model.time;
    }else if ([model.type intValue]==3) {
        self.videoView.hidden = NO;
        self.videoView.expand = model;
        self.videoView.frame = model.videoF;
        self.videoView.startBtn.hidden=YES;
        self.pictureView.hidden = YES;
        self.videoView.addressLabel.text = model.addressName;
        self.videoView.timeLabel.text = model.time;
    }
    
}

- (XMGTopicPictureView *)pictureView
{
    DBSelf(weakSelf);
    if (!_pictureView) {
        XMGTopicPictureView *pictureView = [XMGTopicPictureView pictureView];
        pictureView.moreButton.hidden = YES;
        [self addSubview:pictureView];
        pictureView.pBlock = ^(NSInteger index, NSString *imgStr) {
//            if (weakSelf.picClick) {
//                weakSelf.picClick(index, imgStr);
//            }
            ZZBigView *bigView=[[ZZBigView alloc]initWithFrame:CGRectMake(0, 0, WIDE, HIGHT) withURLs:self.model.images with:index];

            [bigView show];
            
        };
        _pictureView = pictureView;
    }
    return _pictureView;
}



- (XMGTopicVideoView *)videoView
{
    DBSelf(weakSelf);
    if (!_videoView) {
        XMGTopicVideoView *videoView = [XMGTopicVideoView videoView];
        videoView.mareButton.hidden = YES;
        [self addSubview:videoView];
        videoView.sBlock = ^(UIButton *btn) {
//            if (weakSelf.startBlock) {
//                weakSelf.startBlock(btn);
//            }
            [weakSelf cl_tableViewCellPlayVideoWithCell];
        };
        //        videoView.sBlock = ^{
        //            if (weakSelf.startBlock) {
        //                weakSelf.startBlock();
        //            }
        //        };
        _videoView = videoView;
    }
    return _videoView;
}

- (void)cl_tableViewCellPlayVideoWithCell {
    DBSelf(weakSelf);
    self.videoView.img.hidden = NO;
    //销毁播放器
    [_playerView destroyPlayer];
    
    //获取视频尺寸
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL URLWithString:self.model.video]];
    NSArray *array = asset.tracks;
    CGSize videoSize = CGSizeZero;
    
    for (AVAssetTrack *track in array) {
        if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
            videoSize = track.naturalSize;
        }
    }
    
    //    CGFloat width = (KScreenWidth - 70 - 60) / videoSize.height * videoSize.width;
    
    CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(70, self.model.videoF.origin.y, (KScreenWidth - 70 - 60), (KScreenWidth - 70 - 60))];
    playerView.videoFillMode = VideoFillModeResizeAspect;
    _playerView = playerView;
    [self addSubview:_playerView];
    //    //重复播放，默认不播放
    //    _playerView.repeatPlay = YES;
    //    //当前控制器是否支持旋转，当前页面支持旋转的时候需要设置，告知播放器
    //    _playerView.isLandscape = YES;
    //    //设置等比例全屏拉伸，多余部分会被剪切
    //    _playerView.fillMode = ResizeAspectFill;
    //设置进度条背景颜色
    _playerView.smallGestureControl=YES;
    _playerView.progressBackgroundColor = [UIColor colorWithRed:53 / 255.0 green:53 / 255.0 blue:65 / 255.0 alpha:1];
    //设置进度条缓冲颜色
    _playerView.mute=NO;
    _playerView.progressBufferColor = [UIColor grayColor];
    //设置进度条播放完成颜色
    _playerView.progressPlayFinishColor = [UIColor whiteColor];
    
    //    //全屏是否隐藏状态栏
    //    _playerView.fullStatusBarHidden = NO;
    //    //转子颜色
    //    _playerView.strokeColor = [UIColor redColor];
    //视频地址
    _playerView.url = [NSURL URLWithString:self.model.video];
    //播放
    [_playerView playVideo];
    self.videoView.img.hidden = YES;
    //返回按钮点击事件回调
    [_playerView destroyPlay:^{
        //        cell.stopPlay = YES;
        weakSelf.videoView.img.hidden = NO;
        NSLog(@"播放器被销毁了");
    }];
    [_playerView backButton:^(UIButton *button) {
        NSLog(@"返回按钮被点击");
    }];
    
    
    
    //播放完成回调
    [_playerView endPlay:^{
        weakSelf.videoView.img.hidden = NO;
        //销毁播放器
        [_playerView destroyPlayer];
        _playerView = nil;
        NSLog(@"播放完成");
    }];
}


@end
