//
//  JsonSelectViewController.m
//  TestInterface
//
//  Created by 杜洁鹏 on 14/02/2017.
//  Copyright © 2017 JYT. All rights reserved.
//

#import "JsonSelectViewController.h"
#import "Header.h"

@interface JsonSelectViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *datasource;
@end

@implementation JsonSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSArray *)loadAllDocumentFiles {
    NSMutableArray *ret = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *de = [fm enumeratorAtPath:DOCUMENTPATH];
    NSString *str = @"";
    while((str = [de nextObject])!=nil)
    {
        if ([[[str pathExtension] lowercaseString] isEqualToString:@"json"]) {
            if (!ret) {
                ret = [[NSMutableArray alloc] init];
            }
            [ret addObject:str];
        }
    }

    return ret;
}

- (NSArray *)datasource {
    if (!_datasource) {
        _datasource = [self loadAllDocumentFiles];
    }
    
    return _datasource;
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PathCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PathCell"];
    }
    cell.textLabel.text = self.datasource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didSelectedFilePath:[DOCUMENTPATH stringByAppendingString:self.datasource[indexPath.row]]];
    [self backAction:nil];
}
@end
