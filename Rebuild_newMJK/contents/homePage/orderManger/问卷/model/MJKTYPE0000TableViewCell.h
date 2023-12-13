//
//  MJKTYPE0000TableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/10/8.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKA808PojoListModel;
@class MJKA809PojoListModel;
@class MJKA810PojoListModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKTYPE0000TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** <#注释#>*/
@property (nonatomic, strong) MJKA808PojoListModel *a808Model;
/** <#注释#>*/
@property (nonatomic, strong) MJKA810PojoListModel *a810Model;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *a808Arr;
/** <#备注#>*/
@property (nonatomic, copy) void(^radioButtonBlock)(MJKA809PojoListModel *a809Model, NSArray *list, NSString *X_REMARK, NSString *I_TYPE);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)heightForModel:(MJKA808PojoListModel *)a808Model;
+ (CGFloat)heightForA810Model:(MJKA810PojoListModel *)a810Model;
@end

NS_ASSUME_NONNULL_END
