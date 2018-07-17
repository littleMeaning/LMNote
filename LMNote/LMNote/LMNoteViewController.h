//
//  NoteViewController.h
//  LMNoteDemo
//
//  Created by littleMeaning on 2018/1/10.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMNDraft;

@interface LMNoteViewController : UIViewController

@property (nonatomic, readonly) LMNDraft *draft;

- (instancetype)initWithDraft:(LMNDraft *)draft;

@end
