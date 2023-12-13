//
//  MJKGoodPaperInputTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/23.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKGoodPaperInputTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
/** <#备注#>*/
@property (nonatomic, copy) void(^textViewChangeBlock)(NSString *str);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
