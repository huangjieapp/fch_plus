//
//  MJKClueNewProcessHeaderView.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/22.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJKClueDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKClueNewProcessHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
/** MJKClueDetailModel*/
@property (nonatomic, strong) MJKClueDetailModel *model;
/** <#备注#>*/
@property (nonatomic, copy) void(^buttonActionBlock)(NSInteger tag);
@property (nonatomic, copy) void(^secondGotoActionBlock)(void);
@property (nonatomic, copy) void(^firstGotoActionBlock)(void);
@end

NS_ASSUME_NONNULL_END
