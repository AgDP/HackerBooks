//
//  AGTBooksViewController.h
//  HackerBooks
//
//  Created by Agustín on 01/04/2015.
//  Copyright (c) 2015 Agustin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AGTBook;

@interface AGTBooksViewController : UIViewController<UISplitViewControllerDelegate>

@property (strong, nonatomic) AGTBook *model;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *authors;
@property (weak, nonatomic) IBOutlet UILabel *tags;

-(IBAction)displayPdf:(id)sender;

-(id) initWithModel:(AGTBook *) model;

@end
