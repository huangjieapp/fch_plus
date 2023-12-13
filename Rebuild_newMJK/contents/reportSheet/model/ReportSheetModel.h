//
//  ReportSheetModel.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/10.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportSheetModel : MJKBaseModel

@property(nonatomic,strong)NSString*DDL;
@property(nonatomic,strong)NSString*DD_ALL;
@property(nonatomic,strong)NSString*DD_AZ;
@property(nonatomic,strong)NSString*DD_DJ;
@property(nonatomic,strong)NSString*DD_QY;
@property(nonatomic,strong)NSString*DD_XD;
@property(nonatomic,strong)NSString*LL_ALL;
@property(nonatomic,strong)NSString*LL_LD;
@property(nonatomic,strong)NSString*LL_MD;
@property(nonatomic,strong)NSString*LL_XS;
@property(nonatomic,strong)NSString*QDL;
@property(nonatomic,strong)NSString*WGL;
@property(nonatomic,strong)NSString*WG_ALL;
@property(nonatomic,strong)NSString*WG_JE;
@property(nonatomic,strong)NSString*WG_KDJ;
@property(nonatomic,strong)NSString*YX_ALL;
@property(nonatomic,strong)NSString*YX_LD;
@property(nonatomic,strong)NSString*YX_MD;
@property(nonatomic,strong)NSString*YX_QT;
@property(nonatomic,strong)NSString*YX_XS;
@property(nonatomic,strong)NSString*YY_ALL;
@property(nonatomic,strong)NSString*YY_WDD;
@property(nonatomic,strong)NSString*YY_YDD;
@property(nonatomic,strong)NSString*YY_YQX;
@property(nonatomic,strong)NSString*ZHL;

/** 比率的list*/
@property (nonatomic, strong) NSArray *BFB_LIST;
/** 漏斗数字的list*/
@property (nonatomic, strong) NSArray *LIST;


/** 比率的list*/
@property (nonatomic, strong) NSArray *bfbList;
/** 漏斗数字的list*/
@property (nonatomic, strong) NSArray *tabList;


@end



//{
//    CJJCZQ = 9;
//    CJJE = "1,358,829";
//    CJKDJ = "97,059";
//    CJS = 14;
//    DD = 73;
//    DDJE = "2,939,300";
//    DDL = "5%";
//    DDS = 35;
//    DDZHL = "69%";
//    DDZQ = 78;
//    DHXS = 11;
//    JFB = "40%";
//    KDJ = "83,980";
//    LDL = "21%";
//    LDLDS = 4;
//    LDS = 51;
//    MDLDS = 8;
//    QTLDS = 32;
//    SCYY = 1;
//    SJYY = 68;
//    WLLDS = 7;
//    WLXS = 11;
//    XS = 22;
//    ZCYY = 4;
//    code = 200;
//    message = "\U64cd\U4f5c\U6210\U529f";
//}
