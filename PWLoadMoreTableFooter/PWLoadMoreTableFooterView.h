//
//  PWLoadMoreTableFooter.h
//  PWLoadMoreTableFooter
//
//  Created by Puttin Wong on 3/31/13.
//  Copyright (c) 2013 Puttin Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
	PWLoadMoreNormal = 0,
    PWLoadMoreLoading,
    PWLoadMoreDone,
} PWLoadMoreState;


@protocol PWLoadMoreTableFooterDelegate;
@interface PWLoadMoreTableFooterView : UIControl {
    id __unsafe_unretained delegate;
	PWLoadMoreState _state;
    
	UILabel *_statusLabel;
	UIActivityIndicatorView *_activityView;
    
}
- (void)pwLoadMoreTableDataSourceDidFinishedLoading;
- (void)resetLoadMore;

@property(nonatomic,unsafe_unretained) id <PWLoadMoreTableFooterDelegate> delegate;
@end

@protocol PWLoadMoreTableFooterDelegate <NSObject>
@required
- (void)pwLoadMore;
- (BOOL)pwLoadMoreTableDataSourceAllLoaded;
@optional
- (BOOL)pwLoadMoreTableDataSourceIsLoading; //optional temporary
@end