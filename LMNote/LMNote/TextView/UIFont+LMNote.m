//
//  UIFont+LMNote.m
//  SimpleWord
//
//  Created by littleMeaning on 16/6/30.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import "UIFont+LMNote.h"

@implementation UIFont (LMNote)

+ (instancetype)fontWithFontSize:(float)fontSize bold:(BOOL)bold italic:(BOOL)italic {
    
    UIFont *font = [UIFont fontWithName:@"PingFang SC" size:fontSize];
    UIFontDescriptor *existingDescriptor = [font fontDescriptor];
    UIFontDescriptorSymbolicTraits traits = existingDescriptor.symbolicTraits;
    if (bold) {
        traits |= UIFontDescriptorTraitBold;
    }
    if (italic) {
        traits |= UIFontDescriptorTraitItalic;
    }
    UIFontDescriptor *descriptor = [existingDescriptor fontDescriptorWithSymbolicTraits:traits];
    return [UIFont fontWithDescriptor:descriptor size:fontSize];
}

- (BOOL)bold {
    return self.fontDescriptor.symbolicTraits & UIFontDescriptorTraitBold;
}

- (BOOL)italic {
    return self.fontDescriptor.symbolicTraits & UIFontDescriptorTraitItalic;
}

- (float)fontSize {
    return [self.fontDescriptor.fontAttributes[@"NSFontSizeAttribute"] floatValue];
}

@end
