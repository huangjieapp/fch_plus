//
//  MJKVoiceCViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/6.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKVoiceCViewController.h"
#import "IATConfig.h"
#import "ISRDataHelper.h"

@interface MJKVoiceCViewController ()<IFlySpeechRecognizerDelegate,IFlyPcmRecorderDelegate> {
	 UIVisualEffectView* bigvoiceView;
}
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *longClickLabel;
@property (nonatomic, strong) NSMutableArray *textArray;
@end

@implementation MJKVoiceCViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self initRecognizer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/**
 设置识别参数
 ****/
-(void)initRecognizer
{
	//创建语音识别对象
	_iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
	_iFlySpeechRecognizer.delegate = self;
	//设置识别参数
	//设置为听写模式
	[_iFlySpeechRecognizer setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
	//asr_audio_path 是录音文件名，设置value为nil或者为空取消保存，默认保存目录在Library/cache下。
	[_iFlySpeechRecognizer setParameter:@"iat.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
	//启动识别服务
	IATConfig *instance = [IATConfig sharedInstance];
//
//	//设置最长录音时间
	[self.iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
//	设置后端点
	[self.iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
//	设置前端点
	[self.iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
//	网络等待时间
	[self.iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
//
	//设置采样率，推荐使用16K
	[self.iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
//
	if ([instance.language isEqualToString:[IATConfig chinese]]) {
//		//设置语言
		[_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
//		//设置方言
		[_iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
	}else if ([instance.language isEqualToString:[IATConfig english]]) {
		[_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
	}
	//设置是否返回标点符号
	[self.iFlySpeechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
	//设置音频来源为麦克风
	[_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];

	//设置听写结果格式为json
	[_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
	
}

- (IBAction)recordButtonAction:(UIButton *)sender {
}

- (IBAction)closeButtonAction:(UIButton *)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonLongClick:(UILongPressGestureRecognizer *)sender {
	switch (sender.state) {
		case UIGestureRecognizerStateBegan://开始
		{
			self.longClickLabel.text = @"我们正在倾听...";
			[_iFlySpeechRecognizer startListening];
		}
			break;
			
		case UIGestureRecognizerStateEnded://结束
		{
			self.longClickLabel.text = @"长按说话";

			[_iFlySpeechRecognizer stopListening];
		}
			break;
			
		default:
			break;
	}
}
/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void) onError:(IFlySpeechError *) error
{
	if ([error errorCode] == 0) {
		NSLog(@"errorCode:%d",[error errorCode]);
		NSString *str = [self.textArray componentsJoinedByString:@""];
		NSRange range = [str rangeOfString:@"。"];
		if (range.location != NSNotFound) {
			str = [str substringToIndex:range.location];
		}
		if (str.length > 0) {
			if (self.backStrBlock) {
				self.backStrBlock(str);
			}
			[self dismissViewControllerAnimated:YES completion:nil];
		} else {
			[JRToast showWithText:@"您没有说话"];
		}
		
	}
}

/**
 无界面，听写结果回调
 results：听写结果
 isLast：表示最后一次
 ****/
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
	
	NSMutableString *resultString = [[NSMutableString alloc] init];
	NSDictionary *dic = results[0];
	for (NSString *key in dic) {
		[resultString appendFormat:@"%@",key];
	}
	NSString * result =[NSString stringWithFormat:@"%@", resultString];
	NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];
	[self.textArray addObject:resultFromJson];
	if (isLast){
		NSLog(@"听写结果(json)：%@测试",  resultFromJson);
	}
	
}

- (NSMutableArray *)textArray {
	if (!_textArray) {
		_textArray = [NSMutableArray array];
	}
	return _textArray;
}

@end
