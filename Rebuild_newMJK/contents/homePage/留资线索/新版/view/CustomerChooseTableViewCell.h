//
//  CustomerInputTableViewCell.h
//  match
//
//  Created by huangjie on 2022/7/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    CustomerChooseTypeLevel = 0,
    CustomerChooseTypeSource,
    CustomerChooseTypeXS,
    CustomerChooseTypeSF,
    CustomerChooseTypeYW,
    CustomerChooseTypeDG,
    CustomerChooseTypeNW,
    CustomerChooseTypeBirth,
    CustomerChooseTypeTimeWithHMS,
    CustomerChooseTypeTimeWithHM,
    CustomerChooseTypeTimeOnlyHM,
    CustomerChooseTypeChannel,
    CustomerChooseTypeGender,
    CustomerChooseTypePC,
    FollowChooseTypeLevel,
    FollowChooseMode,
    OrderChooseSales,
    CustomerChooseTypeNil,
    CustomerChooseTypeStayTime,
    CustomerChooseTypeWithTYPECODE,
    CustomerChooseTypeWithMainData,
    CarSourceTableViewTypeShopL,
} ChooseType;

@interface CustomerChooseTableViewCell : UITableViewCell
/** <#注释#> */
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *mustLabel;
/** <#注释#> */
@property (nonatomic, assign) ChooseType type;
/** <#注释#> */
@property (nonatomic, strong) NSString *chooseStr;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *sourceStr;
/** <#注释#> */
@property (nonatomic, strong) NSString *typeStr;
/** <#注释#> */
@property (nonatomic, strong) UITextField *chooseTextField;
/** <#注释#> */
@property (nonatomic, strong) UIImageView *rightImageView;
/** <#注释#> */
@property (nonatomic, strong) UIButton *chooseButton;
@property(nonatomic,copy)void(^chooseBlock)(NSString*str,NSString*postValue);
@property(nonatomic,copy)void(^chooseNumberBlock)(NSString* str,NSString*postValue, NSString *number);
@end

NS_ASSUME_NONNULL_END
