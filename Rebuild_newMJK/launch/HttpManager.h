//
//  HttpManager.h
//  AliShake
//
//  Created by 李鹏博 on 15/10/16.
//  Copyright © 2015年 李鹏博. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "AFNetworking.h"
typedef void(^resultBlock)(id data,NSError *error);

@interface HttpManager : NSObject<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}
@property(nonatomic,copy)resultBlock block;
//封装的get请求
-(void)getDataFromNetworkWithUrl:(NSString*)urlString parameters:(id)parameters compliation:(resultBlock)newBlock;

//封装的get请求 没有hud
-(void)getDataFromNetworkNOHUDWithUrl:(NSString*)urlString parameters:(id)parameters compliation:(resultBlock)newBlock;

//封装的post请求
-(void)postDataFromNetworkWithUrl:(NSString*)urlString parameters:(id)parameters compliation:(resultBlock)newBlock;
//没有菊花的 post请求
-(void)postDataFromNetworkNoHudWithUrl:(NSString*)urlString parameters:(id)parameters compliation:(resultBlock)newBlock;

//封装的get请求
-(void)getNewDataFromNetworkWithUrl:(NSString*)urlString parameters:(id)parameters compliation:(resultBlock)newBlock;

//封装的get请求 没有hud
-(void)getNewDataFromNetworkNOHUDWithUrl:(NSString*)urlString parameters:(id)parameters compliation:(resultBlock)newBlock;

//封装的post请求
-(void)postNewDataFromNetworkWithUrl:(NSString*)urlString parameters:(id)parameters compliation:(resultBlock)newBlock;
//没有菊花的 post请求
-(void)postNewDataFromNetworkNoHudWithUrl:(NSString*)urlString parameters:(id)parameters compliation:(resultBlock)newBlock;


//封装的 post 上传图片请求
-(void)postDataUpDataPhotoWithUrl:(NSString*)urlString parameters:(id)parameters photo:(NSData*)data compliation:(resultBlock)newBlock;
//封装的 post 上传素材图片请求
-(void)postDataUpDataMaterialPhotoWithUrl:(NSString*)urlString parameters:(id)parameters photo:(NSArray*)data  andMimeType:(NSString *)mimeType compliation:(resultBlock)newBlock;

-(void)postDataUpDataHeadPhotoWithUrl:(NSString*)urlString parameters:(id)parameters photo:(NSData*)data compliation:(resultBlock)newBlock;
//封装的post 带有HTTPRequestHeader
-(void)postDataAndRequestHeaderNoHudWithUrl:(NSString*)urlString parameters:(id)parameters andRequestHeader:(id)requestHeader compliation:(resultBlock)newBlock;
//上传文件
-(void)postDataUpDataFileWithUrl:(NSString*)urlString parameters:(id)parameters file:(NSData*)data andFileName:(NSString *)fileName andMimeType:(NSString *)type compliation:(resultBlock)newBlock;

-(void)oldPostDataFromNetworkNoHudWithUrl:(NSString*)urlString parameters:(id)parameters compliation:(resultBlock)newBlock;
-(void)postDataQiNiuUpDataFileWithUrl:(NSString*)urlString parameters:(id)parameters file:(NSData*)data andFileName:(NSString *)fileName andMimeType:(NSString *)type compliation:(resultBlock)newBlock;
@end
