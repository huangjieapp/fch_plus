//
//  CGCAppiontDetailVC.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/8/31.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "DBBaseViewController.h"

typedef NS_ENUM(NSInteger,AppointmentType){
    appointmentTypeAdd=0,
    appointmentTypeChoose,
};

typedef void(^RETABLEBLOCK)();

@class CGCAppointmentModel;

@interface CGCAppiontDetailVC : DBBaseViewController

@property (nonatomic, copy) NSString *C_ID;

@property (nonatomic, copy) NSString *isDiss;
/** <#备注#>*/
@property (nonatomic, strong) NSString *assitStr;
/** <#注释#>*/
@property (nonatomic, weak) UIViewController *rootVC;
/** <#注释#>*/
@property (nonatomic, assign) AppointmentType type;


@property (nonatomic, copy) RETABLEBLOCK reBlock;
@end
