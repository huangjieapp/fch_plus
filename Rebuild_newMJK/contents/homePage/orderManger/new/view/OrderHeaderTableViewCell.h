//
//  OrderHeaderTableViewCell.h
//  match
//
//  Created by huangjie on 2022/7/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderHeaderTableViewCell : UITableViewCell
/** <#注释#> */
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *headLabel;
/** <#注释#> */
@property (nonatomic, strong) UITextField *nameTextField;
/** <#注释#> */
@property (nonatomic, strong) UIButton *wechatButton;
@property (nonatomic, strong) UIButton *messageButton;
@property (nonatomic, strong) UIButton *phoneButton;
@end

NS_ASSUME_NONNULL_END
