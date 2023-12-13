//
//  MJKSatisfactionView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/22.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKSatisfactionView.h"

#import "WXApi.h"

@interface MJKSatisfactionView ()
/** 二维码*/
@property (nonatomic, strong) UIImageView *QRImageView;
/** 图片*/
@property (nonatomic, strong) NSString *imageStr;
/** 评价按钮*/
@property (nonatomic, strong) UIButton *satisfaction_flagButton;
@end

@implementation MJKSatisfactionView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		
		[self createView];
	}
	return self;
}

- (void)createView {
	UIView *bgView = [[UIView alloc]initWithFrame:self.frame];
	[self addSubview:bgView];
	bgView.backgroundColor = [UIColor blackColor];
	bgView.alpha = 0.5;
	CGFloat height = (KScreenWidth - 10) + 88;
	UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeViewAction)];
	[bgView addGestureRecognizer:tapGR];
	
	UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(5, (KScreenHeight - height) / 2, KScreenWidth - 10, height)];
	[self addSubview:contentView];
	contentView.backgroundColor = [UIColor whiteColor];
	UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(contentView.frame) - 10 - 20, 10, 20, 20)];
	[closeButton setImage:@"X图标"];
	[closeButton addTarget:self action:@selector(closeViewAction)];
	[contentView addSubview:closeButton];
	
	CGFloat imageViewWidth = contentView.frame.size.width - 80;
	UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((contentView.frame.size.width - imageViewWidth) / 2, CGRectGetMaxY(closeButton.frame) + 10, imageViewWidth , imageViewWidth)];
//	imageView.image = [UIImage imageNamed:@"logo"];
	self.QRImageView = imageView;
	[contentView addSubview:imageView];
	
	UILabel *noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10, contentView.frame.size.width, 20)];
	noteLabel.text = @"扫描二维码,满意度调查";
	noteLabel.font = [UIFont systemFontOfSize:14.f];
	noteLabel.textColor = [UIColor blackColor];
	[contentView addSubview:noteLabel];
	noteLabel.textAlignment = NSTextAlignmentCenter;
	
	CGFloat wechatWidth = height - noteLabel.frame.origin.y - noteLabel.frame.size.height - 20;
	UIButton *weChatButton = [[UIButton alloc]initWithFrame:CGRectMake((contentView.frame.size.width - wechatWidth) / 2, CGRectGetMaxY(noteLabel.frame) + 10, wechatWidth, wechatWidth)];
	[weChatButton addTarget:self action:@selector(shareFriend)];
	[weChatButton setImage:@"微信好友"];
	[contentView addSubview:weChatButton];
	
	UIButton *satisfaction_flagButton = [[UIButton alloc]initWithFrame:CGRectMake(contentView.frame.size.width - 100, CGRectGetMaxY(weChatButton.frame) - 30, 90, 30)];
	[satisfaction_flagButton setTitleNormal:@"查看评价"];
	[satisfaction_flagButton setTitleColor:KNaviColor];
	satisfaction_flagButton.hidden = YES;
	satisfaction_flagButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
	[contentView addSubview:satisfaction_flagButton];
	[satisfaction_flagButton addTarget:self action:@selector(showEvaluation)];
	self.satisfaction_flagButton = satisfaction_flagButton;
}
//分享到朋友圈
- (void)shareFriend {
	WXMediaMessage *message = [WXMediaMessage message];
	[message setThumbImage:[UIImage imageNamed:@""]];
	//缩略图
	WXImageObject *imageObject = [WXImageObject object];
	imageObject.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageStr]];
	message.mediaObject = imageObject;
	
	SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
	req.bText = NO;
	req.message = message;
	req.scene = WXSceneSession;
	[WXApi sendReq:req completion:nil];
}
//查看评价
- (void)showEvaluation {
	WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
	launchMiniProgramReq.userName = [NewUserSession instance].C_GID;  //拉起的小程序的username
	launchMiniProgramReq.path = [NSString stringWithFormat:@"/pages/evaluateList/evaluateList?objectid=%@",self.C_OBJECTID] ;    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
	launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
	[WXApi sendReq:launchMiniProgramReq completion:nil];
}

- (void)closeViewAction {
	[self removeFromSuperview];
}

- (void)setC_OBJECTID:(NSString *)C_OBJECTID {
	_C_OBJECTID = C_OBJECTID;
	[self httpQrCode];
}

- (void)setSatisfaction_flag:(NSString *)satisfaction_flag {
	_satisfaction_flag = satisfaction_flag;
	if ([satisfaction_flag isEqualToString:@"true"]) {
		self.satisfaction_flagButton.hidden = NO;
	}
	
}

- (void)httpQrCode {
	DBSelf(weakSelf);
	HttpManager *manager = [[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:@"https://xcx.51mcr.com/api/comment/qrcodeToCommit" parameters:@{@"objectid" : self.C_OBJECTID} compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		[weakSelf.QRImageView sd_setImageWithURL:[NSURL URLWithString:data[@"mine"][@"qrcode"]]];
		weakSelf.imageStr = data[@"mine"][@"qrcode"];
	}];
}

@end
