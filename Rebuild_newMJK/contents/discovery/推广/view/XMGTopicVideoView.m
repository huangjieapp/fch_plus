//
//  XMGTopicVideoView.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/23.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "XMGTopicVideoView.h"
#import "CGCExpandModel.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>


@interface XMGTopicVideoView()


@property (strong, nonatomic) AVPlayerItem *playerItem;

@end

static AVPlayer * video_player_;
static AVPlayerLayer *playerLayer_;
static UIButton *lastPlayBtn_;
static CGCExpandModel *lastTopicM_;
static NSTimer *avTimer_;
static UIProgressView *progress_;

@implementation XMGTopicVideoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)videoView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (IBAction)moreButtonAction:(UIButton *)sender {
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    [self.startBtn addTarget:self action:@selector(startClick:)];
    self.img.contentMode = UIViewContentModeScaleAspectFit;
    self.img.backgroundColor = [UIColor blackColor];
    
}

- (void)startClick:(UIButton *)btn{
//    [self play:btn];
    if (self.sBlock) {
        self.sBlock(btn);
    }
    
}

- (void)setFrame:(CGRect)frame {
    frame.size.width = KScreenWidth;
    [super setFrame:frame];
}

- (void)setExpand:(CGCExpandModel *)expand{
    if ([expand.type intValue]==3) {
        [self.img sd_setImageWithURL:[NSURL URLWithString:[expand.images firstObject]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }else{
         [self.img sd_setImageWithURL:[NSURL URLWithString:expand.poster] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
   
    
}


- (void)play:(UIButton *)playBtn {
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion integerValue] < 9) {
        MPMoviePlayerViewController *movieVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:self.expand.video]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentMoviePlayerViewControllerAnimated:movieVC];
    }else{
        playBtn.selected = !playBtn.isSelected;
        lastPlayBtn_.selected = !lastPlayBtn_.isSelected;
        if (lastTopicM_ != self.expand) {
            [playerLayer_ removeFromSuperlayer];
            self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.expand.video]];
            [video_player_ replaceCurrentItemWithPlayerItem:self.playerItem];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(playerItemDidReachEnd:)
                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                       object:self.playerItem];
            
            playerLayer_.frame = self.expand.videoF;
            progress_.frame = CGRectMake(playerLayer_.frame.origin.x, CGRectGetMaxY(playerLayer_.frame), playerLayer_.frame.size.width, 2);
            [self.layer addSublayer:playerLayer_];
            
            progress_.progress = 0;
            [video_player_ play];
            [avTimer_ setFireDate:[NSDate date]];
            lastTopicM_.videoPlaying = NO;
            self.expand.videoPlaying = YES;
            [lastPlayBtn_ setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
            [playBtn setImage:[UIImage imageNamed:@"playButtonPause"] forState:UIControlStateNormal];
        }else{
            if(lastTopicM_.videoPlaying){
                [video_player_ pause];
                [avTimer_ setFireDate:[NSDate distantFuture]];
                self.expand.videoPlaying = NO;
                [playBtn setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
            }else{
                playerLayer_.frame = self.expand.videoF;
                progress_.frame = CGRectMake(playerLayer_.frame.origin.x, CGRectGetMaxY(playerLayer_.frame), playerLayer_.frame.size.width, 2);
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(playerItemDidReachEnd:)
                                                             name:AVPlayerItemDidPlayToEndTimeNotification
                                                           object:self.playerItem];
                [self.layer addSublayer:playerLayer_];
                
                [video_player_ play];
                [avTimer_ setFireDate:[NSDate date]];
                self.expand.videoPlaying = YES;
                [playBtn setImage:[UIImage imageNamed:@"playButtonPause"] forState:UIControlStateNormal];
            }
        }
        
        lastTopicM_ = self.expand;
        lastPlayBtn_ = playBtn;
     
    }
}

-(void) playerItemDidReachEnd:(AVPlayerItem *)playerItem{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    lastTopicM_.videoPlaying = NO;
    self.expand.videoPlaying = NO;
    [lastPlayBtn_ setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
    [self.startBtn setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
    [video_player_ pause];
    [video_player_ seekToTime:kCMTimeZero];
    [playerLayer_ removeFromSuperlayer];
    progress_.hidden = !self.expand.videoPlaying;
    progress_.progress = 0;
}

-(void)dealloc{
    [video_player_ pause];
    [playerLayer_ removeFromSuperlayer];
    lastTopicM_.videoPlaying = NO;
    [lastPlayBtn_ setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    //[avTimer_ invalidate];
    //avTimer_= nil;
}




@end
