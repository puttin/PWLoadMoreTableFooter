//
//  PWLoadMoreTableFooter.m
//  PWLoadMoreTableFooter
//
//  Created by Puttin Wong on 3/31/13.
//  Copyright (c) 2013 Puttin Wong. All rights reserved.
//

#import "PWLoadMoreTableFooterView.h"

@interface PWLoadMoreTableFooterView (Private)
- (void)setState:(PWLoadMoreState)aState;
@end

@implementation PWLoadMoreTableFooterView

@synthesize delegate=_delegate;

- (id)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44)]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
		UILabel *label = nil;
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:15.0f];
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(12, 12, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		
		[self setState:PWLoadMoreNormal];
    }
	
    return self;
	
}

- (void)setState:(PWLoadMoreState)aState{
	
	switch (aState) {
		case PWLoadMoreNormal:
            [self addTarget:self action:@selector(callDelegateToLoadMore) forControlEvents:UIControlEventTouchUpInside];
			_statusLabel.text = NSLocalizedString(@"Load More...", @"Load More items");
			[_activityView stopAnimating];
			
			break;
		case PWLoadMoreLoading:
            [self removeTarget:self action:@selector(callDelegateToLoadMore) forControlEvents:UIControlEventTouchUpInside];
			_statusLabel.text = NSLocalizedString(@"Loading...", @"Loading items");
			[_activityView startAnimating];
			
			break;
		case PWLoadMoreDone:
            [self removeTarget:self action:@selector(callDelegateToLoadMore) forControlEvents:UIControlEventTouchUpInside];
			_statusLabel.text = NSLocalizedString(@"No More", @"There is no more item");
			[_activityView stopAnimating];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}

- (void)pwLoadMoreTableDataSourceDidFinishedLoading {
	BOOL _allLoaded = NO;
    if ([_delegate respondsToSelector:@selector(pwLoadMoreTableDataSourceAllLoaded)]) {
        _allLoaded = [_delegate pwLoadMoreTableDataSourceAllLoaded];
    }
    if (_allLoaded) {
        [self setState:PWLoadMoreDone];
    } else {
        [self setState:PWLoadMoreNormal];
    }
}
- (void)resetLoadMore {
    [self setState:PWLoadMoreNormal];
}

- (void)noMore {
    [self setState:PWLoadMoreDone];
}

- (void)callDelegateToLoadMore {
    if (_state == PWLoadMoreNormal) {
        if ([_delegate respondsToSelector:@selector(pwLoadMore)]) {
            [_delegate pwLoadMore];
            [self setState:PWLoadMoreLoading];
        }
    } else {
        //Do nothing
    }
    
}

@end
