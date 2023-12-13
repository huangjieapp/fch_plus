//
//  GlobalInfo.h
//  GKAPP
//
//  Created by 黄佳峰 on 15/11/2.
//  Copyright © 2015年 黄佳峰. All rights reserved.
//

#ifndef GlobalInfo_h
#define GlobalInfo_h


//#define HTTP_ADDRESS     @"http://121.41.13.95:80/mcrmobile/mobile_user/entrance.bk"    //  这个是售后的 不用管它
//@"http://121.40.174.159:6060/mcrmobile/mobile_user/entrance.bk"  //这个才是2.0的

#pragma mark  --客户打我电话  是转到手机还是座机   电话的回拨功能
#define HTTP_PhoneAddress  @"http://121.40.174.159:8585/MJK2.0/mobile/Forward.bk?"


#pragma mark  -- 公司公告  跳h5页面
#define HTTP_CompanyNotice   @"http://47.95.249.137:9091/fch_api/"  //正式
//121.41.13.95:8080
#define HTTP_TestCompanyNotice   @"http://121.41.13.95:8080/MJK2.0/"  //测试


#pragma mark  --获取url地址  h5界面的
#define HTTP_URLAddress    @"http://121.40.174.159:8585/MJK2.0/mobile/rpt.bk?"


//#pragma mark  --新增支付url
//#define HTTP_addNewPayAdress @"http://121.40.174.159:8585/MJK2.0/mobile/prepay.bk"







#pragma mark  --   真正脉居客的接口
#define HTTP_ADDRESS @"http://47.95.249.137:9091/fch_api/mobile_user/entrance.bk"
#define HTTP_TestADDRESS @"http://47.95.249.137:9091/fch_api/mobile_user/entrance.bk"
//#define HTTP_NewADDRESS @"http://47.95.249.137:9091/fch_api/mobile_user/entranceToResponseBody.bk"
//#define HTTP_TestNewADDRESS @"http://47.95.249.137:9091/fch_api/mobile_user/entranceToResponseBody.bk"
//#define HTTP_IPADDRESS @"http://47.95.249.137:9091/fch_api/mobile_user"


//#define HTTP_ADDRESS @"http://47.95.249.137:8080/fch_test/mobile_user/entrance.bk"
//#define HTTP_TestADDRESS @"http://47.95.249.137:8080/fch_test/mobile_user/entrance.bk"
//#define HTTP_NewADDRESS @"http://47.95.249.137:8080/fch_test/mobile_user/entranceToResponseBody.bk"
//#define HTTP_TestNewADDRESS @"http://47.95.249.137:8080/fch_test/mobile_user/entranceToResponseBody.bk"
//#define HTTP_IPADDRESS @"http://47.95.249.137:8080/fch_test/mobile_user"

#define HTTP_NewADDRESS @"http://47.95.249.137:9091/fch_api/mobile_user/entranceToResponseBody.bk"
#define HTTP_TestNewADDRESS @"http://47.95.249.137:9091/fch_api/mobile_user/entranceToResponseBody.bk"
#define HTTP_IPADDRESS @"http://47.95.249.137:9091/fch_api/mobile_user"


