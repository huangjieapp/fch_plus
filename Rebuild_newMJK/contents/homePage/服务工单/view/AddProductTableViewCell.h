//
//  AddProductTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/31.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductInfoModel.h"

@interface AddProductTableViewCell : UITableViewCell

@property(nonatomic,strong)NSString*titleStr;  //标题的名字
@property(nonatomic,strong)NSMutableArray*datasArray;

@property(nonatomic,copy)void(^clickAddInfoButtonBlock)(NSString*titleStr);
@property(nonatomic,copy)void(^DeleteOneInfoBlock)(NSInteger row);

+(CGFloat)getCellHeight:(NSMutableArray*)datasArray;
@end
