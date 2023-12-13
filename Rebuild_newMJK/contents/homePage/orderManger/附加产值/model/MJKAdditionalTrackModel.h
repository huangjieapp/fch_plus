//
//  MJKAdditionalTrackModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/10/2.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKAdditionalTrackModel : MJKBaseModel
/** 轨迹id*/
@property (nonatomic, strong) NSString *C_ID;
/** 订单id*/
@property (nonatomic, strong) NSString *C_A42000_C_ID;
/** 记录id*/
@property (nonatomic, strong) NSString *C_OBJECTID;
/** 类型code*/
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
/** 类型*/
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;
/** 轨迹文本*/
@property (nonatomic, strong) NSString *X_REMARK;
/** 后更新时间*/
@property (nonatomic, strong) NSString *D_LASTUPDATE_TIME;
@end

NS_ASSUME_NONNULL_END
