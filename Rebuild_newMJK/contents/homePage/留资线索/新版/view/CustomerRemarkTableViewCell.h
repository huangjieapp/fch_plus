//
//  CustomerRemarkTableViewCell.h
//  match
//
//  Created by huangjie on 2022/8/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomerRemarkTableViewCell : UITableViewCell
/** <#注释#>*/
@property (nonatomic, weak) UIViewController *rootVC;
/** <#注释#> */
@property (nonatomic, strong) UILabel *mustLabel;
/** <#注释#> */
@property (nonatomic, strong) UILabel *titleLabel;
/** <#注释#> */
@property (nonatomic, strong) UITextView *textView;
@end

NS_ASSUME_NONNULL_END
