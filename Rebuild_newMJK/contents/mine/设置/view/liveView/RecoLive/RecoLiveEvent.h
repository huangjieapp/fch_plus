//
//  RecoLiveEvent.h
//  RecoLive
//
//  Created by Mu Jinpeng on 2016/11/3.
//  Copyright © 2016年 Mu Jinpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RecoLiveEventDelegate <NSObject>

@optional
//初始化接口回调
-(void)onInitializeReturnCode:(int)code infoString:(NSString *)info;
//登陆服务器
-(void)onLogin;
// 登出
-(void)onLogout;
//连接到采集端
-(void)onConnect;

//采集端离线
-(void)onOffLine;
//连接断开
-(void)onDisconnected;


@end


@interface RecoLiveEvent : NSObject
@property(nonatomic,assign)id<RecoLiveEventDelegate>delegate;
-(void)OnEvent:(NSString*)sAction data:(NSString*)sData render:(NSString*)sRender;

@end
