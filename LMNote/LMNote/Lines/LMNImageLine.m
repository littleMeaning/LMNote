//
//  LMNImageLine.m
//  LMNote
//
//  Created by littleMeaning on 2018/7/9.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNImageLine.h"
#import "LMNImageView.h"
#import "LMNStore.h"
#import "UIImage+LMNStore.h"

@interface LMNImageLine ()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *imageFile;

@end

@implementation LMNImageLine

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.imageFile = [aDecoder decodeObjectForKey:@"imageFile"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    UIImage *image = self.bindingImageView.image;
    if (image) {
        if (!image.lmn_fileName) {
            NSData *imageData = UIImagePNGRepresentation(image);
            NSString *fileName = [NSUUID UUID].UUIDString;
            NSURL *fileURL = [[LMNStore shared].imageDirectory URLByAppendingPathComponent:fileName];
            [imageData writeToURL:fileURL atomically:YES];
            image.lmn_fileName = fileName;
        }
        [aCoder encodeObject:image.lmn_fileName forKey:@"imageFile"];
    }
}

- (void)bindImageView:(LMNImageView *)bindingImageView
{
    _bindingImageView = bindingImageView;
    bindingImageView.owner = self;
}

- (void)unbindImageView
{
    _bindingImageView.owner = nil;
    _bindingImageView = nil;
}

- (UIImage *)image
{
    if (!_image) {
        _image = self.bindingImageView.image;
    }
    if (!_image && self.imageFile != nil) {
        NSURL *fileURL = [[LMNStore shared].imageDirectory URLByAppendingPathComponent:self.imageFile];
        _image = [UIImage imageWithContentsOfFile:fileURL.path];
        _image.lmn_fileName = self.imageFile;
    }
    return _image;
}

@end
