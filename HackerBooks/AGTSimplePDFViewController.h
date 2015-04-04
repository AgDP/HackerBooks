//
//  AGTSimplePDFViewController.h
//  HackerBooks
//
//  Created by Agustín on 04/04/2015.
//  Copyright (c) 2015 Agustin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGTBook.h"

@interface AGTSimplePDFViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *browser;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityView;

@property (nonatomic, strong) AGTBook *model;

-(id) initWithModel:(AGTBook *) model;

@end
