//
//  AGTLibraryTableViewController.h
//  HackerBooks
//
//  Created by Agustín on 01/04/2015.
//  Copyright (c) 2015 Agustin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AGTLibrary;

#define FAVORITE_SECTION 0
#define TAGS_SECTION 1

@interface AGTLibraryTableViewController : UITableViewController

@property (strong, nonatomic) AGTLibrary *model;

-(id) initWithModel: (AGTLibrary *) model style: (UITableViewStyle) style;

@end
