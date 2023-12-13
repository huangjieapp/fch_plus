//
//  CGCOrderDetailModel.h
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/22.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGCOrderHtPojoDetailModel : MJKBaseModel
/** <#注释#> */
@property (nonatomic, strong) NSString *C_A42000_C_ID;
@property (nonatomic, strong) NSString *C_FQFGR_NAME;
@property (nonatomic, strong) NSString *C_FQFGR_PHONE;
@property (nonatomic, strong) NSString *C_FQFGSZT_ADDRESS;
@property (nonatomic, strong) NSString *C_FQFGSZT_ID;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_FQFGSZT_NAME;
@property (nonatomic, strong) NSString *C_FQFGSZT_PHONE;
@property (nonatomic, strong) NSString *C_JSF_ID;
@property (nonatomic, strong) NSString *C_JSF_NAME;
@property (nonatomic, strong) NSString *C_JSF_PHONE;
@property (nonatomic, strong) NSString *I_FQFLX;
/** <#注释#> */
@property (nonatomic, strong) NSString *I_JSFLX;
@property (nonatomic, strong) NSString *htUrl;


@end


@interface CGCOrderA801DetailModel : MJKBaseModel
/** <#注释#> */
@property (nonatomic, strong) NSString *B_KPJ;
@property (nonatomic, strong) NSString *C_A80000CJ_C_ID;
@property (nonatomic, strong) NSString *C_A80000CJ_C_NAME;
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_NAME;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_FP_TYPE;
@property (nonatomic, strong) NSString *C_FP_TYPE_NAME;
@property (nonatomic, strong) NSString *I_SFSQWT;
@property (nonatomic, strong) NSString *I_SFDFK;
@property (nonatomic, strong) NSString *I_GZD;
@property (nonatomic, strong) NSString *C_FP_COMPANY;
@property (nonatomic, strong) NSString *C_FP_TAX;
@property (nonatomic, strong) NSString *C_FP_PHONE;
@property (nonatomic, strong) NSString *C_FP_ADDRESS;
@property (nonatomic, strong) NSString *C_FP_BANK;
@property (nonatomic, strong) NSString *C_FP_ACCOUNT;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_FP_EMAIL;
@property (nonatomic, strong) NSString *C_SJR_PHONE;
@property (nonatomic, strong) NSString *C_SJR_NAME;
@property (nonatomic, strong) NSString *C_INFORM_THE_SINGLE;
@property (nonatomic, strong) NSString *C_FP_GR;
@property (nonatomic, strong) NSString *C_FP_SFZ;

/** <#注释#> */
@property (nonatomic, strong) CGCOrderHtPojoDetailModel *htPojo;

@end



