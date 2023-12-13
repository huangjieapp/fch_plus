//
//  RecoLive.h
//  RecoLive
//
//  Created by Mu Jinpeng on 2016/11/2.
//  Copyright © 2016年 Mu Jinpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecoLiveEvent.h"
#import <UIKit/UIKit.h>

@interface RecoLive : NSObject

-(id)initWith:(RecoLiveEvent *)event;

// Initialize.
-(void)initializeWithPhoneNumber:(NSString*)phone password:(NSString*)password deviceID:(NSString *)devID;


//creat window
-(UIView *)WndCreate:(int)iX y:(int)iY w:(int)iW h:(int)iH;


// Start and stop the live.
-(BOOL)Start;
-(void)Stop;

//send message
-(BOOL)SendMessage:(NSString *)message;

// Start and stop video.
-(BOOL)VideoStart;
-(void)VideoStop;

//销毁视频播放窗口和对象
-(void)WndDestroy;
-(void)Cleanup;

//参数iMode: 0为裁剪、1为整幅、2为拉伸
-(BOOL)VideoShowMode:(int)iMode;


@end
