//
//  ExpandCell.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/23.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "ExpandCell.h"
#import "CGCExpandModel.h"

#import "XMGTopicVideoView.h"
#import "XMGTopicPictureView.h"

#import <AVFoundation/AVFoundation.h>

@interface ExpandCell ()


@end

@implementation ExpandCell{
    
    CGCExpandModel * _expand;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.headImg.layer.cornerRadius=25;
//    self.headImg.layer.masksToBounds=YES;
    self.shareBtn.layer.borderWidth=0.5;
    self.shareBtn.layer.borderColor=[UIColor blackColor].CGColor;
    self.shareBtn.layer.cornerRadius=4;
    self.shareBtn.layer.masksToBounds=YES;
    // Initialization code
}


- (XMGTopicPictureView *)pictureView
{
    DBSelf(weakSelf);
    if (!_pictureView) {
        XMGTopicPictureView *pictureView = [XMGTopicPictureView pictureView];
        [self.contentView addSubview:pictureView];
        pictureView.pBlock = ^(NSInteger index, NSString *imgStr) {
            if (weakSelf.picClick) {
                weakSelf.picClick(index, imgStr);
            }
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
        [self.contentView addSubview:videoView];
        videoView.sBlock = ^(UIButton *btn) {
            if (weakSelf.startBlock) {
                weakSelf.startBlock(btn);
            }
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"ExpandCell";
    ExpandCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
    }
    return cell;
    
}

- (void)setExpand:(CGCExpandModel *)expand{
    
    _expand=expand;
    
    //获取视频尺寸
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL URLWithString:expand.video]];
    NSArray *array = asset.tracks;
    CGSize videoSize = CGSizeZero;
    
    for (AVAssetTrack *track in array) {
        if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
            videoSize = track.naturalSize;
        }
    }
    
    
//    if (expand.url.length>0) {
         [self.headImg sd_setImageWithURL:[NSURL URLWithString:expand.salespicture] placeholderImage:[UIImage imageNamed:@"icon_default_head"]];
//    }else{
//         [self.headImg sd_setImageWithURL:[NSURL URLWithString:[expand.images firstObject]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
//    }
   
    self.titLab.text=expand.salesname;
    self.timeLab.text=expand.content;
    if ([expand.type intValue]==0) {
        self.pictureView.hidden = NO;
        self.pictureView.expand = expand;
        self.pictureView.frame = expand.pictureF;
        self.videoView.hidden = YES;
        self.pictureView.addressLabel.text = expand.addressName;
        //    self.timeLab.text=expand.time;
        self.pictureView.timeLabel.text = expand.time;
    }else if ([expand.type intValue]==1) {
        self.videoView.hidden = NO;
        self.videoView.expand = expand;
        self.videoView.frame = expand.videoF;
        self.videoView.startBtn.hidden=NO;
       
        self.pictureView.hidden = YES;
        self.videoView.addressLabel.text = expand.addressName;
        self.videoView.timeLabel.text = expand.time;
    }else if ([expand.type intValue]==3) {
        self.videoView.hidden = NO;
        self.videoView.expand = expand;
        self.videoView.frame = expand.videoF;
        self.videoView.startBtn.hidden=YES;
        self.pictureView.hidden = YES;
        self.videoView.addressLabel.text = expand.addressName;
        self.videoView.timeLabel.text = expand.time;
    }
    
}

@end
