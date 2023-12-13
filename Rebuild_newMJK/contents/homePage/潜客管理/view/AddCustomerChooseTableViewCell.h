//
//  AddCustomerChooseTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,chooseType){
    ChooseTableViewTypeLevel=0,   //等级
    ChooseTableViewTypeFansLevel,
    ChooseTableViewTypeFansType,
    ChooseTableViewTypeStage,     //阶段
    ChooseTableViewTypeGender,    //性别
    ChooseTableViewTypeCustomerSource,  //来源
    ChooseTableViewTypeAction,   //市场活动
    
    
    ChooseTableViewTypeCity,   //省市                //四川省,巴中市  使用，隔开  name和post值是一样的
    ChooseTableViewTypeIndustry,   //行业
    ChooseTableViewTypeYearIn,   //年收入
    ChooseTableViewTypeEducation,   //物业类型A41500_C_EDUCATION
    ChooseTableViewTypeMarriage,   //居住人口
    ChooseTableViewTypeBirthday,   //生日
    ChooseTableViewTypeHobby,   //爱好
    
    ChooseTableViewTypeAllTime, //全时间   跟进时间   2017-04-10 HH:mm:ss
    ChooseTableViewTypeCategory,
    
    ChooseTableViewTypeMimute,//逗留时间
    
    
    //服务任务新增中
    ChooseTableViewTypeChooseCustomer,   //选择客户   name  里面有 电话号码  地址   需要分割的
    CHooseTableViewTypeTaskType,   //任务类型
    CHooseTableViewCarTypeTaskType,//二手车源任务x类型
    CHooseTableViewTypeServicer,  //服务人员
    
    //服务工单
    CHooseTableViewTypeOrderType,  //工单类型
    
    //申请入驻 服务类型
    CHooseTableViewTypeApplyEnter,
    
    //房车汇 来源渠道
    chooseTypeHouseCarSourceWay,
    
    //意向车型
    chooseTypeHouseCarType,   //意向车型的回调 是两个名字  两个id
    
    chooseTypeNil,//无选项
    chooseTypeIsOutType,
    CHooseTableViewTypeCustomerStatus,//状态
    CHooseTableViewTypeListStatus,
    ChooseTableViewTypeFansHY,
    CHooseTableViewTypeFansStatus,
    CHooseTableViewTypeArriveShop,
    ChooseTableViewTypeCustomerLabel,//客户标签
    ChooseTableViewTypeCustomerStar,//星标客户
    CHooseTableViewTypeArriveShopWay,//到店方式
    CHooseTableViewTypeType,//A47700_C_TYPE 类型
    CHooseTableViewTypeRobotTime,// 创建时间、到店时间
    CHooseTableViewTypeRobotActiveTime,//active
    
    ChooseTableViewTypeShopActivity,
    ChooseTableViewTypeActivityType,
    CHooseTableViewTypeMumber,
    ChooseTableViewTypePaymentMethods,//收款方式
    ChooseTableViewTypePaymentType,//收款类型
    //二手车源
    ChooseTableViewTypeCarLevel,
    ChooseTableViewTypeCarType,
    ChooseTableViewTypeCarSpecies,
    ChooseTableViewTypeCarCity,
    ChooseTableViewTypeCarBSX,
    ChooseTableViewTypeCarPL,
    ChooseTableViewTypeCarRYTYPE,
    ChooseTableViewTypeCarPFBZ,
    ChooseTableViewTypeCarZDSG,
    ChooseTableViewTypeCarHSSG,
    ChooseTableViewTypeCarPSSG,
    ChooseTableViewTypeFolderType,
    ChooseTableViewTypeProtect,
    ChooseTableViewTypeManufacturer,
    ChooseTableViewTypeSeatCount,
    ChooseTableViewTypeCarStates,
    ChooseTableViewTypeCarPP,
    ChooseTableViewTypeCarInventoryType,
    ChooseTableViewTypeCarSource,
    ChooseTableViewTypeCarAllStor,
    ChooseTableViewTypeCustomerCarType,
    ChooseTableViewTypeDeploy,//车型配置
    ChooseTableViewTypecCluesType,
    ChooseTableViewTypeMODEFOLLOW,
    ChooseTableViewTypeTaskClockType,
    ChooseTableViewTypeA80200_C_CARTYPE,
    ChooseTableViewTypeA80200_C_CPTYPE,
    ChooseTableViewTypeA80200_C_DKNX,
    ChooseTableViewTypeA80000_C_TYPE,
    ChooseTableViewTypeA80200_C_CPTYPEHIGH,
    ChooseTableViewTypeProvince,
    ChooseTableViewTypeNewCity,
    ChooseTableViewTypeA802_C_TYPE,
    ChooseTableViewTypeA475List,
    ChooseTableViewTypeA800YJSHZH,
    ChooseTableViewTypeJSSTATUS,
    ChooseTableViewTypeSFZJ,
    ChooseTableViewTypeXL,
    ChooseTableViewTypeWWXYY,
    ChooseTableViewTypeA81500_C_STATUS,
    ChooseTableViewTypeA81500_C_JJCD,
    ChooseTableViewTypeA81500_WXRYTYPE,
    ChooseTableViewTypeShopL,
    CustomerChooseTypeWithMainDataForA806
    
};


@interface AddCustomerChooseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *titleBGView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeftLayout;
@property (weak, nonatomic) IBOutlet UILabel *taglabel;
@property (weak, nonatomic) IBOutlet UILabel *BottomLineView;
@property (weak, nonatomic) IBOutlet UILabel *nameTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *chooseTextField;
@property (nonatomic, strong) NSString *vcName;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
/** <#注释#>*/
@property (nonatomic, strong) NSString *showTime;
/** <#注释#>*/
@property (nonatomic, strong) NSString *provinceValue;


@property(nonatomic,strong)NSString*SourceID;  //来源渠道的id  获取 市场活动（渠道细分）必须要传   可以是@“”
@property(nonatomic,strong)NSString*C_TYPECODE;
@property(nonatomic,strong)NSString*C_FATHERVOUCHERID;
@property(nonatomic,strong)NSString*textStr;  //给textField赋值
@property(nonatomic,assign)chooseType Type;
@property(nonatomic,copy)void(^chooseBlock)(NSString*str,NSString*postValue);
/** 地址返回*/
@property (nonatomic, copy) void(^backAddressBlock)(NSString *addressStr);
/** 是否需要标题*/
@property (nonatomic, assign) BOOL isTitle;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
