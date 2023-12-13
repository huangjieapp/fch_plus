//
//  VoiceView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/27.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "VoiceView.h"
#import "iflyMSC/IFlyMSC.h"
#import "ISRDataHelper.h"
@interface VoiceView ()<IFlySpeechRecognizerDelegate>


#pragma mark 语音
//不带界面的识别对象
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
/** <#备注#>*/
@property (nonatomic, assign) BOOL isNORecord;
/** 录音数组*/
@property (nonatomic, strong) NSMutableArray *recordArray;
/** 语音背景*/
@property (nonatomic, strong) UIView *voiceView;
/** 语音背景*/
@property (nonatomic, strong) UIView *voiceImagge;
@end

@implementation VoiceView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self voiceBgView];
		[self startIFly];
	}
	return self;
}



- (void)start {
	self.isNORecord = NO;
	self.voiceView.hidden = NO;
	self.voiceImagge.hidden = NO;
	[_iFlySpeechRecognizer startListening];
}

#pragma mark - 语音
- (void)startIFly {
	//创建语音识别对象
	_iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
	//设置识别参数
	//设置为听写模式
	[_iFlySpeechRecognizer setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
	//asr_audio_path 是录音文件名，设置value为nil或者为空取消保存，默认保存目录在Library/cache下。
	[_iFlySpeechRecognizer setParameter:@"iat.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
	_iFlySpeechRecognizer.delegate =self;
}

/*
 //需要实现IFlyRecognizerViewDelegate识别协议
 @interface IATViewController : UIViewController<IFlySpeechRecognizerDelegate>
 //不带界面的识别对象
 @property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
 @end
 */


//IFlySpeechRecognizerDelegate协议实现
//识别结果返回代理
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast{
	NSLog(@"===========%@",results);
	NSMutableString *resultString = [[NSMutableString alloc] init];
	NSDictionary *dic = results[0];
	for (NSString *key in dic) {
		[resultString appendFormat:@"%@",key];
	}
	NSString * str =  [ISRDataHelper stringFromJson:resultString];
	NSLog(@"===========%@",str);
	[self.recordArray addObject:str];
	if (isLast) {
		//		 if (self.isNORecord == YES) {
		NSString *str1 = [self.recordArray componentsJoinedByString:@""];
		NSLog(@"++++++++++++%@",str1);
		if (self.recordBlock) {
			self.recordBlock(str1);
		}
		[self.recordArray removeAllObjects];
		self.isNORecord = YES;
		self.voiceView.hidden = YES;
		self.voiceImagge.hidden = YES;
		[_iFlySpeechRecognizer stopListening];
		[self removeFromSuperview];
		
		//		 }
	}
}
//识别会话结束返回代理
- (void)onCompleted: (IFlySpeechError *) error{
	
}
//停止录音回调
- (void) onEndOfSpeech{
	//	 if (self.isNORecord == NO) {
	//		 [_iFlySpeechRecognizer startListening];
	//	 } else {
	//		 [_iFlySpeechRecognizer stopListening];
	//	 }
	[self removeFromSuperview];
}
//开始录音回调
- (void) onBeginOfSpeech{
	
}
//音量回调函数
- (void) onVolumeChanged: (int)volume{
	
}
//会话取消回调
- (void) onCancel{
	
}

- (void)voiceBgView {
	UIView *voiceView = [[UIView alloc]initWithFrame:self.frame];
	self.voiceView = voiceView;
	voiceView.hidden = YES;
	voiceView.backgroundColor = [UIColor blackColor];
	voiceView.alpha = .5f;
	[[UIApplication sharedApplication].keyWindow addSubview:voiceView];
	UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake((KScreenWidth - 100) / 2, (KScreenHeight - 130) / 2, 100, 130)];
	bgView.hidden = YES;
	self.voiceImagge = bgView;
	UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
	imageView.image = [UIImage imageNamed:@"语音搜索大按钮"];
	[bgView addSubview:imageView];
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), 100, 30)];
	label.text = @"我们正在倾听你的对话...";
	label.font = [UIFont systemFontOfSize:14.f];
	label.textColor = [UIColor whiteColor];
	[bgView addSubview:label];
	[[UIApplication sharedApplication].keyWindow addSubview:bgView];
//	[voiceView addSubview:bgView];
//	[self addSubview:voiceView];
}

- (NSMutableArray *)recordArray {
	if (!_recordArray) {
		_recordArray = [NSMutableArray array];
	}
	return _recordArray;
}

@end
