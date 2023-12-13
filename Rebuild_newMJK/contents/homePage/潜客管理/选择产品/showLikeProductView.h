//
//  showLikeProductView.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/15.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CodeShoppingModel.h"

typedef enum{
    
    showLikeProductViewDefault,
    showLikeProductViewNew
    
}showLikeProductViewStyle;

@interface showLikeProductView : UIView
-(void)getShowValue:(NSMutableArray*)allDatas;

@property(nonatomic,copy)void(^continueSanfBlock)();
@property(nonatomic,copy)void(^completeBlock)(NSMutableArray*array);
@property(nonatomic,copy)void(^deleteModelBlock)(CodeShoppingModel*model);

@property(nonatomic,copy)void(^addBtnBlock)();

@property(nonatomic,copy)void(^minusBtnBlock)();

//新增数量选项
-(instancetype)initWithFrame:(CGRect)frame withType:(showLikeProductViewStyle)style;

@end
