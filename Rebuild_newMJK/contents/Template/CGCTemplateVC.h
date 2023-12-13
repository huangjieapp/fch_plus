//
//  CGCTemplateVC.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "DBBaseViewController.h"
//@class CustomerDetailInfoModel;
#import "CustomerDetailInfoModel.h"

typedef enum : NSUInteger {
    CGCTemplateMessage,
    CGCTemplateWeiXin,
    CGCTemplatePublic
} CGCTemplateType;


@interface CGCTemplateVC : DBBaseViewController


@property (assign) CGCTemplateType templateType;

@property (nonatomic, copy) NSString *titStr;

@property (nonatomic, strong) NSMutableArray *customIDArr;

@property (nonatomic, strong) NSMutableArray *customPhoneArr;

@property (nonatomic, copy) NSString *C_A51100_C_ID;//粉丝ID

@property (nonatomic, strong) CustomerDetailInfoModel *cusDetailModel;

@property (nonatomic, copy) NSString *isFollow;
/** <#备注#>*/
@property (nonatomic, copy) void(^textBackBlock)(NSString *str);
@end
