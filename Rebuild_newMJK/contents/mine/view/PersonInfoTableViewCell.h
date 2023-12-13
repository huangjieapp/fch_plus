//
//  PersonInfoTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/10.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,textFieldType){
    textFieldTypeNormal=0,
    textFieldTypePhone,
    textFieldTypeEmail,
    
};

@interface PersonInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *myTextField;


@property(nonatomic,assign)NSInteger indexRow;
@property(nonatomic,copy)void(^changeTextFieldBlock)(NSString*textStr,NSInteger indexRow);
@property(nonatomic,assign)textFieldType type;


@end
