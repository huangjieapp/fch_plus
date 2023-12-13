//
//  ReporterViewController.h
//  mcr_s
//
//  Created by bipyun on 16/12/7.
//  Copyright © 2016年 match. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReporterViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UITableView *mainTab;
- (IBAction)reporterbutton:(id)sender;

@end
