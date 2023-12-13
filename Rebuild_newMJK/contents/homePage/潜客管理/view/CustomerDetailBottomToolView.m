//
//  CustomerDetailBottomToolView.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/25.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CustomerDetailBottomToolView.h"
#import "DBTopImageBottomLabelButton.h"

@interface CustomerDetailBottomToolView ()<UITextViewDelegate>
/** <#备注#>*/
@property (nonatomic, assign) NSInteger toolMainViewHeight;
@end

@implementation CustomerDetailBottomToolView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.ToolTextField.layer.borderColor=[UIColor colorWithHexString:@"#E5E5E5"].CGColor;
    self.ToolTextField.layer.borderWidth=0.5;
    
    self.ToolLeftButton.selected=NO;
    self.ToolTextField.hidden=YES;
    self.fllowButton.hidden=YES;
    
    self.VoiceButton.layer.borderWidth=0.5;
    self.VoiceButton.layer.cornerRadius=5;
    self.VoiceButton.layer.masksToBounds=YES;
    self.VoiceButton.layer.borderColor=[UIColor colorWithHexString:@"#999999"].CGColor;
    
    
    self.ToolMainView.layer.borderWidth=0.5;
    self.ToolMainView.layer.borderColor=[UIColor colorWithHexString:@"#E5E5E5"].CGColor;
    self.ToolMainView.backgroundColor=[UIColor colorWithHexString:@"#F7F7F7"];
    
    
    UILongPressGestureRecognizer*longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(btnLong:)];
//    longPress.minimumPressDuration=0.8;
    [self.VoiceButton addGestureRecognizer:longPress];
	
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
//    [self.ToolTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
	self.ToolTextField.delegate = self;
	self.ToolTextField.showsVerticalScrollIndicator = NO;
	
    
    
	
}

- (instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArray andImageArray:(NSArray *)imageArray {
    if (self = [super initWithFrame:frame]) {
        if (self = [super initWithFrame:frame]) {
            self=[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CustomerDetailBottomToolView class]) owner:nil options:nil].firstObject;
            self.frame=frame;
            CGFloat leftValue=10;
            CGFloat popButtonWithHeight=55;
            
            
            NSInteger count = 4;
            CGFloat margin = (KScreenWidth - (popButtonWithHeight * count)) / (count + 1);
            //        CGFloat margin = (KScreenWidth / (titleArray.count) - popButtonWithHeight) ;
            //        CGFloat width = (KScreenWidth - margin) / (titleArray.count) ;
            CGFloat Y = 5;
            int k = 0;
            int j = 0;
            for (int i=0; i<titleArray.count; i++) {
                if ((i + 1) % 5 == 0 ) {
                    k=0;
                    j++;
                    Y += popButtonWithHeight;
                }
                DBTopImageBottomLabelButton*button=[[DBTopImageBottomLabelButton alloc]initWithFrame:CGRectMake(margin+(k * (popButtonWithHeight + margin)), (j == 0 ? Y : 15) + (j * popButtonWithHeight), popButtonWithHeight, popButtonWithHeight)];
                button.TopImageView.image=[UIImage imageNamed:imageArray[i]];
                button.BottomLabel.text=titleArray[i];
                //            [self.chooseScrollView addSubview:button];
                [self.chooseScrollView addSubview:button];
                button.tag=100+i;
                [button addTarget:self action:@selector(clickChooseButton:)];
                k++;
                
            }
        }
        return self;
    }
    return self;
}

- (void)setFansStar:(NSString *)fansStar {
    _fansStar = fansStar;
    for (DBTopImageBottomLabelButton *button in self.backView.subviews) {
        if ([button.BottomLabel.text isEqualToString:@"星标"]) {
            button.TopImageView.image = [UIImage imageNamed:fansStar];
            
        }
    }
}

-(instancetype)initWithFrame:(CGRect)frame andIsMoreLines:(BOOL)isMoreLines {
    self=[super initWithFrame:frame];
    if (self) {
        self.isMoreLines = isMoreLines;
        self=[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CustomerDetailBottomToolView class]) owner:nil options:nil].firstObject;
        self.frame=frame;
        //加上选择的视图
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"VCName"] isEqualToString:@"协助"]) {
            [self assistChooseView];
        } else {
            [self addChooseButtonViewIsMoreLines:isMoreLines];
        }
    }
    return self;
}



