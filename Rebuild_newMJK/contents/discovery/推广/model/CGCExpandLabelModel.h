//
//  CGCExpandLabelModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/15.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGCExpandLabelModel : MJKBaseModel
/** <#注释#>*/
@property (nonatomic, strong) NSString *labelId;
/** <#注释#>*/
@property (nonatomic, strong) NSString *name;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *content;
@end

NS_ASSUME_NONNULL_END
