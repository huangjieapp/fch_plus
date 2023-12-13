//
//  MJKUploadMemoView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/16.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKUploadMemoView.h"
#import "KSPhotoItem.h"
#import "KSPhotoBrowser.h"
#import "MJKPhotoView.h"

@interface MJKUploadMemoView ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate> {
	UIImagePickerController * imagePicker;
	UIImage *backImage;//赶回的图片
	UIView *memoView;
	NSString *textStr;
	NSInteger numberCount;//第几个图
}
@property (nonatomic, copy) void(^imageBlock)(UIImage *backImage);
@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, strong) NSMutableArray *imageArr;
/** 选择button的tag*/
@property(nonatomic,assign) NSInteger buttonTag;
@property(nonatomic,strong) NSMutableArray *buttonTagArray;
/** (MJKPhotoView *)tableFootPhoto*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;
/** image url array*/
@property (nonatomic, strong) NSArray *imageUrlArray;
@end


@implementation MJKUploadMemoView

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andSendMassage:(BOOL)isSend andRootVC:(UIViewController *)rootVC {
	if (self = [super initWithFrame:frame]) {
		self.rootVC = rootVC;
		[self initUIWithTitle:title andSendMassage:isSend];
	}
	return self;
}

- (void)initUIWithTitle:(NSString *)title andSendMassage:(BOOL)isSend {
	UIView *bgView = [[UIView alloc]initWithFrame:self.frame];
	bgView.backgroundColor = [UIColor blackColor];
	bgView.alpha = 0.5f;
	UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
	[bgView addGestureRecognizer:tapGR];
	[self addSubview:bgView];
	
	memoView = [[UIView alloc]initWithFrame:CGRectMake(5, (KScreenHeight - 300) / 2, KScreenWidth - 10, 300)];
	memoView.backgroundColor = [UIColor whiteColor];
	[self addSubview:memoView];
	memoView.layer.cornerRadius = 3.f;
	
	
	UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
//	titleView.backgroundColor = [UIColor lightGrayColor];
	[memoView addSubview:titleView];
	//短信
	UIButton *messgaeButton = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 5 - 10 - 30 , 0, 30, 30)];
	[messgaeButton setImage:@"发送短信"];
	[messgaeButton addTarget:self action:@selector(sendMessage:)];
	[titleView addSubview:messgaeButton];
	messgaeButton.hidden = isSend;
	//标题
	UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, memoView.frame.size.width, 30)];
	titleLabel.text = title;
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.font = [UIFont systemFontOfSize:14.f];
//	titleLabel.textColor = [UIColor grayColor];
	[titleView addSubview:titleLabel];
	
	//备注
	UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 30, memoView.frame.size.width-20, 70)];
	textView.delegate = self;
	textView.tag = 2000;
	textView.backgroundColor =kBackgroundColor;
	[memoView addSubview:textView];
	
	//上传图片
	UIView *imageLabelView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(textView.frame)+ 10, memoView.frame.size.width, 150)];
	[memoView addSubview:imageLabelView];
	
//	UILabel *imageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, imageLabelView.frame.size.width - 20, 20)];
//	imageLabel.text = @"上传图片";
//	imageLabel.font = [UIFont systemFontOfSize:14.f];
//	[imageLabelView addSubview:imageLabel];
	
	[imageLabelView addSubview:self.tableFootPhoto];
	
//	for (int i = 0; i < 3; i++) {
//		UIButton *imageButton = [[UIButton alloc]initWithFrame:CGRectMake(i * ((KScreenWidth - 30) / 3) + 10, CGRectGetMaxY(imageLabelView.frame) + 10, (KScreenWidth - 40) / 3, (KScreenWidth - 40) / 3)];
//		[imageButton setBackgroundImage:[UIImage imageNamed:@"7_03"] forState:UIControlStateNormal];
//		[imageButton addTarget:self action:@selector(addImage:)];
//		[memoView addSubview:imageButton];
//		[self.arr addObject:imageButton];
//		imageButton.tag = 100 + i;
//
//		UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(imageButton.frame.size.width - 22, 2, 20, 20)];
////        [deleteButton setTitleNormal:@"X"];
//        [deleteButton setImage:@"icon_delete"];
//		[deleteButton setTitleColor:[UIColor orangeColor]];
//		[deleteButton addTarget:self action:@selector(deleteButtonAction:)];
//		[imageButton addSubview:deleteButton];
//		deleteButton.tag = 200 + i;
//		if (imageButton.image == nil) {
//			deleteButton.hidden = YES;
//		}
//	}
	
	
	//操作按钮
	for (int i = 0; i < 2; i++) {
		UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * (memoView.frame.size.width / 2), memoView.frame.size.height - 40, memoView.frame.size.width / 2, 40)];
		if (i == 1) {
			button.backgroundColor = DBColor(255,195,0);
		}
		[button setTitleColor:[UIColor blackColor]];
		button.titleLabel.font = [UIFont systemFontOfSize:14.f];
		[button setTitleNormal:@[@"取消", @"提交"][i]];
		[button addTarget:self action:@selector(optionButtonAction:)];
		[memoView addSubview:button];
	}
	
}

