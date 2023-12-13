//
//  MJKFunnelChooseModel.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/8/31.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKFunnelChooseModel : NSObject

@property(nonatomic,strong)NSString*name;   //展示名字
@property(nonatomic,strong)NSString*c_id;   //点击传值
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_VOUCHERID;


@property(nonatomic,assign)BOOL isSelected;  //是否选中

    


@end
