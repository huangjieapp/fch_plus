//
//  CustomLabelHeaderView.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/4.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKCarSourceSubModel;


typedef NS_ENUM(NSInteger,CarSourceInfo){
    CarSourceInfoEditTag=0, //编辑潜客标签
    CarSourceInfoDetail   //潜客详情的view
};



@interface CarSourceLabelHeaderView : UITableViewHeaderFooterView
@property(nonatomic,strong)MJKCarSourceSubModel*mainModel;  //只是获取 头像等数据
@property(nonatomic,assign)CarSourceInfo Type;


/** <#注释#>*/
@property (nonatomic, strong) NSString *nameType;

//潜客详情的view 特有的回调
@property(nonatomic,copy)void(^clickDetailBlock)();
@property(nonatomic,copy)void(^clickToEditTagViewBlock)();
@property(nonatomic,copy)void(^clickLinkCustomerBlock)();

@property(nonatomic,copy)void(^returnHeightBlock)(CGFloat height);

@property(nonatomic,assign)BOOL isZhanbai;

@end
