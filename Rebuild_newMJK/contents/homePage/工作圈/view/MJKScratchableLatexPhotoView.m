//
//  MJKScratchableLatexPhotoView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/27.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKScratchableLatexPhotoView.h"

#import "KSPhotoItem.h"
#import "KSPhotoBrowser.h"


@interface MJKScratchableLatexPhotoView ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
/** add button*/
@property (nonatomic, strong) UIButton *addButton;
/** image url*/
@property (nonatomic, strong) NSMutableArray *urlArray;
/** image url*/
@property (nonatomic, strong) NSMutableArray *addUrlArray;
/** image view array*/
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@end

@implementation MJKScratchableLatexPhotoView
- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self initUI:frame];
	}
	return self;
}

- (void)initUI:(CGRect )frame {
	CGFloat width = frame.size.width;
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 10, (width - 60) / 3, (width - 60) / 3)];
	self.addButton = button;
	[button setBackgroundImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(addImageAction:)];
	[self addSubview:button];
}

- (void)setImageURLArray:(NSArray *)imageURLArray {
	_imageURLArray = imageURLArray;
	[self.urlArray removeAllObjects];
	[self.addUrlArray removeAllObjects];
	
	[self.urlArray addObjectsFromArray:imageURLArray];
	//	NSString *str = @"http://7xt9pc.com1.z0.glb.clouddn.com/";//图片前缀
	[self.addUrlArray addObjectsFromArray:imageURLArray];
	for (UIImageView *imageView in self.imageViewArray) {
		[imageView removeFromSuperview];
	}
	[self.imageViewArray removeAllObjects];
	for (int i = 0; i < imageURLArray.count; i++) {
		UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20 + ((self.addButton.frame.size.width + 10) * (i % 3)) , 10 + (i / 3) * (self.addButton.frame.size.width + 10), self.addButton.frame.size.width, self.addButton.frame.size.height)];
//		[self.scrollView addSubview:imageView];
		[self addSubview:imageView];
		imageView.layer.cornerRadius = 5.f;
		imageView.layer.masksToBounds = YES;
		imageView.tag = i + 100;
		UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigImage:)];
		[imageView addGestureRecognizer:tapGR];
		if (imageURLArray.count > 0) {
			[imageView sd_setImageWithURL:[NSURL URLWithString:imageURLArray[i]]];
		}
		[self.imageViewArray addObject:imageView];
        
		UIButton *delButton = [[UIButton alloc]initWithFrame:CGRectMake(imageView.frame.size.width - 20, 0, 20, 20)];
		[imageView addSubview:delButton];
		imageView.userInteractionEnabled = YES;
		[delButton addTarget:self action:@selector(deleteImage:)];
		delButton.tag = i;
		[delButton setImage:@"icon_delete"];
//		delButton.hidden = YES;
//		if (self.isEdit == YES) {
//			delButton.hidden = NO;
//		}
		if (i == imageURLArray.count - 1 && imageURLArray.count != 9) {
			
			CGRect addFrame = self.addButton.frame;
			if ((i + 1) % 3 == 0) {
				addFrame.origin.x = 20;
				addFrame.origin.y = imageView.frame.origin.y + imageView.frame.size.height + 10;
			} else {
				addFrame.origin.x = imageView.frame.size.width + imageView.frame.origin.x + 10;
				addFrame.origin.y = imageView.frame.origin.y;
			}
			
			self.addButton.frame = addFrame;
			
			CGRect viewFrame = self.frame;
			viewFrame.size.height = self.addButton.frame.origin.y + self.addButton.frame.size.height + 10;
			self.frame = viewFrame;
		}
	}
//	CGRect addFrame = self.addButton.frame;
//	addFrame.origin.x = imageURLArray.count * (addFrame.size.width + 10 ) + 20;
//	self.addButton.frame = addFrame;
//	if (self.isEdit == YES) {
//		self.addButton.hidden = NO;
//		self.scrollView.contentSize = CGSizeMake(self.addButton.frame.origin.x + self.addButton.frame.size.width + 20, self.scrollView.frame.size.height);
//	} else {
//		self.addButton.hidden = YES;
//		self.scrollView.contentSize = CGSizeMake(self.addButton.frame.origin.x + 10, self.scrollView.frame.size.height);
//		self.addButton.hidden = YES;
//	}
	
	
    
	if (self.backUrlArray) {
		self.backUrlArray(self.addUrlArray, /*self.addUrlArray.count % 3 == 0 ? self.frame.size.height / 2 :*/ self.frame.size.height);
	}
}

- (void)deleteImage:(UIButton *)sender {
	[self.addUrlArray removeObjectAtIndex:sender.tag];
	[self.urlArray removeObjectAtIndex:sender.tag];
	self.imageURLArray = [self.urlArray copy];
}

