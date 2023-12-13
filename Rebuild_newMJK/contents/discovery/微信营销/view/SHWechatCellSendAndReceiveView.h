//
//  SHWechatCellSendAndReceiveView.h
//  mcr_sh_master
//
//  Created by Hjie on 2017/8/29.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHWechatTrackModel.h"

@interface SHWechatCellSendAndReceiveView : UIView
+ (UIView *)bubbleView:(SHWechatTrackModel *)wechatTrackModel withPosition:(int)position;
//泡泡文本
+ (UIView *)bubbleView:(NSString *)type text:(NSString *)text time:(NSString *)time from:(NSString *)fromSelf withPosition:(int)position;
//泡泡语音
+ (UIView *)yuyinView:(NSInteger)logntime from:(NSString *)fromSelf withIndexRow:(NSInteger)indexRow  withPosition:(int)position;

@end
