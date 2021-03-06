//
//  AGTSimplePDFViewController.m
//  HackerBooks
//
//  Created by Agustín on 04/04/2015.
//  Copyright (c) 2015 Agustin. All rights reserved.
//

#import "AGTSimplePDFViewController.h"
#import "Cons.h"

@interface AGTSimplePDFViewController ()

@property (nonatomic) BOOL canLoad;
@end

@implementation AGTSimplePDFViewController


-(id) initWithModel:(AGTBook *) model{
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        
        _model = model;
        self.title = TITLE_PDF;
        _canLoad = YES;
    }
    
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Alta en notificación
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(notifyThatBookDidChange:)
               name:NOTIFICATION_SELECT_BOOK_LIBRARY_NAME
             object:nil];
  
    
    // Asegurarse de que no se ocupa toda la pantalla
    // cuando estás en un combinador
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    
    // sincronizar modelo -> vista
    [self syncModelWithView];

    
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // Asignar delegados
    self.browser.delegate = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    //Me doy de baja de las notificaciones
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
-(void) webViewDidFinishLoad:(UIWebView *)webView{
    
    // Para y oculto el activity
    [self.activityView stopAnimating];
    [self.activityView setHidden:YES];
    
    self.canLoad = NO;
    
}


-(void) notifyThatBookDidChange: (NSNotification *) notification{
    
    //Sacamos el personaje
    AGTBook *book = [notification.userInfo objectForKey:NOTIFICATION_SELECT_BOOK_LIBRARY_KEY];
    
    //Actualizamos el modelo
    self.model = book;
    
    //Sincronizamos modelo -> vista
    [self syncModelWithView];
}

-(void) syncModelWithView{
    self.canLoad = YES;
    
    [self.activityView setHidden:NO];
    [self.activityView startAnimating];
    
    [self.browser loadRequest:[NSURLRequest requestWithURL:self.model.pdf]];
}

@end
