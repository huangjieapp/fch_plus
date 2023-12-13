//
//  MJKFlowInstrumentViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKFlowInstrumentViewController : DBBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *operationLabel;
@property (weak, nonatomic) IBOutlet UILabel *manageLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *headTitleArray;

@end
