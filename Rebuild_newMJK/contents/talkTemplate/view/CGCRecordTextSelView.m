//
//  CGCRecordTextSelView.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/19.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCRecordTextSelView.h"

#import "ISRDataHelper.h"
#import "IATConfig.h"
#import "CGCRecordPlaceholderView.h"

@interface  CGCRecordTextSelView()<UITextViewDelegate>
@property (nonatomic, copy) CHANGEBLOCK changeB;

@property (nonatomic, copy) RECORDBLOCK recordB;

@property (nonatomic, copy) TEXTBLOCK textB;

@property (nonatomic, copy) SENDBLOCK sendB;

@property (nonatomic, copy) DISSMISSBLOCK dissB;

@property (nonatomic, copy) SHOWBLOCK showB;

@property (nonatomic, copy) RECORDSTARTBLOCK startB;

@property (nonatomic, copy) RECORDENDBLOCK endB;

@property (nonatomic, copy) NSString *textStr;

@property (nonatomic, copy) NSMutableArray *recordStrArr;

@property (nonatomic, strong) CGCRecordPlaceholderView *pview;





@property (assign) BOOL isSel;

@end

@implementation CGCRecordTextSelView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  
    self.bgView.layer.borderWidth=0.5;
    self.bgView.layer.borderColor=DBColor(0, 0, 0).CGColor;
    self.bgView.layer.cornerRadius=4;
    self.bgView.layer.masksToBounds=YES;
   
}


- (instancetype)initWithFrame:(CGRect)frame withChange:(CHANGEBLOCK)change withRecord:(RECORDBLOCK)record withText:(TEXTBLOCK)text withSend:(SENDBLOCK)send withShow:(SHOWBLOCK)showB withDiss:(DISSMISSBLOCK)dissB withRecordStart:(RECORDSTARTBLOCK)startB withRecordEnd:(RECORDENDBLOCK)endB{

    if (self=[super initWithFrame:frame]) {
        self=[[[NSBundle mainBundle] loadNibNamed:@"CGCRecordTextSelView" owner:self options:nil] lastObject];
        self.isSel=YES;
        self.changeB = change;
        self.recordB = record;
        self.textB = text;
        self.sendB = send;
        self.dissB = dissB;
        self.showB = showB;
        self.startB = startB;
        self.endB = endB;
        
        self.pview=[[CGCRecordPlaceholderView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-114)];
        self.textStr=@"";
        [self.changeBtn addTarget:self action:@selector(changeClick:)];
        self.textView.delegate=self;
        [self.recordBtn addTarget:self action:@selector(recordClick)];
        [self.sendBtn addTarget:self action:@selector(sendClick)];
//        [self.recordBtn addTarget:self action:@selector() forControlEvents:<#(UIControlEvents)#>];
        //button长按事件
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
        longPress.minimumPressDuration = 0.5; //定义按的时间
        [self.recordBtn addGestureRecognizer:longPress];
        
        //监听当键盘将要出现时
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        //监听当键将要退出时
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];

        
      
    }
    return self;

}

