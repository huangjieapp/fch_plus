//
//  DBObjectTools.h
//  Mcr_2
//
//  Created by 黄佳峰 on 2017/6/19.
//  Copyright © 2017年 bipi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CustomerDetailInfoModel;


typedef void(^SURECLICK)();
typedef void(^CANELCLICK)();


@interface DBObjectTools : NSObject
+ (BOOL)isLocationServiceOpenWithSelfView:(UIView*)selfView;
#pragma mark   项目中需要
//得到地址的字典
+(NSMutableDictionary*)getAddressDicWithAction:(NSString*)action;
//type 3电话录音接口     4支付接口   其他脉居客接口
//通过传入所有的参数加上自带的地址  得到post 需要的总的string  返回的是百分号编译好了的string
+(NSString*)getPostStringAddressWithMainDict:(NSDictionary*)dict withtype:(NSString*)type;
+(NSString*)oldGetPostStringAddressWithMainDict:(NSDictionary*)dict withtype:(NSString*)type;


+(NSString*)brokerCenterC_id;

//把字典弄成md5格式
+(NSString*)getMD5StringWithdict:(NSDictionary*)dict;
//为了得到cid   a02600 时间和随机串
+(NSString*)getCID;
+(NSString*)getA41400C_id;
//得到潜客的c_id   A41500
+(NSString*)getPotentailcustomerC_id;
//得到跟进的C_id  备忘录也是这个  A41600
+(NSString*)getVustomerFollowC_id;
//得到新增公告的C_id   A42100
+(NSString*)getNoticeFollowC_id;
//得到交易id 的C_id   A04200
+(NSString*)getDealC_id;
//新增服务任务的c_id    A01200
+(NSString*)getServiceTaskC_id;
//新增材料 其他配件的c_id  A04400
+(NSString*)getProductC_id;
//新增服务工单 其他配件的c_id  A01300
+(NSString*)getServiceOrderC_id;
//新增摇一摇 签到的c_id C_A41600_C_ID
+(NSString*)getShakeSignInC_id;
//流量关联  流量的C_id   A41400_
+(NSString*)flowAboutC_id;
+(NSString*)getA48100C_id;
+(NSString*)getA41300C_id;//线索新增
+(NSString*)getA47200C_id;//协助设计师
+(NSString*)getWorkReportA61200;//汇报点赞
+(NSString*)getWorkReportCommentsA46500;//汇报评论
+(NSString*)getA48600C_id;//新增汇报
//C_A64900_C_ID 新增考勤
+(NSString*)getA64900_C_ID;
+(NSString*)getA47200_C_ID;//协助人id
+(NSString*)getA47100C_id;//新增产品
+(NSString*)getA46600_C_ID;//新增客户标签
+(NSString*)getA46700_C_ID;//新增标签
+(NSString*)getA47700C_id;//经纪人
/* 新增节点**/
+(NSString*)getA47300C_id;
+(NSString*)getA47800_C_ID;//素材
+(NSString*)getA70100C_id;
+(NSString*)getA49500_C_ID;
+(NSString*)getA49600_C_ID;
+(NSString*)getA70600C_id;
+(NSString*)getA70800C_id;
+(NSString*)getA43200C_id;
+(NSString*)getA70900C_id;
+(NSString*)getA71000C_id;
+(NSString*)getA71300C_id;
+(NSString*)getA46400C_id;

+(NSString *)ret20bitString;
+(NSString *)ret18bitString;

//传入 name和自己的view 来跳转
+(void)pushVCWithName:(NSString*)name andSelf:(UIViewController *)mainVC;
+(void)pushVCWithName:(NSString*)name andSelfView:(UIView*)selfView;
//首页今日 后三天 逾期 和自己的view 跳转
+(void)homePagePushVCWithTimeType:(NSString*)timeType andName:(NSString*)name andSelfView:(UIView*)selfView;
//跳二维码  以后加回调 先将就着看
+(void)showQRCodeViewWithVC:(UIViewController*)mainVC;



#pragma 广告栏需要   配合DBTools 上面的方法
// 下载新图片
+ (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName andshoppingID:(NSString*)idd;
//删除旧图片
+ (void)deleteOldImage;

//提示框 这个取消按钮或者确定按钮没有就传@“”
+(UIAlertController *)getAlertVCwithTitle:(NSString *)title withMessage:(NSString *)Message clickCanel:(CANELCLICK)canelClick sureClick:(SURECLICK)sureClick canelActionTitle:(NSString * )ctitle sureActionTitle:(NSString * )stitle;

#pragma mark - 文本宽高
/**得到宽高*/
+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font width:(CGFloat) width;
/**得到宽度*/
+(CGFloat)getTheWeithWithText:(NSString*)text withSize:(double)size;

+(void)httpPostGetCustomerDetailInfoWithC_ID:(NSString *)C_ID andCompleteBlock:(void(^)(CustomerDetailInfoModel *customerDetailModel))successBlock;

//+(EMMessage *)createTextMessageWithStr:(NSString *)str;
+ (void)whbCallWithC_OBJECT_ID:(NSString *)C_OBJECT_ID andC_CALL_PHONE:(NSString *)C_CALL_PHONE andC_NAME:(NSString *)C_NAME andC_OBJECTTYPE_DD_ID:(NSString *)C_OBJECTTYPE_DD_ID andCompleteBlock:(void(^)(void))successBlock;
@end
