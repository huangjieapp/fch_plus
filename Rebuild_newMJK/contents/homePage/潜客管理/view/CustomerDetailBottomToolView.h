//
//  CustomerDetailBottomToolView.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/25.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "iflyMSC/iflyMSC.h"
#import "ISRDataHelper.h"
#import "IATConfig.h"
#import "CGCRecordPlaceholderView.h"
#import "CustomerDetailViewController.h"
@class IFlyDataUploader;
@class IFlySpeechRecognizer;
@class IFlyPcmRecorder;




@protocol CustomerDetailBottomToolViewDelegate <NSObject>
-(void)delegateShowFirstView;
-(void)delegateShowChooseView;
-(void)delegateShowKeyBoardViewWithY:(CGFloat)keyBoardY;


@end

@interface CustomerDetailBottomToolView : UIView<IFlySpeechRecognizerDelegate,IFlyPcmRecorderDelegate>

//普通模式： 键盘-跟进  语音button  加号
//输入模式： 语音-跟进  输入框       跟进按钮
/** */
@property (nonatomic, strong) NSString *fansStar;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIView *ToolMainView;
@property (weak, nonatomic) IBOutlet UIButton *ToolLeftButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolMainViewHeightLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolTextViewHeightLayout;
@property (weak, nonatomic) IBOutlet UITextView *ToolTextField;
@property (weak, nonatomic) IBOutlet UIButton *fllowButton;

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *VoiceButton;



@property (weak, nonatomic) IBOutlet UIView *ChooseMainView;
@property (weak, nonatomic) IBOutlet UIScrollView *chooseScrollView;

@property (nonatomic, strong) NSString *VCName;//那个控制器跳转而来



@property(nonatomic,weak)id<CustomerDetailBottomToolViewDelegate>delegate;


@property(nonatomic,copy)void(^followBlock)(NSString*textField);
@property(nonatomic,copy)void(^endRecordBlock)(NSString*recordStr);
@property(nonatomic,copy)void(^clickChooseButtonBlock)(NSInteger index, NSString *title);
/** <#备注#>*/
@property (nonatomic, copy) void(^textChangeBlock)(NSString *str);

//原始状态   需要这个tool 归位
-(void)initialStatus;
@property(nonatomic,assign)BOOL isStar;

@property (nonatomic, assign) BOOL isMoreLines;//多行




#pragma 音频处理
@property (nonatomic, strong) CGCRecordPlaceholderView *pview;
@property (nonatomic, copy) NSMutableArray *recordStrArr;

@property (nonatomic, strong) NSString *pcmFilePath;//音频文件路径
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象
@property (nonatomic, strong) IFlyDataUploader *uploader;//数据上传对象
@property (nonatomic,strong) IFlyPcmRecorder *pcmRecorder;//录音器，用于音频流识别的数据传入
@property (nonatomic,assign) BOOL isStreamRec;//是否是音频流识别
@property (nonatomic,assign) BOOL isBeginOfSpeech;//是否返回BeginOfSpeech回调
@property (nonatomic, strong) NSString * result;
@property (nonatomic, assign) BOOL isCanceled;
-(instancetype)initWithFrame:(CGRect)frame andIsMoreLines:(BOOL)isMoreLines;

-(instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArray andImageArray:(NSArray *)imageArray;
@end