@interface CGCOrderDetailModel : MJKBaseModel
@property (nonatomic, strong) NSString *C_A80000CJ_C_ID;
@property (nonatomic, strong) NSString *C_A80000CJ_C_NAME;
@property (nonatomic, strong) NSString *C_A800SKZH_C_ID;
@property (nonatomic, strong) NSString *C_A800SKZH_C_NAME;
@property (nonatomic, strong) NSString *C_XDSPR;
@property (nonatomic, strong) NSString *C_XDSPR_NAME;
@property (nonatomic, strong) NSString *B_KPJ;
/** USER_ID*/
@property (nonatomic, strong) NSString *USER_ID;
/** USER_NAME*/
@property (nonatomic, strong) NSString *USER_NAME;
///现金优惠
@property(nonatomic,strong) NSString * B_CASHDISCOUNT;
///
@property(nonatomic,strong) NSString * B_COMMISSION;
///
@property(nonatomic,copy) NSString * B_DECORATEFEE;
///
@property(nonatomic,copy) NSString * B_DEPOSIT;
///
@property(nonatomic,copy) NSString * B_FINANCIALFEE;
///总价【必填】
@property(nonatomic,copy) NSString * B_GUIDEPRICE;
///
@property(nonatomic,copy) NSString * B_INSURANCEFEE;
///
@property(nonatomic,copy) NSString * B_JIAJIA;
///
@property(nonatomic,copy) NSString * B_LICENCEFEE;
///
@property(nonatomic,copy) NSString * B_MONEY;
///
@property(nonatomic,copy) NSString * B_MONEY_TOTAL;
///
@property(nonatomic,copy) NSString * B_NUMBER;
///
@property(nonatomic,copy) NSString * B_PURCHASETAX;
///
@property(nonatomic,copy) NSString * B_SERVICEFEE;
/** <#注释#> */
@property (nonatomic, strong) NSString *B_BOUTIQUE_COST;
///
@property(nonatomic,copy) NSString * B_TESTSERVICEFEE;
///
@property(nonatomic,copy) NSString * B_WARRANTYFEE;
///
@property(nonatomic,copy) NSString * B_ZONGJIA;
///
@property(nonatomic,copy) NSString * C_A40500_C_ID;
///
@property(nonatomic,copy) NSString * C_A40500_C_NAME;
///意向车型
@property(nonatomic,copy) NSString * C_A40600_C_ID;
///
@property(nonatomic,copy) NSString * C_A40600_C_NAME;
@property(nonatomic,copy) NSString * C_A49600_C_ID;
///
@property(nonatomic,copy) NSString * C_A49600_C_NAME;

@property(nonatomic,copy) NSString *C_A70600_C_ID;
@property(nonatomic,copy) NSString *C_A70600_C_NAME;

///
@property(nonatomic,copy) NSString * C_A41200_C_ID;
///
@property(nonatomic,copy) NSString * C_A41200_C_NAME;
@property(nonatomic,copy) NSString * C_A48200_C_ID;
@property(nonatomic,copy) NSString * C_CLUESOURCE_DD_ID;
@property(nonatomic,copy) NSString * C_CLUESOURCE_DD_NAME;
///客户C_ID
@property(nonatomic,copy) NSString * C_A41500_C_ID;
///
@property(nonatomic,copy) NSString * C_A41500_C_NAME;
///
@property(nonatomic,copy) NSString * C_A41900_C_ID;
///
@property(nonatomic,copy) NSString * C_A41900_C_NAME;
///
@property(nonatomic,copy) NSString * C_ADDRESS;
///
@property(nonatomic,copy) NSString * C_ALLOCATION;
///客户姓名
@property(nonatomic,copy) NSString * C_BUYNAME;
///
@property(nonatomic,copy) NSString * C_BUYPHONE;
///
@property(nonatomic,copy) NSString * C_HEADIMGURL;
///
@property(nonatomic,copy) NSString * C_ID;
///
@property(nonatomic,copy) NSString * C_OFFERPIC;
///
@property(nonatomic,copy) NSString * C_ORDERPIC;
///
@property(nonatomic,copy) NSString * C_OWNER_ROLEID;
///职位名称
@property(nonatomic,copy) NSString * C_OWNER_ROLENAME;
///
@property(nonatomic,copy) NSString * C_PHONE;
///
@property(nonatomic,copy) NSString * C_PURCHASEWAY_DD_ID;
///
@property(nonatomic,copy) NSString * C_PURCHASEWAY_DD_NAME;
///
@property(nonatomic,copy) NSString * C_SEX_DD_ID;
///
@property(nonatomic,copy) NSString * C_SEX_DD_NAME;
///
@property(nonatomic,copy) NSString * C_STATUS_DD_ID;
///订单编号
@property(nonatomic,copy) NSString * C_VOUCHERID;
@property(nonatomic,copy) NSString *C_OWNER_PHONE;

@property(nonatomic,copy) NSString *C_SKFS_DD_NAME;
@property(nonatomic,copy) NSString *C_SKFS_DD_ID;
@property(nonatomic,copy) NSString *B_OTHER;
@property(nonatomic,copy) NSString *X_BILLINGPICURL;

