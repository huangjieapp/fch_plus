//
//  MJKPlayVideoTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/3/18.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKPlayVideoTableViewCell.h"
#import <AVFoundation/AVFoundation.h>

#import "CGCExpandModel.h"

@interface MJKPlayVideoTableViewCell ()
@property (nonatomic,strong)AVPlayer *player;//播放器对象
@property (nonatomic,strong)AVPlayerItem *currentPlayerItem;
@end


@implementation MJKPlayVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(CGCExpandModel *)model {
    _model = model;
    [self configPlayer];
}

- (void)configPlayer {
    //第二步:获取播放地址URL
    //本地视频路径
//    NSString* localFilePath=[[NSBundle mainBundle]pathForResource:@"不能说的秘密" ofType:@"mp4"];
//    NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];
    //网络视频路径
    NSString *webVideoPath = self.model.video;
    NSURL *webVideoUrl = [NSURL URLWithString:webVideoPath];
    
    //第三步:创建播放器(四种方法)
    //如果使用URL创建的方式会默认为AVPlayer创建一个AVPlayerItem
    //self.player = [AVPlayer playerWithURL:localVideoUrl];
    //self.player = [[AVPlayer alloc] initWithURL:localVideoUrl];
    //self.player = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:webVideoUrl];
    self.currentPlayerItem = playerItem;
    self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    
    //第四步:创建显示视频的AVPlayerLayer,设置视频显示属性，并添加视频图层
    //contentView是一个普通View,用于放置视频视图
    /*
     AVLayerVideoGravityResizeAspectFill等比例铺满，宽或高有可能出屏幕
     AVLayerVideoGravityResizeAspect 等比例  默认
     AVLayerVideoGravityResize 完全适应宽高
     */
    AVPlayerLayer *avLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    avLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    avLayer.frame = CGRectMake(0, 0, KScreenWidth, 200);
    UIButton *playButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [playButton setImage:@"icon_play"  forState:UIControlStateNormal];
    
    [avLayer addSublayer:playButton.layer];
    [self.contentView.layer addSublayer:avLayer];
    
    [self.player play];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKPlayVideoTableViewCell";
    MJKPlayVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
