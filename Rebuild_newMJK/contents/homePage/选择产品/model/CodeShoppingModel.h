//
//  CodeShoppingModel.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/15.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CodeShoppingModel : NSObject




//编辑特有的
@property(nonatomic,strong)NSString*I_NUMBER;
@property(nonatomic,strong)NSString*C_ID;
@property(nonatomic,strong)NSString*B_MONEY;


@property(nonatomic,strong)NSString*C_A41900_C_ID;
@property(nonatomic,strong)NSString*B_PRICE;
@property(nonatomic,strong)NSString*C_A41900_C_NAME;
@property(nonatomic,strong)NSString*C_PRODUCTCODE;   //都有



@property(nonatomic,strong)NSString*isStatus;  //add   edit   delete

@end



//"B_PRICE" = "1000.00";
//"C_A41900_C_ID" = test1;
//"C_A41900_C_NAME" = "\U684c\U5b50";
//"C_PRODUCTCODE" = 001;



//{
//    "B_MONEY" = "1000.00";
//    "B_PRICE" = "1000.00";
//    "C_A41900_C_ID" = test1;
//    "C_A41900_C_NAME" = "\U684c\U5b50";
//    "C_ID" = "A47100_3949780397";
//    "C_PRODUCTCODE" = 001;
//    "I_NUMBER" = 1;
//}
