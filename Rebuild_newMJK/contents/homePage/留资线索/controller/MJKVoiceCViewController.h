//
//  MJKVoiceCViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/6.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iflyMSC/iflyMSC.h"

@class IFlyDataUploader;
@class IFlySpeechRecognizer;
@class IFlyPcmRecorder;

@protocol MJKVoiceCViewControllerDelegate <NSObject>

- (void)backVoiceChange:(NSString *)str;

@end

@interface MJKVoiceCViewController : UIViewController

@property (nonatomic,strong) IFlyPcmRecorder *pcmRecorder;//录音器，用于音频流识别的数据传入
@property (nonatomic, weak)id<MJKVoiceCViewControllerDelegate>delegate;
@property (nonatomic, copy) void(^backStrBlock)(NSString *str);
@end
