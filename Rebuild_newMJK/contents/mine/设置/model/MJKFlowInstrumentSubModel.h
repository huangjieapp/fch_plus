//
//  MJKFlowInstrumentSubModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKFlowInstrumentSubModel : MJKBaseModel

@property (nonatomic, strong) NSString *C_ID;//每条数据C_ID
@property (nonatomic, strong) NSString *C_NUMBER;//设备编号
@property (nonatomic, strong) NSString *C_POSITION;//位置
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;//设备类型(wifi,流量仪,打印机,在线展厅设置)
@property (nonatomic, strong) NSString *C_PICURL;//图片
@property (nonatomic, strong) NSString *X_REMARK;//备注
@property (nonatomic, strong) NSString *C_NAME;//设备编码
@property (nonatomic, strong) NSString *C_VOUCHERID;//设备条码
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;//设备类型id
@property (nonatomic, strong) NSString *C_LIVEURL;//视频地址

@property (nonatomic, strong) NSString *C_A68000_C_ID;
@property (nonatomic, strong) NSString *C_A68000_C_NAME;
@property (nonatomic, strong) NSString *C_BUSINESS_OUTLETS;
@property (nonatomic, strong) NSString *C_CHANNEL_NUMBER;
@property (nonatomic, strong) NSString *C_SHORTPICURL;

/** 默认屏幕是否选中
 选中true
 未选中false*/
@property (nonatomic, strong) NSString *ISCHECK;
@end