- (void)showBigImage:(UITapGestureRecognizer *)sender {
	UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
	
	UIImageView *views = (UIImageView*) tap.view;
	NSMutableArray *arr = [NSMutableArray array];
	for (UIImageView *imageView in self.imageViewArray) {
		KSPhotoItem * item=[KSPhotoItem itemWithSourceView:imageView image:imageView.image];
		[arr addObject:item];
		
	}
	KSPhotoBrowser * browser=[KSPhotoBrowser browserWithPhotoItems:arr selectedIndex:views.tag - 100];
	
	
	[browser showFromViewController:self.rootVC];
	
}

- (void)addImageAction:(UIButton *)sender {
    if (self.urlArray.count == 9) {
        [JRToast showWithText:@"最多选择9张"];
        return;
    }
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
//	if (self.isCamera == NO) {
		[alertVC addAction:sanfdal];
//	}
	
	[alertVC addAction:manual];
	[alertVC addAction:cancel];
	[self.rootVC presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark -- 上传图片相关

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	
	NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
	
	
	//当选择的类型是图片
	if ([type isEqualToString:@"public.image"])
	{
		//先把图片转成NSData
		UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
		if (!image) {
			image=[info objectForKey:UIImagePickerControllerEditedImage];
		}
		//设置image的尺寸
		//        CGSize imagesize = image.size;
		//        imagesize.height =500;
		//        imagesize.width =500;
		//        //对图片大小进行压缩--
		//        image = [self imageWithImage:image scaledToSize:imagesize];
		NSData *imageData = UIImageJPEGRepresentation(image,0.1);
		image= [UIImage imageWithData:imageData];
		
		
		//		[self saveimg:image];
		[self uppicAction:imageData];
		
	}else{
		UIImage * image=[info objectForKey:UIImagePickerControllerEditedImage];
		if (!image) {
			image=[info objectForKey:UIImagePickerControllerOriginalImage];
		}
		//设置image的尺寸
		//        CGSize imagesize = image.size;
		//        imagesize.height =626;
		//        imagesize.width =413;
		//        //对图片大小进行压缩--
		//        image = [self imageWithImage:image scaledToSize:imagesize];
		NSData *imageData = UIImageJPEGRepresentation(image,0.1);
		image= [UIImage imageWithData:imageData];
		
		
		
		//		[self saveimg:image];
		[self uppicAction:imageData];
		
	}
	[picker dismissViewControllerAnimated:YES completion:nil];
	
	
}
////对图片尺寸进行压缩--
//-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
//{
//    // Create a graphics image context
//    UIGraphicsBeginImageContext(newSize);
//
//    // Tell the old image to draw in this new context, with the desired
//    // new size
//    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//
//    // Get the new image from the context
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    // End the context
//    UIGraphicsEndImageContext();
//
//    // Return the new image.
//    return newImage;
//}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	NSLog(@"您取消了选择图片");
	[picker dismissViewControllerAnimated:YES completion:nil];
}
//储存图像到本地
- (void)saveimg:(UIImage *) img
{
	NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	[formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss:SSS"];
	NSString *date =  [formatter stringFromDate:[NSDate date]];
	
	NSString *imgname =  [NSString stringWithFormat:@"/image%@.png",date];
	imgname = [imgname stringByReplacingOccurrencesOfString:@" " withString:@""];
	imgname = [imgname stringByReplacingOccurrencesOfString:@":" withString:@""];
	
	//这里将图片放在沙盒的documents文件夹中
	NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	//文件管理器
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	//把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
	[fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
	NSData *dataObj = UIImageJPEGRepresentation(img, 1.0);
	[fileManager createFileAtPath:[DocumentsPath stringByAppendingString:imgname] contents:dataObj attributes:nil];
	//得到选择后沙盒中图片的完整路径
	//	self.patchUrl = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,imgname];
	
}

-(void)uppicAction:(NSData *)data{
	DBSelf(weakSelf);
	
	
	//    NSData *data=[NSData dataWithContentsOfFile:self.patchUrl];
	NSString *urlStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ipImage"]];
	HttpManager *manager = [[HttpManager alloc]init];
	[manager postDataUpDataPhotoWithUrl:urlStr parameters:nil photo:data compliation:^(id data, NSError *error) {
		if ([data[@"code"] integerValue] == 200) {
			NSString * imgUrl = [data objectForKey:@"url"];//回传
			//			[self setPicBtn:imgUrl];
			[weakSelf.urlArray addObject:[data objectForKey:@"show_url"]];
			[weakSelf.addUrlArray addObject:imgUrl];
			weakSelf.imageURLArray = [weakSelf.urlArray copy];
		} else {
			[JRToast showWithText:data[@"message"]];
		}
	}];
	
}

- (NSMutableArray *)urlArray {
	if (!_urlArray) {
		_urlArray = [NSMutableArray array];
	}
	return _urlArray;
}

- (NSMutableArray *)addUrlArray {
	if (!_addUrlArray) {
		_addUrlArray = [NSMutableArray array];
	}
	return _addUrlArray;
}

- (NSMutableArray *)imageViewArray {
	if (!_imageViewArray) {
		_imageViewArray = [NSMutableArray array];
	}
	return _imageViewArray;
}
@end
