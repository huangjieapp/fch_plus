//
//  MJKDataDicModel.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/8/30.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKDataDicModel : NSObject



@property(nonatomic,strong)NSString*C_TYPECODE;   //
@property(nonatomic,strong)NSString*C_FATHERVOUCHERID;
@property(nonatomic,strong)NSString*C_ID;     //删除和更新用这个
@property(nonatomic,strong)NSString*C_NAME;
@property(nonatomic,strong)NSString*C_VOUCHERID;   //性别的话 传这个字段   筛选用这个值
@property(nonatomic,strong)NSString*FLAG;          //insert delete  add  update
@property(nonatomic,strong)NSString*I_SORTIDX;
@property(nonatomic,getter=isSelected) BOOL selected;

@end




//{
//    "C_FATHERVOUCHERID" = "-2";
//    "C_ID" = "S10300IAC00001-15CC9C16D53NDSVP55OJ3B77WOQ43DPKN";
//    "C_NAME" = "\U5230\U5e97";
//    "C_TYPECODE" = "A41300_C_CLUESOURCE";
//    "C_VOUCHERID" = "A41300_C_CLUESOURCE_0011";
//    FLAG = INSERT;
//    "I_SORTIDX" = 11;
//},
