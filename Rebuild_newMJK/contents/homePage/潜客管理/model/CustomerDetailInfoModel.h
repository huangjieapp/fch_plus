//
//  CustomerDetailInfoModel.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/21.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomLabelModel.h"

@interface CustomerDetailInfoModel : MJKBaseModel
/** <#注释#>*/
@property (nonatomic, strong) NSString *I_SORTIDX;
@property (nonatomic, strong) NSString *I_SORTIDX_NAME;
@property(nonatomic,strong)NSString*C_ISMC;
@property(nonatomic,strong)NSString*SR;
@property(nonatomic,strong)NSString*C_A40500_C_ID;
@property(nonatomic,strong)NSString*C_A40500_C_NAME;
@property(nonatomic,strong)NSString*C_A40600_C_ID;     //意向车型
@property(nonatomic,strong)NSString*C_A40600_C_NAME;
@property(nonatomic,strong)NSString*C_A41200_C_ID;     //市场活动id
@property(nonatomic,strong)NSString*C_A41200_C_NAME;   //市场活动
@property(nonatomic,strong)NSString*C_A41500_C_ID;
@property(nonatomic,strong)NSString*C_ADDRESS;            //
@property(nonatomic,strong)NSString*C_BIRTHDAY_TIME;
@property(nonatomic,strong)NSString*C_CITY;              //市
@property(nonatomic,strong)NSString*C_CLUESOURCE_DD_ID;    //客户来源  id
@property(nonatomic,strong)NSString*C_CLUESOURCE_DD_NAME;   //客户来源
@property(nonatomic,strong)NSString*C_COMPANY;            //公司
@property(nonatomic,strong)NSString*C_EDUCATION_DD_ID;      //文化程度
@property(nonatomic,strong)NSString*C_EDUCATION_DD_NAME;   //文化程度
@property(nonatomic,strong)NSString*C_EMAIL;
@property(nonatomic,strong)NSString*C_EXISTING;   //现有车型
@property(nonatomic,strong)NSString*C_HEADIMGURL;   //头像
@property(nonatomic,strong)NSString*C_HEADIMGURL_SHOW;   //头像
@property(nonatomic,strong)NSString*C_HOBBY_DD_ID;    //爱好id
@property(nonatomic,strong)NSString*C_HOBBY_DD_NAME;   //爱好名字
@property(nonatomic,strong)NSString*C_ID;
@property(nonatomic,strong)NSString*C_INDUSTRY_DD_ID;    //行业ＴＹＰＥＣＯＤＥ＝A41500_C_INDUSTRY
@property(nonatomic,strong)NSString*C_INDUSTRY_DD_NAME;   //行业
@property(nonatomic,strong)NSString*C_LEVEL_DD_ID;      //潜客等级  id
@property(nonatomic,strong)NSString*C_LEVEL_DD_NAME;    //潜客等级  名字
@property(nonatomic,strong)NSString*B_DRIVE_LAT;    //
@property(nonatomic,strong)NSString*B_DRIVE_LON;    //
@property(nonatomic,strong)NSString*C_LICENSE_PLATE;   //车牌
@property(nonatomic,strong)NSString*C_MARITALSTATUS_DD_ID;    //婚姻状况
@property(nonatomic,strong)NSString*C_MARITALSTATUS_DD_NAME;   //婚姻状况
@property(nonatomic,strong)NSString*C_MODEFOLLOW_DD_ID;    //跟进方式
@property(nonatomic,strong)NSString*C_MODEFOLLOW_DD_NAME;   //跟进方式
@property(nonatomic,strong)NSString*C_NAME;                 //潜客姓名
@property(nonatomic,strong)NSString*C_BUYTYPE_DD_ID;                 //购车类型
@property(nonatomic,strong)NSString*C_OCCUPATION_DD_NAME;   //职务
@property(nonatomic,strong)NSString*C_BY_CAR_REMARK;   //职务
@property(nonatomic,strong)NSString*C_OWNER_ROLEID;
@property(nonatomic,strong)NSString*C_OWNER_ROLENAME;    //所属销售
@property(nonatomic,strong)NSString*C_PHONE;       //电话
@property(nonatomic,strong)NSString*C_PROVINCE;            //省
@property(nonatomic,strong)NSString*C_SALARY_DD_ID;  //收入id
@property(nonatomic,strong)NSString*C_SALARY_DD_NAME;   //年收入
@property(nonatomic,strong)NSString*C_SEX_DD_ID;        //性别  id
@property(nonatomic,strong)NSString*C_SEX_DD_NAME;    //性别
@property(nonatomic,strong)NSString*C_STAGE_DD_ID;      //客户阶段 id
@property(nonatomic,strong)NSString*C_STAGE_DD_NAME;    //客户阶段
@property(nonatomic,strong)NSString*C_STAR_DD_ID;      //星标状态  TYPECODE: A41500_C_STAR
@property(nonatomic,strong)NSString*C_STAR_DD_NAME;   //A41500_C_STAR_0001:否  A41500_C_STAR_0000:是
@property(nonatomic,strong)NSString*C_STATUS_DD_ID;
@property(nonatomic,strong)NSString*C_STATUS_DD_NAME;
@property(nonatomic,strong)NSString*C_WECHAT;          //微信
@property(nonatomic,strong)NSString*D_CREATE_TIME;    //潜客创建时间
@property(nonatomic,strong)NSString*X_INTENTIONREMARK;   //意向备注（仅MJK2.0有此字段）
@property(nonatomic,strong)NSString*X_LABEL;     //潜客标签（多个以逗号隔开）
@property(nonatomic,strong)NSString*X_PICURL;   //图片地址（多个以逗号隔开，仅MJK2.0有此字段）
@property(nonatomic,strong)NSString*X_REMRAK;   //备注
@property(nonatomic,strong)NSString*C_DESIGNER_ROLEID;
@property(nonatomic,strong)NSString*C_DESIGNER_ROLENAME;
@property(nonatomic,strong)NSMutableArray*labelsList;    //标签数组
@property(nonatomic,strong)NSString*C_VIN;//面积
@property (nonatomic, strong) NSString *C_SPAREPHONE;
@property (nonatomic, strong) NSString *D_FORECASTSENDCAR_TIME;
/** 图片list*/
@property (nonatomic, strong) NSArray *urlList;
@property (nonatomic, strong) NSArray *fileList;