#define HTTP_IP @"http://47.95.249.137:9090/prod-api"
//#define HTTP_IP @"http://47.95.249.137:9091/fch_api/prod-api"
//账号列表
#define HTTP_SYSTEMUserList HTTP_IP "/api/system/user/list"
#define HTTP_SYSTEMUserStoreList HTTP_IP "/api/system/user/storeUserList"
#define HTTP_SYSTEMLOGIN HTTP_IP "/api/system/login"
#define HTTP_SYSTEMGETUSERINFO HTTP_IP "/api/system/getInfo"
#define HTTP_SYSTEM802INFO HTTP_IP  "/api/crm/a802/info"
#define HTTP_SYSTEMA800List HTTP_IP  "/api/masterdata/a800/list"
#define HTTP_SYSTEMDICDATALIST HTTP_IP  "/api/system/dict/data/list"
#define HTTP_SYSTEMD802EDIT HTTP_IP "/api/crm/a802/edit"
#define HTTP_SYSTEMD856LIST HTTP_IP "/api/crm/a856/list"
//质保详情
#define HTTP_SYSTEMD804INFO HTTP_IP "/api/crm/a804/info"
#define HTTP_SYSTEMD804EDIT HTTP_IP "/api/crm/a804/edit"
//上牌详情
#define HTTP_SYSTEMD805INFO HTTP_IP "/api/crm/a805/info"
#define HTTP_SYSTEMD805EDIT HTTP_IP "/api/crm/a805/edit"
//保险
#define HTTP_SYSTEMD803INFO HTTP_IP "/api/crm/a803/info"
#define HTTP_SYSTEMD803ADD HTTP_IP "/api/crm/a803/add"
#define HTTP_SYSTEMD803EDIT HTTP_IP "/api/crm/a803/edit"
//精品
#define HTTP_SYSTEMD806INFO HTTP_IP "/api/crm/a806/info"
#define HTTP_SYSTEMD806ADD HTTP_IP "/api/crm/a806/add"
#define HTTP_SYSTEMD806EDIT HTTP_IP "/api/crm/a806/edit"
//品牌
#define HTTP_SYSTEMD706PPLIST HTTP_IP "/api/masterdata/a706/pplist"
//车型
#define HTTP_SYSTEMD496PPLIST HTTP_IP "/api/masterdata/a496/pplist"
#define HTTP_SYSTEMDTREELIST HTTP_IP "/api/masterdata/districts/getTreeList"
//提交审批
#define HTTP_SYSTEMD425APPROVAL HTTP_IP "/api/crm/a425/initiateApproval"
//审批列表
#define HTTP_SYSTEMD425RECORDLIST HTTP_IP "/api/crm/a425/getRecordALLList"
//审批计数
#define HTTP_SYSTEMD425COUNTRECORD HTTP_IP "/api/crm/a425/getCountRecord"
//审批通过
#define HTTP_SYSTEMD425APPROVED HTTP_IP "/api/crm/a425/approved"
//审批驳回
#define HTTP_SYSTEMD425APPROVEDFAILED HTTP_IP "/api/crm/a425/approvalFailed"
//老客户轨迹列表
#define HTTP_SYSTEMDA855List HTTP_IP "/api/crm/a855/list"
//售后列表
#define HTTP_SYSTEMDA815List HTTP_IP "/api/crm/a815/list"
//售后详情
#define HTTP_SYSTEMDA815Info HTTP_IP "/api/crm/a815/info"
//售后新增
#define HTTP_SYSTEMDA815Add HTTP_IP "/api/crm/a815/add"
//售后更新
#define HTTP_SYSTEMDA815Edit HTTP_IP "/api/crm/a815/edit"
//咨询详情
#define HTTP_SYSTEMDA814Info HTTP_IP "/api/crm/a814/info"
//咨询新增
#define HTTP_SYSTEMDA814Add HTTP_IP "/api/crm/a814/add"
//咨询更新
#define HTTP_SYSTEMDA814Edit HTTP_IP "/api/crm/a814/edit"
//评论列表
#define HTTP_SYSTEMDA465List HTTP_IP "/api/crm/a465/list"
//评论新增
#define HTTP_SYSTEMDA465Add HTTP_IP "/api/crm/a465/add"
#define HTTP_SYSTEMD807TREEINFO HTTP_IP "/api/masterdata/a807/getTreeInfo"
#define HTTP_SYSTEMD811INFO HTTP_IP "/api/crm/a811/info"
#define HTTP_SYSTEMD811ADD HTTP_IP "/api/crm/a811/add"
#define HTTP_SYSTEMD812INFO HTTP_IP "/api/crm/a812/info"
#define HTTP_SYSTEMD812ADD HTTP_IP "/api/crm/a812/add"
//七牛云上传
#define HTTP_UploadByQiNiu HTTP_IP "/system/file/uploadByQiNiu"
//客户跟进新增
#define HTTP_AddCustomerFollow HTTP_IP  "/api/crm/a416/addCustomerFollow"
//订单跟进新增
#define HTTP_AddOrderFollow HTTP_IP  "/api/crm/a416/addOrderFollow"
//粉丝跟进新增
#define HTTP_AddAgentFollow HTTP_IP  "/api/crm/a416/addAgentFollow"
//跟进详情
#define HTTP_FollowInfo HTTP_IP "/api/crm/a416/info"
//客户查重
#define HTTP_RepetitioCustomer HTTP_IP "/api/crm/a415/repetitioCustomer"
//今日待办
#define HTTP_Pending HTTP_IP "/api/crm/portal/pending"
//漏斗
#define HTTP_PortalFunnel HTTP_IP "/api/crm/portal/funnel"
//应用功能管理设置
#define HTTP_MenuList HTTP_IP "/api/system/a475/menuList"
//设置列表
#define HTTP_A475List HTTP_IP "/api/system/a475/list"
//消息列表
#define HTTP_A617List HTTP_IP "/api/system/a617/list"
//消息列表批量已读
#define HTTP_A617Read HTTP_IP "/api/system/a617/read"
//审批历史
#define HTTP_ApprovalHistory HTTP_IP "/api/crm/a425/approvalHistory"

