//
//  ViewController.m
//  LMNoteDemo
//
//  Created by littleMeaning on 2018/7/2.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "FolderViewController.h"

@import LMNote;

@interface FolderViewController ()

@property (nonatomic, strong, readwrite) LMNFolder *folder;

@end

@implementation FolderViewController

- (instancetype)init
{
    return [self initWithFolder:nil];
}

- (instancetype)initWithFolder:(LMNFolder *)folder
{
    self = [super init];
    if (self) {
        self.folder = folder ?: [LMNStore shared].rootFolder;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *itemAdd = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"baritem_folder"] style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    UIBarButtonItem *itemEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(edit)];
    self.navigationItem.rightBarButtonItems = @[itemEdit, itemAdd];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeChanged:) name:LMNStoreDidChangedNotification object:nil];
}

- (void)add
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"创建目录" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        NSString *name = alert.textFields.firstObject.text;
        LMNFolder *folder = [[LMNFolder alloc] initWithUUID:[NSUUID UUID] name:name date:[NSDate date]];
        [self.folder add:folder];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:confirm];
    [alert addAction:cancel];
    [alert addTextFieldWithConfigurationHandler:nil];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)edit
{
    LMNDraft *draft = [[LMNDraft alloc] initWithUUID:[NSUUID UUID] name:@"" date:[NSDate date]];
    draft.parent = self.folder;
    LMNoteViewController *vc = [[LMNoteViewController alloc] initWithDraft:draft];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)storeChanged:(NSNotification *)notification
{
    [[LMNStore shared] reload];
    self.folder = [LMNStore shared].rootFolder;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.folder.contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LMNItem *item = self.folder.contents[indexPath.row];
    UITableViewCell *cell;
    if ([item isKindOfClass:[LMNFolder class]]) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = item.name;
    }
    else if ([item isKindOfClass:[LMNDraft class]]) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.text = item.name;
        cell.detailTextLabel.text = item.date.description;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMNItem *item = self.folder.contents[indexPath.row];
    if ([item isKindOfClass:[LMNFolder class]]) {
        FolderViewController *vc = [[FolderViewController alloc] initWithFolder:(LMNFolder *)item];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([item isKindOfClass:[LMNDraft class]]) {
        LMNoteViewController *vc = [[LMNoteViewController alloc] initWithDraft:(LMNDraft *)item];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
 
@end
