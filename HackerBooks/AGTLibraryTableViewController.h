//
//  AGTLibraryTableViewController.h
//  HackerBooks
//
//  Created by Agustín on 01/04/2015.
//  Copyright (c) 2015 Agustin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AGTBook;
@class AGTLibrary;
@class AGTLibraryTableViewController;

#define FAVORITE_SECTION 0
#define TAGS_SECTION 1

@protocol AGTLibraryTableViewControllerDelegate <NSObject>

@optional
-(void) libraryTableViewController: (AGTLibraryTableViewController *)library didSelectedBook:(AGTBook *) book;

@end

@interface AGTLibraryTableViewController : UITableViewController<AGTLibraryTableViewControllerDelegate>

@property (strong, nonatomic) AGTLibrary *model;
@property (weak, nonatomic) id<AGTLibraryTableViewControllerDelegate> delegate;

-(id) initWithModel: (AGTLibrary *) model style: (UITableViewStyle) style;

@end
