//
//  ViewController.h
//  LMNoteDemo
//
//  Created by littleMeaning on 2018/7/2.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMNFolder;

@interface FolderViewController : UITableViewController

@property (nonatomic, strong, readonly) LMNFolder *folder;

@end