- (void)assistChooseView {
//	CGFloat popButtonWithHeight=60;	DBTopImageBottomLabelButton*button=[[DBTopImageBottomLabelButton alloc]initWithFrame:CGRectMake((KScreenWidth - popButtonWithHeight)/2, 5, popButtonWithHeight, popButtonWithHeight)];
	NSArray*titleArray;
	NSArray*imageArray;
	//跟进、预约、任务、订单、协助
	titleArray=@[@"跟进",@"预约",@"任务",@"订单",@"协助"];
	imageArray=@[@"more_新增跟进",@"新增预约-详情页",@"新增任务",@"打印订单",@"协助图"];
	
	CGFloat leftValue=10;
	CGFloat popButtonWithHeight=55;
	
	
	
	CGFloat margin = (KScreenWidth / 5 - popButtonWithHeight) ;
	CGFloat width = (KScreenWidth - margin) / 5 ;
	CGFloat Y = 5;
	int k = 0;
	int j = 0;
	for (int i=0; i<titleArray.count; i++) {
		DBTopImageBottomLabelButton*button=[[DBTopImageBottomLabelButton alloc]initWithFrame:CGRectMake(margin+(k * width), (j == 0 ? Y : 15) + (j * popButtonWithHeight), popButtonWithHeight, popButtonWithHeight)];
		button.TopImageView.image=[UIImage imageNamed:imageArray[i]];
		button.BottomLabel.text=titleArray[i];
		[self.chooseScrollView addSubview:button];
		button.tag=100+i;
		[button addTarget:self action:@selector(clickChooseButton:)];
		k++;
		if ((i + 1) % 5 == 0 ) {
			k=0;
			j++;
		}
			
			
//			leftValue=leftValue+popButtonWithHeight+10;
		
		
		
	}
//	button.TopImageView.image=[UIImage imageNamed:@"新增预约-详情页"];
//	button.BottomLabel.text=@"新增预约";
//	[self.chooseScrollView addSubview:button];
//	button.tag=200;
//	[button addTarget:self action:@selector(clickChooseButton:)];
}

-(void)addChooseButtonViewIsMoreLines:(BOOL)isMoreLines {
	NSArray*titleArray;
	NSArray*imageArray;
	if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"VCName"] isEqualToString:@"order"]) {
		
            NSMutableArray *titleArr = [NSMutableArray array];
            NSMutableArray *imageArr = [NSMutableArray array];
            
            
           
            if ([[NewUserSession instance].appcode containsObject:@"APP005_0009"]) {
                [titleArr addObject:@"变更状态"];
                [imageArr addObject:@"变更状态"];
            }
            
             
            [titleArr addObject:@"车源关联"];
            [imageArr addObject:@"锁定"];
            
            if ([[NewUserSession instance].appcode containsObject:@"APP005_0005"]) {
                [titleArr addObject:@"收款/退款"];
                [imageArr addObject:@"新增收款"];
            }
        
        if ([[NewUserSession instance].appcode containsObject:@"APP005_0014"]) {
            [titleArr addObject:@"预约到店"];
            [imageArr addObject:@"moree_新增预约"];
        }
            
            if ([[NewUserSession instance].appcode containsObject:@"APP005_0013"]) {
                [titleArr addObject:@"重新指派"];
                [imageArr addObject:@"重新指派"];
            }
            
            [titleArr addObject:@"文件签署"];
            [imageArr addObject:@"员工"];
            
                
                [titleArr addObject:@"附加产值"];
                [imageArr addObject:@"moree_新增预约"];
            
            
            
                [titleArr addObject:@"面访问卷"];
                [imageArr addObject:@"面访问卷"];

            
           
            titleArray = titleArr;
            imageArray = imageArr;
		
		
		
	} else {
		
            NSMutableArray *titleArr = [NSMutableArray array];
            NSMutableArray *imageArr = [NSMutableArray array];
            
            if ([[NewUserSession instance].appcode containsObject:@"APP004_0005"]) {
                [titleArr addObject:@"跟进"];
                [imageArr addObject:@"more_新增跟进"];
            }
            if ([[NewUserSession instance].appcode containsObject:@"APP004_0008"]) {
                [titleArr addObject:@"预约"];
                [imageArr addObject:@"新增预约-详情页"];
            }
            if ([[NewUserSession instance].appcode containsObject:@"APP004_0009"]) {
                [titleArr addObject:@"任务"];
                [imageArr addObject:@"新增任务.png"];
            }
            if ([[NewUserSession instance].appcode containsObject:@"APP004_0010"]) {
                [titleArr addObject:@"订单"];
                [imageArr addObject:@"打印订单"];
            }
            if ([[NewUserSession instance].appcode containsObject:@"APP004_0011"]) {
                [titleArr addObject:@"转出"];
                [imageArr addObject:@"icon_transfer"];
            }
            if ([[NewUserSession instance].appcode containsObject:@"APP004_0004"]) {
                [titleArr addObject:@"指派"];
                [imageArr addObject:@"重新指派"];
            }
            if ([[NewUserSession instance].appcode containsObject:@"APP004_0029"]) {
                [titleArr addObject:@"星标"];
                if (self.isStar) {
                    [imageArr addObject:@"星标客户"];
                } else {
                    [imageArr addObject:@"未星标客户"];
                }
            }
            if ([[NewUserSession instance].appcode containsObject:@"APP004_0007"]) {
                [titleArr addObject:@"战败"];
                [imageArr addObject:@"战败-详情页"];
            }
            titleArray = titleArr;
            imageArray = imageArr;
            
            
		
		
	}
	
	
    
    
    CGFloat leftValue=10;
    CGFloat popButtonWithHeight=55;
    
    
