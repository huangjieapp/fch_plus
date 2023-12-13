//
//  MJKFlowProcessModel.h
//  Rebuild_newMJK
//
//  Created by mac on 2018/12/3.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKFlowProcessModel : MJKBaseModel
/** id*/
@property(nonatomic,strong) NSString *C_ID;
/** 左标题*/
@property(nonatomic,strong) NSString *title;
/** 右元素*/
@property(nonatomic,strong) NSString *content;
/** 接口字段*/
@property (nonatomic, strong) NSString *code;
/** 接口字段*/
@property (nonatomic, strong) NSString *nameCode;
@property (nonatomic, strong) NSString *detailCode;
/** 是否可编辑*/
@property(nonatomic,assign) BOOL isEdit;
/** 是否有开关*/
@property(nonatomic,assign) BOOL isHaveSwitch;
/** 是否跳转*/
@property(nonatomic,assign) BOOL isGo;
/** 是否选择*/
@property(nonatomic,assign) BOOL isSelect;
/** 是否有数据*/
@property(nonatomic,assign) BOOL isData;
/** 是否有增加建设*/
@property(nonatomic,assign) BOOL isAdd;
@end
