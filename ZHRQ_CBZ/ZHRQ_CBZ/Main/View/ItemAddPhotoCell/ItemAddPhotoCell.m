//
//  ItemAddPhotoCell.m
//  ZTXWYGL
//
//  Created by Mr Lai on 2017/6/19.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "ItemAddPhotoCell.h"
#import "ItemCell.h"
#import "PhotosNavigationController.h"

@interface ItemAddPhotoCell() <UICollectionViewDelegate, UICollectionViewDataSource, PhotosNavigationControllerDelegate, ItemCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *itemPhotoView;
@property (nonatomic, assign) CGFloat itemWH;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger lineSpacing;
@property (weak, nonatomic) IBOutlet UIButton *helpBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photosViewRightSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photosViewLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photosViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photosViewBottomSpace;
@end

@implementation ItemAddPhotoCell

- (NSMutableArray *)selectedPhotos
{
    if (_selectedPhotos == nil)
    {
        _selectedPhotos = [NSMutableArray array];
    }
    return _selectedPhotos;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupValue];
    [self setupUI];
    [self setupPhotoView];
}

- (void)setupValue {
    if (self.photoCount == 0) self.photoCount = 4;
}

- (void)setupUI {
    if (iPhone5) {
        self.photosViewRightSpace.constant = 15;
        self.photosViewLeftSpace.constant = 30;
    } else if (iPhone6) {
        self.photosViewRightSpace.constant = 60;
        self.photosViewLeftSpace.constant = 40;
    } else if (iPhone6P) {
        self.photosViewRightSpace.constant = 80;
        self.photosViewLeftSpace.constant = 50;
    }
    self.helpBtn.titleLabel.font = IconFont(15);
    [self.helpBtn setTitle:[NSString stringWithFormat:@"示例 %@", HelpIconUnicode] forState:UIControlStateNormal];
    self.helpBtn.hidden = YES;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.itemTitleLabel.text = title;
}

- (void)setHiddenHelpBtn:(BOOL)hiddenHelpBtn {
    _hiddenHelpBtn = hiddenHelpBtn;
    self.helpBtn.hidden = hiddenHelpBtn;
}

static NSString * const ID = @"ItemCell";

- (void)setupPhotoView {
    self.count = self.photoCount + 1;
    self.itemWH = 50;
    self.margin = (self.itemPhotoView.width  -  self.count * self.itemWH) / (self.count - 1);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.itemWH, self.itemWH);
    layout.minimumInteritemSpacing = self.margin;
    layout.minimumLineSpacing = self.lineSpacing = 10;
    
    [self.itemPhotoView setCollectionViewLayout:layout];
    self.itemPhotoView.backgroundColor = [UIColor whiteColor];
    self.itemPhotoView.scrollEnabled = NO;
    self.itemPhotoView.dataSource = self;
    self.itemPhotoView.delegate = self;
    [self.itemPhotoView registerClass:[ItemCell class] forCellWithReuseIdentifier:ID];
}

- (IBAction)helpBtnClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(itemAddPhotoCell:helpBtnDidClick:)]) {
        [self.delegate itemAddPhotoCell:self helpBtnDidClick:button];
    }
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.item == self.selectedPhotos.count) {
        cell.imageView.image = SetImage(@"itemAddCellimages.bundle/AlbumAddBtn");
        cell.closeBtn.hidden = YES;
    } else {
        cell.imageView.image = self.selectedPhotos[indexPath.item];
        cell.closeBtn.hidden = NO;
        cell.closeBtn.tag = indexPath.item;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(photosViewDidClick:)]) {
        [self.delegate photosViewDidClick:self];
    }
    if (indexPath.item != self.selectedPhotos.count) return;
    WeakSelf(weakSelf)
    if (self.selectedPhotos.count == self.photoCount) {
        [LaiMethod alertControllerWithTitle:nil message:[NSString stringWithFormat:@"你最多可上传%zd张图片", self.photoCount] defaultActionTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];

    } else {
        KNActionSheet *sheet = [[KNActionSheet alloc] initWithCancelTitle:@"取消" otherTitleArr:@[@"拍摄", @"从手机相册选择"] actionBlock:^(NSInteger buttonIndex) {
            switch (buttonIndex) {
                case 0:
                {
                    if ([LaiMethod isUserCameraPowerOpen] == NO) {
                        [LaiMethod openRootPowerWithTitle:@"设置相机权限" message:@"请开启相机权限后才能使用" actionTitle:@"前往设置"];
                        return;
                    }
                    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        [MBProgressHUD showError:@"暂不支持拍摄"];
                        return;
                    }
                    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
                    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
                    ipc.delegate = self;
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:ipc animated:YES completion:nil];
                }
                    break;
                case 1:
                {
                    if (indexPath.row == weakSelf.selectedPhotos.count) [weakSelf pickPhotoButtonClick:nil];
                }
                    break;
                default:
                    break;
            }
        }];
        [sheet show];
    }
}

