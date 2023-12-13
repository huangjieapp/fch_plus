//
//  SHChatBarView.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/1.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString*const KNotifactionShowChooseView=@"KNotifactionShowChooseView";
static NSString*const KNotifactionHiddenChooseView=@"KNotifactionHiddenChooseView";
typedef void(^VOICEBLOCK)();
typedef void(^TEXTBLOCK)();

typedef NS_ENUM(NSInteger,SHChatBarType){
    SHChatBarTypeNoneView=0,
    SHChatBarTypeShowVoice,
    
    SHChatBarTypeshowKeyBoard,
    SHChatBarTypeshowSendText,
    
    SHChatBarTypeshowOtherView
    
};


@protocol SHChatBarViewDelegate <NSObject>

-(void)chatBarOfVoice:(UILongPressGestureRecognizer*)gesture;

-(void)chatBarOfSend:(NSString*)str;



@end


@interface SHChatBarView : UIView

@property (nonatomic, copy) VOICEBLOCK voiceB;
@property (nonatomic, copy) TEXTBLOCK textB;

@property (weak, nonatomic) IBOutlet YYTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *voiceRecordButton;

@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@property (weak, nonatomic) IBOutlet UIButton *otherButton;
@property (weak, nonatomic) IBOutlet UIButton *faceButton;


@property(nonatomic,assign)SHChatBarType showType;


@property(nonatomic,assign)CGFloat keyBoardHeight;
@property(nonatomic,assign)id<SHChatBarViewDelegate>delegate;
@end
