//
//  MJKManagerModuleModel.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/8/31.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKManagerModuleModel : MJKBaseModel
@property(nonatomic,strong)NSString*name;
@property(nonatomic,strong)NSString*imageName;
@property(nonatomic,strong)NSString*code;
/** <#备注#>*/
@property (nonatomic, assign) BOOL isBuy;
@property(nonatomic, getter=isSelected)  BOOL selected;  //当前是被选中了


@end