//#define HTTP_TestADDRESS @"http://192.168.1.191:6060/MJK2.0/mobile_user/entrance.bk"//beck本机测试
#pragma mark  --上传图片 的前缀
#define HTTP_postImage    @"http://47.95.249.137:9091/fch_api/mobile_user/uploadFileQINIU.bk?"

#pragma mark  -- 电话录音  有数据的地址。   登录的时候需要整个项目都变成电话录音
#define HTTP_recordSound    @"A45000WebService-getRecordList"   //录音筛选列表
#define HTTP_recordDetailInfo   @"A45000WebService-getRecordInfamation"   //具体一条录音的信息
#define HTTP_RecordInvail       @"A45000WebService-operatingRecord"   //设置为无效或者员工    电话录音

#pragma 首页
#define HTTP_getOrderInformation @"A42000WebService-getOrderInformationBy420Id"//订单详情
#define HTTP_updateOrder @"A42000WebService-updateOrder"//修改订单
#define HTTP_addOrder @"A42000WebService-addOrder"//新增订单
#define HTTP_updateStartTime   @"A42000WebService-updateStartTime"  //延迟交付
#define HTTP_updateByStatus   @"A42000WebService-updateByStatus"  //订单装态修改（取消 交付）
#define HTTP_newAddAppiontment @"ReservationWebService-insertReservation"//新增预约
#define HTTP_getAppiontmentList @"ReservationWebService-getReservationList"//获取预约列表
#define HTTP_getReservationById @"ReservationWebService-getReservationById"//获取预约详情
#define HTTP_CGC_getBeanList @"CustomerWebService-getBeanList"//获取潜客列表
#define HTTP_CGC_operationReservationById @"ReservationWebService-operationReservationById"//
#define HTTP_getLogList @"A45900WebService-getList"//获取操作日志列表
#define HTTP_getLogClueList @"A42600WebService-getAllList"
#define HTTP_CGC_geta420List @"A42000WebService-geta420List"//获取订单列表
#define HTTP_CGC_getListBy420CGC @"A04200WebService-getListBy420"//订单支付记录列表
#define HTTP_CGC_A04200WebServiceinsert @"A04200WebService-insert"//新增付款
#define HTTP_DeletePayRecord     @"A04200WebService-delete"   //删除支付记录
#define HTTP_ChangePayRecord     @"A04200WebService-update"  //修改支付记录

#define HTTP_CGC_getCommunicationList @"UserWebService-getCommunicationList"//通讯录
#define HTTP_CGC_getCommunicationDetailInfo @"UserWebService-SearchView"//通讯录详情
#define HTTP_CGC_saveBeanId @"TemplateMessageWebService-saveBeanId"//
#define HTTP_CGC_weChatTextPushByA511 @"WeChatWebService-weChatTextPushByA511"//微信公众号推送自定义文本消息
#define HTTP_CGC_updateBeanById @"A51100WebService-updateBeanById"//前台传入粉丝C_ID,修改粉丝备注和星标状态


