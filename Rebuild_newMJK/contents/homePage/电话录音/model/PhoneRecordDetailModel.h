//
//  PhoneRecordDetailModel.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/25.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneRecordDetailModel : MJKBaseModel
@property(nonatomic,strong)NSString*C_CALLED;           //被叫号码
@property(nonatomic,strong)NSString*C_CALLER;           //主叫号码
@property(nonatomic,strong)NSString*C_ID;                //通话记录id
@property(nonatomic,strong)NSString*C_LASTC_RESULT_DD_NAME;   //上次处理结构
@property(nonatomic,strong)NSString*C_LAST_RESULT_DD_ID;  //上次处理结构
@property(nonatomic,strong)NSString*C_LAST_A41500_ID;     //上次潜客id
@property(nonatomic,strong)NSString*C_LAST_A41500_NAME;    //上次潜客名称  关联会员
@property(nonatomic,strong)NSString*C_LAST_OWNER_NAME;    //上次接待顾问
@property(nonatomic,strong)NSString*C_PICURL;
@property(nonatomic,strong)NSString*C_RESULT_DD_ID;   //处理结果
@property(nonatomic,strong)NSString*C_RESULT_DD_NAME;   //处理结果     判断是未分配 就显示3个按钮  否则不显示
@property(nonatomic,strong)NSString*C_URL;            //录音地址
@property(nonatomic,strong)NSString*D_LAST_UPDATE_TIME;  //上次处理时间
@property(nonatomic,strong)NSString*D_SYSTEMTIM;    //时间
@property(nonatomic,strong)NSString*I_ARRIVAL;    //来电次数
@property(nonatomic,strong)NSString*I_DIRECTION;  //0 呼入 1呼出

@end



//"C_CALLED" = 913661475900;
//"C_CALLER" = 20528642;
//"C_ID" = "009F73F0-F75F-4B1D-AB8E-A9196628098D";
//"C_LASTC_RESULT_DD_NAME" = "";
//"C_LAST_A41500_ID" = "";
//"C_LAST_A41500_NAME" = "";
//"C_LAST_OWNER_NAME" = "";
//"C_LAST_RESULT_DD_ID" = "";
//"C_PICURL" = "";
//"C_RESULT_DD_ID" = "A45000_C_RESULT_0001";
//"C_RESULT_DD_NAME" = "\U672a\U5206\U914d";
//"C_URL" = "http://101.231.48.17:55503/{009F73F0-F75F-4B1D-AB8E-A9196628098D}.wav";
//"D_LAST_UPDATE_TIME" = "";
//"D_SYSTEMTIM" = "2017-08-25 14:22:38";
//"I_ARRIVAL" = 11;
//"I_DIRECTION" = 1;
