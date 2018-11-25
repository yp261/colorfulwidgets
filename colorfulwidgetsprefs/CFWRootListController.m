#include "CFWRootListController.h"
#include <spawn.h>
#import "libcolorpicker.h"
#import <UIKit/UIKit.h>

@implementation CFWRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"com.morwi.colorfulwidgetsprefs" target:self] retain];
	}
	return _specifiers;
}
	-(id)readPreferenceValue:(PSSpecifier*)specifier {
	NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]]];
	if (![prefs objectForKey:[specifier.properties objectForKey:@"key"]]) {
		return [specifier.properties objectForKey:@"default"];
	}
	return [prefs objectForKey:[specifier.properties objectForKey:@"key"]];
}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSMutableDictionary * prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]]];
	[prefs setObject:value forKey:[specifier.properties objectForKey:@"key"]];
	[prefs writeToFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]] atomically:YES];
	[super setPreferenceValue:value specifier:specifier];
}
-(void)colorPickerOne {
	NSMutableDictionary * preferences = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.morwi.colorfulwidgetsprefs.color.plist"];
	NSString * colorOne = [preferences objectForKey:@"kMainColor"];
	UIColor * initialColor = LCPParseColorString(colorOne, @"#2c3e50");
	PFColorAlert * alert = [PFColorAlert colorAlertWithStartColor:initialColor showAlpha:YES];

		[alert displayWithCompletion:^void (UIColor * pickedColor) {
			NSString * hexColor = [UIColor hexFromColor:pickedColor];
			hexColor = [hexColor stringByAppendingFormat:@":%f", pickedColor.alpha];
			[preferences setObject:hexColor forKey:@"kMainColor"];
			[preferences writeToFile:@"/var/mobile/Library/Preferences/com.morwi.colorfulwidgetsprefs.color.plist" atomically:YES];
		}];
}
-(void)colorPickerTwo {
	NSMutableDictionary * preferences = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.morwi.colorfulwidgetsprefs.color.plist"];
	NSString * colorTwo = [preferences objectForKey:@"mMainColor"];
	UIColor * initialColor = LCPParseColorString(colorTwo, @"#2c3e50");
	PFColorAlert * alert = [PFColorAlert colorAlertWithStartColor:initialColor showAlpha:YES];

		[alert displayWithCompletion:^void (UIColor * pickedColor) {
			NSString * hexColor = [UIColor hexFromColor:pickedColor];
			hexColor = [hexColor stringByAppendingFormat:@":%f", pickedColor.alpha];
			[preferences setObject:hexColor forKey:@"mMainColor"];
			[preferences writeToFile:@"/var/mobile/Library/Preferences/com.morwi.colorfulwidgetsprefs.color.plist" atomically:YES];
		}];
}
-(void)respring{
    pid_t pid;
    int status;
    const char* args[] = {"killall", "SpringBoard", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
    waitpid(pid, &status, WEXITED);
}
-(void)twitter {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/moraw_ski"] options:@{} completionHandler:nil];
}
-(void)twitter2 {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/the_casle"] options:@{} completionHandler:nil];
}
-(void)paypal {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=ZYGNDTNY4S3JS&source=url"] options:@{} completionHandler:nil];
}
@end
// vim:ft=objc
