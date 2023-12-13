//
//  CustomerInputTableViewCell.h
//  match
//
//  Created by huangjie on 2022/7/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomerInputTableViewCell : UITableViewCell
/** <#注释#> */
@property (nonatomic, strong) UILabel *titleLabel;
/** <#注释#> */
@property (nonatomic, strong) UILabel *mustLabel;
/** <#注释#> */
@property (nonatomic, strong) UITextField *inputTextField;
/** <#注释#> */
@property (nonatomic, assign) NSInteger number;
/** <#注释#> */
@property (nonatomic, assign) BOOL isPhoneNumber;
/** <#注释#> */
@property (nonatomic, strong) UIButton *checkButton;
/** <#注释#> */
@property (nonatomic, strong) NSString *allNumber;
@end

NS_ASSUME_NONNULL_END