#define HTTP_CGC_insertAllTemplateMessageToFollowd @"ReservationWebService-insertAllTemplateMessageToFollow"//发送多人消息模板,后台跟进接口
#define HTTP_CGC_getMessageList @"TemplateMessageWebService-getMessageList"//获取常用和公共文字list
#define HTTP_CGC_templateMessageUpdate @"TemplateMessageWebService-update"//模板消息修改
#define HTTP_CGC_templateMessageDeleteByID @"TemplateMessageWebService-DeleteByID"//模板消息删除
#define HTTP_CGC_weChatPush @"WeChatWebService-weChatPush"//微信公众号推送素材消息（通过潜客）
#define HTTP_CGC_weChatPushByA511 @"WeChatWebService-weChatPushByA511"//微信公众号推送素材消息（粉丝潜客）
#define HTTP_CGC_getMessageListByWx @"TemplateMessageWebService-getMessageListByWx"//获取模板其他图片...消息列表
//
#define HTTP_CGC_insertAllTemplateMessageToFollow @"ReservationWebService-insertAllTemplateMessageToFollow"//发送多人消息模板,后台跟进接口
#define HTTP_HomePageDatas    @"A45500WebService-getTodayToLogNew"    //首页的
#define HTTP_NOticeInfo   @"A42100WebService-geta421getContent"   //首页的通知信息
#define HTTP_month_DealDetail    @"A04200WebService-getBeanList"   //每月交易详情
#define HTTP_addCustomer  @"A02600WebService-AddCustomer"    //新增潜客
#define HTTP_AddProduct       @"A41900WebService-getFormByVoucherid"  //加产品
#define HTTP_addLikeProduct   @"A47100WebService-insert"   //加上喜欢的产品
#define HTTP_getSaleList      @"UserWebService-getSubordinate" //得到部分销售列表
#define HTTP_getPrimaryShopping   @"A47100WebService-getList"  //得到潜客编辑时候原来的东西   获取意向、订单明细列表
#define HTTP_dealOrder   @"ReservationWebService-operationReservationById"   //处理预约里面的3个选项  已到店 延期 取消预约

#define HTTP_getAllUser  @"UserWebService-getAllUser" //销售列表
#define HTTP_getBeanList @"CluedisplayWebService-getBeanList" //留资线索列表
#define HTTP_getBeanById  @"CluedisplayWebService-getBeanById"//留资线索详情

#define HTTP_getMarketAction  @"A41200WebService-getAllSelect"  //fannel筛选  获取到筛选的所有选项
#define HTTP_insert @"CluedisplayWebService-insert"//新增留资线索

#define HTTP_operationBean @"CluedisplayWebService-operationBean"//留资线索操作
#define HTTP_ClueToCustomer   @"CluedisplayWebService-operationBeanLS"  //线索到潜客

#define HTTP_getFlowList @"FlowWebService-getFlowList"//展厅流量列表
#define HTTP_flowInsert @"FlowWebService-insert"



#define HTTP_assign @"CluedisplayWebService-assign"//重新指派   线索的

#define HTTP_flowOperationBean @"FlowWebService-operationBean" // 操作流量
#define HTTP_flowGetBeanById @"FlowWebService-getBeanById"

#define HTTP_getSetAllSelect @"A41100WebService-getAllSelect"    //得到等级对应的天数

#define HTTP_updateLevel @"A41100WebService-updateLevel" // 客户回访等级
#define HTTP_getUserListToReceive @"UserWebService-getUserListToReceive"//线索

#define HTTP_updateToReceive @"UserWebService-updateToReceive"//线索设置
#define HTTP_getCountAmount @"A43500WebService-getCountAmount"//业绩设置
#define HTTP_updateCountAmount @"A43500WebService-updateCountAmount"//业绩设置更新

#define HTTP_getMarketBeanById @"A41200WebService-getBeanById" // 市场活动详情
#define HTTP_updateMaketSet @"A41200WebService-update" //市场活动设置修改
#define HTTP_insertMaketSet @"A41200WebService-saveBeanId"//市场活动设置新增
#define HTTP_getPhoneList @"A65500WebService-getALLList"


#define HTTP_getPhoneDetail @"A65500WebService-getSaveByID"//电话设置新增
#define HTTP_getPhoneUpddate @"A65500WebService-updateById"//电话新增修改
#define HTTP_getPhoneDelete @"A65500WebService-DeleteByID"

#define HTTP_getFlowSetList @"A65200WebService-geta652ALLList"
#define HTTP_insertFlowSet @"A65200WebService-insert"
#define HTTP_updataFlowSet @"A65200WebService-updataById"
#define HTTP_deleteFlowSet @"A65200WebService-DeleteById"//wifi

