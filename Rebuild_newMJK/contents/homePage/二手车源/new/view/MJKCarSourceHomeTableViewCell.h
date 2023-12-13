//
//  MJKCarSourceHomeTableViewCell.h
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/10/19.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKCarSourceHomeTableViewCell : UITableViewCell

/** <#注释#> */
@property (nonatomic, strong) UIImageView *headImageView;
/** <#注释#> */
@property (nonatomic, strong) UILabel *headLabel;
/** <#注释#> */
@property (nonatomic, strong) UILabel *titleLabel;
/** <#注释#> */
@property (nonatomic, strong) UILabel *rightLabel;
/** <#注释#> */
@property (nonatomic, strong) UILabel *subLabel;
/** <#注释#> */
@property (nonatomic, strong) UILabel *remarkLabel;
/** <#注释#> */
@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) UILabel *shopLabel;
@end

NS_ASSUME_NONNULL_END
