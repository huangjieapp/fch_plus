//
//  CGCAddExpandModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/1/25.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGCAddExpandModel : MJKBaseModel
/** 素材描述*/
@property (nonatomic, strong) NSString *materialDes;

/** 素材链接*/
@property (nonatomic, strong) NSString *materialLink;

/** 素材描述*/
//@property (nonatomic, strong) NSString *materialDes;

/** 所属小区*/
@property (nonatomic, strong) NSString *communitID;

/** 所属小区*/
@property (nonatomic, strong) NSString *communitName;

/** 素材标签*/
@property (nonatomic, strong) NSString *labelID;

/** 素材标签*/
@property (nonatomic, strong) NSString *labelName;

/** urlList*/
@property (nonatomic, strong) NSArray *urlList;

/** <#注释#>*/
@property (nonatomic, strong) NSString *X_URL;

/** <#注释#>*/
@property (nonatomic, strong) NSString *X_BQ;
/** <#注释#>*/
@property (nonatomic, strong) NSString *X_BQName;


@property (nonatomic, strong) NSString *I_ISQRCODE;//个人主页二维码


/** <#注释#>*/
@property (nonatomic, strong) NSString *I_ISSTORE;//门店简介
/** <#注释#>*/
@property (nonatomic, strong) NSString *I_ISMORE;//更多动态

@end

NS_ASSUME_NONNULL_END