-(void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        NSLog(@"start");
        
        
        self.isStreamRec = NO;
        
        if(_iFlySpeechRecognizer == nil)
        {
            [self initRecognizer];
        }
        
        [_iFlySpeechRecognizer cancel];
        
        //设置音频来源为麦克风
        [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
        
        //设置听写结果格式为json
        [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
        //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
        [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        
        [_iFlySpeechRecognizer setDelegate:self];
        
        BOOL ret = [_iFlySpeechRecognizer startListening];
        
        if (self.startB) {
            self.startB();
        }
        if (ret==0) {
            [JRToast showWithText:@"语音获取失败！"];
        }
      

    }
    
    if ([gestureRecognizer state]==UIGestureRecognizerStateEnded) {
        NSLog(@"end");
        
        if(self.isStreamRec && !self.isBeginOfSpeech){
            NSLog(@"停止录音");
            [_pcmRecorder stop];
            
        }
        
        [_iFlySpeechRecognizer stopListening];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{

    if (self.textB) {
        self.textB();
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{

    self.textStr=textView.text;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    
    if ([text isEqualToString:@"\n"]) {
        
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    }
    return YES;
}

- (void)changeClick:(UIButton *)btn{

    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (self.isSel) {
        [self.changeBtn setImage:@"语音-跟进"];
        self.recordBtn.hidden=YES;
        self.textView.hidden=NO;
        self.sendBtn.hidden=NO;
        self.isSel=NO;
    }else{
        [self.changeBtn setImage:@"键盘-跟进"];
        self.recordBtn.hidden=NO;
        self.textView.hidden=YES;
        self.sendBtn.hidden=YES;
        self.isSel=YES;
    }
  
    if (self.changeB) {
        self.changeB();
    }
}
- (void)recordClick{
   
     [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (self.recordB) {
        self.recordB();
    }
}
- (void)sendClick{
     [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (self.sendB) {
        self.sendB(self.textView.text);
    }
}

-(void)layoutSubviews{

    self.width=KScreenWidth;
    self.height=50;
    
}


//当键盘出现
- (void)keyboardShow:(NSNotification *)notification
{
    
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    CGFloat height = keyboardRect.size.height+30;
    NSLog(@"%f-=-=-",height);
   
    //获取键盘弹出所需时长
    float duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (self.showB) {
        self.showB(height, duration);
    }
    
    
    
    
}

//当键退出
- (void)keyboardHide:(NSNotification *)notification
{
   
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    CGFloat height = keyboardRect.size.height;
    NSLog(@"%f-=-=-",height);
    float duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (self.dissB) {
        self.dissB(height, duration);
    }

}

- (void)dismissKeyboardView{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)setTextWith:(NSString *)text{

    [self.changeBtn setImage:@"语音-跟进"];
    self.recordBtn.hidden=YES;
    self.textView.hidden=NO;
    self.sendBtn.hidden=NO;
    self.isSel=NO;
    self.textView.text=text;

}




#pragma mark - IFlySpeechRecognizerDelegate

/**
 音量回调函数
 volume 0－30
 ****/
- (void) onVolumeChanged: (int)volume
{
    
//    NSString * vol = [NSString stringWithFormat:@"音量：%d",volume];
    //    self.labelText.text=vol;
}



/**
 开始识别回调
 ****/
- (void) onBeginOfSpeech
{
    [self.pview show];
   
    
    NSLog(@"onBeginOfSpeech");
    
    if (self.isStreamRec == NO)
    {
        self.isBeginOfSpeech = YES;
        
    }
}

/**
 停止录音回调
 ****/
- (void) onEndOfSpeech
{
    [self.pview dismiss];
    NSLog(@"onEndOfSpeech");
    
    [_pcmRecorder stop];
    
}


/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void) onError:(IFlySpeechError *) error
{
    
    if ([IATConfig sharedInstance].haveView == NO ) {
        
        //        if (self.isStreamRec) {
        //            //当音频流识别服务和录音器已打开但未写入音频数据时stop，只会调用onError不会调用onEndOfSpeech，导致录音器未关闭
        //            [_pcmRecorder stop];
        //            self.isStreamRec = NO;
        //            NSLog(@"error录音停止");
        //        }
        
        NSString *text ;
        
        if (self.isCanceled) {
            text = @"识别取消";
            
        } else if (error.errorCode == 0 ) {
            if (_result.length == 0) {
                text = @"无识别结果";
            }else {
                text = @"识别成功";
                //清空识别结果
                _result = nil;
            }
        }else {
            text = [NSString stringWithFormat:@"发生错误：%d %@", error.errorCode,error.errorDesc];
            NSLog(@"%@",text);
        }
        
        
    }else {
        
        NSLog(@"errorCode:%d",[error errorCode]);
    }
    
}

- (void)onIFlyRecorderError:(IFlyPcmRecorder *)recoder theError:(int)error{


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
    NSString * str =  [ISRDataHelper stringFromJson:resultString];
    [self.recordStrArr addObject:str];
    NSLog(@"resultFromJson=%@", self.recordStrArr);
    
    if (self.endB) {
        self.endB([self.recordStrArr componentsJoinedByString:@""]);
    }
    
}

/**
 听写取消回调
 ****/
- (void) onCancel
{
    NSLog(@"识别取消");
}


/**
 设置识别参数
 ****/
-(void)initRecognizer
{
    
    //单例模式，无UI的实例
    if (_iFlySpeechRecognizer == nil) {
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    _iFlySpeechRecognizer.delegate = self;
    
    if (_iFlySpeechRecognizer != nil) {
        IATConfig *instance = [IATConfig sharedInstance];
        
        //设置最长录音时间
        [_iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        if ([instance.language isEqualToString:[IATConfig chinese]]) {
            //设置语言
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //设置方言
            [_iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
        }else if ([instance.language isEqualToString:[IATConfig english]]) {
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        }
        //设置是否返回标点符号
        [_iFlySpeechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
        
    }
    
    //初始化录音器
    if (_pcmRecorder == nil)
    {
        _pcmRecorder = [IFlyPcmRecorder sharedInstance];
    }
    
    _pcmRecorder.delegate = self;
    
    [_pcmRecorder setSample:[IATConfig sharedInstance].sampleRate];
    
    [_pcmRecorder setSaveAudioPath:nil];    //不保存录音文件
    
    
}

- (NSMutableArray *)recordStrArr{

    if (!_recordStrArr) {
        _recordStrArr=[NSMutableArray array];
    }

    return _recordStrArr;
}

@end
