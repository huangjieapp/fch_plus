//
//  MJReportDataModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/11/29.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJReportDataModel : MJKBaseModel
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_NAME;
@property (nonatomic, strong) NSString *xs_ri_xx_yx;
@property (nonatomic, strong) NSString *xs_ri_xs_yx;
@property (nonatomic, strong) NSString *xs_ri_xs_xsl;
@property (nonatomic, strong) NSString *xs_ri_xx_xsl;
@property (nonatomic, strong) NSString *xs_yue_xs_yx;
@property (nonatomic, strong) NSString *xs_yue_xx_yx;
@property (nonatomic, strong) NSString *xs_yue_xs_xsl;
@property (nonatomic, strong) NSString *xs_yue_xx_xsl;
@property (nonatomic, strong) NSString *xs_nian_xs_yx;
@property (nonatomic, strong) NSString *xs_nian_xx_yx;
@property (nonatomic, strong) NSString *xs_nian_xs_xsl;
@property (nonatomic, strong) NSString *xs_nian_xx_xsl;


@property (nonatomic, strong) NSString *yy_ri_xs;
@property (nonatomic, strong) NSString *yy_ri_xx;
@property (nonatomic, strong) NSString *yy_yue_xs;
@property (nonatomic, strong) NSString *yy_yue_xx;
@property (nonatomic, strong) NSString *yy_nian_xs;
@property (nonatomic, strong) NSString *yy_nian_xx;

@property (nonatomic, strong) NSString *dd_ri_xs;
@property (nonatomic, strong) NSString *dd_ri_xx;
@property (nonatomic, strong) NSString *dd_yue_xs;
@property (nonatomic, strong) NSString *dd_yue_xx;
@property (nonatomic, strong) NSString *dd_nian_xs;
@property (nonatomic, strong) NSString *dd_nian_xx;

@property (nonatomic, strong) NSString *qk_ri_xs;
@property (nonatomic, strong) NSString *qk_ri_xx;
@property (nonatomic, strong) NSString *qk_yue_xs;
@property (nonatomic, strong) NSString *qk_yue_xx;
@property (nonatomic, strong) NSString *qk_nian_xs;
@property (nonatomic, strong) NSString *qk_nian_xx;
@end

NS_ASSUME_NONNULL_END
