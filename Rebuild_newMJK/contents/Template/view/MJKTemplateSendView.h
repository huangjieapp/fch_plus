//
//  MJKTemplateSendView.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/19.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKTemplateSendView : UIView
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
/** save block*/
@property (nonatomic, copy) void(^saveBlock)(NSString *textStr);
@property (weak, nonatomic) IBOutlet UIButton *publicSendButton;
/** send Block*/
@property (nonatomic, copy) void(^sendBlock)(NSString *textStr);
@property (weak, nonatomic) IBOutlet UIButton *publicCancelButton;
@property (weak, nonatomic) IBOutlet UIView *publicSendView;
@property (weak, nonatomic) IBOutlet UIView *sendView;
@end

NS_ASSUME_NONNULL_END
