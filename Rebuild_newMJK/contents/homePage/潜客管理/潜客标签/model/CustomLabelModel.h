//
//  CustomLabelModel.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/4.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomLabelModel : MJKBaseModel

@property(nonatomic,strong)UIColor*currentColor;
@property(nonatomic,strong)NSString*title;
@property(nonatomic,assign)BOOL isSelected;   //保存选中状态


@property(nonatomic,strong)NSString*C_COLOR_DD_ID;
@property(nonatomic,strong)NSString*C_COLOR_DD_NAME;
@property(nonatomic,strong)NSString*C_ID;
@property(nonatomic,strong)NSString*C_NAME;


//{
//    "C_COLOR_DD_ID" = "A46600_C_COLOR_0001";
//    "C_COLOR_DD_NAME" = "橙色";
//    "C_ID" = "A46700IAC00002-15E3CA55139DUGP38U4HAR34HT68QGWQ0";
//    "C_NAME" = "蛇精脸";
//}



@end
