//
//  MJKHomePageCompleteCollectionCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/26.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJKHomePageJXModel.h"

@interface MJKHomePageCompleteCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UILabel *completeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** MJKHomePageJXModel*/
@property (nonatomic, strong) MJKHomePageJXModel *jxModel;
@end
