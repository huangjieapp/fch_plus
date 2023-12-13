//
//  SHHomePageThirdTableViewCell.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/3.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKManagerModuleModel.h"



@interface SHHomePageThirdTableViewCell : UITableViewCell
@property(nonatomic,strong)UICollectionView*collectionView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** <#注释#>*/
@property (nonatomic, assign) BOOL isHaveDot;
@property(nonatomic,strong)NSMutableArray<MJKManagerModuleModel*>*allDatas;
+(CGFloat)getCellHeight;
@end