///订单状态名
@property(nonatomic,copy) NSString * C_STATUS_DD_NAME;
@property(nonatomic,copy) NSString *C_TYPE_DD_ID;
@property(nonatomic,copy) NSString *C_TYPE_DD_NAME;
@property(nonatomic,copy) NSString *C_A82300_C_ID;
@property(nonatomic,copy) NSString *C_A82300_C_NAME;
@property(nonatomic,copy) NSString *C_A823VOUCHERID;
///下单时间
@property(nonatomic,copy) NSString * D_ORDER_TIME;
///
@property(nonatomic,copy) NSString * D_SEND_TIME;
///预计交付时间
@property(nonatomic,copy) NSString * D_START_TIME;
///已付金额合计
@property(nonatomic,copy) NSString * SumMoney;
///订单明细备注（仅MJK2.0有此字段）
@property(nonatomic,copy) NSString * X_INTENTIONREMARK;
///图片地址（多个以逗号隔开，仅MJK2.0有此字段）
@property(nonatomic,copy) NSString * X_PICURL;
///订单备注
@property(nonatomic,copy) NSString * X_REMARK;
///预估单值
@property(nonatomic,copy) NSString * B_ESTIMATE;
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_WECHAT;
/** <#注释#> */
@property (nonatomic, strong) CGCOrderA801DetailModel *a801;

/** <#注释#>*/
@property (nonatomic, strong) NSString *C_ZP;
@property(nonatomic,copy) NSString * D_FACTORYODRDER_TIME;
@property(nonatomic,copy) NSString * D_RECEIVED_TIME;
@property(nonatomic,copy) NSString * C_BILLINGID;
@property(nonatomic,copy) NSString * C_BILLINGNAME;
@property(nonatomic,copy) NSString * C_FACTORYNUMBER;

@property(nonatomic,copy) NSString * C_STAR_DD_ID;
@property(nonatomic,copy) NSString * C_STAR_DD_NAME;
@property (nonatomic, strong) NSString *C_ASSISTANTNAMES;

@property(nonatomic,copy) NSString * B_DOWNPAYMENTS;//定金
@property(nonatomic,copy) NSString * B_MONTHLYSUPPLY;//已付金额
@property(nonatomic,copy) NSString *C_DESIGNER_ROLEID;
@property(nonatomic,copy) NSString *C_DESIGNER_ROLENAME;
/**主单单号*/
@property(nonatomic,copy) NSString *C_MASTERVOUCHERID;
/** 图片*/
@property (nonatomic, strong) NSArray *urlList;
/** <#注释#> */
@property (nonatomic, strong) NSArray *fileList;
/** 下单金额*/
@property (nonatomic, strong) NSString *B_INTEREST;
/** 验收人id*/
@property (nonatomic, strong) NSString *C_ACCEPTORID;
/** 验收人*/
@property (nonatomic, strong) NSString *C_ACCEPTORNAME;
/** 收货人id*/
@property (nonatomic, strong) NSString *C_CONSIGNEEID;
/** 收货人*/
@property (nonatomic, strong) NSString *C_CONSIGNEENAME;
/** 线索提供人*/
@property (nonatomic, strong) NSString *C_CLUEPROVIDER_ROLENAME;
/**线索提供人id*/
@property (nonatomic, strong) NSString *C_CLUEPROVIDER_ROLEID;
//D_SEND_TIME 完工时间
//@property (nonatomic, strong) NSString *D_SEND_TIME;
/** <#备注#>*/
@property (nonatomic, strong) NSString *C_OBJECTID;
/** 已评价*/
@property (nonatomic, strong) NSString *satisfaction_flag;
/** C_MENDER_ROLEID 项目经理*/
@property (nonatomic, strong) NSString *C_MANAGER_ROLEID;
/** <#备注#>*/
@property (nonatomic, strong) NSString *C_MANAGER_ROLENAME;

