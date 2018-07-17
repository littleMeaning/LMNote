//
//  LMNImageInputViewController.m
//  LMNote
//
//  Created by littleMeaning on 2018/4/19.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNImageInputViewController.h"
#import "LMNPhotoCollectionCell.h"

@import Photos;

@interface LMNImageInputViewController () <UICollectionViewDataSource, UICollectionViewDelegate, PHPhotoLibraryChangeObserver, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) PHFetchResult *photosResult;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation LMNImageInputViewController

static NSString * kReuseIdentifier = @"photo";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self loadSubviews];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)loadSubviews
{
    self.headerImageView = ({
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lmn_tool_image"]];
        view.contentMode = UIViewContentModeCenter;
        view;
    });
    self.headerLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithWhite:0.1 alpha:1.f];
        label.font = [UIFont systemFontOfSize:15.f];
        label.text = @"照片";
        label;
    });
    self.closeButton = ({
        UIImage *image = [UIImage imageNamed:@"lmn_tool_close"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        button;
    });
    [self.closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    
    self.headerView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1.f];
        view;
    });
    [self.headerView addSubview:self.headerImageView];
    [self.headerView addSubview:self.headerLabel];
    [self.headerView addSubview:self.closeButton];
    [self.view addSubview:self.headerView];
    
    self.collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        view.backgroundColor = self.headerView.backgroundColor;
        view.dataSource = self;
        view.delegate = self;
        view;
    });
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[LMNPhotoCollectionCell class] forCellWithReuseIdentifier:kReuseIdentifier];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGRect rect = self.view.bounds;
    rect.size.height = 44.f;
    self.headerView.frame = rect;
    
    self.headerImageView.frame = CGRectMake(0, 0, 44.f, 44.f);
    self.headerLabel.frame = CGRectMake(44, 0, 100.f, 44.f);
    self.closeButton.frame = CGRectMake(CGRectGetWidth(self.headerView.bounds) - 52.f, 0, 44.f, 44.f);
    
    static CGFloat kSpacing = 2.f;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumLineSpacing = kSpacing;
    layout.minimumInteritemSpacing = kSpacing;
    CGFloat width = CGRectGetWidth(self.view.bounds) / 3.f - kSpacing;
    layout.itemSize = CGSizeMake(width, width);
    
    rect.origin.y = CGRectGetHeight(self.headerView.frame);
    rect.size.height = CGRectGetHeight(self.view.bounds) - rect.origin.y;
    self.collectionView.frame = rect;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.photosResult.count == 0) {
        [self fetchPhotos];
    }
    else {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.selectedIndexPath) {
        [self.collectionView deselectItemAtIndexPath:self.selectedIndexPath animated:NO];
        self.selectedIndexPath = nil;
    }
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)fetchPhotos {
    PHFetchOptions *nearestPhotosOptions = [[PHFetchOptions alloc] init];
    nearestPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    self.photosResult = [PHAsset fetchAssetsWithOptions:nearestPhotosOptions];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)reload {
    self.selectedIndexPath = nil;
    [self.collectionView reloadData];
}

- (void)close:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(lmn_imageInputClose:)]) {
        [self.delegate lmn_imageInputClose:self];
    }
}

#pragma mark - <PHPhotoLibraryChangeObserver>

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    [self fetchPhotos];
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LMNPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifier forIndexPath:indexPath];
    PHAsset *asset = self.photosResult[indexPath.item];
    [cell setAsset:asset];
    if (!cell.handler) {
        cell.handler = ^(PHAsset *asset) {
            [self.delegate lmn_imageInput:self didSelectPHAsset:asset];
        };
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndexPath == indexPath) {
        return;
    }
    if (self.selectedIndexPath) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:self.selectedIndexPath];
        [(LMNPhotoCollectionCell *)cell performSelectionAnimations];
    }
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [(LMNPhotoCollectionCell *)cell performSelectionAnimations];
    self.selectedIndexPath = indexPath;
}

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    CGSize targetSize = [UIScreen mainScreen].bounds.size;
    targetSize.width *= 2;
    targetSize.height = targetSize.width * originalImage.size.height / originalImage.size.width;
    
    UIGraphicsBeginImageContext(targetSize);
    [originalImage drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    __unused UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
