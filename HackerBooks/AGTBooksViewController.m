//
//  AGTBooksViewController.m
//  HackerBooks
//
//  Created by Agustín on 01/04/2015.
//  Copyright (c) 2015 Agustin. All rights reserved.
//

#import "AGTBooksViewController.h"
#import "AGTBook.h"

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
    
    
    // Sincronizar modelo -> vista
    
    self.titulo.text = self.model.titulo;
    self.photo.image = self.model.image;
    self.authors.text = self.model.autores.description;
    self.tags.text = self.model.tags.description;
    
    
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
    
    //sync modelo y vista
    self.titulo.text = self.model.titulo;
    self.photo.image = self.model.image;
    self.authors.text = self.model.autores.description;
    self.tags.text = self.model.tags.description;
}


-(IBAction)displayPdf:(id)sender{

    
}

@end
