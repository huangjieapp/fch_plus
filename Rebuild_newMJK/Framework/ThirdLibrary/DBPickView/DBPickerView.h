//
//  DBPickerView.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/18.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,PickViewType){
    PickViewTypeArray=0,   // 1条
    PickViewTypeAddress,   //  2条
    PickViewTypeBirthday,   // 生日      2017-05-10
    PickViewTypeDate,       //日期       2017-05-10 22:22:22
    PickViewTypeMimute,//逗留时间
	PickViewTypeDateToMimute,//2017-05-10 22:22
	PickViewTypePickerModeTime,
    PickViewTypeNewAddress,
    
};

typedef void(^chosePickViewBlock)(NSString*title,NSString* indexStr);

@interface DBPickerView : UIView
//类型
@property(nonatomic,assign)PickViewType currentType;
//数据   0一维   2二维格式 都是字典  每个字典里面 name 和 cities【】
@property(nonatomic,assign)NSMutableArray*mtArrayDatas;
//选中 0string   1 逗号隔开
@property (nonatomic,strong)NSString *selectStr;
//标题的名字
@property(nonatomic,strong)NSString*titleStr;

//如果是地址的话 title用， 分来      indexStr用，分开
@property(nonatomic,copy)chosePickViewBlock choseBlock;


-(instancetype)initWithFrame:(CGRect)frame andCurrentType:(PickViewType)currentType andmtArrayDatas:(NSMutableArray*)mtArrayDatas andSelectStr:(NSString*)selectedStr andTitleStr:(NSString*)titleStr andBlock:(chosePickViewBlock)choseBock;

/** cancel block*/
@property (nonatomic, copy) void(^cancelBlock)(void);

@end
