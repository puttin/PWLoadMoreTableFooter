//
//  DEMOTableViewController.m
//  PWLoadMoreTableFooter
//
//  Created by Puttin Wong on 3/31/13.
//  Copyright (c) 2013 Puttin Wong. All rights reserved.
//

#import "DEMOTableViewController.h"
#define kMaxCellCount 2

@interface DEMOTableViewController ()

@end

@implementation DEMOTableViewController
{
    int cellCount;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //config the load more view
    if (_loadMoreFooterView == nil) {
		
		PWLoadMoreTableFooterView *view = [[PWLoadMoreTableFooterView alloc] init];
		view.delegate = self;
		_loadMoreFooterView = view;
		
	}
    self.tableView.tableFooterView = _loadMoreFooterView;
    
    //*****IMPORTANT*****
    //you need to do this when you first load your data
    //need to check whether the data has all loaded
    //Get the data first time
    cellCount = 1;          //load your data, here is only demo purpose
    [self check];
    //tell the load more view: I have load the data.
    [self doneLoadingTableViewData];
    //*****IMPORTANT*****
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return cellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %d",indexPath.row];
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)check {
    //data source should call this when it can load more
    //when all items loaded, set this to YES;
    if (cellCount >= kMaxCellCount) {               // kMaxCellCount is only demo purpose
        _allLoaded = YES;
    } else
        _allLoaded = NO;
}

- (void)doneLoadingTableViewData {
	//  model should call this when its done loading
	[_loadMoreFooterView pwLoadMoreTableDataSourceDidFinishedLoading];
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)demoOnly {
    _datasourceIsLoading = NO;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)refresh {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    _datasourceIsLoading = YES;
    cellCount = 1;
    [self.tableView reloadData];
    [self check];
    [_loadMoreFooterView resetLoadMore];
    
    //demo Only, fake it's still loading
    [self performSelector:@selector(demoOnly) withObject:nil afterDelay:5.0];
}

#pragma mark -
#pragma mark PWLoadMoreTableFooterDelegate Methods

- (void)pwLoadMore {
    //just make sure when loading more, DO NOT try to refresh your data
    //Especially when you do your work asynchronously
    //Unless you are pretty sure what you are doing
    //When you are refreshing your data, you will not be able to load more if you have pwLoadMoreTableDataSourceIsLoading and config it right
    //disable the navigationItem is only demo purpose
    self.navigationItem.rightBarButtonItem.enabled = NO;
    _datasourceIsLoading = YES;
    ++cellCount;
    [self check];
	_datasourceIsLoading = NO;
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}


- (BOOL)pwLoadMoreTableDataSourceIsLoading {
    return _datasourceIsLoading;
}
- (BOOL)pwLoadMoreTableDataSourceAllLoaded {
    return _allLoaded;
}
@end
