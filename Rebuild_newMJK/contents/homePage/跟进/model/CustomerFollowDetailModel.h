//
//  CustomerFollowDetailModel.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/26.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerFollowDetailModel : MJKBaseModel
/** <#注释#>*/
@property (nonatomic, strong) NSString *I_SORTIDX;
@property(nonatomic,strong)NSString*B_DRIVE_LAT;    //
@property(nonatomic,strong)NSString*B_DRIVE_LON;    //
@property(nonatomic,strong)NSString*C_A40500_C_ID;
@property(nonatomic,strong)NSString*C_A40500_C_NAME;
@property(nonatomic,strong)NSString*C_A40600_C_ID;
@property(nonatomic,strong)NSString*C_A40600_C_NAME;
@property(nonatomic,strong)NSString*C_A41500_C_ID;
@property(nonatomic,strong)NSString*C_A41500_C_NAME;
@property(nonatomic,strong)NSString*C_A41900_C_ID;
@property(nonatomic,strong)NSString*C_A41900_C_NAME;
@property(nonatomic,strong)NSString*C_EXISTING;
@property(nonatomic,strong)NSString*C_FLAG;
@property(nonatomic,strong)NSString*C_LEVEL_DD_ID;
@property(nonatomic,strong)NSString*C_LEVEL_DD_NAME;
@property(nonatomic,strong)NSString*C_MODEFOLLOW_DD_ID;
@property(nonatomic,strong)NSString*C_MODEFOLLOW_DD_NAME;
@property(nonatomic,strong)NSString*C_NEXTMODEFOLLOW_DD_ID;
@property(nonatomic,strong)NSString*C_NEXTMODEFOLLOW_DD_NAME;
@property(nonatomic,strong)NSString*C_OWNER_ROLEID;
@property(nonatomic,strong)NSString*C_OWNER_ROLENAME;
@property(nonatomic,strong)NSString*C_PHONE;
@property(nonatomic,strong)NSString*C_PICTURE;
@property(nonatomic,strong)NSString*C_SEX_DD_ID;
@property(nonatomic,strong)NSString*C_SEX_DD_NAME;
@property(nonatomic,strong)NSString*C_STAGE_DD_ID;
@property(nonatomic,strong)NSString*C_STAGE_DD_NAME;
@property(nonatomic,strong)NSString*D_END_TIME;
@property(nonatomic,strong)NSString*D_FOLLOW_TIME;
@property(nonatomic,strong)NSString*D_NEXTFOLLOW_TIME;
@property(nonatomic,strong)NSString*X_PICURL;
@property(nonatomic,strong)NSString*X_REMARK;
@property(nonatomic,strong)NSString*C_ENGLISHNAME;
/** 图片*/
@property (nonatomic, strong) NSArray *urlList;
@property (nonatomic, strong) NSArray *fileList;


@end


//{
//    "C_A40500_C_ID" = "";
//    "C_A40500_C_NAME" = "";
//    "C_A40600_C_ID" = "";
//    "C_A40600_C_NAME" = "";
//    "C_A41500_C_ID" = "A4150000000001-15635ACD3F30JM2S33OA631W4UKJ0T16J";
//    "C_A41500_C_NAME" = "\U5e03\U9c81\U65af";
//    "C_A41900_C_ID" = "";
//    "C_A41900_C_NAME" = "";
//    "C_EXISTING" = "";
//    "C_FLAG" = true;
//    "C_LEVEL_DD_ID" = "";
//    "C_LEVEL_DD_NAME" = "";
//    "C_MODEFOLLOW_DD_ID" = "";
//    "C_MODEFOLLOW_DD_NAME" = "";
//    "C_NEXTMODEFOLLOW_DD_ID" = "";
//    "C_NEXTMODEFOLLOW_DD_NAME" = "";
//    "C_OWNER_ROLEID" = 00000011;
//    "C_OWNER_ROLENAME" = "\U5e03\U9c81\U65af";
//    "C_PHONE" = 13875545896;
//    "C_PICTURE" = "http://7xt9pc.com1.z0.glb.clouddn.com//2017-09-26/67d03470-4891-41c7-a7a3-72830c0c82fc.";
//    "C_SEX_DD_ID" = "";
//    "C_SEX_DD_NAME" = "";
//    "C_STAGE_DD_ID" = "";
//    "C_STAGE_DD_NAME" = "";
//    "D_END_TIME" = "";
//    "D_FOLLOW_TIME" = "2017-09-26 16:10:03";
//    "D_NEXTFOLLOW_TIME" = "2017-10-08 16:10:03";
//    "X_PICURL" = "http://7xt9pc.com1.z0.glb.clouddn.com/png/2017-09-26/30f68263-f4e2-44fc-a8dd-4bf0706ecf9e.png";
//    "X_REMARK" = Yyyuuu;
//    code = 200;
//    message = "\U64cd\U4f5c\U6210\U529f";
//}
