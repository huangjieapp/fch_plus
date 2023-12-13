//
//  TopCountModel.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/9.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopCountModel : MJKBaseModel

@property(nonatomic,strong)NSString*BJ_BL;  //报价比例
@property(nonatomic,strong)NSString*BJ_FLAG; //报价flag 0无箭头   DOWN下箭头   UP上箭头
@property(nonatomic,strong)NSString*BJ_JRCOUNT;  //今日数字
@property(nonatomic,strong)NSString*BJ_MIDCOUNT;  //月累计

@property(nonatomic,strong)NSString*DD_BL;  //订单比例
@property(nonatomic,strong)NSString*DD_FLAG;
@property(nonatomic,strong)NSString*DD_JRCOUNT;
@property(nonatomic,strong)NSString*DD_MIDCOUNT;

@property(nonatomic,strong)NSString*GJ_BL;  //跟进
@property(nonatomic,strong)NSString*GJ_FLAG;
@property(nonatomic,strong)NSString*GJ_JRCOUNT;
@property(nonatomic,strong)NSString*GJ_MIDCOUNT;

@property(nonatomic,strong)NSString*JF_BL;  //交付
@property(nonatomic,strong)NSString*JF_FLAG;
@property(nonatomic,strong)NSString*JF_JRCOUNT;
@property(nonatomic,strong)NSString*JF_MIDCOUNT;

@property(nonatomic,strong)NSString*LD_BL;  //来电
@property(nonatomic,strong)NSString*LD_FLAG;
@property(nonatomic,strong)NSString*LD_JRCOUNT;
@property(nonatomic,strong)NSString*LD_MIDCOUNT;

@property(nonatomic,strong)NSString*LL_BL;  //流量
@property(nonatomic,strong)NSString*LL_FLAG;
@property(nonatomic,strong)NSString*LL_JRCOUNT;
@property(nonatomic,strong)NSString*LL_MIDCOUNT;

@property(nonatomic,strong)NSString*QK_BL;  //潜客
@property(nonatomic,strong)NSString*QK_FLAG;
@property(nonatomic,strong)NSString*QK_JRCOUNT;
@property(nonatomic,strong)NSString*QK_MIDCOUNT;

@property(nonatomic,strong)NSString*QX_BL;   //取消
@property(nonatomic,strong)NSString*QX_FLAG;
@property(nonatomic,strong)NSString*QX_JRCOUNT;
@property(nonatomic,strong)NSString*QX_MIDCOUNT;

@property(nonatomic,strong)NSString*XS_BL;   //线索
@property(nonatomic,strong)NSString*XS_FLAG;
@property(nonatomic,strong)NSString*XS_JRCOUNT;
@property(nonatomic,strong)NSString*XS_MIDCOUNT;

@property(nonatomic,strong)NSString*YY_BL;   //预约
@property(nonatomic,strong)NSString*YY_FLAG;
@property(nonatomic,strong)NSString*YY_JRCOUNT;
@property(nonatomic,strong)NSString*YY_MIDCOUNT;

@property(nonatomic,strong)NSString*ZB_BL;   //战败
@property(nonatomic,strong)NSString*ZB_FLAG;
@property(nonatomic,strong)NSString*ZB_JRCOUNT;
@property(nonatomic,strong)NSString*ZB_MIDCOUNT;

@property(nonatomic,strong)NSString*ZMT_BL;  //自媒体
@property(nonatomic,strong)NSString*ZMT_FLAG;
@property(nonatomic,strong)NSString*ZMT_JRCOUNT;
@property(nonatomic,strong)NSString*ZMT_MIDCOUNT;


@end
//TOPCOUNT =     {
//    "BJ_BL" = "0%";
//    "BJ_FLAG" = 0;
//    "BJ_JRCOUNT" = 0;
//    "BJ_MIDCOUNT" = 0;
//    "DD_BL" = "0%";
//    "DD_FLAG" = 0;
//    "DD_JRCOUNT" = 0;
//    "DD_MIDCOUNT" = 0;
//    "GJ_BL" = "0%";
//    "GJ_FLAG" = 0;
//    "GJ_JRCOUNT" = 0;
//    "GJ_MIDCOUNT" = 0;
//    "JF_BL" = "0%";
//    "JF_FLAG" = 0;
//    "JF_JRCOUNT" = 0;
//    "JF_MIDCOUNT" = 0;
//    "LD_BL" = "0%";
//    "LD_FLAG" = 0;
//    "LD_JRCOUNT" = 0;
//    "LD_MIDCOUNT" = 0;
//    "LL_BL" = "0%";
//    "LL_FLAG" = 0;
//    "LL_JRCOUNT" = 0;
//    "LL_MIDCOUNT" = 0;
//    "QK_BL" = "0%";
//    "QK_FLAG" = 0;
//    "QK_JRCOUNT" = 0;
//    "QK_MIDCOUNT" = 0;
//    "QX_BL" = "0%";
//    "QX_FLAG" = 0;
//    "QX_JRCOUNT" = 0;
//    "QX_MIDCOUNT" = 0;
//    "XS_BL" = "0%";
//    "XS_FLAG" = 0;
//    "XS_JRCOUNT" = 0;
//    "XS_MIDCOUNT" = 0;
//    "YY_BL" = "0%";
//    "YY_FLAG" = 0;
//    "YY_JRCOUNT" = 0;
//    "YY_MIDCOUNT" = 0;
//    "ZB_BL" = "100%";
//    "ZB_FLAG" = DOWN;
//    "ZB_JRCOUNT" = 0;
//    "ZB_MIDCOUNT" = 2;
//    "ZMT_BL" = "0%";
//    "ZMT_FLAG" = 0;
//    "ZMT_JRCOUNT" = 0;
//    "ZMT_MIDCOUNT" = 0;
//};
