//
//  ProductInfoModel.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/11/1.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductInfoModel : MJKBaseModel
@property(nonatomic,strong)NSString*B_PRICE;
@property(nonatomic,strong)NSString*B_SUBTOTAL;
@property(nonatomic,strong)NSString*C_NAME;
@property(nonatomic,strong)NSString*I_NUMBER;
@property(nonatomic,strong)NSString*C_ID;
@property(nonatomic,strong)NSString*TYPE;


//详情特有
@property(nonatomic,strong)NSString*C_A01300_C_ID;   //工单id
@property(nonatomic,strong)NSString*C_TYPE_DD_ID;     //2和0
@property(nonatomic,strong)NSString*C_TYPE_DD_NAME;   //配件费用   费用类型
@end


//"B_PRICE": "6",
//"B_SUBTOTAL": "18.0",
//"C_ID": "A0440000000006-1509435974f3d19f6d-f",
//"C_NAME": "p",
//"I_NUMBER": "3",
//"TYPE": "0"
