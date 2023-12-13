//
//  CommentView.h
//  match5.0
//
//  Created by huangjie on 2023/6/11.
//

#import <UIKit/UIKit.h>

#import "DBBaseViewController.h"

#import "CustomerPhotoView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentView : UIView
/** <#注释#> */
@property (nonatomic, strong) UITextView *commentTV;
@property (nonatomic, strong) CustomerPhotoView *photoView;
/** <#注释#> */
@property (nonatomic, weak) DBBaseViewController *rootVC;
/** <#注释#> */
@property (nonatomic, strong) UIButton *noticeButton;
@property (nonatomic, strong) UIButton *submitButton;
/** <#注释#>*/
@property (nonatomic, copy) void(^chooseImageArrrayBlock)(NSArray *imageArray);

@end

NS_ASSUME_NONNULL_END
