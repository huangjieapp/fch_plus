//
//  CGCRecordTextSelView.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/19.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "iflyMSC/iflyMSC.h"
@class IFlyDataUploader;
@class IFlySpeechRecognizer;
@class IFlyPcmRecorder;


typedef void(^CHANGEBLOCK)();
typedef void(^RECORDBLOCK)();
typedef void(^TEXTBLOCK)();
typedef void(^SENDBLOCK)(NSString *text);
typedef void(^SHOWBLOCK)(CGFloat hight,CGFloat time);
typedef void(^DISSMISSBLOCK)(CGFloat hight,CGFloat time);
typedef void(^RECORDSTARTBLOCK)();
typedef void(^RECORDENDBLOCK)(NSString* str);


@interface CGCRecordTextSelView : UIView<IFlySpeechRecognizerDelegate,IFlyPcmRecorderDelegate>

@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *recordBtn;

@property (weak, nonatomic) IBOutlet UITextView *textView;


@property (nonatomic, strong) NSString *pcmFilePath;//音频文件路径
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象
@property (nonatomic, strong) IFlyDataUploader *uploader;//数据上传对象
@property (nonatomic,strong) IFlyPcmRecorder *pcmRecorder;//录音器，用于音频流识别的数据传入
@property (nonatomic,assign) BOOL isStreamRec;//是否是音频流识别
@property (nonatomic,assign) BOOL isBeginOfSpeech;//是否返回BeginOfSpeech回调
@property (nonatomic, strong) NSString * result;
@property (nonatomic, assign) BOOL isCanceled;



- (instancetype)initWithFrame:(CGRect)frame withChange:(CHANGEBLOCK)change withRecord:(RECORDBLOCK)record withText:(TEXTBLOCK)text withSend:(SENDBLOCK)send withShow:(SHOWBLOCK)showB withDiss:(DISSMISSBLOCK)dissB withRecordStart:(RECORDSTARTBLOCK)startB withRecordEnd:(RECORDENDBLOCK)endB;

- (void)setTextWith:(NSString *)text;
@end
