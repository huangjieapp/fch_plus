//
//  RadioPlayView.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/25.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "RadioPlayView.h"
#import <AVFoundation/AVFoundation.h>

@interface RadioPlayView()
@property(nonatomic,strong)UILabel*titleLabel;
@property(nonatomic,strong)UIButton*playButton;  //播放中 play按钮   暂停中暂停按钮

@property(nonatomic,strong)NSString*urlStr;  //播放的地址
@property(nonatomic,strong)id  timeObserver;
@property(nonatomic,strong)UIProgressView*progressView;
@property(nonatomic,strong)AVPlayer*player;




@end

@implementation RadioPlayView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=KNaviColor;
        self.hidden=YES;
        
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-10-20, 5, 15, 15)];
//        button.backgroundColor=[UIColor redColor];
        [button setBackgroundImage:[UIImage imageNamed:@"icon_chop"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickDismiss)];
        [self addSubview:button];
        
        
        self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 5, KScreenWidth-80, 15)];
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.font=[UIFont systemFontOfSize:14];
        self.titleLabel.text=@"0秒";
        [self addSubview:self.titleLabel];
        
        
        self.progressView=[[UIProgressView alloc]initWithFrame:CGRectMake(40, 30, KScreenWidth-80, 5)];
        self.progressView.progressViewStyle=UIProgressViewStyleDefault;
        [self addSubview:self.progressView];
        self.progressView.trackTintColor=[UIColor whiteColor];
        self.progressView.progressTintColor=[UIColor redColor];
        self.progressView.progress=0.1;
//        [self.progressView setProgress:0.7 animated:YES];
        
        //40 开始
        self.playButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 40, 20, 20)];
        self.playButton.centerX=self.centerX;
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"icon_pause"] forState:UIControlStateSelected];
        self.playButton.selected=YES;
        [self.playButton  addTarget:self action:@selector(clickPlayButton:)];
        [self addSubview:self.playButton];
        
        
    }
    return self;
}



#pragma mark  --click
-(void)clickPlayButton:(UIButton*)sender{
    sender.selected=!sender.selected;
    
    
    if (sender.selected) {
        //选中了  就是正在播放中  就暂停按钮
        [self.player play];
        
    }else{
        [self.player pause];
        
    }
    
    
}


-(void)clickDismiss{
    
    
    self.hidden=YES;
    [self removeObserver];
    [self.player pause];
    _player=nil;
   
    
}











-(void)playOver:(NSNotification*)notifi{
    //播放完全了
//    self.progressView.progress=0.1;
//    [self.playButton setSelected:NO];
////    [self removeObserver];
//    [self removeFromSuperview];
    
    [self clickDismiss];

    
}









// 在播放另一个时，要移除当前item的观察者，还要移除item播放完成的通知
- (void)removeObserver {
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}







- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    AVPlayerItem *item = object;
    
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown:
                NSLog(@"未知状态，不能播放");
                break;
            case AVPlayerStatusReadyToPlay:
                NSLog(@"准备完毕，可以播放");
                break;
            case AVPlayerStatusFailed:
                NSLog(@"加载失败, 网络相关问题");
                break;
                
            default:
                break;
        }
    }
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *array = item.loadedTimeRanges;
        //本次缓存的时间
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        NSTimeInterval totalBufferTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓存的总长度
        self.titleLabel.text=[NSString stringWithFormat:@"%.0f秒",totalBufferTime];
//        self.progressView.progress = totalBufferTime / CMTimeGetSeconds(item.duration);
        MyLog(@"111------%f",CMTimeGetSeconds(item.duration));
        
    }
}





#pragma mark  --set
- (AVPlayer *)player {
    if (!_player) {
        //        根据链接数组获取第一个播放的item， 用这个item来初始化AVPlayer
        AVPlayerItem *item = [self getItemWithStr:self.urlStr];
        //        初始化AVPlayer
        _player = [[AVPlayer alloc] initWithPlayerItem:item];
        __weak typeof(self)weakSelf = self;
        //        监听播放的进度的方法，addPeriodicTime: ObserverForInterval: usingBlock:
        /*
         DMTime 每到一定的时间会回调一次，包括开始和结束播放
         block回调，用来获取当前播放时长
         return 返回一个观察对象，当播放完毕时需要，移除这个观察
         */
        _timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            
//            NSTimeInterval totalBufferTime = CMTimeGetSeconds(time.start) + CMTimeGetSeconds(time.duration); //缓存的总长度
            
            
            
            float current = CMTimeGetSeconds(time);
            if (current) {
                [weakSelf.progressView setProgress:current / CMTimeGetSeconds(item.duration) animated:YES];
//                weakSelf.progressView.progress = totalBufferTime / CMTimeGetSeconds(item.duration);
             }
            
            
            weakSelf.titleLabel.text=[NSString stringWithFormat:@"%.0f秒",CMTimeGetSeconds(item.duration)];
            
             MyLog(@"222------%f",current);
            
        }];
    }
    return _player;
}

- (AVPlayerItem *)getItemWithStr:(NSString*)urlStr {
    NSString*newStr=[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:newStr];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    //KVO监听播放状态
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //KVO监听缓存大小
    [item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //通知监听item播放完毕
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playOver:) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
    return item;
}




-(void)PlayAudioWithUrl:(NSString*)addressUrl{
//    addressUrl=@"http://101.231.48.17:55503/{B03228BC-B534-470B-0DB8-BA5D33F18E47}.MP4";
//    addressUrl=@"http://fdfs.xmcdn.com/group1/M00/01/3B/wKgDrVCYca7Sf6VzADfjEnQrWdU600.mp3";
    [self clickDismiss];
    self.hidden=NO;
    
    self.urlStr=addressUrl;
    self.playButton.selected=YES;
    [self.player play];
    
    
}



-(void)dealloc{
    [self removeObserver];
    
}


@end