#define HTTP_detailOnlineHall @"A65200WebService-getBeanById"
#define HTTP_getAppoveList @"UserWebService-StatusByUserId"
#define HTTP_updataAppoveList @"UserWebService-updateUserToStatus"
#define HTTP_getOnlineHallList @"A65200WebService-getList"//在线展厅列表

#define HTTP_getPrefixDetail @"A40300WebService-prefixDetail"//查看订单编号
#define HTTP_updatePrefix @"A40300WebService-updatePrefix"//修改订单编号
#define HTTP_OrderNumberDuplicate  @"A42000WebService-voucheridValidate"  //订单编号查重

#define HTTP_FailOrActivate         @"ApplicationWebService-saveBean"    //潜客战败  激活   取消订单接口
#define HTTP_changeStarStatus       @"CustomerWebService-updatetheju"   //改变星标
#define HTTP_CustomerAssign         @"CustomerWebService-operationBean"  //潜客的重新指派
#define HTTP_CheatoutPhoneNumber    @"CustomerWebService-phoneRepetitio"   //检查电话号码
#define HTTP_AddNewCustomer         @"CustomerWebService-insert"     //新增潜客
#define HTTP_CusomterEdit           @"CustomerWebService-updateBeanById"  //潜客修改

#define HTTP_CustomerDetailInfo     @"CustomerWebService-getBeanById"  //潜客详情
#define HTTP_CustomerPath           @"A45600WebService-getLogByA415ID"  //潜客轨迹
#define HTTP_TagList         @"A46700WebService-getList"  //标签列表
#define HTTP_ChooseTag       @"A46700WebService-updateA415Label"  //提交选择的潜客。
#define HTTP_FollowInsert    @"ReservationWebService-insert"  //跟进插入
#define HTTP_FollowEdit      @"ReservationWebService-updateBeanByID"   //跟进编辑
#define HTTP_FollowDatas     @"ReservationWebService-getBeanByID"    //潜客跟进的详细信息
#define HTTP_AddNewNotice    @"A42100WebService-insertGG"    //新增公告
#define HTTP_WorkCalendar        @"ReservationWebService-calendar"  //工作日历
#define HTTP_AddRemind       @"ReservationWebService-saveNotes"  //添加备忘录
#define HTTP_calendarList    @"ReservationWebService-calendarToList"   //日历列表
#define HTTP_RemindInfo      @"ReservationWebService-getBeanByID"   //备忘录信息
#define HTTP_OperationRemark  @"ReservationWebService-processNotes"  //操作备忘录


#define HTTP_BussinessRunning   @"A46300WebService-getListByMonth"   //营业流水首页
#define HTTP_BUsinessDayDetail  @"A46300WebService-getListByDay"   //当日的交易明细
#define HTTP_closeDeal          @"A46300WebService-update"    //关账

#define HTTP_SeviceListDatas    @"A01200WebService-getRwList"   //服务任务列表
#define HTTP_SEviceAdd          @"A01200WebService-insertRw"    //服务任务新增
#define HTTP_ServiceTaskDetail  @"A01200WebService-getRwBeanById"  //服务任务详情
#define HTTP_ChangeServiceTask  @"A01200WebService-updateRwById"   //修改服务任务
#define HTTP_operationServiceTask   @"A01200WebService-operationRwBean"  //1: 确认 2: 退回 3: 签到 4：完成 5：延期 6：重新指派7：取消
#define HTTP_MuchAssign         @"A01200WebService-assignment"  //服务任务批量指派

#define HTTP_ServiceOrderList   @"A01300WebService-getGdList"   //服务工单列表
#define HTTP_CreatServiceOrder  @"A01300WebService-insertGd"   //创建服务工单
#define HTTP_ServiceOrderDetail @"A01300WebService-getGdBeanById"  //服务订单详情
#define HTTP_OrderBillDetail    @"A04400WebService-getGdmxList"   //服务工单费用明细
#define HTTP_OrderUpdate        @"A01300WebService-updateGdById"  //服务工单修改
#define HTTP_CompleteOrder      @"A01300WebService-operationGdBean"  //完成服务工单


#define HTTP_GetFlowMeter @"A46000WebService-getList"
#define HTTP_GetFlowMeterDetail @"A46000WebService-getBeanById"
#define HTTP_UpdataFlowMeter @"A46000WebService-operationBean"


