//
//  LMPhotoCollectionCell.h
//  SimpleWord
//
//  Created by littleMeaning on 16/5/16.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAsset;

@interface LMNPhotoCollectionCell : UICollectionViewCell

@property (nonatomic, copy) void (^handler)(PHAsset *asset);

- (void)setAsset:(PHAsset *)asset;
- (void)performSelectionAnimations;

@end