//    NSInteger count = titleArray.count >= 6 ?  (titleArray.count / 2 + titleArray.count % 2)  : titleArray.count;
//    CGFloat margin = (KScreenWidth / count - popButtonWithHeight) ;
    NSInteger count = 4;
    CGFloat margin = (KScreenWidth - (popButtonWithHeight * count)) / (count + 1);
//    CGFloat width = (KScreenWidth - (margin * 5)) / count ;
    CGFloat Y = 5;
    int k = 0;
    int j = 0;
    for (int i=0; i<titleArray.count; i++) {
        if (isMoreLines == YES) {
            DBTopImageBottomLabelButton*button=[[DBTopImageBottomLabelButton alloc]initWithFrame:CGRectMake(margin+(k * (popButtonWithHeight + margin)), (j == 0 ? Y : 15) + (j * popButtonWithHeight), popButtonWithHeight, popButtonWithHeight)];
            button.TopImageView.image=[UIImage imageNamed:imageArray[i]];
            button.BottomLabel.text=titleArray[i];
            [self.chooseScrollView addSubview:button];
            button.tag=100+i;
            [button addTarget:self action:@selector(clickChooseButton:)];
            k++;
            if ((i + 1) % count == 0 ) {
                k=0;
                j++;
            }
        } else {
            DBTopImageBottomLabelButton*button=[[DBTopImageBottomLabelButton alloc]initWithFrame:CGRectMake(leftValue, 5, popButtonWithHeight, popButtonWithHeight)];
            button.TopImageView.image=[UIImage imageNamed:imageArray[i]];
            //        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"VCName"] isEqualToString:@"order"]) {
            //            [button setImage:imageArray[i] forState:UIControlStateNormal];
            //        } else {
            //
            //        }
            button.BottomLabel.text=titleArray[i];
            [self.chooseScrollView addSubview:button];
            button.tag=100+i;
            [button addTarget:self action:@selector(clickChooseButton:)];
            
            
            leftValue=leftValue+popButtonWithHeight+10;
        }
        
        
    }
       self.chooseScrollView.contentSize=CGSizeMake(leftValue,0);
    
    
}


#pragma mark  --touch
-(void)clickChooseButton:(DBTopImageBottomLabelButton*)button{
    NSInteger number=button.tag-100;
    MyLog(@"%ld",(long)number);
    if (self.clickChooseButtonBlock) {
        self.clickChooseButtonBlock(number,button.BottomLabel.text);
    }
    
    
}



- (IBAction)clickLeftButton:(UIButton*)sender {
    sender.selected=!sender.selected;
    if (sender.selected) {
        //手动输入
//        [self showKeyBoardView];
        self.VoiceButton.hidden=YES;
        self.addButton.hidden=YES;
        self.ToolTextField.hidden=NO;
        [self.ToolTextField becomeFirstResponder];
        self.fllowButton.hidden=NO;
        
        
    }else{
        //语音状态
        [self initialStatus];
        
       

        
        
    }

    
}


//原始状态   需要这个tool 归位
-(void)initialStatus{
    [self showFirstView];
    self.ToolTextField.text=nil;
    [self.ToolTextField resignFirstResponder];
    self.ToolTextField.hidden=YES;
    self.fllowButton.hidden=YES;
    self.VoiceButton.hidden=NO;
    self.addButton.hidden=NO;
    self.addButton.selected = NO;

}

- (IBAction)addChooseButton:(UIButton *)sender {
    sender.selected=!sender.selected;
    if (sender.selected) {
        //显示
        [self showChooseView];
        
    }else{
        //隐藏
        [self showFirstView];
    }
    
}




