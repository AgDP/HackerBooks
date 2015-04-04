//
//  AGTBooksViewController.m
//  HackerBooks
//
//  Created by Agustín on 01/04/2015.
//  Copyright (c) 2015 Agustin. All rights reserved.
//

#import "AGTBooksViewController.h"
#import "AGTBook.h"
#import "AGTSimplePDFViewController.h"

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
        UIImage *yodaReading = [UIImage imageNamed:@"yodaReading.jpg"];
        
        
        //Oculto todos los datos la primera vez solo la portada
        [self.titulo setHidden:TRUE];
        [self.authors setHidden:TRUE];
        [self.tags setHidden:TRUE];
        [self.favorite setHidden:TRUE];
        
        self.photo.image = yodaReading;
        self.photo.contentMode = UIViewContentModeScaleToFill;
        
        CGRect frame = self.view.frame;
        frame.size = yodaReading.size;
        self.photo.frame = frame;
        
        self.photo.image = yodaReading;
        
    }else{
    
        //Muestro los campos
        [self.titulo setHidden:FALSE];
        [self.authors setHidden:FALSE];
        [self.tags setHidden:FALSE];
        [self.favorite setHidden:FALSE];
        
    //Cambiamos las fuentes y tamaños
    [self.titulo setFont:[UIFont fontWithName:@"Arial" size:50]];
    
    // Sincronizar modelo -> vista
    
    self.titulo.text = self.model.titulo;
    self.photo.image = self.model.image;
    self.authors.text = self.model.autores.description;
    self.tags.text = self.model.tags.description;
    
    if (self.model.isFavorite) {
        UIImage *butYe = [[UIImage imageNamed:@"starYe.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.favorite setImage:butYe forState:UIControlStateNormal];
    }else{
        //Añado la imagen al boton
        UIImage *butBla = [[UIImage imageNamed:@"starBla.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
    [self.titulo setHidden:FALSE];
    [self.authors setHidden:FALSE];
    [self.tags setHidden:FALSE];
    [self.favorite setHidden:FALSE];
    
    //Cambiamos las fuentes y tamaños
    [self.titulo setFont:[UIFont fontWithName:@"Arial" size:50]];
    
    //sync modelo y vista
    
    if (self.model.isFavorite) {
        UIImage *butYe = [[UIImage imageNamed:@"starYe.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.favorite setImage:butYe forState:UIControlStateNormal];
    }else{
        //Añado la imagen al boton
        UIImage *butBla = [[UIImage imageNamed:@"starBla.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.favorite setImage:butBla forState:UIControlStateNormal];
    }
    
    self.photo.image = self.model.image;
    self.photo.contentMode = UIViewContentModeScaleToFill;
    
    CGRect frame = self.view.frame;
    frame.size = self.model.image.size;
    self.photo.frame = frame;
    
    self.photo.image = self.model.image;
    
    self.titulo.text = self.model.titulo;
    //self.photo.image = self.model.image;
    self.authors.text = self.model.autores.description;
    self.tags.text = self.model.tags.description;
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
        UIImage *butYe = [[UIImage imageNamed:@"starYe.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [button setImage:butYe forState:UIControlStateNormal];
    }else{
        //Añado la imagen al boton
        UIImage *butBla = [[UIImage imageNamed:@"starBla.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [button setImage:butBla forState:UIControlStateNormal];
    }
    
    
    NSDictionary *dict = @{@"bookFavorite" : book};
    
    NSNotification *n = [NSNotification notificationWithName:@"favoriteChange" object:self userInfo:dict];
    
    [nc postNotification:n];
    
    
    
    
    
    
    
}

@end
