//
//  RecoLiveViw.m
//  mcr_manageShop
//
//  Created by Hjie on 2018/3/27.
//  Copyright © 2018年 月见黑. All rights reserved.
//

#import "RecoLiveViw.h"

@interface RecoLiveViw ()<RecoLiveEventDelegate> {
	RecoLive *live;
	RecoLiveEvent *event;
}

@end

@implementation RecoLiveViw
- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self initUIWithFrame:frame];
	}
	return self;
}

- (void)initUIWithFrame:(CGRect)frame {
	UIView *bgView = [[UIView alloc]initWithFrame:frame];
	bgView.backgroundColor = [UIColor blackColor];
	bgView.alpha = .5f;
	UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
	[bgView addGestureRecognizer:tapGR];
	[self addSubview:bgView];
	
	UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 40, (KScreenHeight - 390) / 2, 40, 40)];
	[closeButton setImage:[UIImage imageNamed:@"icon_module_general_close.png"] forState:UIControlStateNormal];
	[self addSubview:closeButton];
	[closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)initRecoLiveWithDic:(NSDictionary *)dic {
	event=[[RecoLiveEvent alloc] init];
	event.delegate=self;
	live=[[RecoLive alloc] initWith:event];
	/*
	 [KUSERDEFAULT setObject:name forKey:saveLoginName];
	 [KUSERDEFAULT setObject:password forKey:saveLoginCode];
	 */
	[live initializeWithPhoneNumber:[NewUserSession instance].configData.ruiwei_phoneNo password:[NewUserSession instance].configData.ruiwei_password deviceID:dic[@"C_NAME"]];
}

-(void)onInitializeReturnCode:(int)code infoString:(NSString *)info{
	if (code==0) {
		UIView* videoView =[live WndCreate:0 y:(KScreenHeight - 320) / 2 w:KScreenWidth  h:320];
		[self addSubview:videoView];
		[live VideoShowMode:1];
		[live Start];
		
	}else{
        [JRToast showWithText:info];
        [self closeView];
		NSLog(@"失败：%@",info);
	}
}

- (void)onLogin {
	[live VideoStart];
	[live SendMessage:@"start_video_live"];
}

- (void)onConnect {
	
}

-(void)onOffLine {
	[KVNProgress showErrorWithStatus:@"设备不在线"];
}

- (void)closeView {
	[live SendMessage:@"stop_video_live"];
	[live VideoStop];
	[live Stop];
	[live Cleanup];
	[self removeFromSuperview];
}
@end
