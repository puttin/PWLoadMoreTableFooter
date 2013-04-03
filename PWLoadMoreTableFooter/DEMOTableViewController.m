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
    _allLoaded = YES;       //suppose all loaded at first
    //Get the data first time
    cellCount = 1;          //load your data, here is only demo purpose
    if (cellCount < kMaxCellCount) {
        _allLoaded = NO;    //you know
    }
    //tell the load more view: I have load the data.
    [self doneLoadingTableViewData];
    //*****IMPORTANT*****
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(resetLoadMore)];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)doneLoadingTableViewData {
	
	//  model should call this when its done loading
	_loadingMore = NO;
	[_loadMoreFooterView pwLoadMoreTableDataSourceDidFinishedLoading];
    [self.tableView reloadData];
	
}

- (void)resetLoadMore {
    cellCount = 1;
    [self.tableView reloadData];
    //data source should call this when it can load more
    if (cellCount < kMaxCellCount) {
        _allLoaded = NO;
    }
    [_loadMoreFooterView resetLoadMore];
}

#pragma mark -
#pragma mark PWLoadMoreTableFooterDelegate Methods

- (void)pwLoadMore {
	_loadingMore = YES;
    ++cellCount;
    //when all items loaded, set this to YES;
    if (cellCount >= kMaxCellCount) {               // kMaxCellCount is only demo purpose
        _allLoaded = YES;
    }
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}


- (BOOL)pwLoadMoreTableDataSourceIsLoading {        //this method has no use right now.
    return _loadingMore;
}
- (BOOL)pwLoadMoreTableDataSourceAllLoaded {
    return _allLoaded;
}
@end