- (MJKPhotoView *)tableFootPhoto {
	DBSelf(weakSelf);
	if (!_tableFootPhoto) {
		_tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, memoView.frame.size.width, 150)];
		_tableFootPhoto.isEdit = YES;
		_tableFootPhoto.isCamera = NO;
		_tableFootPhoto.rootVC = self.rootVC;
		_tableFootPhoto.backUrlArray = ^(NSArray *arr, NSArray *saveArr) {
			weakSelf.imageUrlArray = arr;
		};
	}
	return _tableFootPhoto;
}

- (void)sendMessage:(UIButton *)sender {
	if (self.messageButtonBloack) {
		self.messageButtonBloack(sender);
	}
	[self removeFromSuperview];
}

- (void)addImage:(UIButton *)sender {
	if (sender.isSelected == NO) {
        self.buttonTag = sender.tag;
		[self selectPhoto];
	} else {
		[self showBigImage:sender.imageView.image withBtn:sender];
	}
	
	UIButton *delButton = [memoView viewWithTag:sender.tag + 100];
	self.imageBlock = ^(UIImage *backImage) {
		delButton.hidden = NO;
		[sender setImage:backImage forState:UIControlStateNormal];
		sender.selected = YES;
	};
}

- (void)showBigImage:(UIImage *)image withBtn:(UIButton *)btn{
	
	KSPhotoItem * item=[KSPhotoItem itemWithSourceView:btn.imageView image:image];
	KSPhotoBrowser * browser=[KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
	
	
	[browser showFromViewController:self.rootVC];
}

//DBColor(255,195,0);
- (void)deleteButtonAction:(UIButton *)sender {
	NSLog(@"删除");
	UIButton *imageButton1 = [memoView viewWithTag:sender.tag - 100];
	sender.hidden = YES;
	[imageButton1 setImage:nil forState:UIControlStateNormal];
	imageButton1.selected = NO;
    [self.buttonTagArray enumerateObjectsUsingBlock:^(NSMutableDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger index = [obj[@"tag"] integerValue];
        if (sender.tag - 200 == index - 100) {
            [self.imageArr removeObject:obj[@"imageStr"]];
        }
    }];
	numberCount = sender.tag - 200;
}

- (void)optionButtonAction:(UIButton *)sender {
	if ([sender.titleLabel.text isEqualToString:@"取消"]) {
		[self removeFromSuperview];
	}
	if ([sender.titleLabel.text isEqualToString:@"提交"]) {
		if (self.commitButtonBloack) {
			self.commitButtonBloack(self.imageUrlArray, textStr);
		}
//		NSString *imageStr = [self.imageArr componentsJoinedByString:@","];
		
	}
}

- (void)closeView {
	[self removeFromSuperview];
}

- (void)selectPhoto {
	
	UIAlertController * alertVC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		
	}];
	
	
	
	UIAlertAction*sanfdal=[UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		
		
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.delegate = self;
		imagePicker.allowsEditing = NO;
		imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[self.rootVC presentViewController:imagePicker animated:YES completion:nil];
		
	}];
	UIAlertAction*manual=[UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		
		
		UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
		if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
		{
			UIImagePickerController *picker = [[UIImagePickerController alloc] init];
			picker.delegate = self;
			//设置拍照后的图片可被编辑
			picker.allowsEditing = NO;
			picker.sourceType = sourceType;
			[self.rootVC presentViewController:picker animated:YES completion:nil];
			
		}else
		{
			NSLog(@"模拟其中无法打开照相机,请在真机中使用");
		}
		
		
	}];
	
	[alertVC addAction:sanfdal];
	[alertVC addAction:manual];
	[alertVC addAction:cancel];
	[self.rootVC presentViewController:alertVC animated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
	textStr = textView.text;
}

