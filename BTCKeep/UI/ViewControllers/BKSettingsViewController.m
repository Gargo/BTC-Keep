//
//  BKSettingsViewController.m
//  BTC Keep
//
//  Created by Apple on 05.05.14.
//  
//

#import "BKSettingsViewController.h"

#import "BKSettingsCellKey.h"
#import "BKSettingsCellLink.h"
#import "BKSettingsCellTitle.h"
#import "BKSettingsCellDemoKey.h"

#import "BKNetworkManagerBox.h"
#import "BKNetworkManager.h"

#define BKCellIdentifierTitle   @"title"
#define BKCellIdentifierKey     @"key"
#define BKCellIdentifierLink    @"link"
#define BKCellIdentifierDemoKey @"demoKey"

#define BKExchangeKeyName       @"name"
#define BKExchangeKeyPublicKey  @"publicKey"
#define BKExchangeKeyPrivateKey @"privateKey"
#define BKExchangeKeyUseDemoKey @"useDemoKey"

@interface BKSettingsViewController ()

@end


@implementation BKSettingsViewController

@synthesize managers;

- (id)init {
    
    if ((self = [super init])) {
        
        [self defaultInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ((self = [super initWithCoder:aDecoder])) {
        
        [self defaultInit];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        
        [self defaultInit];
    }
    return self;
}

- (void)defaultInit {
    
    self.managers = [[BKNetworkManagerBox sharedInstance] managersForSettingsScreen];
}

#pragma mark - View controller lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self getLocalized];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.sections = [self getSections];
}

#pragma mark - Private methods

- (void)getLocalized {
    
    self.title = BKLocalizedString(@"Settings title");
}

- (NSArray *)getSections {
    
    NSMutableArray *sections = [NSMutableArray array];
    for (BKNetworkManager *oneManager in managers) {
        
        NSMutableArray *sectionObjects = [NSMutableArray array];
        [sectionObjects addObject:[AMBCellIdentifier identifierFromString:BKCellIdentifierTitle]];
        if ((oneManager.demoPublicKey.length > 0) || (oneManager.demoPrivateKey.length > 0)) {
            
            [sectionObjects addObject:[AMBCellIdentifier identifierFromString:BKCellIdentifierDemoKey]];
        }
        if (oneManager.publicKey) {
            
            [sectionObjects addObject:[AMBCellIdentifier identifierFromString:BKCellIdentifierKey]];
        }
        if (oneManager.privateKey) {
            
            [sectionObjects addObject:[AMBCellIdentifier identifierFromString:BKCellIdentifierKey]];
        }
        if ([oneManager linkToExchangeSettings]) {
            
            [sectionObjects addObject:[AMBCellIdentifier identifierFromString:BKCellIdentifierLink]];
        }
        if ([oneManager refLink]) {
            
            [sectionObjects addObject:[AMBCellIdentifier identifierFromString:BKCellIdentifierLink]];
        }
        AMBTableViewSection *tempSection = [AMBTableViewSection sectionWithObjects:sectionObjects
                                                                sectionUpdateBlock:^(AMBTableViewSection *section) {
                                                                    
                                                                    [section reloadObjectAtIndex:2];
                                                                    [section reloadObjectAtIndex:3];
                                                                    [section reloadObjectAtIndex:4];
                                                                } cellHeightBlock:^CGFloat(id object, NSIndexPath *indexPath) {
                                                                    
                                                                    return 44;
                                                                } cellIdentifierBlock:NULL
                                                            cellConfigurationBlock:^(id object, UITableViewCell *cell, NSIndexPath *indexPath) {
                                                                
                                                                NSUInteger cellIndex = [sectionObjects indexOfObject:object];
                                                                if ([cell isKindOfClass:[BKSettingsCellTitle class]]) {
                                                                    
                                                                    BKSettingsCellTitle *tempCell = (BKSettingsCellTitle *)cell;
                                                                    tempCell.lbl.text = [oneManager exchangeName];
                                                                } else if ([cell isKindOfClass:[BKSettingsCellKey class]]) {
                                                                    
                                                                    BKSettingsCellKey *tempCell = (BKSettingsCellKey *)cell;
                                                                    [tempCell setEnabled:!oneManager.useDemoKey];
                                                                    if (cellIndex == 2) {
                                                                        
                                                                        tempCell.lbl.text = BKLocalizedString(@"Public key");
                                                                        tempCell.txtField.text = oneManager.publicKey;
                                                                        tempCell.isPrivate = NO;
                                                                    } else {
                                                                        
                                                                        tempCell.lbl.text = BKLocalizedString(@"Private key");
                                                                        tempCell.txtField.text = oneManager.privateKey;
                                                                        tempCell.isPrivate = YES;
                                                                    }
                                                                } else if ([cell isKindOfClass:[BKSettingsCellDemoKey class]]) {
                                                                    
                                                                    BKSettingsCellDemoKey *tempCell = (BKSettingsCellDemoKey *)cell;
                                                                    tempCell.switchUseDemoKeys.on = oneManager.useDemoKey;
                                                                } else if ([cell isKindOfClass:[BKSettingsCellLink class]]) {
                                                                    
                                                                    BKSettingsCellLink *tempCell = (BKSettingsCellLink *)cell;
                                                                    if (cellIndex == 4) {
                                                                        
                                                                        [tempCell.btn setTitle:BKLocalizedString(@"Change settings on the website") forState:UIControlStateNormal];
                                                                        tempCell.urlString = [oneManager linkToExchangeSettings];
                                                                    } else {
                                                                        
                                                                        [tempCell.btn setTitle:BKLocalizedString(@"Register") forState:UIControlStateNormal];
                                                                        tempCell.urlString = [oneManager refLink];
                                                                    }
                                                                }
                                                            }];
        [tempSection setObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, sectionObjects.count)]
                                  hidden:NO];
        [sections addObject:tempSection];
    }
    return sections;
}

