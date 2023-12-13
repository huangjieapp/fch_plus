//
//  CustomerPhotoView.h
//  match
//
//  Created by huangjie on 2022/8/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomerPhotoView : UIView
/** <#注释#> */
@property (nonatomic, strong) UIView *bgView;
/** <#注释#> */
@property (nonatomic, assign) BOOL isNoEdit;
/** <#注释#> */
@property (nonatomic, strong) UILabel *mustLabel;

/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *titleLabel;
/** <#注释#> */
@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) NSMutableArray *imageUrlArray;
/** <#注释#> */
@property (nonatomic, weak) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, weak) UIViewController *rootVC;
@end

NS_ASSUME_NONNULL_END
