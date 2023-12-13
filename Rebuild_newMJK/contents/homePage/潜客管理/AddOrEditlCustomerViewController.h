//
//  AddOrEditlCustomerViewController.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBBaseViewController.h"
#import "CustomerDetailInfoModel.h"

typedef NS_ENUM(NSInteger,customerType){
    customerTypeAdd=0,
    customerTypeEdit,
    
    
    
    customerTypeCallTo,        //来电流量              转潜客
    customerTypeExhibition,    // 展厅流量  流量仪      转潜客
};



@protocol AddOrEditlCustomerViewControllerDelegate <NSObject>

//新增玩潜客 跳跟进  有问题跳警告框
//dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    [self presentViewController:alertVC animated:YES completion:nil];
//});
-(void)DelegateForCompleteAddCustomerShowAlertVCToFollow:(CustomerDetailInfoModel*)newModel;

@end


@interface AddOrEditlCustomerViewController : DBBaseViewController

/** <#注释#>*/
@property (nonatomic, strong) NSString *C_A41300_C_ID;
//公共
@property(nonatomic,assign)customerType Type;
@property(nonatomic,copy)void(^completeComitBlock)(NSString *C_ID, CustomerDetailInfoModel*newModel);   //完成回调  之后的回调
@property(nonatomic,assign)UIViewController*superVC;  //完成后返回到 指定控制器 不传为pop
@property (nonatomic,strong) NSString *vcName;//

/** <#注释#>*/
@property (nonatomic, strong) NSString *assistStr;
//编辑潜客 界面特有的
@property(nonatomic,strong)CustomerDetailInfoModel*mainModel;

/** 楼盘id*/
@property (nonatomic, strong) NSString *C_A48200_C_ID;
@property (nonatomic, strong) NSString *addressStr;

//来电流量转潜客   客户来源--来电    Type=customerTypeCallTo
@property(nonatomic,strong)NSString*phoneNumber;         //电话号码
@property(nonatomic,strong)NSString*marketAction;        //市场活动name
@property(nonatomic,strong)NSString*marketActionID;     //市场活动id
@property(nonatomic,strong)NSString*phoneRemark;        //备注
@property(nonatomic,strong)NSString*phoneC_A41400_C_ID;    //必传


//展厅流量 和 流量仪   客户来源--到店      Type=customerTypeExhibition
@property(nonatomic,strong)NSString*exhibitionMarketAction;
@property(nonatomic,strong)NSString*exhibitionMarketActionID;
@property(nonatomic,strong)NSString*exhibitionSourceAction;
@property(nonatomic,strong)NSString*exhibitionSourceActionID;
@property(nonatomic,strong)NSString*exhibitionRemark;
@property(nonatomic,strong)NSString*exhibitionC_A41400_C_ID;   //必传
@property(nonatomic,strong)NSString*portraitAddress; //头像地址    @“C_HEADIMGURL”


@property(nonatomic,weak)id<AddOrEditlCustomerViewControllerDelegate>delegate;



// customerTypeAdd  新增的时候   如果有值  那么就会赋值     线索处理转新增潜客 就是这个例子
//姓名 电话   来源渠道 渠道细分   性别 备注
@property(nonatomic,strong)NSString*pubNameStr;
@property(nonatomic,strong)NSString*pubTelStr;
@property(nonatomic,strong)NSString*pubSourceStr;
@property(nonatomic,strong)NSString*pubSourceIDStr;
@property(nonatomic,strong)NSString*pubMarketStr;
@property(nonatomic,strong)NSString*pubMarketID;
@property(nonatomic,strong)NSString*pubSexStr;
@property(nonatomic,strong)NSString*pubJieshorenStr;
@property(nonatomic,strong)NSString*pubJieshorenID;
@property(nonatomic,strong)NSString*pubSetID;
@property(nonatomic,strong)NSString*pubAddress;
@property(nonatomic,strong)NSString*cluePeople;
@property(nonatomic,strong)NSString*cluePeopleID;
@property(nonatomic,strong)NSString*pubRemarketStr;
@property(nonatomic,strong)NSString*C_A40600_NAME;//意向产品
@property(nonatomic,strong)NSString*pubWECHAT;//微信

@property (nonatomic, strong) NSString *C_YX_A49600_C_ID;
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_YX_A70600_C_ID;

/** <#注释#>*/
@property (nonatomic, strong) NSString *C_A49600_C_ID;
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_A70600_C_ID;


@end
