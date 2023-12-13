//
//  CustomerDetailChooseView.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/22.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerDetailChooseView : UIView
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;



@property(nonatomic,strong)NSString*titleStr;
@property(nonatomic,strong)NSString*numberStr;


@end
