//
//  ModuleCollectionViewCell.h
//  match
//
//  Created by huangjie on 2022/8/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ModuleCollectionViewCell : UICollectionViewCell
/** <#注释#> */
@property (nonatomic, strong) UIImageView *moduleImageView;
/** <#注释#> */
@property (nonatomic, strong) UILabel *moduleLabel;

@property (nonatomic, strong) UIImageView *moduleSelectImageView;
/** <#注释#> */
@property (nonatomic, strong) UIView *bgView;
/** <#注释#> */
@property (nonatomic, assign) BOOL isCheck;

@end

NS_ASSUME_NONNULL_END
