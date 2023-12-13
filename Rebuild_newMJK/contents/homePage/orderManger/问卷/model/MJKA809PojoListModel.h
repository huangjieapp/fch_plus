//
//  MJKA809PojoListModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/10/8.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKA809PojoListModel : UIView
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_A80700_C_ID;
@property (nonatomic, strong) NSString *C_A80700_C_NAME;
@property (nonatomic, strong) NSString *C_A80800_C_ID;
@property (nonatomic, strong) NSString *C_A80800_C_NAME;
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_NAME;
@property (nonatomic, strong) NSString *I_ISTEXT;

/** <#注释#>*/
@property (nonatomic, getter=isSelected) BOOL selected;
@end

NS_ASSUME_NONNULL_END
