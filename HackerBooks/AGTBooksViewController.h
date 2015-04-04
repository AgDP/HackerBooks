//
//  AGTBooksViewController.h
//  HackerBooks
//
//  Created by Agustín on 01/04/2015.
//  Copyright (c) 2015 Agustin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGTLibraryTableViewController.h"
#import "AGTBook.h"


@interface AGTBooksViewController : UIViewController<UISplitViewControllerDelegate, AGTLibraryTableViewControllerDelegate>

@property (strong, nonatomic) AGTBook *model;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *authors;
@property (weak, nonatomic) IBOutlet UILabel *tags;
@property (weak, nonatomic) IBOutlet UIButton *favorite;

-(IBAction)displayPdf:(id)sender;
-(IBAction)markFavorite:(id)sender;

-(id) initWithModel:(AGTBook *) model;

@end
