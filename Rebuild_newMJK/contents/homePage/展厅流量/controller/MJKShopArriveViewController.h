//
//  MJKShopArriveViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/28.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKShopArriveContentModel;
typedef NS_ENUM(NSInteger,ShopArriveType){
    ShopArriveTypeAdd=0,
    ShopArriveTypeChoose,
};

typedef void (^BackC_IDBlock)(NSString *C_ID);

@interface MJKShopArriveViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (nonatomic, strong) NSString *isLook;
@property (nonatomic, copy) BackC_IDBlock backC_ID;
@property (nonatomic, copy) void(^backCustomerInfoBlock)(MJKShopArriveContentModel *model);
/** <#注释#>*/
@property (nonatomic, assign) ShopArriveType type;
@end