//C_CREATOR_ROLENAME
@property (nonatomic, strong) NSString *C_CREATOR_ROLEID;
@property (nonatomic, strong) NSString *C_CREATOR_ROLENAME;

/** C_CLUEPROVIDER_ROLEID*/
@property (nonatomic, strong) NSString *C_CLUEPROVIDER_ROLEID;
/** C_CLUEPROVIDER_ROLE name*/
@property (nonatomic, strong) NSString *C_CLUEPROVIDER_ROLENAME;
@property (nonatomic, strong) NSString *D_LASTFOLLOW_TIME;
@property (nonatomic, strong) NSString *C_A47700_C_ID;
@property (nonatomic, strong) NSString *C_A47700_C_NAME;
@property (nonatomic, strong) NSString *C_USER_ID;
@property (nonatomic, strong) NSString *C_YS_DD_ID;
@property (nonatomic, strong) NSString *C_YS_DD_NAME;
@property (nonatomic, strong) NSString *C_PAYMENT_DD_ID;
@property (nonatomic, strong) NSString *C_PAYMENT_DD_NAME;

@property(nonatomic,strong)NSString*C_TYPE_DD_NAME;   //图片地址（多个以逗号隔开，仅MJK2.0有此字段）
@property(nonatomic,strong)NSString*C_ENGLISHNAME;   //备注
@property(nonatomic,strong)NSString*D_BRITHDAY_TIME;
@property(nonatomic,strong)NSString*C_HOBBY;
@property (nonatomic, copy) NSString *isJJR;


/*    粉丝   */
/** 开户行名称*/
@property(nonatomic,strong) NSString *C_BANKNAME;
/** 开户账号*/
@property(nonatomic,strong) NSString *C_ACCOUNTHOLDER;
/** 税号*/
@property(nonatomic,strong) NSString *C_DUTYPARAGRAPH;
/** 备注*/
@property(nonatomic,strong) NSString *X_REMARK;
/** 类型*/
@property(nonatomic,strong) NSString *C_TYPE_DD_ID;
/** 小程序accountid*/
@property(nonatomic,strong) NSString *C_OBJECTID;
//C_A48200_C_ID
/** 楼盘id*/
@property(nonatomic,strong) NSString *C_A48200_C_ID;
/** 楼盘*/
@property(nonatomic,strong) NSString *C_A48200_C_NAME;

@property(nonatomic,strong) NSString *C_A70600_C_ID;
@property(nonatomic,strong) NSString *C_A70600_C_NAME;
@property(nonatomic,strong) NSString *C_A49600_C_ID;
@property(nonatomic,strong) NSString *C_A49600_C_NAME;
@property(nonatomic,strong) NSString *C_VOUCHERNAME;
@property(nonatomic,strong) NSString *C_A49600_C_PICTURE;
@property(nonatomic,strong) NSString *C_YX_A70600_C_ID;
@property(nonatomic,strong) NSString *C_YX_A70600_C_NAME;
@property(nonatomic,strong) NSString *C_YX_A49600_C_ID;
@property(nonatomic,strong) NSString *C_YX_A49600_C_NAME;
@property(nonatomic,strong) NSString *C_YX_A49600_C_PICTURE;
@property(nonatomic,strong) NSString *C_CAR_REMARK;
@property(nonatomic,strong) NSString *C_YX_CAR_REMARK;
@property(nonatomic,strong) NSString *C_BUYTYPE_DD_NAME;
//C_A71000_C_ID
@property(nonatomic,strong) NSString *C_A71000_C_ID;
@property(nonatomic,strong) NSString *C_A71000_C_NAME;


@end