#pragma mark - methods for controls inside cells

- (IBAction)btnToggleClicked:(id)sender {
    
    BKSettingsCellTitle *tempCell = (BKSettingsCellTitle *)[BSUtilities parentCellForView:sender];
    NSInteger sectionIndex = [self.tableView indexPathForCell:tempCell].section;
    AMBTableViewSection *tempSection = self.sections[sectionIndex];
    [tempSection setObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, tempSection.objects.count - 1)]
                              hidden:(![tempSection isObjectAtIndexHidden:1] &&
                                      ![tempSection isObjectAtIndexHidden:2] &&
                                      ![tempSection isObjectAtIndexHidden:3] &&
                                      ![tempSection isObjectAtIndexHidden:4] && 
                                      ![tempSection isObjectAtIndexHidden:5])];
}

- (IBAction)switchKeysValueChanged:(id)sender {
    
    BKSettingsCellDemoKey *tempCell = (BKSettingsCellDemoKey *)[BSUtilities parentCellForView:sender];
    NSInteger sectionIndex = [self.tableView indexPathForCell:tempCell].section;
    BKNetworkManager *currentManager = managers[sectionIndex];
    
    UISwitch *sw = (UISwitch *)sender;
    currentManager.useDemoKey = sw.isOn;
    
    AMBTableViewSection *tempSection = self.sections[sectionIndex];
    for (int i = 0; i < tempSection.objects.count; i++) {
        
        AMBCellIdentifier *cellIdentifier = (AMBCellIdentifier *)tempSection.objects[i];
        if ([cellIdentifier.string isEqualToString:BKCellIdentifierKey]) {
            
            BKSettingsCellKey *keyCell = (BKSettingsCellKey *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:sectionIndex]];
            [keyCell setEnabled:!sw.isOn];
        }
    }
}

- (IBAction)txtFieldKeyEditingChanged:(id)sender {
    
    BKSettingsCellKey *tempCell = (BKSettingsCellKey *)[BSUtilities parentCellForView:sender];
    NSInteger sectionIndex = [self.tableView indexPathForCell:tempCell].section;
    BKNetworkManager *currentManager = managers[sectionIndex];
    
    if (tempCell.isPrivate) {
        
        currentManager.privateKey = tempCell.txtField.text;
    } else {
        
        currentManager.publicKey = tempCell.txtField.text;
    }
}

- (IBAction)btnLinkClicked:(id)sender {
    
    BKSettingsCellLink *tempCell = (BKSettingsCellLink *)[BSUtilities parentCellForView:sender];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tempCell.urlString]];
}

@end
