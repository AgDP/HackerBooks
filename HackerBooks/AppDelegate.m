//
//  AppDelegate.m
//  HackerBooks
//
//  Created by Agustín on 01/04/2015.
//  Copyright (c) 2015 Agustin. All rights reserved.
//

#import "AppDelegate.h"
#import "AGTLibraryTableViewController.h"
#import "AGTLibrary.h"
#import "AGTBooksViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Creamos una vista de tipo UIWindow
    [self setWindow:[[UIWindow alloc]
                     initWithFrame:[[UIScreen mainScreen] bounds]]];
    
    //Creo el modelo
    AGTLibrary *library = [[AGTLibrary alloc] initWithArray];
    
    //Creo los Controladores
    AGTLibraryTableViewController *libraryTable = [[AGTLibraryTableViewController alloc] initWithModel:library style:UITableViewStylePlain];
    
    AGTBooksViewController *bookController = [[AGTBooksViewController alloc] initWithModel:[self lastSelectedBookInModel:library]];
    
    
    //Creo los navigationControllers
    UINavigationController *navLib = [UINavigationController new];
    
    [navLib pushViewController:libraryTable animated:NO];
    
    UINavigationController *navBook = [UINavigationController new];
    
    [navBook pushViewController:bookController animated:YES];
    
    
    //Creo el combinador
    UISplitViewController *split = [[UISplitViewController alloc] init];
    
    [split setViewControllers:@[navLib, navBook]];
    
    
    //Asignamos delegados
    split.delegate = bookController;
    libraryTable.delegate = bookController;
    
    //La pinto
    self.window.rootViewController = split;
    
    // La mostramos
    [[self window] makeKeyAndVisible];
    
    return YES;
}

-(AGTBook *) lastSelectedBookInModel: (AGTLibrary *) u{
    
    //Obtengo el NSUserDefaults
   /* NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    */
    //Saco las cordenadas del ultimo personaje
  /*  NSArray *coords = [def objectForKey:LAST_SELECTED_BOOK];
    NSUInteger section = [[coords objectAtIndex:0] integerValue];
    NSUInteger pos = [[coords objectAtIndex:1] integerValue];
  */
    
    
    //Obtengo el personaje
    AGTBook *book = [u bookTagAtIndex:0];
    /*if (section == FAVORITE_SECTION) {
        book = [u bookFavoriteAtIndex:pos];
    }else{
        book = [u bookTagAtIndex:pos];
    }*/
    
    
    //Lo devuelvo
    return book;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
