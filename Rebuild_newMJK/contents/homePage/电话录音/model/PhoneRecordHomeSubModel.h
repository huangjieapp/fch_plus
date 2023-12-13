//
//  PhoneRecordHomeSubModel.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/25.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneRecordHomeSubModel : MJKBaseModel

@property(nonatomic,strong)NSString*C_CALLED;   //被叫号码
@property(nonatomic,strong)NSString*C_CALLER;    //主叫号码
@property(nonatomic,strong)NSString*C_ID;   //通话记录id
@property(nonatomic,strong)NSString*C_MINUTE;   //通话时长
@property(nonatomic,strong)NSString*C_PICURL;
@property(nonatomic,strong)NSString*C_RESULT_DD_ID;    //处理结果   A45000_C_RESULT_0001   003   004
@property(nonatomic,strong)NSString*C_RESULT_DD_NAME;   //处理结果  (未分配 和  已分配  无效  员工)
@property(nonatomic,strong)NSString*C_URL;   //录音地址
@property(nonatomic,strong)NSString*D_HMS_TIME;  // "2017-08-18 18:53:49";
@property(nonatomic,strong)NSString*D_TIME;    //时间
//0呼入  1呼出
@property(nonatomic,strong)NSString*I_DIRECTION;   //以我的手机为中心      1我的手机呼出取被叫号码     0我的手机被呼入取主叫号码


@end



//"C_CALLED" = 9013782876323;
//"C_CALLER" = 20528642;
//"C_ID" = "00B76701-153E-420B-AB9A-4E30F6E98A80";
//"C_MINUTE" = "11\U79d2";
//"C_PICURL" = "";
//"C_RESULT_DD_ID" = "A45000_C_RESULT_0001";
//"C_RESULT_DD_NAME" = "\U672a\U5206\U914d";
//"C_URL" = "http://101.231.48.17:55503/{00B76701-153E-420B-AB9A-4E30F6E98A80}.wav";
//"D_HMS_TIME" = "2017-08-18 18:53:49";
//"D_TIME" = "18:53";
//"I_DIRECTION" = 1;
