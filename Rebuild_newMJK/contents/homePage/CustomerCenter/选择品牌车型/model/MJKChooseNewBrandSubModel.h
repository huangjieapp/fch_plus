//
//  MJKChooseBrandSubModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/12/31.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKChooseNewBrandSubModel : MJKBaseModel
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_NAME;
@property (nonatomic, strong) NSString *C_PICTURE_SHOW;
@property (nonatomic, strong) NSString *C_PY;
/** <#注释#> */
@property (nonatomic, getter=isSelected) BOOL selected;
@end

NS_ASSUME_NONNULL_END
