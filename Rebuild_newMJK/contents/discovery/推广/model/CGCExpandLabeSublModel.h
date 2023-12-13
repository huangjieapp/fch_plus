//
//  CGCExpandLabeSublModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/15.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGCExpandLabeSublModel : MJKBaseModel
/** <#注释#>*/
@property (nonatomic, strong) NSString *labelId;
/** <#注释#>*/
@property (nonatomic, strong) NSString *name;

@property (nonatomic, getter=isSelected) BOOL selected;
@end

NS_ASSUME_NONNULL_END
