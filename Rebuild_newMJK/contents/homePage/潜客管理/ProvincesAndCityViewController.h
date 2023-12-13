//
//  ProvincesAndCityViewController.h
//  match5.0
//
//  Created by huangjie on 2023/2/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProvincesAndCityViewController : DBBaseViewController

@property (nonatomic, strong) NSString *vcName;
/** <#注释#>*/
@property (nonatomic, copy) void(^backBlock)(void);
/** <#注释#>*/
@property (nonatomic, copy) void(^chooseBlock)(NSArray *pAcArray);
@end

NS_ASSUME_NONNULL_END