#pragma mark - imagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
	
	[picker dismissViewControllerAnimated:YES completion:nil];
	//获取到的图片
	UIImage * image = [info valueForKey:UIImagePickerControllerOriginalImage];
//	_imageView.image = image;
	if (self.imageBlock) {
		self.imageBlock(image);
	}
	
	NSData *imageData = UIImageJPEGRepresentation(image,0.5);
	[self uppicAction:imageData];
}

-(void)uppicAction:(NSData *)data{
	
	
	DBSelf(weakSelf);
	//    NSData *data=[NSData dataWithContentsOfFile:self.patchUrl];
	NSString *urlStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ipImage"]];
	HttpManager *manager = [[HttpManager alloc]init];
	[manager postDataUpDataPhotoWithUrl:urlStr parameters:nil photo:data compliation:^(id data, NSError *error) {
		if ([data[@"code"] integerValue] == 200) {
			NSString * imgUrl = [data objectForKey:@"url"];//回传
//			[weakSelf.imageArr addObject:imgUrl];
//			[weakSelf.imageArr removeObjectAtIndex:numberCount];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"tag"] = [NSString stringWithFormat:@"%ld",weakSelf.buttonTag];
            dic[@"imageStr"] = imgUrl;
            [weakSelf.buttonTagArray addObject:dic];
			[weakSelf.imageArr addObject:imgUrl];
		} else {
			[JRToast showWithText:data[@"message"]];
		}
	}];
	
}

- (void)setImageUrlArr:(NSArray *)imageUrlArr {
	_imageUrlArr = imageUrlArr;
	self.tableFootPhoto.imageURLArray = imageUrlArr;
	
	for (int i = 0; i < self.imageUrlArr.count; i++) {
		UIButton *button = self.arr[i];
//        UIImageView *imageView = [[UIImageView alloc]init];
        [button.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrlArr[i]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [button setImage:image forState:UIControlStateNormal];
        }];
        
        
//        [button setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrlArr[i]]]] forState:UIControlStateNormal];
		button.selected = YES;//当为yes那么就不能点击修改图片
		
		
		UIButton *delBtn = [memoView viewWithTag:button.tag + 100];
		delBtn.hidden = NO;
	}
	[self.imageArr addObjectsFromArray:self.imageUrlArr];
}

- (void)setRemark:(NSString *)remark {
	_remark = remark;
	UITextView *textView = [memoView viewWithTag:2000];
	textView.text = remark;
}

//- (void)HttpUpdataOrder:(NSString *)c_id andImageUrl:(NSArray *)urlStr andRemark:(NSString *)remark {
//	NSMutableDictionary*Updict = [DBObjectTools getAddressDicWithAction:@"A47300WebService-update"];
//	
//	NSMutableDictionary * dict=[NSMutableDictionary dictionary];
//	dict[@"C_ID"] = c_id;
//	if (remark.length > 0) {
//		dict[@"X_REMARK"] = remark;
//	}
//	if (urlStr.count > 0) {
//		dict[@"urlList"] = urlStr;
//	}
//	
//	
//	[Updict setObject:dict forKey:@"content"];
//	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:Updict withtype:@"1"];
//	DBSelf(weakSelf);
//	HttpManager*manager=[[HttpManager alloc]init];
//	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
//		MyLog(@"%@",data);
//		if ([data[@"code"] integerValue]==200) {
////			if (weakSelf. commitButtonBloack) {
////				weakSelf.commitButtonBloack();
////			}
//			[weakSelf removeFromSuperview];
//
//		}else{
//			[JRToast showWithText:data[@"message"]];
//		}
//		
//		
//	}];
//	
//	
//	
//}

- (NSMutableArray *)arr {
	if (!_arr) {
		_arr = [NSMutableArray array];
	}
	return _arr;
}

- (NSMutableArray *)imageArr {
	if (!_imageArr) {
		_imageArr = [NSMutableArray array];
	}
	return _imageArr;
}

- (NSMutableArray *)buttonTagArray {
    if (!_buttonTagArray) {
        _buttonTagArray = [NSMutableArray array];
    }
    return _buttonTagArray;
}

@end
