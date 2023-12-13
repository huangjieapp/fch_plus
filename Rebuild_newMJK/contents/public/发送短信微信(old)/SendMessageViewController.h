//
//  SendMessageViewController.h
//  Mcr_2
//
//  Created by bipi on 2016/12/30.
//  Copyright © 2016年 bipi. All rights reserved.
//

#import "DBBaseViewController.h"

#import "iflyMSC/iflyMSC.h"
@class IFlyDataUploader;
@class IFlySpeechRecognizer;
@class IFlyPcmRecorder;

@interface SendMessageViewController : DBBaseViewController<IFlySpeechRecognizerDelegate,IFlyPcmRecorderDelegate>



@property (nonatomic, strong) NSString *pcmFilePath;//音频文件路径
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象
@property (nonatomic, strong) IFlyDataUploader *uploader;//数据上传对象
@property (nonatomic,strong) IFlyPcmRecorder *pcmRecorder;//录音器，用于音频流识别的数据传入
@property (nonatomic,assign) BOOL isStreamRec;//是否是音频流识别
@property (nonatomic,assign) BOOL isBeginOfSpeech;//是否返回BeginOfSpeech回调
@property (nonatomic, strong) NSString * result;
@property (nonatomic, assign) BOOL isCanceled;

- (IBAction)AddPersonButtonClick:(id)sender;
@property(nonatomic,copy)NSString *Type;   //weixin ?

@property(nonatomic,copy)NSString *PhoneNumber;
@property(nonatomic,copy)NSString *CustomerID;

@property(nonatomic,copy)NSString *Name;
@property(nonatomic,strong)NSIndexPath *BrandIndexPath;

@property (weak, nonatomic) IBOutlet UITableView *PublicTableView;

@property (weak, nonatomic) IBOutlet UIImageView *PublicImageView;
@property (weak, nonatomic) IBOutlet UIImageView *MineImageView;

@property (weak, nonatomic) IBOutlet UIView *VoiveView;
//@property (weak, nonatomic) IBOutlet UITextField *VoiceTextField;

@property (weak, nonatomic) IBOutlet UITextView *VoiceTextView;

@property (strong, nonatomic) IBOutlet UIButton *YuYinGenJinLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imgview1;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UIImageView *yuyinImage;

@property (weak, nonatomic) IBOutlet UILabel *MessageName;
@property (weak, nonatomic) IBOutlet UIView *MineView;
@property (weak, nonatomic) IBOutlet UIView *PublicView;


@property (weak, nonatomic) IBOutlet UIView *ChangeMesaageView;
- (IBAction)ChangeMessButtonCancle:(id)sender;
- (IBAction)ChangeMessageButtonSure:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *ChangeTitleTF;

@property (weak, nonatomic) IBOutlet UITextView *ChangeTextView;
@property (weak, nonatomic) IBOutlet UIView *BGView;

- (IBAction)GoBack:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;

@end
