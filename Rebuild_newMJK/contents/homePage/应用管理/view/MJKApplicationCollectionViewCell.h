//
//  MJKApplicationCollectionViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/5.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKManagerModuleModel.h"
#import "MJKApplicationTableViewCell.h"

@interface MJKApplicationCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)MJKManagerModuleModel*model;
@property(nonatomic,assign)ApplicationType appType;
@property(nonatomic,assign)BOOL isSelected;



@end
