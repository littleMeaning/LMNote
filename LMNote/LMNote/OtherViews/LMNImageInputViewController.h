//
//  LMNImageInputViewController.h
//  LMNote
//
//  Created by littleMeaning on 2018/4/19.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;

@class LMNImageInputViewController;

@protocol LMNImageInputViewControllerDelegate <NSObject>

- (void)lmn_imageInput:(LMNImageInputViewController *)viewController didSelectPHAsset:(PHAsset *)asset;
- (void)lmn_imageInputClose:(LMNImageInputViewController *)viewController;

@end

@interface LMNImageInputViewController : UIViewController

@property (nonatomic, weak) id<LMNImageInputViewControllerDelegate> delegate;

@end
