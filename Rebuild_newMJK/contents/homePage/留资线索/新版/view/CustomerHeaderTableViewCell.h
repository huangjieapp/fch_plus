//
//  CustomerHeaderTableViewCell.h
//  match
//
//  Created by huangjie on 2022/7/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomerHeaderTableViewCell : UITableViewCell
/** <#注释#> */
@property (nonatomic, strong) UIImageView *headImageView;
/** <#注释#> */
@property (nonatomic, strong) UITextField *nameTextField;
/** <#注释#> */
@property (nonatomic, copy) void(^choosePhotoBlock)(void);
@end

NS_ASSUME_NONNULL_END
