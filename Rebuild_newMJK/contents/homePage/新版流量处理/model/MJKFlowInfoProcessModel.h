//
//  MJKFlowInfoProcessModel.h
//  Rebuild_newMJK
//
//  Created by mac on 2018/12/3.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKFlowInfoProcessModel : MJKBaseModel
/** 左标题*/
@property(nonatomic,strong) NSString *title;
/** 右元素*/
@property(nonatomic,strong) NSString *content;
/** 是否可编辑*/
@property(nonatomic,assign) BOOL isEdit;
/** 是否选择*/
@property(nonatomic,assign) BOOL isSelect;
/** 是否有数据*/
@property(nonatomic,assign) BOOL isData;
/** 是否有增加建设*/
@property(nonatomic,assign) BOOL isAdd;
@end
