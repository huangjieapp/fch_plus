//
//  FunnelShowCell.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/8/31.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKFunnelChooseModel.h"

@interface FunnelShowCell : UITableViewCell

@property(nonatomic,strong)NSString*titleStr;   //
@property(nonatomic,strong)NSArray*allDataArray;  //
/** <#注释#>*/
@property (nonatomic, assign) BOOL buttonNoSelected;


@property(nonatomic,copy)void(^customTimeBlock)();   //选择了 自定义时间
/** <#备注#>*/
@property (nonatomic, copy) void(^chooseNormalButtonBlock)(void);
@property(nonatomic,copy)void(^getclickButtonBlock)(MJKFunnelChooseModel*model,NSInteger index);

@property(nonatomic,copy)void(^indexTimeBlock)();   //选择了 自定义时间 111

@property(nonatomic,copy)void(^TimeBlock)();   //选择了 自定义时间 222

@property(nonatomic,copy)void(^gotoBlock)();   //自主跳转页面
+(CGFloat)cellHeightWithArray:(NSArray*)labelArray;
@property(nonatomic,strong)UIButton*moreButton;

@property (weak, nonatomic) UIViewController *rootVC;

@end
