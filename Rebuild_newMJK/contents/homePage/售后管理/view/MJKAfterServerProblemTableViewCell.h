//
//  MJKAfterServerProblemTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/1/7.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKAfterServerProblemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mustLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameTitleLabel;
/** <#备注#>*/
@property (nonatomic, copy) void(^buttonActionBlock)(NSString *tagStr,NSInteger tag);
/** <#注释#>*/
@property (nonatomic, strong) NSArray *typeArr;
@property (nonatomic, strong) NSArray *glNameArray;
@property (nonatomic, strong) NSString *typeName;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
