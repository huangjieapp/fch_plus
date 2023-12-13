//
//  FunnelShowView.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/28.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKFunnelChooseModel.h"
@class MJKProductShowModel;

@interface FunnelShowView : UIView


#pragma 如果要自定义时间的。  allDatas 里面的model C_ID 传999

+(instancetype)funnelShowView;
//[[model,model],[],[],];
/*
 *@{@"title":@"创建时间",@"content":contentArr};    allDatas 里面的一个元素  字典。
 contentArr  数组   里面的元素是  model    MJKFunnelChooseModel
 
 */

@property(nonatomic,strong)NSMutableArray*allDatas;

//取消选中第几个section  第几个row   并刷新
-(void)unselectedDetailRow:(NSIndexPath*)indexPath;

@property (nonatomic, weak) UIViewController *rootVC;


/*@{@"model":model,@"index":index};   里面都是字典  且返回第几个cell   和具体的model
*重置回调 走完 会继续走sureBlock 的   价格 array.count<1 的时候 nil
 */
@property(nonatomic,copy)void(^sureBlock)(NSMutableArray*array);
@property(nonatomic,copy)void(^jieshaorenAndLastTimeBlock)(NSString *jieshaoren, NSString *arriveTimes);
@property(nonatomic,copy)void(^pcBlock)(NSString *pcStr, NSString *pcCode);
@property(nonatomic,copy)void(^chooseProductBlock)(MJKProductShowModel *productModel);

//自定义的时间反馈
@property(nonatomic,copy)void(^viewCustomTimeBlock)(NSInteger selectedSection);
//重置的回调，  处理数据的时候 把自定义时间的值去掉  再刷新。
//重置之后 要重新刷新数据
@property(nonatomic,copy)void(^resetBlock)();



//what  用不到
@property(nonatomic,copy)void(^indexTimeBlock)();
@property(nonatomic,copy)void(^TimeBlock)();

-(void)show;
-(void)hidden;
@end
