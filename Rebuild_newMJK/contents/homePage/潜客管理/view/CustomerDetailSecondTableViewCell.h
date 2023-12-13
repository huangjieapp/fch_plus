//
//  CustomerDetailSecondTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/22.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerDetailPathDetailModel.h"
#import "MJKHistorySubModel.h"
@class VoiceRecordModel;


@interface CustomerDetailSecondTableViewCell : UITableViewCell

@property(nonatomic,strong)CustomerDetailPathDetailModel*MainModel;
/** <#注释#> */
@property (nonatomic, strong) VoiceRecordModel *voiceModel;


@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImage;
- (void)updataHistoryCell:(MJKHistorySubModel *)model;

@property(nonatomic,copy)void(^clickScaleBlock)(CustomerDetailPathDetailModel*model);


@end
