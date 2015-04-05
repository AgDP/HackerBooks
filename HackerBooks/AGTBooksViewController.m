//
//  AGTBooksViewController.m
//  HackerBooks
//
//  Created by Agustín on 01/04/2015.
//  Copyright (c) 2015 Agustin. All rights reserved.
//

#import "AGTBooksViewController.h"
#import "AGTSimplePDFViewController.h"
#import "Cons.h"

@interface AGTBooksViewController ()

@end

@implementation AGTBooksViewController

-(id) initWithModel:(AGTBook *) model{
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        _model = model;
        self.title = model.titulo;
        
    }
    
    return self;
}

#pragma mark - View Lifecycle

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Asegurarse de que no se ocupa toda la pantalla
    // cuando estás en un combinador
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if ([self.model.titulo length] == 0) {
        
        UIImage *yodaReading = [UIImage imageNamed:PORTADA_IMAGE];
        
        
        //Oculto todos los datos la primera vez solo la portada
        [self hiddenDataInView];

        
        
        self.photo.image = yodaReading;
        self.photo.contentMode = UIViewContentModeScaleToFill;
        

        
        [self showPortada];
        
        
        
    }else{
    
        // Sincronizar modelo -> vista
        
        self.photo.image = self.model.image;
        self.authors.text = self.model.authorInString;
        self.tags.text = self.model.tagsInString;
        
        //Muestro los campos
        
        [self showDataInView];
        
        
        
        //Detectamos el tipo de pantalla
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
            [self.authors setFont:[UIFont fontWithName:@"Arial" size:10]];
            [self.tags setFont:[UIFont fontWithName:@"Arial" size:10]];
            
        }
    
        [self hiddenPortada];
    
    
    
        if (self.model.isFavorite) {
            UIImage *butYe = [[UIImage imageNamed:IMAGE_STAR_YELLOW] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [self.favorite setImage:butYe forState:UIControlStateNormal];
        }else{
            //Añado la imagen al boton
            UIImage *butBla = [[UIImage imageNamed:IMAGE_STAR_BLACK] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [self.favorite setImage:butBla forState:UIControlStateNormal];
        }
        
    }

    
    //Si estoy dentro de un SpliVC me pongo el botón
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    NSLog(@"Paso");
}

-(void) dealloc{

    NSLog(@"Paso");
}

#pragma mark - UISplitViewControllerDelegate

-(void) splitViewController:(UISplitViewController *) svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode{
    
    
    //Averiguar si la tabla se ve o no
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        
        //La tabla  está oculta y cuelga del botón
        //Ponemos ese boton en mi barra de navegación
        
        self.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
    }else{
        //Se muestra la tabla: oculto el botón de la barra de navegación
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    
}

-(void) libraryTableViewController:(AGTLibraryTableViewController *)library didSelectedBook:(AGTBook *)book{
    
    //Actualizo el modelo
    self.model = book;
    
    //Muestro los campos
    [self showDataInView];
    
    //sync modelo y vista
    
    if (self.model.isFavorite) {
        UIImage *butYe = [[UIImage imageNamed:IMAGE_STAR_YELLOW] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.favorite setImage:butYe forState:UIControlStateNormal];
    }else{
        //Añado la imagen al boton
        UIImage *butBla = [[UIImage imageNamed:IMAGE_STAR_BLACK] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.favorite setImage:butBla forState:UIControlStateNormal];
    }

    [self hiddenPortada];
    
    self.photo.image = self.model.image;
    self.authors.text = self.model.authorInString;
    self.tags.text = self.model.tagsInString;
    
    //Actualizo el titulo del libro en el NavigationC
    self.title = self.model.titulo;
}


-(IBAction)displayPdf:(id)sender{

    // Crear un PDFVC
    AGTSimplePDFViewController *pdfVC = [[AGTSimplePDFViewController alloc]
                                  initWithModel:self.model];
    // Hacer un push
    [self.navigationController pushViewController:pdfVC
                                         animated:YES];
    
}

-(IBAction)markFavorite:(id)sender{
    
    // mandamos una notificacion
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    //Obtengo el modelo
    AGTBook *book = self.model;
    UIButton *button = (UIButton *)sender;
    
    if (!self.model.isFavorite) {
        UIImage *butYe = [[UIImage imageNamed:IMAGE_STAR_YELLOW] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [button setImage:butYe forState:UIControlStateNormal];
    }else{
        //Añado la imagen al boton
        UIImage *butBla = [[UIImage imageNamed:IMAGE_STAR_BLACK] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [button setImage:butBla forState:UIControlStateNormal];
    }
    
    
    NSDictionary *dict = @{NOTIFICATION_MARK_BOOK_FAVORITE_KEY : book};
    
    NSNotification *n = [NSNotification notificationWithName:NOTIFICATION_MARK_BOOK_FAVORITE_NAME object:self userInfo:dict];
    
    [nc postNotification:n];
    
    
    
    
    
    
    
}

//Muestro todos los campos para rellenarlos y mostrar los datos
-(void) hiddenPortada{
    
    NSMutableArray *allSubviews     = [[NSMutableArray alloc] initWithObjects: nil];
    NSMutableArray *currentSubviews = [[NSMutableArray alloc] initWithObjects: self.view, nil];
    NSMutableArray *newSubviews     = [[NSMutableArray alloc] initWithObjects: self.view, nil];
    
    while (newSubviews.count) {
        
        [newSubviews removeAllObjects];
        
        for (UIView *view in currentSubviews) {
            
            for (UIView *subview in view.subviews){
                [newSubviews addObject:subview];
                if (subview.tag == 1) {
                    [subview setHidden:FALSE];
                }
            }
            
        }
        
        [currentSubviews removeAllObjects];
        [currentSubviews addObjectsFromArray:newSubviews];
        [allSubviews addObjectsFromArray:newSubviews];
        
    }
    
    
}

//Oculto los datos para mostrar una foto de portada utilizando el UIIMAGE ya creado
-(void) showPortada{
    
    NSMutableArray *allSubviews     = [[NSMutableArray alloc] initWithObjects: nil];
    NSMutableArray *currentSubviews = [[NSMutableArray alloc] initWithObjects: self.view, nil];
    NSMutableArray *newSubviews     = [[NSMutableArray alloc] initWithObjects: self.view, nil];
    
    while (newSubviews.count) {
        
        [newSubviews removeAllObjects];
        
        for (UIView *view in currentSubviews) {
            
            for (UIView *subview in view.subviews){
                [newSubviews addObject:subview];
                if (subview.tag == 1) {
                    [subview setHidden:TRUE];
                }
                
            }
            
        }
        
        [currentSubviews removeAllObjects];
        [currentSubviews addObjectsFromArray:newSubviews];
        [allSubviews addObjectsFromArray:newSubviews];
        
    }
    
}

-(void) hiddenDataInView{
    
    [self.authors setHidden:TRUE];
    [self.tags setHidden:TRUE];
    [self.favorite setHidden:TRUE];
}

-(void) showDataInView{
    
    [self.authors setHidden:FALSE];
    [self.tags setHidden:FALSE];
    [self.favorite setHidden:FALSE];
}

@end
