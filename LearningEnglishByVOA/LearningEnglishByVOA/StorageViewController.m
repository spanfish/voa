//
//  StorageViewController.m
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/19.
//  Copyright © 2017 Xiangwei Wang. All rights reserved.
//

#import "StorageViewController.h"
#import "SWRevealViewController.h"
#import "PathUtil.h"
#import "StorageTableViewCell.h"
#import "NSLayoutConstraint+Multiplier.h"
@interface Directory : NSObject
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *path;
@property(nonatomic, assign) unsigned long long totalSize;
@property(nonatomic, assign) unsigned long long totalfiles;
@property(nonatomic, assign) BOOL calculating;

-(instancetype) initWithTitle:(NSString *) title path:(NSString *) path;
@end

@implementation Directory
-(instancetype) initWithTitle:(NSString *) title path:(NSString *) path {
    self = [super init];
    if(self) {
        self.title = title;
        self.path = path;
        self.totalSize = 0;
        self.totalfiles = 0;
        self.calculating = YES;
    }
    return self;
}
@end

@interface StorageViewController () {
    //dispatch_queue_t queue;
    BOOL stop;
    NSMutableArray *directoryArray;
}

@end

@implementation StorageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Storage";
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController ) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];

        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    directoryArray = [NSMutableArray arrayWithObjects:
                      [[Directory alloc] initWithTitle:@"English in a Minute" path:[PathUtil englishInAMinutePath]],
                      [[Directory alloc] initWithTitle:@"English @ the Movies" path:[PathUtil englishInMoviePath]], nil];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tableView reloadData];
    
    for (Directory *dir in directoryArray) {
        dir.calculating = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self calculateSizeOfDirectory: dir];
        });
    }
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    stop = YES;
}

-(void) calculateSizeOfDirectory:(Directory *) directory {
    NSLog(@"directory.path:%@", directory.path);
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:directory.path error: nil];
    NSLog(@"attributesOfFileSystemForPath:%@, %@", directory.path, dictionary);
    
    NSArray *filesArray = [fm subpathsOfDirectoryAtPath:directory.path error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    
    while (fileName = [filesEnumerator nextObject]) {
        if(stop) {
            return;
        }
        NSDictionary *fileDictionary = [fm attributesOfItemAtPath:[directory.path stringByAppendingPathComponent:fileName] error:nil];
        NSLog(@"fileName:%@", fileDictionary);
        directory.totalSize += [fileDictionary fileSize];
        directory.totalfiles += 1;
    }
    directory.calculating = NO;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadRowsAtIndexPaths:@[
                [NSIndexPath indexPathForRow:0 inSection:0],
                [NSIndexPath indexPathForRow:1 inSection:0],
                                                 ] withRowAnimation:UITableViewRowAnimationNone];
        
        StorageTableViewCell *cell = (StorageTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        
        long long freeSize = [[dictionary objectForKey:NSFileSystemFreeSize] longLongValue];
        long long systemSize = [[dictionary objectForKey:NSFileSystemSize] longLongValue];
        if(freeSize/1024.0/1024/1024 > 1) {
            cell.freeLabel.text = [NSString stringWithFormat:@"%.2f GB free", freeSize/1024.0/1024/1024];
        } else if(freeSize/1024.0/1024 > 1) {
            cell.freeLabel.text = [NSString stringWithFormat:@"%.2f MB free", freeSize/1024.0/1024];
        } else if(freeSize/1024.0 > 1) {
            cell.freeLabel.text = [NSString stringWithFormat:@"%.2f KB free", freeSize/1024.0];
        } else {
            cell.freeLabel.text = [NSString stringWithFormat:@"%lld Bytes free", freeSize];
        }

        [cell.widthRatioConstraint updateMultiplier:(CGFloat)freeSize/(systemSize-freeSize)];
    });
}

-(void) dealloc {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [directoryArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == [directoryArray count]) {
        //TotalCell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TotalCell" forIndexPath:indexPath];
        UISlider *slider = [cell viewWithTag:1];
        if(slider) {
            UIImage* minTrack = [UIImage imageNamed:@"minimum"];
            minTrack = [minTrack resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [slider setMinimumTrackImage:minTrack forState:UIControlStateNormal];
            
            UIImage* maxTrack = [UIImage imageNamed:@"maximum"];
            maxTrack = [maxTrack resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [slider setMaximumTrackImage:maxTrack forState:UIControlStateNormal];
        }
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SizeCell" forIndexPath:indexPath];
    
    Directory *dir = [directoryArray objectAtIndex:indexPath.row];
    cell.textLabel.text = dir.title;
    if(dir.calculating) {
        cell.detailTextLabel.text = @"Calculating...";
    } else {
        NSString *sizeStr = @"0 byte";
        if(dir.totalSize / 1024 / 1024 / 1024 >= 1) {
            sizeStr = [NSString stringWithFormat:@"%.2f G", (double)dir.totalSize / 1024 / 1024 / 1024];
        } else if(dir.totalSize / 1024 / 1024 >= 1) {
            sizeStr = [NSString stringWithFormat:@"%.2f MB", (double)dir.totalSize / 1024 / 1024];
        } else if(dir.totalSize / 1024 >= 1) {
            sizeStr = [NSString stringWithFormat:@"%.2f KB", (double)dir.totalSize / 1024];
        } else {
            sizeStr = [NSString stringWithFormat:@"%lld Bytes", dir.totalSize];
        }
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%lld Files, %@", dir.totalfiles, sizeStr];
    }
    
    return cell;
}

@end
