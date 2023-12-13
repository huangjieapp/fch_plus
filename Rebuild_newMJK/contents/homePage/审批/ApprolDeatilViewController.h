//
//  ApprolDeatilViewController.h
//  mcr_s
//
//  Created by bipyun on 16/6/7.
//  Copyright © 2016年 match. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDESegmentControl.h"

@class PDESegmentControl;

@interface ApprolDeatilViewController : DBBaseViewController
@property (strong, nonatomic) IBOutlet UITableView *mainTab;
@property(strong,nonatomic)NSArray *itemArr;
@property(nonatomic,assign)int SelectedIndex;
@property(nonatomic,assign)NSInteger Index;

@property(nonatomic,strong)NSString *typeID;
@property(nonatomic,strong)NSString *typeStr;
@property(nonatomic,strong)NSString *STATUS;

- (IBAction)shenqingButton:(id)sender;
- (IBAction)shenpiButotn:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;


@end