#pragma 登录
#define HTTP_Login        @"UserWebService-login"            //登录
#define HTTP_ApplyEnter   @"A42300WebService-saveBeanId"     //申请入驻

#pragma 报表
#define HTTP_ResportSheet    @"RptWebService-getFunnel"     //报表的


#pragma 发现
#define HTTP_ShakeSignIn     @"A65000WebService-insert"   //签到



#pragma 个人中心
#define HTTP_changeCode           @"UserWebService-updatePassword"  //修改密码
#define HTTP_PostPortrait         @"UserWebService-updateHeadImageUrl"  //上传头像
#define HTTP_updatePersonInfo     @"UserWebService-updateBean"   //更新个人信息



#define HTTP_ShowOrderNumberSet   @"A40300WebService-prefixDetail"  //查看订单前缀和长度
#define HTTP_ChangeOrderPrefixSet @"A40300WebService-updatePrefix" //修改订单长度


#define HTTP_A47700WebServicegetBeanById     @"A47700WebService-getBeanById"  //经纪人详情

#define HTTP_getClueToIntegarlByA420   @"CluedisplayWebService-getClueToIntegarlByA420"  //（MJK）积分核销列表
#define HTTP_operationClueToIntegarl @"CluedisplayWebService-operationClueToIntegarl" //（MJK）积分核销操作

#define HTTP_CGC_A47700WebServiceinsert @"A47700WebService-insert"//新增经纪人
//经纪人列表
#define HTTP_A47700WebService_getAllList @"A47700WebService-getAllList"

//积分商品列表@"http://120.26.211.79:8081/api/integral/list"
#define HTTP_integralList  @"https://xcx.51mcr.com/api/integral/list"

//推广列表
#define HTTP_materialList @"https://www.fchcrm.com/api/material/home"
#define HTTP_materialListTest @"https://www.fchcrm.com/api/material/home"
//#define HTTP_materialList @"https://xcx.51mcr.com/api/material/home"
//#define HTTP_materialListTest @"http://121.41.13.95:9091/api/material/home"
#define HTTP_pushMaterial @"http://121.40.174.159:8585/MJK2.0/push/pushInfo.bk"
//http://121.40.174.159:8585/MJK2.0/push/pushInfo.bk

//获取我的二维码分享经纪人@"http://120.26.211.79:8081/api/my/qrcode"
#define HTTP_getQrcode @"https://xcx.51mcr.com/api/my/qrcode"


//积分商品详情@"http://120.26.211.79:8081/api/integral/getInfo" //
#define HTTP_integralGetInfo  @"https://xcx.51mcr.com/api/integral/getInfo"

//核销列表@"http://120.26.211.79:8081/api/point/applist"
#define HTTP_pointApplist @"https://xcx.51mcr.com/api/point/applist"

//核销详情@"http://120.26.211.79:8081/api/point/getCancelAfterVerificationInfo"
#define HTTP_getCancelAfterVerificationInfo @"https://xcx.51mcr.com/api/point/getCancelAfterVerificationInfo"

//分享
#define HTTP_sharePYQ @"https://xcx.51mcr.com/api/templates/activity/match/"


//分享链接
#define HTTP_shareSPZP @"https://xcx.51mcr.com/api/templates/material"

//分享统计
#define HTTP_shareTJ @"http://120.26.211.79:8081/api/material/share"


//分享统计
#define HTTP_pointTake @"http://120.26.211.79:8081/api/point/take"


//联盟版漏斗数据
#define HTTP_getMJKUnionFunnel @"RptWebService-getMJKUnionFunnel"


#import "MJKBaseModel.h"
#import "MJKCardView.h"
#import "HttpManager.h"
#import "NewUserSession.h"
#import "DBLanguageTool.h"    //中英文
#import "HttpWebObject.h"
#import "DBTools.h"
#import "DBObjectTools.h"
#import "DBNoDataView.h"   //没数据的时候加载
#import "DBRefreshGifHeader.h"
#import "DBRefreshAutoNormalGifFooter.h"
#import "UIBarButtonItem+DBImageItem.h"
#import "UIColor+HexColor.h"
#import "UIButton+Extension.h"
#import "UIView+Extension.h"
#import "UIImageView+Extension.h"
#import "UIImage+Extension.h"
#import "UIViewController+Extension.h"
#import "DBMD5Tool.h"
#import "JRToast.h"
#import "YJSegmentedControl.h"
#import "DBBaseViewController.h"
#import "FMDBManager.h"  //自定义的数据库
#import <PPBadgeView.h>
#import "MJKHttpApproval.h"
#import "Global.h"
#import "MJKOldCustomerSalesModel.h"
#import "MJKApprovalRequest.h"


