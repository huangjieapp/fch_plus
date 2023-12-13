//
//  ServiceOrderDetailOrEditViewController.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/11/1.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceOrderSubModel.h"
//详情  展示   没有任何地方编辑
//编辑 可以    客户手机  上门地址   工单描述   上传图片   材料信息    不能签名  不编辑状态可以签名

typedef NS_ENUM(NSInteger,OrderType){
    OrderTypeUnComplete=0,
    OrderTypeComplete,   // 编辑又分 点了编辑按钮和 没有电编辑按钮
};


@interface ServiceOrderDetailOrEditViewController : DBBaseViewController

@property(nonatomic,assign)OrderType Type;
@property(nonatomic,strong)ServiceOrderSubModel*pubModel;  //只用到 C_ID   




@end
