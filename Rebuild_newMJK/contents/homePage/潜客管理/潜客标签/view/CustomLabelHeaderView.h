//
//  CustomLabelHeaderView.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/4.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerDetailInfoModel.h"


typedef NS_ENUM(NSInteger,CusomterInfo){
    CusomterInfoEditTag=0, //编辑潜客标签
    CusomterInfoDetail   //潜客详情的view
};



@interface CustomLabelHeaderView : UITableViewHeaderFooterView
@property(nonatomic,strong)CustomerDetailInfoModel*mainModel;  //只是获取 头像等数据
@property(nonatomic,strong)CustomerDetailInfoModel*membersDetailModel;//粉丝详情
@property(nonatomic,strong)NSMutableArray*allLabelArray;   //就是mainModel 的labelsList类型 选中的model
@property(nonatomic,assign)CusomterInfo Type;

+(CGFloat)headerHeight:(NSArray*)array andType:(CusomterInfo)Type;

/** <#注释#>*/
@property (nonatomic, strong) NSString *nameType;

//潜客详情的view 特有的回调
@property(nonatomic,copy)void(^clickDetailBlock)();
@property(nonatomic,copy)void(^clickToEditTagViewBlock)();
@property(nonatomic,copy)void(^clickLinkCustomerBlock)();

@property(nonatomic,copy)void(^returnHeightBlock)(CGFloat height);

@property(nonatomic,assign)BOOL isZhanbai;

@end