#import "MJKMapNavigationViewController.h"

#import "YYText.h"
#import "YYModel.h"
#import "AFNetworking.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
#import "KVNProgress.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import "POPRequestManger.h"

#import "MJKPermissions.h"
#import "MJExtension.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
#import "DDUIManager.h"
#import "SSKeychain.h"
#import "MJKCustomerChooseViewController.h"

#import "MJKPushMsgHttp.h"
#import "NSString+Extension.h"
#import <SVProgressHUD.h>

#import "SLPlayer.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <BRPickerView.h>

#import "CustomerPhotoView.h"
#import "VideoAndImageModel.h"

#import <IQKeyboardManager.h>
#import "CGCCustomModel.h"
#import <HXPhotoPicker/HXPhotoPicker.h>



//#import <Hyphenate/Hyphenate.h>

#define FontSize(number) [UIFont fontWithName:@"Helvetica" size:number]
#define DBColor(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]


#define KBasicColor DBColor(214, 41, 117)
#define KNaviColor   DBColor(253,194,45)

#define KCustomNaviColor   [UIColor colorWithHexString:@"#F5CD63"]
#define KRedColor   [UIColor colorWithHexString:@"#FF0000"]
#define KYellowColor   [UIColor colorWithHexString:@"#E8E534"]
#define KBlueColor   [UIColor colorWithHexString:@"#5DC2CA"]
#define KGreenColor   [UIColor colorWithHexString:@"#5CB85C"]
#define KPurpleColor  [UIColor colorWithHexString:@"#C68EEF"]
#define CGCTABBGColor   DBColor(245,245,245)
#define CGCWEiXINColor   DBColor(74,171,60)
#define CGCZHIFUBAOColor   DBColor(17,139,226)
#define CGCNAVCOLOR  DBColor(238,180,51)
#define CGCBGCOLOR [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5]
#define KColorForButtonNormal [UIColor colorWithRed:255.0/255.0 green:211.0/255.0 blue:66/255.0 alpha:1.0]
#define KColorForButtonSelect [UIColor colorWithRed:207/255.0 green:201/255.0 blue:0/255.0 alpha:1.0]
#define KColorListSelectButton [UIColor colorWithRed:255.0/255.0 green:195.0/255.0 blue:0.0/255.0 alpha:1.0]
#define KColorListUnSelectButton [UIColor colorWithRed:242.0/255.0 green:243.0/255.0 blue:247.0/255.0 alpha:1.0]
#define KColorForAlert [UIColor blackColor]
#define KColorSelectCell  [UIColor orangeColor]
#define KColorUnSelectCell  [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]


#define COLOR_F0F2F4 RGBA(240, 240, 240, 1)
#define COLOR_242526 RGBA(36,37,38, 1)
#define COLOR_333333 RGBA(51, 51, 51, 1)
#define COLOR_81838B RGBA(129,131,139, 1)

#define COLOR_43AAFF08 RGBA(67, 170, 255, 0.8)//系统蓝

#define COLOR_33333308 RGBA(51, 51, 51, 0.8)

#define KSuperBigFont      [UIFont systemFontOfSize:18.f]
#define KBigFont      [UIFont systemFontOfSize:16.f]
#define KNomarlFont      [UIFont systemFontOfSize:14.f]
#define KSmallFont      [UIFont systemFontOfSize:12.f]

#define WXSHARESUCCESS   @"weinxinshare"

#define COLOR_RGB(rgb) [UIColor colorWithRed:((rgb & 0xff0000) >> 16) / 255.0 green:((rgb & 0xff00) >> 8) / 255.0 blue:(rgb & 0xff) / 255.0 alpha:1]
/** 1    背景色    - 浅灰 */
#define kBackgroundColor COLOR_RGB(0xefeff4)


#define kNormalTextColor COLOR_RGB(0x777777)

