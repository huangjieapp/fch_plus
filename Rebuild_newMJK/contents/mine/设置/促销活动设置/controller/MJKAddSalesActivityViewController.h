//
//  MJKAddSalesActivityViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/10.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
	SalesActivityAdd,
	SalesActivityEdit,
} SalesActivityEnum;

@interface MJKAddSalesActivityViewController : DBBaseViewController
/** SalesActivityEnum*/
@property (nonatomic, assign) SalesActivityEnum salesActivityType;
/** C_ID*/
@property (nonatomic, strong) NSString *C_ID;
@end

NS_ASSUME_NONNULL_END