@property (nonatomic, strong) NSString *C_A47700_C_ID;
/** <#备注#>*/
@property (nonatomic, strong) NSString *C_A47700_C_NAME;
@property (nonatomic, strong) NSString *C_MERCHANT_ORDER_NO;
@property (nonatomic, strong) NSString *C_PAYCHANNEL;
@property (nonatomic, strong) NSString *C_PAYCHANNELNAME;


@property (nonatomic, strong) NSString *D_VIPJQ;
@property (nonatomic, strong) NSString *D_HTJHSJ;
@property (nonatomic, strong) NSString *C_SCYHQ;
@property (nonatomic, strong) NSString *C_SJZK;
@property (nonatomic, strong) NSString *D_FCSJ;
@property (nonatomic, strong) NSString *D_CCSJ;
@property (nonatomic, strong) NSString *D_SJQTSJ;
@property (nonatomic, strong) NSString *D_JHQTSJ;
@property (nonatomic, strong) NSString *D_SJCTSJ;
@property (nonatomic, strong) NSString *D_JHCTSJ;
@property (nonatomic, strong) NSString *D_SCGTSJ_TIME;
/** <#注释#>*/
@property (nonatomic, strong) NSString *D_YJXDSJ_TIME;
/** 退单意图*/
@property (nonatomic, strong) NSString *C_TDYX_DD_ID;
@property (nonatomic, strong) NSString *C_TDYX_DD_NAME;
/** 过单时间*/
@property (nonatomic, strong) NSString *D_GDSJ_TIME;
/** 签约时间*/
@property (nonatomic, strong) NSString *D_QUEREN_TIME;
/** 送货人*/
@property (nonatomic, strong) NSString *C_SHR_ROLEID;
@property (nonatomic, strong) NSString *C_SHR_ROLENAME;
/** 送货时间*/
@property (nonatomic, strong) NSString *D_SHSJ_TIME;
/** 安装人员*/
@property (nonatomic, strong) NSString *C_AZRY_ROLEID;
@property (nonatomic, strong) NSString *C_AZRY_ROLENAME;

@property (nonatomic, strong) NSString *D_SJAZSJ;
@property (nonatomic, strong) NSString *D_JHAZSJ;
@property (nonatomic, strong) NSString *C_ISMC;


@property (nonatomic, assign)  BOOL A42000_C_STATUS_0001_FALG;
@property (nonatomic, strong) NSString *A42000_C_STATUS_0001_MESSAGE;

@property (nonatomic, assign)  BOOL A42000_C_STATUS_0002_FALG;
@property (nonatomic, strong) NSString *A42000_C_STATUS_0002_MESSAGE;

@property (nonatomic, assign)  BOOL A42000_C_STATUS_0006_FALG;
@property (nonatomic, strong) NSString *A42000_C_STATUS_0006_MESSAGE;

@property (nonatomic, assign)  BOOL A42000_C_STATUS_0007_FALG;
@property (nonatomic, strong) NSString *A42000_C_STATUS_0007_MESSAGE;

@property (nonatomic, assign)  BOOL A42000_C_STATUS_0009_FALG;
@property (nonatomic, strong) NSString *A42000_C_STATUS_0009_MESSAGE;
@property (nonatomic, strong) NSString *C_INDUSTRY_DD_ID;
@property (nonatomic, strong) NSString *C_INDUSTRY_DD_NAME;
@property (nonatomic, strong) NSString *C_SPD;
@property (nonatomic, strong) NSString *C_VIN;
@property (nonatomic, strong) NSString *C_BILLING;
@property (nonatomic, strong) NSString *qtfy;
@property (nonatomic, strong) NSString *detailStr;
@property (nonatomic, strong) NSString *C_GDSPR;
/** <#注释#> */
@property (nonatomic, strong) NSString *B_A823GLS;
@property (nonatomic, strong) NSString *C_A823N_COLOR;
@property (nonatomic, strong) NSString *C_A823W_COLOR;


@property (nonatomic, getter=isSelected) BOOL selected;

@property (nonatomic, getter=isStar) BOOL star;


/** 是否补单*/
@property (nonatomic, strong) NSString *I_SFBD;

@end
