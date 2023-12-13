//
//  CustomerListTableViewCell.h
//  match
//
//  Created by huangjie on 2022/7/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomerListTableViewCell : UITableViewCell
/** <#注释#> */
@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UIImageView *genderImageView;
/** <#注释#> */
@property (nonatomic, strong) UILabel *headLabel;
/** <#注释#> */
@property (nonatomic, strong) UILabel *titleLabel;
/** <#注释#> */
@property (nonatomic, strong) UILabel *subTitleLabel;
/** <#注释#> */
@property (nonatomic, strong) UIImageView *levelImageView;
/** <#注释#> */
@property (nonatomic, strong) UIImageView *starImageView;
/** <#注释#> */
@property (nonatomic, strong) UILabel *phoneLabel;
/** <#注释#> */
@property (nonatomic, strong) UILabel *addressLabel;
/** <#注释#> */
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *jfLabel;
/** <#注释#> */
@property (nonatomic, strong) UILabel *saleLabel;
/** <#注释#> */
@property (nonatomic, strong) UIButton *chooseButton;
@end

NS_ASSUME_NONNULL_END
