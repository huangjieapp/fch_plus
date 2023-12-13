//
//  ServiceTaskTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/27.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceTaskSubModel.h"
#import "ServiceOrderSubModel.h"

@interface ServiceTaskTableViewCell : UITableViewCell

//服务任务
@property(nonatomic,strong)ServiceTaskSubModel*pubMainDatasModel;


//服务订单
@property(nonatomic,strong)ServiceOrderSubModel*pubOrderDatasModel;


/** <#注释#>*/
@property (nonatomic, strong) NSString *tabType;
@property(nonatomic,assign)BOOL isNewAssign;  //是否是重新指派

@end
