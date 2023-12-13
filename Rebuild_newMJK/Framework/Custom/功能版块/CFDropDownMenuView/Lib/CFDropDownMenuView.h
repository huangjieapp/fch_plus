//
//  CFDropDownMenuView.h
//  CFDropDownMenuView
//
//  Created by Peak on 16/5/28.
//  Copyright © 2016年 陈峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFLabelOnLeftButton.h"
#import "CFDropDownModel.h"

#import "FunnelShowView.h"

@class CFDropDownMenuView;

@protocol CFDropDownMenuViewDelegate <NSObject>

@optional

- (void)dropDownMenuView:(CFDropDownMenuView *)dropDownMenuView clickOnCurrentButtonWithTitle:(NSString *)currentTitle andCurrentTitleArray:(NSArray *)currentTitleArray;

@end


@interface CFDropDownMenuView : UIView <UITableViewDelegate, UITableViewDataSource>
/**
 *  提供两种方式处理筛选条件后的业务逻辑(回调方式) - 代理/block 二选一
 */
/* block 点击选择条件按钮 调用 */
typedef void (^ChooseConditionBlock)(NSString*selectedSection,NSString*selectedRow ,NSString *title);
/* 代理 */
@property (nonatomic, weak) id<CFDropDownMenuViewDelegate> delegate;
@property (nonatomic, copy) ChooseConditionBlock chooseConditionBlock;

//选中的button 的下标
@property(nonatomic,assign)NSInteger selectedButtonIndex;

/** 订单管理切换tab页时筛选b变成全部*/
@property (nonatomic, strong) NSString *setNil;

//”流量仪“ ？ 全部的时候显示标题
@property (nonatomic, strong) NSString *VCName;
@property (nonatomic, strong) NSString *typeName;
/**
 *  cell为筛选的条件    为了让  table。delegate 吊点击方法。
 */
@property (nonatomic, strong) UITableView *dropDownMenuTableView;
/** <#注释#> */
@property (nonatomic, copy) void(^chooseCarTypeBlock)(NSString *typeStr);


#pragma 只有当indexRow=0  并且是全部的时候 才显示原来的title  否则就是筛选条件。

/**
 *  数据源--二维数组
 *  每一个大分类里, 都可以有很多个小分类(条件)
 */
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

/* 默认显示的  选择了第一个 就 还是用默认的 */
@property (nonatomic, strong) NSArray *defaulTitleArray;

/* 分类内容 动画起始位置 显示tableView 的位置*/
@property (nonatomic, assign) CGFloat startY;



    
- (void)tableReload;

- (void)show;
- (void)hide;

@end







#pragma mark  --添加一个图片的返回按钮
//这里的大小  给定为 最右边的  40，40
@interface CFRightButton : UIView

@property(nonatomic,copy)void(^clickFunnelBlock)(BOOL isSelected);

@end
