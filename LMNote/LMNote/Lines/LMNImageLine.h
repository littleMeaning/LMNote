//
//  LMNImageLine.h
//  LMNote
//
//  Created by littleMeaning on 2018/7/9.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNLine.h"

@interface LMNImageLine : LMNLine

@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, readonly) LMNImageView *bindingImageView;
- (void)bindImageView:(LMNImageView *)bindingImageView;
- (void)unbindImageView;

@end
