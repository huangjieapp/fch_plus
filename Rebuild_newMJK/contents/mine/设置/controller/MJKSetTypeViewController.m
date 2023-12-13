//
//  MJKSetTypeViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/26.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKSetTypeViewController.h"
#import "MJKSettingListTableViewCell.h"

#import "MJKSettingViewController.h"

@interface MJKSetTypeViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *exitButton;
@end

@implementation MJKSetTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	if (@available(iOS 11.0, *)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
    self.title = @"设置";
	self.view.backgroundColor = kBackgroundColor;
	[self.view addSubview:self.tableView];
	[self.view addSubview:self.exitButton];
    @weakify(self);
    if ([[NewUserSession instance].user.phonenumber isEqualToString:@"15979198580"]) {
        UIButton *delButton = [UIButton new];
        [self.view addSubview:delButton];
        [delButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.equalTo(self.exitButton.mas_top).offset(-15);
            make.height.mas_equalTo(45);
        }];
        delButton.backgroundColor = KNaviColor;
        [delButton setTitle:@"注销账号" forState:UIControlStateNormal];
        [[delButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"注销账号" message:@"你确实要注销账号,注销后不可恢复？" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction*action0=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction*action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [KUSERDEFAULT setObject:@"1" forKey:@"notLogin"];
                [NewUserSession cleanUser];
                
                /*EMError *error = [[EMClient sharedClient] logout:YES];
                 if (!error) {
                 NSLog(@"退出成功");
                 }*/
            }];
            [alertVC addAction:action1];
            [alertVC addAction:action0];
            
            
            [self presentViewController:alertVC animated:YES completion:nil];
        }];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKSettingListTableViewCell *cell = [MJKSettingListTableViewCell cellWithTableView:tableView];
	cell.handImageView.image = [UIImage imageNamed:@[@"个人设置",@"管理员设置"][indexPath.row]];
	cell.titleLabel.text = @[@"个人设置",@"管理员设置"][indexPath.row];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKSettingViewController *vc = [[MJKSettingViewController alloc]init];
//	vc.title = @[@"客户管理相关",@"订单管理相关",@"绩效管理相关",@"消息推送相关",@"硬件设备相关",@"账号安全相关"][indexPath.row];
	vc.title = @[@"个人设置",@"管理员设置"][indexPath.row];
	[self.navigationController pushViewController:vc animated:YES];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 点击事件
- (void)exitButtonAction:(UIButton *)sender {
	UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"退出账号" message:@"你确实要退出账号？" preferredStyle:UIAlertControllerStyleActionSheet];
	UIAlertAction*action0=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		
	}];
	UIAlertAction*action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
		[NewUserSession cleanUser];
		
		/*EMError *error = [[EMClient sharedClient] logout:YES];
		 if (!error) {
		 NSLog(@"退出成功");
		 }*/
	}];
	[alertVC addAction:action1];
	[alertVC addAction:action0];
	
	
	[self presentViewController:alertVC animated:YES completion:nil];
	
	
	
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - 50 - WD_TabBarHeight) style:UITableViewStyleGrouped];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.tableFooterView = [[UIView alloc]init];
	}
	return _tableView;
}

- (UIButton *)exitButton {
	if (!_exitButton) {
		_exitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame) + 5, KScreenWidth, 50)];
		[_exitButton setBackgroundColor:[UIColor redColor]];
		[_exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
		//        _exitButton.layer.cornerRadius = 5.0f;
		[_exitButton addTarget:self action:@selector(exitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	}
	return  _exitButton;
}

@end
