//
//  MJKTaskSignInView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/9.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKTaskSignInView.h"

#import "MJKPhotoView.h"

@interface MJKTaskSignInView ()
@property (weak, nonatomic) IBOutlet UIView *addImageView;
/** MJKPhotoView*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;
/** url*/
@property (nonatomic, strong) NSArray *urlList;
@end

@implementation MJKTaskSignInView

- (void)awakeFromNib {
	[super awakeFromNib];
}

- (void)createAddImageView {
	[self.addImageView addSubview:self.tableFootPhoto];
}

- (MJKPhotoView *)tableFootPhoto {
	DBSelf(weakSelf);
	if (!_tableFootPhoto) {
		_tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-20, 150)];
		_tableFootPhoto.isEdit = YES;
		_tableFootPhoto.isCamera = NO;
		_tableFootPhoto.rootVC = self.rootVC;
		_tableFootPhoto.backUrlArray = ^(NSArray *arr, NSArray *saveArr) {
			weakSelf.urlList = arr;
		};
	}
	return _tableFootPhoto;
}
- (IBAction)closeView:(id)sender {
	[self removeFromSuperview];
}
- (IBAction)confirmButtonAction:(id)sender {
	if (self.chooseBlock) {
		self.chooseBlock(self.urlList);
	}
}

- (void)setFrame:(CGRect)frame {
	frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
	[super setFrame:frame];
}

@end