#define KColorGrayTitle    DBColor(153, 153, 153)      //文字灰色
#define KColorGrayBGView   DBColor(247, 247, 247)      //背景默认的tableView灰


#define WIDE   [UIScreen mainScreen].bounds.size.width

#define HIGHT  [UIScreen mainScreen].bounds.size.height

#define ENDKEYWORD [[UIApplication sharedApplication].keyWindow endEditing:YES]


//获取屏幕宽度
#define KScreenWidth  [UIScreen mainScreen].bounds.size.width
//获取屏幕高度
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#define SafeAreaTopMoreHeight ([Global supportFaceID] ? 24 : 0)
//获取导航栏全部高度
#define NavigationHeight 64.f
//获取导航栏高度
#define NavigationBarHeight self.navigationController.navigationBar.frame.size.height
//获取状态栏高度
#define StatusBarHeight  [[UIApplication sharedApplication] statusBarFrame].size.height

#define NavStatusHeight NavigationBarHeight + StatusBarHeight
//获取tabBar的高度
#define TabbarDeHeight 49.f
#define WD_TabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?88:45) //底部tabbar高度

#define SafeAreaBottomHeight ([Global supportFaceID] ? 34.f : 0) //底部类似home键的高

#define SafeAreaTopHeight ([Global supportFaceID] ? 88 : 64)

#define AdaptNaviHeight ([Global supportFaceID] ? 44.f : 22.f) //状态栏高度

#define AdaptTabHeight  ([Global supportFaceID] ? 34.f : 0) //Tab bar 圆角部分高度

//#define NAVIHEIGHT      ([Global supportFaceID] ? 88 : 64) //导航
#define NAVIHEIGHT      [Global supportFaceIDHeight] //导航
#define AdaptSafeBottomHeight  ([Global supportFaceID] ? 34.f : 0) //safe bottom
//比例
#define ACTUAL_WIDTH(width)   KScreenWidth/375*width
#define ACTUAL_HEIGHT(height)   KScreenHeight/667*height


#define isHairHeadHeight 64 + [DDUIManager sharedManager].safeAreaInset.top
#define isAfteriPheneXBottomHeight 49 + [DDUIManager sharedManager].bottom

// 视频录制 最大时长
#define GS_Video_Limit_Seconds 120
// 判断当前的iPhone设备/系统版本
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define iPhoneX (IS_IPHONE && KScreenHeight>=812)  //iPhoneX系列
#define KWindow [UIApplication sharedApplication].keyWindow

//自定义NSLog
#ifdef DEBUG // 调试状态, 打开LOG功能

#define MyLog(...) NSLog(__VA_ARGS__)
#define MyFunc MyLog(@"%s", __func__);

#else // 发布状态, 关闭LOG功能

#define MyLog(...)
#define MyFunc

#endif



//保存进userdefault  里面的参数
#define KUSERDEFAULT [NSUserDefaults standardUserDefaults]
#define saveLoginName        @"saveLoginName"   //保存登录的名字
#define saveLoginCode        @"saveLoginCode"   //保存登录的密码
#define saveLastLoginTime    @"saveLastLoginTime"   //保存最后一次登录的时间

#define SaveSelectedModule     @"SaveSelectedModule"   //保存选中的模块
#define SaveSelectedModuleName @"SaveSelectedModuleName"

#define SaveVersionTime      @"SaveVersionTime"   //保存版本时间（1天只显示一次）


#define DBSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

/**    通知     **/
//#define kNotificationClickUser @"kNotificationClickUser"     //点击用户
//#define KNotificationTwo       @"KNotificationTwo"    //点击房间号



#define isiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)]? CGSizeEqualToSize([[UIScreen mainScreen]currentMode].size,CGSizeMake(640, 960)):NO)
#define isiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)]? CGSizeEqualToSize([[UIScreen mainScreen]currentMode].size,CGSizeMake(640, 1136)):NO)
#define isiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)]? CGSizeEqualToSize([[UIScreen mainScreen]currentMode].size,CGSizeMake(750, 1334)):NO)
#define isiPhone7P ([UIScreen instancesRespondToSelector:@selector(currentMode)]? CGSizeEqualToSize([[UIScreen mainScreen]currentMode].size,CGSizeMake(1242, 2208)):NO)

#endif /* GlobalInfo_h */
