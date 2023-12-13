//
//  DBBaseViewController.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/3/17.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import <UShareUI/UShareUI.h>
//#import <AlipaySDK/AlipaySDK.h>
//#import "WXApi.h"
// <WXApiDelegate>

#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@class HXPhotoManager;
@class VideoAndImageModel;


@interface DBBaseViewController : UIViewController


@property (nonatomic, strong) UILabel * aplaceholdLab;


@property (nonatomic, strong)UIDatePicker *datePicker;
@property (nonatomic, strong)UIButton *doneButton;

- (void)createLabStr:(NSString *)str withbool:(BOOL)hide;
- (void)dismissKeyboardView;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)donePicker;
-(void)dissmissPicker;
////单利
+(instancetype)sharedManager;

//吊用照相机拍照
-(void)TouchAddImage;
//成功后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;



//定位
//定位获取数据
-(void)LocateCurrentLocatedWithSuccess:(void(^)(MAPointAnnotation *annotation))successBlock;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;




//#pragma 友盟很重要的一点     如果没有安装客户端直接把 友盟该第三方登录的按钮隐藏掉 友盟分享的按钮也隐藏掉
////设置友盟分享配置  使用友盟分享 集成自该控制器 然后要吊用此方法
//-(void)setUpShare;
////友盟分享功能 分享的主播的id 
//-(void)showShareMenuWithAnchor_id:(NSString*)idd;
////分享结束 回调得到马币
//-(void)getSharePoint;
////友盟退出登录
//-(void)UMCancelLogin:(NSString*)typeStr;
//得到友盟登录的所有数据
//-(void)getUMShareDatasWithPlatformType:(NSString*)typeStr success:(void(^)(UMSocialUserInfoResponse* resp))success failure:(void(^)(NSError*error))fail;



////微信支付
//-(void)TowechatPay:(NSDictionary*)dict;
////支付宝支付
//-(void)ToaliPay:(NSString*)orderString;


- (void)selectTelephone:(NSInteger)index;//拨打电话

- (void)datePickerAndMethod;


- (void)closePhone;
//电话
- (void)telephoneCall:(NSInteger)index;
//座机
- (void)landLineCall:(NSInteger)index;
//回呼
- (void)callBack:(NSInteger)index;
- (void)whbcallBack:(NSInteger)index;


- (void)openPhotoLibraryWith:(HXPhotoManager * _Nullable)photoManager success:(void (^_Nullable)(VideoAndImageModel * _Nullable model))successUpdateBlock;
@end
