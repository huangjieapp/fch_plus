//
//  MJKFlowProcessViewController.h
//  Rebuild_newMJK
//
//  Created by mac on 2018/12/3.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKFlowMeterSubSecondModel;

typedef enum : NSUInteger {
    MJKFlowProcessOneImage,
    MJKFlowProcessMoreImage,
} MJKFlowProcessType;

@interface MJKFlowProcessViewController : DBBaseViewController
/** MJKFlowProcessType*/
@property(nonatomic,assign) MJKFlowProcessType type;

@property (nonatomic, strong) MJKFlowMeterSubSecondModel *model;
/** <#注释#>*/
@property (nonatomic, strong) NSString *typeName;

/** headImageArray*/
@property(nonatomic,strong) NSMutableArray *headImageArray;
@property(nonatomic,strong) NSMutableArray *C_A41500_C_IDArray;
@property(nonatomic,strong) NSMutableArray *C_A41500_C_NAMEArray;
/** 记录id*/
@property (nonatomic, strong) NSMutableArray *idArr;
@property (nonatomic, strong) NSString *idStr;
/** <#注释#>*/
@property (nonatomic, strong) NSString *vcName;
/** <#注释#>*/
@property (nonatomic, strong) NSString *clueName;
@property (nonatomic, strong) UIViewController *superVC;
/** <#注释#>*/
@property (nonatomic, strong) NSString *fromStr;
/** 历史文本*/
@property (nonatomic, strong) NSString *X_REMARK;

@end
