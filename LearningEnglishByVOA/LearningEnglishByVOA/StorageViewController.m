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
    dispatch_queue_t queue;
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
    queue = dispatch_queue_create("com.xiang.voa.storage", DISPATCH_QUEUE_CONCURRENT);
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tableView reloadData];
    
    for (Directory *dir in directoryArray) {
        dir.calculating = YES;
        dispatch_async(queue, ^{
            [self calculateSizeOfDirectory: dir];
        });
    }
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    stop = YES;
}

-(void) calculateSizeOfDirectory:(Directory *) directory {
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray *filesArray = [fm subpathsOfDirectoryAtPath:directory.path error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    
    while (fileName = [filesEnumerator nextObject]) {
        if(stop) {
            return;
        }
        NSDictionary *fileDictionary = [fm attributesOfItemAtPath:[directory.path stringByAppendingPathComponent:fileName] error:nil];
        directory.totalSize += [fileDictionary fileSize];
        directory.totalfiles += 1;
    }
    directory.calculating = NO;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
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
    return [directoryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