- (IBAction)addFollowButton:(id)sender {
    //跟进
    [self.ToolTextField resignFirstResponder];
    
    MyLog(@"%@",self.ToolTextField.text);
    if (self.followBlock) {
        self.followBlock(self.ToolTextField.text);
    }
    
    
}

//长按开始结束
-(void)btnLong:(UILongPressGestureRecognizer*)longPressGesture{
    if (longPressGesture.state==UIGestureRecognizerStateBegan) {
       
        
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
        
//        if (self.startB) {
//            self.startB();
//        }
        if (ret==0) {
            [JRToast showWithText:@"语音获取失败！"];
        }

        
        
        
    }else if (longPressGesture.state==UIGestureRecognizerStateEnded){
        
        if(self.isStreamRec && !self.isBeginOfSpeech){
            NSLog(@"停止录音");
            [_pcmRecorder stop];
            
        }
        
        [_iFlySpeechRecognizer stopListening];

        
        
        
    }
    
    
    
    
    
//    if (self.longPressBlock) {
//        self.longPressBlock(longPressGesture);
//    }
    
    
}


//编辑的开始
-(void)textFieldChange:(UITextField*)textField{
    
    
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
	if (self.textChangeBlock) {
		self.textChangeBlock(textView.text);
	}
}

-(void)textFieldWillShow:(NSNotification*)notification{
    NSDictionary*userInfo=notification.userInfo;
    //得到键盘的top   y 位置
    CGFloat keyEndY = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].origin.y;
    MyLog(@"%f",keyEndY);
    
    
    [self showKeyBoardViewWithY:keyEndY];
    
}

-(void)textFieldWillHidden:(NSNotification*)notification{
//    NSDictionary*userInfo=notification.userInfo;
//    UITextField*textField=notification.object;

    [self showFirstView];
}


//3种状态
-(void)showFirstView{
    MyLog(@"1");
    if ([self.delegate respondsToSelector:@selector(delegateShowFirstView)]) {
        [self.delegate delegateShowFirstView];
    }
    
}

-(void)showChooseView{
    MyLog(@"2");
    if ([self.delegate respondsToSelector:@selector(delegateShowChooseView)]) {
        [self.delegate delegateShowChooseView];
    }
    
}

-(void)showKeyBoardViewWithY:(CGFloat)keyBoardY{
    MyLog(@"3");
    if ([self.delegate respondsToSelector:@selector(delegateShowKeyBoardViewWithY:)]) {
        [self.delegate delegateShowKeyBoardViewWithY:keyBoardY];
    }
    
}



#pragma mark  --set
-(void)setIsStar:(BOOL)isStar{
    _isStar=isStar;
    for (UIView*subview in self.chooseScrollView.subviews) {
        if ([subview isKindOfClass:[DBTopImageBottomLabelButton class]]) {
            DBTopImageBottomLabelButton*button = (DBTopImageBottomLabelButton *)subview;
            if ([button.BottomLabel.text isEqualToString:@"星标"]) {
                if (isStar) {
                    button.TopImageView.image=[UIImage imageNamed:@"星标客户"];
                }else{
                    button.TopImageView.image=[UIImage imageNamed:@"未星标客户"];
                }
            }
        }
    }
//    DBTopImageBottomLabelButton*button=[self.chooseScrollView viewWithTag:106];
//    if (button) {
//        if (isStar) {
//            button.TopImageView.image=[UIImage imageNamed:@"星标客户"];
//        }else{
//            button.TopImageView.image=[UIImage imageNamed:@"未星标客户"];
//        }
//
//    }
    
    
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
//    NSLog(@"resultFromJson=%@", self.recordStrArr);
    
//    if (self.endB) {
//        self.endB([self.recordStrArr componentsJoinedByString:@""]);
//    }
    
    
//    MyLog(@"%@",str);
    
    
    if (isLast) {
        if (self.endRecordBlock) {
            self.endRecordBlock([self.recordStrArr componentsJoinedByString:@""]);
            
        }
        //要清空  不然有历史残余
        [self.recordStrArr removeAllObjects];

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



-(CGCRecordPlaceholderView *)pview{
    if (!_pview) {
        CGFloat height =  [[UIApplication sharedApplication] statusBarFrame].size.height>20 ? 88 : 64;
        _pview=[[CGCRecordPlaceholderView alloc] initWithFrame:CGRectMake(0, height, KScreenWidth, KScreenHeight-height-SafeAreaBottomHeight - 50)];
    }
    return _pview;
}



- (NSMutableArray *)recordStrArr{
    
    if (!_recordStrArr) {
        _recordStrArr=[NSMutableArray array];
    }
    
    return _recordStrArr;
}


@end
