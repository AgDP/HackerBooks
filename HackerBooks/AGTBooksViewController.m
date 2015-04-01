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
    
    if (self = [super init]) {
        _model = model;
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
    self.title = self.model.titulo;
    self.photo.image = self.model.image;
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(IBAction)displayPdf:(id)sender{

    
}

@end
