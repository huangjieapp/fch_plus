//
//  WorkCalendartListViewController.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,workCalendartListType){
    workCalendartListTypeNormal=0,  //
    workCalendartListTypeShakeit,  //摇一摇 筛选过了的
    
};

@interface WorkCalendartListViewController : UIViewController

@property(nonatomic,assign)workCalendartListType calendarType;
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
@property (nonatomic, strong) NSString *CREATE_TIME_TYPE;
/** <#注释#>*/
@property (nonatomic, strong) NSString *saleCode;

@end
