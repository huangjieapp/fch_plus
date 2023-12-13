//
//  MJKLouDouDetailTableViewCell.h
//  Rebuild_newMJK
//
//  Created by huangjie on 2023/1/15.
//  Copyright © 2023 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKLouDouDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKLouDouDetailTableViewCell : UITableViewCell
/** MJKLouDouDetailModel */
@property (nonatomic, strong) MJKLouDouDetailModel *model;
/** <#注释#> */
@property (nonatomic, strong) NSString *tableType;
/** <#注释#> */
@property (nonatomic, strong) UIButton *toButton;
@end

NS_ASSUME_NONNULL_END
