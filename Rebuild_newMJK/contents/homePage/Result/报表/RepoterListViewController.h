//
//  RepoterListViewController.h
//  mcr_s
//
//  Created by bipyun on 16/12/8.
//  Copyright © 2016年 match. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepoterListViewController : DBBaseViewController<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)NSString *type;


@property(nonatomic,strong)NSString *userid;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