// 相册代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [UIImage fixOrientation:info[UIImagePickerControllerOriginalImage]];
    [self.selectedPhotos addObject:[UIImage compressImageWithOriginalImage:image scale:0.01]];
    if ([self.delegate respondsToSelector:@selector(itemAddPhotoCell:selectedPhotos:)]) {
        [self.delegate itemAddPhotoCell:self selectedPhotos:self.selectedPhotos];
    }
    [self.itemPhotoView reloadData];
}
- (void)pickPhotoButtonClick:(UIButton *)sender {
    NSInteger maxCount = 0;
    if (_selectedPhotos.count == 0) {
        maxCount = self.photoCount;
    } else {
        maxCount = self.photoCount - self.selectedPhotos.count;
    }
    
    PhotosNavigationController *navigation = [[PhotosNavigationController alloc] initWithMaxImagesCount:maxCount delegate:self];
    
    // 你可以通过block或者代理，来得到用户选择的照片.
    [navigation setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
        for (UIImage *image in photos) {
            //如果返回的图片还是太大 可以这样压缩
            NSData *data = UIImageJPEGRepresentation(image, 0.5);
            NSData *oriData = UIImageJPEGRepresentation(image, 1);
            NSLog(@"%@, %@", [NSString getBytesFromDataLength:data.length], [NSString getBytesFromDataLength:oriData.length]);
        }
    }];
    
    
    // 在这里设置imagePickerVc的外观
    navigation.navigationBar.barTintColor = [UIColor whiteColor];
    [navigation.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    //     navigation.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // 设置是否可以选择视频/原图
    navigation.allowPickingVideo = NO;
    navigation.allowPickingOriginalPhoto = YES;
    [self.window.rootViewController presentViewController:navigation animated:YES completion:nil];
}

#pragma mark - 用户点击了取消
- (void)PhotosNavigationControllerDidCancel:(PhotosNavigationController *)picker {
    // NSLog(@"cancel");
}

/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)PhotosNavigationController:(PhotosNavigationController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets {
    if (photos.count == 0) return;
    [self.selectedPhotos addObjectsFromArray:photos];
    [self.itemPhotoView reloadData];
    if ([self.delegate respondsToSelector:@selector(itemAddPhotoCell:selectedPhotos:)]) {
        [self.delegate itemAddPhotoCell:self selectedPhotos:self.selectedPhotos];
    }
    [self cellHeightChangeWithphotoCount:self.selectedPhotos.count];
}

/// 用户选择好了视频
//- (void)PhotosNavigationController:(PhotosNavigationController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
//    [_selectedPhotos addObjectsFromArray:@[coverImage]];
//    [_collectionView reloadData];
//    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
//}

- (void)cellHeightChangeWithphotoCount:(NSInteger)photoCount {
    if (self.photoCount <= 5) return;
    NSInteger row = (photoCount + 1 > 5) ? 2 : 1;
    switch (row) {
        case 1:
            self.photosViewH.constant = 50;
            break;
        case 2:
            self.photosViewH.constant = 105 + self.margin;
            break;
        default:
            break;
    }
    self.height = self.photosViewH.constant + self.itemPhotoView.y + self.photosViewBottomSpace.constant;
    [self setNeedsLayout];
    [self setNeedsDisplay];
    if ([self.delegate respondsToSelector:@selector(didReloadTableView:)]) {
        [self.delegate didReloadTableView:self];
    }
}

#pragma mark - itemCell代理
- (void)itemCell:(ItemCell *)itemCell closeBtnDidClick:(UIButton *)button {
    if (self.selectedPhotos.count > 0) {
        [self.selectedPhotos removeObjectAtIndex:button.tag];
        [self.itemPhotoView reloadData];
        if ([self.delegate respondsToSelector:@selector(itemAddPhotoCell:selectedPhotos:)]) {
            [self.delegate itemAddPhotoCell:self selectedPhotos:self.selectedPhotos];
        }
        [self cellHeightChangeWithphotoCount:self.selectedPhotos.count];
    } else {
        [self.itemPhotoView reloadData];
    }
}

@end
