//
//  AGTLibraryTableViewController.m
//  HackerBooks
//
//  Created by Agustín on 01/04/2015.
//  Copyright (c) 2015 Agustin. All rights reserved.
//

#import "AGTLibraryTableViewController.h"
#import "AGTLibrary.h"
#import "AGTBooksViewController.h"

@interface AGTLibraryTableViewController ()

@end

@implementation AGTLibraryTableViewController

#pragma mark - Init
-(id) initWithModel: (AGTLibrary *) model style: (UITableViewStyle) style{
    
    if (self = [super initWithStyle:style]) {
        _model = model;
        self.title = @"Books";
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if (section == FAVORITE_SECTION) {
        return self.model.favoritesCount;
    }else{
        return self.model.tagsCount;
    }
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == FAVORITE_SECTION) {
        return @"Favorites";
    }else{
        return @"Tags";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AGTBook *book = nil;
    
    if (indexPath.section == FAVORITE_SECTION) {
        book = [self.model bookFavoriteAtIndex:indexPath.row];
    }else{
        book = [self.model bookTagAtIndex:indexPath.row];
    }
    
    //Crear una celda
    static NSString *cellId = @"BooksCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        //La tenemos que crear nosotros desde cero
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    //Configurarla
    //Sincronizar modelo (pj) con la vista (celda)
    cell.imageView.image = book.image;
    cell.textLabel.text = book.titulo;
//    cell.detailTextLabel.text = character.name;
    
    //Devolverla
    return cell;
}


#pragma mark - Delegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    AGTBook *book = nil;
    
    if (indexPath.section == FAVORITE_SECTION) {
        book = [self.model bookFavoriteAtIndex:indexPath.row];
    }else{
        book = [self.model bookTagAtIndex:indexPath.row];
    }
    
    //Avisar al delegado siempre y cuando entienda el mensaje
    if ([self.delegate respondsToSelector:@selector(libraryTableViewController:didSelectedBook:)])  {
        
        //te lo mando
        [self.delegate libraryTableViewController:self didSelectedBook:book];
    }

}

//Protocol
-(void) libraryTableViewController: (AGTLibraryTableViewController *)library didSelectedBook: (AGTBook *)book{
    
    //Creamos un book
    AGTBooksViewController *bookController = [[AGTBooksViewController alloc] initWithModel:book];
    
    //Hago un push
    [self.navigationController pushViewController:bookController animated:YES];
    
}

@end
