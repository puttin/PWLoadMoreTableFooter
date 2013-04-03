//
//  DEMOTableViewController.h
//  PWLoadMoreTableFooter
//
//  Created by Puttin Wong on 3/31/13.
//  Copyright (c) 2013 Puttin Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWLoadMoreTableFooterView.h"
@interface DEMOTableViewController : UITableViewController <PWLoadMoreTableFooterDelegate> {
    PWLoadMoreTableFooterView *_loadMoreFooterView;
	BOOL _loadingMore;
    bool _allLoaded;
}

@end
